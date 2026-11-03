# Project Changelog

This changelog begins with a consolidated handoff snapshot. Add future entries at the top with date, scope, Studio place version if known, validation performed, and remaining placeholders.

## 2026-09-15 — Tool-free promotional direction

- Replaced the active `MAX TOOL!` progression thumbnail with `assets/promotional-art-v1/trash-collector-max-pets-thumbnail-v1.png`, showing pet progression and empty-handed avatars with no player tools.
- Moved the superseded tool-focused image to `assets/promotional-art-v1/archive/removed-tool-concepts/trash-collector-max-tool-thumbnail-v1.png` so it cannot be mistaken for current promotional direction while remaining recoverable.
- Validation: visually inspected the replacement and confirmed a 1672×941 RGB PNG at an effective 16:9 aspect ratio. Promotional art only; live Roblox Studio systems and project design documents were not changed.

## 2026-09-15 — Five additional promotional thumbnails

- Added five original promotional images under `assets/promotional-art-v1/`: Cosmic mutation discovery, Triple Hatch jackpot, Backpack Full sell run, World's End unlock, and three-stage tool evolution.
- Validation: visually inspected all five compositions and confirmed each is a 1672×941 RGB PNG at an effective 16:9 aspect ratio. Promotional art only; none has been uploaded or connected in Roblox Studio.

## 2026-09-15 — Noob-to-Pro promotional thumbnail

- Added `assets/promotional-art-v1/trash-collector-noob-to-pro-thumbnail-v1.png`, an original split-screen progression thumbnail showing a Downtown rookie advancing into a late-game landfill collector with upgraded gear, pets, coins, and Diamonds.
- Validation: visually inspected the rendered composition and confirmed a 1672×941 RGB PNG at a 1.7768:1 aspect ratio, effectively 16:9. Promotional art only; it has not been uploaded or connected in Roblox Studio.

## 2026-09-13 — Daily login reward UI icon

- Added `assets/ui-icons-v1/ui_daily_login_reward.png`, a text-free calendar, check-mark, gift, and coin icon matching the existing glossy blue-and-gold simulator UI style.
- Validation: confirmed a 1254×1254 32-bit RGBA PNG with transparent corners and visually checked the cutout on a contrasting background. Art asset only; it has not been uploaded or connected in Roblox Studio.

## 2026-09-12 — Egg crack moved to animation start

- Moved `EggCrack` to the beginning of the normal hatch presentation, immediately after the Fast Hatch early return and before the darkness and egg-entrance tween.
- Removed the former slow-shake trigger so the sound plays exactly once during a normal hatch. Fast Hatch continues to skip `EggCrack`, while `EggResult` remains tied to the pet reveal.
- Preserved the pre-change module at `ServerStorage.CodexAudioBackups.EggCrackAnimationStartBefore_20260912`. `EggShopUI` compiled and source validation confirmed one crack call in the intended position with the separate result call intact.

## 2026-09-12 — Egg crack sound timing

- Moved `EggCrack` from the white-flash/result boundary into the fifteenth shake keyframe, giving it approximately 1.58 seconds before the pet reveal while leaving `EggResult` at the reveal itself.
- Preserved the pre-change module at `ServerStorage.CodexAudioBackups.EggCrackTimingBefore_20260912`. `EggShopUI` compiled, contains one crack call site inside the pre-reveal shake loop, and retains its separate result call.

## 2026-09-11 — Gameplay SFX slot and event system

- Added nine empty, user-fillable `SoundService.GameSFX` slots for button hover, successful selling, coin/collection pop, zone unlock, collection loop, egg crack, egg result, verified Robux purchase, and active upgrade-button presses. Collection completion intentionally reuses `CoinPop`.
- Added `SoundController` with SFX-group routing, safe empty-ID handling, overlapping one-shot playback, loop start/stop support, and automatic hover binding for existing and dynamically created active buttons.
- Connected sounds to server-confirmed sell, zone, and Shop results; active upgrade-button presses; collection session start/result; the exact sell-coin HUD arrival; and the normal egg crack plus both normal/Fast Hatch result reveals. Failed sell, zone, and Robux actions do not play their success sounds.
- Preserved the pre-change scripts at `ServerStorage.CodexAudioBackups.GameplaySFXHooksBefore_20260911`. All nine changed/new scripts compiled; nine-slot hierarchy, fourteen hook, SFX-group, success-gating, empty-ID safety, no-runtime-leak, and temporary-module cleanup assertions passed. SoundIds remain intentionally empty for the user's audio imports.

## 2026-09-11 — Batch-safe pet capacity and storage-pass offer

- Kept pet storage authoritative in `PetHatchService` and extracted a reusable capacity check that validates the whole requested batch before cash deduction or pet rolls: 1× requires one free slot and 3× requires three.
- Expanded `InventoryFull` results with owned count, total capacity, hatch amount, and missing slots. Non-owners receive the server-suggested `PetStorage50` key; verified +50 Pet Storage owners never receive a duplicate pass suggestion.
- Updated `EggShopUI` to show the server's exact capacity message and automatically open the +50 Pet Storage Game Pass prompt only for an eligible non-owner.
- Preserved the pre-change modules at `ServerStorage.CodexMonetizationBackups.PetCapacityPromptBefore_20260911`. Both scripts compiled, and isolated checks passed for 50/50 1× rejection, 49/50 3× rejection needing two slots, exact 47/50 3× allowance, 50/100 owner allowance, 100/100 owner rejection without a pass suggestion, and temporary-service cleanup.

## 2026-09-11 — Cash leaderboard column readability

- Realigned the authored board's header and row templates to the same 94%-width grid, widened the cash column, and added 12-pixel gaps between rank, player, and cash so values no longer collide.
- Left-aligned player names, right-aligned cash, replaced uneven per-label scaling with fixed 26-pixel headers and 28-pixel rows, and retained end truncation for unusually long usernames.
- Preserved the pre-adjustment board at `ServerStorage.CodexBackups.CashLeaderboardLayoutBefore_20260911`. A real rank row (`#1`, `@iCopter0`, `$2.14Qa`) passed text-bound, alignment, fixed-size, gap, OrderedDataStore-read, and temporary-cleanup assertions.

## 2026-09-11 — Global cash leaderboard

- Reused the authored `Workspace.LeaderboardFolder.Leaderboard` model and connected it to a new server-authoritative `LeaderboardService` backed by an OrderedDataStore of current cash balances.
- Disabled the model's incompatible legacy script, which searched for a player descendant `Cash` value, and raised its two-second refresh setting to 120 seconds to protect DataStore request budgets.
- Added highest-cash-first rows with cached username resolution, compact dollar formatting, medal colors for the top three, stale-row cleanup, automatic vertical canvas sizing, and a safe unavailable state when DataStore access fails.
- Wired periodic publication plus final player-removal/server-shutdown snapshots, while refusing to publish temporary `_loadFailed` profiles. Preserved the pre-change model and bootstrap under `ServerStorage.CodexBackups.CashLeaderboardBefore_20260911`.
- Validation: a fresh clone of `LeaderboardService` compiled; initialization rendered and cleaned its generated loading row; an actual OrderedDataStore read returned `@iCopter0` as rank 1 with compact `$2.14Qa` cash; source/hierarchy assertions confirmed the single bootstrap wiring, disabled legacy script, 120-second refresh, top-100 bound, automatic vertical canvas, backup, and no temporary clones. The MCP bridge started a one-player test but attached no runtime client/server, so final in-viewport confirmation during a normal Studio Play remains pending.

## 2026-09-11 — Global top purchase-status toast

- Moved the runtime `PurchaseStatusLabel` out of `ShopMenuRoot` and directly under the enabled `ShopMenu` ScreenGui, so purchase progress/results remain visible after the Shop modal closes.
- Restyled it as a responsive top-center banner: 82% viewport width capped at 920 pixels, 60 pixels high, 52%-transparent black background, Fredoka One text, and a state-colored outline.
- Preserved the pre-change Shop UI and menu at `ServerStorage.CodexMonetizationBackups.PurchaseToastTopBefore_20260911`. `ShopUI` compiled and global-parent, top-anchor, size, transparency, Z-index, and ScreenGui visibility assertions passed. The bridge started without attaching a runtime client, so final visual confirmation remains pending.

## 2026-09-11 — Authoritative monetization UI states

- Wired the Shop's existing Buy, Owned, and Purchased artwork into the live purchase flow. A selected card is disabled with `WAIT...` while the Roblox prompt, Game Pass ownership verification, or Developer Product receipt is pending; cancellation and failure restore the Buy state.
- Game Pass cards become Owned only after the server rechecks ownership. Repeatable Developer Products show Purchased for three seconds only after the server persists the receipt, then return to Buy.
- Added a large Fredoka One status panel with opening, verifying, processing, cancelled, failed, and successful states. Cash-product success includes the server-authoritative compact reward amount, such as `POCKET CASH PURCHASE SUCCESSFUL! +$2.85K CASH`; timed boosts show their added minutes.
- Preserved the pre-change Shop modules and GUI at `ServerStorage.CodexMonetizationBackups.PurchaseUIStatesBefore_20260911`. `ShopUI`, `ShopController`, and `ServerBootstrap` compiled; source-contract and ButtonStates hierarchy checks passed. The Studio bridge started a test without attaching a runtime client, so a real Marketplace prompt remains to be verified.

## 2026-09-11 — Compact UI number suffixes

- Added `NumberFormat.Compact` and routed the shared UI formatter through it. Player-facing HUD/menu values now use `K`, `M`, `B`, `T`, and higher suffixes with up to three significant digits; for example `100,000,000` becomes `100M`, `1,000,000,000` becomes `1B`, and `1,000,000,000,000` becomes `1T`.
- Updated the sell-success reward banner, which previously bypassed `Theme.FormatNumber`, to call `NumberFormat.Compact` directly; large sales now display like `+$1.5B` or `+$228T`.
- Kept `NumberFormat.Commas` unchanged for exact server/admin messages. Preserved the pre-change modules at `ServerStorage.CodexNumberFormatBackups.CompactNumbersBefore_20260911`.
- All three edited modules compiled and boundary tests passed from `999` through `228T`, including negative values, sell-banner output, and exact-comma regression coverage. The sell-controller backup is at `ServerStorage.CodexNumberFormatBackups.CompactSellDisplayBefore_20260911`. The bridge started a one-player test but attached no runtime client, so final visual confirmation remains pending.

## 2026-09-11 — Permanent buff right alignment

- Tightened the transparent `PermanentCash2x` layout box and moved the complete icon/text group to the same rendered right edge as the temporary cash boost badge.
- Preserved the pre-change HUD at `ServerStorage.CodexMonetizationBackups.PermanentBuffAlignmentBefore_20260911`. The HUD compiled and right-edge assertions passed; the Studio bridge started the test but attached no runtime client, so final visual confirmation remains pending.

## 2026-09-11 — Responsive buff edge alignment

- Fixed `UIScale` shrinking the transparent buff cluster inward from the bottom-right. The HUD now compensates for its rendered scale, keeping the visible right and bottom edges at a consistent 12-pixel margin at desktop and narrow viewport scales.
- Applied the same bottom-edge compensation to backpack/cash and renamed the timed cash label to `2X CASH BOOST` to distinguish it from the permanent pass.
- Preserved the pre-change HUD at `ServerStorage.CodexMonetizationBackups.BuffAlignmentBefore_20260911`. The HUD compiled and scale-math assertions passed for 0.72×, 0.78×, 1×, and 1.08×. The bridge again started without attaching a runtime client, so final visual confirmation remains pending.

## 2026-09-11 — Repeatable temporary 2× Cash

- Enabled the `CashBoost` Developer Product at ID `3712279243`. A persisted receipt grants 15 minutes of 2× trash-sale cash, and every distinct additional purchase extends the current expiry by another 15 minutes.
- Reused `Monetization.ActiveBoosts.Cash2xExpiresAt`, so the existing bottom-right HUD timer updates from the server snapshot and Starter Pack time combines naturally with purchased time. The temporary boost stacks with Permanent 2× Cash for 4× trash-sale cash but does not affect pet resale, admin grants, or Robux cash packages.
- Extended the existing receipt-idempotency ledger and single `ProcessReceipt` path to the boost; duplicate receipt delivery cannot add time twice. Updated the Shop description and persisted-result message.
- Preserved three pre-change modules at `ServerStorage.CodexMonetizationBackups.TemporaryCashBoostBefore_20260911`. All three scripts compiled; fresh-module tests passed the initial 900 seconds, additive 900-second extension, duplicate guard, unchanged direct cash, 2×/4× stacking, and existing cash-package flow. Live product lookup confirmed the product is for sale at R$79. A production purchase remains to be verified.

## 2026-09-11 — Progression cash Developer Products

- Enabled repeatable `PocketCash`, `CashBag`, and `CashVault` Developer Products at IDs `3712279056`, `3712279152`, and `3712279199`.
- Added the experience's single server `MarketplaceService.ProcessReceipt` handler. It accepts only enabled configured cash products, calculates rewards on the server, persists each `PurchaseId` before acknowledgment, and safely treats receipt retries as already processed.
- Cash rewards use the highest unlocked zone and represent 5, 20, or 60 minutes of that zone's configured next-goal pace, capped at 15%, 40%, or 80% of the goal. The final zone uses ten current-zone eggs as its reference goal. Pet, permanent-cash, and temporary-cash multipliers are intentionally excluded.
- The Shop now explains the time/cap policy and shows the exact comma-formatted cash grant after a successful persisted receipt. Added backward-compatible `Monetization.ProcessedDeveloperReceipts` data.
- Preserved six pre-change modules at `ServerStorage.CodexMonetizationBackups.CashProductsBefore_20260911`. All six edited scripts compiled; isolated fresh-module tests passed all ten zones, all three products, Downtown rewards of `$2,850`/`$7,600`/`$15,200`, the final-zone fallback, duplicate receipt rejection, and disabled/unknown product rejection. The bridge started a one-player test but attached no runtime instance or output, so a production purchase remains to be verified after a fresh Studio session.

## 2026-09-11 — Bottom-edge HUD anchoring

- Anchored backpack and cash to the bottom-left and moved the transparent active-buff cluster closer to the bottom-right, using a 12-pixel safe margin on both sides.
- Removed the player-stats dependency on `NavigationUI.NavigationRoot`, so navigation layout changes no longer move the cash/backpack block.
- Preserved the pre-change HUD module at `ServerStorage.CodexMonetizationBackups.BottomEdgeHUDBefore_20260911`; the edited HUD compiled and its anchor/position contracts passed.

## 2026-09-11 — Bottom-right transparent buff HUD

- Moved the runtime `ActiveBuffs` cluster out of the left-side player-stats panel and anchored it to the bottom-right safe area.
- Removed the green and purple card backgrounds while retaining large cash/luck icons, Fredoka One labels, countdowns, and strong black outlines for readability over the world.
- Enlarged the permanent and temporary boost presentation and added responsive one-boost/two-boost positioning without changing entitlement, stacking, or expiry behavior.
- Preserved the pre-change HUD module at `ServerStorage.CodexMonetizationBackups.BuffHUDLayoutBefore_20260911`. The edited HUD module compiled successfully; a fresh visual playtest remains pending because the Studio bridge still reports a stale running test with no attached instances.

## 2026-09-11 — Starter Pack Game Pass

- Enabled the one-time `StarterPack` Game Pass at Marketplace ID `1975556729` and added server-verified ownership reconciliation through the existing Shop flow.
- A first verified claim grants exactly `$5,000`, one unequipped 50× Epic `StarterRecycler`, 15 minutes of 2× trash-sale cash, and 15 minutes of +100% egg luck. `StarterRecycler` currently reuses the Downtown raccoon model as a replaceable placeholder and cannot be sold.
- Added backward-compatible `OwnedGamePasses.StarterPack`, `StarterPackClaimed`, and persisted `ActiveBoosts` expiry fields. Repeated join/purchase reconciliation cannot duplicate any reward.
- Temporary cash stacks multiplicatively with Permanent 2× Cash for 4× trash-sale cash. Temporary luck adds one best-of rarity roll and stacks with Permanent +400% Luck for six rolls; the Egg Menu and server hatch path use the same shared calculation.
- Added compact HUD countdown badges for both timed boosts. Preserved the nine pre-change modules at `ServerStorage.CodexMonetizationBackups.StarterPackBefore_20260911`.
- Validation: all nine affected modules compiled; fresh-module tests passed exact rewards, no auto-equip, 15-minute expiries, one-time idempotence, protected resale, 2×/4× cash, and 2/5/6-roll luck. No validation objects remain and Studio Output contains no new game errors. The bridge accepted a one-player start but did not attach a server/client process, so final purchase-prompt and visual confirmation remain pending.

## 2026-09-11 — Permanent Cash HUD buff and five-pet formation

- Added a compact green/gold `2X CASH` permanent-buff badge below the cash HUD. It is driven only by the server-reconciled `Monetization.OwnedGamePasses.PermanentCash2x` snapshot and stays hidden for non-owners.
- Added dedicated four- and five-pet follower formations. Five pets now form a wide symmetric arc instead of falling through to the cramped generic three-column grid.
- Preserved the pre-change client modules at `ServerStorage.CodexMonetizationBackups.CashBuffAndPetFormationBefore_20260911`.
- Validation: both edited modules compiled; the ownership-binding source contract passed; the four- and five-pet layouts have the correct slot counts and minimum center spacing of 3.65 and 3.68 studs respectively. Studio Output contained no new task-related errors. The bridge accepted a one-player start but did not attach a server/client process, so final in-game visual confirmation remains pending.

## 2026-09-11 — Permanent 2× Cash pass

- Enabled `PermanentCash2x` and added its backward-compatible `Monetization.OwnedGamePasses.PermanentCash2x` entitlement default.
- Extended `ShopService` join-time and post-prompt server ownership reconciliation to Marketplace pass ID `1976750705`; the existing Shop card now transitions to `OWNED` through the shared data-driven UI flow.
- Applied the configured 2× multiplier exactly once to the final server-authoritative trash-sale total, after trash values, mutations, and the current pet team are resolved. Pet resale, admin grants, and future Robux cash products are intentionally unchanged.
- Preserved the pre-change modules at `ServerStorage.CodexMonetizationBackups.PermanentCashBefore_20260911`.
- Validation: all four affected scripts compiled; fresh-module tests passed six-enabled-pass reconciliation, old-profile fallback, unchanged base sale value, exactly-once doubling, and exact cash credit. Live `UserOwnsGamePassAsync` verification succeeded for the connected account, and no validation clones remain.

## 2026-09-11 — Egg Game Passes

- Enabled `TripleHatch`, `FastHatch`, and `EggLuckBoost400`, bringing the implemented permanent-pass set to five while leaving all Developer Products and the remaining permanent passes disabled.
- Added server-authoritative Triple Hatch validation. Pressing the locked 3× egg button opens Roblox's purchase prompt; a forged 3× request is rejected before cash or inventory changes.
- Added a saved `Monetization.FastHatchEnabled` preference and a compact ON/OFF switch below the egg buttons. Verified owners may skip directly to the result presentation; unowned switch clicks open the Fast Hatch purchase prompt.
- Added a clickable +400% Luck badge at the right side of the Egg Menu. Owners see `+400% LUCK ACTIVE`, and the displayed egg chances update to the same server formula used for hatching.
- Implemented +400% Luck as five independent base-rarity rolls with the rarest result kept. Current chances change from 45/30/15/9.9/0.1% to approximately 1.845/21.885/35.319/40.452/0.499% for Common through Legendary.
- Added backward-compatible entitlement flags for all three egg passes and a validated `Pet.SetFastHatchEnabled` remote. Saved the pre-change scripts and Egg Menu at `ServerStorage.CodexMonetizationBackups.EggPassesBefore_20260911`.
- Validation: nine affected scripts compiled; five-pass config/reconciliation, Fast Hatch ownership and idempotence, rarity totals, Triple Hatch denial/success, 5× luck application, and no-auto-equip behavior passed isolated tests. Live ownership checks succeeded for all five enabled passes on the connected account. No validation clones remain. A real one-player start was requested, but the Studio bridge reported a running test without starting a server/client instance, so final visual interaction remains to be checked after restarting Studio.

## 2026-09-11 — Simple permanent pet passes

- Enabled the `ExtraPetSlots` and `PetStorage50` Game Passes while leaving the other ten configured Shop products disabled.
- Added backward-compatible entitlement fields under `Monetization.OwnedGamePasses` and derived pet bonuses under `Pets.GamePassEquipSlotBonus` / `Pets.GamePassStorageBonus`.
- Added server ownership reconciliation at join and a server recheck after a completed purchase prompt. Client prompt events and client data never grant either benefit.
- `+2 Equip Slots` raises the pet equip limit from 3 to 5 everywhere: equip validation, full-team oldest-pet replacement, income calculation, follower rendering, and inventory summary. `+50 Pet Storage` raises capacity from 50 to 100 while preserving the existing non-pass `Pets.StorageBonus` path.
- Shop cards now render `OWNED` from reconciled player data. Preserved the nine pre-change scripts/configs at `ServerStorage.CodexMonetizationBackups.SimplePassesBefore_20260911`.
- Validation: all ten affected Studio modules compiled; old-profile reconciliation, capacity/equip limits, five-pet income, oldest-pet replacement, clamping, and revocation passed isolated fresh-module tests. Live `UserOwnsGamePassAsync` checks succeeded for both passes, validation clones were removed, and Studio Output contained no new task-related errors. The Studio playtest controller remained stuck in its pre-existing `A test is already running` state, so a fresh end-to-end purchase prompt was not run.

## 2026-09-11 — Shop live-price and purchase-prompt connection

- Connected every live Shop card to `MonetizationConfig` and client-side `MarketplaceService:GetProductInfo`, including comma-formatted live Robux prices and OFF SALE/failure fallbacks.
- Routed configured Game Passes to `PromptGamePassPurchase` and Developer Products to `PromptProductPurchase`, with one-prompt-at-a-time protection and cancellation/submission feedback.
- Preserved the security boundary: all 12 config entries remain disabled, so clicks continue to show Coming Soon and cannot charge players until server ownership/receipt effects are implemented. Prompt-finished events are presentation signals only and never grant rewards.
- Preserved the pre-change module at `ServerStorage.CodexMonetizationBackups.ShopUIBeforeButtonConnection_20260911`.
- Validation: `ShopUI` passed Luau compilation and source-contract checks for config use, both prompt routes, live-price lookup, and the enabled gate. A one-player startup captured no output errors; direct MCP introspection of the running client timed out, so visual verification of all 12 returned price labels remains pending.

## 2026-09-11 — Royal Recycler Raccoon turnaround concept

- Added `assets/pets/premium/royal-recycler-raccoon-turnaround-v1.png`, a white-background modeling sheet showing consistent front, left-profile, rear, and right-profile views of the proposed Premium Pet.
- Locked the concept around royal-blue and silver raccoon markings, a gold crown, emerald recycling medallion, striped tail, and a cobalt-and-gold diamond trash-grabber backpack with folded mechanical arms.
- Validation: confirmed the 2043×770 RGB PNG opens correctly and shows exactly four complete, evenly scaled views. This is concept art only and has not been added to the authoritative Studio pet configuration or models.

## 2026-09-11 — Central monetization configuration

- Added `ReplicatedStorage.Shared.Config.MonetizationConfig` as the single shared contract for all seven Game Passes and five Developer Products.
- Recorded the 12 supplied Marketplace IDs, live Shop order/sections, permanent and temporary effect metadata, 15-minute boost durations, and progression-based Cash-package rules.
- Deliberately omitted hardcoded display prices and started every product with `Enabled = false`; future UI must request the player-facing price from `MarketplaceService`, and future server services must explicitly enable validated effects.
- Left the Premium Pet and Starter Pack pet IDs blank instead of inventing rewards. Preserved the prior config folder at `ServerStorage.CodexMonetizationBackups.ConfigBeforeMonetization_20260911`.
- Validation: fresh-source compilation and execution passed with 12 unique IDs, 12 matching live Shop cards, reverse ID lookup, valid InfoTypes, zero enabled products, and zero hardcoded prices.

## 2026-09-11 — Transparent-background shop artwork pack

- Added non-destructive transparent-background copies of nine supplied shop images under `assets/game-passes/transparent-bg-pack`, plus `assets/game-passes/game-pass-transparent-pack-v1.zip` for delivery.
- Preserved the existing product artwork, titles, decorative sparkles, colored glows, and canvas dimensions while removing only the white backdrops.
- Validation: confirmed all nine outputs are 1254×1254 `Format32bppArgb` PNGs with genuine transparent canvas corners; the ZIP contains exactly nine files. The original white-background images remain unchanged.

## 2026-09-11 — Permanent +400% Egg Luck pass

- Converted the existing `EggLuckBoost400` shop card from a temporary Boost into a permanent Game Pass and moved it to the sixth slot of `GamepassesSection`.
- Updated its live name and description to communicate permanent five-times-normal egg luck while preserving the existing product key and icon contract.
- Preserved the pre-change Shop and `ShopUI` at `ServerStorage.CodexShopBackups.ShopBeforePermanentEggLuck_20260911`.
- The ownership effect and Marketplace ID remain intentionally inactive until the final Game Pass ID is supplied.

## 2026-09-10 — Cash and pet-storage product art

- Added white-background product images for Permanent 2× Cash, +50 Pet Storage, and the temporary 2× Cash Boost under `assets/game-passes/white-bg-pack`.
- Distinguished the permanent cash pass with a vault and infinity emblem, the storage pass with an expanded empty-slot vault, and the temporary cash boost with a stopwatch and speed arrows.
- Validation: confirmed all three text-labeled PNGs are 1254×1254 with clean near-white corners. These are art assets only and have not been uploaded or connected in Studio.

## 2026-09-10 — Shop product-icon slot cleanup

- Removed the nine obsolete `ShopMenu.AssetSlots.ProductIcons` entries for VIP, Bigger Backpack, Speed Runner, Collection Speed Boost, Backpack Boost, +100% Egg Luck, Mutation Luck Boost, Mega Vault, and Premium Egg.
- Kept exactly one icon slot for each of the 12 live shop products and cleared `PremiumPet`, `PermanentCash2x`, and `PetStorage50` so final artwork can be inserted directly without changing product keys.
- Preserved the pre-cleanup icon folder at `ServerStorage.CodexShopBackups.ShopIconsBeforeCleanup_20260910`.
- Validation: confirmed 12 live product keys map one-to-one to 12 icon slots, all three new slots are blank, obsolete slots are absent, the recovery copy exists, and `ShopUI` still compiles.

## 2026-09-10 — Final Robux Shop card lineup

- Reordered the live Shop so Premium Pet appears first, followed by Starter Pack, permanent game passes, temporary boosts, and cash packs.
- Reused the existing long/small product templates for 12 current cards: Premium Pet, Starter Pack, Triple Hatch, Fast Hatch, +2 Equip Slots, Permanent 2× Cash, +50 Pet Storage, 2× Cash Boost, +400% Egg Luck, Pocket Cash, Cash Bag, and Cash Vault.
- Removed VIP, Speed Runner, Bigger Backpack, Collection Speed Boost, Backpack Boost, +100% Egg Luck, Mutation Luck Boost, Mega Vault, and Premium Egg from the live lineup. Six obsolete standalone cards were moved to `ShopMenu.Templates.ArchivedProductCards`; repurposed cards and all original artwork remain recoverable from `ServerStorage.CodexShopBackups.ShopBeforePremiumPet_20260910`.
- Added `PremiumPet`, `PermanentCash2x`, and `PetStorage50` icon slots so final images can be inserted without changing product keys.
- Product effects and Marketplace IDs remain intentionally inactive; purchase buttons continue to show `R$ ---` and Coming Soon feedback.
- Validation: `ShopUI` passed Luau compilation; hierarchy checks confirmed five ordered sections, 12 unique live keys, matching card attributes/StringValues, icon slots, price placeholders, and six archived cards. The only Studio Output errors were the MCP plugin's unrelated missing icon asset `8532023742`.

## 2026-09-10 — Pet inventory capacity and duplicate resale

- Added a 50-slot base pet inventory with backward-compatible `Pets.StorageBonus`, a +50 premium-storage constant for future commerce wiring, and a shared capacity calculation used by hatch validation and the inventory UI.
- Added server-authoritative single-pet resale through `Pet.SellPet`: ownership, equipped state, UID shape, request rate, and configured value are validated before the pet is removed and cash is credited.
- Balanced resale from each pet's originating egg price at Common 12%, Uncommon 18%, Rare 30%, Epic 55%, and Legendary 100%, yielding a 20.845% expected refund at current hatch odds.
- Updated the Pet Menu with owned/capacity, exact comma-formatted sell value, a red Sell button, and a three-second two-click confirmation. Equipped pets must be unequipped before sale.
- Validation: all seven edited Studio scripts passed Luau compilation; fresh cloned config/service tests passed capacity bonus, all Downtown rarity prices, equipped protection, valid sale, duplicate rejection, invalid UID rejection, exact cash credit, and World's End scaling. Studio Output contained no error entries; the Studio playtest controller retained a stale `A test is already running` state after an earlier multi-client stop and prevented a fresh final UI run.

## 2026-09-10 — Text-only zone unlock billboards

- Replaced the white zone-unlock card, accent bar, and lock icon with a larger transparent `BillboardGui` containing only dynamic text.
- Restyled the zone title, prerequisite, collection-speed requirement, and unlock price with centered Fredoka One typography, four-pixel rounded dark outlines, offset shadows, and high-contrast semantic colors.
- Removed auto-scaling and its 12-pixel minimum after visual testing showed it made the labels too small; the billboard now uses a 1,000 × 260 canvas with fixed 54/36/33/46-pixel text sizes and a 60-stud viewing distance.
- Validation: `ZoneBarrierService` passed Luau syntax checks; all nine locked-zone gates rebuilt with no Frame, ImageLabel, or text-size constraints; the longest line uses 752 of 988 available pixels; and a one-player startup produced no captured Output errors.

## 2026-09-10 — Terrain-safe trash spawning and final gate opening

- Updated `TrashSpotService` to validate each randomized position against the real footprint of that zone's Small or Medium trash model, rejecting positions that intersect or sit beneath authored terrain, props, structures, markets, or sell stations.
- Removed the obsolete full-width `EndWall` and `EndTopAccent` from the live and recovery-template Nuclear Wasteland models, exposing the existing framed doorway to World's End while keeping the intended unlock barrier functional.
- Saved the pre-change Nuclear Wasteland model at `ServerStorage.ZoneModelBackups.NuclearWastelandZone_BeforeWorldsEndGateFix_20260910`.
- Validation: the service passed Luau syntax checks; a fresh isolated service generated all 300 player-specific spots across ten zones with zero terrain/prop intersections; the authored doorway aperture had no solid obstruction other than the intended unlock barrier; a one-player startup produced no captured Output errors.

## 2026-09-10 — Normal trash white outline

- Added a crisp, no-fill white silhouette to non-mutated trash models while preserving the existing colored highlights, particles, and lights for Gold, Infected, and Cosmic trash.
- Distance-gated all trash highlights to the nearest 30 spots within 80 studs so synchronizing all ten zones does not exhaust Roblox's active `Highlight` budget; nearby mutations retain their original colors.
- Validation: `TrashSpotController` passed Luau syntax and source-contract checks; a one-player startup completed with no captured Output errors.

## 2026-09-10 — Downtown small trash-pot remodel

- Replaced `ReplicatedStorage.TrashModels.Downtown_Small` with a 41-part, concept-matched blue street bin featuring a domed lid, reinforced rims and ribs, trash bags, newspaper, drink can, bottle, and pizza details.
- Preserved the exact model name, `MainBody` primary-part contract, Downtown/Small attributes, anchored non-collidable client-render geometry, and ground-relative spawn pivot. Saved the original model under `ServerStorage.TrashModelBackups.Downtown_Small_BeforeRemodel_20260910`.
- Validation: model contract checks passed with 41 parts, no scripts, no collision/touch/query, a 4.706-stud vertical silhouette, a 0.060-stud ground clearance after the production placement transform, and no new Output errors after a one-player startup check.

## 2026-09-09 — Authored zone-model persistence

- Made a complete `Workspace.ZoneWorld` containing all ten valid `<ZoneKey>Zone` models the first runtime source of truth, so startup keeps the hand-positioned models instead of deleting them. Matching recovery templates live under `ServerStorage.ZoneModelTemplates`, with a complete pre-change world copy under `ServerStorage.CodexZoneBackups`.
- Updated `ZoneWorldService` to normalize the authored models' zone attributes, `Floor`, and `PrimaryPart`; only an incomplete or missing Workspace world falls back to stored templates and then procedural creation.
- Kept the nine handmade World's End Landfill terrain objects and excluded its obsolete generated compactor/polish terrain. Anchored all authored template geometry and kept nine embedded imported-model scripts disabled.
- Validation: `ZoneWorldService` compiled through `loadstring`; all ten templates passed exact name, zone attribute, `Floor`, `PrimaryPart`, anchoring, and script-state checks. A direct fresh-module startup test retained the same ten Workspace zone instances, a one-player startup test added no new task-related Output errors, and Studio returned to a stopped state.

## 2026-09-09 — Ten-zone small/medium trash-pot concept pack

- Added 20 text-free white-background PNG concepts under `assets/trash-pots`: separate Small and Medium trash pots for Downtown, Beach, Factory, Junkyard, Sewers, Frostbite, Haunted Carnival, Toxic Swamp, Nuclear Wasteland, and WorldEnd.
- Gave each Medium design a structurally distinct silhouette rather than scaling its Small counterpart, while carrying zone-specific trash and materials into both tiers.
- Validation: confirmed exactly 20 images at 1254×1254 with clean near-white corners. These are art/reference assets only; they have not been uploaded or connected in Studio, and Nuclear Wasteland and WorldEnd remain future-zone concepts rather than configured progression content.

## 2026-09-09 — Transparent player-speed icon

- Added `assets/ui-icons-v1/ui_upgrade_player_speed.png`, a text-free winged running-shoe icon that visually distinguishes movement speed from collection speed.
- Validation: confirmed a 1254×1254 RGBA PNG with genuine transparent corners and intact foreground artwork. The asset has not been uploaded or connected in Studio.

## 2026-09-09 — Transparent upgrade-stat icon set

- Added separate text-free PNG icons for Collection Speed, Extra Trash, and Mutation Luck under `assets/ui-icons-v1`.
- Validation: confirmed all three files are 1254×1254 RGBA images with genuine transparent corners and opaque foreground artwork. The assets have not been uploaded or connected in Studio.

## 2026-09-09 — Seven-zone egg PNG set

- Completed a coordinated white-background egg-art set under `assets/eggs` for Junkyard, Sewers, Frostbite, Haunted Carnival, Toxic Swamp, Nuclear Wasteland, and WorldEnd.
- Added six new 1254×1254 PNGs while preserving the previously approved `junkyard-egg-v1.png`; every egg is text-free and uses the same centered, thick-outlined simulator style.
- Validation: confirmed all seven files open as square PNGs with clean near-white corner backgrounds. These are art assets only; Nuclear Wasteland and WorldEnd have not been added to authoritative Studio configs or progression.

## 2026-09-09 — Transparent upgrade icon

- Added `assets/ui-icons-v1/ui_upgrade.png`, a text-free blue-arrow, gold-gear, and lime-chevron upgrade icon matching the simulator UI style.
- Validation: confirmed a 1254×1254 RGBA PNG with genuine transparent pixels and fully opaque icon artwork. The asset has not been uploaded or connected in Studio.

## 2026-09-08 — Downtown bird's-eye zone concept

- Added `assets/design-concepts/downtown-zone-top-view-v1.png`, a 1254×1254 top-down layout concept for the Downtown starting zone.
- Illustrated a west spawn, east progression gate, central road loop, recycling sell kiosk, zone egg market, shared tool-crate entrance, upgrade kiosk, open collection routes, and themed city-block dressing.
- Validation: confirmed the PNG opens successfully at 1254×1254. This is a visual planning asset only and has not changed the authoritative Studio layout or configs.

## 2026-09-08 — Three-type upgrade menu concept

- Added `assets/design-concepts/upgrade-menu-three-types-v1.png`, a 1536×1024 visual concept for Collection Speed, Extra Trash, and Mutation Luck upgrades.
- Kept levels, current/next values, prices, and status messaging as empty visual slots so Roblox can render authoritative dynamic values over the decorative artwork.
- Validation: confirmed the PNG opens successfully at the intended 1536×1024 dimensions. The concept has not been uploaded or connected to the live Studio hierarchy.

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
