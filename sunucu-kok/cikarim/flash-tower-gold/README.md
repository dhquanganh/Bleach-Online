# Tower of Gold

Independent portable event, state `oyuncu.json -> towerGold`. Trial Tower progress is separate.

Tower battles require valid targets for row-restricted skills. If no living target remains in the required row, the actor uses a Standard without spending Mystery fury. The execution and scheduling paths use the same rule. Other battle modes retain their existing target fallback policy. This prevents floor 46's Shin Isshin/Urahara from repeatedly applying middle/back controls to a lone front-row Obito, blocking his Standards and Rage Roots while passive Kamui continues. Rage still requires HP below 50%; Roots retains its shared Mystery recovery and chakra cost. A short fight can end before Roots becomes ready; it is not forced into every battle.

Regression: `node sunucu-kok/sunucu/tests/tower-gold-combat.test.js` reproduces the old floor-46 lock and verifies the repaired case, Roots at rounds 5/8/11 in the sustained fixture, real damage, both cooldown families, legal controls against valid row targets, round-limit losses, invalid inputs and corrupt saved replays. Tests clone fixture data and do not advance the player's actual floor.

Each new floor awards `min(floor * 100, 50000)` gold and `min(floor, 500)` Reincarnation Stone (14100698), only upon a real victory. Failed fights and cleared-floor replays grant no loot. First and fastest clear records are persisted per floor. The UI displays the last completed floor's records, current floor and the next four floors. No reset operation exists.

The roster uses existing non-main heroes, ordered by quality. Higher floors select later/stronger roster entries and increase enemy count at floors 20 and 50. Tower-only HP/attack/defense/speed use baselines 600/35/10/10 multiplied by 1 + 0.5*(floor-1) + 0.1*(floor-1)^2, saturating at 1 billion. Hero identity and skills still come from the existing roster. Floor metadata uses JSON numbers, with no configured final floor. The legacy battle report contains signed 16-bit level fields; above 32767 only the report level is saturated, while floor metadata and enemy stats keep growing. Combat integer stats saturate at 1 billion to avoid integer overflow.

Custom packets: CS 0x0181f100 info, CS 0x0181f101 challenge (UTF JSON floor), SC 0x01180a7e state (UTF JSON), SC 0x01180a7f battle admission. Native combat report/result and inventory/currency updates are used.

Flash adds a Trial Tower icon copy adjacent to the existing Trial Tower shortcut in Battle, labeled Tower of Gold. Trial Tower artwork, hero model animation and the native Reincarnation Stone icon are reused. The event does not expose a reset button.

Build: `python sunucu-kok/cikarim/flash-tower-gold/build.py --ffdec PATH/ffdec.jar --install`.
Test: `node sunucu-kok/sunucu/tests/tower-gold.test.js`.
Build verifies decompiled patched classes and byte-for-byte preservation of non-code SWF tags, then backs up the installed SWF. Actual interactive Flash rendering/clicking still requires manual verification. Restart server and game after installation.
