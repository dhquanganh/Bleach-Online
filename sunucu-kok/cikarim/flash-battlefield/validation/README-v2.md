# Runtime verification — 2026-10-11

Verified in the bundled Electron 1.8.8 / Pepper Flash 22 runtime with the wrapper's child-SWF uncaught-error listener. Backend, player JSON, currency JSON and database were copied into `.battlefield-runtime-test`; no production profile was used. Test-only timers: 5-second preparation, 120-second combat split across two rounds, 5-second intermission, bosses at seconds 5 and 10 of each round. Production config remains 90-second preparation / 3600-second combat.

Observed: login, Daily > Daily Activities > Chiến trường, shared INFO updates, registration, countdown, both faction scores, server-driven actor movement, auto combat and damage effects, role swap, finish/reward reconciliation, weekly table, shop offers and a purchase sending `BATTLEFIELD-bag` before its reply. No `RUNTIME ERROR` was recorded. Both modal backgrounds were corrected after screenshot inspection and recompiled/retested.

- `battlefield-combat.png`: final client, harbor asset, HUD, actors and effects.
- `battlefield-result.png`: final client, actual winning-faction settlement, +180 honor / +10 activity in this test.
- `battlefield-shop.png`: final client, four configurable offers and honor wallet.
- `battlefield-weekly.png`: earlier client with the same weekly ranking UI; the final change only fixed modal background layering.
- `runtime.log`: accumulated native Flash wrapper messages and simulated clicks for the test sessions.

Final protected canonical and active `/public/2026101105/TApplication.swf` SHA-256:

`889ae968d1c7bcae4fefc3cd70e612626653a1cbaf040ab72f42e31f2e5e1811`

`node sunucu-kok/sunucu/tests/battlefield.test.js` passes; it covers multi-ID arena behavior and persistence separately from this native UI check. The host server still uses one shared player profile, so this runtime check uses one human plus eight explicitly local AI, not independent authenticated accounts or cross-server networking.
