# Tower of Gold

Independent portable event, state `oyuncu.json -> towerGold`. Trial Tower progress is separate.

Combat audit (2026-10-22): malformed Tower containers and record maps recover
without discarding a valid floor. Incomplete clear records no longer crash the
preview, next clear, or faster-clear update; replay requires valid metadata and
a decodable saved report. Preview arithmetic stays within safe integer floors,
and the final representable floor cannot advance into an unsafe integer.
Ordinary combo chance and damage use the battle's supplied random function,
matching the rest of seeded combat. The default live random source is unchanged.
Obito Rage's automatic once-per-round enhanced Kamui refresh is intentionally
independent of paid Mystery cooldown; the floor-46 test distinguishes them.
`tests/tower-gold-integrity.test.js` covers corrupt saves and seeded combo reports
without account writes. Backend restart is required to load these changes.

Tower battles require valid targets for row-restricted skills. If no living target remains in the required row, the actor uses a Standard without spending Mystery fury. The execution and scheduling paths use the same rule. Other battle modes retain their existing target fallback policy. This prevents floor 46's Shin Isshin/Urahara from repeatedly applying middle/back controls to a lone front-row Obito, blocking his Standards and Rage Roots while passive Kamui continues. Rage still requires HP below 50%; Roots retains its shared Mystery recovery and chakra cost. A short fight can end before Roots becomes ready; it is not forced into every battle.

Regression: `node sunucu-kok/sunucu/tests/tower-gold-combat.test.js` reproduces the old floor-46 lock and verifies the repaired case, Roots at rounds 5/8/11 in the sustained fixture, real damage, both cooldown families, legal controls against valid row targets, round-limit losses, invalid inputs and corrupt saved replays. Tests clone fixture data and do not advance the player's actual floor.

Each new floor awards `min(floor * 100, 50000)` gold and `min(floor, 500)` each of Reincarnation Stone (14100698) and Blood War Crystal (14100779), only upon a real victory. Starting at floor 100 it also awards Nguyên thạch (14900001), with quantity equal to the cleared floor: 100 at floor 100, 150 at floor 150, etc. The per-drop quantity is bounded at 65535 by the native inventory protocol. Failed fights and cleared-floor replays grant no loot. First and fastest clear records are persisted per floor. The UI displays the last completed floor's records, current floor and the next four floors. No reset operation exists.

Before advancing a newly cleared floor, the server simulates adding all item rewards to a copy of the account and verifies the exact inventory delta. A full bag or capped stack rejects completion without advancing the floor or granting partial rewards. The native admission response can carry a readable error message so the player can spend/free items and retry. The original four-byte error format is still accepted.

The roster uses existing non-main heroes, ordered by quality. Higher floors select later/stronger roster entries and increase enemy count at floors 20 and 50. With `n = floor - 1`, HP/defense/speed retain baselines 600/10/10 multiplied by `1 + 0.5*n + 0.1*n^2`. Offensive stats now use `35 * (1 + 0.5*n + 0.1*n^2 + 0.01*n^3)`, rounded and bounded at 1 billion; Magic ATK follows the same curve so enemy Ninjutsu does not retain unrelated base-hero stats. Floor 1 stays at 35 ATK; floor 100 reaches 375676 ATK (over ten times the previous curve). Hero identity and skills still come from the existing roster. Floor metadata uses JSON numbers, with no configured final floor. The legacy battle report contains signed 16-bit level fields; above 32767 only the report level is saturated, while floor metadata and enemy stats keep growing. Combat integer stats saturate at 1 billion to avoid integer overflow.

Custom packets: CS 0x0181f100 info, CS 0x0181f101 challenge (UTF JSON floor), SC 0x01180a7e state (UTF JSON), SC 0x01180a7f battle admission. Native combat report/result and inventory/currency updates are used.

Flash adds a Trial Tower icon copy adjacent to the existing Trial Tower shortcut in Battle, labeled Tower of Gold. Trial Tower artwork, hero model animation and native inventory icons are reused. The current enemy ATK is sent in the server preview and shown in the panel. Three reward slots show Stones, Crystals and Nguyên thạch, with a floor-100 unlock message before the new drop becomes available. Upcoming-floor entries show their server-provided Nguyên thạch amount. All quantities are looked up by reward item ID rather than assuming fixed array positions. The event does not expose a reset button.

To prepare the first reward-panel upgrade from an older live panel, run `upgrade-rewards.py --ffdec PATH/ffdec.jar`. It exports the current class so later character changes are preserved; it refuses to reapply over an already upgraded panel. Rebuild: `python sunucu-kok/cikarim/flash-tower-gold/build.py --ffdec PATH/ffdec.jar --tower-only --install`. The installed client and loader cache version is **2026101954**.
Test: `node sunucu-kok/sunucu/tests/tower-gold.test.js`.
New scaling/reward regression: `node sunucu-kok/sunucu/tests/tower-gold-scaling.test.js`. It covers cubic attack gaps, safe bounds, the 99/100/101 threshold, preview/result consistency, actual inventory delivery and native notifications, save/reload, loss/replay/deduplication and full inventory rejection. Account writes use a temporary directory.
Build verifies decompiled patched classes and byte-for-byte preservation of non-code SWF tags, then backs up the installed SWF. Actual interactive Flash rendering/clicking still requires manual verification. Restart server and game after installation.
