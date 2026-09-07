# Trash Collector Simulator — Full UI Asset Pack v2

Generated on 2026-08-23 from the supplied simulator UI references.

## What is included

- 8 transparent interface icons: Shop, Teleport, Book, Pets, Cash, Inventory, Equipped Pets, and Mystery/Locked
- 1 transparent rarity-reveal VFX overlay
- 1 neutral seamless-style stud texture that can be recolored in Roblox
- High-resolution source PNGs in `Source_HighRes/`
- Normalized direct-upload PNGs in `RobloxReady_512/`
- `PREVIEW.png`, `manifest.json`, and the complete generation prompt set

## Recommended Roblox use

### Icons

- Upload files from `RobloxReady_512/` as images.
- Use an `ImageLabel` or `ImageButton` with `BackgroundTransparency = 1`.
- Set `ScaleType = Fit` so the complete icon remains visible.
- Keep text as Roblox `TextLabel` objects; text is intentionally not baked into these images.

### Stud texture

- Place `ui_texture_studs_tile.png` in an `ImageLabel` above the panel color.
- Set `ScaleType = Tile` and start with `TileSize = UDim2.fromOffset(42, 42)`.
- Recolor it with `ImageColor3` and use roughly `ImageTransparency = 0.75` to `0.88`.
- Use `ZIndex` just above the panel background and below all text/icons.

### Rarity reveal VFX

- Place `ui_vfx_rarity_burst.png` behind the revealed pet portrait.
- Tween rotation, scale, and transparency during the hatch reveal.
- A useful starting animation is scale `0.45 -> 1.10 -> 1.00` over 0.55 seconds.

## UI construction note

Panel fills, gradients, borders, rounded corners, tabs, progress bars, buttons, and close buttons should remain native Roblox UI objects. This keeps the interface responsive and makes recoloring or balancing layouts much easier.

