# Audio Direction

## Core Rule

The Last World Museum has two sound worlds:

- Museum: clean UI clicks, mechanical hums, sterile terminals, card flips, synthetic blips.
- Exhibits: era-specific footsteps, weapons, ambience, human sounds, horror stingers, environmental sounds.

When the Curator interferes, the Museum layer should cut through the Exhibit layer.

## Runtime Format

Curated runtime audio should be OGG Vorbis for size. Raw source WAV/MP3 files remain outside the Godot project under `C:/dev/Godot Game/Assets/sound effects`.

Do not bulk-import the full source audio library. Add named events to `game/data/audio/audio_events.json`, then run:

```powershell
powershell -ExecutionPolicy Bypass -File game/tools/audio/convert_audio_manifest.ps1 -ProjectRoot (Resolve-Path game).Path
```

The converter writes OGG files under `game/assets/audio/...`.

## First Slice Banks

The Bell Saint slice currently curates:

- UI: confirm, cancel, Curator warning.
- Cards: Memory Card reveal.
- Relics: Bell Clapper cue.
- Human: plague cough.
- Combat: weapon slice, hit impact.
- Items: item pickup.

The first curated pass reduced selected source audio from about 1.65 MB to about 174 KB.

## Naming

Use stable event ids such as:

- `curator_warning`
- `memory_card_reveal`
- `bell_clapper_relic`
- `plague_cough`
- `weapon_slice`
- `hit_impact`
- `item_pickup`

Gameplay code should refer to event ids, not raw files.
