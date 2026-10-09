# Partner star upgrades

New entry below Event in Modify Lab; three owned partners per page, a single upgrade action per card. The star page hides the old Modify/Cultivating Dojo tabs and Create action; switching back restores the original menus. Partners displays a separate gold star count badge, loaded from the server and refreshed live.

Partners only, per explicit user choice. Requires the exact HeroChangeAttr fragment used by that partner. Upgrades to stars 1..24 consume 50 fragments; upgrades to stars 25..50 consume 100. Max 50. No gold cost. Requests include the expected current count to reject duplicate/stale clicks. Stock and ownership are validated before cloning/consuming. Save failure preserves stars/materials.

State: `oyuncu.json -> heroStars -> heroId: count`. Stats: multiplier 1 + 0.2 * count applied after equipment, reincarnation and refinery to both PvE/PvP core stat blocks and BattlePower. Float percentages remain unchanged. Combat uses the same stat packet. Legacy Flash integer attributes saturate at 2147483647; higher stars remain stored but cannot exceed that wire limit.

CS info 0x0181f200; CS upgrade 0x0181f201 carries u32 heroId + u32 expectedStars. SC 0x01186f7e is UTF JSON within the existing HeroChange routing range. Native stats and bag updates follow success.

Test: `node sunucu-kok/sunucu/tests/hero-stars.test.js`.
Build: `python sunucu-kok/cikarim/flash-hero-stars/build.py --ffdec PATH/ffdec.jar --install`. Compiles dependencies in order, verifies decompiled symbols and preserves non-code SWF tags; backs up the installed file. `--partner-only` resumes from the existing phase-1 SWF for a Partners-only correction and must only be used with the matching saved intermediate build.

Restart server and game after installation. Actual interactive Flash rendering/clicking still requires manual verification.
