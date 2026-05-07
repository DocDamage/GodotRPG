# Bell Saint Slice Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Finish The Bell Saint first playable slice enough that the project has an end-to-end verified path, documented runtime expectations, and pushed GitHub state.

**Architecture:** Keep the slice completion pass data-driven. `first_slice.json`, `slice_flow.json`, map catalogs, authored field maps, battle rewards, and save state should agree on the playable route; tests should verify the route contract rather than relying on manual memory.

**Tech Stack:** Godot 4.6 GDScript, JSON data catalogs, PowerShell verification, local Git/GitHub remote.

---

### Task 1: Lock The Playable Route

**Files:**
- Modify: `game/data/maps/slice_flow.json`
- Modify: `game/tests/test_runner.gd`

- [x] **Step 1: Write failing route test**

Add a test that loads `res://data/maps/slice_flow.json` and asserts the full route includes `underchapel_drain` between `chapel` and `hidden_hospital_corridor`, starts with `character_creator`, and ends with `truth_recovered`.

- [x] **Step 2: Run red**

Run:

```powershell
godot_console.exe --headless --path game --script res://tests/test_runner.gd 2>&1
```

Expected: FAIL because `slice_flow.json` currently skips `underchapel_drain`.

- [x] **Step 3: Fix data**

Insert `underchapel_drain` after `chapel` in `game/data/maps/slice_flow.json`.

- [x] **Step 4: Run green**

Run the same Godot test command. Expected: `All tests passed.`

### Task 2: Add Slice Readiness Validator

**Files:**
- Modify: `game/tests/test_runner.gd`

- [x] **Step 1: Write failing validator test**

Add a test that walks every non-menu/non-battle phase in `slice_flow.json`, confirms `MapCatalog.map_for_phase()` returns a map, each mapped phase has transition coverage to the next map where applicable, and the boss phase grants Bell Clapper, The Bell Saint memory card, and `truth_recovered`.

- [x] **Step 2: Run red**

Run the Godot test suite. Expected: fail if route/data contracts are incomplete.

- [x] **Step 3: Fix contracts**

Update JSON or code only where the failing test identifies a real route gap.

- [x] **Step 4: Run green**

Run the Godot test suite. Expected: `All tests passed.`

### Task 3: Add Save/Load Checkpoint Coverage

**Files:**
- Modify: `game/tests/test_runner.gd`
- Modify only if needed: `game/scripts/save/save_service.gd`, `game/scripts/core/game_state.gd`

- [x] **Step 1: Write checkpoint tests**

Add tests for three save/load states: after Mira recruitment, before Bell Saint, and after Bell Saint defeat. Each must preserve `map_id`, party membership, inventory, memory cards, and completion flags.

- [x] **Step 2: Run red**

Run the Godot test suite. Expected: fail only if a required checkpoint field is not serialized.

- [x] **Step 3: Implement minimal persistence fix**

If needed, update `GameState.to_save_payload()` / `GameState.apply_save_payload()` or `SaveService` to preserve the missing fields.

- [x] **Step 4: Run green**

Run the Godot test suite. Expected: `All tests passed.`

### Task 4: Finish Field Inspect And Entry Audio

**Files:**
- Modify: `game/scripts/field/prototype_field.gd`
- Modify: `game/scripts/field/map_interactable.gd`
- Modify: `game/scripts/core/audio_service.gd`
- Modify: `game/tests/test_runner.gd`

- [x] **Step 1: Keep current tests**

Retain tests proving authored props become interactables, normal player interaction can inspect a prop, and mounted map entry audio is recorded.

- [x] **Step 2: Run tests**

Run the Godot test suite. Expected: `All tests passed.`

- [x] **Step 3: Fix any regression**

Use scoped code changes only in the listed field/audio files.

### Task 5: Update Documentation

**Files:**
- Modify: `README.md`
- Modify: `docs/story/the-last-world-museum-story-bible.md`
- Modify: `docs/story/audio-direction.md`

- [x] **Step 1: Update README**

Document current project status, how to run tests, how to boot the app/field/battle scenes, slice route, key systems, and known remaining polish.

- [x] **Step 2: Update story bible**

Add Underchapel Drain to the first playable slice map list and clarify current runtime systems: character creator, Mira recruitment, Bell Saint reward, memory card, and authored prop inspections.

- [x] **Step 3: Update audio direction**

Document map audio profiles, placeholder event behavior, OGG policy, and current missing dedicated ambience loops.

### Task 6: Verify, Commit, Push

**Files:**
- All changed files.

- [x] **Step 1: Run full tests**

```powershell
godot_console.exe --headless --path game --script res://tests/test_runner.gd 2>&1
```

- [x] **Step 2: Smoke scenes**

```powershell
godot_console.exe --headless --path game --scene res://scenes/app/app_root.tscn --quit-after 2 2>&1
godot_console.exe --headless --path game --scene res://scenes/field/prototype_field.tscn --quit-after 2 2>&1
godot_console.exe --headless --path game --scene res://scenes/battle/prototype_battle.tscn --quit-after 2 2>&1
```

- [x] **Step 3: Commit and push**

```powershell
git add -A
git commit -m "Complete Bell Saint slice readiness pass"
git push -u origin codex/jrpg-vertical-slice-spec
```

Expected: branch pushes to `https://github.com/DocDamage/GodotRPG.git`.
