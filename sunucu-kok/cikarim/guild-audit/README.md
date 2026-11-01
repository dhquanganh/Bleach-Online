# Guild repair, 2026-10-30

Shared authoritative registry: `.accounts/guilds.json` (`BLEACH_GUILD_FILE` override). Account workers use authenticated account IDs. Existing local guild name/family is migrated once; same-name/family memberships merge, resources import once, personal research/merit/coins/solo progress survive. Previously opened legacy group maps reopen at their original first boss because the old implementation did not store actual boss HP.

Guild mutations are locked and atomically persisted, with write-ahead receipts for the account state/currencies. Offline warehouse distributions are durable inbox parcels, converted once to normal claimable mail even after the recipient leaves. Role checks, exact payload sizes, source prices, stock counts and resource sufficiency are enforced before commit. Live IPC refresh propagates membership and resource changes across account workers; periodic refresh maintains profiles and day rollover.

Solo and group battles use configured OrgPointInfo/EnemyArmy opponents and real battle reports. Group enemy HP is persisted by formation position, avoiding duplicate-template collisions. Quotas, activity, vitality, reset prices, drops and guild-coin rewards use native tables. Group loot enters shared warehouse; chief distribution writes visible allocation history. Guild shops use real BlackMarket models 3/4, guild coins and per-offer limits. Markets 0/1/2 retain their existing handlers.

Personal guild research contributes the configured cumulative flat bonus, not a sum of all levels. Cross Server continues to use its independent base-only stats.

Native fixes: Silver donation field read, duplicate instance catalogs, stale daily fight/reset counters, duplicate member entries. Build verification retained all non-ABC assets and checked 68 other methods (including equivalent compiler simplifications). Four native Flash runtime protocol cases passed, with no account access.

Checks:
- `node sunucu-kok/sunucu/tests/guild.test.js`
- `node sunucu-kok/sunucu/tests/cross-server-scaling.test.js`
- `node sunucu-kok/sunucu/tests/king-challenge.test.js`
- `validation/native/result.json`

Guild legacy war commands do not create fake victories or nonexistent opponents; the separate Alliance War system is unchanged. No real-player live session was used for the tests. Restart the auth/game server and reopen the launcher to load backend changes and client 2026103003.
