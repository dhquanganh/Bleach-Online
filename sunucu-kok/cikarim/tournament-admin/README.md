# Tournament of Throne admin

The dedicated admin tab calls authenticated `/auth/admin/tournament` GET/POST. Actions: add eligible real account using an isolated PvP snapshot of its latest saved/live files; remove registration; reorder one group; start all groups immediately. Maximum eight entrants per group. Starting closes registration and runs quarter-finals immediately; remaining rounds retain their five-minute intervals. Started rosters cannot be edited.

The API and game use the same locked/atomically written `king-challenge-store` registry. Optimistic revisions reject stale edits. Manual start redirects existing account season pointers without losing submitted teams or prize entitlements. Newly opened registration after the tournament display expires does not follow the old redirect. Mutations retain a bounded admin audit log.

Online account workers receive `tournament-update` and push native base/roster/bracket packets directly. Their five-second reconciliation advances due matches and recovers a missed push. Offline players synchronize on their next event request. Opening the admin view also resolves due matches using the real combat simulator. Reports and results are shared across workers.

Validation:
- `node --test sunucu-kok/tournament-admin.test.cjs`: admin permissions/methods, eligibility, capacity, add/remove/order, stale revisions, immediate quarter-finals, shared results, timed later rounds, retained prize rank, registration after manual completion, real isolated PvP snapshot.
- `node sunucu-kok/sunucu/tests/king-challenge.test.js`: existing tournament, wagering, rollback, rewards, real combat tests pass.
- `ui-smoke.js` run with the bundled Electron: separate tab, add/reorder/remove/start, disabled roster after start, no duplicate start, no JavaScript errors. See `ui-result.json` and `admin-preview.png`. Uses isolated fixtures; no live tournament was started during validation.

Restart the server/account workers once to load the new routes and native push handler, then reload `/admin`. No SWF update is needed.
