# Title Screen Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the approved title screen as the first playable screen before character creation.

**Architecture:** Keep `AppRoot` as the main scene and add a `title` phase to `StoryFlowService`. Add a focused `TitleScreen` scene/script that emits menu signals and reads a small pane catalog.

**Tech Stack:** Godot 4.6 GDScript, JSON data catalog, curated PNG runtime assets, existing headless test runner.

---

### Task 1: Title Data And Assets

**Files:**
- Create: `game/data/ui/title_screen.json`
- Create: `game/assets/title_screen/panes/*.png`
- Modify: `.gitignore`

- [x] Add `.superpowers/` to `.gitignore` so brainstorming previews do not pollute Git status.
- [x] Create a title screen JSON catalog with six pane entries: Plague active, Rome/Saga/War/Modern/Future locked.
- [x] Generate curated pane PNGs under `game/assets/title_screen/panes` from approved source art.

### Task 2: Title Scene

**Files:**
- Create: `game/scripts/title/title_screen.gd`
- Create: `game/scenes/title/title_screen.tscn`

- [x] Create a `TitleScreen` Control script with signals for New Game, Continue, Memory Catalog, Options, and Exit.
- [x] Build the UI programmatically from reusable nodes: background, title, door, six panes, menu, status, prompt.
- [x] Load pane data from `game/data/ui/title_screen.json`.
- [x] Assign controller focus to New Game and disable Continue when no save exists.

### Task 3: App Flow Integration

**Files:**
- Modify: `game/scripts/core/story_flow_service.gd`
- Modify: `game/scripts/core/app_root.gd`

- [x] Make `StoryFlowService` start at `title`.
- [x] Mount `TitleScreen` when the current phase is `title`.
- [x] Route New Game to character creator.
- [x] Route Continue through `GameState.load_manual_slot()` and `StoryFlowService.go_to_phase(game_state.map_id)`.

### Task 4: Tests And Docs

**Files:**
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add title screen scene/data/routing tests.
- [x] Update README status and smoke-test instructions to mention the title screen.
- [x] Run the full headless test suite.
- [x] Run app scene smoke check.

### Task 5: Complete Title Submenus

**Files:**
- Modify: `game/scripts/core/game_state.gd`
- Modify: `game/scripts/title/title_screen.gd`
- Modify: `game/tests/test_runner.gd`
- Modify: `README.md`

- [x] Add failing tests for real Memory Catalog and Options submenus.
- [x] Add separate settings persistence on `GameState` using `user://settings.save`.
- [x] Implement Memory Catalog as a title submenu that lists recovered memory cards or an empty-state message.
- [x] Implement Options as a title submenu that edits text speed, menu scale, ATB mode, high contrast, reduced flashing, controller glyph family, controller deadzone, display mode, and audio volumes.
- [x] Add Back behavior from both submenus to the main title menu.
- [x] Run tests and smoke checks.

### Task 6: Robustness Pass

**Files:**
- Modify: `game/scripts/accessibility/accessibility_settings.gd`
- Modify: `game/scripts/title/title_screen.gd`
- Modify: `game/tests/test_runner.gd`

- [x] Sanitize invalid title options when loading persisted settings.
- [x] Make missing title pane textures resolve safely without loader noise.
- [x] Ensure reopening title submenus does not duplicate controls.
- [x] Make cancel close open title submenus before falling back to the main-menu status response.
- [x] Verify Memory Catalog renders owned recovered cards.
- [x] Verify corrupt settings payloads are rejected without overwriting current runtime settings.
