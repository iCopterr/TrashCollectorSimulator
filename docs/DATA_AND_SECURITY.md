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
- Sell value and inventory removal
- Egg/crate price, allowed open count, RNG, inventory capacity, and proximity
- Pet/tool ownership and equip limits
- Zone prerequisites, unlock price, and teleport destination
- Shop/Robux receipt effects

Client-provided fields should select among known server options only. They must never carry an authoritative price, multiplier, reward amount, rarity, item definition, CFrame, or ownership flag.

Backpack `Value` is presentation data for the collected item: configured base trash value with the rolled mutation bonus, excluding pets. Selling must not trust this stored number. `SellService` resolves the trash ID and mutation against server configs, accepts only a legacy tool multiplier that matches a configured legacy tool, and applies the currently equipped pet team on the server. Unknown trash IDs and invalid multiplier metadata must never mint cash.

## Remote validation patterns

- Reject wrong types immediately.
- Resolve IDs through the appropriate config.
- Check the player has a loaded data session.
- Check ownership/unlock state.
- Check distance to the server-owned station/spot where applicable.
- Check allowed quantities (`1`/`3`, equip limit, capacity).
- Rate-limit repeat requests. Pet and tool equip requests currently use request IDs and server rate limits; preserve this protection.
- Make mutations atomic: subtract currency and add inventory in one validated server path.
- Return a structured failure result so the client can unlock buttons and display a useful message.

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
