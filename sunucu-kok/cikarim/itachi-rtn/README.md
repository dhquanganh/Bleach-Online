# Itachi Uchiha [Road to Ninja]

Installed hero `11120960`, talent `13220960`, Modify Fragment `14130960`.
SSS (quality 7), unrestricted formation positions. The overlay hero shop excludes
the reserved Naruto ID range, including this hero. The main admin Add Hero/Item
tools can grant the hero or fragment by ID; no player accounts are auto-granted.

## Combat

`sunucu/itachi-rtn.json` is the combat configuration; `itachi-combat.js` implements
the state transitions and reactive actions. All damaging skills, including Level 2
Ignition, use buffed Physical ATK and Physical DEF. Healing remains max-HP based.

| ID | Action |
| --- | --- |
| 13121201 | Nan-Shu: all enemies, Chakra drain/limit 10 through next round, initiative growth, permanently modifies Mystery |
| 13121202 | Kisame-Itachi: Chakra limit 40; selected target interruption/Extreme Chaos |
| 13121203 | Sharingan: 2–3 targets, Suppress Immunity, conditional Extreme Chaos |
| 13121204 | Deidara/Sasori: first two Mystery damage reactions per round; Level 2 Ignition/Paralysis |
| 13121205 | Pain/Konan: first two Trigger damage reactions per round; suppression, stacking Chakra cost, no revival on its kills |
| 13121206 | Hidan/Kakuzu: first two Standard damage reactions per round; three lowest-HP targets and extra critical chance |
| 13121207 | Crow Clone: first allied Akatsuki action per round; chase evasion and temporary chase-hit defense growth |

Both Mysteries have cooldown 2 and battlefield cooldown 0. Their Chakra costs are
20/40. Other passives include the separate incoming damage reductions, critical
healing/growth, debuff cancellation/Hiding and allied Akatsuki suppression.

The supplied screenshot takes precedence over older source CFG where they differ:
debuff cancellation includes Level 2 debuffs. The screenshot/video do not specify
all damage coefficients or numerical probabilities. Configured values are base
Mystery 0.4, modified 1.2, Standard 1.0, Deidara/Pain 0.9, Hidan 1.1, Ignition 0.3;
chase evasion 80%, extra Hidan crit 30%, initiative growth 10%. These are explicit
implementation choices, not verified original-server coefficients.

## Art and native client

Reference: https://www.youtube.com/watch?v=cojd8C4bnfk

Source actor: `asset/Itachi_Road_to_Ninja/assets/battle/role/left/11008581.swf`.
The local effect SWFs and skill icons are recorded in `source-assets.json` and
`effect-sources.json`. Missing standalone Sharingan/Crow icons use matching local
Sharingan/Akatsuki art. The fragment uses Itachi's portrait and its own native
inventory texture ID.

The actor retains its source pivots and aspect ratio (991 unique frames). Large
cinematics are rendered at native scale inside a 1250×650 battle camera; blank
actor frames during those cinematics are intentional. Source `xia` layers are
composited before `shang` layers. Both camps mirror the complete scene uniformly.

Effects use lossless paged ARGB with bounded decoded caching and lookahead loading,
following the existing Mecha runtime. No JPEG conversion, frame dropping or tween
replacement is used. There are 372 current atlas pages; total compressed effect
payload is about 387 MB, loaded as needed rather than decoded all at once. This
is still a substantial first-use download on a remote deployment.

Build order: `prepare-assets.py`, `prepare-vfx.py --ffdec <jar>`, `page-vfx.py`,
`prepare-camera.py`, `prepare-streaming.py`, `build.py --help`,
`build-fragments.py --help`, then `build-client.py`. Consult each CLI before
reapplying data. Client rebuilding refuses unknown installed Itachi modifications.
Itachi feature release: `2026102104`. The shared client received `2026102105`
after the isolated Mecha/Pain size repair in `../animation-size-repair/README.md`;
Itachi methods, model textures and effect manifests are unchanged by that repair.
Current shared client: `2026102106`, with consecutive-hit scheduling and a
foreground damage layer; see `../damage-float/README.md`.
Follow-up shared client `2026102108` adds a separately visible animated Crow
decoy and its round/death/reset cleanup; see `../itachi-crow/README.md`.

## Validation

`node sunucu-kok/sunucu/tests/itachi-combat.test.js` checks both camps/all slots,
physical-stat independence, state counters, Chakra cap expiry, debuffs, healing,
revival prevention and encoded battle-report scheduling. Existing Mecha and
Mystic Shop regressions also pass.

`build-probe.py` / `runtime-raster.js` run the actual native actor/VFX component
for seven skills in both camps, across formation positions. This is a component
probe, not a complete interactive gameplay test. `validation/native` contains the
results and captured frames. `validation/pixels` compares all 372 ARGB pages to
native Flash PNG decoding pixel-for-pixel. Fragment inventory upsert is exercised
by the native Backpack probe, including newly received category-21 items.

Restart the backend and reload the game to load the new server modules and client.
