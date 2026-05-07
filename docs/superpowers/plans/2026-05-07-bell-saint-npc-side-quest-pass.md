# Bell Saint NPC and Side-Quest Pass

## Goal

Make the first playable slice feel more inhabited and more playable by adding meaningful NPC presence and a small, reusable side-quest interaction path.

## Scope

- Add a few high-signal NPCs to Hallowmere and the hidden hospital corridor.
- Add two small first-slice side quests:
  - `clean_cloth`: a Sick Woman reward that gives emergency bandages.
  - `wrong_chart`: a Nurse Echo reward that gives a fever charm after the hospital reveal.
- Keep the implementation data-driven through existing map interaction data.
- Avoid a full quest-log UI until there are enough quests to justify it.

## Implementation Steps

1. Add failing tests.
   - Verify first-slice maps include the added NPCs.
   - Verify side-quest payloads come through `MapInteractable`.
   - Verify field interactions complete side quests once.
   - Verify repeat interactions do not duplicate rewards.

2. Extend interaction results.
   - Carry `display_name` and optional `quest` data from map entries.
   - Preserve current direct interaction behavior for existing tests.

3. Apply side-quest results in `PrototypeField`.
   - Check completion flags in `GameState`.
   - Add rewards once.
   - Show completion or repeat text in the field status label.

4. Populate map data.
   - Add `fever_child` and `corpse_cart_driver` to Hallowmere.
   - Add `nurse_echo` to the hidden hospital corridor.
   - Attach `clean_cloth` and `wrong_chart` quest payloads to NPCs.

5. Update documentation.
   - Note the playable side-quest pass in the README.
   - Note the slice’s expanded NPC/side-quest content in the story bible.

6. Verify.
   - Run the headless test suite.
   - Run field/app/battle smoke boots.
   - Run verbose leak scan and `git diff --check`.

