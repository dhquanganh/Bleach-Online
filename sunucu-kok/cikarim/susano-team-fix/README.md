# Sasuke / Pain / Mecha team animation fix - client 2026102242

Confirmed in bundled Electron/Pepper Flash using copied account state and native
Daily Activities -> Void Region -> battle pointer clicks. Party: main at 6,
Pain at 2, Sasuke Shinden at 8, Mecha Naruto at 11; enemy Itachi RTN.
Production account files and boss configuration were not modified.

Root causes and final changes:
- Native PlaySkill selected Susano sequence 6 while FTextureSkill was still the
  one-sequence placeholder. texture-diagnostic.log captures the exact failure:
  id=11120970 skill=13121309 sequences=1 fallback=true, RangeError #1125.
  Normal battle loading previously requested only idle model animations; full
  animation preloading was restricted to the introductory mission. TBattleHandle
  now requests idle, attack, skill, hit and run as primary resources for every
  roster model before starting playback. Cached textures are reused by the
  existing resource repository. No fallback animation or art was substituted.
- Later mixed reactions reproduced Error #2094 inside ShowHashiramaStatusText,
  the shared status-label renderer used by Sasuke, Mecha and Itachi. A removal
  callback could try removing the same child again during removal. Cleanup is
  now idempotent and never detaches a child during REMOVED_FROM_STAGE dispatch.

Only TBattleHandle and TRole are imported from a fresh 2241 client. The normal
battle command scheduler is retained. All non-ABC SWF tags are byte-identical;
combat formulas, damage, skill ordering and animation timing are unchanged.

Validation:
- tests/susano-team-preload.test.js executes the compiled loader across tutorial,
  later missions, Void, City Defend and replay/video paths, and checks original
  Susano sequence selection.
- tests/ninja-status-cleanup.test.js reproduces the old removal reentry and checks
  replacement, expiry, external removal and duplicate cleanup of the new code.
- existing Void start cue and entry frontend regressions pass.
- fixed-full/final.png: mixed team proceeds to round 2 against Itachi, no errors.
- fixed-short-x1/final.png: same team finishes naturally with WINS against a
  private low-HP Itachi config; runtime.log has no uncaught errors.
- Full native x2 validation and release verification recorded separately below.

Final native validation: fixed-short-x2/speed-x2.png shows the original Susano
animation at x2; fixed-short-x2/final.png shows natural WINS. The full and both
short native runs have no uncaught Flash errors. The x2 test uses a private
200,000-HP Itachi config only to finish promptly. No production boss stats changed.
