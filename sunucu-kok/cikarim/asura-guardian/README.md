Asura Otsutsuki [Guardian of the Land]

Hero 11121008; Modify Fragment 14131008; Recruit Token 14141008; talent 13221008; skills 13122501..13122510.
SSS, all 15 positions, excluded from admin overlay shop. 80 fragments per recruit.

All damage uses buffed Physical ATK vs Physical DEF. Area attacks target all enemies. Base-ATK Dragon Protection heals retain their separate healing formula. Descriptions use the original source text, with Physical ATK substitutions and requested additions.

Rounds 1-2: absolute incoming damage immunity. Living Asura can resurrect one random eligible ally per round at full HP. Self revival: two rounds later, 40% HP and Dragon Protection; complete defeat still ends the match. No-revival effects remain effective. Banishment is cleared by a native end-round marker and during revival/reset.

Actor frames: source 24fps sampled to 25fps, 0.84 uniform scale, fixed lobby idle canvas. Large MME layers use original embedded BitmapData and affine transforms directly from AsuraActor.swf; native SWFs preserve the original MME timings and VFX. This avoids oversized Flash atlases and repeated raster frames. Kurama uses a stable uniform battlefield fit; both camps are mirrored.
No separate summoned combat unit is defined by the source kit; Wood Dragons/Kurama are original visual actors.

Build: prepare-assets.py, tools/build-asura-native.py, tools/build-asura-actor-layers.py, build.py, build-items.py, build-client.py, build-probe.py, release.py. Native component validation is separate from actual encoded backend battle tests.
