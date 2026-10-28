# Guy [Gate of Death]

- Hero `11121007`, SSS, all 15 formation positions; excluded from admin overlay shop.
- Modify Fragment `14131007`, usable Recruit Token `14141007`.
- Release `2026102816`; art `11001941` from `asset/Guy_Gate_of_Death_Full`.
- Tags: Lightning, Male, Konoha, Allied Shinobi Forces.

The isolated combat module implements six-combo Five Steps against every living
enemy, rotating random-line Air Cannons with 20% adjacent-grid splash, and Night
Guy against the front line. All damaging skills, including splash and Night Guy,
use buffed Physical ATK against Physical DEF. These are pure Taijutsu attacks;
existing explicit Pure Taijutsu immunity remains applicable. The reference does
not specify coefficients, splash probability or evasion rate; JSON explicitly
sets the chosen values (.95 standard, 1.5 Mystery, 3 Night Guy, 50% splash chance,
60% standard evasion). Night Guy's source max-HP damage is adapted to ATK by request.

Before an action, Steam consumes 10% max HP, grants Level 2 armor/standard evasion
through round end, grows Attack 60% up to ten activations and Speed 5% up to three.
A Mystery consumes another 10% max HP. Costs stop at 1 HP and never redirect.
Lost HP dynamically grants the living Guy's team +2% Attack and +1 percentage
point Critical Rate per missing 1% HP. Guy is immune to Debuffs/lower Suppress
Immunity and cannot receive healing, including the Naruto cloak's Life Steal.

During rounds 1 and 2, a living Guy intercepts allies' attacks using his own
Physical DEF and has +200% Physical DEF. Multiple Guys do not recursively pass
damage to each other. Shared DOT/indirect paths also redirect to Guy; HP costs
are excluded. A fatal hit holds Guy at 1 HP until the finite Night Guy queue runs.
Guy is defeated after Night Guy resolves, so the client actor stays alive until
its skill completion callback. A shield that absorbs the hit cannot falsely
trigger Night Guy. Defeated Night Guy targets cannot revive.

With Naruto Final Battle in the starting lineup, Guy can revive once at 50% max
HP. This is an external rescue overriding Guy's own death prohibition, not enemy
no-revival effects. It does not renew on resurrection. If the death skill is
disabled, Guy stays at 1 HP and is defeated at round end; Naruto's external
rescue can still apply once. A wiped lineup is never held open by a dead Guy.

No independently targetable summon is defined by this kit. Native source SWFs
retain the air cannons, Five Steps, red Night Guy dragon and Steam, with uniform
0.84 actor/VFX scale and source pivots. Fixed-canvas profile idle, two standards,
Steam, Night Guy, revival, entry, death and damage poses use private dispatch.
Approximately 6.3 MiB of model textures plus 13.7 MiB of native VFX; no existing
character animation is rebuilt.

Validation: both-camp backend and real binary reports for redirect/fatal/death/
one revival, missing-HP buffs, no-healing, cost/stack limits, shields, statuses,
splashes and all positions; 122 physical-scaling move/camp cases; recruit items,
base stats, Cross, Hashirama, Madara, Naruto, Tsunade and Kakuzu regressions.
The 18 Flash component cases cover both camps with zero errors or remaining
layers; this is a component preview, not a logged-in account battle.
`client-validation.json` confirms 252 unrelated TRole methods unchanged.
