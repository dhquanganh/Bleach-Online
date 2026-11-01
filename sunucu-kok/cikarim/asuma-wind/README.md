# Asuma [Wind Blade]

- Hero **11121011**, **S+**, quality 5, all 15 formation positions.
- Modify Fragment **14131011**; usable Recruit Token **14141011**;
  shared inventory picture **16228163**. No hero sale in the old admin overlay.
- Tags: Wind, Male, Konoha, Sword User. Native partner and other-player profiles
  include the tag icons and tooltips.

## Combat

The user's clarification preserves the screenshot's **3-target Mystery**.
Flying Swallow – Wind Blade has cooldown 3, battlefield cooldown 1, Chakra cost
40, and knocks down the selected opponent. Eight original visual contacts split
the total damage into eight portions; damage is not multiplied eight times.

Chakra Blade – Straight Line attacks up to 3 enemies in the foremost living row,
with a Repulse chance. Courage adds 20 team Chakra once at the beginning of the
battle. Burning Ash chases Repulse, causes Knockdown and ordinary Blindness
(blocks Standard Attacks), with a finite per-round chase budget.

Pose of Invincibility grants 30% Physical ATK to full-HP allied ninjas while a
living Asuma is on their side. It is conditional, nonstacking, stops on injury or
Asuma's death, and resumes if full HP/living Asuma are restored. The Ninjutsu
bonus is replaced with Physical ATK, not added a second time.

All damaging moves use buffed/debuffed Physical ATK against Physical DEF.
Unspecified local balance coefficients/chances are explicit in
`sunucu/asuma-wind.json`: 1.8 Mystery, 0.9 standard, 1.1 chase, 45% Repulse.
The supplied kit has no autonomous summon; no extra unit is invented.

## Animation and assets

Original assets: `asset/Asuma_Wind_Blade_Full`, source actor 11003911.
MME poses retain per-frame anchors and convert 24 fps to the 25 fps battle clock.
Lossless atlases deduplicate repeated frames; original SWF effect symbols retain
their native layers/blending instead of flattened full-screen videos:

- `asima-fykc.swf`: `feiyankc` (Mystery)
- `ASIMA2hit.swf`: `erdaoliu` (standard)
- `ASM_huijishao.swf`: `feiyan` (chase, delayed to the source effect event)
- `ASIMAentry.swf`: `rc` (Courage)

Effects follow the caster's target contact offset and mirror for the opposing
camp. Serial checks and removal listeners clean layers after interruption,
reset, character removal or action completion. Only Asuma's dispatch is added.
283 existing TRole methods and the original non-code SWF artwork are verified
unchanged. The checked-in original Mid-Autumn composite source is reused to
avoid corrupting its nested loops during decompiler/compiler round trips.

## Validation and release

- `node sunucu/tests/asuma-wind.test.js`: both camps, Chakra/cooldowns, target
  cap/front-row rules, chase/Blindness/immunity, full-HP aura lifecycle, no double
  aura, physical-only damage, 15 positions, item mappings and finite combat reports.
- `node sunucu/tests/naruto-recruit-items.test.js`: using the real token recruits
  the matching hero; duplicate/bulk/forged uses preserve inventory.
- Existing Physical scaling, Tobi, Tsunade and Mid-Autumn combat tests pass.
- `validation/native/result.json`: 8 hidden Flash component casts (4 moves ×
  both camps), no runtime errors or leftover layers. This is a component preview,
  not an authenticated gameplay recording. Screenshots are in the same folder.
- Client release **2026110102** uses fresh table/texture URLs and preserves all
  previously released client features. Tests never edit real account saves.

Restart services and reopen the launcher once to load the new hero and client.
