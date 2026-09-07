# Game Overview and Design Intent

## Core fantasy

Trash Collector Simulator is a zone-based Roblox simulator. The player cleans increasingly valuable areas, improves collection efficiency through pets and tools, discovers rare trash and mutations, and works toward difficult long-term zone unlocks.

The core progression rule is:

> Higher zone → more valuable trash → higher income → more expensive eggs/unlocks → longer progression.

Early zones should feel fast and welcoming. Later zones should take increasingly longer, and the final zone of a world should be a major achievement. Pets and tools must feel important without making the game trivial.

## Current core loop

1. Enter an unlocked zone.
2. Find a client-visible randomized small or medium trash spot.
3. Hold/interact to begin a 3–5 second collection.
4. A single skill check may appear during collection.
5. Success grants trash; better ratings can grant more and improve rarity odds.
6. Mutations can greatly increase the item's value and are shown by a trash-spot aura.
7. Diamonds may drop on a successful collection.
8. Sell the backpack at the zone's center sell station.
9. Spend cash on the zone egg and hatch pets.
10. Equip up to three pets; their multipliers add together.
11. Hatch at least one pet from the current zone and save enough cash to unlock the next zone.
12. Spend World 1 Diamonds on the shared World 1 tool crate and equip one tool.

## Collection is primary; the minigame is seasoning

The skill check must not become the main reason to play. It exists to break repetition during collection.

- Collection lasts 3–5 seconds.
- One skill check type is used.
- Current skill-check chance is 35%.
- A miss stops collection immediately, gives no trash, and applies a three-second per-player miss cooldown to that spot.
- A success replaces/rerolls the collected spot immediately for that player; there is no global 20-second cooldown banner.
- Collection progress and its UI must stop immediately on a miss.

## World and zone structure

- Each world is planned for up to ten zones.
- World 1 is Earth-based and currently has eight implemented zones.
- The current map is a straight line of 300×300 zones along the X axis.
- Every zone has its own walls, terrain personality, trash models, sell station, egg, trash table, pet table, Diamond tuning, and teleport entry.
- Locked-zone barriers are server-created and physically block players who have not unlocked the destination.
- A zone unlock requires both the previous zone and a permanent hatch flag from the previous zone.

Current World 1 order:

1. Downtown
2. Beach
3. Factory
4. Junkyard
5. Sewers
6. Frostbite Harbor
7. Haunted Carnival
8. Toxic Swamp
9–10. Not finalized/implemented

World 2 is planned around the Solar System. Do not implement World 2 or decide World 1 zones 9–10 without an explicit design request.

## Pets

- One egg market exists per zone.
- Each current zone egg contains five pets: Common, Uncommon, Rare, Epic, and Legendary.
- There is no hatch pity system.
- New pets are not auto-equipped.
- The default equipment limit is three pets.
- Equipped pet multipliers add: `17.1x + 8.2x + 15.3x = 40.6x`.
- Equipped pets stay in their normal inventory position and are indicated by a star.
- Sorting supports Default, Multiplier, Rarity, and Zone, with high/low direction where applicable.
- The pet collection shows undiscovered pets as silhouettes/question marks.

Future monetization direction includes premium Robux eggs. Premium pets may be stronger, but balance must preserve meaningful gameplay and avoid making normal progression irrelevant.

## Tools

- Tools are the only content in the Tools inventory; ordinary trash is not shown there.
- Tool acquisition uses crates, not eggs.
- World 1 has one shared crate configuration and one World 1 Diamond wallet.
- Every zone can contain an entrance to the same World 1 tool crate.
- A player equips one crate tool.
- Crate tools improve collection speed, extra-trash chance, and mutation chance. They intentionally avoid a direct cash-value multiplier.
- The old cash-upgrade tool list remains only as a compatibility path and should eventually be retired through a planned migration.

## Mutations

Three mutations currently exist:

- Gold: 4×, 5% base chance
- Infected: 12×, 1% base chance
- Cosmic: 100×, 0.1% base chance

Mutation chances can be improved by the equipped tool. Mutation and pet value bonuses use the existing additive combination formula rather than multiplying into an uncontrolled economy. Mutated pots use auras/effects; do not add a persistent mutation banner.

## Currencies

- Cash is global and is earned by selling trash.
- Diamonds are isolated by world: `Diamonds.World1`, future `Diamonds.World2`, and so on.
- A Diamond obtained anywhere in World 1 can be spent at any World 1 tool-crate entrance.
- Current World 1 tool crate price is 15 Diamonds per opening.

## UI direction

- Bright, toy-like simulator UI inspired by polished Roblox simulator experiences.
- Thick black borders, bold/Fredoka-style text, saturated rarity colors, stud/halftone textures, rounded shapes, and clear state changes.
- Figma PNGs provide authored decorative frames/buttons.
- Roblox-generated text is used for values that change: prices, counts, names, rarity, multipliers, progress, lock state, and descriptions.
- Opening major menus uses blur and transitions.
- Reward/discovery/collection-progress banners must not overlap each other.
- No emoji should be used as final UI artwork.

## Monetization direction

The Shop menu is intended for Robux products rather than normal cash upgrades. Current/planned categories include starter pack, VIP, triple hatch, boosts, cash products, premium egg, and premium tools. Product effects and final commerce IDs must be treated as incomplete until verified in the implementation and marketplace configuration.
