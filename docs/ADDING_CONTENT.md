# Safe Content Extension Guide

## Adding a new zone

A zone is not complete until every relevant row below is handled.

### 1. Choose stable identity and progression

- Internal key with no spaces, for example `FrostbiteHarbor`.
- Display name, for example `Frostbite Harbor`.
- World membership and ordered index.
- Previous-zone requirement.
- Required previous-zone hatch flag.
- Unlock price and target time.
- Zone center, floor material/color, border color, gate positions.

Never use the display name as a persistent key.

### 2. Update all configuration sources

- `ZoneConfig.Order`
- `ZoneConfig.DisplayNames`
- `ZoneConfig.Layout`
- `ZoneConfig.Profiles`
- `ZoneConfig.Zones` (not needed for the starting zone)
- `PlayerDataTemplate.Zones`
- `TrashConfig.Zones`
- `PetConfig.Pets`
- `PetConfig.Eggs`
- `SellAreaConfig.Stations`
- `DiamondDropConfig.Zones`
- `TeleportWorldConfig.Worlds[world].Zones`
- `ToolGachaMarketConfig.ZoneWorldIds`
- `UITheme.ZoneColors`

Search for other explicit zone lists before assuming this list is exhaustive.

### 3. Update bootstrap/runtime creation

- Confirm `ServerBootstrap` spawns trash for the new zone.
- Extend `ZoneWorldService` terrain and wall style.
- Extend client `TrashSpotController.addZoneGroundDressing`.
- Confirm `ZoneBarrierService`, `SellService`, `EggMarketService`, and `ToolGachaMarketService` iterate the updated config.

### 4. Create exact model templates

```text
ReplicatedStorage.TrashModels.<ZoneKey>_Small
ReplicatedStorage.TrashModels.<ZoneKey>_Medium
ReplicatedStorage.SellStationModels.<SellAreaConfig.ModelName>
```

Every template must be a `Model`, contain at least one `BasePart`, have a correct `PrimaryPart`, be anchored as expected by the current clone/render code, and have a sensible pivot near its ground base. Small and medium must be different designs, not a simple scale change.

### 5. Add UI asset slots

- `TeleportUI.AssetSlots.ZoneButtons/<ZoneKey>`
- `CollectionMenu.AssetSlots.ZoneBanners/<ZoneKey>`
- `EggMenu.AssetSlots.EggImages/<ZoneKey or configured egg ID>`

If art is not ready, create a clearly marked empty placeholder slot with the exact final name. Do not use another zone's image as final art.

### 6. Validate

- Correct world/order/index/center.
- Eight trash definitions with stable unique IDs.
- Five pet definitions and one of each rarity.
- Egg references exactly those five pets.
- Pet multipliers do not exceed the zone profile cap.
- Unlock and egg pacing are coherent.
- Diamond World ID matches the zone's world.
- Both trash templates render and interact.
- Sell, egg, and tool-crate stations spawn in the correct zone.
- Gate blocks locked players and becomes non-collidable only for unlocked players.
- Teleport is grey/`???` while locked and works only after unlock.
- Collection tab cycles to the zone and shows correct totals.
- Old profiles receive `Zones[ZoneKey] = false` without a wipe.
- Rejoin persistence works.

## Adding trash

- Add a stable ID to the correct `TrashConfig.Zones[ZoneKey]` table.
- Set display name, rarity, value, and weight.
- Check uniqueness across the entire project.
- Verify discovery and locked collection cards.
- Verify reward banner, backpack, sell value, mutations, and comma formatting.
- Do not add trash as an entry in the Tools inventory.

## Adding a pet or egg

- Add the pet definition with stable ID, display name, zone, rarity, multiplier, and model name.
- Add the pet ID to exactly one intended egg pool unless cross-zone drops are explicitly designed.
- Ensure odds still resolve one pet for every configured rarity.
- Keep new hatches unequipped.
- Verify discovery silhouette, inventory card, full preview, sorting, equip limit, additive team multiplier, permanent hatch flag, and zone prerequisite.

## Adding a crate tool

- Add its definition to `ToolConfig.CrateTools` and `CrateToolOrder`.
- Add it to the correct `ToolCrateConfig.Crates[world].Drops`.
- Keep drop weights totaling exactly 100 and matching `RarityOdds`.
- Keep `WorldId` consistent.
- Define collection speed, bonus-trash chance, and mutation multiplier.
- Verify duplicate behavior, capacity, discovery, sorting, one-tool equip limit, server stats, and Diamond spending.

## Adding a world

- Add the world to `TeleportWorldConfig`.
- Add isolated `Diamonds[WorldId]` and `DiamondDropPity[WorldId]` defaults.
- Add a world crate to `ToolCrateConfig` and zone mapping to `ToolGachaMarketConfig`.
- Ensure World N Diamonds cannot be spent in another world.
- Add world/zone/egg/crate art slots.
- Define spawn/teleport behavior and world boundaries.
- Treat World 2 Solar System design as a separate planned feature, not an incidental zone patch.

## Adding a Robux product

- Design the Shop card/icon and dynamic text contract.
- Create the Roblox product/game-pass asset and record its ID in one authoritative commerce config.
- Handle ownership or `ProcessReceipt` on the server as appropriate.
- Make receipt processing idempotent.
- Never grant from a client button click alone.
- Define stacking, duration, rejoin behavior, and failure messaging.
- Test owned, unowned, pending, cancelled, failed, and duplicate-receipt paths.

## Editing a GUI safely

- Search code references to the node name.
- Preserve root/template/asset-slot names.
- Change `Position`, `Size`, anchors, image, or layout properties without replacing dynamic children unless necessary.
- Keep template instances hidden.
- Check desktop and narrow/mobile resolutions.
- Test opening, closing, repeated clicking, scroll bounds, blur, and menu exclusivity.
