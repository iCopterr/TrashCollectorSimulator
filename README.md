# Trash Collector Simulator — Project Handoff

This folder is the permanent context pack for developers and coding agents working on the Roblox game **Trash Collector Simulator**.

The live game currently contains eight ordered World 1 zones: Downtown, Beach, Factory, Junkyard, Sewers, Frostbite Harbor, Haunted Carnival, and Toxic Swamp. Players collect randomized trash through a short 3–5 second interaction, may receive a Dead by Daylight-style skill check, sell items for cash, hatch zone pets, equip pets for additive income multipliers, find world-specific Diamonds, and open a shared World 1 tool crate.

## Start here

- Agent rules: [AGENTS.md](AGENTS.md)
- Product and gameplay direction: [docs/GAME_OVERVIEW.md](docs/GAME_OVERVIEW.md)
- Code and system map: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Saved-data and security rules: [docs/DATA_AND_SECURITY.md](docs/DATA_AND_SECURITY.md)
- GUI naming and Figma contracts: [docs/UI_CONTRACTS.md](docs/UI_CONTRACTS.md)
- How to add zones/content safely: [docs/ADDING_CONTENT.md](docs/ADDING_CONTENT.md)
- Current balance snapshot: [docs/BALANCE_CURRENT.md](docs/BALANCE_CURRENT.md)
- Known gaps and roadmap: [docs/KNOWN_ISSUES_AND_ROADMAP.md](docs/KNOWN_ISSUES_AND_ROADMAP.md)
- Required regression checks: [docs/TEST_CHECKLIST.md](docs/TEST_CHECKLIST.md)
- Studio/MCP operating procedure: [docs/MCP_WORKFLOW.md](docs/MCP_WORKFLOW.md)
- Copyable onboarding prompt: [docs/CODEX_ONBOARDING_PROMPT.md](docs/CODEX_ONBOARDING_PROMPT.md)
- Change history: [docs/CHANGELOG.md](docs/CHANGELOG.md)

## Files and source of truth

- **Roblox Studio place:** authoritative for Luau scripts, instances, models, GUI hierarchy, remotes, and live assets.
- **Config ModuleScripts in Studio:** authoritative for current gameplay balance.
- **This documentation:** authoritative for architecture, naming rules, design intent, and safe workflow; update it when the implementation changes.
- **`outputs/balance-config-20260825/Trash_Collector_Balance_Config.xlsx`:** an earlier design/balance export. It may not include later zones or tuning. Compare it with Studio configs before using it.
- **`assets/`, `build-library/`, and UI asset packs:** source/reference artwork and procedural build data. They do not replace the Studio place.

## How to hand the project to another Codex

1. Save or publish the latest Roblox place and give the collaborator access.
2. Share this entire folder, preferably through a private Git repository.
3. Have the collaborator open the correct place in Roblox Studio.
4. Start the Roblox Studio MCP plugin and confirm all status indicators are green.
5. Open Codex with this folder as its workspace.
6. Send the prompt from [docs/CODEX_ONBOARDING_PROMPT.md](docs/CODEX_ONBOARDING_PROMPT.md).
7. Require an inspection-only architecture summary before authorizing changes.

## Recommended backup/versioning practice

- Save a dated `.rbxl` copy before major changes.
- Publish named Roblox versions after verified milestones.
- Commit documentation and source art to Git.
- Long term, consider a planned Rojo migration so Luau source is reviewable and version-controlled outside Studio. Do not attempt that migration as part of an unrelated feature.

## Rojo and GitHub setup

This repository now contains a staged, partially managed Rojo 7 project in `default.project.json`. It is restricted to Roblox place ID `97825563424125` and preserves Studio-only instances with `$ignoreUnknownInstances` while the existing scripts are migrated.

- The GitHub remote is `https://github.com/iCopterr/TrashCollectorSimulator.git`.
- Rojo uses port `34872`; the Roblox Studio MCP server uses a separate port such as `58741`.
- Install or update the matching Studio plugin with `rojo plugin install`.
- Start the filesystem sync server from this folder with `rojo serve`.
- In Studio, open the Rojo plugin and connect to `localhost:34872` only after confirming the correct place is open.
- Do not treat the current empty `src` folders as a complete game export. The authoritative scripts must first be copied from the live Studio place into their matching service folders and verified before Rojo becomes the source of truth.
- Generated image packs in `outputs/`, local place builds, backups, and duplicate root ZIP archives are excluded from Git.
