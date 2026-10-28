# Madara Uchiha [The Final Battle]

- Hero: `11121001`, reserved Shadow Clone: `11121002`.
- Modify Fragment: `14131001`; usable Recruit Token: `14141001`.
- SSS, any formation position; excluded from the admin overlay hero shop.
- Source: `asset/Madara_The_Final_Battle_Full`.
- Client release: `2026102802` (full-width Mystery cut-in).

The ordinary and Chakra Burst skill sets, 20-combo chase, technique points,
first-entry fatal protection and clone reactions live in `sunucu/madara-final-combat.js`.
All attack damage, including reflection, clone splash and Inferno, uses Physical
ATK. Original skill/passive wording remains in the UI; damaging skills also state
the Physical ATK adaptation. The source screenshot has no damage coefficients;
the explicit chosen coefficients live in `sunucu/madara-final.json`.
Clone splash retains full armor penetration and a 30000 damage cap.

Actor images retain source pivots and aspect ratio. Battle actors use 0.84 scale;
the partner idle uses a fixed canvas. Original native SWF effects retain their
timelines, blending and alpha. The clone shares its owner's textures, with
separate actor state, spawn/death poses and a blue tint.
Models occupy about 12.5 MiB and native effects about 28.8 MiB, including the
Mystery cut-in. No rasterized VFX atlases are loaded.

Validation:

- `node sunucu-kok/sunucu/tests/madara-final.test.js`
- `node sunucu-kok/sunucu/tests/physical-scaling.test.js`
- `node sunucu-kok/sunucu/tests/naruto-recruit-items.test.js`
- Existing Tobi, Kakuzu, Tsunade, Mecha, base-stat, Cross and defeat regressions.
- `validation/native/result.json`: 28 Flash component casts, both camps,
  zero runtime errors and zero remaining effect layers.
- `clone-lifecycle/validation/native/result.json`: six actors, delayed texture
  delivery, death callbacks, respawn interruption and listener cleanup.
- `client-validation.json`: 214 existing TRole methods unchanged in decompiled
  output, plus unaffected methods in the other patched classes.

The Flash probes are isolated component previews, not logged-in account battles.
Backend tests separately decode actual binary combat reports in both camps.

Build sequence: `prepare-assets.py`, `build.py`, `build-items.py`, capture the
active client into `source.swf` and `original/`, then `build-client.py` and probes.
`release.py` verifies the probe results and publishes fresh manifest URLs.
FFDec is located at `tools/ffdec/ffdec.jar`. Runtime assets do not depend on FFDec.

The full-width cut-in fix lives in `full-width/`. It preserves the image aspect
ratio, fits the painted panel rather than its transparent gutters, and changes
only `PlayMadaraNative`; 228 other TRole methods remain unchanged.
