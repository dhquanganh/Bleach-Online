# Accessories stat audit — client 2026102602

Verified the current native client, `BaseEquip`, `OrnamentValue`, `Suit`, equipment packets, character stat packets, and combat units. No player saves were edited.

Changes:

- Flat accessory Strength/Intelligence/Agility/Stamina now affect the corresponding derived physical ATK/DEF, magic ATK/Resistance, Speed and HP. Conversions use the hero's calibrated base ratios, as the existing stone/fruit system does, before final multipliers.
- Rock Bracelets grant 600 Stamina; strengthening to level 1 adds 54 for a total of 654. The native decoder incorrectly added attribute ID 4 to the upgrade amount and displayed 58 instead of 54. The compiled decoder now matches the catalog and server.
- Physical ATK/DEF are read independently from magic ATK/Resistance. Magic accessories no longer silently raise physical damage or defense through a `max(physical, magic)` shortcut.
- Matching Rock Bracelets and Rock Anklets grant 5% Fury resistance once; unequipping either removes it. Bag items and other heroes' accessories grant no stats.
- Hostile Fury reduction uses target resistance offset by the attacker's Fury effect bonus. Fury resistance cannot avoid a character's own Mystery cost. The no-Fury effect still blocks normal Fury generation.

Validation:

```
node --test sunucu-kok/accessories.test.cjs
node sunucu-kok/sunucu/tests/physical-scaling.test.js
node sunucu-kok/sunucu/tests/soul-stone.test.js
node sunucu-kok/sunucu/tests/level-stats.test.js
```

The accessory tests compare native compiled tooltip expressions against server totals at levels 1, 10, 50 and 100, verify both stat blocks, immediate upgrade notifications, reload and actual battle-report HP. The physical scaling suite checks 50 move/camp combinations. Alliance regression tests also pass.

The broad `hero-skills.test.js` suite stops on the existing Small Katsuyu catalog row (`active: 0`). This was reproduced with the pre-change `HEAD` version of `hero-skills.js`; it is independent of these accessory fixes.

Restart the server and reload the launcher to load backend changes and client 2026102602.
