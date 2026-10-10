# Hollow Soul Map (NijiaStar)

Hollow Soul King uses SevenKing (0x38). Its Hollow Soul Map button switches to NijiaStar (0x39). The black screen was caused by CS_NijiaStarUpdateReq (0x01813904) returning an empty u16 count, leaving all per-hero NijiaStar objects null. The response callback then attempted to render the map from those missing models.

The request handler now returns the actual login roster (main hero, configured partners and tavern recruits), each with exactly seven saved star branch IDs. Invalid stored IDs are displayed as inactive points; the read request does not erase or write player progress. Unknown requested heroes receive no records.

Flash initializes missing branch models before showing the map, refreshes stars and eight soul balances on every entry, skips unknown hero records without breaking parsing of subsequent records, guards an empty hero list and only reopens the window while the map is the visible plate. The existing 60000000.swf UI asset is present.

```powershell
node sunucu-kok/sunucu/tests/hollow-soul-map.test.js
python sunucu-kok/cikarim/flash-hollow-soul-map/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

Build preserves the live client and unrelated features, backs it up and verifies decompiled initialization order. Restart the backend and reopen the client to use both corrected sides. Interactive rendering must be verified in the actual game.

## Activated attribute bonuses

`hollow-soul-map.bonuses()` sums activated SevenHeroLittleStar rows through each hero's saved branch node and adds SevenHeroStar's completion bonus once when the final node is active. Only the configured six combat attributes are added through the shared equipment/stat path, which feeds Partners, PvE/PvP attribute packets and battle snapshots. Existing saved activations are applied on login; no reactivation or extra material cost is needed.

Upgrades require the exact predecessor node and owned hero, deduct the correct soul type/quantity on a clone, persist before notifications, and then send star data, soul balances and hero stats. Duplicate/skip/invalid requests and save failures do not change resources. Inheritance refreshes both heroes.

Flash totals now count only activated nodes. Server progress updates refresh the current selected hero without returning to the first hero. The active-attribute tooltip and the backend use the same node/completion tables.

Test: `node sunucu-kok/sunucu/tests/hollow-soul-stats.test.js` verifies configured bonuses, the pictured +660 node, all six stats in PvE/PvP packets, matching combat HP, persistence, upgrade material checks and inheritance.
