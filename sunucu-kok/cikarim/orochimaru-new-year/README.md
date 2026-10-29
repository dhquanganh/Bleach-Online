Orochimaru [New Year]
Hero 11121009, Modify Fragment 14131009, recruit token 14141009, talent 13221009, skills 13122601..13122611.
SSS, all 15 positions, excluded from admin overlay shop. Base speed 180 plus ordinary level growth. Both Mystery forms cooldown 2, Manda costs 20 / Serpent costs 40 Chakra.

Source: asset/Orochimaru_New_Year_Full, art 11002191. Manda/Eight Headed Serpent are the original summoned skill actors; the kit does not define a separate autonomous summoned combat unit.
Animation: original MME poses at 24fps sampled to 25fps; all actor/VFX scales uniform, fixed lobby idle canvas, original native Flash VFX and separate Orochimaru cache/layer cleanup. Main effects retain original blending; cut-ins use Screen to remove their opaque black matte. Blank source actor cells hold the opening cast pose rather than an invisible/airborne frame. Native frame hit markers split the total damage without multiplying its coefficient.

All attack damage uses buffed Physical ATK vs Physical DEF. The explicitly stated Laceration follow-up remains a separate 10% max-HP True damage effect (AGENTS HP-effect convention). Attack coefficients and unspecified evasion/repulse/critical values are configurable local balance values.

50% recovery proc heals 105% of actual HP damage from enemies; also handles indirect damage, aid, reflected damage and counters. Can rescue fatal damage, respects max HP/healing denial/reduction, excludes self costs and zero damage. Recovery is reported after damage; no hidden HP-only changes. Explosive Mode prevents death and recovers 4% HP when attacked. Original self-revival waits 2 rounds; complete wipe still ends the match.

Additional Seal counters are limited to 5 per round even if controlled. Seal cost reduction caps at 40 Chakra per camp until next round end. Chase conditions unlock Low Float, High Float, Knockdown, Repulse in order. Critical growth capped at 5 evades per round; healing remains per evasion.

Validation: tests/orochimaru-new-year.test.js (both camps/15 positions, finite binary reports, exact fatal-damage/recovery playback HP), physical-scaling, recruit token integration, base stats, Cross base normalization, buff floats and existing Guy/Asura/Itachi/Mecha/Kakuzu tests. Flash component preview separately covers 22 native casts in both camps.

Existing broader test limitation: reincarnation.test.js:89 compares battle HP 221264 to gear-packet HP 217639 using the current live account fixture. The identical assertion fails with all Orochimaru rules disabled. This is outside the new character implementation; no player data was changed to force that test to pass.

Release 2026102905: at the end of rounds 2, 4, 6..., a living Orochimaru revives one random eligible non-summoned ally at 100% HP. One use per owner per interval, no backlog from empty intervals, no self-targeting or no-revival bypass. HP restore is reported before the owner's existing resurrection animation. Both-camp real combat reports verify even-round timing and full HP.
