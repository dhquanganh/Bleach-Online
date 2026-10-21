# Pain - Tendo [Six Paths Rinnegan]

Follow-up 2026102105: Six-in-one uses a 1250-unit footprint, preserving its source
images and timing. Other Pain skills and all Itachi methods are unchanged. See
`../animation-size-repair/README.md` for native component and isolation checks.

Latest client: **2026101974** (source-detail paged VFX, viewport sizing and bounded streaming cache).

All eleven VFX layers have been rebuilt from native source PNGs, using fresh .7-zoom SWF exports for the revival, Almighty Push, laser beam, standard and Chase. Output reaches 1024x768 without upscaling source pixels. Atlas pages stay within 2048px; playback prefetches the next page and bounds each ninja's cache to 40 million pixels. Every Pain layer is tied to the active cast serial and character frame, including at x2 battle speed. Size/position conversion uses the battle viewport rather than a scaled actor container. Mystery/standard/Chase/revival visual footprints are enlarged; combat timings and cooldown rules are unchanged. Use `../upgrade-ninja-vfx.py --export --ffdec JAR`, `../upgrade-ninja-vfx.py`, then `../upgrade-vfx-client.py --ffdec JAR --install`; verify with `../verify-vfx-quality.py` and the full native component probe.

Chakra Rod now uses a 1000-unit battle-stage footprint rather than 600 actor-parent
units, and its source character art renders at 1.05 instead of .85. This avoids
an extra reduction under scaled actor containers. Its approach updates each tick,
including repeated native surfaces, and its raster timeline follows actor frames.
A cast generation guard removes an interrupted Rod before another starts. The
pre-Hashirama/current Pain method comparison was byte-identical; the repair changes
the existing footprint and synchronization explicitly. Laser, Final idle, revival
and Almighty Push flight remain intact. Native validation: six motion cases in
both camps, 10 raster plays, 11 atlases, zero runtime errors or leftover layers.

Extreme, Final and Super Push now update their airborne position every tick,
including repeated source images. The feet follow a smooth ascent, a gentle hover,
and a smooth descent, keeping pose-height changes from snapping the body vertically.
Damage frame 78 and return frame 170 are unchanged. Final idle remains selected
after revival. `update-flight.py` patches the current live client while preserving
Laser, Obito and Tower changes. `build-probe.py --flight-check` exercises all three
skills in both camps using the native bitmap-change gate; `verify-flight.py` checks
logged foot positions, ascent/hover/descent speed, grounded return and effect cleanup.

Shurado Laser now damages every living enemy combat unit in all rows, including
middle/back-only formations. It grants one Technique Point per cast and removes
up to 10 Chakra per hit enemy from the shared pool without going negative. The
2-round recovery and Physical ATK scaling remain in effect. `pain-laser.test.js`
checks all 15 target slots in both camps and the actual encoded round-start report.

The original beam remains anchored to Shurado's mouth and points toward the enemy
formation. Width is now at least 1500 and height at least 850 stage units, extending
to the farthest victim and widening for the actual target bounds. A cyan/white
shockwave covers the formation at the source damage marker (1960 ms), then fades
within 1200 ms. Both raster and vector layers use the existing battle cleanup.
`build-probe.py --laser-check` previews five opponents spread across rows in both
camps and recursively checks that effect layers are removed. `update-laser.py`
patches the live role methods, preserving the later Tower rewards UI, Final idle,
revival fixes and Obito. Use this incremental builder for the current live client.

Final form now loops the open-coat, extended-hand standing pose from source
`SP_skill7` frame 23 onward. Battle idle texture `0a` contains separate base and
Final sequences; lobby/map/base standing textures retain `C_idle`. The native
idle selector uses the Final sequence after resurrection and after subsequent
actions. Pool reset clears the form before a new battle. Revival/Super ending
frames and Final Mystery's return frame also use this pose to avoid a flash of
the base idle. The original source assets remain unchanged.

## Resurrection visibility correction

The old `ChangeHP` revival branch supported earlier heroes but omitted Pain. A
positive HP record left `FIsDie`, the death fade and pending death flags intact,
so the native client skipped the resurrection animation or faded the actor out.
Pain now updates HP first, cancels role/bitmap death tweens, clears death/control
render flags and stale death callbacks, restores visibility/alpha/HUD/idle position,
and installs an actual idle bitmap before the next animation tick. Ordinary healing
of a living Pain continues through the normal path. Both revival forms use the fix.

The original full-screen Extreme/Super cinematic also contained 113 transparent
actor frames. The local renderer now holds the last visible airborne pose for
these frames and bounds its vertical pivot to 230, retaining a visible actor while
the original cinematic effects play. Source SWFs remain untouched; this is a local
playback adaptation. Timing, damage markers and return-to-idle frames are unchanged.

Rebuild with `prepare-assets.py`, `build.py --apply`, then `build-client.py --install`
as below. `build-probe.py --revival-check` copies the production HP/recovery methods
and loads the installed native textures into Flash 22. It checks 12 cases spanning
both camps, both revival forms and Super Push, including a queued death and active
death tweens, then verifies visibility again after 1.2 seconds. Run it through
`runtime-raster.js` with `PAIN_REVIVAL_PROBE=1`; evidence goes to
`validation/revival-final`. `verify-revival.py` checks the compiled client and these
runtime results. This is a component lifecycle check plus separate encoded combat
tests, not a claim of a manually played full battle.

Hero **11120930**, SSS / quality 7, **Assaulter (profession 1), middle row**.
Modify Fragment: **14130930**. Existing account ownership and formation are not
changed by installation. The character is available to the existing roster/admin
recruitment flow; the Mystic fragment offer appears when the account owns Pain.

The supplied screenshot is the rules reference. The video reference is
[Naruto Online - Pain Tendo Six Paths Still Online in 2026?!](https://www.youtube.com/watch?v=Kw2WtDyBaP8).
The video was downloaded locally and inspected as a timestamped contact sheet.
Local source `SkillCFG` entries 21006551–21006558 and 21006567 corroborate the
screenshot; newer Divinity variants in those files are deliberately not substituted
for the requested skill set.

## Combat rules

All damaging moves scale exclusively from **Physical ATK**, including Laser,
Final and Super Push. `attackStat: "atk"` selects the offensive stat independently
of the target mitigation selected by `damageType`. Magic ATK no longer contributes
to damage. Existing multipliers remain: Standard 100%, base Push 150%, Extreme /
Final / Super Push 180%, Rod Strike 120% and Laser 110%. Technique Points, Attack
growth and ATK buffs/debuffs affect damage through the normal Physical ATK path.

| Skill/form | Implemented behavior |
| --- | --- |
| Tendo - Almighty Push | Prompt; 20 Chakra, 1 Technique Point, cooldown 2, battlefield cooldown 0. Up to 7 enemies, Interruption; selected target gets Horror II and stackable Mystery cost +20 through round end. |
| Extreme - Almighty Push | Selected strictly below 60% HP. 20 Chakra, all Technique Points, cooldown 3. All enemies, 5 Combo, Interruption; selected target gets Repulse, Horror II and stackable cost +20 through round end. Actual-damage Life Steal 7%. |
| Six-in-one | Up to 6 enemies, 4 Combo, Mystery cooldown reduced by 1, Technique Point +1. |
| Chakra Rod Strike | Cooldown 2 rounds. Chase Repulse/Knockdown; Knockdown, Chakra Disruption II, Pain II, Chakra Limit 20 through round end. Orthogonal neighboring grids receive 30% splash damage. Unavoidable; configurable partial defense/resistance penetration. |
| Outer Path | Cap 5 Technique Points, including half points. Attack/Ninjutsu +12% per point. Incoming attacks grant .5 point, including dodged/shielded attacks. First defeat: revive at 100% HP and replace the entire skill set with the two Final skills. |
| The One called God | Each damage event increases Attack by 12%; critical hits inflict Chakra Disruption II. Cancel non-Level-2 debuffs and gain Initiative +2%, capped at 5 stacks. |
| Shurado - Laser Canon | At round start in base form when ready (cooldown 2): hit every enemy in all rows, remove 10 Chakra per hit, gain 1 Technique Point. Immune to Interruption and allied Rinnegan Mysteries become unavoidable for that round. |
| Final - Almighty Push | 2 Technique Points, 0 Chakra, cooldown 2 (up to two casts in an eligible round), battlefield cooldown 0. Unavoidable damage to all enemies, 5 Combo, Interruption. Selected target: Repulse, Horror II, cost +20 through round end. |
| Final - The One called God | Super Armor, debuff immunity, at most 2 Mysteries/round. Attack/Ninjutsu +20% per point; incoming attacks grant 1 point. Critical hits add target Mystery cost +20. Once, if another allied ninja is already defeated when Pain falls: revive at 40% HP and trigger Super Push. |
| Super - Almighty Push | Trigger after Final revival: unavoidable damage, 5 Combo and Interruption to all enemies; all hit enemies gain stackable Mystery cost +20 through round end. No Chakra/Technique Point payment. |

Horror II (Fear) blocks Standards and external buffs, stat increases and shields.
It ends at the end of the next round or immediately when its victim executes a
Mystery. It does not prevent that Mystery or Chases. Chakra Disruption II reduces
Attack/Ninjutsu by 10% for each living opposing Rinnegan ninja through next-round
end. Pain II suppresses Defense/Resistance to 75% of base and removes 10% current
HP before each Standard, through next-round end. The common engine uses one Chakra
pool/limit per camp. Surcharges also apply to ordinary Bleach Mysteries.

Cooldowns follow the latest requested revision below; other explicit screenshot values are authoritative. The image omits damage
coefficients, exact Chase penetration and a per-round Chase cap; these local values
are configurable in `sunucu/pain-tendo.json`. Damage-triggered Attack growth is
additive per damaged target, with Technique scaling as a separate multiplier.
Final critical-hit cost increases use the same current-round lifetime as its
Mystery cost effect. These choices are documented rather than claimed as values
shown by the reference.

## Original artwork and playback

All eight supplied files retain their original SHA256 values. The battle, lobby
and outdoor MME assets are decoded. Repeated incomplete asset references in the
source XML are normalized without deleting any acting layers. The build preserves
770 decoded frames in 12 clips, resampled from 24 to 25 FPS with original alpha and
per-frame pivots. Both native resource sets contain 1772 verified frame entries.
Damage is committed once at the first source hit marker; later source hit markers
remain visual, preventing duplicate damage.

The supplied folder initially had character assets only. Six original effect SWFs
and six skill icons were recovered from the same local resource collection named
in its README, using the original SkillAction/Effect mappings:

- `PEpugong1`: Six-in-one.
- `PEzhuida`: Chakra Rod Strike.
- `PEaoyi1`: base Almighty Push.
- `PEaoyi2`: Laser Canon.
- `Peienchaoshenshenluotianzheng_aoyi`: Extreme/Final/Super Push, including cut-in.
- `DASHEWAN_tongyongfuhuo`: the source revival effect mapped to Pain's passive.

They are retained under `asset/Pain_Tendo_Six_Paths_Rinnegan`; additional checksums
are in `effects-manifest.json`. The original 8-file manifest is unchanged. Effects
use 11 transparent atlases, shared caches, per-layer pivots, camp mirroring and
listener cleanup. Dark screen masks fill the screen; energy layers use additive
blending to preserve the original light effects without rectangular black mattes.
Laser energy renders above its dimmer; body/Chase poses anchor to the actual report
target. Original idle returns after every non-looping sequence.

The native client selects the exact animation for each of the 9 skill IDs, displays
Technique Points, marks Final form, and holds status text for 3.2 seconds. Existing
Obito, Arena, rank and other client patches are preserved. Final cache version:
**2026101946**.

## Validation and rebuild

```powershell
python sunucu-kok/cikarim/pain-tendo/prepare-vfx.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar"
python sunucu-kok/cikarim/pain-tendo/prepare-assets.py
python sunucu-kok/cikarim/pain-tendo/build.py --apply
python sunucu-kok/cikarim/pain-tendo/build-fragments.py --apply
python sunucu-kok/cikarim/pain-tendo/build-client.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar" --install
python sunucu-kok/cikarim/pain-tendo/verify-assets.py
.\node\node.exe sunucu-kok/sunucu/tests/pain-combat.test.js
```

`validation/assets.json` verifies exact installed RGBA, pivots, atlas limits, 40ms
timing, idle returns and single damage markers. Combat tests cover both camps, all
reference tables, both revivals, final skill loss, generic Mystery costs and native
report encoding. Healing precedes resurrection animation in the report so Flash
can clear the old death state first. Obito, generic hero skills, rank, Arena rewards
and retired-character regression suites also pass.

`build-probe.py` and `runtime-raster.js` exercise the installed textures and copied
production VFX methods in isolated Flash 22, without accessing accounts. The full
probe covers 18 cases, 11 atlases and 36 effect plays in both camps with no errors.
The final laser-only check is in `validation/laser-final`; full playback evidence is
in `validation/native`. This component test is separate from encoded combat tests;
it does not claim a complete interactive battle has been manually played.

## Cooldown and animation revision (2026-10-19)

Requested cooldown overrides: Almighty Push 2 rounds, Extreme 3, Final 2,
Chakra Rod Strike 2, Shurado Laser 2. Standard remains once per round and reduces
Mystery recovery by one. Final can cast twice in an eligible round; the next round
is locked. HP thresholds and revival retain active Mystery recovery. Laser starts
ready and consumes recovery only when executed. Revival/Super remain once-per-battle
conditional triggers, not repeatable skills. These cooldowns intentionally replace
the reference image's zero cooldowns and every-round Laser.

Client 2026101948 eases the attack anchor toward the enemy and back while preserving
source jump heights and stabilizing the horizontal strike anchor. Rod Strike centers its VFX on the primary victim rather than
the splash average; Six-in-one uses a tighter, raised effect footprint. Damage
markers remain unchanged.

Final anchor revision was checked in `validation/motion-final`: six cases across
both camps (Almighty Push, Six-in-one, Rod Strike), 10 layer plays, 11 loaded atlases,
no runtime errors. The earlier full 18-case run is in `validation/native`. Installed
client/cache version 2026101948 was verified byte-for-byte.

## Laser direction correction (client 2026101949)

The original beam source emits toward +X from the bright core. The old runtime
flipped it and anchored it on the victim, making the blast appear to fire back
toward Pain. Laser now anchors at Shurado's mouth (source local 330, -65), converts
both muzzle and enemy aim into battle-stage coordinates, and uses their vector for
rotation and reach. The core pivot is (0.25, 0.60); no role-facing flip is applied
to the beam. This also handles targets at different heights and parent scaling.
Same-camp results are excluded when finding attack targets. If no enemy attack
result exists, the beam is omitted rather than aimed at the caster.

Laser verification: `validation/laser-final` contains two successful Flash cases,
four effect-layer plays, 11 loaded atlases, no errors. Both directions were visually
inspected and the logged source-to-target vectors checked with scaled/translated
role containers and unequal row heights. Pain combat/cooldown tests still pass.

Multi-hit combat (2026101971): every damaging skill now has 4 or 5 timed impacts. See [shared multi-hit implementation](../ninja-multihit.md). Revival, Forest and Chakra Burst remain support actions.


Physical damage rule: every damaging move, including talent-triggered and splash attacks, uses Physical ATK and Physical DEF only (`attackStat: atk`, `damageType: physical`). Resistance and Magic ATK do not affect attack damage. Dedicated HP costs, healing and percentage-HP loss retain their separate formulas.

Camera shake is disabled in client 2026101974, including cast-lifetime and short impact/critical shake. Physical damage rules, multihit and skill animation remain.
