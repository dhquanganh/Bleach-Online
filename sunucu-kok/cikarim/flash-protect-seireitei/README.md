# Protect Seireitei, all day

Local event uses the native CityDefend scene and two gates. TimeMall/Mystic Shop currency item 14900001 is awarded as 1 Nguyen thach after each valid attack, whether won or lost. No rewards on entry, invalid requests or replay. Battles have a persisted 20-second cooldown across re-entry. Rewards and progression are saved before ACK/report/result/inventory notifications.

Configuration: `../../sunucu/protect-seireitei-config.json`. The two gates use Enemy 12810000+worldLevel and 12820000+worldLevel (levels 1..159). Reports use known gate model roles 12810001/12820001 because native RoleModel rows end at level 150; actual level, HP, attacks, defense and speed come from the correct enemy row.

Implemented local functions: native entry, gate approach/exit, battle, gate HP, own daily damage ranking, paid/native natural revival, two-gate progression, immediate gem inventory, 20 recent reports and replay inside Flash. This local mode shows no fabricated guild/player opponents. Completing both gates ends that round and returns to town; the event remains open for another round.

Flash changes: Daily Activities always offers Join for Protect Seireitei, displays 24-hour availability and gem reward; fight starts only after ACK; request/cooldown guards; delayed HP/stage/end updates until playback finishes; cloned deferred status packet; accurate server death deadline; idle gate exit does not simulate death; auto-run retries after cooldown and resumes at the next gate; a fatal request error stops automatic requests.

Native DailyActivity JSON and 25 resource variants updated. Other event row bytes preserved. `node sunucu-kok/cikarim/daily-activity-paketle.js --check` verifies installed packages. If changing the reward/cooldown config later, edit the Protect description in DailyActivity.json and rerun that resource packer.

Validation:

```powershell
node sunucu-kok/sunucu/tests/protect-seireitei.test.js
python sunucu-kok/cikarim/flash-protect-seireitei/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

Build preserves current client changes, backs up the original SWF, checks that only AS3 code changed, and decompiles the result to verify the changes. Runtime Flash interaction still needs testing in the game. Restart the backend and reopen the game to load the changes.

## Loading 0% regression

The CityDefend ACK previously set TBattleHandle.IsInBattle before the report arrived. The current battle report handler rejects packets when this flag is true, so it ignored the real report and never started resource loading. The ACK now leaves that flag false and holds the separate FightPending guard; the battle handler sets IsInBattle only after decoding the report. Returning to the map clears FightPending. Existing delayed HP/stage handling still runs after battle playback. Protect-specific report traces are included through the existing diagnostic opcode.

Build phases use unique directories. Reusing a phase folder with an old class can reimport that class and undo an earlier phase's change; decompiled verification now checks the cross-class ACK/report order explicitly before installation.

## Boss balance

Protect Seireitei boss HP is 9,100,002,004 for each gate. Attack and defense multiply the prior per-level stats by 4. Other events use their existing formulas. The balance migration resets the current boss HP to the new maximum once, keeping earned items and participation counters. Subsequent reloads and day rollovers preserve remaining HP.

CityDefend entry/HP packets and damage rankings use double precision; the map UI uses Number instead of uint/int. Protect battle reports use version 4 with double current/maximum HP. Legacy versions 1..3 retain their existing integer fields. Flash role health models and health-bar getters accept Number, with large integer text displayed without 32-bit casts. Per-hit combat commands retain the original wire format.
