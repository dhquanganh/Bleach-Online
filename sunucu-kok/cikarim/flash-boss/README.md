# Infinite Illusion / Đánh Boss

Native Flash event integrated into the portable game. The Muken Aizen portrait sits immediately to the left of Receive Gift Pack. The revised UI opens an inset 1080×570 modal at (85,36), with the game's Tahoma font and original Common SWF panel, button, close and gold textures. The three rotated cards were removed: device fonts do not display reliably under rotation in Flash. It includes a scrolling damage ranking, pinned personal rank, daily countdown, reward preview and localized Challenge / Sweep buttons. Challenge plays a real battle report; Sweep simulates the same battle without playback. Both share a 15-second cooldown and have no daily attempt limit.

The revision also registers the custom response range in `TProcessorGameRoot`. Registering only in the lobby previously left rankings at “Đang tải” and Challenge only updated backend scores because the root receiver never forwarded the packets. This fixes both ranking snapshots and fight acknowledgements. The loader now selects `/public/2026101004/TApplication.swf` to bypass the old cached UI.

`python cikarim/flash-boss/build-revision.py` builds the root packet route and event UI separately. `PatchUiBodies.java` transfers only seven UI method bodies, preserving the other 46,227 method bodies byte-for-byte; closure targets, signatures, activation traits and scope depths are preserved. Non-code SWF tags are unchanged. A corrupt baseline is rejected. `--baseline PATH` can rebuild from a known working protected client backup. Scratch builds, decompilation checks and timestamped backups remain local. `layout-v2.as.txt` contains the revised window layout; `ui-methods.as.txt` is the combined event source.

Startup repair: a code-only ASM import clears parameters/default arguments on the supplied MethodInfo. The earlier importer inadvertently passed the live MethodInfo, producing `ArgumentError #1063` on the first UI call. The repaired importer passes a disposable MethodInfo, restores method-body scope/activation metadata and verifies parameter counts. Boss icons are hidden while a battle is active.

Runtime validation uses the game's bundled Electron/Pepper Flash runtime, with a child-SWF uncaught-error listener and a private server at 10035 with copied player files. Verified login, boss ranking, Challenge acknowledgement, animated Aizen combat, native result confirmation and return to the ranking panel, without runtime errors. Production player/currency files were never written by the test. See `validation/runtime.log`, `validation/boss-battle.png`, `validation/boss-result.png` and `validation/boss-return.png`.

The strongest Aizen in the installed BaseHero table is Muken Aizen (`11150031`, SSS / quality 7). Boss health is exactly 10,000,000,000, attack 2,500,000 and defense 1,500,000. Every fight starts at full HP. Battle reports use the client's existing version 4 double-precision health format. Scores are actual boss HP lost, capped at maximum HP. No forced victory or client-reported damage is accepted.

Ranking keeps each participant's best single fight in the current UTC+7 calendar day, with ties resolved by earliest achievement then stable ID. Each day's leaderboard starts with 100 distinct randomly selected bots from the existing 2,000-bot pool (`botInitialCount`). Existing partially populated leaderboards are filled up to that count. After the initial batch, one randomly selected bot attacks every 300 seconds, preferring a participant who has not entered today's ranking yet. Bot levels, hero growth, power factor and formation determine damage through the same engine. Bot equipment multipliers are configurable; scheduled fights preserve the player's last combat statistics. Missed offline intervals are not replayed. Tests: `tests/illusion-bots.test.js`. A measured batch of 100 actual engine simulations completed in about one second.

At UTC+7 midnight (processed within the scheduler's 15-second interval), the previous ranking is settled and the new ranking starts empty. The player's reward is sent as an unread system mail titled “Thưởng Boss [date] — Hạng [rank]”, with Gold and Nguyên thạch attachments. It is not credited automatically: the player uses the existing Mail → Receive attachment action. Native `SC_Mail_MailRecNtf` immediately refreshes an open mailbox and triggers the new-mail indicator. Bots compete but do not receive account rewards. If the server was stopped at midnight, settlement occurs on the next startup tick.

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
