# Void boss entry and native loading - 2026102241

Reproduced the reported failure in the full production Flash application,
using the bundled Electron/Pepper Flash runtime and an isolated gateway with
copies of player files. The existing native menu and pointer clicks were used.
No injected battle callbacks or standalone loading mock were used in these runs.

Confirmed blocker: TProcessorVoidSoulWorld referenced CONST_BATTLE without its
import. On successful admission it hid the map and then threw ReferenceError
#1065 before setting battle status. Consequently the report arrived without
the proper transition and the user saw generic module loading on black.
The class now imports Resources.Constants.CONST_BATTLE explicitly.

A second first-battle issue was observed after entry was repaired: the ready
movie's exact frame could be missed. Void playback now starts once when the
ready clip reaches or passes its cue. Other battle types retain their native
start behavior. The guard resets when the next ready sequence begins.

Only TProcessorVoidSoulWorld and TBattleHandle are imported from a fresh 2240
baseline. Non-ABC SWF assets remain byte-identical. Prior admin/portrait/physical
combat and loading screen fixes are retained. Publish 2026102241 preserves routes.

Native end-to-end evidence: ../void-live-entry/
- baseline/runtime.log: ReferenceError #1065 after clicking the boss.
- loading-fixed/screen-11.png: actual Loading resources screen while entering boss.
- full-boss/screen-19.png: actual high-HP Sage boss attacks in round 2.
- completed/screen-12.png: WINS after a short fight using a private 200-HP boss config.
- completed/final.png: return to Void Region, boss HP 0/200, rank and damage 200.
- completed/result.json and runtime.log: no uncaught Flash errors.

The shortened fight overrides only BLEACH_VOID_CONFIG in the test gateway.
Production boss configuration and account files were not changed. Test gateway
and HTTP server exit automatically; their ports were checked closed afterward.

Checks passed:
- compiled ready cue tests: exact, skipped and final frames; no duplicate or early
  start; native start behavior retained for other battle modes.
- frontend tests against compiled AS, including explicit CONST_BATTLE import.
  The old test's injected constant had masked the missing runtime binding.
- actual report generation for all seven active Naruto bosses.
- real HTTP launcher/version map and all 66 published routes for 2026102241.
