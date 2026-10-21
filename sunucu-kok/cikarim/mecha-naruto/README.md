# Mecha-Naruto SSS

Installed client **2026102009**. Hero `11120950`, quality 7, all 15 formation positions in both camps. Modify Fragment `14130950`, Inventory icon `16228102`, Mystic offer `41120950` (100 gems, shown only after owning Mecha-Naruto). No player saves are changed.

All attack variants and Level 2 Ignition use buffed/debuffed Physical ATK and Physical DEF only. Magic ATK and Resistance do not affect their damage. UI descriptions, server config, native databases and both texture versions agree.

## Combat rules

- Chakra Bomb: prompt, unavoidable, 40 Chakra, cooldown 2, battlefield cooldown 1. All enemies, or up to 9 when own **HP is greater than 60%**. Selected-target Knockdown, Interruption and Mystery recovery locked at 1 through round end. The completed cast permanently activates Tailed Beast Mode.
- Taijutsu Combo: lowest current HP, bypass defensive skills, Suppress Super Armor through round end; high chance of Combo/Repulse. Team Chakra greater than 50 selects Beam at action time, including stolen actions.
- Beam: random occupied line, unavoidable, own Mystery recovery -1, high chance of one-target Repulse and that target's Mystery recovery +1. Team Mysteries cost 20 less Chakra through round end; repeated reductions stack and costs stop at zero.
- Rasengan: chase Knockdown or High Float, Repulse, Suppress Immunity through round end and steal all unspent Standards. Already suppressed targets select Modified Rasengan: unavoidable, 30% Physical DEF penetration, Repulse and Immobile. Both share two Chase charges per round. Lost actions use the existing Sword Crusher budget; completed or already stolen actions cannot be stolen again.
- Advance Technology: debuff immunity; +8 percentage points Critical Rate and +15% Physical ATK per executed action, at most six triggers per round. Growth persists until the battle ends.
- Jet: high chance to evade one ordinary attack each round; 45% Chase evasion. On evasion recover 20 team Chakra and execute Extreme Beam, at most three triggers per round. This works while controlled. Jet is a separate visual transition and does not generate a second Technology stack. Extreme Beam always applies its one-target Repulse/recovery increase. Unavoidable attacks and attacks bypassing defensive skills cannot activate Jet.

The screenshot does not specify damage coefficients, numeric “high chance”, or the amount of penetration. These balance values are explicit in `sunucu/mecha-naruto.json`: 60% high chances, 30% modified penetration, coefficients 1.0 / 1.1 / 1.2 / 1.8. They are implementation choices, not values verified from the video.

## Tailed Beast Mode

The provided transformation matches original form `11015003`; exact skill associations/descriptions are recorded in `tailed-beast-source.json`. A completed base Chakra Bomb replaces the whole base kit for the rest of the battle. Standards, Rasengan, Jet, stolen Standards and Technology triggers stop; earned Attack/Critical buffs remain. The new form has Debuff immunity and Super Armor, and gains stacking +20% Physical ATK for each Trigger skill. Incoming attacks reduce Mystery recovery by 1.

Energy Recovery is the new prompt Mystery: 20 Chakra, cooldown **3**, battlefield cooldown **1**, heal **12% max HP**, Level 2 Super Armor/Advanced Immunity through round end. The transformation starts this new recovery at 3 rounds; received attacks can reduce it. The Mystery additionally executes Chakra Bomb against up to 12 enemies, random Repulse and +30 percentage points Critical Rate. This additional Bomb has no separate Mystery cost/cooldown.

At round start, even rounds trigger unavoidable Claw Strike on the front occupied enemy line, Interruption, random Low Float and Mystery recovery lock at 1 through round end (immunity applies). Odd rounds trigger Tail Sweep on the front occupied enemy row, random Knockdown and 25% physical splash per orthogonal hit neighbor. There is no ordinary Standard in this source form.

Recovery activates permanent Explosive Mode. Physical damage dealers receive one-round Level 2 Ignition during the Advanced window; it blocks healing and its damage uses current Physical ATK/Physical DEF, penetration and common damage modifiers. Advanced Immunity resists it. Damaging enemies receive up to four Inflammation layers while Explosive; a physical action costs 1% max HP per layer. Healing and this explicit percentage-HP loss retain separate formulas. All form flags, stacks and Ignition are cleared for a fresh battle.

New unsupplied damage coefficients are explicit balance settings: Bomb 2.0, Claw 1.4, Sweep 1.3 and Ignition .3; +30% Bomb crit is an explicit choice. Source timings, target/state rules, healing, costs and cooldowns are preserved.

## Animation and resources

The reference [video](https://www.youtube.com/watch?v=k4ybF4nZ8oU) was downloaded and visually inspected. Both supplied battle forms, both map forms and both lobby forms are decoded from the provided SWFs; all sixteen original files have SHA-256 checks. Original Mecha skill effects and skill icons missing from the input bundle are recovered from the local `Naruto_Online_Full_Resources` archive into `asset/Mecha_Naruto/effects` and `icons`.

Thirteen skill IDs select native action sequences. Both HP variants of the base Bomb use the human SP_skill1; SP_skill3 is the transformation. The permanent form uses supplied 11015003 C_idle/C_run1_2/D_stand_behit1 and its four SP actions: SP_skill1 Energy Recovery, SP_skill2 Claw, SP_skill3 Bomb and SP_skill4 Sweep. The client selects the transformed idle, run and hit sequence until battle Reset. Extreme Beam follows Jet's own animation. Native 24 FPS timing is resampled to the client's 25 FPS; damage is divided across the original hit markers, preserving the total coefficient. Root movement is removed from close attacks before one eased approach and return is applied. Mirrored effects share a single transform across their original upper/lower layers. Per-cast guards and battle cleanup remove interrupted effects.

Contact cameras crop distant particle/blur outliers at a fixed source origin; the Rasengan source is re-exported at .85 native zoom before this crop. Beam uses a bright-core anchor. Body registration includes the bitmap asset offset, fixing the Rasengan overshoot. Lower Mystery layers use additive blending over a separate full-viewport dimmer, preventing a cropped dark rectangle. Character bounds are fitted inside the viewport in both camps.

Effect output uses lossless RGBA pages with fixed source crops/pivots, up to 1280x900 cells and 2048px atlas pages. Small pages reduce impact-time decode stalls. The first page of each used source layer stays cached; subsequent pages use the existing per-character prefetch and memory budget. No generated replacement drawings are used.

Build: `prepare-vfx.py --ffdec JAR`, `refine-vfx.py --ffdec JAR`, `prepare-beast-vfx.py --ffdec JAR`, `page-vfx.py`, `prepare-assets.py`, `build.py --apply`, `build-fragments.py --apply`, `build-client.py --ffdec JAR --install`.

Checks: `node --test sunucu-kok/sunucu/tests/mecha-combat.test.js` and `python sunucu-kok/cikarim/mecha-naruto/verify-assets.py`. The combat test covers both camps/all 15 slots, pre-spend thresholds, expiry, growth, physical scaling, suppression, shared Chase limits/Standard theft, controlled Jet and actual encoded AI reports. Existing physical-scaling, Hashirama, reactive-Mystery and zero-non-Mystery-cooldown regressions also pass. `build-probe.py` / `runtime-raster.js` exercise the production animation methods in isolated native Flash; this is a component preview, not a complete interactive battle replay.

Native Flash evidence is recorded in `validation/native/result.json`, screenshots and `validation/summary.json`. The permanent-mode regression is `sunucu/tests/mecha-tailed-beast.test.js`; it includes actual encoded reports proving one transformation, replacement of all base actions, both round triggers and Recovery/Bomb chaining in both camps.

Final installed checks (2026102003): eight combat suites pass; native Flash completed 26 casts, 34 VFX layer plays and 78 snapshots in both camps, with no errors and zero remaining layers. The compiled client and version manifest match; native idle/run/hit selectors retain the mode until battle Reset.

## Lossless runtime optimization (2026102004)

`optimize-runtime.py` is applied by the client builder. The large Mecha manifest is parsed once per client instead of once per call, including cache eviction scans. First-page membership uses a precomputed map; each timeline frame has a precomputed next-page lookup with exactly the original prefetch behavior. PNG cell extraction reuses its Rectangle/Point and immediately disposes only the source atlas after independent frame copies are complete. The existing cache size, source images, smoothing, masks, pivots, scale, frame selection, 40ms timing and skill logic are unchanged. Subsequent first use can still incur PNG loading/decoding; this change does not claim a measured FPS increase on every machine.

Validation for 2026102004: installed SWF matches the compiled output and version alias; original non-ABC tags and unrelated private methods pass the builder checks. Native Flash completed all 26 casts / 34 VFX layers / 78 snapshots with no errors or remaining layers. Full VFX manifest equality and all 1,406 next-page selections match the previous implementation. Atlas load counts are not an FPS benchmark.

## Explosion flicker and stalls (2026102007)

Late atlas pages previously hid the entire visible explosion layer. Cache eviction also discarded needed pages, while permanent first-page pins used about 34 million of the 40 million pixel budget. The new runtime retains the last complete image on a late page and catches up to the native frame index without restarting, shifting or extending the skill. It pins the active 21-frame look-ahead window, keeps only Bomb openings/small Jet layers permanently warm, preloads five opening frames, prioritizes queued requests by deadline and cancels stale queued pages. Six binary requests can overlap network wait. Active windows can temporarily exceed the LRU budget; eviction disposes unpinned atlases explicitly.

Each effect layer reuses one exact-size BitmapData, copying the selected original cell only when its frame changes. Atlas completion no longer allocates/copies an entire array of frame images. `prepare-streaming.py` (Pillow + NumPy) creates zlib-compressed `.argb` pages beside the original PNGs. It compensates Flash 22 PNG alpha premultiplication so `setPixels` produces exactly the same native BitmapData. No PNG, native actor texture, mask, smoothing, blending, placement, scale, skill timing, cooldown or combat formula is changed.

Validation: `verify-streaming.py` verifies all 279 source and binary checksums. `build-pixel-probe.py` / `MECHA_PIXEL_PROBE=1` compares every complete atlas in native Flash: **279 pixel-identical results**, including alpha. The production animation dispatch, effect transforms, approach/return, fitting and backdrop methods are identical to 2026102004. `MECHA_STREAM_PROBE=1` completed **26 casts, 34 effect layers, 78 snapshots**, no errors or residual layers. Missing-page callbacks fell from **413 to 127** in the component sample; late pages hold the last image instead of hiding it. This is not an FPS benchmark or a complete battle replay; slow first loads may still briefly hold a frame. Evidence: `validation/stress`, `validation/streaming`, `validation/pixels`, `validation/summary.json`.

Rebuild streaming pages after any PNG changes, then run `build-client.py --ffdec JAR --install`; the builder rejects missing or stale streams. The server serves `.argb` as binary without requiring an HTTP server change.

## Persistent-form size (2026102008)

Follow-up 2026102105: giant Bomb/Claw/Sweep source scale is now 0.75 (25% larger
than 0.6), with lossless native atlas packing and fresh model URLs. Persistent
poses remain 1.0. See `../animation-size-repair/README.md` for the isolated repair
and preservation checks against Itachi.

The 0.6 arena scale intended for giant Kurama attacks also reduced the Naruto-sized persistent form. `prepare-assets.py` now uses native 1.0 scale for beast idle, run, hit and Energy Recovery, making these poses about 67% larger. Giant Bomb/Claw/Sweep frames retain 0.6. Registration comes from the original source at the same scale; frame IDs, loop/duration, hit timing and effects are unchanged. Existing skill return frames reference the corrected idle automatically.

121 unique small-form frames changed. All other actor frames are byte-identical to the previous output; animation clip metadata/IDs are unchanged. Both native texture sets are installed. `build-probe.py --idle-only` with `MECHA_IDLE_PROBE=1` exercises base idle and all four small-form poses in both camps: five snapshots, no errors. Evidence: `validation/idle-size-check.json`, `idle-size-comparison.jpg`, `idle-native/`. The asset-only release uses `publish-models.py`; installed Flash code and the explosion streaming fix are unchanged.

## Energy Recovery missing animation effect (2026102009)

Original `SkillAction.xml` binds 21015017 / SP_skill1 to effect 6077, `Jijiamingren_ji_aoyi.swf` (xia + shang). Those two existing source layers were exported and verified but omitted from the Recovery action. They are now bound to the caster ground origin with a shared transform and 650 reference-unit visual bound, preventing enemy-centroid placement or the offensive skill's 85-unit upward offset. The actor's native SP_skill1, corrected persistent-form size, frame timing, healing, cooldown 3 and follow-up Bomb are retained. `recovery-source.json` records the original associations; `verify-assets.py` checks them to prevent another empty effect list.

`build-probe.py --recovery-only`, `MECHA_RECOVERY_PROBE=1`: 4 casts (Recovery + follow-up Bomb in both camps), 8 VFX layers, 12 snapshots, zero errors/residual layers. Evidence: `validation/recovery-native`. The permanent-form combat regression also passes, including 12% heal, cooldown and encoded Recovery/Bomb scheduling. Existing lossless streaming pages are reused.
