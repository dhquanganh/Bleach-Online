# Soul Stone frontend repair — 2026102234

Four classes are patched from the current live application export, preserving
the earlier equipment-reference/slot redraw fix and all non-code SWF tags.

- Route combine and mosaic replies to their requesting scene, independent of
  the currently selected window tab. Error replies also refresh/unlock it.
- Release combine waits on errors/cancellation. Keep the success animation's
  wait guard until its final frame; an idle final frame cannot unlock a request.
- Ignore empty mosaic slots and repeated mount/unmount clicks during a request.
- Clamp socket loops to actual UI slots and reset/clamp filtered backpack pages.
- Recheck combine stock before sending; clamp counts to the signed-short packet
  limit and reject missing selections/missing upgrade definitions.
- Restore the VIP hint when switching from an eligible account to an ineligible
  one; callbacks absent from the UI cannot leave it waiting forever.

`patch.py` edits fresh exports under `original/scripts`. `build.py` imports only
the four classes into `source.swf`, verifies the result and saves the previous
protected application as `TApplication.before.swf`. `release.py` uses the existing
cache-safe publisher and publishes the launcher pointer last.

`sunucu/tests/soul-stone-frontend.test.js` executes the patched method bodies;
`SOUL_STONE_UI_SOURCE` can point to the decompiled compiled SWF classes to repeat
the same checks. Coverage includes empty slots, repeated requests, failed replies,
tab-independent routing, input bounds, cancellation, excess socket data and
backpack pagination after the last item disappears. The existing
`soul-stone-ui.test.js` covers the earlier replacement-equipment/last-stone redraw.
These checks do not replace an interactive Flash session; no player save is
modified by them. No backend formulas or Soul Stone costs are changed.
