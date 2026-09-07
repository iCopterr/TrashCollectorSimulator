# Roblox Studio and MCP Workflow

## Opening a safe session

1. Open the latest shared/published place in Roblox Studio.
2. Save a dated local backup.
3. Open the MCP Server plugin.
4. Confirm HTTP, MCP bridge, and Commands all show green/OK.
5. Note the active localhost port. It may change between sessions.
6. Open Codex in this handoff folder.
7. Ask Codex to read `AGENTS.md` and perform an inspection-only summary.

If the plugin is red, stuck on Connecting, or reports Server unavailable:

- Disconnect the plugin.
- Close duplicate MCP/plugin panels or Studio instances using the same port.
- Restart Studio and the plugin.
- Try a fresh port and update the URL used by the coding session.
- Confirm Windows firewall/security software is not blocking localhost.
- Do not start edits until a read-only Studio query succeeds.

## Inspection commands/tasks Codex should perform

- List the relevant project structure.
- Read exact config/service/controller sources.
- Search script references to names being changed.
- Inspect the exact GUI/model path and properties.
- Check current playtest state and Studio Output.
- Distinguish edit-mode instances from playtest clones.

## Safe edit sequence

1. Modify config contracts first.
2. Modify server behavior and bootstrap wiring.
3. Modify client controller/UI binding.
4. Create or adjust templates/instances.
5. Rebuild generated edit-world content if needed.
6. Validate exact paths/counts/attributes.
7. Start a fresh playtest and inspect server/client Output.
8. Stop the playtest and save the place.

## Edit mode vs playtest

- `StarterGui` is the authored source. `PlayerGui` is a runtime clone.
- `StarterPlayerScripts` is the authored source. `PlayerScripts` is a runtime clone.
- Change authored instances in Edit mode unless debugging a runtime clone.
- A runtime-only change disappears when playtest stops.
- A playtest uses a fresh Luau VM and is the preferred validation for changed ModuleScripts.

## Module cache

Studio edit-mode `require()` caches a ModuleScript's returned value. Requiring it again after editing may return old data. Use a new playtest to validate. For a persistent edit-world rebuild, use temporary fresh clones as described in `AGENTS.md`, then destroy them and verify no temporary instances remain.

## Saving and handoff

- Stop playtest before saving.
- Save the place locally and publish a named version if appropriate.
- Update `docs/CHANGELOG.md`.
- Commit documentation/assets to Git.
- Tell the next collaborator the place version/date and active known limitations.

## What not to do

- Do not edit runtime `PlayerGui` and assume it changed `StarterGui`.
- Do not trust a successful tool response without inspecting the resulting hierarchy.
- Do not rebuild the entire UI or map for a small requested change.
- Do not leave temporary ModuleScript clones or duplicate generated folders.
- Do not use chat history as the sole specification.
