# Regression and Completion Checklist

Run the sections affected by the change. For a new zone/system or data change, run the full list.

## Static and hierarchy checks

- [ ] Relevant ModuleScripts compile/load in a fresh VM.
- [ ] No accidental duplicate services, GUI roots, world folders, markets, or barriers.
- [ ] No `_Rebuild`, `_Temp`, or validation clones remain.
- [ ] Exact internal keys and GUI/model names match all references.
- [ ] Config references resolve to real items/pets/tools/models.
- [ ] Drop weights and rarity totals pass config validation.
- [ ] Every model has a valid `PrimaryPart` and sensible pivot.

## Playtest startup

- [ ] Server initializes without new warnings/errors.
- [ ] Client initializes without new warnings/errors.
- [ ] Player data loads and HUD values appear.
- [ ] Spawn is inside Downtown and character movement/sprint works.
- [ ] Background music loops; SFX/BGM sliders drag and change only their intended audio.

## Collection

- [ ] Small and medium models render in every affected zone.
- [ ] Spots are player-specific/random and obey zone bounds/spacing.
- [ ] Locked-zone trash cannot be collected.
- [ ] Collection duration is affected correctly by equipped tools.
- [ ] Skill check sometimes appears and accepts a correctly timed hit.
- [ ] MISS stops progress/UI immediately, grants nothing, and shows only a three-second cooldown.
- [ ] GOOD/GREAT/PERFECT grant configured quantities.
- [ ] A normal collected item and reward banner show the configured base value without any equipped-pet multiplier.
- [ ] Gold/Infected/Cosmic collected items and reward banners show base value multiplied only by the rolled mutation.
- [ ] Success rerolls/replaces the spot immediately for that player.
- [ ] Mutation aura matches Gold/Infected/Cosmic; no mutation banner appears.
- [ ] Backpack-full rejection is clear and does not start a broken session.
- [ ] Reward, discovery, and collection-progress UI do not overlap.

## Economy and selling

- [ ] Sell station faces the previous zone and prompt distance is reasonable.
- [ ] Sell uses server backpack contents and configured values.
- [ ] Sell ignores forged/invalid stored item values, trash IDs, mutations, and tool multipliers.
- [ ] Mutations and the currently equipped pet-team formula produce expected cash at sale time.
- [ ] Equipping or unequipping a pet after collection but before selling changes the resulting sale value.
- [ ] Cash flight/effect reaches HUD and comma formatting is correct.
- [ ] Empty backpack and repeated sell interactions are safe.

## Zones

- [ ] Locked barrier physically blocks the player.
- [ ] Unlock rejects insufficient cash.
- [ ] Unlock rejects missing previous-zone hatch flag.
- [ ] Successful unlock subtracts correct cash and persists.
- [ ] Barrier collision changes only for the unlocked player.
- [ ] Walking into a zone shows the rising/fading current-zone popup.
- [ ] Teleport lists all configured zones.
- [ ] Locked teleport cards are dark, show `???`, and cannot teleport.
- [ ] Unlocked teleport lands in front of that zone's sell station.
- [ ] Teleport is rejected during active collection and while cooling down.

## Pets and eggs

- [ ] Correct zone egg UI opens from each market.
- [ ] Cash price, zone unlock, distance, hatch count, and capacity are server-validated.
- [ ] 1× and 3× work only when allowed/affordable.
- [ ] Hatch animation completes without white crack artifacts or stuck blur/UI.
- [ ] New pet enters inventory/discovery but is not auto-equipped.
- [ ] Permanent `HatchedZones` prerequisite is set.
- [ ] Equip spam cannot deadlock the UI or server state.
- [ ] Maximum three equipped pets.
- [ ] Team multiplier is the additive total and summary is always green with a black stroke.
- [ ] Equipped star appears without changing default inventory order.
- [ ] Default/Multiplier/Rarity/Zone sorts and directions work.
- [ ] Pet collection uses three columns and locked silhouettes.

## Diamonds and tools

- [ ] Successful collection rolls Diamonds exactly once.
- [ ] Diamond amount and chance match the zone, but credit the correct world wallet.
- [ ] World 1 Diamonds work from all World 1 zones.
- [ ] Every World 1 tool-crate entrance opens the same crate.
- [ ] 1× costs 15 and 3× costs 45 World 1 Diamonds.
- [ ] Insufficient Diamonds, wrong world, invalid count, and full inventory are rejected.
- [ ] Tool result enters inventory/discovery.
- [ ] Maximum one tool equipped; equip spam remains recoverable.
- [ ] Tool stats affect collection speed/extra trash/mutation odds as configured.
- [ ] Tools UI rarity backgrounds, full preview, summary, and sorting render correctly.

## UI/responsive

- [ ] Shop, Teleport, Collection, Pets, and Tools open/close repeatedly.
- [ ] Only one major modal remains active.
- [ ] Blur turns on/off cleanly.
- [ ] Buttons have one click sound and one motion response.
- [ ] Scroll content is reachable and does not overlap progression/summary areas.
- [ ] Navigation, backpack, cash, and World 1 Diamonds remain on-screen at desktop and narrow/mobile sizes.
- [ ] Figma image text is not duplicated by Roblox labels.
- [ ] Dynamic text has readable stroke/contrast.

## Data persistence

- [ ] New profile receives all defaults.
- [ ] Old-shaped profile reconciles without a wipe.
- [ ] Cash, Diamonds, zones, collection, pets, tools, discoveries, and equipment persist after rejoin.
- [ ] Disconnect during collection/hatch/crate does not duplicate or lose rewards/currency.
- [ ] Admin commands are permission-gated and do not crash the client display.

## Final handoff

- [ ] Studio Output captured/checked after final test.
- [ ] Place stopped, saved, and optionally published as a named version.
- [ ] `docs/CHANGELOG.md` updated.
- [ ] Balance/contracts/roadmap docs updated if behavior changed.
