# Konoha’s Great Tree — Fortune Store

Player entrance and exchange window use existing game artwork, not recreated images.
Sources under `asset/Konoha_Great_Tree_Fortune_Store`: KonohaTree image 186
(panel), 38 (Naruto), 30 (reward card), 201/203 (Fortune Store tab), 34 (coin),
mainUI image 1761 (the supplied event entrance), Fortune_Coins_10189026.png.
Served artwork: `gorsel/konoha-tree/`; original extraction retained here.

## Items and defaults

- Fortune Coins: Article **14900002**, native Inventory texture **00E35B22**,
  selling price 10, not directly usable; native expiry follows event deadline.
- One sample offer: **1 Nguyên thạch (14900001)** for **10 Fortune Coins**,
  **100 exchanges per player per day**. Daily reset: 00:00 UTC+7.
- Initial schedule: 31 October through **4 November 2026 22:59:59 UTC+7**.
  Schedule and prices are editable in admin. No free starting coins are granted.
  Existing admin item grants can distribute item 14900002.

## Administration

Open the separate admin page → **Konoha’s Great Tree** tab. Search items by
name/ID with actual native icons, add rewards, edit quantity/price/daily cap,
reorder, delete or disable rows, change dates and enable the event, then save.
Updates reach the game on refresh or within 15 seconds. Revisions reject stale
admin writes. Season IDs isolate limits; keep the same ID when editing one event.

Mongo `game_config/konoha-tree.json` persists configuration, projected atomically
to `.accounts/konoha-tree.json` for account workers. Exchange uses existing
authenticated account control endpoints and updates the native bag immediately.
Coin debit, actual item grant, daily usage and nonce receipt share one atomic
player save. Retries replay the receipt without another charge or reward.

## Validation and client release

- `node konoha-tree.test.cjs`: inventory economics, idempotency, schedule, UTC+7
  daily limits, stale configuration, stack/bag capacity, equipment rewards,
  interrupted saves and admin authorization/CAS.
- `validation/ui/result.json`: hidden Electron test of real event/admin HTML,
  icon decoding, edits, retries and button locking. Preview PNGs alongside it.
- `validation/native/result.json`: native Flash Article decode, flags, price and
  icon reference. Tests use isolated fixtures and never modify real accounts.
- Existing Myoboku, Soul Palace, Item Evolutions and recruit-item tests pass.
- Release **2026103103** publishes item tables/icon at fresh resource URLs.
  Production TApplication bytes and all native animation code are unchanged.

Restart the game services after backend changes and reopen the launcher to load
the new client resource version. This implementation covers Fortune Store;
other Great Tree minigames are outside this change.

## Hueco Mundo exchange (2026103106)

Native BlackMarket offer **41900002**, model 2: **10 Hueco Mundo Coins
(14140507) → 1 Fortune Coin (14900002)**. It occupies the first slot in both
new and existing saved shops. Other slots retain the original random rewards.
The offer is repeatable up to the native stack limit per shop refresh.

`hueco-offer.py` patches only this BlackMarket row in native data and JSON;
`hueco-client.py` preserves native artwork and patches only shop rendering,
buy-button guards and stale purchase-result handling. The native Konoha entrance
from 2026103104 remains intact.

Hueco backend now uses the correct ID-only refresh response (initialization
continues to send ID/purchase-count pairs), validates payload lengths and bag
capacity, and saves staged exchange state before sending inventory notifications.
Purchasing a revive while the team is fully defeated restores the team and
consumes the newly purchased revive; temporary summons are excluded from
persistent formation HP. Claim/battle stack overflow is rejected before granting
partial coins. Reset/revive purchase failures refund charged gold when saving
fails. Tests use in-memory players and do not modify real accounts.

Passing validation: `sunucu/tests/hueco-mundo.test.js`, `black-market.test.js`,
and `konoha-tree.test.cjs`. Native Fortune Coin offer bytes are verified in all
13 published BlackMarket packages; original artwork is unchanged.
An additional `mystic-shop.test.js` run found a pre-existing missing owned-hero
offer for Naruto Mid-Autumn (11121010). That separate shop configuration is not
changed by this Hueco event fix.
