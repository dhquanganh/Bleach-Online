# Soul Stone window and Synthesize — 2026102235

Patch from the live 2026102234 client, preserving prior character/UI repairs.
Five Jade classes are imported; native skin and other non-code SWF tags stay
byte-for-byte identical.

The earlier repair still let `Update()` consume a stale result when the window
tab changed. Both scenes now distinguish an actual response (`FReplyReady`)
from a refresh. Auto-synthesize additionally distinguishes its confirmation
dialog from a transmitted request (`FRequestSent`). Closing/reopening/switching
tabs preserves outstanding requests until their matching scene gets its reply.

Close hides the window before reset and notifies the parent in `finally`. Parent
close/unmount also hides reliably. The native X button is above both content
panels, and Escape closes while the panel is visible. Reset no longer calls
Perform_Reset/Update while tearing the window down.

Both views use the live Character.Gems collection. Only positive-quantity items
with a BaseStone definition pass the filters. Visible lists refresh when item
quantities/templates change while the panel is open. Equipment page changes
reset the hero selection consistently, old rows are cleared and growing lists
are rebuilt; the first available equipment is selected automatically. A hero
without equipped items gets an explicit empty message instead of a blank list.
This does not give equipment to heroes or expose another hero's equipment.

Synthesis follows BaseStone.nextId on both server and client. The server checks
the exact output inventory delta on a cloned state before consuming ingredients;
full output stacks/bags leave that craft unchanged. Invalid mode/zero count and
invalid stone IDs are rejected. Existing inventory pushes/full-bag refresh still
precede the result so new output stacks can appear immediately.

Checks:
- `sunucu/tests/soul-stone-window.test.js`: execute frontend method bodies from
  patched or decompiled compiled classes (`SOUL_STONE_UI_SOURCE`), stale reply,
  tab switching, confirmation, errors, reset failure and item filtering.
- `sunucu/tests/soul-stone-synthesize.test.js`: actual backend single/bulk/auto
  crafting, output insertion packets, no loss at cap, malformed operations.
- `build-close-probe.py` + `runtime-close.js`: actual native Jade skin and the
  compiled production close-handler body. Hidden Electron sends real mouse
  clicks to the native X in Embed/Synthesize, normally and with a failing reset.
  `validation/native-close/result.json`: 4 closes / 4 cases, no errors. This is
  a component test, not an authenticated full-game interaction.
- The normal HTTP bootstrap verifier checks the released app/version routes.

Rebuild: fresh export -> `patch.py` -> `build.py` -> tests -> `release.py`.
Restart backend for the synthesis change, reload launcher for the new client.
