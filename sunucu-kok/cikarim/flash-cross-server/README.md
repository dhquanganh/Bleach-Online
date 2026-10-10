# Local Cross Server Battle (GongFuFight)

Configuration: `../../sunucu/cross-server-config.json`. The local simulation uses 2,000 seeded bots and 131 eligible heroes with all five combat animations plus a cached portrait. Every bot has a unique five-hero ordered squad, shuffled valid battle positions, a unique ID/name and stable seed. These are local simulated opponents, not remote online users.

Native UI receives its configured 18 normal and 12 super opponents. Normal groups unlock progressively; super refresh selects new eligible bots and observes the native three-refresh cap and gold cost. Completing and claiming all five normal groups advances to another seeded set of opponents. The rank list covers all 2,000 bots plus the player. The pool is kept out of the display tree, preserving UI performance.

Dedicated battle handling uses the stored bot squad in the real simulator and native report/result packets; it validates shown opponent IDs, mode, unlocked group, defeated state, attempts and cooldown. Cross reports use version 4 for wide HP. Attempts, score, victory tokens, report history and defeated opponents are saved before notifications. Local replay does not award or consume anything.

Implemented entry/season/base state, rank list, registration, opponents, paid attempts, super refresh, daily offering, pay history, 20 stored battle reports, progressive reward boxes and both actual shop models 12/13. Shops deduct the honour item configured by each offer (challenge token/stone), not gold, then update the full inventory. Rewards and costs are previewed before saving; failed saves refund charges.

Local seasons are seven days and remain available all day, with day rollover resetting daily counters and retaining season score. Native costs/reward tables are reused. Editable win/loss scores and small battle victory-token reward are local simulation defaults. Bot levels are relative to the current player, clamped to 1..159; the existing battle engine balances bot strength against the player's PvP stats.

Flash fixes: disable legacy fixed-ID sorting, clear duplicated daily-offering entries, refresh authoritative base counters, maintain normal/super challenge state, guard repeated battle clicks, handle replay without marking an unrelated target defeated, null-target guard and in-game report playback. Native payloads retain their exact field/count format.

```powershell
node sunucu-kok/sunucu/tests/cross-server.test.js
python sunucu-kok/cikarim/flash-cross-server/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

The compiler starts from the installed live client, uses unique per-class source folders, checks non-code asset preservation, verifies decompiled changes and backs up before install. Tests run in memory. Interactive Flash validation is still needed; restart the backend and reopen the game to apply both sides.

Shop completion: models 12/13 charge native token/stone items atomically; six hero offers recruit through Tavern notifications; duplicate heroes and invalid quantities are rejected. Bag/recruit pushes precede purchase ACK so native shop callbacks see the updated balances. All purchase counters are restored on login. Flash work times are 00:00?24:00 and registration prompt is 24/7. Recompiled client installed; automated protocol tests pass, interactive gameplay still requires client verification.

Direct entry: intro always shows Enter, hides Registered and removes obsolete signup times. Button sends CS_Enter_GongFuFight with one-byte mode 1; backend returns native scene status 1. Empty request retains introduction entry; save failure returns status 2, never successful scene status.

Black screen runtime cause confirmed 2026-10-09: FLASH-VOID CrossUI superGroups ArgumentError #2109. TBeyondLevelPlayerHeadItem used gotoAndStop("H" + hero ID), but the embedded HeadPic clip lacks labels for newer randomized heroes. Replaced with native RoleModel.RoleHead texture loading, preserving selection/killed overlays and guarding stale texture callbacks. Initialization flag is now set after challenge decoding; re-entry refreshes opponents.
