# Pre-Playtest Hardening Plan

Goal: make the Bell Saint slice tight enough for first human testing by closing controller, save, and edge-case gaps that can be validated before manual QA.

## Implementation Scope

- Add visible controller help prompts to the character creator, field, battle, Tetra, and reward surfaces.
- Add battle cancel/back behavior so controller users can close skill/target menus without committing an action.
- Preserve and test controller accessibility settings through save/load.
- Add real manual-slot roundtrip coverage for first-slice completion/evidence state.
- Keep existing map collision, spawn, transition, encounter pacing, and boss-safety tests green.

## Manual QA Checklist After This Pass

- Complete the character creator with controller only.
- Move through Hallowmere, inspect story props, complete side quests, and enter the dungeon with controller only.
- Open battle skills/items, cancel back to commands, select targets, defeat Bell Saint, and read the reward panel with controller only.
- Start a Tetra match, select a hand card, move to board slots, and play a card with controller only.
- Save after boss completion, restart, load, and confirm Bell Clapper, Bell Saint Memory Card, Mira, evidence progress, and autosave status remain intact.
