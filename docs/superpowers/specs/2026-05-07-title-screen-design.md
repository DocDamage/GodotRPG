# Title Screen Design

## Goal

Add a real title screen for *The Last World Museum* before the character creator. It should use the approved "Curated Lie" composition with the darker broken-exhibit mood: a clean museum interface, a cracked central exhibit door, and six Vista Engine panes that hint at the full game.

## Visual Direction

The title screen shows all six major museum wings from the start: Plague, Rome, Saga, War, Modern, and Future. The Plague pane is sharp because it is the current first-slice breach. The other panes remain visible but partially obscured behind curator glass: blur, lower saturation, lower brightness, and a subtle sealed overlay. Players should be able to almost make out what is behind them without reading them clearly.

The center of the screen is a black cracked exhibit door. The surrounding UI is cold, institutional, and readable. The title lettering is warmer and aged, so the screen feels like history trapped inside a machine rather than generic sci-fi.

## Menu

The visible menu items are:

- New Game
- Continue
- Memory Catalog
- Options
- Exit

For this implementation, New Game starts the first slice and advances to the character creator. Continue loads the existing manual save slot if present and routes into the saved phase. Memory Catalog and Options are visible but locked with status text until their real menus exist. Exit quits the game.

## Runtime Asset Rule

Raw source assets stay under `C:/dev/Godot Game/Assets`. The title screen uses curated runtime PNGs under `game/assets/title_screen/panes`. These pane images are cropped and scaled for UI use so the Godot project does not import oversized source sheets.

## Interaction

The title screen must support keyboard and controller navigation using existing Godot UI actions. The first focused button is New Game. Status text explains locked or failed actions. Continue is disabled when no manual save exists.

## Integration

`AppRoot` remains the main scene. `StoryFlowService` starts at a new `title` phase, then advances to `character_creator`, then the existing field route. `AppRoot` mounts the title screen when the current phase is `title`.

## Testing

Automated tests should verify:

- `StoryFlowService` starts at `title` and advances to `character_creator`.
- The title screen scene exists, has six panes, and marks Plague active while all other panes are locked.
- The title screen emits `new_game_requested`.
- Continue is disabled without a save payload.
- `AppRoot` starts on the title screen.
- New Game from the title screen advances to the character creator.
- Continue loads a manual save and routes to the saved phase.
