# Arena ranking chest

The authenticated parent freezes a daily rank/level snapshot in MongoDB
`arenaSettlements` at the first roster refresh on or after the configured local
release time (ConfigValue 60140010/60140011: 19:30). Existing snapshots are immutable
across rank changes and restarts. Offline accounts in the real roster are included;
accounts created after the snapshot wait for the next release. If the entire server
was stopped at release time, the first refresh after starting supplies that day's
snapshot. Only the latest released chest is offered; missed days do not accumulate.

Each account worker receives only its own entitlement. `arena-rewards.js` validates
the release timestamp and durable claimed-period marker. Claiming before release,
claiming twice, malformed requests and overflowing/full inventory balances fail.
Crossing midnight does not reset the claim marker; a new settlement does.

Rewards match native `TProcessorWindowArena.MakeHtmlText`:

- Chest quality: `RankComposeQuality`.
- Material chest: level and quality, from all 1113 `RankReward` descriptions.
  `build-materials.py` verifies the English/Chinese descriptions and generates the
  six structured level bands in `sunucu/arena-materials.json`.
- Silver: `floor(2000 * 2^(level/20) * log(6561/(rank+8))/log(3))`.
- Prestige: the rank's `RankMoney.prestige`.

For rank 1, level 99: 14 Epic Material Chests, 370919 silver and 20000 Prestige
(the executable test checks the formula rather than a rounded display value).

Inventory, currency and the claim marker are saved together with an account-scoped
redo journal. Save errors restore the prior files and return failure without reward
notifications. `durum.yukle()` recovers an interrupted transaction before loading
the player. The auth persistence file list includes this journal for worker/cloud
recovery. The shared generic reward helper is deliberately bypassed here because it
swallows save errors.

Enter_Arena now sends actual BoxType/BoxRanking/BoxLevel. Arena_Update pushes refresh
availability after the parent releases the entitlement and after a successful claim.
Native success replies retain the original array layout; item and currency pushes
update the bag and HUD. The native client displays the frozen chest quality even
when the current ranking has changed. Cache version: 2026101941.

Validation:

```powershell
.\node\node.exe sunucu-kok/sunucu/tests/arena-rewards.test.js
.\node\node.exe sunucu-kok/sunucu/tests/military-rank.test.js
.\node\node.exe sunucu-kok/sunucu/tests/reiatsu.test.js
.\node\node.exe sunucu-kok/sunucu/tests/obito-combat.test.js
```

The Arena suite uses temporary player files and an in-memory Mongo collection
double, without granting rewards or changing real accounts. Native code is compiled
and re-exported with FFDec, with unchanged non-ABC assets verified. Full manual UI
and live MongoDB integration remain separate checks.
