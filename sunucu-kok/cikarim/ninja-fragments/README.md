# Ninja icons, Modify Fragments and Rasen Shuriken playback fix

Naruto and Jiraiya HeadIcon/SmallIcon now use **48×48**, matching the native UI slot rather than 64×64. Jiraiya uses the user's exact supplied portrait preserved at `gorsel/jiraiya-icon-input.png` (68×74), read from the supplied image on the clipboard and visually confirmed. Full-sized character artwork and battle sprites are unchanged. The respective Naruto/Jiraiya build scripts preserve these settings when rebuilt.

| Partner | Modify Fragment | Mystic offer |
| --- | --- | --- |
| Naruto [Sage Mode] / 11120901 | 14130901 | 41120901 |
| Jiraiya [Toads Chant] / 11120903 | 14130903 | 41120903 |
| Kabuto [Great Ninja War] / 11120910 | 14130910 | 41120910 |

Kabuto uses the user's supplied **68×69** portrait, preserved at `gorsel/kabuto-icon-input.png`, packed to 48×48 character icons and a 40×40 inventory icon. Its full kit and asset pipeline are documented in `../kabuto-gnw/README.md`.

Each offer exchanges **100 Nguyên thạch (14900001)** for one fragment, following the existing Mystic Shop price. Only owned partners appear. Article, BlackMarket, HeroChangeAttr and the server offer catalog are synchronized. Fragment association supports star upgrades and reincarnation. No unrelated partner's Modify challenge/city is reused. Inactive fragment-only associations have no challenge city; the native Hero Change constructor skips those entries while Reincarnation still reads their fragment IDs. Inventory icons are native 40×40 TexClient textures. Existing database records outside these additions are preserved byte-for-byte. No fragments/currency are granted to live saves automatically.

## Rasen Shuriken freeze

Reproduced using a native Flash report where Naruto has 100 HP and reflects 100 damage onto himself while Rasen Shuriken is still playing. `CheckDie()` interrupts the actor before the animation completion callback; the next report command never runs. Before fix: round 1 remains stuck, even though no Flash exception is thrown. Evidence: `naruto-sage/validation/rasenshuriken-reflection-before.png`.

The server now emits Rasen Shuriken self-damage in the immediately following passive reaction instead of the skill's own target effects. The damage amount and final server HP stay unchanged; the renderer completes the skill before applying the reflected damage. Client **2026101708** additionally checks for death after positive passive HP deductions and displays them as damage instead of a green/healing-style `+` value. Other Naruto/Jiraiya patches are preserved. No watchdog, skipped turn or swallowed exception is used.

## Build and verify

```powershell
python sunucu-kok/cikarim/naruto-sage/build.py --apply
python sunucu-kok/cikarim/jiraiya-toads/build.py --apply
python sunucu-kok/cikarim/ninja-fragments/build.py --apply
python sunucu-kok/cikarim/jiraiya-toads/build-client.py --ffdec "path/to/ffdec.jar" --install
python sunucu-kok/cikarim/ninja-fragments/verify.py
.\node\node.exe sunucu-kok/sunucu/tests/ninja-fragments.test.js
.\node\node.exe sunucu-kok/sunucu/tests/naruto-combat.test.js
```

`verify.py` decodes installed native textures and package records, comparing pixels with the portrait files and validating all three database associations. The fragment test buys each item at the real handler, then spends exactly 50 on the correct partner's star upgrade, without writing player files. Existing Mystic Shop, Reincarnation, Jiraiya, hero skill and asset checks also pass. Restart backend and client to load the updated server logic, tables and images.

Final native verification on client 2026101708: clean login with the new fragment tables, lethal reflection deducts Naruto's 100 HP and removes the dead caster, the following ally action executes, and the report reaches WINS without an uncaught Flash error. Evidence: `../naruto-sage/validation/rasenshuriken-reflection-fixed.gif`, `rasenshuriken-reflection-fixed.png` and `rasenshuriken-reflection-runtime.log`. Tests use an isolated copied backend/save; production saves are unchanged.
