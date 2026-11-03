# Player Data and Security Contracts

## Current persistent schema

Authoritative template: `game.ReplicatedStorage.Shared.Config.PlayerDataTemplate`.

```text
Cash
Diamonds
  World1
DiamondDropPity
  World1
Backpack
  CapacityLevel
  Items[] = { Id, Rarity, Value, BaseValue, Mutation, MutationMultiplier, ToolMultiplier }
Equipment
  Tool
  ToolLevel
Zones
  Downtown, Beach, Factory, Junkyard, Sewers, FrostbiteHarbor, HauntedCarnival, ToxicSwamp
Collection
  [trashId] = true
Pets
  Inventory[petUid] = { PetId, HatchedAt, ... }
  Equipped[]
  HatchedZones[zoneKey] = true
  Discovered[petId] = true
  TotalHatches
  StorageBonus
  GamePassStorageBonus
  GamePassEquipSlotBonus
Monetization
  OwnedGamePasses
    StarterPack
    TripleHatch
    FastHatch
    ExtraPetSlots
    PermanentCash2x
    PetStorage50
    EggLuckBoost400
  FastHatchEnabled
  StarterPackClaimed
  ActiveBoosts
    Cash2xExpiresAt
    EggLuck2xExpiresAt
Tools
  Inventory[toolUid] = { ToolId, OpenedAt, WorldId, CrateId }
  Equipped
  Discovered[toolId] = true
  TotalOpens
Mutations
Rebirths
```

The actual data service may add metadata/session fields internally. Inspect it before changing persistence.

## Compatibility rules

- New fields must have safe defaults in `PlayerDataTemplate` and be reconciled into old profiles.
- New zones default to `false`; the starting zone alone defaults to `true`.
- New worlds require both a Diamond balance and a Diamond pity counter.
- Never derive permanent hatch progression only from current pet ownership. `Pets.HatchedZones` is permanent even if a pet is later deleted.
- Never reuse or silently change a persistent item/pet/tool ID. Display names may change; IDs should remain stable.
- Do not change array ↔ dictionary shape without a migration.
- Do not wipe live data to fix a schema bug. Write a targeted migration and test it with old-shaped fixtures.
- Data-wipe scripts must remain isolated, disabled/manual, and clearly named. They must never run from normal bootstrap.

## Server authority checklist

The server must own and validate:

- Cash and Diamond balances
- Backpack contents/capacity
- Trash reward selection and quantity
- Mutation and Diamond RNG
- Collection session timing and skill-check result
- Trash and pet sell value and inventory removal
- Egg/crate price, allowed open count, RNG, inventory capacity, and proximity
- Pet/tool ownership and equip limits
- Zone prerequisites, unlock price, and teleport destination
- Shop/Robux receipt effects
- Global cash leaderboard publication and ranking reads

The global leaderboard is a derived display index, not a second player-data authority. `LeaderboardService` reads `DataService.GetData(player).Cash` on the server, rejects temporary `_loadFailed` profiles, normalizes the value to a nonnegative safe integer, and writes only that snapshot to the ordered store. Gameplay must never read a player's spendable cash back from the leaderboard. Client input is not involved in publishing or ranking.

`ReplicatedStorage.Shared.Config.MonetizationConfig` is the shared identity/effect contract for Shop products. Its `MarketplaceId` values are selectors, not proof of ownership. Seven passes plus `CashBoost`, `PocketCash`, `CashBag`, and `CashVault` are enabled; only `PremiumPet` remains disabled until its server effect is implemented and tested. Client-supplied product keys, IDs, prices, ownership flags, and rewards are never authoritative. Display prices must come from `MarketplaceService` so managed/regional pricing is respected; configured prices must not be introduced as a fallback reward authority.

Client purchase prompts and `PromptGamePassPurchaseFinished` / `PromptProductPurchaseFinished` are presentation-only. Neither completion event proves that a reward may be granted. Developer Products must be granted idempotently through the single server `ProcessReceipt` callback, and permanent pass effects must be derived from server-verified ownership. The Shop may show verifying/processing after prompt completion, but it may show Purchased/Owned and a reward amount only from the server's `Shop.Result` after those checks succeed.

Cash-product receipts are resolved from the receipt's server-provided `ProductId`; the client never supplies the reward tier or amount. `ShopService` derives the amount from the highest unlocked zone, configured progression target, equivalent minutes, and next-goal cap. `Monetization.ProcessedDeveloperReceipts[PurchaseId]` is written with the cash grant, and `DataService.SaveData` must succeed before `PurchaseGranted` is returned. A save failure returns `NotProcessedYet`; an in-memory processed ID prevents that retry from granting cash twice while the server remains alive.

The temporary `CashBoost` uses the same receipt rules. A distinct receipt advances `ActiveBoosts.Cash2xExpiresAt` from the later of the current expiry or current server time; therefore purchases add duration instead of resetting or shortening it. Duplicate receipt IDs do not advance the timestamp.

For the seven active passes, `ShopService` verifies ownership with `MarketplaceService:UserOwnsGamePassAsync` at join and rechecks after a completed prompt before changing saved entitlements. `Monetization.OwnedGamePasses` is the server-owned cached entitlement record. `StarterPackClaimed` makes the bundled reward idempotent, while absolute `ActiveBoosts` expiry timestamps keep its timed effects persistent across rejoins. `Pets.GamePassStorageBonus` and `Pets.GamePassEquipSlotBonus` are derived, clamped benefit fields; they are not trusted as independent ownership evidence. `Monetization.FastHatchEnabled` is a preference, not an entitlement, and the server accepts changes only from verified Fast Hatch owners. A successful ownership response of `false` revokes the cached entitlement, while a temporary API failure preserves the last verified saved state.

`SellService` uses the shared server-side cash multiplier: verified Permanent 2× Cash and an unexpired Starter Pack cash boost stack to 4× only on the final trash-sale total. Client totals, pet-sale requests, admin commands, and cash-product receipts cannot opt into either multiplier.

`PetHatchService` independently checks `TripleHatch` before accepting a count of three and obtains the verified permanent/temporary luck roll count from `MonetizationConfig`. Client-displayed ownership, timers, odds, hatch count, and animation preference never authorize cash spending or rarity RNG.

Client-provided fields should select among known server options only. They must never carry an authoritative price, multiplier, reward amount, rarity, item definition, CFrame, or ownership flag.

Backpack `Value` is presentation data for the collected item: configured base trash value with the rolled mutation bonus, excluding pets. Selling must not trust this stored number. `SellService` resolves the trash ID and mutation against server configs, accepts only a legacy tool multiplier that matches a configured legacy tool, and applies the currently equipped pet team on the server. Unknown trash IDs and invalid multiplier metadata must never mint cash.

## Remote validation patterns

- Reject wrong types immediately.
- Resolve IDs through the appropriate config.
- Check the player has a loaded data session.
- Check ownership/unlock state.
- Check distance to the server-owned station/spot where applicable.
- Check allowed quantities (`1`/`3`, equip limit, capacity).
- Rate-limit repeat requests. Pet equip, pet sale, and tool equip requests use request IDs and server rate limits; preserve this protection.
- Make mutations atomic: subtract currency and add inventory in one validated server path.
- Return a structured failure result so the client can unlock buttons and display a useful message.

Pet sale requests contain only the pet UID and request ID. The server resolves the pet definition and originating egg, rejects equipped or unowned pets, and calculates the payout from `PetConfig.SellReturnByRarity`; the client-suggested display value is never authoritative.

## Data-change test matrix

For every schema change test:

1. Brand-new profile.
2. Old profile missing the new field.
3. Partially populated/corrupt optional table.
4. Save → leave → rejoin persistence.
5. Two rapid requests for the same purchase/equip action.
6. Insufficient currency/capacity.
7. Player disconnect during an active collection/hatch/crate action.

## Admin commands

Admin commands are parsed/displayed through `AdminCommandController` and validated/executed by `AdminCommandService`. Current requested commands include adding cash and adding world Diamonds. Keep command permissions server-side and never expose a production command to every player merely because the client recognizes its text.

Current diagnostic grant caps are $1,000,000,000,000,000 Cash for `/addcash` and 1,000,000,000 Diamonds for `/adddiamond`. These are separate server-side limits.
