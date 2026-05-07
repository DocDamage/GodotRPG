# The Last World Museum Story Bible

## Working Title

The Last World Museum

## Core Premise

Long after humanity's final disaster, a reality-engine called The Last World Museum was built outside normal time to preserve every age of humanity before it vanished. It preserved facts, but also stories, myths, lies, fears, propaganda, and unresolved guilt.

The museum is now collapsing. Exhibits bleed into each other, people inside the exhibits are remembering they are trapped, and the Curator AI is trying to freeze every age into a clean loop.

The party must decide whether history should be preserved, corrected, freed, or allowed to die.

## Big Rule

The Archive Makes Belief Physical.

Every era has three layers:

- The Fact: what actually happened.
- The Myth: what people believed happened.
- The Wound: what was hidden, erased, or unresolved.

When those layers conflict, monsters are born.

## Theme

History is not just what happened. It is what people choose to remember.

The villain wants history to be painless, clean, heroic, and controllable. The heroes learn that preserving history honestly means preserving ugly truths too.

## Protagonist

The first protagonist direction is Option 3: The Stolen Child.

The protagonist is The Uncatalogued: a person pulled from one historical era as a child and raised by the museum with no official exhibit tag. The Curator calls them an error. Their arc is: "I am not an error just because I do not fit your records."

## Core Party

- The Uncatalogued: balanced sword/relic user.
- Roman Engineer: shield, formations, earth/stone skills.
- Plague Apothecary: healer, poison, cleansing, plague magic.
- Viking Skald: axe/spear fighter, buffs, fate manipulation.
- Trench Runner: speed, evasion, debuffs, guns/explosives.
- Codebreaker: support, signals, enemy disruption.
- Neon Archivist: tech mage, hacking, illusions, energy weapons.

## Main Antagonists

- The Curator: central museum intelligence that censors history to make it survivable.
- The Unremembered: erased people, cultures, victims, and events demanding to be seen.
- The Patron: human or post-human designer who wanted humanity remembered kindly.

## Chapter Rhythm

Each chapter follows this loop:

1. Enter a historical wing.
2. Learn the official version.
3. Find contradictions.
4. Recruit or deepen a party member.
5. Discover the hidden wound.
6. Fight a myth/history boss.
7. Recover an anchor relic.
8. Return to the hub.
9. Unlock new wing connections.

## First Playable Slice: The Bell Saint

Maps:

- Empty museum hallway.
- Broken exhibit door.
- Plague town street.
- Apothecary house.
- Chapel.
- Underchapel Drain.
- Hidden hospital corridor.
- Bell tower boss room.

Characters:

- Protagonist.
- Plague Apothecary.
- Curator voice.
- Infected townspeople.
- Church Warden.
- Bell Saint boss.

Story flow:

1. The protagonist wakes up during a museum breach.
2. The Curator orders them to seal the Plague Wing.
3. Inside, the town is trapped in the same quarantine day.
4. The apothecary remembers dying yesterday.
5. The party descends into the Underchapel Drain, where plague water, hospital waste, and museum pipes mix.
6. The party finds a hospital corridor hidden beneath the chapel.
7. The Curator claims the hospital is contamination from another exhibit.
8. The apothecary realizes the museum has been editing the town's history.
9. The church warden rings the plague bell.
10. The bell transforms into The Bell Saint.
11. After the fight, the Curator says: "Unauthorized truth recovered. Correction required."

The player should understand immediately: this is history, but broken; fantasy, but not random; a museum, but also a prison.

Runtime status:

- Sev's character creator is the first playable screen.
- The Bell Saint route is defined in both story flow and map flow data.
- Hallowmere, Mira's Apothecary, the chapel, Underchapel Drain, hidden hospital, and Bell Tower have authored field scenes with inspectable story props.
- First-slice prop placement is data-driven through layered navigation, story evidence, and atmosphere entries, so map density can be tuned without editing each map script.
- Blocking prop collision is defined in the same manifest for houses, wells, coffins, beds, chapel benches, sewer machinery, hospital props, and Bell Tower anchor objects while preserving route spawns and transitions.
- Story evidence props now carry inspection audio cues from the same manifest, letting museum machinery, plague evidence, medicine props, and bell anchors sound distinct when examined.
- Story evidence inspections now set stable `discovered_prop_*` flags, show one-time "Evidence recovered" feedback, and maintain a `discovered_story_props` list, giving later codex entries, optional dialogue, and completion checks a real evidence trail.
- The Truth Recovered reward panel now summarizes first-slice evidence progress as `Evidence Found: found / total`, plus an `Evidence Remaining` hint for the earliest maps still missing inspected story props. This lets the chapter close reflect how much of Hallowmere's hidden record the player examined.
- Evidence discovery is save/load covered. If an older save has individual `discovered_prop_*` flags but no `discovered_story_props` list, the game rebuilds the list when loading.
- Hallowmere now includes additional ambient residents and a `clean_cloth` side quest from the Sick Woman that grants Clean Bandages.
- The hidden hospital now includes Nurse Echo and a `wrong_chart` side quest that grants the Fever Charm.
- Mira recruitment, Bell Saint completion flags, Bell Clapper, and The Bell Saint Memory Card are save/load covered.
- The battle system resolves Bell Saint victory into the Truth Recovered reward scene.
- The Bell Saint reward scene confirms autosave, and the first-slice encounter pacing now favors fewer dungeon fights before the boss.
