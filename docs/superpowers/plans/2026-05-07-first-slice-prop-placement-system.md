# First Slice Prop Placement System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a data-driven prop placement system for the Bell Saint slice so navigation, story evidence, and atmospheric detail can be tuned from manifests instead of map scripts.

**Architecture:** Add a first-slice prop placement JSON manifest and a shared `MapPropRenderer` that converts manifest entries into Godot nodes. Existing authored map scripts keep their floors, collision walls, and ambience, but delegate prop/landmark creation to the renderer.

**Tech Stack:** Godot 4.6 GDScript, JSON data manifests, existing headless test runner.

---

### Task 1: Add Prop Manifest Coverage

**Files:**
- Create: `game/data/maps/first_slice_prop_placements.json`
- Modify: `game/tests/test_runner.gd`

- [x] Add tests asserting the prop manifest exists, contains all first-slice authored maps, and classifies props into `navigation`, `story`, and `atmosphere`.
- [x] Add the JSON manifest with existing prop placements migrated from the six map scripts.
- [x] Run `godot_console.exe --headless --path game --script res://tests/test_runner.gd` and verify the manifest tests pass.

### Task 2: Add Shared Prop Renderer

**Files:**
- Create: `game/scripts/field/map_prop_renderer.gd`
- Modify: `game/tests/test_runner.gd`

- [x] Add tests asserting `MapPropRenderer.props_for_map("hallowmere_street")` resolves manifest data and can instantiate a `House01` prop with source metadata.
- [x] Implement `MapPropRenderer` with support for sprite props, color marker props, nested child sprites, story metadata, z-index, scale, tint, and optional collision rectangles.
- [x] Run the test suite and verify renderer tests pass.

### Task 3: Migrate Authored Maps To Renderer

**Files:**
- Modify:
  - `game/scripts/field/maps/hallowmere_street_map.gd`
  - `game/scripts/field/maps/mira_apothecary_map.gd`
  - `game/scripts/field/maps/sainted_bell_chapel_map.gd`
  - `game/scripts/field/maps/underchapel_drain_map.gd`
  - `game/scripts/field/maps/hidden_hospital_corridor_map.gd`
  - `game/scripts/field/maps/bell_tower_boss_room_map.gd`

- [x] Replace hard-coded `_add_landmarks()` prop construction with `MapPropRenderer.new().render_props(landmarks, map_id)`.
- [x] Remove now-unused per-map prop helper functions where safe.
- [x] Keep existing floor, wall collision, and atmosphere methods unchanged.
- [x] Run existing authored-map tests to verify node paths, textures, metadata, story props, and inspection markers still work.

### Task 4: Add Placement Safety Tests

**Files:**
- Modify: `game/tests/test_runner.gd`

- [x] Add tests that manifest prop positions do not overlap first-slice spawns or transition centers when marked as blocking.
- [x] Add tests that every story prop has non-empty `story_role` and `inspect_text`.
- [x] Add tests that every sprite prop points at an existing `asset_path` or valid `asset_id`.
- [x] Add tests that every story prop defines inspect audio and a stable discovery flag.
- [x] Add tests that inspecting a story prop records its discovery flag in game state.
- [x] Run the full test suite.

### Task 5: Update Documentation

**Files:**
- Modify:
  - `README.md`
  - `docs/story/the-last-world-museum-story-bible.md`

- [x] Document the prop placement layers and manifest path.
- [x] Note that first-slice maps now use data-driven props.
- [x] Document story prop audio and discovery flags.
- [x] Run `git diff --check`.
