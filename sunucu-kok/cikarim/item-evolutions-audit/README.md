# Item Evolutions repair — 2026-10-30

Backend: `sunucu/item-evolutions.js`; registered by `ekipman.js`. Handles UltimateEquip opcodes 8C00–8C06 and the shared Smithy upgrade opcode 0E05.

- Verify the exact template/instance pair and source/target slot. UltimateEquip operates on bag equipment, matching the native selection list.
- Forge transforms one instance in place and returns the configured Asauchi count. RetCount is a material return, not a number of duplicate equipment pieces (native help 70950006).
- Preserve instance, enhancement, sockets, gems, additional attributes, weapon skill and spirit. Advance consumes the configured Asauchi amount. Smithy materials are aggregated and consumed transactionally; equipped upgrades refresh owner stats.
- Send the authoritative bag before the success response so native selection resets see the resulting equipment and material counts.
- Persist inventory, work counters and Gold through a write-ahead journal. Startup and every normal player-state load recover interrupted transactions before other gameplay proceeds. Reject invalid requests and full reward stacks without partial grants.
- Work configuration uses 62100001 for one extra purchase/day, 62100002 for daily energy, 62100005/06 for purchase price/energy, 62100007 for early completion, 62100008 for duration in minutes and 62100009 for energy consumed. Current data yields one free 60-minute job plus one purchasable job/day. Native BuyCount receives purchases used, since its getter subtracts that value from the daily maximum.
- Elapsed jobs become claimable automatically, including after disconnect. Claim fixed Award 23200001 plus one weighted bonus from 62100004. Reject overlapping jobs and duplicate claims. UTC+7 day rollover restores daily energy and purchase quota while retaining pending work/rewards.
- Migrate legacy placeholder energy and three-purchase counters once, retaining pending work. Historical duplicate equipment previously produced by the faulty handler is not deleted automatically.

Native client: select equipment by its identifier rather than a possibly stale list index; guard missing selections; clear stale selected references; request authoritative work state when the countdown expires, with a five-second retry interval. No assets changed.

Validation:

- `node sunucu-kok/sunucu/tests/item-evolutions.test.js`: all 40 Forge and 112 Advance rows, malformed/forged requests, preserved properties, costs/returns, Smithy equipped upgrade, daily quotas, work expiry, reward capacity, early completion, save failures and delayed journal recovery through normal player-state loading.
- `validation/native/result.json`: six successful Flash runtime cases for idle/future/exact/offline expiry and empty Forge/Advance clicks.
- Guild, Cross Server scaling and Top Up Gift Pack regression tests passed.
- `client-validation.json`: all non-ABC assets retained; 19 unaffected methods verified.

Release: `2026103004`. Restart auth/game workers and reopen the launcher. Tests used isolated temporary account data, not an active player session.
