# UI and Figma Contracts

## Design ownership split

Figma-exported PNGs should own:

- Decorative panel/background art
- Baked headings explicitly designed into the image (for example SHOP, PETS, Close, 1×, 3×)
- Stud/halftone textures, border treatment, and decorative icons

Roblox instances/scripts should own:

- Prices and currency icons that depend on product/currency
- Player counts, cash, backpack capacity, and Diamonds
- Item/pet/tool names and descriptions
- Rarity and multiplier/stats
- Progress bars and discovered totals
- Lock state, mystery text, silhouettes, owned/equipped state
- Dynamic category/zone content
- Click handling, scrolling, sorting, transitions, blur, and responsive scaling

Do not bake dynamic content into a PNG. Do not redraw baked image text with a duplicate Roblox `TextLabel`.

Normal HUD/menu values use `Theme.FormatNumber`, which delegates to `NumberFormat.Compact`: `K`, `M`, `B`, `T`, then higher suffixes. Values below `1,000` stay unshortened. Exact server/admin text may continue using `NumberFormat.Commas`.

### World cash leaderboard

```text
Workspace.LeaderboardFolder.Leaderboard
  Config
    Enabled
    StatName
    ReloadDelay
    DataStoreName
    MaxPlayers
  Board.SurfaceGui.ScrollingFrame
    UIListLayout
    Titles
      Rank
      Username
      Value
    Template
      Rank
      Username
      Value
```

`LeaderboardService` reuses this authored model and clones only `Template` rows marked with the `CashLeaderboardGenerated` attribute. It labels the columns RANK, PLAYER, and CASH; cash values use compact `$1.2B`-style formatting; and the top three rows receive gold, silver, and bronze text colors. Titles and rows share a centered 94%-width grid with 18% rank, 50% player, and 32% cash columns plus 12-pixel inter-column gaps. Player names align left, cash aligns right, fixed 26/28-pixel text prevents one short value from overpowering another, and long names truncate within their column. The original Workspace script remains disabled because it expects a descendant `Cash` value that this profile-based game does not create.

## Exact root contracts

These names are currently referenced by client code. Search references before changing any child; this list highlights the main contracts and is not a substitute for inspecting the live hierarchy.

### Navigation

```text
StarterGui.NavigationUI.NavigationRoot
  ShopToggle
  TeleportToggle
  CollectionToggle
  PetToggle
  ToolsToggle
```

### Player HUD

`StarterPlayer.StarterPlayerScripts.ClientBootstrap.UI.HUD` creates the runtime `PlayerGui.HUD` tree. `PlayerGui.HUD.ActiveBuffs` is a transparent, enlarged cluster anchored to the bottom-right safe area and is separate from `PlayerStats`. Its bottom/right position compensates for `UIScale`, so the rendered content—not merely the unscaled layout box—retains a 12-pixel edge margin. The permanent cash icon/text group and the single temporary boost badge share the same rendered right edge. `ActiveBuffs.PermanentCash2x` is visible only while the server snapshot contains `Monetization.OwnedGamePasses.PermanentCash2x == true`. `ActiveBuffs.TemporaryBoosts.StarterCash2x` and `StarterEggLuck2x` show `MM:SS` countdowns derived from the saved expiry timestamps and disappear at zero. Client purchase callbacks must not reveal any badge before server ownership reconciliation.

### Teleport

```text
StarterGui.TeleportUI.TeleportRoot
  ResponsiveScale
  WorldSelect
    Background
    CloseButton
    HeaderBanner
    WorldScroll
      UIListLayout
      UIPadding
      WorldButtonTemplate
  ZoneSelect
    Background
    CloseButton
    WorldBanner
    ZoneScroll
      UIListLayout
      UIPadding
      ZoneButtonTemplate
        LockedOverlay

StarterGui.TeleportUI.AssetSlots
  WorldButtons/<WorldId>
  WorldBanners/<WorldId>
  ZoneButtons/<ZoneKey>
```

World and zone scrolling frames are data-driven. Locked zones stay dark/grey, show `???`, and cannot teleport.

### Pets inventory

```text
StarterGui.PetsMenu.PetsMenuRoot
  ResponsiveScale
  MainBackground
  PetsBanner
  CloseButton
  PetInventoryScroll
  PetFullPreview
    SellValueLabel
    SellButton
  PetTeamSummary
    OwnedCountLabel
    CapacityDivider
  Sort

StarterGui.PetsMenu.AssetSlots
  RarityBackgrounds/<Rarity>
  FullPreviewRarityBackgrounds/<Rarity>
  SmallPreviewInfoBackgrounds/<Rarity>
```

The inventory uses three cards per row on the wider background. Full and small preview backgrounds are selected by rarity. The summary displays owned/capacity, equipped count, and current multiplier. The selected-pet preview displays the comma-formatted server-configured sell value; `SellButton` uses a two-click confirmation and is disabled while the pet is equipped. Equipped pets show a star but keep their unsorted/default position unless the player explicitly selects a sort.

### Tools inventory

```text
StarterGui.ToolsMenu.ToolsMenuRoot
  ResponsiveScale
  MainBackground
  ToolsBanner
  CloseButton
  ToolInventoryScroll
  ToolFullPreview
  ToolSummary
  Sort
  StatusLabel

StarterGui.ToolsMenu.AssetSlots
  RarityBackgrounds/<Rarity>
  FullPreviewRarityBackgrounds/<Rarity>
  SmallPreviewInfoBackgrounds/<Rarity>
```

Tools mirror the pet-menu format but allow one equipped tool and show collection speed, extra-trash chance, and mutation multiplier.

### Collection book

```text
StarterGui.CollectionMenu.CollectionMenuRoot
  CollectionBackground
  CollectionBanner
  CloseButton
  TrashTab
  PetsTab
  ZoneBanner
  Progression display
  Scrolling content for generated cards

StarterGui.CollectionMenu.AssetSlots
  ZoneBanners/<ZoneKey>
  TrashRarityBackgrounds/Common|Uncommon|Rare|Epic|Legendary|Locked
  PetRarityBackgrounds/Common|Uncommon|Rare|Epic|Legendary|Locked
```

Trash cards use two columns. Pet cards use three columns. Tabs visually tuck behind the main background. The zone banner cycles through `ZoneConfig.Order`. Unknown trash uses `???`; unknown pets use a silhouette/question mark.

### Egg menu

```text
StarterGui.EggMenu
  EggMenuRoot
    ResponsiveScale
    MainBackground
    CloseButton
    LuckPassBadge
    Content
      PetResultsScroll
        PetResultTemplate
      EggSection
        EggImage
        PriceLabel
        EggNameLabel
        HatchOneButton
        HatchThreeButton
        FastHatchToggle
  AssetSlots
    PetRarityBackgrounds/<Rarity and Locked>
    EggImages/<ZoneKey or EggId>
```

The menu is scrolling and currently shows three pet previews per row. Egg art is an image; pet names, odds/rarity, price, and state are dynamic. The hatch buttons' 1×/3× text is baked into images. The 3× button shows a small `PASS` lock label until `TripleHatch` is server-confirmed; pressing it while locked opens the Roblox purchase prompt. A hatch failure with server reason `InventoryFull` shows the exact missing-slot and owned/capacity message. When its server response suggests `PetStorage50`, the menu opens the +50 Pet Storage Game Pass prompt; verified owners receive only the capacity warning and must sell pets. `FastHatchToggle` shows LOCKED/ON/OFF and sends only a boolean preference through `Pet.SetFastHatchEnabled`. `LuckPassBadge` sits to the right of the panel, uses the configured Shop icon, opens the pass prompt when unowned, and shows `+400% LUCK ACTIVE` when owned. Egg chance labels use `PetConfig.GetRarityChance` with the verified luck multiplier.

### Shop

```text
StarterGui.ShopMenu.ShopMenuRoot
  ResponsiveScale
  Background
  ShopBanner
  CloseButton
  ShopContentScroll
    PremiumPetSection
    StarterPackSection
    GamepassesSection
    BoostsSection
    CashSection
  PurchaseStatusLabel (authored here; moved directly under ShopMenu at runtime)

StarterGui.ShopMenu.Templates
  LongProductCardTemplate
  SmallProductCardTemplate

StarterGui.ShopMenu.AssetSlots
  ProductBannerBackgrounds
  ButtonStates
  ProductIcons
```

Product category titles, product names/descriptions, and Robux prices are dynamic. Premium Pet is the first section. Current live keys are `PremiumPet`, `StarterPack`, `TripleHatch`, `FastHatch`, `ExtraPetSlots`, `PermanentCash2x`, `PetStorage50`, `EggLuckBoost400`, `CashBoost`, `PocketCash`, `CashBag`, and `CashVault`. `EggLuckBoost400` is a permanent pass in `GamepassesSection`; `CashBoost` is the only current temporary boost product. Keys, Marketplace IDs, purchase kinds, and effect metadata come from `ReplicatedStorage.Shared.Config.MonetizationConfig`; player-facing prices must be fetched from `MarketplaceService`, not copied from the config. Every product except `PremiumPet` is currently enabled. A clicked Buy control is disabled with `WAIT...` while its prompt and authoritative verification are pending. Cancellation/failure restores Buy. A verified Game Pass renders `OWNED`; a persisted repeatable Developer Product receipt renders `PURCHASED` for three seconds before returning to Buy. `PurchaseStatusLabel` is authored under `ShopMenuRoot` but reparented directly under the enabled `ShopMenu` ScreenGui at runtime. It is a long, highly transparent black top-center toast, independent of modal visibility, and shows opening, verifying, processing, cancelled, failed, and successful states. Cash success text must use the server result's `Amount`, formatted through `Theme.FormatNumber`; timed products show the server result's `DurationSeconds`. `CashBoost` displays the existing bottom-right `StarterCash2x` countdown because Starter Pack and purchased boost time intentionally share `Cash2xExpiresAt`. The UI must never infer a reward from a prompt-completion event. Banner/close art is static. Obsolete cards are retained under `Templates.ArchivedProductCards`, outside the live scroll. Never implement a product effect solely in UI; commerce and receipt handling must be server-authoritative.

### Tool crate

```text
StarterGui.ToolCrateMenu.ToolCrateMenuRoot
  ResponsiveScale
  MainBackground
  CloseButton
  Content
  StatusLabel

StarterGui.ToolCrateMenu.AssetSlots
  ToolRarityBackgrounds/<Rarity and Locked>
  CrateImages/<WorldId or CrateId>
```

Use crate/open terminology, not egg/hatch terminology.

### Settings

```text
StarterGui.SettingsUI
  SettingsToggle
  SettingsPanel
    ResponsiveScale
    Header
    Content
    HintLabel
```

Settings include SFX and background-music controls with draggable left/right volume sliders. Do not reduce these back to simple toggle-only controls.

Current audio contracts:

- `SoundService.BackgroundMusic` uses `rbxassetid://80414797258582` and should loop through `BackgroundMusicGroup`.
- UI click SFX is created by `UITheme` with `rbxassetid://123377640435811` and routed through `SFXGroup` when available.
- User-supplied gameplay SoundIds belong in `SoundService.GameSFX`: `ButtonHover`, `SellSuccess`, `CoinPop`, `ZoneUnlock`, `TrashCollectLoop`, `EggCrack`, `EggResult`, `RobuxPurchase`, and `UpgradePurchase`. `EggCrack` starts immediately when the normal egg animation begins, before the darkness and egg-entrance tween; Fast Hatch skips it. `EggResult` remains tied to the pet appearing.
- `CoinPop` is intentionally shared by sell-coin HUD arrivals and successful trash-collection completion. `TrashCollectLoop` starts only for a validated collection session and stops on every collection result. Sell, unlock, and Robux sounds play only after their server-success results; `UpgradePurchase` plays when an active upgrade button is pressed, before the server response, as requested.
- `SoundController` clones one-shot slots for overlap, ignores empty SoundIds, and automatically binds hover sound to current and future active `GuiButton` descendants. Do not add a second hover binding in individual menus.
- `BackgroundMusicGroup` and `SFXGroup` volumes are the values changed by the settings sliders; do not change every individual sound independently.

## Modal behavior

Major menus use `UITheme.RegisterModal`, background blur, and open/close transitions. Only one major modal should be active at a time. Bind click motion once; duplicate signal connections produce repeated sound/animation.

## Layering and feedback

- New discovery, collected-item reward, and collection progress must occupy coordinated, non-overlapping regions.
- Starting a new collection must not be obscured by an old collected-item banner.
- A duplicate interaction during an active collection is rejected silently; do not show the `You're already collecting this` reward banner.
- Cooldown text must have high contrast.
- Current-zone feedback is a Fredoka One-style stroked popup that rises and fades, not a persistent top banner.
- HUD backpack/cash are independently anchored to the bottom-left safe area. Active buff icons and outlined text use the bottom-right safe area without an opaque card background; both HUD groups must remain on-screen at narrow mobile resolutions.

## Adding/replacing images

1. Upload the PNG to Roblox.
2. Insert its `rbxassetid://...` into the corresponding `AssetSlots` ImageLabel/ImageButton.
3. Preserve the exact slot name.
4. Keep the slot hidden if it is only a source/template.
5. Test `ScaleType`, transparent padding, and all target aspect ratios.
6. Do not place the image in a random `StaticImages` folder unless the active UI module reads that folder.

Frostbite Harbor currently has replaceable placeholder slots at:

- `StarterGui.TeleportUI.AssetSlots.ZoneButtons.FrostbiteHarbor`
- `StarterGui.CollectionMenu.AssetSlots.ZoneBanners.FrostbiteHarbor`

Haunted Carnival has empty replaceable slots at:

- `StarterGui.TeleportUI.AssetSlots.ZoneButtons.HauntedCarnival`
- `StarterGui.CollectionMenu.AssetSlots.ZoneBanners.HauntedCarnival`
- `StarterGui.EggMenu.AssetSlots.EggImages.HauntedCarnival`

Toxic Swamp has empty replaceable slots at:

- `StarterGui.TeleportUI.AssetSlots.ZoneButtons.ToxicSwamp`
- `StarterGui.CollectionMenu.AssetSlots.ZoneBanners.ToxicSwamp`
- `StarterGui.EggMenu.AssetSlots.EggImages.ToxicSwamp`
