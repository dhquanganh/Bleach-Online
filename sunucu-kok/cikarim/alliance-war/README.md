# Alliance War repair

Client release: `2026102604`. Alliance War now uses the game's original Flash hub, room list, Campaign/map selection, three-player room, matching preparation and Honor Shop. `alliance-war-native.cjs` adapts the native TCP requests to the same shared coordinator used by the HTTP fallback. The worker accepts these requests only from authenticated game sessions. Native room and quota updates are pushed to online participants; the HTML controls stay hidden during the native flow. Combat and durable rewards remain unchanged. History and report replay still use the existing fallback controls. The native UI compilation/verification is in `native-ui`; its build starts from the accessory-fixed 2602 client and preserves all non-ABC tags. Do not run an older full-client patch over a newer release without rebasing it.

## Behavior

- Authenticated game characters only; real shared rooms, password checks, three seats, leader permissions, readiness, leave/kick and leader reassignment. Rooms and queues expire when clients leave or stop reporting activity.
- PvP matches real teams of equal size. Auto-Battle queues a real solo team; it waits for another real player. Matching expires after 120 seconds. Opening hours: 13:45–14:45 and 21:00–22:00, UTC+7.
- Campaigns use `LeaguePointPath` and the real `EnemyArmy` formations, without enemy scaling or forced victories. Squads continue the relay until one side has no squads left, with no four-wave cutoff; surviving original heroes retain their HP ratio. A solo player can clear all six armies in six consecutive wins. Summons and temporary buffs are not carried as extra permanent team members. Clearing Normal unlocks its Hard variant.
- PvP has ten reward attempts per day, reset at midnight. Campaign attempts refill by five at 12:30 and 18:30, capped at ten. Campaign losses do not consume attempts. Training with no attempts gives no rewards.
- Campaign victories grant one randomly selected accessory from the map's displayed pool plus the map's configured Honor value. PvP rewards are Bright Stone and 30 Honor for a win or 10 Honor otherwise. Item rewards arrive by mail; Honor and attempts update immediately.
- MongoDB `alliance_battles` stores the outcome before any delivery. Each character records a receipt. Delivery is marked complete only after the account has been saved to MongoDB. Pending delivery resumes on login or opening Alliance War. Active rooms are transient; battle history and rewards survive restart.
- Honor Shop uses Honor as an unlock threshold, preserves Honor, checks level and daily purchase allowance, charges the catalog's gold price (existing coupon fallback supported), and honors lifetime item limits. Free hero unlocks are once per character. Purchases use a redo record in `veri.json` so currency, items and ownership recover together after interruption.
- Legacy local-room success stubs are rejected and no longer increment Alliance achievements.
- Reward generation validates the current item pool and exact Honor value, including zero. Native PvP items use AddedReward; players with no rewards are omitted to avoid the original UI dereferencing an empty slot. Right-side kill counts use the opponent side of the reports.
- Friend/guild bonus rewards are not currently calculated: the social/guild layer does not yet provide authoritative shared cross-account relationships. Base Campaign/PvP rewards are independent of these bonuses.

## Validation

```
node --test sunucu-kok/alliance-war.test.cjs sunucu-kok/alliance-war-native.test.cjs sunucu-kok/alliance-war-playback.test.cjs sunucu-kok/alliance-war-rounds.test.cjs sunucu-kok/alliance-war-rewards.test.cjs
node --test sunucu-kok/auth.test.cjs sunucu-kok/ultimate-bp.test.cjs sunucu-kok/town-presence-ui.test.cjs
```

Browser test: set `BLEACH_PLAYWRIGHT_PATH` to an installed Playwright package, optionally `BLEACH_CHROME_PATH`, then run `node --test sunucu-kok/alliance-war-ui.test.cjs`. The test uses its own local HTTP fixture and does not modify player accounts. The native TCP integration creates and removes isolated temporary account directories. `native-live-preview.cjs` additionally launches the bundled Flash client with a temporary MongoDB account to capture a real native battle; it removes the account, battle records and runtime afterward.

Restart the local server and reopen the launcher to load the new backend and versioned client.

Native UI end-to-end check (bundled Electron/Flash and a temporary MongoDB account): `node sunucu-kok/cikarim/alliance-war/native-ui/preview.cjs` from the workspace root. It clicks the original menus, selects Campaign, creates a room, confirms solo play and verifies entry into native MiniBattle. Screenshot: `native-ui/native-ui-battle-preview.png`. Account, sessions, runtime and battle records are removed afterward.

Room discovery repair (2604): native hall ACK precedes the model/room snapshots, halls repair dropped room updates every five seconds, and the All filter displays higher-level/locked-map rooms while the server still validates entry. ID search falls back to the server when a room is absent from the local Flash cache. Quick Join skips locked maps, full/private/queued rooms and active playback. Native hall Player List contains only real connected participants. Native room heartbeat survives pauses in HTTP polling. Non-owner departures preserve a transferred leader. Late joins and map changes during playback are rejected.

Validation: `node --test sunucu-kok/alliance-war-coop.test.cjs` covers packet order, refresh, room IDs, level/password/capacity/leader permissions, Quick Join and compiled Flash filtering/search. `node sunucu-kok/cikarim/alliance-war/coop-preview.cjs` launches two independent authenticated Flash windows and checks they join the same native battle; temporary accounts and records are removed afterward. Build/compiled verification: `coop/build-client.py` and `coop/verify`; it starts from the 2603 SWF and changes only the hall class.
