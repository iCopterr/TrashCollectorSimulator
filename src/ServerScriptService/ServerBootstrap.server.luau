-- REPLACES the previous version of this file.
-- Path: ServerScriptService > ServerBootstrap
-- Type: Script

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RemotesSetup = require(ReplicatedStorage.Shared.RemotesSetup)
local MiniGameConfig = require(ReplicatedStorage.Shared.Config.MiniGameConfig)
local ToolConfig = require(ReplicatedStorage.Shared.Config.ToolConfig)
local ToolCrateConfig = require(ReplicatedStorage.Shared.Config.ToolCrateConfig)
local ZoneConfig = require(ReplicatedStorage.Shared.Config.ZoneConfig)
local SellAreaConfig = require(ReplicatedStorage.Shared.Config.SellAreaConfig)

local DataService = require(ServerScriptService.Services.DataService)
local TrashSpotService = require(ServerScriptService.Services.TrashSpotService)
local MiniGameService = require(ServerScriptService.Services.MiniGameService)
local RewardService = require(ServerScriptService.Services.RewardService)
local DiamondDropService = require(ServerScriptService.Services.DiamondDropService)
local SellService = require(ServerScriptService.Services.SellService)
local EggMarketService = require(ServerScriptService.Services.EggMarketService)
local ToolGachaMarketService = require(ServerScriptService.Services.ToolGachaMarketService)
local ToolCrateService = require(ServerScriptService.Services.ToolCrateService)
local ToolInventoryService = require(ServerScriptService.Services.ToolInventoryService)
local AdminCommandService = require(ServerScriptService.Services.AdminCommandService)
local PetHatchService = require(ServerScriptService.Services.PetHatchService)
local PetInventoryService = require(ServerScriptService.Services.PetInventoryService)
local ShopService = require(ServerScriptService.Services.ShopService)
local ZoneService = require(ServerScriptService.Services.ZoneService)
local ZoneBarrierService = require(ServerScriptService.Services.ZoneBarrierService)
local ZoneWorldService = require(ServerScriptService.Services.ZoneWorldService)

local Remotes = RemotesSetup.Init()
local dataUpdateRemote = Remotes.Player.DataUpdate
local trashInteractRemote = Remotes.Trash.Interact
local trashCooldownRemote = Remotes.Trash.Cooldown
local trashSyncRemote = Remotes.Trash.Sync
local trashRequestSyncRemote = Remotes.Trash.RequestSync
local miniGameStartRemote = Remotes.MiniGame.Start
local skillCheckStartRemote = Remotes.MiniGame.SkillCheckStart
local miniGameSubmitRemote = Remotes.MiniGame.Submit
local skillCheckResultRemote = Remotes.MiniGame.SkillCheckResult
local miniGameResultRemote = Remotes.MiniGame.Result
local sellResultRemote = Remotes.Sell.Result
local eggOpenRemote = Remotes.Pet.OpenEggShop
local eggPurchaseRemote = Remotes.Pet.PurchaseEgg
local eggHatchResultRemote = Remotes.Pet.HatchResult
local petToggleEquipRemote = Remotes.Pet.ToggleEquip
local petInventoryResultRemote = Remotes.Pet.InventoryResult
local toolCrateOpenRemote = Remotes.Tool.OpenCrateShop
local toolCrateRequestRemote = Remotes.Tool.OpenCrate
local toolCrateResultRemote = Remotes.Tool.CrateResult
local toolToggleEquipRemote = Remotes.Tool.ToggleEquip
local toolInventoryResultRemote = Remotes.Tool.InventoryResult
local commandResultRemote = Remotes.Player.CommandResult
local shopPurchaseRemote = Remotes.Shop.Purchase
local shopResultRemote = Remotes.Shop.Result
local zoneResultRemote = Remotes.Zone.Result
local zoneTeleportRequestRemote = Remotes.Zone.TeleportRequest
local zoneTeleportResultRemote = Remotes.Zone.TeleportResult

local function pushDataUpdate(player)
	local data = DataService.GetData(player)
	if data then
		dataUpdateRemote:FireClient(player, data)
	end
end

local function getToolValueMultiplier(playerData)
	local toolIndex = ToolConfig.GetToolIndex(playerData.Equipment.Tool)
	local toolData = ToolConfig.Tools[toolIndex]
	return toolData and toolData.RewardValueMultiplier or 1.0
end

local function resolveCollectionResult(player, spotId, displayRating, rewardRating, mutationId)
	rewardRating = rewardRating or displayRating
	mutationId = mutationId or "None"

	if rewardRating == "MISS" then
		TrashSpotService.CompleteSpot(spotId, player, rewardRating)
		miniGameResultRemote:FireClient(player, {
			Success = true,
			Rating = displayRating,
			GrantedItems = {},
			NewDiscoveries = {},
			BackpackFull = false,
			MutationId = mutationId,
		})
		return
	end

	local playerData = DataService.GetData(player)
	if not playerData then
		TrashSpotService.ReleaseSpot(spotId, player)
		return
	end

	local zoneName = spotId:match("^(.-)_%d+$") or "Downtown"
	local equippedToolStats = ToolInventoryService.GetEquippedStats(playerData)
	local rewardResult = RewardService.GenerateAndApplyReward(
		playerData,
		zoneName,
		rewardRating,
		TrashSpotService.GetRewardTierBonus(spotId, player),
		getToolValueMultiplier(playerData),
		mutationId,
		equippedToolStats.BonusTrashChance
	)

	-- Exactly one Diamond roll per successful collection that granted trash.
	-- The client never submits chance, amount, zone, or world information.
	local diamondResult = {
		Dropped = false,
		Amount = 0,
		WorldId = nil,
		Guaranteed = false,
	}
	if #rewardResult.grantedItems > 0 then
		diamondResult = DiamondDropService.RollAndApply(playerData, zoneName)
	end

	TrashSpotService.CompleteSpot(spotId, player, rewardRating)
	pushDataUpdate(player)
	miniGameResultRemote:FireClient(player, {
		Success = true,
		Rating = displayRating,
		GrantedItems = rewardResult.grantedItems,
		NewDiscoveries = rewardResult.newDiscoveries,
		BackpackFull = rewardResult.backpackFull,
		MutationId = mutationId,
		DiamondAmount = diamondResult.Amount,
		DiamondWorldId = diamondResult.WorldId,
		DiamondGuaranteed = diamondResult.Guaranteed,
		ToolBonusGranted = rewardResult.toolBonusGranted == true,
	})
end

local function onPlayerAdded(player)
	DataService.LoadData(player)
	TrashSpotService.InitializePlayer(player)
	pushDataUpdate(player)
end

local function onPlayerRemoving(player)
	local sessionId = MiniGameService.GetActiveSessionId(player)
	if sessionId then
		-- Disconnecting mid-mini-game counts as an instant MISS, same as dying.
		MiniGameService.ForceComplete(sessionId, "MISS")
	end

	-- Safety net for any spot somehow still marked Locked by this player,
	-- and cleans up their per-spot state table entirely.
	TrashSpotService.HandlePlayerRemoving(player)
	PetHatchService.ClearPlayer(player)
	ToolCrateService.ClearPlayer(player)

	DataService.SaveData(player)
	DataService.RemoveSession(player)
end

-- Wire validated Trash Spot interactions to the server-generated mini-game challenge.
TrashSpotService.SetInteractCallback(function(player, spot, sessionId, miniGameType)
	local sessionData = MiniGameService.GetClientSessionData(sessionId)
	if not sessionData then
		TrashSpotService.ReleaseSpot(spot.Id, player)
		return
	end
	miniGameStartRemote:FireClient(player, sessionData)
end)

MiniGameService.SetSkillCheckStartCallback(function(player, session, skillCheckData)
	skillCheckStartRemote:FireClient(player, skillCheckData)
end)

MiniGameService.SetSkillCheckResultCallback(function(player, session, rating)
	skillCheckResultRemote:FireClient(player, {
		SessionId = session.SessionId,
		Rating = rating,
	})
end)

MiniGameService.SetCollectionCompleteCallback(function(player, session, rating)
	local rewardRating = rating == "MISS"
		and MiniGameConfig.SkillCheck.MissRewardRating
		or rating
	resolveCollectionResult(player, session.TrashSpotId, rating, rewardRating, session.MutationId)
end)

-- Feedback for interact attempts that were rejected server-side (backpack full,
-- already cooling down for this player, etc.) so the client isn't left guessing.
TrashSpotService.SetInteractRejectedCallback(function(player, reason)
	trashInteractRemote:FireClient(player, { Success = false, Reason = reason })
end)

-- Misses alone receive a three-second countdown. Successful collections are
-- replaced immediately through the randomized player-specific sync below.
TrashSpotService.SetPlayerCooldownCallback(function(player, spotId, hidden, durationSeconds)
	trashCooldownRemote:FireClient(player, {
		SpotId = spotId,
		Hidden = hidden,
		DurationSeconds = durationSeconds,
	})
end)

TrashSpotService.SetSpotSyncCallback(function(player, payload)
	trashSyncRemote:FireClient(player, payload)
end)

-- Prompts are client-local, but every requested spot ID, unlock, server-known
-- position, backpack limit, and active state is validated before collection.
trashInteractRemote.OnServerEvent:Connect(function(player, spotId)
	if type(spotId) ~= "string" then
		return
	end
	local sessionId, err = TrashSpotService.HandleInteract(player, spotId)
	if not sessionId then
		TrashSpotService.NotifyRejected(player, err)
	end
end)

trashRequestSyncRemote.OnServerEvent:Connect(function(player)
	if DataService.GetData(player) then
		TrashSpotService.SyncPlayer(player)
	end
end)

-- A session that was force-ended (player died, or disconnected - see onPlayerRemoving
-- above) resolves through this single path, same shape as a normal MISS result.
MiniGameService.SetForceEndCallback(function(player, session, forcedRating)
	TrashSpotService.CompleteSpot(session.TrashSpotId, player, forcedRating)

	miniGameResultRemote:FireClient(player, {
		Success = true,
		Rating = forcedRating,
		GrantedItems = {},
		NewDiscoveries = {},
		BackpackFull = false,
	})
end)

-- A skill-check action affects the eventual bonus; collection continues to its timer.
miniGameSubmitRemote.OnServerEvent:Connect(function(player, sessionId, actionData)
	if type(sessionId) ~= "string" then
		return
	end

	local outcome, err = MiniGameService.SubmitAction(player, sessionId, actionData)
	if not outcome then
		warn(("Skill check submit rejected for %s: %s"):format(player.Name, tostring(err)))
	end
end)

-- Sell Area triggers this directly via ProximityPrompt (no client-initiated remote needed -
-- the value is always computed server-side from playerData, never trusted from the client).
SellService.SetSellRequestedCallback(function(player)
	local playerData = DataService.GetData(player)
	if not playerData then
		return
	end

	local result = SellService.SellAll(playerData)

	if result.Success then
		pushDataUpdate(player)
	end

	sellResultRemote:FireClient(player, result)
end)

-- Opening still comes from the server-owned ProximityPrompt. The purchase remote
-- carries only the selected zone; price, distance, RNG, cash, and inventory are
-- all validated and mutated on the server before the client animates the result.
EggMarketService.SetOpenRequestedCallback(function(player, zoneName)
	local playerData = DataService.GetData(player)
	if playerData and playerData.Zones and playerData.Zones[zoneName] == true then
		eggOpenRemote:FireClient(player, zoneName)
	end
end)

ToolGachaMarketService.SetOpenRequestedCallback(function(player, zoneName, worldId, crateId)
	local playerData = DataService.GetData(player)
	local crate = ToolCrateConfig.GetCrate(worldId)
	if crate
		and crate.Id == crateId
		and playerData
		and playerData.Zones
		and playerData.Zones[zoneName] == true then
		-- Zone is intentionally omitted from the client state: every entrance in the
		-- same world opens this one shared crate page and Diamond wallet.
		toolCrateOpenRemote:FireClient(player, worldId, crate.Id)
	end
end)

toolCrateRequestRemote.OnServerEvent:Connect(function(player, worldId, openAmount)
	local playerData = DataService.GetData(player)
	if not playerData then
		toolCrateResultRemote:FireClient(player, {
			Success = false,
			Reason = "DataUnavailable",
			Message = "Your data is still loading. Try again in a moment.",
		})
		return
	end

	local result = ToolCrateService.Open(player, playerData, worldId, openAmount)
	if result.Success then pushDataUpdate(player) end
	toolCrateResultRemote:FireClient(player, result)
end)

eggPurchaseRemote.OnServerEvent:Connect(function(player, zoneName, hatchAmount)
	local playerData = DataService.GetData(player)
	if not playerData then
		eggHatchResultRemote:FireClient(player, {
			Success = false,
			Reason = "DataUnavailable",
			Message = "Your data is still loading. Try again in a moment.",
		})
		return
	end

	local result = PetHatchService.Purchase(player, playerData, zoneName, hatchAmount)
	if result.Success then
		pushDataUpdate(player)
	end
	eggHatchResultRemote:FireClient(player, result)
end)

local lastToolEquipRequestAt = setmetatable({}, { __mode = "k" })
toolToggleEquipRemote.OnServerEvent:Connect(function(player, toolUid, requestId)
	local function reply(result)
		result = type(result) == "table" and result or {
			Success = false,
			Reason = "UnknownError",
			Message = "Unable to update your tool. Please try again.",
		}
		result.RequestId = requestId
		toolInventoryResultRemote:FireClient(player, result)
	end

	if type(toolUid) ~= "string" then
		reply({ Success = false, Reason = "InvalidTool", Message = "That tool is not available." })
		return
	end

	local now = os.clock()
	if now - (lastToolEquipRequestAt[player] or 0) < 0.2 then
		reply({ Success = false, Reason = "RateLimited", Message = "Please wait a moment and try again." })
		return
	end
	lastToolEquipRequestAt[player] = now

	local playerData = DataService.GetData(player)
	local result = ToolInventoryService.ToggleEquip(playerData, toolUid)
	if result.Success then pushDataUpdate(player) end
	reply(result)
end)

local lastPetEquipRequestAt = setmetatable({}, { __mode = "k" })
petToggleEquipRemote.OnServerEvent:Connect(function(player, petUid, requestId)
	local function reply(result)
		result = type(result) == "table" and result or {
			Success = false,
			Code = "UnknownError",
			Message = "Unable to update pets. Please try again.",
		}
		result.RequestId = requestId
		petInventoryResultRemote:FireClient(player, result)
	end

	if type(petUid) ~= "string" then
		reply({
			Success = false,
			Code = "InvalidPet",
			Message = "That pet is not available.",
		})
		return
	end

	local now = os.clock()
	if now - (lastPetEquipRequestAt[player] or 0) < 0.2 then
		reply({
			Success = false,
			Code = "RateLimited",
			Message = "Please wait a moment and try again.",
		})
		return
	end
	lastPetEquipRequestAt[player] = now

	local playerData = DataService.GetData(player)
	local result = PetInventoryService.ToggleEquip(playerData, petUid)
	if result.Success then pushDataUpdate(player) end
	reply(result)
end)

-- Shop purchases (Tool / Backpack). itemType comes from the client but only ever
-- selects WHICH validated purchase path runs - it never carries a price or effect.
shopPurchaseRemote.OnServerEvent:Connect(function(player, itemType)
	if type(itemType) ~= "string" then
		return
	end

	local playerData = DataService.GetData(player)
	if not playerData then
		return
	end

	local result = ShopService.HandlePurchase(playerData, itemType)

	if result.Success then
		pushDataUpdate(player)
	end

	shopResultRemote:FireClient(player, result)
end)

-- Zone unlock gates trigger this directly via ProximityPrompt, same pattern as
-- Trash Spots and the Sell Area - no client-initiated remote needed for the request.
ZoneBarrierService.SetUnlockRequestedCallback(function(player, zoneName)
	local playerData = DataService.GetData(player)
	if not playerData then
		return
	end

	local result = ZoneService.PurchaseUnlock(playerData, zoneName)

	if result.Success then
		pushDataUpdate(player)
	end

	zoneResultRemote:FireClient(player, result)
end)

-- Zone-menu teleports are validated and performed by the server. The client only
-- chooses a zone name; it cannot supply a destination CFrame or bypass unlocks.
local lastZoneTeleportAt = setmetatable({}, { __mode = "k" })
zoneTeleportRequestRemote.OnServerEvent:Connect(function(player, zoneName)
	if type(zoneName) ~= "string" or not ZoneConfig.GetIndex(zoneName) then
		return
	end

	local now = os.clock()
	if now - (lastZoneTeleportAt[player] or 0) < 1 then
		zoneTeleportResultRemote:FireClient(player, {
			Success = false,
			Reason = "Teleport is cooling down",
		})
		return
	end

	local playerData = DataService.GetData(player)
	if not playerData or not playerData.Zones or playerData.Zones[zoneName] ~= true then
		zoneTeleportResultRemote:FireClient(player, {
			Success = false,
			Reason = "Unlock this zone first",
		})
		return
	end

	if MiniGameService.GetActiveSessionId(player) then
		zoneTeleportResultRemote:FireClient(player, {
			Success = false,
			Reason = "Finish collecting first",
		})
		return
	end

	local station = SellAreaConfig.GetStation(zoneName)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not station or not character or not humanoid or humanoid.Health <= 0 or not rootPart then
		zoneTeleportResultRemote:FireClient(player, {
			Success = false,
			Reason = "Unable to teleport right now",
		})
		return
	end

	lastZoneTeleportAt[player] = now
	local targetPosition = station.Position + SellAreaConfig.TeleportOffset
	local lookTarget = Vector3.new(station.Position.X, targetPosition.Y, station.Position.Z)
	character:PivotTo(CFrame.lookAt(targetPosition, lookTarget))

	zoneTeleportResultRemote:FireClient(player, {
		Success = true,
		ZoneName = zoneName,
		Message = "Teleported to " .. ZoneConfig.GetDisplayName(zoneName),
	})
end)

AdminCommandService.Init(DataService, pushDataUpdate, commandResultRemote)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			DataService.SaveData(player)
		end)
	end
	task.wait(3)
end)

-- Build the ordered zone floors, borders, containment, and player spawn first so
-- every gameplay object is placed into the final straight-line map.
ZoneWorldService.Build()

-- All zones' Trash Spots spawn immediately at server start (matching the hard-gate
-- design: later zones physically exist and are visible from a distance, just
-- blocked by the barrier until unlocked - not lazily created on unlock).
TrashSpotService.SpawnZone("Downtown")
TrashSpotService.SpawnZone("Beach")
TrashSpotService.SpawnZone("Factory")
TrashSpotService.SpawnZone("Junkyard")
TrashSpotService.SpawnZone("Sewers")
TrashSpotService.SpawnZone("FrostbiteHarbor")
TrashSpotService.SpawnZone("HauntedCarnival")
TrashSpotService.SpawnZone("ToxicSwamp")
TrashSpotService.SpawnZone("NuclearWasteland")
TrashSpotService.SpawnZone("WorldsEndLandfill")

SellService.SpawnSellArea()
EggMarketService.SpawnEggMarkets()
ToolGachaMarketService.SpawnMarkets()
ZoneBarrierService.SpawnGates()

print("[ServerBootstrap] Trash Collector Simulator server initialized.")
