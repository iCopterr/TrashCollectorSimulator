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
- [ ] Empty `SoundService.GameSFX` slots produce no errors; populated slots all obey `SFXGroup` volume and mute.
- [ ] Hover plays once when entering any active current or dynamically created button, without duplicating the existing click sound.
- [ ] Successful sell plays `SellSuccess`; each cash icon arrival plays `CoinPop`; an empty/failed sell plays neither.
- [ ] `TrashCollectLoop` starts with a valid collection, stops on success/MISS, and a successful item grant plays the shared `CoinPop` once.
- [ ] Successful zone unlock, egg crack, egg result reveal, and verified Robux purchase each play only their matching slot; every active upgrade-button press plays `UpgradePurchase` once.

## Collection

- [ ] Small and medium models render in every affected zone.
- [ ] Spots are player-specific/random and obey zone bounds/spacing.
- [ ] Locked-zone trash cannot be collected.
- [ ] Collection duration is affected correctly by equipped tools.
- [ ] Triggering the same spot again during an active collection is rejected without showing an `already collecting` banner.
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
- [ ] Permanent 2× Cash doubles the final trash-sale total exactly once after pet/mutation calculation.
- [ ] Permanent 2× Cash does not affect pet resale, admin cash grants, or Robux cash products.
- [ ] Equipping or unequipping a pet after collection but before selling changes the resulting sale value.
- [ ] Cash flight/effect reaches HUD and the sell-success banner uses compact suffix formatting (`K`, `M`, `B`, `T`).
- [ ] Empty backpack and repeated sell interactions are safe.

## Global cash leaderboard

- [ ] The authored `Workspace.LeaderboardFolder.Leaderboard` model remains intact and its bundled legacy script is disabled.
- [ ] The board headers read RANK, PLAYER, and CASH; generated rows preserve the template layout and the board scrolls vertically.
- [ ] Current authoritative cash is published on the server, including after spending, on player removal, and during shutdown.
- [ ] Rankings sort highest cash first and use compact dollar formatting; first, second, and third place use distinct medal colors.
- [ ] A profile with `_loadFailed` is never published as a zero/default record.
- [ ] Disabled Studio API access or a transient OrderedDataStore failure shows a safe unavailable state without stopping server startup.

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
- [ ] At 50/50 base storage, 1× is rejected before cash is spent and offers +50 Pet Storage only to a non-owner.
- [ ] At 49/50 base storage, 3× is rejected as needing two slots; at 47/50, exactly three pets can hatch.
- [ ] A +50 Pet Storage owner can use slots 51–100, receives no duplicate pass prompt at 100/100, and must sell pets before hatching again.
- [ ] 1× works when allowed/affordable; unowned 3× opens the Triple Hatch prompt and is rejected server-side if forged.
- [ ] Owned Triple Hatch spends exactly three egg prices and returns exactly three pets.
- [ ] Fast Hatch switch is locked without the pass, persists ON/OFF for owners, and skips only the egg animation—not result presentation.
- [ ] Permanent +400% Luck shows its right-side active badge, updates visible odds, and uses the identical server formula.
- [ ] Hatch animation completes without white crack artifacts or stuck blur/UI.
- [ ] New pet enters inventory/discovery but is not auto-equipped.
- [ ] Permanent `HatchedZones` prerequisite is set.
- [ ] Equip spam cannot deadlock the UI or server state.
- [ ] Maximum three equipped pets without the pass and five with `+2 Equip Slots`; a full team still replaces the earliest equipped pet.
- [ ] Four and five equipped followers use their dedicated wide formations, remain symmetric behind the player, and do not overlap while idle or moving.
- [ ] Pet capacity is 50 without bonuses and 100 with `+50 Pet Storage`, before any non-pass storage bonus.
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
- [ ] Navigation and World 1 Diamonds remain on-screen; scaled backpack/cash retain a 12px bottom-left margin and scaled active buffs retain a 12px bottom-right margin at desktop and narrow/mobile sizes.
- [ ] The enlarged, transparent `2X CASH` HUD buff appears at the bottom-right only for a server-reconciled `PermanentCash2x` owner and remains hidden for non-owners.
- [ ] The permanent cash icon/text group and a single temporary boost badge end on the same visible right edge at desktop and narrow/mobile sizes.
- [ ] Starter Pack temporary cash/luck buffs show correct `MM:SS` countdowns at the bottom-right, reflow without overlap for one or two active buffs, and disappear at zero.
- [ ] Figma image text is not duplicated by Roblox labels.
- [ ] Dynamic text has readable stroke/contrast.
- [ ] Shared UI numbers cross suffix boundaries correctly: `999`, `1K`, `100M`, `1B`, and `1T`; exact server/admin outputs still support comma formatting.

## Data persistence

- [ ] New profile receives all defaults.
- [ ] Old-shaped profile reconciles without a wipe.
- [ ] Cash, Diamonds, zones, collection, pets, tools, discoveries, and equipment persist after rejoin.
- [ ] Disconnect during collection/hatch/crate does not duplicate or lose rewards/currency.
- [ ] Admin commands are permission-gated and do not crash the client display.

## Monetization

- [ ] Seven implemented passes plus `CashBoost`, `PocketCash`, `CashBag`, and `CashVault` are enabled; only `PremiumPet` cannot open a purchase prompt.
- [ ] All seven active passes show the live Marketplace price before purchase and `OWNED` after server reconciliation.
- [ ] A clicked card shows disabled `WAIT...` state; cancelling or a failed verification restores Buy without granting anything.
- [ ] A verified Game Pass becomes Owned, while a persisted repeatable Developer Product shows Purchased for three seconds and then becomes buyable again.
- [ ] Successful cash products show `PURCHASE SUCCESSFUL` plus the server-confirmed compact cash amount; Cash Boost shows the server-confirmed added duration.
- [ ] Purchase progress/results appear in a long transparent black toast at the top-center and remain visible if the Shop modal closes.
- [ ] Join-time and post-prompt ownership checks use `UserOwnsGamePassAsync`; client prompt completion alone cannot grant a benefit.
- [ ] A verified Starter Pack ownership grants exactly $5,000, one unequipped `StarterRecycler`, and two 900-second boosts once; repeated reconciliation grants nothing.
- [ ] Starter Pack cash is 2× alone and 4× with Permanent 2× Cash; luck is 2 rolls alone, 5 with the permanent pass alone, and 6 when stacked.
- [ ] `StarterRecycler` cannot be sold and does not set a zone hatch prerequisite.
- [ ] Old profiles missing `Monetization` and Game Pass bonus fields reconcile without a wipe.
- [ ] A successful ownership result of `false` revokes the cached entitlement; an ownership API failure preserves the last verified saved state.
- [ ] Cash Developer Products resolve only through the single server `ProcessReceipt` callback; prompt-finished events never grant cash.
- [ ] Downtown Pocket/Bag/Vault receipts grant exactly `$2,850`, `$7,600`, and `$15,200`; each later zone uses its authoritative next-goal pace and cap.
- [ ] Cash-product grants ignore pets, Permanent 2× Cash, temporary cash boosts, and the player's client payload.
- [ ] A duplicate `PurchaseId` grants no additional cash, and receipt data is saved before `PurchaseGranted`; save failure returns `NotProcessedYet`.
- [ ] World's End uses ten zone eggs as the reference goal; unknown and disabled product IDs are not acknowledged or rewarded.
- [ ] A first `CashBoost` receipt adds exactly 900 seconds from server time; another distinct receipt adds 900 seconds from the existing expiry without resetting it.
- [ ] A duplicate `CashBoost` receipt adds no time, direct cash remains unchanged, and the bottom-right countdown reflects the saved expiry.
- [ ] Temporary Cash Boost produces 2× trash-sale cash alone and 4× with Permanent 2× Cash, without affecting pet resale, admin grants, or Robux cash packages.

## Final handoff

- [ ] Studio Output captured/checked after final test.
- [ ] Place stopped, saved, and optionally published as a named version.
- [ ] `docs/CHANGELOG.md` updated.
- [ ] Balance/contracts/roadmap docs updated if behavior changed.
