# Bleach UI / Void Regions sprites — native validation, 2026-10-11

Tested in Electron 1.8.8 / Pepper Flash 22 at 1250 × 650 against the private backend and copied profile/database in `.battlefield-runtime-test`. Production match timers and account data remain unchanged.

Cooldown/ground alignment (client `2026101112`): the renderer removes complete
actors during death, combat cooldown and endpoint cooldown. Cached positions are
discarded while hidden and when changing lane/team, preventing diagonal slides
from stale positions after respawn. The Void artwork's lower-center anchor is
aligned with the actor's ground marker. At the opposite endpoint, the server
starts a cooldown, then returns the actor to its own lane base for the next run.
Hidden actors do not obstruct visible runners, and cannot accept movement commands.
Native evidence: `cooldown-native-map.png`, `cooldown-native-hidden.png`,
`cooldown-native-resume.png`, `cooldown-native-runtime.log`. An authoritative
sample had 14 hidden cooldown/dead actors and 6 visible runners. Native audit logs
confirm endpoint finish/resume transitions; no uncaught Flash exceptions occurred.
Tests cover complete endpoint cycles, invisibility during cooldown, reappearance,
and 220 ticks of repeated respawn/protection/duel cycles without scheduler stalls.
The formation, lanes and legacy battlefield test suites pass.
Canonical/active `2026101112` SHA-256:
`abb29e6970fcd9276d2dc6dfbb657c1c1fce8aeeb4c9a69cafdc103db80ce5bf`.

Previous straight-lane revision (client `2026101111`): `lanes-native-map.png`,
`lanes-native-encounters.png`, `lanes-native-final.png` and
`lanes-native-runtime.log` document native route guides and encounters.
The private authoritative world contains 20 actors on the three exact lines;
all recorded duels have matching attacker/defender lane IDs and total faction
resources remain 1000. No uncaught Flash errors were observed.
`battlefield-lanes.test.js`, `battlefield-formation.test.js` and
`battlefield.test.js` pass. Tests cover straight movement, balanced lane counts,
cross-lane rejection even at overlapping positions, same-lane encounters,
base-only lane selection, blocking passage through a recovering enemy and migration.
Canonical/active SHA-256:
`4a02743a2ffbcc46aef807f25d204610754360bd963eb387d18fb50294760de9`.

The interface reuses the game's panel/button textures. Map actors use Void Regions' original `Role_*` movie clips from `3E000000.swf`. The library contains professions 1, 3 and 4; profession 2 uses profession 1 with the same sex. Actual combat heroes and formations remain unchanged.

Walking fix (client `2026101110`): native playback observed 57 moving samples,
covering all 16 animation frames. The cumulative clock progressed from 5 to 8760
milliseconds without resetting across snapshots. `void-walk-runtime.log` records
these observations; `verify-walk.py` checks frame coverage, moving coordinates,
clock continuity and absence of uncaught errors. `void-walk-a.png`,
`void-walk-b.png`, `void-walk-c.png` and `void-walk-return.png` are visual evidence.
The old exponential position interpolation was replaced with a continuous
one-second interpolation between authoritative positions.

Previous animation client `2026101110` SHA-256:
`6e2cce2974ac3f71d73e7dcfb48f4c54df27f393ce062c4e2198aec31cb600b2`.

Previous UI-client evidence (`2026101109`):

- `void-final-map.png`: resource bar, native sprites, HUD and ranking.
- `void-final-movement.png`: a later native walking animation frame and positions.
- `void-final-formation.png`: formation modal with background input blocked.
- `void-native-live.png`: live bot reports and updated faction scores.
- `void-final-replay.png`, `void-final-duel-result.png`, `void-final-return.png`: real native replay, result and return to the battlefield.
- `void-final-town.png`: return to the town interface.
- `runtime.log`: final wrapper trace, with child-SWF exceptions surfaced as `RUNTIME ERROR`.

Additional checks before the last button text sizing adjustment:

- `void-ui-replay.png`: real native formation replay and skills.
- `void-ui-duel-result.png`, `void-ui-return.png`: replay result and battlefield return.
- `void-before-final.log`: traces for these checks.

Previous protected client `/public/2026101109/TApplication.swf` SHA-256:

`e9363a574127d0c2c5b15b397d9164eef559978e5c6eb1731d3168dbac88c365`

Build verifies preserved non-code SWF assets and replay return routes. `battlefield-formation.test.js` passes: native reports, resource conservation, cooldown/respawn, strategy, honor reconciliation, replay and migration. Previous video-preset evidence is retained in `README-video-v6.md`. Implementation notes are in `../ui-native.md`.
