# Soul Palace daily point chests

The screenshot is the native SkyTower/Soul Palace chest panel, not Daily Tasks.
Thresholds remain **5, 10, 15, 20, 50, 100, 150, 200, 250, 300, 330, 360**.
Points count the permanently cleared subfloors. A player may select **one**
eligible chest each day; taking a lower chest does not permit claiming a higher
chest on the same day. Day rollover preserves cleared floors and restores the
daily choice. Existing current-day claims are retained during migration.

## Admin

The separate admin page has a **Rương điểm Soul Palace** tab. Select a threshold,
edit quantities, remove rewards, browse/search actual inventory items with icons,
or add currencies. Changes across all 12 thresholds are saved together. Empty
reward lists disable that chest. Default rewards match TemplePliesNumber/Award.
No example changes or free items have been applied to live accounts.

`GET/PATCH /auth/admin/palace-chests` requires admin authorization. Configuration
is stored atomically under `.accounts/palace-chests.json`, using the existing
cross-process locked store and optimistic revision checks. Workers read the file
on each info/claim request. Optional isolation: `BLEACH_PALACE_CHEST_FILE`.

The native tooltip reads compressed reward configuration appended to ChestInfo.
Reopen the chest window after an admin edit; no F5 or client recompilation is
required for future reward edits.

## Reward safety

`sunucu/palace-chests.js` validates the selected ID, points, once-per-day choice,
inventory stack/bag capacity and currency limits before committing. Items and
currencies are staged together with the claim marker. A redo journal covers the
account and player files, recovery runs before player loading, and failed saves
restore the original bytes. Native bag and currency packets are sent only after
commit. Claims are not reset by admin revisions.

## Validation

- `node palace-chests.test.cjs`: admin permissions/CAS, add/delete validation,
  icons, worker hot reads, exact grants, daily reset, replay protection, stack and
  currency overflow, save failure rollback, current tooltip data and recovery.
- `node soul-palace-admin.test.cjs`: existing floor/progression/combat regressions.
- `validation/ui/result.json`: actual admin page in hidden Electron 1.8, tab,
  12 milestones, icons, item search, add/delete/quantity/save and switching tiers.
- `validation/ui/admin-preview.png`: isolated admin preview, not a live account.
- Client release **2026103107** changes only native chest/protocol UI code and
  preserves all original SWF artwork. Start from the active 2026103106 client.

Restart the services for new backend handlers and reopen the launcher once to
load 2026103107. Future admin edits apply without restarting.
