# Void Region boss entry fix

The captured server log showed InitReq (0x01818b00) but no FightEnterReq (0x01818b02). The live Flash client attached entrance clicks to MC_StartPos circles; MC_Pointer shortcut labels had no battle listener. The boss/player sprite layer also intercepted mouse hits over the entrance artwork.

- Disable mouse hit testing on decorative boss/player layers, keep entrance circles interactive, and wire all four shortcut labels through the same validated controller entry path.
- Preserve the event/form checks and revive handling.
- Normalize standard formation positions 1/2/3/6/7/8/11/12/13 into six Void preview slots while retaining original combat positions. Include the main hero consistently with the combat engine.
- Build Void battles from the submitted formation snapshot; migrate legacy snapshots that discarded rear/middle allies.
- Reject malformed fronts, duplicate active entry and dead bosses. Backend report-generation errors now return a failure packet instead of leaving the client waiting forever.

```powershell
node sunucu-kok/sunucu/tests/void-entry.test.js
python sunucu-kok/cikarim/flash-void/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

Build verifies decompiled changes and unchanged non-code assets, and installs with backups. Direct interactive Flash validation remains manual. Restart game/backend to load the changes.
