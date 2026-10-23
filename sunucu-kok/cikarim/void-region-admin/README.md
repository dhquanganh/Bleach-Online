# Void Region entry, rewards and admin boss

## Void rewards and VIP-free Skip — 2026102245

Void attendance claims now award 60,000 of the existing Mystic Shop `Nguyên thạch` inventory item (Article `14900001`) and two Void chests, with no Gold currency. Coupon/Gold reward previews map to this Article and its existing inventory icon; displayed reward quantities are doubled. Claims are marked only after validating the full item reward list, use normal inventory notifications, and reject retries. Skip battle is enabled without VIP only when the battle type is Void Soul World; other battle types retain their normal VIP requirements. Void formation submission accepts up to seven distinct occupied battle positions, includes the main hero within that limit, and keeps the original position mapping in combat.

Checks:
- `node sunucu-kok/sunucu/tests/void-entry.test.js`
- `node sunucu-kok/sunucu/tests/void-region-boss.test.js`
- `node sunucu-kok/sunucu/tests/void-rewards.test.js`
- `node sunucu-kok/sunucu/tests/void-region-frontend.test.js`
- `python sunucu-kok/cikarim/sasuke-shinden/verify-bootstrap.py`

Client release: `2026102245`. Restart the backend to load the reward and formation changes; the client release pointer is already updated.

The live client had no click handler on the "Click to battle" guide, although
the floor entrance was interactive. Its admission handler also discarded the
participant fields, leaving client front-player/death state inconsistent. Four
classes are patched from the current application: pointer clicks go through the
existing front validation; admission decodes the player, adds it to its front,
hides the map for the local player, and dispatches battle status before setup.
Other participants never start a local battle. Pending clicks are deduplicated.
The existing battle handle's Void IsInBattle reset is preserved.

`sunucu/void-region-config.js` owns a shared file configuration (override path
`BLEACH_VOID_CONFIG` for tests). Admin GET/PATCH `/auth/admin/void-region` requires
admin access, validates an existing boss with local combat/showcase animations,
checks revisions and atomically saves. The accounts admin page provides search,
selection, save and reload. Configuration is read on each event/battle access,
so existing account workers see changes without restarting for each boss edit.

One selected Enemy drives the native report, map model, head icon, name, roster
popup and global HP. Enemy heroIcon aliases are respected. The init packet keeps
its legacy binary prefix and appends UTF JSON; old clients ignore it. Current
clients read it after the existing unstreamizer. UI model/head loads are reused
per revision, and stale icon callbacks are rejected.

The old map showed a five-enemy Hell army while combat used a hard-coded
Ulquiorra stage. Combat now builds a single configured enemy directly, uses the
submitted formation at all 15 valid slots, limits legacy report integer stats
to 1 billion, keeps the raid HP as a safe integer, and computes actual wins and
actual damage without a forced victory. The default selection retains the old
combat enemy Ulquiorra; the map now agrees with it.

Saving a boss creates a new revision/round: HP, damage/rank, participants and
attendance reward eligibility reset on next event access; a same-cycle submitted
formation is retained. Old delayed death/rank packets are suppressed if a new
boss round has started. Ranking uses current saved state, not a stale snapshot.

Checks (no real account writes):
- `node --test sunucu-kok/void-region-admin.test.cjs`: permissions, invalid IDs,
  stale revisions, persistence and independent process reads, temporary config.
- `node sunucu-kok/sunucu/tests/void-region-boss.test.js`: admission, submitted
  lanes 4/10/15, dynamic boss report/metadata, damage, revision reset/deduplication.
- `node sunucu-kok/sunucu/tests/void-entry.test.js`: deterministic cloned fixture,
  original front 7/11/main entry, report decode and invalid requests.
- `node sunucu-kok/sunucu/tests/void-region-frontend.test.js`: actual patched AS
  bodies; set VOID_UI_SOURCE to compiled decompiled classes to repeat checks.
- build verifies non-code SWF tags; HTTP bootstrap verifies published routes.

These are packet/component tests, not a full authenticated interactive Flash
session. Restart backend once to load new handlers; reload the launcher for the
new client. Subsequent boss changes apply when reopening Void Region.
