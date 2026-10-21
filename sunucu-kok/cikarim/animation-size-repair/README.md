# Mecha / Pain animation size repair — client 2026102105

The user reported small Mecha Beast Mode attacks and Pain's Six-in-one attack
after the Itachi release. Inspection found the pre-Itachi Mecha/Pain textures and
their existing runtime methods still intact. This repair explicitly adjusts the
two visual footprints and versions their model URLs; it does not claim that the
Itachi installer overwrote the older characters.

* Mecha giant Bomb, Claw and Sweep use 0.75 source scale instead of 0.6: 25% larger.
  They are regenerated from the native SWF, retaining aspect ratio, source action,
  frame count, hit markers, duration and registration. Transparent borders can be
  trimmed with matching pivot correction. All 297 affected actor frames are
  packed losslessly with MaxRects within Flash's 4096-pixel bitmap limits. The
  larger 0.85 candidate exceeded the available native atlas capacity and was not
  installed. Persistent Beast idle/run/hit and Energy Recovery retain native 1.0
  scale. Base Mecha poses and all Mecha VFX are unchanged.
* Pain Six-in-one (`13120974`) changes from a 900 to 1250 battle-unit footprint.
  Its images, aspect ratio, frame timings and other skills are unchanged.
* Fourteen model URLs for these two heroes receive release version 2026102105,
  including their corrected persistent poses, to avoid older cached models.
* Every other TRole method (116 methods), including every Itachi method, matches
  the previous client export exactly. No other class is imported. Eleven Itachi
  configuration/model files retain their hashes; combat is untouched.

`build.py` patches the current installed client and publishes the targeted model
textures. It refuses an unexpected starting footprint. Backups preserve the live
client, version manifest, animation metadata, original frames and model textures.
`verify.py` checks all 1029 native skill actor frames pixel-for-pixel against their
PNGs, pivots, 40 ms timing, unchanged clip dispatch, model aliases and Itachi hashes.

Native component probes are built with `--role-source` pointing at
`verify/scripts/Processors/Game/Battle/Character/TRole.as` here. They exercise 26
Mecha casts and 18 Pain casts across both camps. These are component tests rather
than a complete interactive battle. See each character's `validation/native`.

Reload the game completely to load client 2026102105 and the new model URLs.
