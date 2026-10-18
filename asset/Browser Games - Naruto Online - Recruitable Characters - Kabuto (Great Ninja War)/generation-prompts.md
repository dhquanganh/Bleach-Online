# Kabuto / Edo Tensei asset generation

Built-in `image_gen` was used (not API/CLI fallback). Four selected original RGBA sheets were copied into `atlases/` and remain unchanged. `portrait.png` is the user's original **68×69** supplied image, obtained from the copied bitmap and visually verified. A generated portrait preview was superseded by this exact supplied icon and is not used in the game. Slicing, registration, native packing and optical-flow in-betweens are deterministic local processing in `sunucu-kok/cikarim/kabuto-gnw/prepare-assets.py`.

## Final prompt set

Shared specification: production 2D Naruto Online browser-game sprite atlas; crisp dark ink outlines and flat cel shading; exactly four columns and four rows of equal cells on a square transparent canvas; chronological discrete poses; same three-quarter camera facing right; consistent scale and baseline; full bodies and effects inside each cell; generous transparent gutters; no text, labels, UI, grid lines or scenery. Requested square 1536×1536; the tool delivered 1254×1254 RGBA sheets, so the packer measures the actual image dimensions instead of assuming the requested size.

1. **01-kabuto-movement.png** — Kabuto Great Ninja War/Sage White Snake. Lean adult, pale skin, short shaggy silver hair, round glasses, yellow snake eyes, subtle sage horns, bare chest, large white segmented snake coiled behind shoulders, deep purple cropped trousers, pale shin wraps and dark sandals. Row 1: four subtle breathing idle poses. Row 2: four forward close-combat running strides. Row 3: recoil, stronger recoil, recovery, idle. Row 4: lying, kneeling, rising, standing idle. Preserve the identity and outfit in every cell.

2. **02-kabuto-combat.png** — Use the first atlas as identity/style reference. Row 1: blue chakra gathering in hands, stepping palm slash, low follow-up slash, idle; hand-to-hand attack rather than projectile. Row 2: hand seal, palm to ground, white snake rising with violet aura, idle. Row 3: coiled stance, snake rears/open mouth, luminous white sphere with sonic/violet rings, idle. Row 4: green healing hands, violet reanimation sigil, ground summon, upright green healing sparks. Do not change body proportions or camera.

3. **03-mu.png** — Mu, Second Tsuchikage, Edo Tensei mummy ninja, full off-white/gray bandages with narrow dark eyes, dark sleeveless slate tunic, dark cropped trousers and sandals, two swords strapped on back. Row 1: four slightly floating idles. Row 2: earth-chakra preparation, palm strike, dust sweep, idle. Row 3: hand seal, ground seal, small upright coffin, lid opening with white smoke. Row 4: recoil, stagger, recovery, idle. Same Mu in every cell, no face skin or other characters.

4. **04-edo-summons.png** — Row 1: Edo Deidara, blond side bangs/ponytail, dark red high-collar reincarnation outfit; prepare clay bird, throw, orange clay blast, recover. Row 2: Dan Kato, long pale blue hair, green-gray flak vest and dark shinobi clothes; idle, seal, cyan spirit extending forward, recover. Row 3: Pakura, green bun/orange fringe, dark green backless top, wrapped forearms and dark trousers; idle, gather scorch spheres, throw three spheres, recover. Row 4: standalone white snake coil/head, violet poison smoke, closed wooden coffin, open coffin with white smoke. No labels, all silhouettes contained in cells.

5. **Discarded portrait preview** — Small square Kabuto icon based on the user-provided portrait beside the skill image. Tight silver-haired face crop, round glasses, very pale face, yellow snake eyes, subtle sinister smile, head three-quarter right, gray-purple high collar and muted dark background. Match the reference composition and linework closely; no new text, labels, elaborate frame, border, other characters or sprite sheet. This preview was replaced by the original supplied image for the final `portrait.png` and native 48×48 icons.

Generated source filenames retained for provenance:

| Project asset | Built-in generated filename |
| --- | --- |
| Movement | exec-af0ace65-892b-45fc-a778-7ea91f99c35f.png |
| Combat | exec-9d9e5da2-de24-4e6f-8e1f-bae8ed3855ae.png |
| Mu | exec-c0c04fa1-237a-4c91-8399-7988033c36bc.png |
| Edo summons | exec-5d5a5a26-c9e9-407c-b3be-91a50b08f2fb.png |
| Superseded portrait preview (not used in game) | exec-927c510e-3bdd-45fa-9ab0-4c834150bfcd.png |
