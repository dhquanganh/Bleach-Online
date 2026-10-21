# Naruto Sage Mode native rebuild

Naruto `[Sage Mode]` uses hero ID `11120901`, clone ID `11120902`, talent `13220901`, skills `13120901`–`13120904`, and Modify Fragment `14130901`.

The actor is decoded from `asset/Naruto_Sage_Mode/assets/battle/role/left/11000171.swf`. The build keeps the source timeline, transparent RGBA pixels and per-frame pivots at a single 0.9 scale. It packages separate idle, run, hit, clone summon, Rasengan Barrage, Rasen Shuriken and chase sequences. Empty source cells hold the previous visible pose so the actor does not flash. Frames are packed losslessly into bounded native atlases and loaded by the existing game texture streamer.

The backend implements the screenshot rules: Rasen Shuriken attacks the enemy lineup, adds 10 combo and Repulse; an actual Lightning-resistant clone is summoned at battle start; the standard becomes Rasengan Barrage while the clone lives; chase converts Repulse to Knockdown; Sage Chakra adds 20 team Chakra each round. Only Mystery has cooldown 2 and battlefield cooldown 1. Every damaging move uses Physical ATK and Physical DEF. Naruto is SSS and profession 2 (middle row).

The source folder's native portrait, preview and battle head images are installed. Naruto and the clone share one immutable model cache, so summoning does not load a duplicate atlas. Modify Fragment quality is 7 and its inventory icon uses the supplied native head art. Naruto is available again while the clone stays hidden from recruitment and shops.

Rebuild and verify:

```powershell
python sunucu-kok/cikarim/naruto-sage-native/prepare-assets.py
python sunucu-kok/cikarim/naruto-sage-native/build.py --apply
python sunucu-kok/cikarim/naruto-sage-native/release.py
python sunucu-kok/cikarim/naruto-sage-native/verify.py
.\node\node.exe sunucu-kok/sunucu/tests/naruto-combat.test.js
.\node\node.exe sunucu-kok/sunucu/tests/physical-scaling.test.js
```

Reference video inspected at `https://www.youtube.com/watch?v=9pAXLba269Y&t=63s`; local contact sheets and the downloaded reference are retained in this work directory for timing comparison.
# Original skill effects

`prepare-skill-effects.py` converts the supplied SWF timelines from
`asset/Naruto_Sage_Mode_Skill_Effects` into the six native Skill TexClient
resources used by Mystery, Rasengan Barrage and the chase. It preserves alpha,
registration pivots and 40 ms playback, includes the shared hit spark and
Mystery charge layers, and bounds each lossless atlas for Flash playback.

