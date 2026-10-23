# Void Region Naruto bosses - client 2026102238

Admin catalog includes the seven active Naruto profiles (Sage Naruto, Obito,
Pain, Hashirama, Mecha-Naruto, Itachi and Sasuke Shinden). Removed heroes and
summons are excluded. Naruto entries are prioritized in the bounded admin
search response and labelled [Naruto]. Existing Enemy bosses remain available.

The config resolver exposes a boss-shaped view for BaseHero entries. Battle
entry builds them with heroBirim, preserving their existing skills and physical
combat profiles, then applies boss HP and the configured combat stat overrides.
Global event HP and metadata use the same config. Saving still resets the round.

The sole Flash class change allows TProcessorMonsterHead to resolve RoleModel
directly from hero ID when no Enemy row exists, including its asynchronous head
callback. All non-ABC assets are verified identical to client 2237.

Passed checks:
- node --test sunucu-kok/void-region-admin.test.cjs
- node sunucu-kok/sunucu/tests/void-region-boss.test.js (actual reports for all 7)
- node sunucu-kok/sunucu/tests/void-naruto-portraits.test.js (compiled AS bodies)
- node sunucu-kok/sunucu/tests/void-region-frontend.test.js
- admin inline JavaScript syntax
- python sunucu-kok/cikarim/sasuke-shinden/verify-bootstrap.py

Full authenticated Flash playback was not visually tested.
