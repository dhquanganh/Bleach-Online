Conquest of Might ? native Nightmare Trial modules 0x81/0x82.

Implemented chapter info, difficulty selection, reset, buff query/refresh, stage battle, progress updates and mop-up. Three chapters with four difficulties and fifteen stages each. Exact configured EnemyArmy and Award rows are used. Stage conditions are checked against actual reports. Losses do not advance. Completion rewards are granted directly to the bag, with full inventory notifications. Rewards and progress commit together; failed saves refund gold.

Local buff behavior: weighted 12/13/14 percent values from ConfigValue 61000004; random ATK, DEF or HP boost applies to all deployed allies only in Conquest. Refresh prices and two-hour auto refresh use native ConfigValue rows. This establishes explicit local behavior where the server implementation was missing.

Mop-up requires previously completing the selected difficulty, stops after twelve cleared stages and allows three uses per chapter per day. Frontend uses the server's remaining count rather than unrelated membership welfare counters.

Flash battle transition waits for successful ACK; rejected requests restore the preparation dialog. Report initialization does not preemptively block the report decoder. Resource assets and existing client patches are preserved.

Validation: tests/conquest.test.js covers chapter state, reset/refund, rewards, sweep eligibility, conditions and buff packets. Actual combat report decoded against the exact five configured enemies. Native AS3 classes recompiled, decompiled and verified; non-code SWF tags unchanged. Interactive gameplay still needs verification in the launcher.

2026-10-10 loader audit: the live request log did not contain the new Conquest ACK trace. Application manifest now selects /public/2026101001/TApplication.swf to invalidate older in-memory/browser application copies; HTTP contents verified against canonical 2026090619 client. Cache explanation is a hypothesis pending a fresh-launch runtime check, not a confirmed root cause.

All successful stage clears now additionally grant gold = monster level * 10 and gems (14900001) = ceil(monster level / 10). Mop-up sums these rewards for each skipped stage at its own level. Currency and inventory/progress updates are sent immediately. Gold is refunded if state persistence fails. Flash mop-up reward text handles gold as currency rather than attempting to resolve an Article for it.
