Tournament of Throne audit ? 2026-10-29

Backend:
- Real account registrations only; capacity eight per eligibility group and final registration-order pairing at cutoff.
- Registration uses PvP snapshots. Both combat camps use their own saved units, PvP stats and skill lists; spectator account data cannot provide missing skills/equipment.
- Submission switches the server's viewed group to the actual registration group. All player/fight/rank packets identify their group so stale tab replies cannot overwrite another roster.
- Current registration group is transmitted separately from an old pending-prize group. Archived winning wagers remain discoverable and collectable through Collect All during the next event.
- Malformed replay requests, invalid stat snapshots and orphaned historical wagers fail safely. Error messages are valid UTF-8 Vietnamese.
- A notification send failure after durable commit cannot roll back the registered entry/result or refund a wager already settled.

Client:
- Stop ButtonBar at its final frame before binding controls; captions use correctly positioned system-font labels over the native button artwork.
- Registration status is inside the roster panel; group/empty-seat labels are explicit. Prize access remains available during registration. A submitted entry follows its actual eligibility tab after the refreshed base packet.
- Current group filtering and separation of registration/old prize groups; refresh and action-pending timeout handling; clock clears instead of freezing after expiry.
- Detail panels hide stale character mounts for missing entrants, retain working close binding, and empty branches are not clickable.
- Archived wager winnings enable Collect All; losing/pending wagers do not falsely enable it.

Validation:
- king-challenge.test.js uses temporary accounts/registry, tests registration/capacity/cutoff/byes/real matches/betting/prizes/replay/migration, failed save and failed registry rollback, failed notification after commit, malformed inputs, group trailers, actual PvP snapshot stats, archived prize-group separation and old wager collection exactly once.
- Isolated Flash preview: protocol accepts current and ignores stale group packets, decodes old-prize/current-registration separation and pending old wagers, plus five native UI states. It accesses no live accounts.
- Incremental client compilation verifies unchanged resource tags and all methods outside the targeted tournament methods. Battle animation classes are retained.

An empty roster (0/8) remains valid when no real player has registered. Schedule stays Monday/Wednesday/Friday, 21:05 UTC+7. No live account registration, betting or prize claim is performed by the tests.
