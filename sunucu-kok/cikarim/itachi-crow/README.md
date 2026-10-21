# Crow Clone visual — client 2026102108

Crow Clone previously played the source crow/substitution effect and SP_skill6,
but did not create a separate visible Itachi decoy. The backend's Crow passive
was already activating; this repair changes its client presentation.

`ShowItachiVfx(13121207)` now creates one decoy beside Itachi, using the existing
native 37-frame idle sequence with its original pixels, pivots, aspect ratio and
facing. It fades in with the source crow effect, animates independently and stays
through the current round. Repeated evasion triggers reuse that decoy. Viewport
clamping keeps it on screen in either camp and at front/middle/rear positions.

The decoy is a visual representation of the Crow buff, not an additional combat
unit: no occupied formation slot, HP pool, extra turn, targeting or damage is
added. Combat logic, resource costs and consecutive-hit totals are unchanged.

The next round command clears the decoy. Owner death, role reset/reuse and stage
removal also clean up the sprite/listeners. Cleanup does not dispose shared native
BitmapData. REMOVED_FROM_STAGE cleanup releases references without removing the
same child again during its removal event.

Only TRole and TBattleStage are imported into the current live client. All other
existing methods are compared after compilation (160 checks), including Mecha,
Pain, damage foreground and consecutive-hit behavior. Textures/native databases
are not regenerated. The previous native database/model URL versions are retained.
The builder refuses an unrecognized already-patched client; its own rebuilds use
the preserved pre-Crow client in `backups/`.

Native component validation:

```powershell
python sunucu-kok/cikarim/itachi-rtn/build-probe.py --role-source sunucu-kok/cikarim/itachi-crow/verify/scripts/Processors/Game/Battle/Character/TRole.as --crow-only
```

Six casts exercise front/middle/rear in both camps. Checks include visible idle
decoy after the Crow animation, no duplicate on repeated triggers, viewport bounds,
death and removal cleanup. The component host uses the actual production VFX/clone
methods and decoded native actor pixels/pivots; the idle texture interface is
adapted for that host. This is not a complete interactive gameplay run.

The runtime runner is `../itachi-rtn/runtime-raster.js` (launch Electron with
ELECTRON_RUN_AS_NODE unset). Evidence is copied to `validation/` after completion.
Reload the game completely to load client 2026102108.
