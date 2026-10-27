# Tobi [Great Ninja War]

Native client release: `2026102609`. Initial Tobi integration was based on the active `2026102605` client; the actor scale and playback fix are based on `2026102606`.

- Hero `11120995`, White Zetsu `11120996`, SSS/quality 7, all formation positions.
- Tags: Earth, Male, Akatsuki, Confusion, Blood Limit.
- Modify Fragment `14130995`, Recruit Token `14140995`, inventory icon `16228147`.
- Excluded by the existing admin overlay hero filter. Fragment association uses the existing owned-partner Mystic Shop workflow. The recruit token uses the normal inventory item handler; duplicate ownership does not consume it. White Zetsu is summon-only.

## Combat

The user's HP scaling override takes precedence over the workspace Physical ATK default. Every configured damaging move uses `attackStat: "maxHp"`, `damageType: "physical"`; maximum HP is measured at cast time, damage is reduced by Physical DEF, and ordinary penetration, critical and reduction rules remain. Tobi/Zetsu block counters also use maximum HP. Attack/Ninjutsu increases from Mystery kills are retained as described; they do not change the HP damage formula.

The supplied screenshot does not specify damage coefficients or the chance of a line standard. Local tuning is declared in `sunucu/tobi-war.json`: Mystery 18% max HP, standard 8%, chase 9% plus 4% lineup splash, Summit 14%, White Zetsu attack 5% of its own max HP, line chance 50%.

Mystery costs 40 Chakra, has cooldown 3 and entry cooldown 0. It dispels the selected set's buffs/shields before its unavoidable nine-target damage and gains 40% damage against summons/clones/puppets. A kill grants 40% Attack/Ninjutsu per defeated unit and one immediate Summit; every Mystery also schedules Summit for the next round and summons up to two White Zetsu in reserved slots. Existing live summons are retained.

Summit targets seven enemies, interrupts them, applies Low Float to the lowest-HP surviving hit, gives Level 2 Super Armor for the round, reduces Mystery cooldown by one and restores 20 Chakra. Chase requires Low Float, applies Knockdown/Immobile, absorbs up to 40 available enemy Chakra, then damages the opponent lineup within one chase animation.

White Zetsu has 60% of its owner's max HP, cannot be killed by Mystery damage, and heals 50% of its own max HP at round end (normal healing-block rules apply). While a Zetsu lives, the first attack against each allied ninja reduces all allies' Mystery cost by 10, or 20 for a Mystery, capped at 40 until round end. Auxiliary summons do not count as allied ninjas for that trigger. Fatal damage sacrifices the living allied White Zetsu with the lowest current HP to revive Tobi at 40%; existing no-revival effects are honored.

## Assets and client

`prepare-assets.py` decodes the supplied Tobi and White Zetsu MME timelines. All 766 source actor frames retain their pivots and aspect ratios in lossless, deduplicated native atlases. Partner profile idle uses a fixed canvas/pivot across frames.

The `2026102607` follow-up scales Tobi and Zetsu's battle actor textures to 90% with proportional pivots. Both partner profile idles move down 12 px through pivot metadata only; their pixels and atlas are unchanged. The nonportrait Tobi effects use the same 90% scale.

Skill effects use the original SWFs and named `shang`/`xia`/`texie` layers, with dedicated cached ApplicationDomains and independent per-cast MovieClips. This retains source alpha, blending and nested timelines without enlarged raster exports. The portrait uses a stable source strip rectangle and spans the stage width. Skill layers are removed on completion, interruption, reset or stage removal. Tobi's renderer/dispatch and White Zetsu's entry/death lifecycle are actor-scoped.

Both camps register zero-HP reserved Zetsu actors before building the replay queue. HP restoration resets stale death state before entry playback. The summon/healing animations have `friendhp` events; damaging clips have exactly 100% total HP dispatch across source hit frames.

## Build and validation

Build order: prepare assets, build native data, build fragments with `--apply`, run the shared recruit-item builder with `--apply`, snapshot/export the current active client, compile the client, run tests and native probes, then publish with `release.py`. Do not rebuild from an older character's client snapshot. Publication checks active/canonical equality and preserves unrelated resource-map entries.

- `sunucu/tests/tobi-war.test.js`: all 15 positions/both camps, HP/DEF scaling, costs/cooldowns, random/line standards, chase/splash, summon damage bonus, HP-scaled counters, summon/revival, Spore cap/expiry, immunity, Summit and encoded scheduling.
- `sunucu/tests/tobi-war-revival.test.js`: real encoded reports with repeated revivals, sacrifice HP, HP-before-animation ordering, reserved actors and later rounds.
- Existing Naruto, Mecha, Tsunade, Pain, Hashirama, Obito, Itachi, Sasuke, Gaara, Nagato, revival and recruit-item suites passed.
- `validation/native`: 22 native actor/skill casts in both camps; no errors or remaining VFX layers.
- `zetsu-lifecycle/validation/native`: six independent Zetsu exercise delayed textures, entry, death, respawn, callback cancellation and stage removal; no errors/stale listeners.
- `client-validation.json`: 186 other TRole methods, 27 TActive methods, 45 stage methods and both profile windows' unrelated methods preserved.
- `repair-freeze-scale/client-validation.json`: Tobi's `IsSkill(0)` had returned true, causing passive records to play the 124-frame Mystery pose. Only Tobi's actual skill IDs now enter skill playback; the 24 passive ID-0 events in the two encoded revival fixtures no longer select Mystery. The repair preserves 201 other TRole methods and 29 other TActive methods.
- `queue-probe/validation/native`: native stage registration addresses all 153 events in each camp's actual Tobi revival report, including both zero-HP White Zetsu actors. The old live-actor-only registration stopped at event 3.
- `sunucu/tests/tower-gold-zetsu.test.js`: floor 68 produces two White Zetsu deaths and two Tobi revivals; every report actor resolves and play continues into the following round.
- `repair-gold-zetsu`: release `2026102608` bounds White Zetsu death playback when a texture sequence is absent or the replay clock stalls. It also preserves the outstanding action callback if Zetsu dies during its own attack. Scope validation confirms 199 other `TRole` methods unchanged. The dual-death native probe finished with both callbacks called exactly once, but the later full replay exposed a separate buff-only command error fixed in `2026102609`.
- `repair-passive-queue`: release `2026102609` fixes the reproduced floor 68 freeze. A buff-only Tobi event with skill ID 0 has no `CMD_ATTACK` target vector; `TRole.CommandPlay` previously read `.length` from null and stopped the native command queue at the beginning of round 4. The fix completes that no-op command and lets the following buff removals and Mystery play. The exact same encoded report from an isolated copy of the account failed at command 158 with Flash `#1009` before the fix, then executed all 399 commands and reached the battle result after the fix. Scope validation confirms 201 other `TRole` methods unchanged. One unrelated, nonblocking Flash `#2094` also appeared in both runs during an earlier skill effect.

The Flash probes are isolated native component tests, not a logged-in gameplay recording. Log out and sign in after publication to load fresh account-worker modules and the new client resource URLs.
