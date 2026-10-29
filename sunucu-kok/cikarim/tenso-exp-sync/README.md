# Tenso EXP sync (2026102907)

- Server EXP reward is three times the original rounded formula for every stage, level and VIP tier.
- Client GetExp preview applies the same multiplier. Other methods and non-ABC assets are unchanged.
- Reward delta is granted once before replay. Authoritative per-hero EXP follows; level-up and stat notifications are sent immediately for main and deployed partners.
- Item rewards, costs, attempts and defeat rewards retain existing behavior.

Validation: `node sunucu-kok/sunucu/tests/tenso.test.js` passes, including a real grant crossing a level threshold, exact EXP delta, absolute EXP packets before replay, all-stage multiplier checks, loss handling and persisted values. Tests use isolated player files.

Build: `build.py`; publish: `release.py` (requires predecessor 2026102906). `client-validation.json` records 10 unchanged methods and unchanged assets. Publication verified decrypted client, canonical/versioned copies and a single changed manifest entry. No manual live-account UI test was performed.
