# Naruto [Mid-Autumn Festival]

Hero `11121010`, SS, quality 5, all 15 formation positions. Modify Fragment `14131010`, Recruit Token `14141010`, shared item picture `16228162`, skills `13122701..13122707`, talent `13221010`.

Source assets: `asset/Naruto_Mid_Autumn_Festival_Full`, actor `11012171`. Original Gamatatsu is embedded in the standard attack animation; this kit does not create a persistent independently targetable Gamatatsu unit. No admin overlay shop entry was added.

Mechanics:

- Mystery: unavoidable Physical ATK damage against Physical DEF, all living enemies including summons, 5 Combo, cooldown 1, battlefield cooldown 0, 40 Chakra.
- Standard: 2–4 living enemies, chance of Knockdown, three supported attack dispatches using the supplied two actor poses.
- Ingot Shower: once per living owner per round, select one living non-summoned lineup character. Excited Mode increases Physical ATK by 60%, reduces Physical DEF/Resistance by 30% and adds 70% Combo Rate until that round ends. Reapplication does not stack. The source Ninjutsu increase is replaced by the single Physical ATK increase, not an additional duplicate bonus.
- Ingot Shower also grants an extra standard to allied auxiliary/summoned/clone/puppet units. “Non-ninja” follows combat entity roles, not the Naruto/Bleach franchise. This grant belongs to the round-start Trigger, not the similarly named Mystery. It uses the summon’s existing standard without consuming its ordinary action budget; dead, disabled and disarmed units do not execute a grant.
- Chase: requires 5 Combo, once per round, up to five enemies. Above 60% HP it changes to the single-target unavoidable version with increased penetration, Critical Rate and critical damage (Injury Rate). Exactly 60% uses the ordinary version.
- Passive: basic debuff immunity, susceptible to Suppress Immunity; Physical ATK grows 4% per executed standard, once per action rather than once per victim/hit. Growth stacks for the battle and is reset for a new battle.

The reference does not specify damage coefficients, penetration, Knockdown chance or modified-chase bonus magnitudes. Explicit local values in the JSON are: Mystery 1.65 ATK, standard 0.9 ATK/45% Knockdown, ordinary chase 1.1 ATK/20% penetration, modified chase 1.8 ATK/35% penetration/+20% Critical Rate/+30% critical damage. Existing general damage reduction/critical rules remain active. Previously configured growth is retained: interpolated between the existing SS and SSS base-stat policy, without changing other characters.

Animation:

- Lossless, deduplicated native atlases, original per-frame pivots, uniform 0.84 battle scale and a fixed profile-idle canvas.
- The sparse clone composite is rendered from the original SWF’s exported bitmap definitions and MME layer transforms at the original 24fps timeline. This replaces a 20.2 MB precomposed skill texture with an approximately 0.9 MB skill texture plus the original 0.85 MB actor file. No shared decoder format was changed.
- Original native VFX layers retain transparency, facing and blending. Dedicated Mid-Autumn loader domains, caches and cleanup prevent cross-character animation changes. All non-ABC client assets were preserved; 275 other TRole methods were verified unchanged.
- Tags: Wind, Mid-Autumn, Male, Konoha, Jinchuriki, Uzumaki Clan, Allied Shinobi Forces, Senjutsu; hover names and icons are present in own and inspected player profiles.

Validation:

- `sunucu/tests/naruto-mid-autumn.test.js`: both camps, all positions, real finite binary battle reports, Chakra/CD, target counts, 60% boundary, basic immunity suppression, round buff expiry/nonstacking, per-action growth, summoned-unit extra actions and Physical ATK/DEF scaling independent of Magic ATK/Resistance.
- `sunucu/tests/naruto-recruit-items.test.js`: all 21 characters, real token recruitment, forged requests and duplicate ownership without item loss.
- Physical scaling, buff notices, Tobi, Mecha, Orochimaru and Cross scaling regressions passed.
- `validation/native/result.json`: 14 successful component casts (seven skills in both camps), no missing frames/errors/remaining VFX layers. Native screenshots cover Gamatatsu, coins and mirrored clone sequences. This is a component preview; actual combat report coverage is provided separately by backend tests.

Release `2026103102`. Restart the server and reopen the launcher to load backend changes and the fresh client/resource URLs. No live player account was used for validation.
