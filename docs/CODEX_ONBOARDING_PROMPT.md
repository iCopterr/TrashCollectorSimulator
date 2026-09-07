# Copyable Prompt for a New Codex

Send this as the first message after the collaborator opens the correct Roblox place, starts the green MCP connection, and opens this project folder in Codex:

```text
You are joining the Trash Collector Simulator Roblox project.

Before changing anything, read these files completely in order:
1. AGENTS.md
2. README.md
3. docs/GAME_OVERVIEW.md
4. docs/ARCHITECTURE.md
5. docs/DATA_AND_SECURITY.md
6. docs/UI_CONTRACTS.md
7. docs/ADDING_CONTENT.md
8. docs/BALANCE_CURRENT.md
9. docs/KNOWN_ISSUES_AND_ROADMAP.md
10. docs/TEST_CHECKLIST.md
11. docs/MCP_WORKFLOW.md
12. docs/CHANGELOG.md

Then connect to the active Roblox Studio MCP server and perform an inspection-only audit. Confirm the correct place is open and inspect the relevant Config modules, ServerBootstrap, server services, client controllers/UI modules, StarterGui roots, remotes, ReplicatedStorage model templates, and generated Workspace folders.

Do not edit anything yet. Give me:
- a concise architecture summary;
- the current World 1 zone order;
- the authoritative locations for balance, player data, server validation, GUI templates, and model templates;
- the most important naming/data/security contracts;
- any differences between the documentation and the live place;
- the risks and exact files/instances that would be involved in my requested task.

For later changes, follow AGENTS.md, preserve unrelated work, keep the server authoritative, maintain backward-compatible data, make minimal edits, run the relevant TEST_CHECKLIST sections, check server/client Output, update CHANGELOG.md, and save the place. Ask before any destructive replacement, data wipe, migration, or materially broader redesign.
```

## Short follow-up prompt for a feature

After the inspection summary, use:

```text
Implement this request: <REQUEST>.

First state the exact scope and integration points. Then make the smallest safe complete change. Validate success and rejection paths, run the relevant regression checklist, report any assumptions or remaining placeholders, update the documentation, and save the Roblox place. Do not implement adjacent roadmap ideas unless I explicitly request them.
```
