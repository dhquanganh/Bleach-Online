# Titles / danh hiệu

Backend ownership is `oyuncu.json.unvan = {version:2, owned:{titleId:{obtainedAt, expiresAt, source}}, takili:[...]}`. Title information and achievements now use live state rather than captured packets. Equipment checks exact request length, catalog membership, ownership, expiry and title group. Expired records remain visible as history but cannot be equipped and contribute no stats.

Using one title item activates/auto-equips the configured title. Timed reuse adds the configured duration to the later of now/current expiry; expired titles renew from now. Permanent duplicate grants are rejected. Inventory/title state is saved before success notifications; a failed title-item save preserves the item and prior ownership. Existing saves migrate only previously equipped titles and titles attached to saved claimed achievements. Legacy timed equipment without an old timestamp starts its configured duration at migration.

The shared equipment/stat calculation applies the title's configured attributes and scope: 1=whole team, 2=positions 1–5, 3=positions 6–10, 4=positions 11–15. Both stat blocks and battle generation use it. Arena snapshot cache keys include effective equipped titles, so expiry invalidates an offline opponent's cached stats even with unchanged save files.

Achievement requests use live server progress, reward claims are validated and persisted once, and `titlePending` recovers interrupted account/player writes. Eligibility derives supported conditions from levels, military rank, hero ownership, completed instance stages, home/girlfriend level, summon counters, gold balance and verified gold spending. Other condition types require existing trusted `achievementProgress[achievementId][conditionType]`; they are not automatically marked complete. Existing claimed achievements and owned title records preserve earned completion. Cumulative gold-spending evidence is separate from round Crystal resets and subtracts explicit refunds. Public achievement inspection is distributed through authenticated public profiles and resolves exact role IDs.

Client release **2026102513** patches two native classes on the current reviewed client:
- Full sync clears stale ownership flags and redraws the title panel.
- Unknown title records are fully consumed and skipped without losing alignment or looping.
- Progress totals reset per title; equip/other-profile errors return before reading a success payload.
- Countdown clamps at expiry instead of unsigned wraparound.
- Title expiry polls every five seconds; own achievement progress refreshes while its panel is visible.

Rebuild: `python sunucu-kok/cikarim/titles/build-client.py`. It refuses to overwrite a client unrelated to the reviewed source/current compiled output. All non-ABC SWF tags are checked unchanged, and the compiled methods are re-exported into `verify/`.

Validation: 38 related backend/frontend/regression checks pass. `titles-ui.test.cjs` executes method bodies re-exported from the compiled SWF with protocol fixtures (ownership replacement, unknown IDs, per-title progress, errors, expiry, polling and other-player errors). Full interactive Flash gameplay was not automated.

Existing unrelated failures verified separately: `usable-items.test.js:13` fails 1 !== 0 on its EXP fixture against the original HEAD bag module as well; `hollow-soul-stats.test.js:21` reports HP 12966 vs 13233 even with title bonuses disabled. Those unrelated formulas/fixtures were not changed.
