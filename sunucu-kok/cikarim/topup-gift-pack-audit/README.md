# Top Up Gift Pack / First Top-up — 2026103002

Audits the enabled First Top-up event (wire 12, category 130000, HDFirstPay). The separately defined but unregistered FirstPayBag activity is not activated or duplicated by this change.

Fixes:
- Dedicated init packet includes the native Parameter block with actual cumulative recharge and all six configured award states. It no longer uses a captured account packet patched by character level.
- Eligibility uses `durum.topup.toplam`, not level, wallet Gold, VIP level or VIP EXP. Existing configured thresholds and rewards are retained, including the first threshold of 1. VIP-only top-up cards retain their existing separate behavior.
- Strict claim payloads, enabled-event checks, tier validity, threshold checks, sequential claims and duplicate rejection. Existing claimed indices are retained. Old records with the final tier claimed do not hide unclaimed earlier tiers.
- Grant actual items and currency fields once, without also granting usable currency proxy cards. Item stack capacity is checked before committing. Full bag and absolute currency updates are queued after settlement; the generic activity grant path is bypassed to prevent double payment.
- A write-ahead currency journal completes both currency and player-state files after interruption. Recovery runs at account-worker startup and event access. Top-up credit itself uses the same journal, validates input and returns fresh event progress packets for immediate delivery to connected clients.
- Native client checks every tier before hiding the event and refreshes the shortcut's status after receiving updated progress. Empty award lists are guarded.

Validation:
- `node sunucu-kok/sunucu/tests/topup-gift-pack.test.js` passes: no recharge/level159, real recharge and live packets, actual mixed rewards, exact money and inventory, no proxy duplication, sequential/duplicate/malformed/closed claims, legacy final-only records, persistence recovery and full stacks. Tests use isolated account files.
- Flash probe uses the actual activity decoder and recharge decoder on five server-generated packet fixtures: unpaid, first threshold, partially claimed, legacy final-only and completed. It calls the compiled production completion check. Five cases pass with no errors or live-account access.
- Other pre-existing methods and all non-ABC assets are unchanged. Client-only publication changes one manifest entry and preserves previous resource versions.
- A broader `usable-items.test.js` run fails at its existing EXP-use fixture (line 13), before any top-up gift flow. That unrelated fixture/path was not changed here. The dedicated event tests pass.

Restart the server/account workers and reopen launcher 2026103002 once. No admin overlay was added back, and no live account was credited or claimed during validation.
