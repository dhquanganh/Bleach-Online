# Nagato [Frog Squad]

Gale Palm enlargement: 2.25x uniform display scale, preserving the hand anchor. Its two original effect layers are re-rendered at zoom 2 from the source SWF into lossless pages up to 2048px, using new `large-v2` URLs. After a full asset rebuild, run `enlarge-gale.py --assets`, then `prepare-streaming.py` before building the client. For an installed client, `enlarge-gale.py` updates only the Gale presentation methods and manifest.

Hero `11120990`, SS (quality 6), every formation slot. Modify Fragment `14130990`; inventory icon `16228142`. Hero purchases remain blocked by the existing reserved Naruto ID filter in both the overlay catalog and purchase endpoint. The fragment uses the existing owned-only Mystic fragment shop.

Presentation refinement follows https://www.youtube.com/watch?v=FkS9HwulWUo at 29–33 seconds: approach before the palm, source-space wind origin at +70px, uniform scale tied to the actor, and smooth return. Source approach distances: Mystery 300, standards 360, chase 240. `refine-client.py` updates the current client incrementally and verifies that unrelated methods remain unchanged. Motion checks: `node sunucu-kok/sunucu/tests/nagato-presentation.test.js`.

The five skills follow the supplied screenshot. All attack damage uses buffed Physical ATK against Physical DEF. Frog Squad Cooperation therefore grants stacking 8% Physical ATK to the Frog Squad unit that executes each chase; its lineup aura persists after Nagato's death. Frog Squad Lead triggers once per round before his action, reduces cooldown by one and makes his Mystery free for that round. The battlefield cooldown still prevents a round-one Mystery. Frog Knockdown has a fixed two-use round budget.

Gale Palm checks the selected target's shield before attacking: normally six targets and Low Float on the selected target; with a shield, all targets, no Low Float, and removal of positive buffs (including reflection) and shields from units hit. Unspecified damage coefficients are 1.8 Mystery, 1.0 standard, 1.2 chase, with a 30% standard four-combo proc; these tuning values are explicit in `sunucu/nagato-frog.json`.

Original source: `asset/Nagato_Frog_Squad_Full`. Native action mappings are A_1hit / A_2hit / A_3hit, SP_skill4 Mystery, SP_skill2 chase. Preserve source pivots and uniform scaling. QWCMpg1/2/3, QWCMaoyi and QWCMzhuida use isolated Nagato dispatch and caches. Effects retain transparent edges and are paged at <=2048 px, with lossless ARGB streams and bounded, pooled Mecha-style playback. No shared character animation method is replaced.

Rebuild in order from the workspace root:

```powershell
python sunucu-kok/cikarim/nagato-frog/prepare-vfx.py --ffdec .tools/ffdec/ffdec.jar
python sunucu-kok/cikarim/nagato-frog/page-vfx.py
python sunucu-kok/cikarim/nagato-frog/prepare-assets.py
python sunucu-kok/cikarim/nagato-frog/prepare-streaming.py
python sunucu-kok/cikarim/nagato-frog/build.py --apply
python sunucu-kok/cikarim/nagato-frog/build-fragments.py --apply
python sunucu-kok/cikarim/nagato-frog/build-client.py
python sunucu-kok/cikarim/nagato-frog/verify-assets.py
node sunucu-kok/sunucu/tests/nagato-combat.test.js
python sunucu-kok/cikarim/nagato-frog/release.py
```

The client builder checks its input against its saved compiled client before rebuilding an installed dispatcher. It preserves unrelated methods and non-code SWF tags. Do not rebuild from its earlier backup after subsequent client features have been installed; add future changes incrementally to the current client.
