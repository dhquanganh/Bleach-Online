# Native battle resource loading (2026102237)

The first battle created TProcessorBattleLoading but only mounted it inside
ProcessorBattleInfo, which runs after combat resource loading completes.
This left the generic module progress display visible instead of the native
MC_BattleLoad screen.

TBattleHandle now mounts that existing screen in InitBattleHandle and raises
it before StartPlayerLoad, before requesting models, skills and backgrounds.
ProcessorBattleInfo still raises it over the newly created stage. Native
progress, transition frames, completion callbacks and Reset are unchanged.
No startup loader text or asset is replaced.

source.swf is the decoded 2236 client. patched contains only TBattleHandle.
build.py imports the class, re-exports verification source, checks ordering and
requires all non-ABC tags to remain identical before updating canonical app.
release.py publishes 2237 with the existing routes preserved.

Validation:
- node sunucu-kok/sunucu/tests/void-battle-loading.test.js
- node sunucu-kok/sunucu/tests/void-region-frontend.test.js
- node sunucu-kok/sunucu/tests/void-entry.test.js
- python sunucu-kok/cikarim/sasuke-shinden/verify-bootstrap.py

These checks passed. Full authenticated Flash playback was not visually tested.
