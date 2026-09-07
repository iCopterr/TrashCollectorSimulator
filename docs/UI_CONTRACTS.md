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
  PetTeamSummary
  Sort

StarterGui.PetsMenu.AssetSlots
  RarityBackgrounds/<Rarity>
  FullPreviewRarityBackgrounds/<Rarity>
  SmallPreviewInfoBackgrounds/<Rarity>
```

The inventory uses three cards per row on the wider background. Full and small preview backgrounds are selected by rarity. Equipped pets show a star but keep their unsorted/default position unless the player explicitly selects a sort.

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
  authored root/background/close controls
  scrolling egg content and pet-card templates
  AssetSlots
    PetRarityBackgrounds/<Rarity and Locked>
    EggImages/<ZoneKey or EggId>
```

The menu is scrolling and currently shows three pet previews per row. Egg art is an image; pet names, odds/rarity, price, and state are dynamic. The hatch buttons' 1×/3× text is baked into images.

### Shop

```text
StarterGui.ShopMenu.ShopMenuRoot
  ResponsiveScale
  Background
  ShopBanner
  CloseButton
  ShopContentScroll
  PurchaseStatusLabel

StarterGui.ShopMenu.Templates
  LongProductCardTemplate
  SmallProductCardTemplate

StarterGui.ShopMenu.AssetSlots
  ProductBannerBackgrounds
  ButtonStates
  ProductIcons
```

Product category titles, product names/descriptions, and Robux prices are dynamic. Banner/close art is static. Never implement a product effect solely in UI; commerce and receipt handling must be server-authoritative.

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
- `BackgroundMusicGroup` and `SFXGroup` volumes are the values changed by the settings sliders; do not change every individual sound independently.

## Modal behavior

Major menus use `UITheme.RegisterModal`, background blur, and open/close transitions. Only one major modal should be active at a time. Bind click motion once; duplicate signal connections produce repeated sound/animation.

## Layering and feedback

- New discovery, collected-item reward, and collection progress must occupy coordinated, non-overlapping regions.
- Starting a new collection must not be obscured by an old collected-item banner.
- A duplicate interaction during an active collection is rejected silently; do not show the `You're already collecting this` reward banner.
- Cooldown text must have high contrast.
- Current-zone feedback is a Fredoka One-style stroked popup that rises and fades, not a persistent top banner.
- HUD cash/backpack/World 1 Diamonds live below the navigation buttons and must remain on-screen at narrow mobile resolutions.

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
