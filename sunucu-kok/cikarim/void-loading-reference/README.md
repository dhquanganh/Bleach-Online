# Void Region loading reference - 2026102239

Reference artwork confirmed visually against the shipped native asset:
2017112917/Resources/Swf/Vital/00000002.swf, MC_BattleLoad frame 47.
Its embedded JPEG is the exact background in the user's screenshot, and its
native load bar already says Loading resources. No replacement art or caption.

Changes (fresh export of client 2238):
- TBattleHandle exposes a Void-only resource loading flag from admission until
  native loading completion, and clears it if the battle view is hidden.
- Lobby module progress cannot show or reopen via a delayed tween during this
  interval. Non-Void loading uses its existing path.
- Native battle loader no longer additionally waits for all secondary downloads
  before initializing its UI. Its primary resource readiness guard remains.
- Previously fixed early mount and all boss/avatar/admin changes are retained.
- Non-ABC assets are byte-identical; publishing preserves existing routes.

Validation passed:
- compiled AS lifecycle / module suppression test:
  node sunucu-kok/sunucu/tests/void-loading-reference.test.js
- existing Void frontend bodies and actual reports for all 7 Naruto bosses
- native Flash asset probe: validation/native50.png and native100.png;
  validation/result.json completed=true, errors=[]
- real HTTP bootstrap / release routes: 2026102239

The native asset was rendered in bundled Electron/Flash. Full authenticated
end-to-end boss playback was not exercised; report identity and entry dispatch
were checked separately. Probe root imports clean source.swf; runtime-probe.js
serves the exact existing native loading asset, not a copied screenshot.
