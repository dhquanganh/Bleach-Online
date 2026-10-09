# Soul Hunt / TreasureMap

New `sunucu/soul-hunt.js` replaces the incomplete TreasureMap handlers. Existing state `oyuncu.json -> hazine` is migrated; blue/red balances and an active hunt are retained. The old stored `last` deadline is converted to a start timestamp for Flash actor packets.

All five target point awards are taken from Digging.award1: Menos 12 blue, Gillian 16 blue, Arrancar 10 blue +5 red, Espada 17 red, Vasto Lorde 25 red. Silver follows BuyMoney.money * Digging.silverNum1 /100 using main reincarnation history level, as the target preview does. Soul loot uses the cumulative thresholds from Digging.award2. Only completion grants the hunt reward once.

Free finish at the deadline, gold fast-finish based on 60150005, refresh costs/limits from 60150006, direct activation costs/bonus from Digging, daily quota and VIP purchases use 60150002/60150007/VipConfig. Coupon refresh/activation spends coupons before gold. Invalid requests, active-hunt changes, repeated completion and insufficient material/currency requests are rejected. Cloned state is committed before item notifications; paid save failures refund currency.

Mall model 3 exchange uses type [8]/[9] points and integration, validates level/quantity and delivers actual inventory items. It does not use the gold-shop branch. Both star totals are pushed as absolute native StarsNumRet, with full state and full bag updates after changes. Flash refreshes exchange and map windows together, auto-claims when the timer reaches zero, and polls state at 15-second intervals for day rollover and missed updates. Mismatched VIP error opcodes are corrected.

Portable robbery uses local arena-bot teams as hunting opponents because there is no multi-user account backend. Targets are validated, self/invalid targets denied; daily/cooldown/per-target limits apply. Robbery starts the native battle using FightOk + report/result, awards on real wins only, and saves the last 20 robbery reports for the native log panel. No outgoing requests to other servers.

Tests: `node sunucu-kok/sunucu/tests/soul-hunt.test.js`.
Build: `python sunucu-kok/cikarim/flash-soul-hunt/build.py --ffdec PATH/ffdec.jar --install`. `--processor-only` patches just the live processor while preserving other classes. Builds decompile/verify the output, preserve all non-code SWF tags and back up the installed client. Restart server and game to load. Actual interactive Flash rendering/clicking still requires manual verification.
