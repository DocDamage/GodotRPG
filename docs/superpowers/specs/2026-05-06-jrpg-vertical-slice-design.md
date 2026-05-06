# JRPG Vertical Slice Design

Date: 2026-05-06

## Goal

Build a clean Godot 4.6 foundation for a top-down, genre-bending, time-travel fantasy JRPG. The first playable vertical slice starts with an in-depth character creator, moves through a medieval fantasy overworld, town, and dungeon, resolves in a classic ATB boss battle, then ends with a short playable future/cyberpunk teaser.

The project will be Windows desktop first, with architecture choices that do not block future web or mobile support.

## Source Assets

Raw asset packs stay outside the Godot project under `C:\dev\Godot Game\Assets`. The game project will copy only curated runtime assets into `game/assets/vendor/...`.

Primary top-down JRPG assets:

- `Assets/CuteSCKR/Modern World Overworld Pixel Tileset`
- `Assets/CuteSCKR/Medieval Fantasy Town Pixel Art Tileset Pack`
- `Assets/CuteSCKR/Medieval Fantasy Dungeon & Prison Pixel Art Tileset Pack`
- `Assets/characters`
- `Assets/Monsters`
- `Assets/UI`
- `Assets/icons`
- `Assets/sound effects`

Parallax, mood, music, and teaser assets:

- `Assets/ansimuz assets/Mountain Dusk Parallax background`
- `Assets/ansimuz assets/Parallax Forest`
- `Assets/ansimuz assets/Cyberpunk streets`
- `Assets/ansimuz assets/Gothicvania Cold Corridors`
- `Assets/ansimuz assets/Sewers Action Pack`

The Ansimuz pack includes non-runtime files such as Unity artifacts, Godot sample imports, caches, binaries, source formats, and `.DS_Store` files. Those should not be bulk-imported into the clean project.

## Reference Repositories

Clone the requested GitHub repositories into `game/references/` or a similarly isolated reference folder:

- `https://github.com/DocDamage/awesome-godot`
- `https://github.com/DocDamage/Git-JRPG`
- `https://github.com/DocDamage/godot-4-leveling-system`
- `https://github.com/DocDamage/godot-open-rpg`
- `https://github.com/DocDamage/GodotRPG`
- `https://github.com/DocDamage/godot_jrpg_template`

These repositories are references only. The project should not start from a template repo. Any copied or adapted code must be reviewed for Godot version compatibility, licensing, and fit with this architecture.

## Player Experience Flow

1. Title or new game entry.
2. Character creator.
3. Medieval overworld.
4. Medieval town.
5. Medieval dungeon with random encounters.
6. Boss battle using ATB combat.
7. Time-fracture transition.
8. Short playable future/cyberpunk teaser.

The slice excludes full world-scale content, crafting, full shops, quest logs, deep branching narrative, and multi-era campaigns until the core loop is stable.

## Character Creator

The character creator is the first major scene before gameplay.

Features:

- Player name.
- Pronouns.
- Starting archetype/class.
- Base body or full sprite preset selection.
- Hair, outfit, and armor selection when compatible layered assets exist.
- Palette swaps for skin, hair, outfit primary, and outfit accent.
- Preview for idle and walking animation directions when the selected sprite supports it.
- Accessibility settings surfaced early: text speed, menu scale, high-contrast UI, reduced flashing, and ATB mode.

Initial lead-hero class options:

- `Vanguard`: durable front-line attacker.
- `Spellblade`: hybrid physical and magic attacker.
- `Mystic`: magic-focused damage and support.
- `Warden`: defensive/support role.

The output is a structured `PlayerProfile` resource or save payload. It stores identity, appearance metadata, palette choices, class, and accessibility defaults. The creator should not permanently mutate source art. If an asset pack is not layer-compatible, it appears as a full preset option.

## Party

The first slice uses a four-character party. The created character is the lead hero. The other three party members can use fixed placeholder profiles and roles for the vertical slice.

Suggested first party roles:

- Created lead hero: class chosen in the creator.
- Guardian: durable tank/support.
- Arcanist: offensive magic.
- Scout: fast attacker and item utility.

## Movement And Field Interaction

Field movement uses free 8-direction movement. Interactions and transitions resolve through tile-aligned trigger areas.

Requirements:

- Keyboard input.
- Gamepad input.
- Touch-ready action abstraction for later mobile support.
- Movement actions named centrally for remapping.
- Interaction targets resolve against the character's facing direction.
- Map transitions use explicit trigger zones.
- Player speed can later be exposed as an accessibility setting.

## Dialogue

Dialogue uses a simple reusable dialogue UI:

- Speaker name.
- Portrait placeholder.
- Configurable text speed.
- Choice-ready data shape.
- Name and pronoun interpolation from `PlayerProfile`.

The town should include a few NPC conversations that establish time fractures and point the player toward the dungeon.

## Encounters

The first dungeon uses random encounters, matching the requested classic JRPG feel.

Requirements:

- Encounter checks are distance or step based, not purely time based.
- Dungeon map regions select encounter tables.
- Encounter rate can later be reduced or disabled for accessibility.
- Boss encounters are scripted, not random.

## ATB Combat

Combat is classic JRPG ATB inspired by Final Fantasy 6.

Requirements:

- Four-character party.
- Enemy groups.
- ATB bars fill over time based on speed.
- Default ATB mode is `Wait`: enemy ATB and hostile action resolution pause while command menus are open.
- Future `Active` mode remains supported by the state model.
- Commands: Attack, Skill or Magic, Item placeholder, Defend, Flee.
- Victory grants XP, loot, and level-up checks.
- Boss victory triggers the time-fracture transition.

The first implementation should keep the combat content small: a few enemy types, one dungeon encounter table, one boss, and a small command set.

## Progression

Progression should be data-driven enough to expand later without redesign.

Requirements:

- Class-based starting stats.
- XP curve.
- Level-up stat gains.
- Basic item and equipment model.
- Treasure pickup in the dungeon.
- Loot and XP rewards after battle.

The `godot-4-leveling-system` repository should be inspected for concepts, but the implemented API should match this project's own `PlayerProfile`, party, and battle data.

## Save And Load

The first slice needs one manual save slot.

Saved data:

- Player profile.
- Accessibility settings.
- Current map id.
- Player position.
- Party stats and levels.
- Inventory.
- Story flags.

The save payload should be versioned from the start so future schema changes can migrate cleanly.

## Accessibility

Accessibility is a first-class requirement, not a late setting screen.

First-slice requirements:

- Keyboard and gamepad action maps.
- Touch-ready input abstraction.
- Configurable text speed.
- Menu scale setting.
- High-contrast UI flag.
- Reduced flashing flag.
- Default ATB mode is Wait.
- Encounter rate should be configurable later, and the encounter system should not make that difficult.

The first implementation may only partially apply every visual flag, but the settings must exist in the data model and be consumed by systems where practical.

## Project Structure

Create a clean Godot project under `C:\dev\Godot Game\game`.

```text
game/
  project.godot
  addons/
  assets/
    source_manifest/
    vendor/
      cute_sckr/
      ansimuz/
  data/
    characters/
    classes/
    combat/
    encounters/
    dialogue/
    items/
    maps/
  scenes/
    app/
    character_creator/
    field/
    battle/
    dialogue/
    ui/
  scripts/
    core/
    character_creator/
    field/
    battle/
    progression/
    save/
    accessibility/
  tests/
  references/
```

Use GDScript unless a specific library or external code path clearly justifies C#.

Core runtime boundaries:

- `AppRoot`: owns scene flow between title, creator, field, battle, and teaser.
- `GameState`: autoload for profile, party, map, settings, inventory, and flags.
- `CharacterCreatorController`: owns profile creation flow.
- `CharacterPreview`: renders layered or full-sheet preview sprites.
- `FieldController`: owns movement, interactions, transitions, and encounter checks.
- `BattleController`: owns ATB state, commands, enemy turns, victory, and defeat.
- `SaveService`: serializes and loads versioned save data.
- `AccessibilitySettings`: stores and applies settings shared by UI, field, and battle systems.

## Testing Strategy

Use test-first implementation for new behavior.

Automated tests should cover pure logic first:

- XP curve and level-up results.
- Class stat initialization.
- ATB fill behavior.
- Wait-mode pause behavior.
- Encounter table selection.
- Save payload serialization and migration.
- Character creator profile output.

Scene composition and visual asset import need manual Godot verification in addition to automated logic tests.

## First Milestone Definition Of Done

The first milestone is done when a player can:

1. Launch the game.
2. Create a lead character.
3. Enter the medieval overworld.
4. Move into a town.
5. Talk to at least one NPC.
6. Enter a dungeon.
7. Trigger random encounters.
8. Win at least one normal ATB battle.
9. Open at least one treasure pickup.
10. Fight and defeat a boss.
11. Receive XP and level-up if thresholds are met.
12. Transition through a time fracture.
13. Walk briefly in a future/cyberpunk teaser map.
14. Save and load one slot.

