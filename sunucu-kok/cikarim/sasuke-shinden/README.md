# Sasuke Uchiha [Sasuke Shinden]

Hero 11120970, talent 13220970, skills 13121301–13121309, Modify Fragment
14130970 (inventory texture uses picture ID 16228122). SSS, all formation rows.

`sasuke-combat.js` contains the isolated rules. Kirin changes to Blaze Infusion
and back, with cooldowns 3/0, cost 20, battlefield cooldown 0 and a shared
two-casts-per-round cap. Standards change at 50% HP. Dragon Fire alternates on
odd/even rounds. Visual-jutsu reactions have one shared four-per-round cap.
The first two Mystery attacks receive 40% mitigation; the first two pure
Taijutsu attacks do no damage. HP-based Disorder/Fear retain their own formulas.

All damaging moves use Physical ATK, Physical DEF and all living enemy targets,
with consecutive client impact markers splitting the total damage coefficient.
Coefficients are local tuning: the reference does not give numeric attack ratios.

Source: `asset/Sasuke_Shinden_Full`, including native actor, normal/blaze effects,
Kirin cinematic effects, Susanoo, portraits, item artwork and skill icons.
The reference video is https://www.youtube.com/watch?v=_pOWA-BB3ro.

VFX are isolated in the Sasuke namespace. Paged RGBA atlases are at most 2048px;
the player consumes compressed ARGB streams with bounded lookahead/cache rather
than decoding large PNGs while casting. Effect age follows the actor's frame,
so x2 advances the effects and actor together. Stage sorting lifts damage text
above Sasuke effects. Existing character method bodies are checked unchanged
when rebuilding the application.

Release 2026102126 repacks the effects into the separate `sasuke-vfx/large-v2`
cache namespace, retaining up to 1400×1050 pixels per source cell on bounded
2048px pages. Kirin uses 1.55× the previous display scale, Dragon Fire up to
1.7× (subject to viewport limits), Chidori 1.35× and Susanoo 1.25×. The camera
keeps the main action visible while allowing distant sparks beyond the viewport;
it no longer shrinks the whole cinematic solely to fit its particle envelope.

Release 2026102128 keeps that presentation and replaces transparent frame
padding with lossless, individually trimmed atlas rectangles. All 818 unique
frames reconstruct exactly to the preceding RGBA images, including pivots and
timing. The 132 pages become 47; decoded atlas area falls 65.70% and frame copy
area 70.62%. Playback keeps one reusable surface per layer, uses two concurrent
downloads, and evicts unpinned pages toward a 32-million-pixel LRU target;
opening and active pinned pages may exceed that target. Opening frames stay warm to avoid cold-start
gaps when another skill evicts the preceding cast's pages.
Pages follow first-use playback order instead of rectangle-size order to avoid
mid-cast cache churn. A 24-frame lookahead also covers x2 playback.
The versioned bootstrap publishes `client-release.json` after all release files.

Release 2026102129 changes the visible presentation. `presentation.py` derives
hit anchors from the bright native artwork, so surrounding smoke no longer
centers strikes away from their victims. Kirin lands at the enemy's feet,
Chidori/Dragon Fire at torso height, and Susanoo keeps the caster's foot origin.
Chidori and Susanoo are re-exported from the original SWFs at 1.7 zoom; the
largest shipped Chidori source layer is 1150px wide instead of 807px (the
1400px trial exceeded the streaming budget at x2). All layers retain
uniform scaling capped at 1.55 output pixels per source pixel at native stage
size. Susanoo's supplied 11-frame aura repeats through its 41-frame action.
The higher-resolution set retains lossless trimmed pages and prefetches a
40-frame window to cover x2 decoding. Frame surfaces are cleared
and updated under BitmapData lock/unlock before presenting the next frame.
`compare-presentation.py` combines real Flash captures from the preceding and
new component tests into `validation/presentation-before-after.jpg`.
The final set contains 53 compact pages (159 before trimming), with 64.46%
less decoded atlas area and 69.24% less frame copy area than the untrimmed HD
set. `validation/presentation-x2/result.json` records 18 completed casts,
34 effect layers, zero missing frames, zero residual layers and no errors.

Release 2026102130 makes both HP-dependent Chidori standards melee. The server
profile marks their delivery as melee; `build.py` translates that into the
existing native `runPoint` at frame 0 and `backPoint` at frame 64. TRole's normal
movement approaches the enemy field by a 100px contact offset in 200ms divided
by playback rate; first damage occurs at frame 6 (240ms divided by that rate).
All five hits finish by frame 56, before the 200ms retreat at frame 64. The
86-frame action has enough time to finish returning before its idle reset.
Physical ATK/DEF, AOE combo targets and Mystery cooldown rules remain configured
as before. No application bytecode or shared movement routine is changed.
The Sasuke backend test reads the actual packed BaseHero table to check these
movement points against both server standards and their damage frames.

Release 2026102131 fixes a native white flash card incorrectly rendered as a
world-space rectangle over Kirin. `clean_kirin.py` clears only bitmap 677 in
Kirin and bitmap 705 in Blaze Kirin in generated SWF copies; all other source
tags remain identical. The extracted flash timing becomes a stage-sized vector
cue, smoothed and capped at 12% alpha. Lightning and impact artwork is preserved.
Both fire variants export their core at 0.65 zoom (1193px wide), with a 1280px
display width instead of 680px. Scaling is limited by the sharp core instead of
the soft smoke envelope; smoke stays below 1024px per cell to avoid the 4x page
count jump across the 2048px atlas packing threshold. Compact assets use the
separate `compact-v6` namespace: 63 pages, 61.51% less decoded area than untrimmed
HD pages, and 66.38% less frame-copy area. `verify-kirin.py` audits the exact
source tag changes, flash timing/alpha and core raster magnification.
`validation/kirin-fire-x2/result.json` records 18 completed casts across both
camps, no missing frames, no remaining effect layers and no errors. Captures
include each Kirin impact and four fire phases. `compare-kirin-fire.py` creates
`validation/kirin-fire-before-after.jpg` from old/new Flash component captures.

Build in this order (FFDec path is configured in the build tools):

```powershell
python sunucu-kok/cikarim/sasuke-shinden/prepare-vfx.py --ffdec <ffdec.jar>
python sunucu-kok/cikarim/sasuke-shinden/optimize-vfx.py
python sunucu-kok/cikarim/sasuke-shinden/prepare-streaming.py
python sunucu-kok/cikarim/sasuke-shinden/prepare-assets.py
python sunucu-kok/cikarim/sasuke-shinden/build.py --apply
python sunucu-kok/cikarim/sasuke-shinden/build-fragments.py --apply
python sunucu-kok/cikarim/sasuke-shinden/build-client.py
python sunucu-kok/cikarim/sasuke-shinden/release.py
python sunucu-kok/cikarim/sasuke-shinden/verify.py
python sunucu-kok/cikarim/sasuke-shinden/verify-compact.py
python sunucu-kok/cikarim/sasuke-shinden/verify-bootstrap.py
node sunucu-kok/sunucu/tests/sasuke-combat.test.js
```

`build-probe.py` and `runtime-raster.js` run an isolated Flash component preview:
18 casts, both camps, x2 playback, screenshots, HTTP error detection and cleanup
count. It uses no player account/save. This is a component probe, not a complete
interactive game session or a claim of zero lag on every device.

Compact release validation: `validation/compact-x1/result.json` and
`validation/compact-x2/result.json` each report 18 completed casts, 34 effect
layers, zero missing frames, zero remaining layers and no errors. The persisted
PNG comparison reconstructs all 818 unique VFX frames exactly; actor verification
checks 1810 packed frames. `build-pixel-probe.py` additionally checks Flash's PNG
decoder against the compressed ARGB path on every page in the current manifest.
