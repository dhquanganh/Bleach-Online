# Tensō / ExpDuplicate

Backend: `sunucu/tenso.js`, registered through `savas-etkinlik.js`. Tensō is excluded from generic battle replay routing. All four requests use the Flash protocol exported in `original/scripts`.

- Six level-gated chapters, each with its own five EnemyArmy variants. Daily selections and refresh counts persist in `gunlukSayac.expd`.
- Refresh charges the configured gold price, selects a different variant, and updates the client army before its actual enemy skills.
- Challenges validate the exact four-byte chapter ID, level and daily allowance. They use the selected army and current formation with real win/loss resolution. Both outcomes consume silver and one attempt; only victories grant rewards.
- EXP matches the client's GetExp formula (HeroExp, current level, VIP and chapter difficulty). Coupon rewards use mutually exclusive cumulative Award tiers and are converted 1:1 to inventory item 14900001 (Nguy?n th?ch).
- Frontend fixes reward/level labels, locked chapter names, stale skills, preview refresh, pending requests and exhausted attempt counts.

`node sunucu-kok/sunucu/tests/tenso.test.js` exercises packet layout, rejection cases, refresh charging, daily rollover, persistence, win/loss, cumulative drops, real combat decoding and the production reward handler. It uses a temporary account directory and does not change the player's account.

`patch-client.py` builds from the exported pre-change client, checks that non-code SWF assets are unchanged, exports the compiled classes for verification, and installs client version `2026102311`. Pre-change canonical client and manifest are retained in `backups`. To build over a future client, export its current classes and decoded source first; the script rejects a mismatched source.

Verification is automated; the in-game UI has not been manually exercised. Restart the game server and reload the game to load the backend changes and new client manifest.

`build-primogem-reward.py` applies and verifies the Primogem label on the installed client and publishes version `2026102312`. Tests verify the Primogem inventory grant and unchanged Coupon balance.

`build-claim-items.py` publishes client `2026102313`. Its Tens?-only result parser normalizes legacy Coupon entries to item 14900001 before TItems categorizes rewards. Existing item rewards and quantities are preserved; the standard victory item slots provide the Article icon, name and tooltip. The packet integration test verifies an item reward of 15 reaches the victory popup and no Coupon entry is sent. Compiled code was re-exported and non-code assets checked unchanged; no manual game UI session was run.

`build-card-reward.py` publishes release `2026102314` with the Vietnamese card label `Nguy?n th?ch: 0-<maximum>`. It includes the actual index.swf and version.swf bootstrap and updates public/client-release.json last, so launcher loads the changed application. Earlier 2311?2313 app-only releases did not update the launcher pointer.

`build-guaranteed-reward.py` publishes client `2026102316`. Tens? victories now condition the original cumulative drop distribution on a nonempty Primogem tier (40% minimum, 40% middle, 20% maximum). The item remains 14900001, matching the Article named Nguy?n th?ch and Mystic Shop. Chapters award 5?15, 10?20, 15?25, 20?30, 25?35 or 30?40 gems. The former 50% empty tier is excluded, and the production-handler regression forces RNG=0 to verify that even this former empty-drop case persists 5 gems and sends them in the victory result. Frontend labels show the positive range.
