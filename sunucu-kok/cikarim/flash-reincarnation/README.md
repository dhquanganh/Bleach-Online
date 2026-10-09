# Reincarnation fixes

The current live protected SWF was decoded and the relevant classes exported under `original/`. Edited AS3 is under `patched/`. The build recompiles those classes, decompiles the result for verification, checks that all non-code SWF assets are unchanged, re-applies the loader byte swaps, and backs up the live client before installation.

Backend fixes:
- Validate ownership, current reincarnation level, required level, main-character prerequisite and maximum of five reincarnations.
- Deduct cumulative EXP using 64-bit arithmetic, preserve the remaining EXP, persist the new level and highest reached level, and send authoritative results to Flash.
- Roll power/effect only at the first reincarnation; subsequent reincarnations strengthen the existing selections. Reset uses the unlocked effect pool and correct materials. Advanced reset additionally charges Gold.
- Validate all materials before consuming anything. Claim Epic EXP Books once per day after the main character reincarnates, with separately paid purchases thereafter.
- Synchronize materials, stats, login fields and battle report reincarnation count. Apply final damage/reduction, power restrictions and attack effects in the local combat simulation.

Flash fixes:
- Read the actual Epic EXP Book ID, show the correct reward item, parse authoritative level/EXP/history results, preserve capped-level preview, and block duplicate outstanding mutation requests.
- Correct reset cost references, update live inventory counts, refresh hero status after resetting attributes, and query daily book status whenever the window opens.
- Keep the battle role-position dictionary synchronized when an attack effect changes formation.

Run from the project root:

```powershell
node sunucu-kok/sunucu/tests/reincarnation.test.js
python sunucu-kok/cikarim/flash-reincarnation/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

Omit `--install` to build only. Backups are stored under `backups/`. Restart the game and backend once after installation. Automated validation covers in-memory backend operations, combat reports and recompiled AS3; direct interactive Flash UI verification remains manual.
