-- Owns the sell area and performs server-authoritative backpack sales.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SellAreaConfig = require(ReplicatedStorage.Shared.Config.SellAreaConfig)
local UIAssetConfig = require(ReplicatedStorage.Shared.Config.UIAssetConfig)
local TrashConfig = require(ReplicatedStorage.Shared.Config.TrashConfig)
local MutationConfig = require(ReplicatedStorage.Shared.Config.MutationConfig)
local PetConfig = require(ReplicatedStorage.Shared.Config.PetConfig)
local ToolConfig = require(ReplicatedStorage.Shared.Config.ToolConfig)
local EconomyService = require(script.Parent.EconomyService)
local PetInventoryService = require(script.Parent.PetInventoryService)

local SellService = {}

local onSellRequested = nil

local function createSellBillboard(part, stationConfig)
	local accentColor = stationConfig.AccentColor or Color3.fromRGB(77, 214, 104)
	local accentDarkColor = stationConfig.AccentDarkColor or Color3.fromRGB(25, 159, 80)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "SellBillboard"
	billboard.Size = UDim2.fromOffset(340, 112)
	billboard.StudsOffset = Vector3.new(0, 3.7, 0)
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.MaxDistance = 32
	billboard.Parent = part

	local card = Instance.new("Frame")
	card.Name = "Card"
	card.Size = UDim2.new(1, -8, 1, -8)
	card.Position = UDim2.fromOffset(4, 4)
	card.BackgroundColor3 = accentColor
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 20)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(12, 27, 52)
	stroke.Thickness = 3
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Parent = card

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, accentColor),
		ColorSequenceKeypoint.new(1, accentDarkColor),
	})
	gradient.Rotation = 90
	gradient.Parent = card

	local icon = Instance.new("ImageLabel")
	icon.Name = "SellIcon"
	icon.Size = UDim2.fromOffset(82, 82)
	icon.Position = UDim2.fromOffset(10, 10)
	icon.BackgroundTransparency = 1
	icon.Image = UIAssetConfig.Get("SellRecycle")
	icon.ScaleType = Enum.ScaleType.Fit
	icon.ZIndex = 2
	icon.Parent = card

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -112, 0, 42)
	title.Position = UDim2.fromOffset(100, 8)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 27
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextStrokeColor3 = Color3.fromRGB(12, 27, 52)
	title.TextStrokeTransparency = 0
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "SELL TRASH"
	title.ZIndex = 2
	title.Parent = card

	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, -112, 0, 40)
	subtitle.Position = UDim2.fromOffset(100, 51)
	subtitle.BackgroundTransparency = 1
	subtitle.Font = Enum.Font.GothamBold
	subtitle.TextSize = 14
	subtitle.TextWrapped = true
	subtitle.TextYAlignment = Enum.TextYAlignment.Top
	subtitle.TextColor3 = Color3.fromRGB(12, 27, 52)
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.Text = stationConfig.Subtitle or "Turn items into cash"
	subtitle.ZIndex = 2
	subtitle.Parent = card

	return billboard
end

function SellService.SetSellRequestedCallback(callback)
	onSellRequested = callback
end

local function createSellStation(parent, stationConfig)
	local templatesFolder = ReplicatedStorage:FindFirstChild("SellStationModels")
	local template = templatesFolder and templatesFolder:FindFirstChild(stationConfig.ModelName)
	if not template or not template:IsA("Model") then
		warn(("SellService: missing model %s for %s"):format(
			tostring(stationConfig.ModelName),
			stationConfig.ZoneName
		))
		return nil
	end

	local model = template:Clone()
	model.Name = "SellArea_" .. stationConfig.ZoneName
	local mainBody = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	if not mainBody then
		model:Destroy()
		warn("SellService: station model has no BasePart for " .. stationConfig.ZoneName)
		return nil
	end
	model.PrimaryPart = mainBody

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = true
		end
	end
	mainBody.CanCollide = true

	local groundPosition = stationConfig.Position - Vector3.new(0, SellAreaConfig.Size.Y * 0.5, 0)
	local facingYawDegrees = stationConfig.FacingYawDegrees or 90
	model:PivotTo(
		CFrame.new(groundPosition)
			* CFrame.Angles(0, math.rad(facingYawDegrees), 0)
			* model:GetPivot()
	)
	model:SetAttribute("ZoneName", stationConfig.ZoneName)
	model:SetAttribute("StationModel", stationConfig.ModelName)
	model.Parent = parent

	local boundsCF, boundsSize = model:GetBoundingBox()

	local interactionAnchor = Instance.new("Part")
	interactionAnchor.Name = "SellInteraction"
	interactionAnchor.Anchored = true
	interactionAnchor.CanCollide = false
	interactionAnchor.CanTouch = false
	interactionAnchor.CanQuery = false
	interactionAnchor.CastShadow = false
	interactionAnchor.Transparency = 1
	interactionAnchor.Size = Vector3.new(2, 4, 2)
	interactionAnchor.Position = stationConfig.Position + Vector3.new(-4.2, 0, 0)
	interactionAnchor:SetAttribute("ZoneName", stationConfig.ZoneName)
	interactionAnchor.Parent = model

	local billboard = createSellBillboard(interactionAnchor, stationConfig)
	billboard.StudsOffsetWorldSpace = Vector3.new(
		0,
		boundsCF.Position.Y + boundsSize.Y * 0.5 - interactionAnchor.Position.Y + 1.25,
		0
	)

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "SellPrompt"
	prompt.ActionText = SellAreaConfig.PromptActionText
	prompt.ObjectText = stationConfig.ZoneName .. " " .. SellAreaConfig.PromptObjectText
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = SellAreaConfig.MaxActivationDistance
	prompt.RequiresLineOfSight = false
	prompt.Parent = interactionAnchor

	prompt.Triggered:Connect(function(player)
		if onSellRequested then
			onSellRequested(player)
		end
	end)

	return model
end

function SellService.SpawnSellArea()
	local oldFolder = Workspace:FindFirstChild("SellStations")
	if oldFolder then
		oldFolder:Destroy()
	end

	-- Remove the single-station version from older map revisions.
	local legacyStation = Workspace:FindFirstChild("SellArea")
	if legacyStation then
		legacyStation:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = "SellStations"
	folder.Parent = Workspace

	for _, stationConfig in ipairs(SellAreaConfig.Stations) do
		createSellStation(folder, stationConfig)
	end

	return folder
end

local function roundNonNegative(value)
	value = tonumber(value) or 0
	if value ~= value or value == math.huge or value == -math.huge then
		return 0
	end
	return math.max(0, math.floor(value + 0.5))
end

local trashDefinitionsById = {}
for _, zonePool in pairs(TrashConfig.Zones) do
	for _, trashEntry in ipairs(zonePool) do
		trashDefinitionsById[trashEntry.Id] = trashEntry
	end
end

local function getMutationMultiplier(item)
	local mutationId = type(item.Mutation) == "string" and item.Mutation or MutationConfig.NoneId
	local mutation = MutationConfig.Get(mutationId)
	return mutation and math.max(1, tonumber(mutation.Multiplier) or 1) or 1
end

local function getToolMultiplier(item)
	local storedMultiplier = tonumber(item.ToolMultiplier)
	if not storedMultiplier or storedMultiplier < 1 then
		return 1
	end

	for _, toolDefinition in ipairs(ToolConfig.Tools) do
		if storedMultiplier == toolDefinition.RewardValueMultiplier then
			return storedMultiplier
		end
	end

	-- Tool multipliers are persisted metadata, not a client-controlled price.
	-- Unknown values must not create an arbitrary cash multiplier.
	return 1
end

-- Resolve the base from the server config instead of trusting stored Value or
-- BaseValue. This keeps old entries valid while preventing malformed IDs from
-- minting arbitrary cash.
local function calculateItemSaleValue(item, currentPetMultiplier)
	if type(item) ~= "table" then
		return 0
	end

	local trashDefinition = trashDefinitionsById[item.Id]
	if not trashDefinition then
		return 0
	end

	local mutationMultiplier = getMutationMultiplier(item)
	local currentCombinedMultiplier = PetConfig.CombinePetAndMutation(
		currentPetMultiplier,
		mutationMultiplier
	)
	local toolMultiplier = getToolMultiplier(item)

	return roundNonNegative(
		trashDefinition.Value
			* toolMultiplier
			* currentCombinedMultiplier
	)
end

-- Mutates server-held data only; client-provided totals and multipliers are never trusted.
function SellService.SellAll(playerData)
	local items = playerData and playerData.Backpack and playerData.Backpack.Items
	if type(items) ~= "table" then
		return { Success = false, Reason = "Backpack unavailable", Total = 0, ItemCount = 0 }
	end

	local itemCount = #items
	if itemCount == 0 then
		return { Success = false, Reason = "Backpack is empty", Total = 0, ItemCount = 0 }
	end

	local currentPetMultiplier = PetInventoryService.GetEquippedMultiplier(playerData)
	local total = 0
	for _, item in ipairs(items) do
		total += calculateItemSaleValue(item, currentPetMultiplier)
	end

	table.clear(items)
	EconomyService.AddCash(playerData, total)

	return { Success = true, Total = total, ItemCount = itemCount }
end

return SellService
