# Consecutive hits and foreground damage — client 2026102106

Mecha Naruto and Itachi Road to Ninja now use consecutive damage impacts for all
16 damaging skills. Existing multi-impact timing is retained (including the
eight-hit Taijutsu Combo and two-hit Deidara/Sasori). The previously single-impact
Beast Bomb, Claw and Sharingan use four impacts inside their existing hit effects:

| Action | Frames at 25 fps |
| --- | --- |
| Beast Bomb | 53, 59, 65, 71 |
| Beast Claw | 38, 42, 46, 50 |
| Sharingan | 31, 36, 41, 46 |

`ninja-multihit.py` owns these schedules. Actor images, pivots, clip durations,
skill return times, VFX and the preceding Mecha/Pain size repair are unchanged.
Support actions (transformation, Energy Recovery, Jet and Crow) retain their
existing non-damage behavior. Damage continues to use Physical ATK/Physical DEF.

The old native partition helper supported only four/five hits. It now supports
1–64 impacts. At impact i of n, damage is
`floor(total*(i+1)/n) - floor(total*i/n)`. Thus three/eight-hit skills no longer
lose damage to percentage rounding. Each impact deducts HP and shows its own
number; death checks happen only at the final impact. The report still contains
one total per cast/target: no multiplied damage, extra Chakra costs, additional
passive stacks or duplicate target vectors.

All `TBattleStage.SetFloatText` damage/healing numbers and their critical/block
captions use a dedicated `battleDamageFloatLayer`. It retains the original text
positioning, typography and float animation. Mouse input passes through it. Its
display order is restored at ENTER_FRAME and RENDER, so native flashes and
raster VFX appended later in a frame cannot cover the numbers. Reset removes the
layer/listeners, and the next battle creates a fresh layer. Other UI text is not
moved into this layer.

`build.py` patches the current live client rather than rolling back to an older
character build. Only TEffectControl and TBattleStage are imported. Unrelated
methods are compared after compilation; full TRole and TActive class exports
are also identical before/after. Only the requested heroes' hit schedules and
descriptions change in native databases. Modified Bin URLs are versioned; the
previous 2026102105 model URLs are retained. Backups are in `backups/`.

Validation:

* `sunucu/tests/ninja-multihit.test.js`: 31 skills / 124 authoritative
  damage, shield and camp cases across Mecha, Itachi, Pain and Hashirama.
* Existing Itachi and permanent Mecha Beast combat suites pass.
* Native Flash probe: 622 exact integer-partition cases, 16 foreground paint
  cases covering eight native/raster overlay types in both camps, plus reset.
  It invokes the installed partition helper and copies the verified production
  layer methods into a component host. It uses solid occluding overlays and
  test labels; it is not a complete interactive gameplay run.
* `native-result.json` and `foreground.png` record the native component proof.

Restart the backend to reload hit-count configuration and completely reload the
game to load client 2026102106 plus its native databases.
