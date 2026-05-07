# Prologue Cinematic Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an animated museum prologue that plays after New Game and before character creation, using existing museum/vista assets and backstory captions.

**Architecture:** Add a data-driven `PrologueCinematic` scene with parallax panes, marching docent silhouettes, drifting fog/sparks, timed narration captions, and a skip/continue signal. Add `prologue` to story flow between `title` and `character_creator`, and let `AppRoot` mount the cinematic on New Game while Continue still loads saved phases directly.

**Tech Stack:** Godot 4.6 GDScript, existing AppRoot story routing, JSON data catalogs, headless scene tests in `game/tests/test_runner.gd`.

---

### Task 1: Story Flow Routing

**Files:**
- Modify: `game/scripts/core/story_flow_service.gd`
- Modify: `game/tests/test_runner.gd`

- [x] **Step 1: Write failing tests**

Add assertions that `load_first_slice()` starts with `title`, advances to `prologue`, then advances to `character_creator`.

- [x] **Step 2: Run tests and verify failure**

Run: `godot_console.exe --headless --path game --script res://tests/test_runner.gd`

Expected: FAIL because `prologue` is not in the phase list.

- [x] **Step 3: Implement routing**

Change the initial phase array from `["title", "character_creator"]` to `["title", "prologue", "character_creator"]`.

- [x] **Step 4: Verify**

Run the full test suite and confirm story flow tests pass.

### Task 2: Prologue Data and Scene

**Files:**
- Create: `game/data/cinematics/prologue.json`
- Create: `game/scripts/cinematics/prologue_cinematic.gd`
- Create: `game/scenes/cinematics/prologue_cinematic.tscn`
- Modify: `game/tests/test_runner.gd`

- [x] **Step 1: Write failing tests**

Test that the prologue data defines at least five captions, that the scene mounts parallax, marchers, weather, and caption labels, and that calling `finish()` emits `prologue_completed`.

- [x] **Step 2: Run tests and verify failure**

Expected: FAIL because data and scene do not exist yet.

- [x] **Step 3: Implement data and scene**

Create a cinematic with:
- Museum maintenance backdrop
- Vista panes for plague, Rome, war, modern, future
- Three marching docent silhouettes
- Fog/spark weather bands
- Timed backstory captions
- Prompt text: `Interact: begin`

- [x] **Step 4: Verify**

Run full tests and smoke boot the scene.

### Task 3: AppRoot Integration

**Files:**
- Modify: `game/scripts/core/app_root.gd`
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] **Step 1: Write failing tests**

Test that title New Game mounts `PrologueCinematic`, prologue completion routes to character creator, and Continue still restores saved phases without showing the prologue.

- [x] **Step 2: Run tests and verify failure**

Expected: FAIL because AppRoot still routes New Game directly to character creator.

- [x] **Step 3: Implement AppRoot mounting**

Preload the prologue scene, mount it for `prologue`, connect `prologue_completed`, and route completion to `character_creator`.

- [x] **Step 4: Polish and verify**

Update README, run the full suite, and smoke boot `app_root`, `title_screen`, and `prologue_cinematic`.

