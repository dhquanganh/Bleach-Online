# Black Market test offer

Backend: `sunucu/black-market.js`, editable `sunucu/black-market-config.json`.
50 Epic EXP Scroll (14100005) cost 50 gold, one bundle per refresh. Gold only; coupons are not spent. Automatic refresh after 10 hours; manual refresh costs 10 gold. Mystic Shop is outside this test offer.

The client uses TimeMall type 0, not the obsolete BlackMarket purchase opcodes. Offers carry server metadata in a UTF JSON extension, used to rebuild the preview and prices. Buy replies carry authoritative purchase counts. Inventory notifications and a full bag packet follow a successful purchase.

Build: `python sunucu-kok/cikarim/flash-black-market/build.py --ffdec PATH/ffdec.jar --install`.
Test: `node sunucu-kok/sunucu/tests/black-market.test.js`.
Compiled assets are checked to remain unchanged, and live SWF is backed up before installation. Interactive Flash clicking still requires manual verification. Restart backend and game to load changes.
