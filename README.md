# The Last World Museum

Godot JRPG prototype for **The Bell Saint**, the first playable slice of *The Last World Museum*.

The slice starts with Sev's character creator, moves through the breached museum into Hallowmere, recruits Mira Venn, exposes the Underchapel Drain and hidden hospital, then resolves in the Bell Saint boss fight and memory-card reward scene.

## Current Playable Route

1. Character creator
2. Empty Rotunda
3. Broken Exhibit Door
4. Hallowmere Street
5. Mira's Apothecary
6. Chapel of the Sainted Bell
7. Underchapel Drain
8. Hidden Hospital Corridor
9. Bell Tower
10. Bell Saint battle
11. Truth Recovered reward scene

## Implemented Systems

- Data-driven story flow, map catalog, objectives, dialogue, items, enemies, and audio events.
- Character creator with Sev profile, portrait, relic voice, dossier, validation, randomize, reset, and save persistence.
- Authored field maps with curated tile art, story prop inspections, transitions, entry dialogue, objectives, and random encounters.
- Data-driven first-slice prop placement manifest at `game/data/maps/first_slice_prop_placements.json`, layered by navigation, story evidence, and atmosphere.
- Selected navigation and story props now define manifest-level collision rectangles, with tests guarding spawns and transition centers.
- Story evidence props define manifest-level inspection audio and `discovered_prop_*` flags, so first-time prop inspections show evidence feedback, use exhibit or museum cues, and feed later codex/dialogue logic.
- First-slice evidence progress is summarized on the Truth Recovered reward panel as `Evidence Found: found / total`, with an `Evidence Remaining` hint for the earliest maps still missing inspected story props.
- Evidence discovery flags and the discovered evidence list are save/load covered, including rebuild support for older saves that only have individual `discovered_prop_*` flags.
- First-slice NPC/side-quest interactions in Hallowmere and the hidden hospital, including one-time Clean Bandage and Fever Charm rewards.
- FF9-style prototype battle presentation with cinematic camera, enemy AI profiles, status effects, skill menus, generated Bell Saint/Clean Man animation sets, and boss rewards.
- Memory Card collection/equip data and Tetra-style card battle minigame foundations.
- Save/load payload coverage for route checkpoints before and after Bell Saint completion, plus autosave feedback on the chapter reward panel.
- First-slice navigation and encounter pacing checks for safe spawns, clear transition points, lighter hospital patrols, and a tuned Bell Saint boss.
- OGG-first curated runtime audio manifest with dedicated first-slice map entry and ambience cues.

## Requirements

- Godot `4.6.2.stable` available as `godot_console.exe` on PATH.
- PowerShell on Windows.

Raw source assets live under `C:/dev/Godot Game/Assets`. Curated runtime assets live under `game/assets` so the Godot project does not import the full source library.

## Verification

Run the full automated suite:

```powershell
godot_console.exe --headless --path game --script res://tests/test_runner.gd 2>&1
```

Smoke boot the main prototype scenes:

```powershell
godot_console.exe --headless --path game --scene res://scenes/app/app_root.tscn --quit-after 2 2>&1
godot_console.exe --headless --path game --scene res://scenes/field/prototype_field.tscn --quit-after 2 2>&1
godot_console.exe --headless --path game --scene res://scenes/battle/prototype_battle.tscn --quit-after 2 2>&1
```

## Audio Pipeline

Curated runtime audio is OGG Vorbis. Add named events to `game/data/audio/audio_events.json`, then run:

```powershell
powershell -ExecutionPolicy Bypass -File game/tools/audio/convert_audio_manifest.ps1 -ProjectRoot (Resolve-Path game).Path
```

The converter writes selected OGGs under `game/assets/audio`.

## Remaining Slice Polish

- Replace generated one-shot map cues with final mastered ambience loops once source audio is selected.
- Manual visual QA for authored tile maps in the Godot editor, especially prop placement and visual readability.
- Expand the prop manifest with final collision rectangles after editor playthrough confirms walk lanes.
- Add final production UI art pass for the reward scene, save UI, and battle command panels.
