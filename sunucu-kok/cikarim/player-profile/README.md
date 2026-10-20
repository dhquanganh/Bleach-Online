# Public player Inspector

Client **2026101977** plus backend changes replace the fixed captured Inspector packet with account-specific public character data.

`sunucu/player-profile.js` serializes the selected account's main character and owned partners using the same hero, attribute, equipment, awakening, rebirth and jade serializers as login. It includes saved formation positions, individual partner levels, selected main skill and Zanpakuto. Currency, account credentials and private inventory are excluded. Snapshot construction clones its input and does not save the target account.

The existing isolated Arena snapshot process now also builds the public profile. The parent distributes it with the complete roster to every account worker, including profiles outside the eight Arena opponents. The worker keeps this public directory separately from battle-opponent data. Lookup matches both 32-bit role ID words. Self inspection builds from current local state. Missing, malformed, deleted or unavailable identities return an error and never use the captured bot response. Remote snapshots follow the existing roster refresh (normally five seconds).

The native Inspector request now hides and clears the previous profile and item window before requesting the next role. It no longer ignores a new request because the old profile is visible. Its server-time namespace calls are explicitly qualified to preserve their original AS3 binding through recompilation. The installed battle-speed/native-Skip class is unchanged.

Validation: `node --test sunucu-kok/sunucu/tests/player-profile.test.js sunucu-kok/arena-ranking.test.cjs` passes eleven tests. The profile integration test runs the real snapshot child for two isolated accounts, walks the serialized hero/equipment records, switches A→B→A, changes equipment and formation, tests identical equipment instance IDs across accounts, removes stale identities and checks self inspection/read-only behavior. `verify-client.py` checks the installed native client, request reset/IDs, version manifest and unchanged battle-speed UI class. No production account is edited by these checks.

Restart the server/account workers and reopen the game to load the backend and client changes.

Client 2026101965 removes an unsafe Inventory=null assignment when changing Inspector targets. The native inventory-window setter requires a non-null item; the normal Hide lifecycle already releases its tooltip reference. The target-switching behavior remains in place.

Client 2026101975 repairs the first-click crash: RequestShowHero previously called player-window Hide unconditionally, but Hide calls Reset and Reset dereferenced its not-yet-assigned FHeros. No network packet was sent. Requests now close only visible windows, and Reset returns safely before touching controls when FHeros is null. Existing target switching, role IDs, profile serialization, combat, physical damage, healing and disabled shake are retained. `fix-first-open.py` incrementally builds this fix from the live client. `probe-first-open.py` reproduces native Flash #1009 with the original methods and exercises the repaired first-open/switch/reopen request path; `run-first-open.js` runs that isolated probe without account access.

Player profiles include each partner's persistent `heroStars` count. Native Inspector reads the appended ID/count map before showing the target and refreshes the local account's star map when the profile window closes. Build/install with `python fix-profile-stars.py`; the installed client revision is `2026101977`.

Client 2026101978 renders that map inside the read-only Inspector itself: a gold `x N` badge appears beside the existing star row, and up to seven stars light according to the real count. `fix-profile-star-display.py` preserves the profile parsing and all unrelated window methods.

Client 2026101979 separates the two star systems correctly. The original top row remains `ChangeSchedule`; Modify Lab's persistent 0–50 partner stars use a separate gold icon and `x N` badge at the lower-left of the character panel.

Client 2026101980 places that lower-left badge on the PlayerAssets foreground layer at the same visual height as the badge in the player's own Team Info window, preventing the character-panel background from covering it.

Client 2026101981 anchors the badge to the inner `HeroEquipInfor` panel at `(10,218)` and raises it within that panel. This matches the own-partner badge position without drifting into the partner list when Inspector uses a different outer-window origin.

Client 2026101982 moves the complete gold star/count widget to `(120,300)` in `HeroEquipInfor`, matching the user-marked lower-left area beside Battle Power while preserving its partner-style icon and text.
