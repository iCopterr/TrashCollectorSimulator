# Project Changelog

This changelog begins with a consolidated handoff snapshot. Add future entries at the top with date, scope, Studio place version if known, validation performed, and remaining placeholders.

## 2026-09-08 — Silent duplicate collection rejection

- Kept the server-side active-collection guard but stopped `TrashSpotController` from showing the redundant `You're already collecting this` reward banner.
- Preserved all other collection rejection feedback, including backpack-full and cooldown messages.
- Mirrored the changed live `TrashSpotController` into the staged Rojo tree.
- Validation: the live source compiled through `loadstring`, direct filter assertions passed for duplicate/other/success cases, and a one-player startup test stopped with no captured Output errors.

## 2026-09-08 — Pet multiplier moved to sell time

- Changed collection rewards so backpack items and reward banners show configured base trash value with only the rolled mutation bonus; equipped pets are no longer baked into collected item values.
- Changed server-authoritative selling to resolve trash base values and mutation data from shared configs, validate legacy tool-value metadata against configured tools, and apply the player's current equipped pet-team multiplier when selling.
- Preserved the existing additive pet/mutation formula (`pet + mutation - 1`) and the legacy cash-tool multiplier exactly once, while rejecting unknown trash IDs and invalid multiplier metadata.
- Kept the existing client payload shape and reward UI binding; no remote or GUI contract was renamed.
- Mirrored the three changed server scripts into the staged Rojo tree so this code change is reviewable in Git; the larger Studio-to-Rojo migration remains incomplete.
- Validation: fresh-module formula checks covered normal and mutated collection values, current-pet sale values, valid legacy tool bonuses, invalid metadata, unknown IDs, empty backpacks, and repeated sells. The accessible Studio Output contained no new task-related errors, but a fresh one-player run could not start because the Studio bridge retained a stale `A test is already running` state after its stop signal.

## 2026-09-08 — Staged Rojo and GitHub foundation

- Added a partially managed Rojo 7 project restricted to place ID `97825563424125`, with source roots for shared, server, client, GUI, and storage content.
- Enabled `$ignoreUnknownInstances` on every managed service during migration so connecting an empty source root cannot remove existing Studio-only instances.
- Added Git attributes and ignores for generated output, local place builds/backups, temporary review files, and duplicate root ZIP archives.
- Installed the Rojo 7 Studio plugin and configured the local repository remote for `https://github.com/iCopterr/TrashCollectorSimulator.git`.
- Validation: Rojo 7.7.0 is installed locally and the target GitHub repository is reachable and has no refs yet.
- Remaining handoff: the Roblox Studio MCP bridge timed out, so authoritative live scripts have not yet been exported into `src`; reconnect the correct place before completing the migration and enabling normal live sync.

## 2026-08-31 — Downtown pet model drafts

- Used `Workspace.RacoonNew` as the scale and orientation reference to create `Workspace.Zone1PetModelDrafts` with exact config-named Models for `DowntownPigeon`, `DowntownRat`, `DowntownStray`, and `DowntownFox`.
- Gave every model a 2x2x2 `Body` PrimaryPart, four two-piece legs, species-specific ears/wings/beak, a separate tail, anchored non-collidable geometry, and body welds.
- Added 32 empty named Decal slots with `SourcePng` attributes: four body surfaces and the four long tail surfaces per pet. No decal asset IDs were inserted, and the drafts were intentionally not copied into `ReplicatedStorage.PetModels` before the user's manual decal pass.
- Validation: confirmed four Models, 55 BaseParts, 51 valid body welds, 32 empty Decals, exact model names, valid PrimaryParts, expected attributes, and disabled collision/touch/query on every part. A fresh one-player playtest started and stopped with no captured Output; the server-target inspection timed out after Studio's plugin bridge disconnected during playtest.
- Remaining handoff: manually add decal asset IDs, visually inspect all faces, copy the approved Models into `ReplicatedStorage.PetModels`, retest the three pet viewport UIs, and save/publish a named Studio version. The MCP input tool lacked permission to invoke Studio's save shortcut.

## 2026-08-30 — Downtown four-side pet decal pack

- Confirmed the live `Trash Collector Simulation` place (`placeId` 97825563424125) and authoritative Downtown pet roster through the Studio MCP connection on port 58742.
- Added a project asset pack for Alley Pigeon, Street Rat, Neon Stray, and Golden City Fox; Recycle Raccoon was intentionally excluded because the user already has its prototype.
- Included body and separate tail art for Front, Right, Back, and Left: 32 individual 1024x1024 transparent PNGs plus eight source atlases, usage notes, prompts, and a manifest.
- Validation: all 32 individual files resolve as PNG, are exactly 1024x1024, and retain alpha transparency at their canvas corners. No Roblox Studio instances, scripts, data, or balance values were changed.

## 2026-08-30 — Ten-zone pet multiplier rebalance

- Replaced the nearly flat 70–500× World 1 pet curve with a 10–4,300× curve; each zone after Downtown now starts above the previous zone's Legendary pet.
- Preserved the three-pet additive team formula, rarity odds, IDs, ownership, equip behavior, and mutation combination formula.
- Scaled Factory through World's End Landfill egg prices and unlock prices using the preceding zone's expected pet-income increase so stronger pets do not shorten the intended progression targets.
- Updated pet inventory cards, full preview, team summary, collection cards, and hatch results to comma-format the new four-digit multipliers.
- Refreshed live edit-world barrier titles and comma-formatted prices from the authoritative zone config.
- Validation: fresh config load confirmed ten ordered zones, five increasing rarity values per egg, one pet of every rarity, Common-over-previous-Legendary gaps, matching profile caps, the expected prices, a 12,075× best World 1 team, and additive Cosmic combination of 12,174×.

## 2026-08-30 — Toxic Swamp (World 1 Zone 8)

- Added `ToxicSwamp` after Haunted Carnival at X=2,100, including the $140,000,000,000 unlock, Haunted Carnival hatch requirement, progression profile, saved-data default, teleport order, server trash spawn, UI theme, and shared World 1 Diamond/tool-crate mappings.
- Added eight Toxic Swamp trash definitions, five pets from 395× to 435×, the $112,000,000,000 Bog Egg, and 9% World 1 Diamond drops worth 8–10 Diamonds.
- Built a raised boardwalk, toxic bog pools, cypress trees and roots, witchlights, and a wrecked airboat landmark with complete walls, containment extension, and a gated Haunted Carnival-to-Swamp divider.
- Added unique leaking-barrel and wrecked-airboat trash templates, a swamp purification sell station, zone egg market, and shared World 1 tool-crate entrance.
- Added empty replaceable teleport, collection-banner, and egg-image slots for later Figma art.
- Validation: fresh-source parsing and fresh config loads passed; structural assertions confirmed eight zones, 73 terrain details, eight trash items, five pets, all three entrances, model templates, barrier, containment, and UI slots. A one-player Play session started/stopped without captured output; run a normal in-Studio traversal test before publishing.

## 2026-08-30 — Haunted Carnival sell-station facing

- Added an optional per-station `FacingYawDegrees` setting and set Haunted Carnival to `0` so its differently authored ticket booth faces Frostbite Harbor without changing other zones.
- Rotated only the edit-world booth geometry and preserved the sell interaction anchor at the configured negative-X side.
- Validation: the booth window and prompt both resolve to the Frostbite Harbor-facing side.

## 2026-08-30 — Higher `/addcash` testing limit

- Raised the server-authoritative `/addcash` maximum from $1,000,000,000 to $1,000,000,000,000,000 so late-zone economy values can be tested.
- Split the shared grant limit into currency-specific limits; `/adddiamond` remains capped at 1,000,000,000.
- Validation: fresh-loaded `AdminCommandService`; confirmed 25,000,000,000 and the new maximum are accepted, larger Cash grants are rejected, and the Diamond cap is unchanged.

## 2026-08-30 — Haunted Carnival (World 1 Zone 7)

- Added `HauntedCarnival` after Frostbite Harbor at X=1,800, including its unlock/hatch requirement, $25,000,000,000 unlock, progression profile, server barrier, teleport order, saved-data default, shared World 1 Diamond/tool-crate mapping, and UI theme color.
- Added eight Haunted Carnival trash definitions, five zone pets, the $20,000,000,000 Spectral Egg, and 8% World 1 Diamond drops worth 7–9 Diamonds.
- Built an eerie midway with tent pads, a ghost carousel, broken Ferris wheel, ghost lamps, full walls/borders/containment, and the Frostbite-to-Carnival gated divider.
- Added unique small and medium trash templates plus a haunted ticket-booth sell station, a zone egg market, and a shared World 1 tool-crate entrance.
- Added empty replaceable teleport, collection-banner, and egg-image slots for later Figma art.
- Removed an accidental duplicate Frostbite Harbor trash-spot spawn call while adding the Zone 7 spawn.
- Validation: fresh config loads and structural assertions passed for seven zones, eight trash items, five pets, all physical entrances, model PrimaryParts, the barrier, containment, and UI slots. The Studio MCP playtest-output endpoint became stale during a client-module edit-mode validation; all temporary `_HC_` modules were removed, and a normal in-Studio Play test should still be run before publishing.

## 2026-08-29 — Codex handoff pack

- Added permanent project/agent rules in `AGENTS.md`.
- Documented product intent, architecture, data/security contracts, UI/Figma contracts, current balance, extension procedures, MCP workflow, regression tests, known gaps, and onboarding prompts.
- Recorded that the Roblox Studio place remains the authoritative source for Luau and instances.

## Current consolidated implementation snapshot

- Eight straight World 1 zones: Downtown, Beach, Factory, Junkyard, Sewers, Frostbite Harbor, Haunted Carnival, Toxic Swamp.
- 300×300 zone layouts with themed terrain, walls, gates, randomized player-specific trash spots, unique small/medium templates, and per-zone sell/egg stations.
- Server-authoritative 3–5 second collection flow with optional single skill check, immediate miss stop, no miss reward, and three-second miss cooldown.
- Gold, Infected, and Cosmic mutations with trash-spot auras.
- Coordinated collection/reward/discovery effects and HUD feedback.
- Server-authoritative selling, zone unlock requirements, locked barriers, and teleport validation.
- Five-pet zone eggs, no pity, permanent hatch-zone progression, non-auto-equip hatch behavior, three equip slots, additive team multiplier, inventory sorting, collection silhouettes, and Figma-based UI.
- World 1 Diamonds with per-zone drop tuning and world-isolated saved balances/pity.
- Shared World 1 tool crate accessible from every zone, ten configured tools, server opening/inventory/equip behavior, and Tools UI.
- Robux Shop UI/templates and product art structure; product effects remain subject to live verification/final implementation.
- Shift-to-run, menu blur/transitions, click SFX, looping background music, and draggable SFX/BGM settings.
- Frostbite Harbor added as Zone 6 with eight trash items, five pets, Glacier Egg, 7% Diamond drop tuning, frozen terrain, custom trash models, an arctic sell station, markets, barrier, and placeholder zone-art slots.
- Haunted Carnival added as Zone 7 with eight trash items, five pets, Spectral Egg, 8% Diamond drop tuning, haunted midway terrain, unique trash/sell models, markets, barrier, and placeholder zone-art slots.
- Toxic Swamp added as Zone 8 with eight trash items, five pets, Bog Egg, 9% Diamond drop tuning, boardwalk/bog terrain, unique trash/sell models, markets, barrier, and placeholder zone-art slots.

## Entry template

```text
## YYYY-MM-DD — Change title

- Request:
- Studio place/version:
- Config/data changes:
- Server changes:
- Client/UI changes:
- Models/assets:
- Validation performed:
- Remaining placeholders/risks:
```
