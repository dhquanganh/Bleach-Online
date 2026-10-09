# Usable item repair and audit

`item-audit.json` inventories every Article advertised as usable (plus the bag expansion item). It distinguishes direct consumables from feature materials. The backend normalizes the shifted Article.json fields using the actual Flash TArticle stream layout: ItemFunction is stored in `functionValue`, effect amount/hero/title ID in `f16`, and sell price in `itemFunction`.

- EXP and Silver cards use their actual amounts. EXP scrolls validate the selected owned partner and reject main-character use where the description forbids it.
- Equipment, accessory, complete outfit, Hogu, gem and material chests use database pools or explicit item-description recipes. Bulk random openings roll independently; equipment receives separate persistent instances.
- Package rewards are validated on a copied inventory before the used item is committed. Invalid IDs/quantities, insufficient inventory or storage capacity, invalid rewards and failed currency grants preserve the item.
- Permanent fruits update primary and derived combat stats. Character/title tokens, partner expansion, bag expansion and top-up cards are supported. Top-up cards affect VIP/charge progress without granting Gold or counting as paid event recharge.
- New bag state and partner slots sync through local packet 0x01180f7f after bag loading/use. The portable initial capacity is at least 250; expansions use ConfigValue costs and increase capacity. Packet-size checks remain in place.
- Flash routes packages and fruit/EXP correctly, displays package receipts, clamps signed protocol quantities, shares a pending-use guard and prevents duplicate bag-capacity increments. Resource icons no longer incorrectly open the clan-change dialog.

## Editable local defaults

The user authorized local rewards where original server drop configuration is absent. `sunucu-kok/sunucu/item-use-config.json` records these per item ID, with `source: local-default`. The default quantity is one; pools are derived from matching item families or material rarity. These are local server defaults, not recovered original drop rates. VIP trial duration defaults to 24 hours and is also configurable. Restart the backend after editing overrides.

`kind: fixed` uses a rewards array of `{type,code,amount}`; `kind: choice` randomly chooses one entry per opening; `kind: set` chooses an item from each equipment slot.

## Validation and build

```powershell
node sunucu-kok/sunucu/tests/usable-items.test.js
python sunucu-kok/cikarim/flash-items/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

The build starts from the current live SWF, compiles patched classes, decompiles to verify changes, preserves non-code assets and previous fixes, then installs with a backup. Automated checks cover in-memory use, loot, persistence and packets. Direct interactive Flash testing remains manual. Restart game/backend once after installation.
