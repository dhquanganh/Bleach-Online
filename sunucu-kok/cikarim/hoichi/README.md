# Hoichi

Hero `11121012`, S+, all 15 formation positions. Modify Fragment `14131012`; usable recruitment item `14141012`. Both items have icons. Recruitment tokens protect against duplicate recruitment. Mystic Shop fragments require owning Hoichi; the old admin shop overlay does not sell him.

Mystery hits at most **5** enemies, cooldown 4, battlefield cooldown 0, Chakra 20. Dharma Seal requires Acupuncture already present before this cast. Standard attacks a random enemy line and absorbs up to 20 Chakra per unit actually hit. Senbon Barrage triggers at the end of a round in which Mystery was used: up to 9 enemies, 4 Combo, buff/shield removal, lowest-HP target receives Level 2 Acupuncture.

Celestial Pillars works while controlled, once per round below 50% HP. Its first activation grants team Perseverance, cleanses Hoichi and restores his action count; later activations grant Endurance. Perseverance limits each damage event to 1 but does not make a unit at 1 HP immortal. Endurance expires on that unit's next Mystery or after the next round. Secret Jutsu allies ignore shields while Hoichi lives and permanently reduce their own Mystery cost by 10 per evasion until defeated. Evasion wording follows the supplied screenshot; the extracted XML has different action-based wording.

Attack damage uses buffed Physical ATK versus Physical DEF. Locally chosen coefficients absent from the reference: Mystery 1.6, standard 0.9, Barrage 1.25, standard Acupuncture chance 45%. Dharma Seal preserves the separate explicit 8% current-HP formula, capped at 25000 per evasion.

Native actor and the four original front/back SWF effects come from `asset/Hoichi_Full`. Barriers are visual effects; the reference kit contains no independently acting summon. Actor atlases are lossless and deduplicated, about 2.83 MB. Animation placement, mirroring, hit poses and cleanup are isolated to Hoichi. Shared native methods are compared after compilation, including preservation of the existing Mid-Autumn composite animation.

Build order: `prepare-assets.py`, `build.py`, `build-client.py`, `build-probe.py`, standalone Electron component probe, `release.py`. Release target: `2026110103`.

Validation: `sunucu/tests/hoichi.test.js` covers both camps, all positions, physical scaling, target limits, Chakra, seals, immunity, protection and finite server combat reports. Physical-scaling, Tsunade, Guy, Tobi, Asuma and recruit-item regression tests passed. Native component probe exercises four moves in both camps, checks zero leftover effect layers and captures screenshots. This is a component probe and server report validation, not an authenticated full-game playback test.
