# Pain / Hashirama consecutive damage hits

Client **2026101971** retains the paged HD assets and every existing character, speed and Inspector fix. No textures are rebuilt by this change.

All 15 damaging moves have four or five impact frames. Pain's Standard, base Almighty Push, Chakra Rod and Laser have four; Extreme, Final and Super Almighty Push have five. Hashirama's Taijutsu, Sword and Adamantine Fist have four; both Mysteries, both Severe Thousand Hands variants and Wood Golem have five. Support actions retain their existing behavior.

The battle protocol transmits total damage once per target per cast. The native client now deducts HP and shows damage at every impact marker. For hit `i` of `n`, integer damage is `floor(total*(i+1)/n) - floor(total*i/n)`. This preserves the exact authoritative total, including very small and very large damage. Death checks run at the last impact. Defensive resolution, resource costs, cooldowns, passive effects and chase scheduling remain per cast, avoiding duplicate target vectors, repeated costs or multiplied passive stacks. Existing combo counts remain unchanged.

`ninja-multihit.py` owns the frame schedules and updates existing JSON and native Bin packages, preserving unrelated records. Both character asset preparers and installers share its timing/effect generation. Server configs record `hitCount`; damage continues to scale from Physical ATK using the existing total coefficient.

Install after any older client/asset build:

```powershell
python sunucu-kok/cikarim/ninja-multihit.py
python sunucu-kok/cikarim/install-multihit-client.py --ffdec "path/to/ffdec.jar"
```

Verification: `sunucu/tests/ninja-multihit.test.js` checks all 15 moves against actual damage resolution in both camps with/without shields. The existing nine combat suites pass. Both asset decoders verify 3,746 installed frames and the new impact markers. `verify-multihit-native.py` builds an isolated Flash probe; `runtime-multihit.js` runs 270 numeric cases through the production AS3 helper, including zero/tiny/large totals, healing and legacy single-hit behavior. The full TRole, TActive, TBattleHandle and Inspector class sources are unchanged by recompilation.

Restart Node and reopen the game to load the updated configs, native databases and client.
