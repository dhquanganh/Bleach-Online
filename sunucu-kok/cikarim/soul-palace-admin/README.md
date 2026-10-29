# Seireitei Soul Palace — 2026102909

Dedicated admin tab and authenticated GET/PATCH `/auth/admin/soul-palace`. The default catalog contains 13 divisions and 360 encounters. Admin can add divisions and encounters, rename them, set level requirements, edit enemy/hero formations and positions, set HP/ATK/DEF/speed/level, and configure fixed/random rewards. Original random drop pools are retained. Existing IDs retain progression. Limits: 100 divisions, 255 floors per division, 2000 floors total, nine units per formation.

Configuration is atomically saved with a cross-process lock and optimistic revision in `.accounts/soul-palace.json` (override `BLEACH_PALACE_FILE`). Game workers hot-read it for every entry/challenge; reopen the game window to refresh metadata. Admin changes require no worker restart. The admin upload endpoint alone accepts up to 2 MiB; login and unrelated requests retain their small limit.

Fixes include capped default unlock requirements at 159 instead of unreachable 165/175; per-floor clear flags instead of reporting other divisions fully cleared; server-side sequence/level/day/attempt checks; no repeat cleared-floor rewards; real configured combat teams without synthetic victory fallback; correct attempt counts on both win/loss; validated chest thresholds and repeat-claim rejection; no fabricated PvP salary when no real occupiers exist; paid daily reaping limited to previously cleared floors. Battle of Gold keeps its separate implementation.

Native client receives a compressed catalog after the existing SkyTower packet. The decoder rebuilds TTower/TLayer data, including newly added IDs, unlocked status, names, models and exact progress. Pagination supports arbitrary division counts instead of hardcoding the last page for 13 divisions. No image assets changed.

Validation:
- `node --test sunucu-kok/soul-palace-admin.test.cjs`: authorization, configuration edits/additions, invalid/stale writes, hot reads in another process, level/sequence/day gates, losses/wins/repeats, attempt limits, refund on save failure, chest eligibility/idempotency, original random drops, configured Naruto Final formation in a real fully decoded combat report.
- `node sunucu-kok/sunucu/tests/tower-gold-integrity.test.js` and `tower-gold.test.js`: pass.
- Hidden bundled Electron UI smoke: actual admin page adds division 14, adds two floors, adds Naruto Final, changes ATK and submits the whole configuration. `ui-result.json` passes without JavaScript errors; screenshot `admin-preview.png`.
- Flash runtime probe calls the compiled catalog decoder with 14 divisions and new floor IDs, checks exact clear flags/unlocks/names, and repeats loading without duplicating entries. `validation/native/result.json` passes, no live-account access.
- Published client 2026102909 changes only TApplication's manifest entry; all prior resource mappings (including Mystic Shop 2026102908) remain intact. Original client and manifest backups are in `release-backup`.

Restart server/account workers once to load the implementation and open launcher 2026102909. No live-account configuration or progression was changed by the tests.
