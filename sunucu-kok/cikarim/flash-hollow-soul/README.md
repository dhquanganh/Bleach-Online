# Hogyoku / CrashJade

This native CrashJade module powers Hogyoku. Hollow Soul Map is the separate NijiaStar module (see flash-hollow-soul-map). The backend now uses strict native packet layouts and atomic cloned-state transactions for drawing, one-click drawing, picking up, selling gray items, direct unlocking, buying attempts, bag slots, chips/pellets, EXP upgrades, equipping/unloading and the actual model-15 shop purchase.

Costs and limits come from ConfigValue and DailyCrashJadeKind. Each draw produces one level-1 jade. MakeJadeFlag is a bitmask (first stage always available); direct unlock opens bit 8 and grants the configured chip/shop-coin rewards. One-click draws stop at the native 39-item temporary board, available silver or daily attempt allowance. Jade bag capacity is independent (initial 25, then native unlock price tiers).

The project has no server-side rarity or advancement probabilities. `../../sunucu/crash-jade-config.json` documents editable fallback quality weights, 50% stage advancement, 10% chip and 5% shop-coin bonus chances. They are local defaults, not verified original game rates.

Swallow uses each source's configured crushed EXP plus invested EXP, rejects duplicate/self/incorrect-owner IDs, and resolves the native nextID chain. Max-level jades cannot consume further resources; pellet upgrades consume only the amount needed to reach the maximum and preserve excess pellets. Equipment requires an owned hero and the unlock levels from BaseHero.f48. Occupied slots are rejected, matching the client drag/unload flow. Changes refresh the authoritative hero attribute packet used by Partners and combat.

The shop uses its actual model-15 honour currency, jade inventory capacity, quantity and purchase limits. Native receipts add the jade/pellet immediately. A custom packet inside the existing CrashJade range (0x01186c7e) updates absolute chips, pellets, shop coins, slots, unlocked stages and draw counters without reopening or F5.

Flash fixes: reply/request busy guards, native state synchronization, exact-balance silver check, single-pickup animation index, correct pellet type branch, unknown shop-row guard and inventory refresh after receiving a shop item. Gray quality zero is preserved in the backend item loader. Generation distinguishes required item level from the jade level encoded in template IDs.

Build from the installed live client (preserves other features), with unique compile phase folders and decompiled assertions:

```powershell
node sunucu-kok/sunucu/tests/crash-jade.test.js
python sunucu-kok/cikarim/flash-hollow-soul/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

Tests are in-memory and do not write player files. Restart the backend and reopen the game to load changes. Interactive Flash testing remains necessary.
