# Soul King Palace Refinery fixes

- Apply the ProfessionRefine table rates to physical/magic attack, physical/magic defense, HP and speed of heroes of the matching profession. Level 1 grants 0.7%. Bonuses flow through stat packets, login and combat. Speed is now read by combat and determines initiative, with camp/slot order as the tie-breaker.
- Upgrade consumes the exact next-level Blood Stone cost, validates max level, saves before notifying the client, and pushes fresh stats to affected owned heroes.
- Breakdown validates the full request and each distinct gem stack before charging Silver. Products and costs are computed from gem level and the full selected quantity, matching Flash. Insufficient balance, invalid gems, duplicate requests and storage overflow do not consume materials. Save failure refunds Silver.
- Flash receives absolute levels, updates storage live, disables pending submissions, refreshes new gem stacks and Silver/product previews live, prevents overflowing the Blood Stone stack, and guards maximum level.

Run from the project root:

```powershell
node sunucu-kok/sunucu/tests/refinery.test.js
python sunucu-kok/cikarim/flash-refinery/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
```

The build verifies the compiled AS3 and unchanged non-code SWF assets, then installs with a backup under `backups/`. It uses the current live SWF so previous fixes remain present. Restart game/backend once after installation. Automated tests exercise real stats and combat plus in-memory transactions; direct interactive Flash validation remains manual.
