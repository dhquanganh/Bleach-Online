# Void Region own-admission blocker - client 2026102240

Root cause confirmed from native login code, not the loading artwork:
TUnstreamizerCharacter reads high then low and calls Coerce(high,low).
TCharacter.Coerce assigns Identifier0=high, Identifier1=low.
The Void admission patch compared high against Identifier1 and low against
Identifier0, so own admissions returned before SetBattleStatus/OnInitBattle.
The server sent report/result but the client never initialized the battle view.

Fix (fresh source 2239):
- TProcessorVoidSoulWorld admission compares high/Identifier0, low/Identifier1.
- MainWin uses the same order to find the local participant on the event map.
- All previous native loading assets, callbacks, selected boss and stats remain.
- Only these two classes are imported. Non-ABC tags byte-identical.

Validation:
- Bundled Flash regression probe executes the old and new production admission
  bodies with byte-array packets and the native Character.Coerce body.
  Baseline reproduces own admission ignored; fixed executes status then battle;
  other-player admission and rejected admission do not start a local battle.
  validation/result.json: completed=true, checks=4, errors=[].
- JS frontend test now asserts login/Coerce order, rather than the previous test's
  incorrect swapped fixture; passed against the compiled/re-exported classes.
- Actual generated boss reports for both Enemy bosses and all 7 Naruto heroes pass.
- HTTP bootstrap and 66 routes verified for 2026102240.

Full authenticated fight playback has not been exercised by this probe. It tests
and reproduces the exact admission blocker in native Flash, separately from the
battle report and resource-loading tests. No live account state was changed.
