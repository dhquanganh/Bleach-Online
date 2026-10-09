# Hueco Mundo Attack fix

The live Flash classes were exported from the current protected `2026090619/TApplication.swf`. Only `TProcessorBackpack` and `TProcessorVainTravel` are recompiled; existing client fixes and other SWF assets are preserved.

- `InventoryNtf` now inserts unseen items after checking backpack and mounted equipment, and updates existing quantities without duplicates.
- VainTravel uses its own 0..14 point indices and persisted local opponent formations instead of the last world-map stage. This portable server uses local bots because the original feature matches online player teams.
- Winning grants and saves 10 Hueco Mundo Coins immediately, matching the previous local reward amount. Each point grants once per run. Reset, surviving HP, revival and exchange use persisted state.
- Exchange uses BlackMarket model 2 and actual inventory coin balance.

Run backend regression checks from the project root:

```powershell
node sunucu-kok/sunucu/tests/hueco-mundo.test.js
```

Recompile, decompile for verification, check that non-code SWF assets are identical, and install with a backup:

```powershell
python sunucu-kok/cikarim/flash-hueco/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

Omit `--install` to build only. The tool uses the current live SWF as the base and saves original protected files under `backups/`. Restart the game/backend once to load the changes. Runtime checks cover backend simulation and wire packets; interactive Flash UI verification remains a manual check.
