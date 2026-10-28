# Naruto Uzumaki [The Final Battle]

- Hero `11121006`, SSS, all 15 formation positions, excluded from admin overlay shop.
- Modify Fragment `14131006`, usable recruit item `14141006`.
- Release `2026102808`; source `asset/Naruto_The_Final_Battle_Full`, art `11016211`.
- Tags: Wind, Male, Konoha, Jinchuriki, Blood Limit, Uzumaki Clan, Allied Shinobi Forces, Senjutsu.

The isolated `sunucu/naruto-final-combat.js` implements Shukaku, Matatabi, Isobu,
Son Goku, Kokuo, Saiken, Chomei, Gyuki and Kurama in that order. Each free Bond
refunds its own cooldown; after nine casts the Mystery becomes Super Massive
Rasen-Shuriken (40 Chakra, separate two-round cooldown). A round can execute at
most nine Bond casts plus one final Mystery. Kokuo immediately restores action
availability and cleanses, then at round end cleanses and resets Bond to stage 0.
That reset does not erase the offensive Mystery's independent cooldown.

All damaging moves and indirect damage use buffed Physical ATK versus Physical
DEF. Each Mystery adds one 12% Physical ATK growth stack; Magic ATK is unchanged.
Area moves hit every living enemy as requested, while the Magnet chase and
Reverse Harem target the selected unit. A lone enemy takes double final Mystery
damage; a female selected target replaces that cast with Reverse Harem, not a
second damaging Mystery. Harem causes interruption, acts-last Slowness and a
nonstacking 60% damage reduction through round end.

Each first team Mystery and first team Trigger can produce one additional
Rasen-Shuriken per round. Its own additional attack cannot trigger itself.
Friendship removes team Fear and grants 15% standard damage per incoming attack,
capped at six stacks, and unavoidable Jinchuriki standards until round end.

The nine resonance effects coexist until round end. Status definitions were
checked against the local source SkillKeyDescCFG: Slow Reflex grants the physical
attacker a 60% extra-standard chance, max five per round; Dye Ink blocks standards
and chases; Discouragement prevents new buffs/shields and clears on Mystery.
Magnet Seal blocks Mysteries and, for non-Jinchuriki, additional/death skills.
Shukaku makes it a special effect that normal debuff cleanses cannot remove.
Blocking a death skill does not prohibit an external ally resurrection.

Kurama and the other beasts are original visual skill actors; no independently
targetable summon is defined by this kit. All nine resonance animations, three
Kurama standards, final Mystery, Harem, chase, additional, Recovery, Restoration,
entry/death and fixed-canvas profile idle retain source choreography and pivots.
Native SWF VFX avoid huge raster-effect atlases. Actor frames are packed and
deduplicated losslessly at uniform 0.84 scale. Model textures are about 27.5 MiB;
19 native effects are about 35.4 MiB. No other character's animation is rebuilt.

Validation includes both-camp actual binary reports, finite action/refund caps,
all resonance effects, cooldown/chakra, female replacement, Physical ATK/DEF and
Magic ATK/Resistance independence, recruit items, base stats, Cross and existing
revival/character regressions. The 40 Flash component cases cover both camps and
all moves; this preview is separate from logged-in account combat.

Final Mystery cinematic fix (`2026102810`): restore original normal compositing
instead of whitening the cut-in with Screen, separate the introductory cut-in
from the later impact layers, and use a full-viewport cinematic backdrop. The
camera fits the visible golden foreground instead of transparent/cloud padding;
uniform scaling retains the artwork's proportions. Temporary sampling bitmaps
are disposed immediately, and the cinematic backdrop follows effect cleanup.
Only `PlayNarutoFinalNative` changes; all other 255 TRole methods are verified
unchanged, including the four-second buff text runtime. Focused both-camp previews
are under `final-fullscreen/validation`.

Bomb alignment fix (`2026102812`): only the `texie` transformation uses cinematic
framing. The later projectile/impact layers retain the original caster-relative
coordinates, 0.84 scale and mirrored facing, and use Screen compositing to remove
their dark rectangular matte. The transformation sequence is retained. Both-camp
impact previews and effect cleanup checks are under `bomb-alignment/validation`.

Kurama Chakra Cloak (`2026102814`): at battle start, grant the entire team +50%
Physical ATK, +50% Physical DEF and 50% Life Steal. One copy per recipient; two
Naruto Final Battle owners do not double it. The ordinary positive buffs last
for the battle and follow the existing buff-dispel rules. Direct normal/skill/
chase/trigger hits heal their living attacker from actual HP damage after shield
and mitigation; standard healing prevention, reduction and max-HP caps apply.
The shared four-second buff notices announce all three gains. No animation rebuild.
