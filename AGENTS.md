# Trash Collector Simulator — Codex Rules

These instructions apply to every task in this project. Read this file and the documents linked from [README.md](README.md) before changing Roblox Studio, project files, balance, or UI.

## Project reality

- The authoritative Luau code and Roblox instances currently live inside the Roblox Studio place, not as Rojo source files in this folder.
- This folder contains handoff documentation, balance exports, and art/build assets. It is not sufficient by itself to reconstruct the game.
- Work on the game requires the correct `.rbxl`/published place open in Roblox Studio and the Studio MCP plugin showing a green `Connected` state.
- The local MCP port can change between Studio sessions. Discover or confirm the active endpoint; do not assume `58741` or `58742` is always correct.
- Save a named place version before and after material work. Do not rely on chat history as a backup.

## Required reading order

1. [README.md](README.md)
2. [docs/GAME_OVERVIEW.md](docs/GAME_OVERVIEW.md)
3. [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
4. [docs/DATA_AND_SECURITY.md](docs/DATA_AND_SECURITY.md)
5. [docs/UI_CONTRACTS.md](docs/UI_CONTRACTS.md)
6. [docs/ADDING_CONTENT.md](docs/ADDING_CONTENT.md)
7. [docs/BALANCE_CURRENT.md](docs/BALANCE_CURRENT.md)
8. [docs/KNOWN_ISSUES_AND_ROADMAP.md](docs/KNOWN_ISSUES_AND_ROADMAP.md)
9. [docs/TEST_CHECKLIST.md](docs/TEST_CHECKLIST.md)

## Non-negotiable engineering rules

1. **Inspect before editing.** Read the relevant config, service, controller, UI module, and instance hierarchy. Search all references to any name you plan to change.
2. **Make minimal edits.** Preserve unrelated user work. Never replace a whole service or GUI tree merely to change one behavior or layout value.
3. **Never rename a live contract casually.** GUI node names, config keys, remote names, model names, folder names, and internal zone keys are API contracts.
4. **The server is authoritative.** Clients may request an action or render results, but they must never decide prices, rewards, RNG, mutation odds, pet/tool ownership, equip state, currency, zone unlocks, or teleport destinations.
5. **Never trust client payloads.** Validate types, membership, distance, cooldowns, ownership, unlock state, allowed counts, prices, and active sessions on the server.
6. **Keep saved data backward-compatible.** Add defaults and reconcile old profiles. Do not rename or remove persistent fields without a written migration and test plan.
7. **Configs are the balance source of truth.** Do not hardcode a second price, chance, multiplier, or zone list in UI or service code when a config already owns it.
8. **Preserve the Figma workflow.** Image assets supply decorative backgrounds and text that is intentionally baked into an image. Dynamic values must remain Roblox text/models layered over the image.
9. **Do not auto-equip newly hatched pets.** Pet equipment changes only through the validated equip flow.
10. **Equipped pet order must remain stable.** Equipped pets are marked with a star; do not automatically move them to the front of the inventory.
11. **Do not reintroduce global trash cooldowns.** Successful collections reroll immediately for that player. A miss alone uses the three-second cooldown.
12. **Do not add a mutation banner.** Mutated trash spots communicate through their aura/effects.
13. **Use comma formatting for large whole numbers.** Reuse `ReplicatedStorage.Shared.NumberFormat` or the existing theme formatter.
14. **One World 1 Diamond wallet.** All current World 1 zones earn and spend `Diamonds.World1`. Diamonds are isolated by world, not by zone.
15. **One tool crate per world.** Physical entrances can exist in every zone, but all World 1 entrances resolve to the same crate, odds, inventory, and wallet.
16. **One egg market per zone.** A zone egg uses that zone's cash price and pet pool.
17. **Update documentation with behavior changes.** At minimum update `CHANGELOG.md`, and update any contract/balance document affected by the change.

## Required workflow for every change

### Before editing

- Confirm the correct Studio place and green MCP connection.
- Save a version/copy of the place.
- Read the relevant documents.
- Inspect the exact Studio paths involved.
- Search references to every object/config key being renamed, removed, or extended.
- State the intended scope and assumptions.

### During editing

- Prefer exact, local script edits.
- Preserve existing models, Figma images, and user-authored layout unless the request explicitly replaces them.
- When adding a system, separate configuration, server behavior, client controller, and UI rendering.
- When adding a zone or content type, complete the entire integration matrix in [docs/ADDING_CONTENT.md](docs/ADDING_CONTENT.md).

### After editing

- Run the relevant checks in [docs/TEST_CHECKLIST.md](docs/TEST_CHECKLIST.md).
- Check Studio Output on server and client.
- Verify both success and rejection/failure paths.
- Confirm existing zones, menus, and player data still work.
- Reinspect the final hierarchy and exact names.
- Save the place and record the change in [docs/CHANGELOG.md](docs/CHANGELOG.md).

## Roblox Studio ModuleScript cache warning

Edit-mode `require()` caches ModuleScript results. After changing a config, an edit-mode rebuild can accidentally use the old cached table. Prefer a fresh playtest VM. If a persistent edit-world rebuild is necessary, clone the service and freshly clone its config dependencies, redirect the cloned service's `require()` calls to those cloned modules, run the rebuild, then destroy the temporary clones. Never leave `_Rebuild` modules behind.

## Destructive actions

- Do not delete an existing GUI, model folder, service, config, or data field unless the user explicitly requested that exact replacement and all references were inspected.
- Do not run broad recursive deletion or reset commands.
- Do not overwrite user assets or a dirty worktree.
- Before replacing a model/template, verify the exact target name and `PrimaryPart`.

## Completion standard

A task is complete only when the requested outcome exists, all relevant contracts are connected, validation passes, Studio Output has no new errors, documentation is updated, and the place is saved. A visually present object with missing config/data/remote support is not complete.
