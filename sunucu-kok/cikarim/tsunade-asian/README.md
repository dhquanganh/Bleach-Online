# Tsunade [Asian Style]

Hero `11120992`, SSS (quality 7), unrestricted formation positions. Modify
Fragment `14130992`, native inventory icon `16228144`, summon `11120993`.
The existing overlay excludes the entire reserved Naruto ID range, so neither
Tsunade nor her summons are sold there. The main admin grant tools can grant
the hero and fragment by ID. No player account is auto-granted anything.

Tags: Water, Asian Style, Female, Konoha, Kage, Senju Clan, Secret Jutsu User,
Allied Shinobi Forces. Both own-hero and other-player profiles show these tags.

## Combat

`sunucu/tsunade-asian.json` is the source of truth. `tsunade-combat.js` owns
the character's state, avoiding shared animation state or unrelated hero IDs.

- Acid Shot: prompt, up to seven enemies, Chakra 20, cooldown 2, entry 0;
  Suppress Immunity through next round, Corrosion II for the round, Melt II
  through next round. All four damage hits share the cast's total coefficient.
- Healing Jutsu: 3–5 allies, 15% current Physical DEF, remove one Debuff; after
  Reserve Seal, 7–9 allies. Heal candidates prioritize missing HP.
- Reserve Seal: Debuff immunity subject to Suppress Immunity; physical hits
  have 45% chance of Chaos/Weakness, increased to 75% after revival. First
  defeat revives at 100% HP once; no second revival, including both camps.
  Existing Itachi revival prevention is respected.
- Legendary Sannin reads numeric Konoha tag `1`, from unit tags or the hero
  database. Extra Standard grants from Hashirama/Obito/Mecha enter the same
  hook; Tsunade receives at most three extra Standards per round. The first
  Mystery damage to each other living Konoha ally each round cannot kill it
  while Tsunade is alive. Unknown/untagged heroes do not receive this aura.
- Giant Healing: at the end of rounds 1–3 before revival, heal up to nine
  allies for 25% current Physical DEF, cleanse all Debuffs and dispel her Ignition.
  After revival, this is an allied-target Mystery instead, sharing Acid's
  Chakra cost and cooldown. The automatic battle AI chooses the healing
  variant when a living ally is below 75% HP; an explicit target-camp field
  overrides this choice. This project's combat is report simulation rather
  than an interactive Naruto-style target selection UI.
- After revival, before each Mystery, summon/refresh three Small Katsuyu
  with 15% Tsunade max HP. Their separate reserved slots start at zero HP,
  become visible via native HP restoration records, heal a random ally on
  Standard/fatal damage, and restore that camp's Chakra Limit to 100. Up to
  three available formation slots are used; a full lineup cannot spawn extra
  physical slots. Fatal heal is latched until that summon is refreshed.
- Corrosion shreds the affected attacker's Physical DEF/Resistance by 3%
  per damage event for the round. Melt blocks that unit's additional skill
  Chakra gains, allowing round/attacked gains; attacking a Melt target grants
  non-stacking +30% critical rate for the round. Weakness sets attacks to
  75% base stats. Healing/cleansing can remove these debuffs.

All damage uses buffed Physical ATK and Physical DEF. Healing intentionally
uses Tsunade's current Physical DEF including buffs/debuffs. Revival HP and summoned Katsuyu HP remain max-HP based. The screenshot
omits Acid's coefficient and Small Katsuyu's healing amount: configured
values are 1.8 total physical damage and 15% current Physical DEF respectively.
These local coefficients are explicit tuning, not verified original values.

## Original art and playback

Source: `asset/Tsunade_Asian_Style_Full`, actor `11002371.swf`. Actor actions
retain source pivots, aspect ratio and timing, resampled from 24 to 25 fps.
There are 697 rendered source actor frames, eight original effect layers,
and 80 lossless atlas pages of at most 2048 pixels, with deduplicated cells.
Runtime ARGB payload is about 38 MB compressed, loaded by page with bounded
cache/lookahead using the existing Mecha playback design. No JPEG asset
conversion, frame removal or synthetic replacement of the choreography.
Native probe screenshots are JPEG review artifacts only.

Small Katsuyu now uses the dedicated original actor `19004611.swf` from
`asset/Tsunade_Asian_Style_Full/Katsuyu_Tsunade_Asian_Style`, replacing the
previous lower-layer substitute. Six source actions cover idle, healing,
entry, death, hit and run. Actor scaling is uniformly 1.5 with source pivots
retained; 24 fps source frames are resampled to 25 fps. The healing action
ends with an explicit idle return frame whose index matches `backPoint`.
The original `hphuifu.swf` supplies native healing effect `13622609`, emitted
on the healed ninja for both Standard and fatal-damage healing. Source sprite layers preserve their
compositing order. The actor uses six independent action mappings; death
recovery cancels death tweens/callbacks and restores bitmap, shader, HP bar,
buff layer, alpha, visibility and idle pose before playing Reserve Seal.

The `rongjie.swf` ancillary asset uses a different container format and is
not exported by the sprite-atlas tool; Melt/Corrosion use native status text.
All six actor skills and the source Acid/Healing/Reserve Seal VFX are present.

## Build and validation

Build order: `prepare-vfx.py --ffdec .tools/ffdec/ffdec.jar`, `page-vfx.py`,
`prepare-streaming.py`, `prepare-assets.py`, `build.py --apply`,
`build-fragments.py --apply`, `build-client.py`, shared `character-tags/build.py`,
then `release.py`. Do not reapply an older character client over later shared
client changes; builders retain input backups and check unrelated methods.

Data release `2026102419` includes fresh resource URLs for native tables
and the new textures, as well as the bootstrap, client and tag metadata.
Restart the backend and reload the game after installation.

Client `2026102420` makes the Acid Shot portrait (`gangshou_aoyi1_niansuantexie`)
a stage-sized cutscene. Its portrait strip spans the viewport width with
uniform scaling, a black backdrop and clipping of outer ink to the viewport.
The text remains readable in both camps. The viewport removes itself when
the effect ends and detaches its listeners when removed from the stage.
`fullscreen.py` applies this incremental change to the current shared client;
`fullscreen.as.txt` is also included by the original client builder. All 170
other role methods, including the death/revival recovery, are preserved.
Combat and Physical DEF healing are unchanged. The isolated fullscreen
probe and captures are in `fullscreen/validation/native`.

Client/data release `2026102421` installs the dedicated Small Katsuyu actor,
healing VFX and actor-scoped entry/death playback. `katsuyu.py` builds the
original actor/effect textures and updates only the summon animation timing;
the main hero builder also uses these textures. `katsuyu-client.py` adds
entry/death playback, cancels old callbacks on respawn/reset/removal, and
preserves 167 other role methods. `katsuyu-release.py` publishes fresh native
resource URLs without reverting the fullscreen cutscene or Physical DEF heal.

`katsuyu-probe.py` plus `katsuyu/runtime-raster.js` exercise three summons in
each camp using native texture decoding and the production pose methods.
All six complete entry, idle, heal, hit, death and respawn, including respawn
during death and removal/re-add. Six death callbacks run exactly once; stale
callbacks and remaining pose listeners are zero. The probe reports no errors
or missing frames. Captures/results: `katsuyu/validation/native`. Both Tsunade
combat suites also pass after the asset replacement. Reload the game to load
the new client and textures; no healing coefficients or battle rules changed.

## Allied HP / black cutscene repair (`2026102422`)

The earlier combat and actor probes missed a client playback defect: support
actions had HP changes in server reports but lacked native `friendhp` events.
Allied HP therefore was not applied by the actor's frame dispatcher. The fix
adds one 100% allied-health event at a valid source frame for Healing Jutsu,
both Giant Healing variants, Reserve Seal, summoning and Small Katsuyu's
Standard. Damage-only append effects are removed from support actions; Acid
Shot retains its four original damage hits. Both hero builders preserve this
metadata. Heal formulas remain based on Physical DEF.

The full-screen portrait previously painted an opaque black viewport even
while its bitmap was loading or its source frame was empty. The viewport now
stays transparent outside the original art, retaining its full-screen scale
and clipping. This prevents an absent/empty portrait frame from blacking out
the battle. The cutscene cleanup and Katsuyu lifecycle code are preserved.

`healing-playback.py` updates active native table versions and source hero
records. `healing-playback-probe.py` compiles the original actor's allied HP
dispatch block into an isolated native Flash harness. It reproduces the
missing-HP baseline, then checks six repaired mappings in both camps: 84
assertions, HP applied to self/allies exactly once, no enemy healing, and
`HealthGaining` consumed correctly. This is a dispatch component test with
test role objects, not a full logged-in battle.

Results: `healing-visibility/probe/validation/native`. Portrait captures at
frames 0, 8, 24, 44, 64, 100 and 136 in both camps, including transparent
start/tail frames: `healing-visibility/cutscene/validation/native`.
`tsunade-native-healing.test.js` guards all six support timing mappings.
Reload the game to load the new client and resource-map versions.

Validation:

- `node sunucu-kok/sunucu/tests/tsunade-combat.test.js`: all 15 positions in
  both camps; damage stat independence; cooldowns; healing/cleanse; Konoha
  aura; extra cap; debuffs; three summons; one revival; encoded reports.
- Existing Mecha, Itachi, Hashirama, Pain, Gaara, Sasuke and Obito combat
  regressions pass after the shared hooks.
- `build-probe.py` plus `runtime-raster.js` with bundled Electron and
  `ELECTRON_RUN_AS_NODE` unset: 12 native Flash casts, both camps, two dead-state
  recovery checks, zero reported errors/missing frames, no remaining VFX
  layers. See `validation/native/result.json` and frame captures.
- Original icon copies, native database associations, lossless ARGB streams,
  unrelated SWF tags/methods and resource-map synchronization are checked.

The Flash probe is an isolated rendering component, not a full interactive
logged-in combat session. Runtime death-reset checks exercise production
recovery code with test actor fields and native TweenUtil.

## Combat logic audit

The follow-up audit fixes the following edge cases without changing damage
coefficients, Physical DEF healing, native textures or the fullscreen client:

- Single cleanse removes exactly one active debuff, emits its native removal
  record, and handles timer-based debuffs from other ninjas. Giant cleanse
  removes those timers while preserving positive forms/buffs.
- Both healing skills can select living summoned units. Their target-count
  boundaries remain 3–5 before revival and 7–9 after revival; Giant Healing
  triggers only at the end of rounds 1, 2 and 3 before Reserve Seal.
- Melt grants its non-stacking critical bonus when the attack begins, so the
  triggering hit benefits and a missed attack still grants the buff.
- Konoha protection reaches the final damage resolver, including instant-kill
  procs, and another living Tsunade can protect a Konoha-tagged Tsunade ally.
- Controlled Tsunade keeps pending extra Standards until freed within that
  round; the credits reset at the next round. Generic combo Standard grants
  also notify the Konoha passive.
- Summon slot reservation is idempotent. Only spawned Katsuyu trigger fatal
  healing; DoT and other death paths are covered, with a latch preventing
  duplicate healing. Summoning is limited to actual living Mystery casts.
- Physical DoTs do not proc Reserve Seal's direct-hit retaliation. Chaos
  respects control immunity/shields and does not accumulate duplicate entries.
- Explicit ally/enemy Mystery target selection survives battle initialization.

`tsunade-edge-cases.test.js` covers these cases in both camps, alongside the
existing Tsunade suite. Both Tsunade suites and the Mecha, Itachi, Hashirama,
Pain, Gaara, Sasuke and Obito combat suites pass. Restart the backend to load
the logic fixes; the client remains `2026102420`.
