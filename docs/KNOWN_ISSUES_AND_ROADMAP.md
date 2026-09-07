# Known Issues, Technical Debt, and Roadmap

Snapshot date: 2026-08-30. Verify each item against the live place before acting; this file is a planning aid, not permission to implement everything listed.

## Known incomplete areas

- World 1 currently has eight of the intended ten zones. Zones 9–10 are not finalized.
- World 2 is intended to be Solar System-themed but is not implemented.
- Frostbite Harbor, Haunted Carnival, and Toxic Swamp replaceable UI slots are waiting for final uploaded Figma art. Verify whether Sewers also still needs final zone artwork.
- Final pet 3D models/portraits for later zones may still use generated initials/placeholders; inspect assets before assuming they exist.
- Robux Shop cards/art exist, but final product IDs, receipt effects, stacking rules, and production commerce validation are not complete unless proven in the live implementation.
- Balance is explicitly scheduled for later refinement. Current configs are playable targets, not final launch analytics tuning.
- The project still contains `UpgradeService` and `ToolConfig.LegacyUpgradeTools`. These are compatibility/technical-debt paths after the design shifted toward a Robux Shop and Diamond tool crates.
- Some comments in older configs may describe a feature as future/config-only even though its backend was later implemented. Trust behavior and tests over stale comments, then correct the comment.
- The repository does not yet contain Rojo-synced Luau source. The Studio place must be shared and backed up separately.

## Confirmed current design decisions

- Collection minigame remains secondary seasoning.
- One skill-check type.
- Miss grants nothing and causes a three-second cooldown.
- No successful-collection cooldown banner.
- Mutations: Gold, Infected, Cosmic; aura instead of mutation banner.
- One zone egg with five pets per zone.
- No egg pity.
- New pets do not auto-equip.
- Three pet equip slots, additive multipliers.
- One shared tool crate and Diamond wallet per world; physical entrance can appear in each zone.
- One equipped tool.
- Tools inventory contains tools only.
- Shop direction is Robux-only; ordinary tool acquisition uses Diamond crates.
- Current zone uses a rising/fading text popup, not the old persistent banner.
- Settings provide draggable volume controls for SFX and background music.

## Planned or undecided

- Final themes and balance for World 1 zones 9–10.
- Rebirth system replacing the older Recycler concept.
- Premium eggs and premium tools balance.
- Final pay-to-win boundaries and fair free-player pacing.
- Retention systems, including future pets/eggs/events, after core gameplay and UI stability.
- Whether backpack progression remains a cash upgrade, becomes shop/quest content, or is redesigned.
- Proper source-control/Rojo migration.

## High-risk future work

- Data schema migrations
- Developer product receipt processing
- Rebirth/economy resets
- Cross-world teleport and currencies
- Changing pet multiplier math
- Removing legacy upgrade systems
- Renaming Figma GUI hierarchy

These require a written plan, backup, migration/rollback strategy, and full regression test.
