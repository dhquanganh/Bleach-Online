# Uchiha Obito [Rage Mode] — SSS Vanguard

Hero ID **11120920**, profession **2** (Vanguard), quality **7**, assess **SSS**. The existing character roster loader includes this hero on the next login. Place him in the front row. No save or current formation is modified by installation. Modify Fragment **14130920** is registered for stars/reincarnation and the existing owned-hero Mystic Shop flow.

## Duplicate-body animation fix

The original MME `A_1hit` / `A_2hit` layer at source index 3 and `SP_skill5` layer at index 5 contain an extra standing Obito (asset 0) over the acting body. The exporter now removes only those idle backdrop layers before rendering. Acting poses, wood/effect layers, coordinates, alpha and damage events remain. Both native texture sets are rebuilt. `verify-dedup.py` verifies one body per Standard frame, original hit events and corrected source pixels/pivots; `validation/dedup-before-after.png` shows the comparison. Restart the game to clear loaded model textures; this fix does not require a new client SWF or change combat rules.

All 12 source files from `asset/Extracted_Obito_Rage` are checksum verified. The battle MME SWF is decoded into 483 original character frames and 11 animation clips, preserving layer transforms, alpha and per-frame pivots. The six original VFX SWFs provide 11 separate transparent atlas layers. Both portraits, the large illustration, bag preview and decoded lobby showcase are used by native UI textures/icons. Original files remain available under `/public/obito-vfx/extracted/original/`.

The two native resource sets contain 1,170 verified character frames with exact RGBA/pivots. Animation uses 25 FPS / 40 ms ticks, resampled from the original 24 FPS. Damage is applied once per move at the first original hit marker; repeated source impact events remain visual, avoiding multiplied report damage. Casting poses wait for effect completion. Effects mirror with the camp, retain source origins, preload into a shared cache and remove their listeners/layers when finished or the battle resets. The lobby uses a standing idle pose.

## Larger, aligned VFX and skill recovery

`vfx-layout.json` defines widths and individual body/ground anchors. Horizontal offsets from the Naruto source are replaced by anchors at the target, mirrored for both camps; portal/spear flashes center on the body, dust/wood/rings use ground anchors. Single-target widths: Kamui 340, Roots 660, Rage 540, Chaos 580, Standard 520, Spear 600 world pixels. Multiple-target effects use 82% of these widths to limit overlapping clutter. Source timelines, alpha, sprite deduplication and damage timing remain.

Kamui and enhanced passive Kamui recover for 2 rounds, Roots for 3, both Chase families for 2. Example: Roots at round 2 is next available at round 5. Base/Rage forms share each Chase family recovery. Rage Spear retains two uses within an eligible round; changing form, a new combo chain or team Chase bonuses cannot bypass cooldown. Two Standards per round are preserved. Reload both backend and game for rules, tooltips and client version 2026101821.

## Combat

All damaging Obito moves scale from **Physical ATK**, including Roots, Chaos and Spear in both forms. `attackStat: "atk"` chooses the offensive stat independently of `damageType`, which still determines the target's Defense/Resistance mitigation. Magic ATK does not contribute. Base coefficients remain Standard 110%, Roots 165%, Chaos 115% and Spear 120%; buffs, Rage's Chase bonus and mitigation then apply through the normal combat engine.

## Supplemental power effects — client 2026101822

`power-vfx.as.txt` adds native Flash vector accents over the original extracted raster effects: converging charge wisps, a ground chakra ring, a brief local impact flash, expanding shock rings, cracks, wood fragments and bright sparks. Kamui uses violet spiral arcs; Rage uses red expanding arcs/embers; Wood Style uses amber impacts and brown fragments; Spear/Standards add sharp curved cutting streaks. Supplemental impacts start at the same first source hit frame as damage; charge lasts 560 ms and impacts 820–1250 ms, within the original animation return time. Multiple targets use 72% accent scale. Every layer uses `obitoSkillVfx` and removes its frame/stage listeners when finished or the battle resets. This changes presentation only; Physical ATK scaling, cooldowns and status rules are unchanged.

The component probe records `powerLayers` separately and captures `HIT-*` screenshots at the damage marker as well as cast/impact pictures.

## Standard playback repair

The saved Tower of Gold battle report was checked separately from the animation: Obito already produced two damaging Standards per round. The source A_1hit/A_2hit choreography contains an invisible teleport interval and a fixed horizontal travel offset. Keeping that offset while the caster stays at its formation position makes the strike appear away from the report target. The client repair positions the visible strike beside the actual enemy in both camps, then restores the source idle frame. Both Standard skill IDs are explicitly classified as attacks; a Standard reaching `PlaySkill` is redirected to `PlayAttack` instead of the Kamui sequence-zero fallback. Damage, hit frames, cooldowns, HP costs and Kamui protection remain unchanged.

Run `repair-standard-client.py --ffdec PATH/ffdec.jar --install` against a current client without this repair. It preserves the other client patches and non-code assets, verifies the recompiled methods, backs up the client and publishes a fresh manifest-selected URL. Restart the game to load it; an already open battle retains its loaded client.

- Two Standards per round. Lowest absolute HP target, unavoidable, bypasses defensive skills; base costs 5% max HP. High chance of Knockdown and Kamui Tag.
- Base Kamui is a free-chakra Prompt with a 2-round cooldown, costs 10% max HP, can evade the next attack that round, and protects against defeat by the first five Standard/Chase attacks that round. It does not consume a Standard. HP costs retain at least 1 HP.
- Below 50% HP, once per battle: enter persistent Rage and recover 50% max HP. Includes thresholds reached through direct hits, costs, reflection and round effects. Recovery respects existing healing restrictions.
- Rage removes Standard/Spear HP costs, adds 12% actual-damage Life Steal, one extra Standard per Standard kill, and free enhanced Kamui at eligible round start (2-round cooldown) with guaranteed next evasion. Standard credits remain bounded by the number of kills.
- Rage Mystery hits all enemies, Low Float on the selected target, +40% Chase damage for the round without stacking. Chakra starts at 40, then 20, then 0. Roots has a 3-round cooldown, shared with the base Mystery ready-round so transformation cannot reset recovery.
- Hellish Chaos has a 2-round cooldown and triggers at 20 Combo, hits at most seven and absorbs up to 20 shared chakra per hit enemy, capped by own team pool. Rage first suppresses their immunity through round end.
- Thrusting Spear has a 2-round cooldown and chases Low Float and hits its battlefield line (same position modulo five), Knockdown on the chased target, Immobile on hit enemies for the current round and Kamui Tag until the end of next round. Rage allows twice within an eligible round, with use counts shared across base/Rage transformations and separate combo chains.
- Kamui Tag caps evasion at 35%, reduces Defense/Resistance 15%. Immunity checks and durations use the existing combat system.

The reference does not state damage coefficients, exact "high chance", penetration or base Chase cap. These local values are documented in `sunucu/obito-rage.json`: chances 75%, penetration 30%, base Chase once per round. They can be balanced there without replacing artwork.

## Rebuild

From the repository root, using Python with Pillow and Java with FFDec:

```powershell
python sunucu-kok/cikarim/obito-rage/prepare-vfx.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar"
python sunucu-kok/cikarim/obito-rage/prepare-assets.py
python sunucu-kok/cikarim/obito-rage/build.py --apply
python sunucu-kok/cikarim/ninja-fragments/build.py --apply
python sunucu-kok/cikarim/obito-rage/build-client.py --ffdec "E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar" --install
python sunucu-kok/cikarim/obito-rage/verify-assets.py
node/node.exe --test sunucu-kok/sunucu/tests/obito-combat.test.js
```

The client patch starts from the current client and preserves previous Naruto/Jiraiya/Kabuto/decoder changes. An exact rerun uses the saved pre-Obito client; if another client patch has since changed it, the script refuses a duplicate Obito patch instead of overwriting that work. Backups are under `backups/`. Version URL is **2026101822**.

Close and reopen the backend and game to reload server modules, databases, roster and Flash resource caches.

## Validation

### Readable status text — client 2026101923

`status-text.as.txt` holds each status label for 3.2 real seconds (2.6 seconds fully visible, 0.6 second fade). Labels stack above the affected role without mirroring, follow its position and refresh matching messages. Removal/reset detaches all listeners. The status patch is incremental (`build-status-client.py --ffdec PATH --install`) so it preserves client changes installed after the initial Obito release.

Obito's custom status markers cover Rage, Kamui, Tag II, Suppress Immunity, chakra absorption, Immobile, +40% Chase damage, remaining Roots chakra cost, actual Life Steal HP, extra Standards, Kamui evasion and fatal protection. Obito-origin combo/displacement notices use markers 19000600–19000705 so they also last 3.2 seconds on an enemy. Incoming native buffs/debuffs and their ending notifications use the native BuffEffect name; shield changes and existing special status banners on Obito use the same longer text renderer. Display duration does not change gameplay effect duration.

Run `build-probe.py --status-check --ffdec PATH`, then launch `runtime-raster.js` with `OBITO_STATUS_PROBE=1` and `ELECTRON_RUN_AS_NODE` unset. The isolated Flash test checks five stacked labels at 1.0, 2.4 and 3.0 seconds, then checks they have all disappeared by 3.5 seconds. Evidence is in `validation/status-text/`. Reload backend and game for the extra server notifications and new client.

`validation/assets.json`: exact native RGBA, atlas sizes, pivots, 40 ms timing, idle return and damage/return markers in both resource sets.

`validation/extracted/native/result.json`: actual Flash 22 component playback, **18 cases in both camps, 11 atlases loaded, 34 source asset plays plus 36 supplemental power layers, zero errors, zero remaining VFX layers**. Screenshots cover cast/impact and mirroring. This isolated component probe and the encoded battle-report tests are separate checks; they do not claim a complete interactive client battle was played.

To repeat the isolated probe, compile with `build-probe.py --ffdec PATH`, unset `ELECTRON_RUN_AS_NODE`, then launch `oyun/electron.exe sunucu-kok/cikarim/obito-rage/runtime-raster.js`. Source animation/effect GIFs are in `validation/extracted/`.
