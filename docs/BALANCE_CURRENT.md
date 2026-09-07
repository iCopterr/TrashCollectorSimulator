# Current Balance Snapshot

Snapshot date: 2026-08-30. The authoritative values remain the ModuleScripts in `ReplicatedStorage.Shared.Config`.

## Zone progression

| # | Zone key | Display name | Center X | Unlock cash | Required hatch | Egg price | Legendary pet cap | First egg target | Next-zone target | Diamond drop |
|---:|---|---|---:|---:|---|---:|---:|---:|---:|---|
| 1 | `Downtown` | Downtown | 0 | Starting zone | — | 1,500 | 70× | 2 min profile | 12 min | 2%, 2–4 |
| 2 | `Beach` | Beach | 300 | 15,000 | Downtown | 200,000 | 125× | 5 min profile | 30 min | 3%, 2–4 |
| 3 | `Factory` | Factory | 600 | 2,750,000 | Beach | 6,500,000 | 210× | 6 min profile | 45 min | 4%, 3–5 |
| 4 | `Junkyard` | Junkyard | 900 | 125,000,000 | Factory | 150,000,000 | 340× | 10 min | 60 min | 5%, 4–6 |
| 5 | `Sewers` | Sewers | 1,200 | 1,100,000,000 | Junkyard | 875,000,000 | 540× | 10 min | 75 min | 6%, 5–7 |
| 6 | `FrostbiteHarbor` | Frostbite Harbor | 1,500 | 8,250,000,000 | Sewers | 6,500,000,000 | 850× | 12 min | 90 min | 7%, 6–8 |
| 7 | `HauntedCarnival` | Haunted Carnival | 1,800 | 56,000,000,000 | Frostbite Harbor | 45,000,000,000 | 1,300× | 14 min | 105 min | 8%, 7–9 |
| 8 | `ToxicSwamp` | Toxic Swamp | 2,100 | 400,000,000,000 | Haunted Carnival | 320,000,000,000 | 1,950× | 16 min | 120 min | 9%, 8–10 |
| 9 | `NuclearWasteland` | Nuclear Wasteland | 2,400 | 3,100,000,000,000 | Toxic Swamp | 2,500,000,000,000 | 2,900× | 18 min | 150 min | 10%, 9–12 |
| 10 | `WorldsEndLandfill` | World's End Landfill | 2,700 | 23,500,000,000,000 | Nuclear Wasteland | 18,800,000,000,000 | 4,300× | 20 min | 240 min | 12%, 10–14 |

Each zone is 300×300. Unlocks also require the previous zone itself. Diamond pity currently guarantees progress through a threshold of 50 unsuccessful successful-collection rolls per world, subject to `DiamondDropService` behavior.

## Trash values

### Downtown

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `Newspaper` | Newspaper | Common | 5 | 36 |
| `PlasticBottle` | Plastic Bottle | Common | 8 | 30 |
| `SodaCan` | Soda Can | Common | 10 | 22 |
| `PizzaBox` | Pizza Box | Uncommon | 15 | 16 |
| `TornToy` | Torn Toy | Uncommon | 28 | 10 |
| `OldPhone` | Old Phone | Rare | 50 | 5 |
| `SilverWatch` | Silver Watch | Epic | 140 | 2 |
| `GoldenTrash` | Golden Trash | Legendary | 500 | 0.5 |

### Beach

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `Driftwood` | Driftwood | Common | 35 | 32 |
| `BeachBottle` | Beach Bottle | Common | 45 | 30 |
| `Shell` | Seashell | Common | 55 | 25 |
| `LostSunglasses` | Lost Sunglasses | Uncommon | 80 | 15 |
| `FishingRod` | Fishing Rod | Uncommon | 120 | 10 |
| `Pearl` | Pearl | Rare | 250 | 5 |
| `Treasure` | Buried Treasure | Epic | 600 | 2 |
| `PirateCompass` | Pirate Compass | Legendary | 1,800 | 0.5 |

### Factory

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `Metal` | Scrap Metal | Common | 180 | 30 |
| `CopperWire` | Copper Wire | Common | 225 | 28 |
| `Battery` | Battery | Uncommon | 350 | 20 |
| `CircuitBoard` | Circuit Board | Uncommon | 500 | 12 |
| `MachineParts` | Machine Parts | Rare | 900 | 7 |
| `RobotCore` | Robot Core | Epic | 1,800 | 3 |
| `RadioactiveWaste` | Radioactive Waste | Epic | 2,800 | 1.5 |
| `PrototypeChip` | Prototype Chip | Legendary | 6,500 | 0.4 |

### Junkyard

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `RustedBolt` | Rusted Bolt | Common | 900 | 30 |
| `WornTire` | Worn Tire | Common | 1,150 | 28 |
| `CarBattery` | Car Battery | Uncommon | 1,800 | 20 |
| `EngineBlock` | Engine Block | Uncommon | 2,600 | 12 |
| `CopperRadiator` | Copper Radiator | Rare | 4,500 | 7 |
| `Turbocharger` | Turbocharger | Epic | 9,000 | 3 |
| `VintageEngine` | Vintage Engine | Epic | 14,000 | 1.5 |
| `GoldenCatalyst` | Golden Catalytic Converter | Legendary | 32,500 | 0.4 |

### Sewers

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `RustedPipe` | Rusted Pipe | Common | 4,500 | 30 |
| `WetCardboard` | Wet Cardboard | Common | 5,750 | 28 |
| `BrokenValve` | Broken Valve | Uncommon | 9,000 | 20 |
| `SewerGrate` | Sewer Grate | Uncommon | 13,000 | 12 |
| `MaintenanceKey` | Maintenance Key | Rare | 22,500 | 7 |
| `SludgeCanister` | Bio-Sludge Canister | Epic | 45,000 | 3 |
| `MutantRelic` | Mutant Relic | Epic | 70,000 | 1.5 |
| `GoldenManhole` | Golden Manhole Cover | Legendary | 162,500 | 0.4 |

### Frostbite Harbor

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `FrozenRope` | Frozen Rope | Common | 22,500 | 30 |
| `IceCoveredCan` | Ice-Covered Can | Common | 28,750 | 28 |
| `BrokenBuoy` | Broken Buoy | Uncommon | 45,000 | 20 |
| `RustedAnchor` | Rusted Anchor | Uncommon | 65,000 | 12 |
| `LostCargoRadio` | Lost Cargo Radio | Rare | 112,500 | 7 |
| `FrozenSupplyCrate` | Frozen Supply Crate | Epic | 225,000 | 3 |
| `IceboundTreasure` | Icebound Treasure | Epic | 350,000 | 1.5 |
| `AuroraCompass` | Aurora Compass | Legendary | 812,500 | 0.4 |

### Haunted Carnival

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `TornTicket` | Torn Admission Ticket | Common | 112,500 | 30 |
| `StickyCandyWrapper` | Sticky Candy Wrapper | Common | 143,750 | 28 |
| `BrokenClownHorn` | Broken Clown Horn | Uncommon | 225,000 | 20 |
| `RustedRideGear` | Rusted Ride Gear | Uncommon | 325,000 | 12 |
| `HauntedMask` | Haunted Carnival Mask | Rare | 562,500 | 7 |
| `CursedPrizeBox` | Cursed Prize Box | Epic | 1,125,000 | 3 |
| `PhantomCarouselHorse` | Phantom Carousel Horse | Epic | 1,750,000 | 1.5 |
| `MidnightRingmasterCane` | Midnight Ringmaster Cane | Legendary | 4,062,500 | 0.4 |

### Toxic Swamp

| ID | Name | Rarity | Value | Weight |
|---|---|---|---:|---:|
| `MuddyBoot` | Muddy Boot | Common | 562,500 | 30 |
| `LeakingBarrel` | Leaking Chemical Barrel | Common | 718,750 | 28 |
| `BrokenAirboatPropeller` | Broken Airboat Propeller | Uncommon | 1,125,000 | 20 |
| `BoggedGenerator` | Bogged Generator | Uncommon | 1,625,000 | 12 |
| `ToxicResearchCase` | Toxic Research Case | Rare | 2,812,500 | 7 |
| `MutantAlligatorScale` | Mutant Alligator Scale | Epic | 5,625,000 | 3 |
| `SunkenMoonshineCrate` | Sunken Moonshine Crate | Epic | 8,750,000 | 1.5 |
| `WitchlightRelic` | Witchlight Relic | Legendary | 20,312,500 | 0.4 |

## Zone pets

| Zone | Common | Uncommon | Rare | Epic | Legendary |
|---|---|---|---|---|---|
| Downtown | Alley Pigeon 10× | Street Rat 14× | Recycle Raccoon 22× | Neon Stray 38× | Golden City Fox 70× |
| Beach | Sand Crab 80× | Treasure Seagull 90× | Sea Turtle 100× | Coral Dolphin 112× | Tide Guardian 125× |
| Factory | Bolt Mouse 140× | Gear Hound 155× | Scrap Bot 170× | Reactor Drone 190× | Prototype Mech 210× |
| Junkyard | Scrap Crow 235× | Wreckyard Hound 255× | Magnet Bot 280× | Crusher Golem 310× | Rust Phoenix 340× |
| Sewers | Drain Rat 380× | Toxic Frog 415× | Pipe Eel 450× | Slime Beast 495× | Sewer Leviathan 540× |
| Frostbite Harbor | Snowy Seal 600× | Harbor Penguin 655× | Arctic Fox 715× | Icebreaker Bear 780× | Frost Kraken 850× |
| Haunted Carnival | Popcorn Bat 950× | Midnight Cat 1,030× | Ticket Booth Ghost 1,120× | Cursed Clown 1,210× | Phantom Ringmaster 1,300× |
| Toxic Swamp | Glowcap Firefly 1,450× | Mudskip Frog 1,575× | Bayou Gator 1,700× | Mutant Heron 1,825× | Toxic Hydra 1,950× |
| Nuclear Wasteland | Radroach 2,180× | Mutant Hound 2,360× | Atomic Scorpion 2,540× | Reactor Golem 2,720× | Atomic Dragon 2,900× |
| World's End Landfill | Scrapling Rat 3,250× | Landfill Hound 3,500× | Compactor Golem 3,750× | Methane Phoenix 4,025× | World Eater 4,300× |

Base pet rarity weights are Common 45, Uncommon 30, Rare 15, Epic 9.9, and Legendary 0.1. There is no pity. Equip limit is three; multipliers add. The current equipped team is applied when the backpack is sold, while collection feedback shows base value plus mutation only. Mutation and pet value multipliers combine additively (`pet + mutation - 1`). Starting with Beach, every zone's Common pet is stronger than the previous zone's Legendary. Later egg and unlock prices are scaled against the preceding zone's increased expected pet income to preserve the target pacing.

## Collection and skill check

- Collection duration: 3.0–5.0 seconds
- Skill-check chance: 35%
- Active duration: 1.5 seconds
- Good arc: 54°
- Perfect arc: 14°
- MISS: 0 items
- GOOD: 1 item, 1.0× rare chance
- GREAT: 2 items, 1.3× rare chance
- PERFECT: 2–3 items, 2.0× rare chance
- Miss cooldown: 3 seconds
- Normal success cooldown: 0 seconds/player-specific reroll
- Spawn positions per zone: 30
- Small/medium weights: 78/22
- Medium reward-tier bonus: +1

## Mutations

| Mutation | Base chance | Value multiplier |
|---|---:|---:|
| Gold | 5% | 4× |
| Infected | 1% | 12× |
| Cosmic | 0.1% | 100× |

Roll order is rare-first: Cosmic, Infected, Gold.

## Tool crate

- World 1 price: 15 World 1 Diamonds per crate
- Allowed open counts: 1 and 3
- Open animation: 6 seconds
- Inventory capacity: 50
- Equip limit: 1
- Pity: disabled
- Duplicates: kept
- Rarity odds: 50% Common, 30% Uncommon, 14% Rare, 5% Epic, 1% Legendary

| Tool | Rarity | Drop weight | Speed | Extra trash | Mutation chance |
|---|---|---:|---:|---:|---:|
| Street Broom | Common | 18 | 1.08× | 1% | 1.00× |
| Recycle Grabber | Common | 17 | 1.04× | 3% | 1.03× |
| Beach Rake | Common | 15 | 1.06× | 2% | 1.05× |
| Bottle Magnet | Uncommon | 12 | 1.10× | 5% | 1.08× |
| Cleanup Vacuum | Uncommon | 10 | 1.16× | 2% | 1.06× |
| Scrap Tongs | Uncommon | 8 | 1.08× | 4% | 1.15× |
| Turbo Collector | Rare | 8 | 1.25× | 5% | 1.12× |
| Industrial Magnet | Rare | 6 | 1.14× | 8% | 1.20× |
| Mutation Scanner | Epic | 5 | 1.22× | 8% | 1.40× |
| Cosmic Cleanup Rig | Legendary | 1 | 1.35× | 12% | 1.80× |

## Backpack levels

| Level | Capacity | Cost | Required zone |
|---:|---:|---:|---|
| 1 | 10 | 0 | — |
| 2 | 20 | 150 | Downtown |
| 3 | 35 | 700 | Downtown |
| 4 | 60 | 50,000 | Beach |
| 5 | 100 | 250,000 | Beach |
| 6 | 175 | 3,000,000 | Factory |
| 7 | 300 | 15,000,000 | Factory |

Backpack upgrades and the old cash-tool upgrade path are legacy systems whose final place in the Robux-focused Shop design still needs a deliberate decision.
