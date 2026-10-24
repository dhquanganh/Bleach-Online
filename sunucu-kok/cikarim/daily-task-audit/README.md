# Daily Tasks repair

Current repair release: `2026102424` (`repair-ui.py`, `repair-release.json`).

- Clamp the reward-list index at the tenth row for 150–195 points; previously 165+ points indexed outside the vector and could interrupt window initialization. The progress bar now reaches the final milestone at 150.
- Clear obsolete task buttons on selection, use natural completion when progress is complete, hide acceptance and disable refresh at 10/10, preserve active progress when previewing another task, wrap descriptions, and show doubled Silver rewards.
- Set the information-ready flag only after a successful response. Completion replies now clear the active task immediately.
- Repair missing, duplicate or invalid persisted task IDs and clear obsolete active tasks at the daily limit. Reject malformed info requests.
- Compile against the current canonical app, re-export the three classes to verify changes, preserve all non-code SWF tags and existing version routes, and publish the release pointer last. Backups are kept per release.

Validation: Daily Tasks, Tensō and King Challenge tests passed; compiled AS3 was re-exported and checked. Live Flash interaction still requires a manual check after reopening the client.

Previous client release: `2026102324`.

- Replaced placeholder handlers in `sunucu/sosyal.js` with `sunucu/daily-tasks.js`.
- Corrected the extracted DailyTask schema from the actual binary/AS3 reader: task names, completion requirements, Instant costs, icon IDs and descriptions were shifted in backend JSON.
- Progress uses server event counters after task acceptance. No arbitrary completion or competing active tasks. Ten completions per day; refill completed slots; first refresh free, subsequent refreshes use ConfigValue 60160003 (10 Gold/Coupon).
- Each completed task grants 15 points. Three daily target types grant a one-time 45-point bonus. Double Reward enables doubled ordinary rewards; the 150-point milestone remains exactly 100 Primogems (Article 14900001), across all five level tiers.
- Enforce milestone order, tier, points, one-time claim; stage inventory changes and reject overflow before committing. Save failure refunds charges and preserves claims.
- Fixed duplicate fortify counting and removed the lifetime fallback for daily points in Experiences.
- Flash now selects initial task details, refreshes server state on open/operations, updates live progress, handles claim errors, guards missing quest links, and omits the double effect/quantity for the final milestone.
- Patched only DailyTask points and five DailyAward final rewards in 13 normal/combine/localized data packages. Preserved other SWF asset tags and earlier tournament fixes.

Validation:

```
node sunucu-kok/sunucu/tests/daily-tasks.test.js
node sunucu-kok/sunucu/tests/tenso.test.js
node sunucu-kok/sunucu/tests/king-challenge.test.js
git diff --check
```

All passed. Daily Tasks tests include production handler registration and persisted delivery of exactly 100 inventory Primogems in an isolated account, plus negative claims, action progress, paid/free refresh, save failure, overflow and reset. Re-exported three compiled AS3 classes and checked changed behaviors; checked all five final milestone rows in every released data package. Live manual Flash UI was not exercised.

Restart the game server and reopen the launcher to load the new backend/client release.
