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
- FF9-style prototype battle presentation with cinematic camera, enemy AI profiles, status effects, skill menus, generated Bell Saint/Clean Man animation sets, and boss rewards.
- Memory Card collection/equip data and Tetra-style card battle minigame foundations.
- Save/load payload coverage for route checkpoints before and after Bell Saint completion.
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
- Manual visual QA for authored tile maps in the Godot editor, especially collision bounds and prop placement.
- Add final production UI art pass for the reward scene, save UI, and battle command panels.
