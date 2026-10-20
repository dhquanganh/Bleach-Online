# Infinite Illusion / Đánh Boss

Native Flash event integrated into the portable game. The Muken Aizen portrait sits immediately to the left of Receive Gift Pack. The revised UI opens an inset 1080×570 modal at (85,36), with the game's Tahoma font and original Common SWF panel, button, close and gold textures. The three rotated cards were removed: device fonts do not display reliably under rotation in Flash. It includes a scrolling damage ranking, pinned personal rank, daily countdown, reward preview and localized Challenge / Sweep buttons. Challenge plays a real battle report; Sweep simulates the same battle without playback. Both share a 15-second cooldown and have no daily attempt limit.

The revision also registers the custom response range in `TProcessorGameRoot`. Registering only in the lobby previously left rankings at “Đang tải” and Challenge only updated backend scores because the root receiver never forwarded the packets. This fixes both ranking snapshots and fight acknowledgements. The loader now selects `/public/2026101004/TApplication.swf` to bypass the old cached UI.

`python cikarim/flash-boss/build-revision.py` builds the root packet route and event UI separately. `PatchUiBodies.java` transfers only seven UI method bodies, preserving the other 46,227 method bodies byte-for-byte; closure targets, signatures, activation traits and scope depths are preserved. Non-code SWF tags are unchanged. A corrupt baseline is rejected. `--baseline PATH` can rebuild from a known working protected client backup. Scratch builds, decompilation checks and timestamped backups remain local. `layout-v2.as.txt` contains the revised window layout; `ui-methods.as.txt` is the combined event source.

Startup repair: a code-only ASM import clears parameters/default arguments on the supplied MethodInfo. The earlier importer inadvertently passed the live MethodInfo, producing `ArgumentError #1063` on the first UI call. The repaired importer passes a disposable MethodInfo, restores method-body scope/activation metadata and verifies parameter counts. Boss icons are hidden while a battle is active.

Runtime validation uses the game's bundled Electron/Pepper Flash runtime, with a child-SWF uncaught-error listener and a private server at 10035 with copied player files. Verified login, boss ranking, Challenge acknowledgement, animated Aizen combat, native result confirmation and return to the ranking panel, without runtime errors. Production player/currency files were never written by the test. See `validation/runtime.log`, `validation/boss-battle.png`, `validation/boss-result.png` and `validation/boss-return.png`.

The strongest Aizen in the installed BaseHero table is Muken Aizen (`11150031`, SSS / quality 7). Boss health is exactly 10,000,000,000, attack 2,500,000 and defense 1,500,000. Every fight starts at full HP. Battle reports use the client's existing version 4 double-precision health format. Scores are actual boss HP lost, capped at maximum HP. No forced victory or client-reported damage is accepted.

Ranking now uses only authenticated real accounts, shared by every account worker through the auth service. MongoDB collection `illusionPeriods` stores each UTC+7 day's highest single-fight damage, fight cooldown, standings and reward outbox. Damage comes from the server battle engine. Ties use earliest achievement then account ID. Legacy local bot standings are discarded; existing reward mail remains claimable. No bot is inserted or simulated by the leaderboard.

At 00:00 UTC+7, the parent scheduler atomically freezes standings and all real-player reward entries before opening the new empty period. Revision checks protect concurrent score submissions. Archived periods remain available for audit and offline reward recovery. Every reward has a stable `aizen:<day>:<accountId>` ID; account workers import outstanding rewards as system mail on refresh/login. Rewards are collected through Mail attachments. Restarting or refreshing does not create duplicate rewards. If the service is stopped at midnight, the next refresh settles overdue periods before accepting new scores.

Native client 2026101976 replaces the bot status label. `build-ranking-text.py` changes only the string constant and verifies all method bodies and unrelated UI assets remain unchanged. Restart the server/auth process and reopen the client after installing this update.

Validation: `node --test illusion-board.test.cjs sunucu/tests/illusion-real-players.test.js`, plus `sunucu/tests/boss-reward-mail.test.js` and `sunucu/tests/infinite-illusion.test.js`.

The payout journal prevents duplicate mail creation, and the currency-file ledger prevents duplicate Gold when recovering an interrupted attachment claim. Item delivery, currency delivery and final attachment removal are saved in recoverable stages. A full bag or currency cap rejects the claim while retaining the attachments; boss reward mail cannot be deleted until claimed. Old partially delivered rewards are migrated to mail containing only the outstanding attachments. Rewards that were already fully credited are not reissued. Tests: `tests/boss-reward-mail.test.js` and `tests/infinite-illusion.test.js` cover the native mail wire format, manual collection, duplicate prevention, save failure/restart recovery, legacy migration and full bags.

| Rank | Gold | Nguyên thạch |
|---|---:|---:|
| 1 | 8,000 | 800 |
| 2 | 7,000 | 700 |
| 3 | 6,000 | 600 |
| 4–10 | 4,000 | 400 |
| 11–50 | 3,200 | 320 |
| 51–100 | 2,000 | 200 |
| 101+ | 1,000 | 100 |

Settings: `sunucu/infinite-illusion-config.json`. State and ranking: `oyuncu.json.infiniteIllusion`, mirrored by the existing state saver to `oyun.db`. Gold: `veri.json.altin`; deduplication ledger: `veri.json.illusionCredits`. Nguyên thạch uses the existing Mystic Shop currency item `14900001`.

Protocol: request `0x01817E00` / response `0x01187E00` carries a UTF JSON event snapshot; fight `0x01817E01` carries one byte (0 Challenge, 1 Sweep) and response `0x01187E01` is a u32 result. Successful Challenge sends the usual report/result packets. Ranking pushes refresh connected authenticated clients every 15 seconds, and immediately after a player fight.

`python cikarim/flash-boss/build.py` recompiles the three modified classes from the live client. It checks that existing non-code SWF tags remain identical, exports the compiled classes for verification, creates a timestamped backup, and installs the canonical and active manifest-selected application files. The script deliberately refuses to patch an already-patched client. For a rebuild, use an unpatched backup that includes the desired previous client changes.

Validation: `node sunucu/tests/infinite-illusion.test.js`, `node sunucu/tests/protect-balance.test.js`, Node syntax checks and native AS3 compilation/decompilation. The existing Cross Server test currently fails in the stone-shop exchange assertion (line 25); Cross Server implementation is untouched by this event. No live player account is used for reward tests. Visual interaction still needs verification after restarting the portable server/client to load the new binaries.

Assets: `gorsel/aizen-head.png` decodes the game's Muken Aizen portrait. `gorsel/infinite-illusion.png` is new artwork generated using the built-in imagegen tool. The full generation prompt is in `asset-prompt.md`.
