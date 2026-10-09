# Void Region native battle playback

The supplied 23.68-second video shows loading, movement to the boss and damage/death without the native battle view. The current live client gates both battle callbacks under FIsResourcesLoadCompleted in FightEnterRet. The report can therefore be handled while the battle panel was never shown. The rebuilt handler only gates the optional scene-player update; it always hides the Void map and dispatches the proper three-argument status callback followed by battle setup. Void admission also resets the stale IsInBattle flag that otherwise drops incoming reports after some other boss modes.

Backend remains the real Ulquiorra encounter and native report/result flow. Validate with `node sunucu-kok/sunucu/tests/void-entry.test.js`.
Build: `python sunucu-kok/cikarim/flash-void-playback/build.py --ffdec PATH/ffdec.jar --install`.
Only two live client classes are imported. All non-code SWF tags are preserved; previous live SWF is backed up and the compiled methods are decompiled/checked. Interactive playback still requires manual validation. Restart game after installation.
