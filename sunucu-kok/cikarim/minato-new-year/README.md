# Minato Namikaze [New Year]

- Hero `11121003`, Yellow Flash Clone `11121004`.
- Modify Fragment `14131003`, usable Recruit Token `14141003`.
- SSS, all 15 formation positions; excluded from the admin overlay hero shop.
- Client release `2026102804`.
- Original resources: `asset/Minato_New_Year_Full`.

The isolated `sunucu/minato-new-year-combat.js` module implements the team debuff
immunity aura, Flying Thunder Mark, ordinary/enhanced Mystery, rotating Rasengan
standards, evasion counters, clone resummoning and once-only Prowess.
Mystery attacks every living enemy as requested. Original skill/passive text is
retained with that target-count adaptation and the Physical ATK damage rule;
native tooltips contain plain text and real paragraph breaks rather than HTML.

All damaging attacks use buffed Physical ATK against Physical DEF. The source
reference has no numeric damage coefficients; the chosen coefficients are in
`sunucu/minato-new-year.json`. Healing retains the described max-HP ratios:
Prowess restores 70% HP and the one reserved clone has 100% of its owner's HP.

Safety and ordering:

- At most one Yellow Flash Clone actor per team; resummoning reuses its position.
- The clone is registered at zero HP, then its summon HP event starts its entry
  pose. Spawn/death timers and callbacks are isolated to that actor.
- Prowess cannot resurrect a dead Minato. A surviving clone cannot keep a wiped
  lineup fighting.
- Clone counters refund Mystery cooldown at most twice per round. Ordinary cast
  plus two refunds gives a finite maximum of three Mysteries per round; normal
  chakra, cooldown and control checks still apply.
- Flying Raijin buffs fire at Trigger execution and cap at six activations per
  round. Healing/rescue Trigger helpers notify this module as well.
- Prowess resets the primary action budget; an already-used standard is queued
  through the normal action spender, so it cannot turn into an infinite loop.

Animation:

- Original native SWF effects, alpha, blending, textures and timelines.
- About 5.8 MiB of compact actor textures and 13.1 MiB of native VFX.
- Source pivots, uniform 0.84 battle scale, fixed-canvas partner idle.
- Three original Rasengan standards, ordinary/enhanced Mystery, counter, evade,
  summon, Prowess, entry and death poses. Clone shares the owner's textures.
- `client-validation.json`: 224 existing TRole methods unchanged in decompiled
  output, with other unmodified methods verified in the patched classes.

Validation:

- `sunucu/tests/minato-new-year.test.js`: both camps/all slots, aura, mark,
  40% Mystery bonus, damage penalties, caps, clone reuse, Prowess, defeat and
  decoded binary battle reports.
- `sunucu/tests/physical-scaling.test.js`: Physical ATK/DEF, Magic ATK/Resistance
  independence and buff/debuff scaling across Minato and existing characters.
- Recruit-item, base-stat, Cross, Madara, Tsunade and Kakuzu regressions.
- `validation/native/result.json`: 24 Flash component cases, both camps,
  no runtime errors or remaining effect layers.
- `clone-lifecycle/validation/native/result.json`: six actors, delayed textures,
  death, respawn cancellation and listener cleanup.

These Flash probes are component previews, not logged-in account battles.
Backend tests separately exercise the actual combat scheduler and binary reports.
