# Native video-preset validation — 2026-10-11

Final client checked in Electron 1.8.8 / Pepper Flash 22 using an isolated backend and copied profile/database at `.battlefield-runtime-test`. The wrapper listens to child-SWF uncaught errors. Test-only timers: preparation 5 seconds, two 80-second rounds, intermission 5, duel freeze 12, respawn 5. Production remains two 15-minute rounds, preparation 90, intermission 30, freeze 25 and respawn 15.

Observed final sequence:

1. Login, Daily > Daily Activities > Chiến trường.
2. Register one human with 19 bots; full native map sprites load.
3. Enable Auto. Server resolves human and bot formations; map remains visible while faction resources and rankings update.
4. Click View in the report feed. A real native v4 bot formation report plays to its winning result, with skill effects and sound.
5. Confirm the native result. The dedicated return route opens the battlefield again; the round-two/result display reflects current live resources and personal points.

No `RUNTIME ERROR` appears in the final `runtime.log`. Earlier failed sessions are preserved as separate `video-*-debug.log` / `video-before-*.log` artifacts; they are not the final result. The counter-vector correction fixes native two-slot block playback without duplicating damage. Map and MP3 requests successfully use existing cached 2017 assets rather than 404 responses.

Evidence:

- `video-final-map.png`: automatic combat remains on the map, three friendly spawn pads, native actors, HUD and live reports/ranking.
- `video-final-duel.png`: native formation replay.
- `video-final-return.png`: return to the battlefield after watching, scores and rewards from the live match.
- `video-final-town.png`: return control closes the battlefield to town.
- `runtime.log`: final wrapper trace.

Canonical client and active `/public/2026101106/TApplication.swf` both have SHA-256:

`32bc12691bf52472cc18144032c911b1c7c05fa471802f8cc3c4d6bda402b1a4`

Applying `PatchRoutes` again to the final decoded client is byte-for-byte idempotent. Build verifies preserved non-code SWF assets and unchanged unrelated method bodies during ASM patches. Backend suites pass: `battlefield.test.js`, `battlefield-formation.test.js`, `hero-skills.test.js`, `protect-balance.test.js`; the formation suite also decodes real native reports and covers server-only Auto, resource conservation, freeze, replay safety, honor reconciliation, strategy and old-rule settlement.

Source-video observations and reconstruction limits are in `../video-reference.md`. Character/battle assets remain Bleach assets; this validation does not claim original One Piece sprites or verified hidden 568 formulas.
