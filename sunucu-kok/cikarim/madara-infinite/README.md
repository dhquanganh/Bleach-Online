# Madara Uchiha [Infinite Tsukuyomi]

- Hero `11121005`, SSS, any of the 15 formation positions.
- Modify Fragment `14131005`; usable Recruit Token `14141005`.
- No admin-overlay shop entry. Tags match the supplied reference.
- Original resources: `asset/Madara_Infinite_Tsukuyomi_Full`, artistic ID `11011761`.
- Release `2026102805`.

The isolated backend module alternates Infinite Tsukuyomi and Complete Body
Susano'o, tracks restrained actions and Slumber, steals remaining standard
attempts, switches the 30-combo chase at 60 Chakra, and grants one evasion
counter/Mystery refund per round. Every action can grow Attack/Ninjutsu, capped
at eight growth activations per round. Physical damage always uses buffed ATK
against Physical DEF; the source gives no numeric damage coefficients, so the
chosen coefficients and 60% evasion chance are explicit in the JSON.

Infinite Tsukuyomi is a control-only Mystery, matching the reference. Susano'o
and the offensive area skills hit all living opponents as requested. Susano'o
removes Explosive Mode, including Hashirama's existing implementation. Barrier
immunity lasts two rounds; bonus Chakra prevention and 80% healing reduction
apply only to the activation round. The normal next-round Chakra pool remains.

Revival occurs at the start of the third round after death, restoring 80% HP.
HP restoration is reported before the animation. No-revival kills prevent it,
and an entirely defeated lineup loses immediately without waiting for revival.
Limbo shadows are rendered in the original effect timeline; this reference has
no separate independently targetable summoned unit.

Native SWF effects retain original vector/bitmap alpha and timelines rather
than rasterizing every effect frame. Battle actor textures use uniform 0.84
scale, deduplicated packed frames and original pivots. Partner idle uses a fixed
canvas. About 16.5 MiB of model textures and 31.8 MiB of native VFX retain all
three Thunder Dance variants, Limbo, both Mysteries, two chases, counter, barrier,
evasion, revival, entry and death animations.

Validation: both-camp backend and binary-report tests, Physical ATK/DEF scaling,
recruit-item use/duplicates, base stats, Cross scaling, Hashirama, Madara Final,
Minato, Kakuzu and Tsunade regressions. The Flash component probe executes 28
animation cases across both camps with zero runtime errors and zero remaining
effect layers. It is a component preview, not a logged-in account battle.
`client-validation.json` verifies 235 pre-existing TRole methods unchanged.

Susano'o transparency fix: release `2026102806` composites only `yuehziyan_aoyi2`
and `yuehziyan_aoyi2texie` with Screen blending, removing their black light-effect
matte. All other character methods, gameplay and source assets remain unchanged.
Focused both-camp component previews are under `susanoo-transparency/validation`.
