-- REPLACES the previous version of this file.
-- Path: ServerScriptService > Services (Folder) > RewardService
-- Type: ModuleScript

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TrashConfig = require(ReplicatedStorage.Shared.Config.TrashConfig)
local MiniGameConfig = require(ReplicatedStorage.Shared.Config.MiniGameConfig)
local BackpackConfig = require(ReplicatedStorage.Shared.Config.BackpackConfig)
local MutationConfig = require(ReplicatedStorage.Shared.Config.MutationConfig)

local RewardService = {}

local function rollWeightedTrash(zonePool, rareChanceMultiplier)
	-- Apply the multiplier only to non-Common entries so PERFECT feels special
	-- without needing a second weighted table.
	local totalWeight = 0
	local weights = {}

	for i, entry in ipairs(zonePool) do
		local weight = entry.Weight
		if entry.Rarity ~= "Common" then
			weight = weight * rareChanceMultiplier
		end
		weights[i] = weight
		totalWeight += weight
	end

	local roll = math.random() * totalWeight
	local cumulative = 0
	for i, entry in ipairs(zonePool) do
		cumulative += weights[i]
		if roll <= cumulative then
			return entry
		end
	end

	return zonePool[#zonePool] -- fallback, should not normally hit
end

-- Mutates playerData.Backpack.Items and playerData.Collection directly.
-- The tool multiplier is captured as server-owned metadata for the legacy sell
-- bonus; collection values contain only the base value and mutation multiplier.
-- Pet income is resolved from the current equipped team when the item is sold.
-- mutationId is a server-snapshotted property of the trash spot and is never
-- accepted from the client.
-- Returns: { grantedItems = {...}, newDiscoveries = {...}, backpackFull = bool }
function RewardService.GenerateAndApplyReward(
	playerData,
	zoneName,
	rating,
	spotRewardTierBonus,
	toolValueMultiplier,
	mutationId,
	toolBonusTrashChance
)
	local zonePool = TrashConfig.Zones[zoneName]
	if not zonePool then
		warn("RewardService: no trash pool configured for zone " .. tostring(zoneName))
		return { grantedItems = {}, newDiscoveries = {}, backpackFull = false }
	end

	local ratingConfig = MiniGameConfig.RatingRewards[rating]
	if not ratingConfig then
		warn("RewardService: unknown rating " .. tostring(rating))
		return { grantedItems = {}, newDiscoveries = {}, backpackFull = false }
	end

	toolValueMultiplier = math.max(1, tonumber(toolValueMultiplier) or 1)
	toolBonusTrashChance = math.clamp(tonumber(toolBonusTrashChance) or 0, 0, 1)
	local mutation = MutationConfig.Get(mutationId)
	local mutationValueMultiplier = math.max(1, tonumber(mutation.Multiplier) or 1)

	local quantity = math.random(ratingConfig.MinQty, ratingConfig.MaxQty)
	quantity += spotRewardTierBonus or 0
	local toolBonusGranted = toolBonusTrashChance > 0 and math.random() < toolBonusTrashChance
	if toolBonusGranted then quantity += 1 end

	local capacity = BackpackConfig.GetCapacity(playerData.Backpack.CapacityLevel)
	local grantedItems = {}
	local newDiscoveries = {}
	local backpackFull = false

	for _ = 1, quantity do
		if #playerData.Backpack.Items >= capacity then
			backpackFull = true
			break
		end

		local trashEntry = rollWeightedTrash(zonePool, ratingConfig.RareChanceMultiplier)
		-- Collection UI and stored items show only the base price plus mutation.
		-- Tool and pet income are resolved later when the item is sold.
		local finalValue = math.floor(trashEntry.Value * mutationValueMultiplier + 0.5)

		table.insert(playerData.Backpack.Items, {
			Id = trashEntry.Id,
			Rarity = trashEntry.Rarity,
			Value = finalValue,
			BaseValue = trashEntry.Value,
			Mutation = mutation.Id,
			MutationMultiplier = mutation.Multiplier,
			ToolMultiplier = toolValueMultiplier,
		})

		table.insert(grantedItems, {
			Id = trashEntry.Id,
			DisplayName = MutationConfig.ApplyToName(mutation.Id, trashEntry.DisplayName),
			BaseDisplayName = trashEntry.DisplayName,
			Rarity = trashEntry.Rarity,
			Value = finalValue,
			BaseValue = trashEntry.Value,
			Mutation = mutation.Id,
			MutationDisplayName = mutation.DisplayName,
			MutationMultiplier = mutation.Multiplier,
			ToolMultiplier = toolValueMultiplier,
		})

		if not playerData.Collection[trashEntry.Id] then
			playerData.Collection[trashEntry.Id] = true
			table.insert(newDiscoveries, trashEntry.Id)
		end
	end

	return {
		grantedItems = grantedItems,
		newDiscoveries = newDiscoveries,
		backpackFull = backpackFull,
		toolBonusGranted = toolBonusGranted,
	}
end

return RewardService
