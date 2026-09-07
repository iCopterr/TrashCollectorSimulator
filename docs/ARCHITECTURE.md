# Technical Architecture

## Runtime layers

The project follows four main layers:

1. **Shared configuration and utilities** in `ReplicatedStorage.Shared`.
2. **Server-authoritative services** in `ServerScriptService.Services`.
3. **Client controllers and UI modules** under `StarterPlayerScripts.ClientBootstrap`.
4. **Authored GUI/model instances** in `StarterGui`, `ReplicatedStorage`, and the generated `Workspace` folders.

`ServerScriptService.ServerBootstrap` wires services and remotes, loads player data, builds the world, and spawns gameplay objects. `StarterPlayer.StarterPlayerScripts.ClientBootstrap` initializes client controllers and UI.

## Shared configuration modules

Path prefix: `game.ReplicatedStorage.Shared.Config`

| Module | Owns |
|---|---|
| `PlayerDataTemplate` | Persistent schema and defaults |
| `ZoneConfig` | Ordered zones, internal keys, display names, layouts, gates, unlock prices, progression targets |
| `TrashConfig` | Trash item IDs, names, rarity, base values, weights per zone |
| `TrashSpotConfig` | Random spot counts, spacing, interaction distance, model size weights, miss cooldown |
| `MiniGameConfig` | Collection duration, skill-check timing, arcs, ratings, quantities |
| `BackpackConfig` | Capacity levels, costs, zone requirements |
| `SellAreaConfig` | One station per zone, placement, model, colors, subtitle, teleport offset |
| `PetConfig` | Pet definitions, egg pools/prices, rarity odds, equip slots, multiplier formulas |
| `EggMarketConfig` | Physical egg-market placement and prompt settings |
| `MutationConfig` | Mutation odds, multipliers, colors, roll order |
| `DiamondDropConfig` | Per-zone World ID, chance, amount, pity threshold |
| `ToolConfig` | Legacy tool upgrades and new crate-tool definitions/stats |
| `ToolCrateConfig` | Shared world crate price, odds, drops, open counts, animation, validation |
| `ToolGachaMarketConfig` | Zone-to-world mapping and physical tool-crate entrance placement |
| `TeleportWorldConfig` | World order and zone membership used by teleport UI |
| `UIAssetConfig` | Shared icon asset IDs |

Other shared contracts include `ReplicatedStorage.Shared.RemotesSetup` and `ReplicatedStorage.Shared.NumberFormat`.

## Server services

Path prefix: `game.ServerScriptService.Services`

| Service | Responsibility |
|---|---|
| `DataService` | Load, reconcile, save, and expose player data sessions |
| `TrashSpotSpawner` | Generate valid randomized spot positions |
| `TrashSpotService` | Own spot state, per-player sync, interaction validation, miss cooldown, rerolls |
| `MiniGameService` | Server-owned collection sessions and skill-check validation |
| `RewardService` | Roll/apply trash rewards and discoveries |
| `DiamondDropService` | Roll/apply world-specific Diamond drops and pity |
| `EconomyService` | Shared currency/economy helpers |
| `SellService` | Spawn sell stations and perform server-authoritative sell-all |
| `ZoneService` | Validate and purchase zone unlocks |
| `ZoneBarrierService` | Spawn physical gates and initiate unlock requests |
| `ZoneWorldService` | Generate ordered floors, walls, containment, terrain details, spawn placement |
| `EggMarketService` | Spawn physical egg markets and validated open requests |
| `PetHatchService` | Validate prices/counts/distance, roll pets, write inventory/discovery/hatch flags |
| `PetInventoryService` | Validate pet equip/unequip and calculate team multiplier |
| `ToolGachaMarketService` | Spawn per-zone entrances to the shared world crate |
| `ToolCrateService` | Validate Diamond spending/open counts, roll tools, write inventory/discovery |
| `ToolInventoryService` | Validate tool equip state and expose equipped stats |
| `ShopService` | Current shop purchase endpoints; inspect carefully because legacy and Robux UI work are in transition |
| `UpgradeService` | Legacy upgrade behavior retained for compatibility; not the intended long-term product design |
| `AdminCommandService` | Validated Studio/admin commands such as adding cash or world Diamonds |

## Client controllers

Path prefix: `game.StarterPlayer.StarterPlayerScripts.ClientBootstrap.Controllers`

- `DataController`: receives the server snapshot and publishes client data changes.
- `TrashSpotController`: renders player-specific trash models, prompts, auras, and zone ground dressing.
- `MiniGameController`: coordinates collection/skill-check UI and submission.
- `SellController`: handles sell result presentation.
- `ZoneController`: current-zone detection, announcements, unlocked-state behavior.
- `ZoneBarrierService`: client-side per-player barrier behavior; despite its name, this is a client controller.
- `TeleportController`: sends validated zone teleport requests and handles results.
- `EggController`: opens the requested zone egg UI and sends hatch requests.
- `ToolCrateController`: opens the shared world crate UI and sends crate requests.
- `ShopController`: shop UI interactions/results.
- `EffectsController`: reward and movement effects.
- `SprintController`: Shift-to-run behavior.
- `AdminCommandController`: local chat/admin command display.

## Client UI modules

Path prefix: `game.StarterPlayer.StarterPlayerScripts.ClientBootstrap.UI`

- `UITheme`: colors, styling, click sound, blur, responsive scales, modal transitions, number formatting.
- `HUD`: navigation, backpack, cash, World 1 Diamonds, current-zone announcement.
- `RewardBanner`, `DiscoveryUI`, `CollectionProgressUI`: coordinated collection feedback.
- `SkillCheckUI`: the single collection skill-check presentation.
- `ShopUI`, `TeleportUI`, `CollectionBookUI`, `EggShopUI`, `PetInventoryUI`, `ToolsInventoryUI`, `ToolCrateUI`, `SettingsMenuUI`: bind authored `StarterGui` templates to dynamic data and input.

## Remote contract

All remotes live below `game.ReplicatedStorage.Remotes` and are created/normalized through `RemotesSetup`.

| Folder | Remotes |
|---|---|
| `Player` | `DataUpdate`, `CommandResult` |
| `Trash` | `Interact`, `Cooldown`, `Sync`, `RequestSync` |
| `MiniGame` | `Start`, `SkillCheckStart`, `Submit`, `SkillCheckResult`, `Result` |
| `Sell` | `Result` |
| `Zone` | `Result`, `TeleportRequest`, `TeleportResult` |
| `Pet` | `OpenEggShop`, `PurchaseEgg`, `HatchResult`, `ToggleEquip`, `InventoryResult` |
| `Tool` | `OpenCrateShop`, `OpenCrate`, `CrateResult`, `ToggleEquip`, `InventoryResult` |
| `Shop` | `Purchase`, `Result` |

Never rename or move these without updating `RemotesSetup`, bootstrap wiring, the relevant controller/UI, and both sides of the contract.

## Major flows

### Collect

`TrashSpotController prompt` → `Trash.Interact` → `TrashSpotService validation` → `MiniGameService session` → client collection/skill-check UI → `MiniGame.Submit` → server validation → `RewardService` and `DiamondDropService` → `DataUpdate` + `MiniGame.Result` → reward/discovery/inventory effects. `RewardService` stores and reports the configured trash base value with only the rolled mutation bonus applied; it does not bake the pet multiplier into the backpack item.

### Sell

Server-created station prompt → `SellService` callback → resolve every item through `TrashConfig`, validate persisted mutation/tool metadata, read the current equipped pet-team multiplier, and calculate the authoritative sale value → clear sold items/add cash → `DataUpdate` + `Sell.Result` → cash flight/effects. Mutation and pet multipliers use `PetConfig.CombinePetAndMutation`; the current team is evaluated at sale time.

### Egg

Server-created zone egg prompt → `Pet.OpenEggShop` → `Pet.PurchaseEgg(zoneName, count)` → server validates unlock, distance, cash, allowed count, inventory → `PetHatchService` RNG/write → `DataUpdate` + `Pet.HatchResult` → hatch animation. New pets remain unequipped.

### Tool crate

Any World 1 crate entrance → `Tool.OpenCrateShop(worldId, crateId)` → `Tool.OpenCrate(worldId, count)` → validate shared crate and `Diamonds.World1` → roll/write tools → `DataUpdate` + `Tool.CrateResult`.

### Zone unlock

Barrier prompt → server callback → verify previous zone, previous-zone hatch flag, and cash → write `Zones[destination] = true` → update client → client disables collision only for that player.

### Teleport

Client selects a zone name → server verifies known zone, unlock state, cooldown, live character, and no active collection → server computes destination from `SellAreaConfig` and pivots the character in front of the sell station.

## Generated runtime folders

The following are generated/rebuilt from configs and templates:

- `Workspace.ZoneWorld`
- `Workspace.TrashSpots` and player-specific client trash folders
- `Workspace.SellStations`
- `Workspace.EggMarkets`
- `Workspace.ToolGachaMarkets`
- `Workspace.ZoneBarriers`

Templates are stored under:

- `ReplicatedStorage.TrashModels` using `<ZoneKey>_Small` and `<ZoneKey>_Medium`
- `ReplicatedStorage.SellStationModels` using the exact `SellAreaConfig.ModelName`

## Initialization order

The server builds the zone world first, explicitly spawns trash for every configured/bootstrapped zone, then spawns sell stations, egg markets, tool-crate entrances, and gates. When adding a zone, inspect `ServerBootstrap` for explicit spawn calls; config changes alone may not create trash spots.
