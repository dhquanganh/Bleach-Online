Myoboku native entry recovery: client `2026102505`.

The original Myoboku releases 2026102501/2502 published their client aliases
and client-release.json, but left the legacy 2026090619/TApplication.swf
unchanged. The subsequent Naruto patch read that legacy file and therefore
lost the two Myoboku lobby changes when publishing its client.

`recover.py` imports only the reviewed 2502 TProcessorLobby class onto the
current 2504 client. Only existing IllusionConstruct and IllusionUpdate
change; all other lobby methods compare equal. Myoboku occupies the first
event slot and Boss remains 68 pixels to its right. The openMyoboku bridge,
event UI/backend, configuration and account data are retained. The current
Naruto native Rasengan methods remain in the compiled client.

Both current and legacy client/manifest paths are synchronized. Naruto's
publishers now reject a source when the canonical client differs from the
release selected by client-release.json. Future client edits must resolve
the active release first; do not assume the legacy path is authoritative.

Validation: `node --test sunucu-kok/myoboku.test.cjs
sunucu-kok/myoboku-ui.test.cjs` passes all five tests, including Electron
layout/entry-dialog behavior, spinning, reward persistence and recovery.
Native export checks verify the restored entry and preserved Naruto methods.

Layout correction `2026102506`: both custom icons move left by 72 pixels.
Myoboku is at anchor.x - 72, Boss at anchor.x - 4. The anchor is 72 pixels
left of the native gift button; with 64-pixel click areas this leaves a
4-pixel gap between custom icons and 12 pixels before the gift button.
Only IllusionUpdate changes; entry callbacks, availability and event data
are retained. See `naruto-nine-tails/wide-portrait.py` for the current patch.
