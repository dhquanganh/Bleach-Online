# Soul Cultivation audit — 2026103001

Replaces the old CollectSoul stubs in `sunucu/ev.js` with `sunucu/soul-cultivation.js`. Native opcodes 0x01818800–03 and their packet layouts are preserved.

Fixes:
- Strict request lengths/operation flags; actual daily draw usage and UTC+7 reset; purchase counts reset daily while one-time exchange claims remain persistent.
- Prices use SoulCollectionBase and ConfigValue: junior 300000 silver; junior ten 2400000; senior 100 gold; senior ten 800; super 100. Native free timers are respected, with five junior free draws/day. The existing one-hour free cooldown is retained. Both ten-draw actions produce ten result IDs and the two Exclusive Fragments stated by the native tooltip.
- Reward pools follow operation type. Four unique, valid super rewards are persisted for the preview; super draws select from that preview. Reward aliases 6/7/13/21 resolve through the real inventory mapping.
- Energy retains the existing local policy of 100 per draw and now caps at ConfigValue 61600002 (10000). Exchange consumes the full bar, validates the reward, and prevents repeated frequency=1 claims.
- Daily base quota is ConfigValue 61600007 (100). A purchased quota adds that amount; purchase price is ConfigValue 61600006 and purchase count respects VipConfig.lotteryRecruitNum as well as the price-array limit.
- Inventory and state are prepared on a copy and persisted together; insufficient currency/stack space rejects before grant. Failed persistence refunds payment. Successful rewards send an immediate authoritative bag snapshot.
- Client claim tracking now inserts first claims and updates existing ones without duplicates. Opening the window again clears cached super-preview inventories before filling them.

Validation:
- `node sunucu-kok/sunucu/tests/soul-cultivation.test.js` passes: prices, free/paid draws, ten result IDs and bonus, quotas/VIP limits/reset, typed pools, preview agreement, capped energy, unique exchange, failed-save refunds, inventory saturation, alias rewards and real handler/inventory/currency persistence on isolated account files.
- Compiled client: nine other existing methods and all non-ABC assets unchanged.
- Native Flash regression uses the exact production claim helper and tests first/second/repeat claims plus 100 repeated updates. `validation/native/result.json` completed with no errors or live-account access. This is an isolated helper probe, not a manual end-to-end live-account UI test.
- Client-only release 2026103001 preserves every previous resource mapping. Backups are in `release-backup`.

Restart the server/account workers and open the launcher once to load this implementation and client version.
