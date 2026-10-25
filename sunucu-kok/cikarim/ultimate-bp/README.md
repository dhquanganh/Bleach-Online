# Ultimate BP

- MongoDB `game_config/ultimate-bp.json` is authoritative; auth startup and admin GET repair the atomic worker projection.
- `/admin` → Ultimate BP edits the hero, price, five gift thresholds, repeat step, item/currency rewards and quantities. Existing rewards include names and decoded native atlas icons. PATCH checks admin role and revision before database update.
- Real gold spending earns one event Piece per ten gold; remainder persists in `veri.json`. Coupons, top-ups, rewards and refunded transactions do not earn Pieces. Previous spending is not backfilled from current balances.
- Hero exchange does not consume Pieces (matching the native event rule), and grants the configured hero directly once. Each gift's next threshold is its initial threshold plus claim count × cycle step. Gift claims do not consume Pieces.
- Pending claims store the complete resulting player state with the account mutation, allowing restart recovery exactly once. Full item stacks and stale config requests do not grant rewards.
- Native client release `2026102508` extends the existing client with four classes; all non-ABC SWF tags are verified unchanged. The event polls every three seconds while visible and receives current prices, hero, thresholds and tooltip rewards through native InitRet.
- The old paid bonus-pack actions (7/8) and random stage-drop action (96) are not reward sources under the new gold-only rule. Rankings and the manual admin payout are implemented by the follow-up in `../ultimate-bp-ranking/README.md`; no captured ranking rows are presented as real players.

Validation: 22 related backend/admin/regression checks pass, plus the isolated Electron admin smoke test (`admin-ui-result.json`). The actual MongoDB default configuration was seeded/read successfully. The compiled native scripts were exported for inspection in `verify/`. Full interactive Flash gameplay was not automated.

Existing unrelated failure: `sunucu/tests/reincarnation.test.js:89` expects 247021 but gets 247746, reproduced against the original `HEAD` reincarnation module as well.

Rebuild: `python sunucu-kok/cikarim/ultimate-bp/build-client.py`. The builder requires the reviewed source or its compiled output to still be the canonical client, and refuses to overwrite an unrelated client change.
