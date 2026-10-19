# Public player Inspector

Client **2026101964** plus backend changes replace the fixed captured Inspector packet with account-specific public character data.

`sunucu/player-profile.js` serializes the selected account's main character and owned partners using the same hero, attribute, equipment, awakening, rebirth and jade serializers as login. It includes saved formation positions, individual partner levels, selected main skill and Zanpakuto. Currency, account credentials and private inventory are excluded. Snapshot construction clones its input and does not save the target account.

The existing isolated Arena snapshot process now also builds the public profile. The parent distributes it with the complete roster to every account worker, including profiles outside the eight Arena opponents. The worker keeps this public directory separately from battle-opponent data. Lookup matches both 32-bit role ID words. Self inspection builds from current local state. Missing, malformed, deleted or unavailable identities return an error and never use the captured bot response. Remote snapshots follow the existing roster refresh (normally five seconds).

The native Inspector request now hides and clears the previous profile and item window before requesting the next role. It no longer ignores a new request because the old profile is visible. Its server-time namespace calls are explicitly qualified to preserve their original AS3 binding through recompilation. The installed battle-speed/native-Skip class is unchanged.

Validation: `node --test sunucu-kok/sunucu/tests/player-profile.test.js sunucu-kok/arena-ranking.test.cjs` passes eleven tests. The profile integration test runs the real snapshot child for two isolated accounts, walks the serialized hero/equipment records, switches A→B→A, changes equipment and formation, tests identical equipment instance IDs across accounts, removes stale identities and checks self inspection/read-only behavior. `verify-client.py` checks the installed native client, request reset/IDs, version manifest and unchanged battle-speed UI class. No production account is edited by these checks.

Restart the server/account workers and reopen the game to load the backend and client changes.

Client 2026101965 removes an unsafe Inventory=null assignment when changing Inspector targets. The native inventory-window setter requires a non-null item; the normal Hide lifecycle already releases its tooltip reference. The target-switching behavior remains in place.
