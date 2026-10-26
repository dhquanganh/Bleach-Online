# Zanpakuto repair

Client release: 2026102605. `sunucu/zanpakuto.js` owns all five native handlers (information, activation, training, materialization and Fortify). The old free-unlock/free-strengthen stubs are removed. A fresh account has no activated swords. Activation consumes one actual handbook, checks Reiatsu, and cannot be repeated. Existing trained or purchased swords and legacy materialization records are migrated by relation ID without granting unrelated swords.

KnifeExpand's exported column names are shifted: `quality` is the Reiatsu requirement, `knifeSoulAdded` is the quality, `normalExp` is the normal Soul cost, `goldExp`/`needExp`/`f10` are front/middle/back materialization bonuses, and `f11`/`f12`/`f13` are normal EXP / gold EXP / required EXP. Gold training costs the native constant 10 gold per attempt. Native batches are 1 or 50. Training validates the current form and next form's Reiatsu gate, carries EXP, synchronizes an equipped form on advancement, and stops at form four. Failed saves roll back the currency snapshot, including spending event ledgers; item mutations happen on a cloned player state.

Fortify uses ConfigValue 61100002 (fossil 14100592), opens at level 45, and follows KnifeStrengExp costs and the native 10/50/100 balanced-attribute gates. The client displays base+level*growth. Following its native help text, Fortify attributes and phase passives apply to PvP only. PvE and PvP attribute blocks are calculated separately, and account snapshots carry the PvP block/passives for matches on other workers. Materialization bonuses and scheduled sword skills work in both modes. Fortify phase hero bonuses are associated with the named hero and highest achieved phase.

`sunucu/zanpakuto-combat.js` schedules all 96 forms using KnifeExpand's rounds and SkillConfig's attack coefficient, targets and described effects. Attacks use total living formation Physical ATK and physical defenses through the shared combat engine. The two old ignite/poison descriptions omit a tick coefficient; their default is 3% of formation ATK, while explicitly described burn/mutilation values use their catalog percentages. Benihime's immunity and Ichimonji's permanent bonuses cannot be dispelled. Battle groups identify the selected sword, and ordinary battle records use the native sword position 100. Native Alliance MiniBattle intentionally shows squad leaders instead of individual formation/sword models.

Login patches the two sword/Reiatsu IDs AFTER the variable-length FreshGuide UTF string. The rest of the character packet remains untouched. Native frontend fixes guard the optional power callback, reset phase activation correctly, block training a maximum form, and show Fortify success only after the server response.

Validation:

- `node --test sunucu-kok/zanpakuto.test.cjs` from the workspace root.
- Accessory, Alliance, physical-scaling, Reiatsu and level-stat regression suites.
- `python cikarim/zanpakuto-audit/build-client.py` is a guarded one-time build from the 2604 source; it preserves every non-ABC SWF tag. Do not overwrite a later client with this baseline.
- The native preview uses a temporary MongoDB account and a separate probe SWF redirected only in its hidden Electron session. Probe callbacks are not in the released client. Build the probe with `python cikarim/zanpakuto-audit/build-probe.py` from sunucu-kok, then run `node sunucu-kok/cikarim/zanpakuto-audit/native-preview.cjs` from the workspace root. Remove the temporary public probe directory after use. Native screenshots are kept in this directory.

Final verification: 49 selected regression checks passed (see `verification.log`), including 12 Zanpakuto checks. The Flash preview confirmed activation, selection, Fortify level 2, both training types (22 EXP, 10 gold and 140 Souls consumed), then completed an ordinary battle with the Benihime model, background/skill effect and WINS dialog (`native-preview-battle-complete.png`). Temporary accounts, sessions, runtimes and public probe assets were removed.

Pre-existing unrelated check: `sunucu/tests/cross-server.test.js` fails its hero-offer assertion at line 39 with both the working copy and the HEAD Cross Server module. The dedicated sword-exchange test passes and confirms that purchase information contains owned swords only. The full hero-offer failure is not counted among the 49 passing checks.
