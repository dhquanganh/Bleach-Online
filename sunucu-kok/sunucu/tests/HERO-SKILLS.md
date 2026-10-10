Combat skill audit
==================

Run `node sunucu-kok/sunucu/tests/hero-skills.test.js` from the repository root.
The test runs in memory and does not save player files.

The backend now reads active skill damage coefficients and target rows from
SkillConfig, with explicit secondary-effect rules in hero-skills.js. All 148
BaseHero entries (144 distinct active skills), all 204 PartnerChange event IDs,
and all 80 WeaponSkillConfig entries have been inspected. Also covered: 30 Soul
Skill families and their upgraded SkillConfig rows. PartnerChange skills
require the corresponding saved degisim.hero unlock; gear skills require an
equipped instance. Main-hero combat uses the selected, upgraded Soul Skill.

Kido characters' healing uses their Kido attack, then the recipient's recovery modifier;
HP stays between zero and max HP. Healing never revives a dead partner. Pure
healers do not damage enemies. Mixed healing and regeneration use native
Active_PassiveSkill records because their attack animations do not contain
friendhp events. Buffs change server combat values, refresh by skill/source,
expire, and can be cleansed. Fury restoration follows skill-cost payment.

Remaining data uncertainty
-------------------------

The client tables describe effects but do not contain original server formulas.
These local conventions are explicit rather than claims of original-server parity:

- Unspecified proc chance: 50%; "high chance": 75%.
- Level-dependent control: clamp(50% + 2% per level difference + ControlRate,
  5%, 95%), followed by control resistance. Exact numeric chances in descriptions
  use their stated value.
- Unspecified temporary-effect duration defaults to two rounds in active rules;
  weapon stun/silence defaults to one round. Permanent auras last through combat.
- English PartnerChange descriptions 13900113 (shield size), 13900145 (PDEF
  decrease size), and 13900197 (avoid-injury amount) omit numbers retained in
  SkillConfig; these use the corresponding SkillConfig numbers. Other conflicting
  translations follow the English text displayed by the client.
- Passive 13900232 (toxic damage size) and active 13100265 (dodge decrease size)
  omit a numeric magnitude in both available descriptions. These missing effects
  remain unresolved. Active 13100273 uses a local 100% attack coefficient for toxic
  damage because the description does not state its coefficient.
- Soul Skills 13100005/13100021/13100037 also omit their healing-reduction
  magnitude. Their attack is implemented; that secondary magnitude is unresolved.
- Existing combat still uses a combined physical/Kido defense for damage. Healing
  now preserves the separate Kido attack value. Profession-specific aura effects
  use the class filter but their defense bonus operates on that combined defense.

Live Flash animation playback is not covered by Node tests. Packet tests check
native record types, complete serialization, and exact HP/fury conservation for
all heroes plus a full multi-round healing battle.
