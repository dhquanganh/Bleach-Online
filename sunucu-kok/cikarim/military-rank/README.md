# Upgrade Ranks repair

The account-scoped `sunucu/military-rank.js` owns rank lookup, prestige lookup,
promotion, daily salary and formation bonuses. New accounts explicitly start at
40100001 with zero prestige. Existing valid saved ranks are preserved. Captured
login rank/prestige values are replaced in both server and offline login paths.

`Military.json` supplies each rank's total bonus: the four primary stats and, at
higher ranks, damage bonus/reduction. Bonuses apply to deployed heroes, feed the
shared character/combat stat pipeline, and refresh after promotion/deployment.
They are computed from the current rank; promotion never adds permanent stat
increments that could duplicate after relogging.

Promotion requires the next row's prestige threshold. `costCredit` is daily upkeep,
charged once when claiming that day's salary rather than when promoting. Salary
uses exact 64-bit silver arithmetic. Save failure restores the two account JSON
files; daily claim state and rank are not committed on failure.

The native client patch fixes acquired-rank labels, maximum-rank preview,
prestige assignment, initial character synchronization, failed-upgrade refresh
and salary claim state. It keeps the existing client assets and other features.
Installed client cache version: **2026101940**.

Validation:

```powershell
.\node\node.exe sunucu-kok/sunucu/tests/military-rank.test.js
.\node\node.exe sunucu-kok/sunucu/tests/reiatsu.test.js
.\node\node.exe sunucu-kok/sunucu/tests/level-stats.test.js
.\node\node.exe sunucu-kok/sunucu/tests/obito-combat.test.js
```

The rank suite creates temporary account files and checks creation defaults,
account isolation, relog persistence, both attribute groups, reserve/deployed
bonuses, promotion limits, claim limits, salary carry/upkeep, failed-save rollback,
login field offsets and deployment stat notifications. The native client was
compiled with FFDec, re-exported for verification, and checked for unchanged
non-ABC assets. Interactive game UI testing remains manual.
