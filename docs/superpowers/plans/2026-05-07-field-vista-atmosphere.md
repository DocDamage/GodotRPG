# Field Vista And Atmosphere Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add real mounted field vista, weather, and lighting layers for the first playable slice so every map visibly communicates its museum/exhibit atmosphere.

**Architecture:** Keep authored map scenes focused on map props and collision. Add a data-driven `FieldAtmosphereCatalog` and let `PrototypeField` mount non-interactive visual layers behind and above maps from the current phase profile: parallax/vista bands, weather particles, ambient fog/mist overlays, and lighting tint. Tests will assert every first-slice phase has complete atmosphere metadata and that the field scene mounts the expected nodes.

**Tech Stack:** Godot 4.6 GDScript, JSON data catalogs, `ColorRect`/`Node2D` runtime visuals, existing headless test runner.

---

### Task 1: Atmosphere Data Catalog

**Files:**
- Create: `game/data/field/atmosphere_profiles.json`
- Create: `game/scripts/field/field_atmosphere_catalog.gd`
- Modify: `game/tests/test_runner.gd`

- [x] Add tests that every first-slice field phase resolves an atmosphere profile with `vista_id`, `weather_profile`, `lighting_profile`, and at least one parallax layer.
- [x] Add a catalog class that loads `res://data/field/atmosphere_profiles.json` and exposes `profile_for_phase(phase_id)`.
- [x] Define profiles for `empty_rotunda`, `broken_exhibit_door`, `plague_town_street`, `apothecary_house`, `chapel`, `underchapel_drain`, `hidden_hospital_corridor`, and `bell_tower_boss_room`.

### Task 2: Runtime Field Mounting

**Files:**
- Modify: `game/scripts/field/prototype_field.gd`
- Modify: `game/tests/test_runner.gd`

- [x] Add failing tests proving `PrototypeField` creates `MapContent/VistaParallax`, `MapContent/WeatherLayer`, and `MapContent/LightingOverlay`.
- [x] Render parallax layers behind authored maps using profile color bands and scroll speeds recorded as metadata.
- [x] Render weather/ambient patches above map art using profile particle definitions.
- [x] Render lighting overlay with map-specific tint and intensity.

### Task 3: Route And Visual Robustness

**Files:**
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add tests that changing maps clears old vista/weather/light nodes and remounts the target profile.
- [x] Add tests that every mounted atmosphere node is non-interactive and does not add collision bodies.
- [x] Document the implemented first-slice parallax/weather/day-night state and remaining polish.

### Task 4: Verification

**Files:**
- All changed files.

- [x] Run `godot_console.exe --headless --path game --script res://tests/test_runner.gd 2>&1`.
- [x] Run scene smoke checks for app, title, field, and battle scenes.

## Result

Implemented:
- `game/data/field/atmosphere_profiles.json`
- `game/scripts/field/field_atmosphere_catalog.gd`
- Runtime `VistaParallax`, `WeatherLayer`, and `LightingOverlay` mounting in `PrototypeField`
- Underchapel Vista mapping in `game/data/vistas/vista_engines.json`
- Tests for catalog coverage, mounted layers, map-change refresh, and non-interactive/no-collision atmosphere nodes

The first slice now has authored time states, weather profiles, lighting profiles, and parallax metadata for every field phase. The system is static/color-band based for this pass; final art replacement and animation drift are tracked as remaining visual polish in `README.md`.

### Task 5: Animate Atmosphere Layers

**Files:**
- Modify: `game/data/field/atmosphere_profiles.json`
- Modify: `game/scripts/field/prototype_field.gd`
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add a failing test proving `_process()` moves parallax/weather rects and pulses lighting alpha.
- [x] Add weather patch `drift_speed` and lighting `pulse_strength` / `pulse_speed` metadata to the Bell Tower profile.
- [x] Animate parallax bands from `scroll_speed`, weather patches from `drift_speed`, and lighting from pulse metadata.
- [x] Update README to document animated atmosphere behavior.
- [x] Run the full Godot test suite.

### Task 6: Texture-Backed Vista Layers

**Files:**
- Modify: `game/data/field/atmosphere_profiles.json`
- Modify: `game/scripts/field/prototype_field.gd`
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add tests requiring key first-slice profiles to reference existing vista texture files.
- [x] Add tests proving `PrototypeField` mounts at least one `TextureRect` parallax layer for the Plague field.
- [x] Add `texture_path` support to parallax layer profiles while keeping `ColorRect` fallback behavior.
- [x] Assign museum/plague field profiles to curated title/Vista pane artwork.
- [x] Run the full Godot test suite.

### Task 7: Curate Ansimuz First-Slice Vista Layers

**Files:**
- Create: `game/assets/vistas/first_slice/industrial/*.png`
- Create: `game/assets/vistas/first_slice/sewer/*.png`
- Create: `game/assets/vistas/first_slice/gothic/*.png`
- Modify: `game/data/field/atmosphere_profiles.json`
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add tests requiring selected Ansimuz vista layer files to exist under curated runtime folders.
- [x] Promote Industrial Parallax `bg.png` and `far-buildings.png` into `game/assets/vistas/first_slice/industrial`.
- [x] Promote Sewers Action Pack `back.png` and `middle.png` into `game/assets/vistas/first_slice/sewer`.
- [x] Promote Gothicvania Cold Corridors `back.png` and `middle.png` into `game/assets/vistas/first_slice/gothic`.
- [x] Point museum profiles at industrial art, Underchapel at sewer art, and hidden hospital at gothic corridor art.
- [x] Run the full Godot test suite.

### Task 8: Remove Title Pane Dependency From Field Vistas

**Files:**
- Create: `game/assets/vistas/first_slice/mountain_dusk/*.png`
- Create: `game/assets/vistas/first_slice/gothic/near.png`
- Modify: `game/data/field/atmosphere_profiles.json`
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add tests proving field atmosphere profiles do not reference `game/assets/title_screen`.
- [x] Promote Mountain Dusk `sky.png` and `far-mountains.png` into `game/assets/vistas/first_slice/mountain_dusk`.
- [x] Promote Gothicvania Cold Corridors `near.png` into `game/assets/vistas/first_slice/gothic`.
- [x] Point Hallowmere and apothecary atmosphere at mountain dusk art.
- [x] Point chapel and Bell Tower atmosphere at gothic corridor art.
- [x] Run the full Godot test suite.
