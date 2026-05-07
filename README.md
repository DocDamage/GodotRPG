# The Last World Museum

Godot JRPG prototype for **The Bell Saint**, the first playable slice of *The Last World Museum*.

The slice starts on the title screen, enters Sev's character creator, moves through the breached museum into Hallowmere, recruits Mira Venn, exposes the Underchapel Drain and hidden hospital, then resolves in the Bell Saint boss fight and memory-card reward scene.

## Current Playable Route

1. Title screen
2. Character creator
3. Empty Rotunda
4. Broken Exhibit Door
5. Hallowmere Street
6. Mira's Apothecary
7. Chapel of the Sainted Bell
8. Underchapel Drain
9. Hidden Hospital Corridor
10. Bell Tower
11. Bell Saint battle
12. Truth Recovered reward scene

## Implemented Systems

- Data-driven story flow, map catalog, objectives, dialogue, items, enemies, and audio events.
- Title screen with the Plague Wing as the active clear Vista pane, future wings visible but sealed/obscured, New Game routing to character creation, Continue loading the manual slot, a usable Memory Catalog, and an Options terminal.
- Character creator with Sev profile, portrait, relic voice, dossier, validation, randomize, reset, and save persistence.
- Authored field maps with curated tile art, story prop inspections, transitions, entry dialogue, objectives, and random encounters.
- Data-driven field vista and atmosphere profiles for the first slice. Each field phase now mounts a non-interactive parallax/vista layer, weather or ambient particle patches, a lighting overlay, and a fixed time-of-day state.
- Data-driven first-slice prop placement manifest at `game/data/maps/first_slice_prop_placements.json`, layered by navigation, story evidence, and atmosphere.
- Selected navigation and story props now define manifest-level collision rectangles, with tests guarding spawns and transition centers.
- Story evidence props define manifest-level inspection audio and `discovered_prop_*` flags, so first-time prop inspections show evidence feedback, use exhibit or museum cues, and feed later codex/dialogue logic.
- First-slice evidence progress is summarized on the Truth Recovered reward panel as `Evidence Found: found / total`, with an `Evidence Remaining` hint for the earliest maps still missing inspected story props.
- Evidence discovery flags and the discovered evidence list are save/load covered, including rebuild support for older saves that only have individual `discovered_prop_*` flags.
- First-slice NPC/side-quest interactions in Hallowmere and the hidden hospital, including one-time Clean Bandage and Fever Charm rewards.
- FF9-style prototype battle presentation with cinematic camera, enemy AI profiles, status effects, skill menus, generated Bell Saint/Clean Man animation sets, and boss rewards.
- Memory Card collection/equip data and Tetra-style card battle minigame foundations.
- Save/load payload coverage for route checkpoints before and after Bell Saint completion, plus autosave feedback on the chapter reward panel.
- Bell Saint completion now autosaves after routing to `truth_recovered`, so Continue restores the reward/safe-stop screen instead of dropping the player back into battle.
- Robustness coverage for title-to-slice scene churn, corrupt settings files, missing title art, submenu reuse, runtime placeholder/stub markers, and verbose Godot leak output.
- First-slice navigation and encounter pacing checks for safe spawns, clear transition points, lighter hospital patrols, and a tuned Bell Saint boss.
- OGG-first curated runtime audio manifest with dedicated first-slice map entry and ambience cues.
- Modern controller baseline: left stick and D-pad movement, face-button confirm/cancel, shoulder paging actions, Godot UI action mappings, saved deadzone/glyph accessibility settings, controller/keyboard prompt labels, and controller focus setup for the title screen, character creator, battle commands, Tetra, and reward panel.
- Title Options persists text speed, menu scale, ATB wait/active mode, high contrast, reduced flashing, controller glyph family, controller deadzone, display mode, and per-bus audio volumes in `user://settings.save` without creating a gameplay Continue slot.

## Field Atmosphere

First-slice field atmosphere is defined in `game/data/field/atmosphere_profiles.json` and loaded by `FieldAtmosphereCatalog`.

- `VistaParallax`: mounted behind map art with texture-backed vista layers when `texture_path` is present, plus color-band fallback layers and scroll-speed metadata.
- `WeatherLayer`: mounted above map art with fog, mist, dust, smoke, flicker, or boss haze patches.
- `LightingOverlay`: mounted as a non-interactive tint that records `lighting_profile` and `time_of_day`.
- Field atmosphere animates during map processing: parallax bands drift, weather patches move at profile-defined speeds, and lighting overlays pulse or flicker from profile metadata.
- Press `F3` in field scenes to show or hide the QA phase overlay. It surfaces the active atmosphere, lighting, and time state without crowding normal play.

Current time states are authored per map rather than simulated as a continuous clock: museum spaces use `outside_time`, Hallowmere uses `quarantine_day`, the drain/hospital use `below_time`, and Bell Tower uses `false_dusk`. Runtime vista art is curated under `game/assets/vistas/first_slice`: industrial layers support museum spaces, mountain dusk layers support plague exterior/Hallowmere views, sewer layers support Underchapel, and gothic corridor layers support chapel, hidden hospital, and Bell Tower.

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
godot_console.exe --headless --path game --scene res://scenes/title/title_screen.tscn --quit-after 2 2>&1
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
- Continue replacing secondary color bands with final painted/parallax art from the Ansimuz packs once the exact scene compositions are selected.
- Animate weather drift and lighting flicker after editor visual QA confirms the static profile placement.
- Expand the prop manifest with final collision rectangles after editor playthrough confirms walk lanes.
- Add final production UI art pass for the reward scene, save UI, and battle command panels.

## Pre-Playtest Checklist

- Complete the character creator with controller only.
- Move through Hallowmere, inspect story props, complete side quests, and enter the dungeon with controller only.
- In battle, open skills/items, cancel back to commands, select targets, defeat Bell Saint, and read the reward panel with controller only.
- Start a Tetra match, select a hand card, move to board slots, and play a card with controller only.
- Save after boss completion, restart, load, and confirm Bell Clapper, Bell Saint Memory Card, Mira, evidence progress, and autosave status remain intact.
