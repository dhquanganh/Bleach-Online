# Alliance War repair

Client release: `2026102525`. The native Alliance War hub is retained. Its four buttons open the launcher controls for Battle, Campaign, Auto-Battle and Honor Shop. Starting a fight sends the original MiniBattle head/waves/result packets and switches into the native animated battle scene; the launcher panel hides until the player returns. History and native report rows can replay a fight without awarding it again. `verify/scripts` contains the decompiled compiled classes used by the native regression tests. The bridge explicitly imports `flash.external.ExternalInterface`; regression tests cover the compiled Enter Campaign click chain and reject unresolved Flash API references. The build preserves every non-ABC SWF tag and refuses to replace an unexpectedly changed client.

## Behavior

- Authenticated game characters only; real shared rooms, password checks, three seats, leader permissions, readiness, leave/kick and leader reassignment. Rooms and queues expire when clients leave or stop reporting activity.
- PvP matches real teams of equal size. Auto-Battle queues a real solo team; it waits for another real player. Matching expires after 120 seconds. Opening hours: 13:45–14:45 and 21:00–22:00, UTC+7.
- Campaigns use `LeaguePointPath` and the real `EnemyArmy` formations, without enemy scaling or forced victories. Squads fight a relay over at most four waves and surviving original heroes retain their HP ratio. Summons and temporary buffs are not carried as extra permanent team members. Clearing Normal unlocks its Hard variant.
- PvP has ten reward attempts per day, reset at midnight. Campaign attempts refill by five at 12:30 and 18:30, capped at ten. Campaign losses do not consume attempts. Training with no attempts gives no rewards.
- Campaign victories grant one randomly selected accessory from the map's displayed pool plus the map's configured Honor value. PvP rewards are Bright Stone and 30 Honor for a win or 10 Honor otherwise. Item rewards arrive by mail; Honor and attempts update immediately.
- MongoDB `alliance_battles` stores the outcome before any delivery. Each character records a receipt. Delivery is marked complete only after the account has been saved to MongoDB. Pending delivery resumes on login or opening Alliance War. Active rooms are transient; battle history and rewards survive restart.
- Honor Shop uses Honor as an unlock threshold, preserves Honor, checks level and daily purchase allowance, charges the catalog's gold price (existing coupon fallback supported), and honors lifetime item limits. Free hero unlocks are once per character. Purchases use a redo record in `veri.json` so currency, items and ownership recover together after interruption.
- Legacy local-room success stubs are rejected and no longer increment Alliance achievements.

## Validation

```
node --test sunucu-kok/alliance-war.test.cjs sunucu-kok/alliance-war-native.test.cjs sunucu-kok/alliance-war-playback.test.cjs
node --test sunucu-kok/auth.test.cjs sunucu-kok/ultimate-bp.test.cjs sunucu-kok/town-presence-ui.test.cjs
```

Browser test: set `BLEACH_PLAYWRIGHT_PATH` to an installed Playwright package, optionally `BLEACH_CHROME_PATH`, then run `node --test sunucu-kok/alliance-war-ui.test.cjs`. The test uses its own local HTTP fixture and does not modify player accounts. The native TCP integration creates and removes isolated temporary account directories. `native-live-preview.cjs` additionally launches the bundled Flash client with a temporary MongoDB account to capture a real native battle; it removes the account, battle records and runtime afterward.

Restart the local server and reopen the launcher to load the new backend and versioned client.
