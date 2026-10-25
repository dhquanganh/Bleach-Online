# Naruto [Nine-Tails Chakra]

Client/data release `2026102427`. Hero `11120994`, S+ / quality 5, all 15
formation positions in either camp. Modify Fragment `14130994`, inventory
icon `16228146`, owned-only Mystic fragment offer `41120994`. The admin
overlay excludes the reserved 11120900–11120999 hero range, including this
hero. No account saves are modified.

## Skills

- Tornado Rasengan!: Prompt, 40 Chakra, cooldown 2, battlefield cooldown 1.
  Physical damage to the selected enemy, Repulse and one-round Ignition.
  Successful Repulse also damages living enemies in the immediately
  following formation row. Super Armor/control immunity prevents that
  Repulse splash; no following row means no splash.
- Taijutsu Attack: attacks the front occupied enemy row. A 60% chance
  selects the original three-hit animation, 3 COMBO, Low Float and Ignition.
  Normal attacks have no cooldown and do not share the prompt's action.
- Tailed Beast Coat: direct physical damage against Naruto inflicts
  Ignition on the attacker, respecting Debuff/fire immunity. Physical DoTs,
  reflected/indirect damage and zero-damage hits do not trigger it.
- Tailed Beast Chakra - Wars: before each round's actions, living Naruto
  recovers HP based on his current buffed/debuffed Physical ATK. Naruto is
  immune to Debuffs, subject to the existing Suppress Immunity rules.
- Ignition blocks healing, damages at the end of the current round and
  expires then. It does not use the ordinary start-round DoT tick. It is
  removable through existing cleanse logic and retains the shared buff icon.

All direct, splash and Ignition damage use Physical ATK against Physical
DEF; Magic ATK/Resistance do not affect them. Healing also uses Physical
ATK, as requested. Text follows the supplied screenshot with these physical
stat overrides. The screenshot omits coefficients and numeric chance:
explicit local tuning is Mystery 1.8 ATK, standard 1.0 ATK total, rear-row
splash 0.5 ATK, Ignition 0.3 ATK and healing 20% ATK. These values are not
claimed to be verified original-game coefficients.

Tags: Wind, Male, Konoha, Jinchuriki, Uzumaki Clan, Senjutsu. Original tag
icons/tooltips are embedded for both own-hero and other-player profiles.

## Original assets and isolation

Source: `asset/Naruto_Nine_Tails_Chakra_Full`. The original battle actor
11000131 supplies idle, run, hit, death, all three Taijutsu variants,
SP_skill1 and SP_skill2. The source 24 FPS is sampled at the client's 25 FPS.
The 301 rendered poses retain source pivots and one uniform 1.5 scale.
Original portraits and skill icons supply native hero/skill/item textures.

The source punch effects, Tornado Rasengan/portrait and self-healing effect
are exported into six layers, twelve lossless <=2048px pages. Exact ARGB
streams total about 4.1 MB and use Mecha's prefetched, pinned, bounded cache
runtime, with independent fields/methods and cast cleanup. Source
`dianran.swf` supplies the isolated Ignition effect texture 13622702; its
marker does not alter other characters' existing Ignition visuals.

All actor/skill selectors and formation exceptions check only hero 11120994.
The current client is patched incrementally, preserving 171 other TRole
methods, 27 other TActive methods, 46 other stage methods and both profile
renderers except their embedded tag data. The previous Katsuyu/revival
queue repair and Daily Tasks changes are retained.

## Validation and build

`sunucu/tests/naruto-nine-tails.test.js` covers both camps/all positions,
costs/cooldowns, standard/Prompt independence, row selection, combo chance,
Repulse splash, immunity/retaliation, end-round Ignition, cleanse/heal block,
Physical ATK/DEF independence and actual encoded battle reports. Twelve
related combat/revival regression suites also pass.

`build-probe.py` / `runtime-raster.js` run ten casts in native Flash using
the production paged FX methods and native actor textures. Captures and
results are in `validation/native`: completed, no errors, zero remaining
layers. This is an isolated rendering component, not a logged-in battle.

Build order: `prepare-vfx.py --ffdec .tools/ffdec/ffdec.jar`, `page-vfx.py`,
`prepare-streaming.py`, `prepare-assets.py`, `build.py`,
`build-fragments.py --apply`, `build-client.py`, `build-probe.py`, `release.py`.
`build-client.py` expects its `original` export and `source.swf` from the
current shared client; never replace them with older character backups.
`release.py` refuses repeated publication and verifies the current client
matches that source before installing.

Restart the backend and reopen the game to load new backend modules and
the native client/data release.

## Animation size/alignment correction — 2026102503

All nine exported pose states now use uniform source scale 1.0 rather than
1.5 (33% smaller). Attack root translation is removed from the bitmap pivot;
an eased approach/contact/return tracks the actual first enemy's position
in either camp, with original vertical pose movement and hit timing retained.
This avoids adding the source's long forward translation to an independently
positioned target effect.

Punch impacts play individually on hit frames for each enemy hit. Uppercut
and particles have their own timing; the Rasengan main layer and intro
portrait no longer share a fitted union. Precomputed alpha bounds register
visible impact content at the target instead of letting transparent source
borders shift or shrink it. Healing has its own caster-following aura.
All effect widths/heights preserve aspect ratio.

The isolated main Rasengan export is now 1280x810 rather than 520x329, so
its enlarged display downsamples detailed source pixels. Punch and healing
layers are re-exported at zoom 1.4. The portrait's oversized source bounds
are kept independent from the main Rasengan export. These HD pages use a
fresh `nine-tails-vfx/aligned-hd` namespace, 53 <=2048px pages and about
12.5 MB compressed lossless ARGB, retaining Mecha's prefetch/pin/cache limits.

`repair-alignment.py` patches the current client and verifies 184 unrelated
TRole methods unchanged. `publish-alignment.py` publishes fresh native
texture URLs and preserves the current resource map. The normal client
builder also applies the correction. Pose review: `scale-alignment/all-poses.png`.
The final native component probe covers ten casts across both camps; the
backend combat suite remains unchanged and passes.

## Profile idle and native Rasengan — 2026102504

Partner showcase idle (Model A9B1620E) now uses a fixed 202x201 canvas and
the same pivot for all 34 frames, raised 35 source pixels. The showcase
renderer updates bitmap surfaces while retaining the first frame's pivot;
the former individually cropped battle frames therefore drifted sideways
and down as Naruto's tail changed the crop. Only the showcase texture is
changed; battle idle retains its original registration. `profile-probe.py`
checks every native decoded frame with this renderer policy and captures
the idle cycle above the statistics boundary.

Rasengan uses the original 547 KB Flash SWF's `zlxw` and `lian` symbols,
preserving nested animation, vectors, filters, blending and alpha. It no
longer uses flattened raster effect cells or moving alpha-bound centers.
The source actor root movement and effect origin (70 pixels) share the
same target-distance correction, so the ball follows Naruto's hand during
charge/approach and reaches the hit target. The portrait starts at the
source playFaceEffect event (client frame 31), leaving the charge visible.
Source frames are sampled at the same 24-to-25 FPS mapping as the actor.
Unused raster Rasengan preloading is disabled; native symbol instances
are independent per cast and removed on interruption/removal/end.

`repair-profile-rasengan.py` preserves 184 other TRole methods. Validation:
34 profile frames, ten native casts across both camps, expanded Mystery
captures at frames 3/12/26/34/46/58/62/66/86/95/115, no errors or remaining
layers, and the unchanged backend Naruto combat suite passes. These are
native component checks rather than a logged-in profile/battle session.
The normal asset/client builders retain both corrections.

## Full-width portrait and event spacing — 2026102506

The native `lian` symbol includes distant ink geometry in getBounds(), so
fitting that bound made the visible portrait band small. The viewport now
uses the main opaque band's source rectangle (-112.4, 230.8, 1529.1, 370),
derived from the original rendered reference. Uniform scale fits its width
to the stage width in host coordinates. A transparent stage-sized scroll
rectangle clips overflowing ink while preserving the source aspect ratio.
This affects the portrait only; the hand-aligned Rasengan remains unchanged.

Both Myoboku and Boss move left one 72-pixel slot to clear the native gift
icon. `wide-portrait.py` imports only the native portrait method and lobby
IllusionUpdate, preserving 191 other role methods and 526 other lobby methods.
The normal native-effect template includes the full-width viewport.
