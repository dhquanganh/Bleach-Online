# Real town presence

The captured `CS_LOBBY_Town_Move` mapping returned `SC_LOBBY_Town_NewRoleNtf`, replaying the sample Reika each time the player moved. The gateway now handles town entry, movement and a map-ready resync directly; these requests never fall through to captured actor packets. Static town NPCs remain part of the normal scene.

`town-presence.cjs` maintains a shared roster only from authenticated game-worker connections currently in the town. Merely opening the launcher/starting a worker does not make an account visible. The parent reads identity/appearance from that account's own saved files and verifies the worker's public-profile role IDs. Each account appears once; expired sessions, disconnects, worker exits and stale heartbeats remove it. Self is excluded. Unchanged rosters are not repeatedly pushed.

Workers compute public inspection snapshots using their own account/stat context. Town profiles override an older Arena profile and are cleared independently when the actor leaves; no wallet/password/private state is broadcast. Existing native click/context-menu inspection uses the exact role ID and live public character/equipment data.

Native actor packets carry actual ID, name, protagonist, rank, level, equipped titles and saved rebirth. Movement only sends RoleMove, and metadata changes remove/replace the existing actor. Initial coordinates are encoded in an otherwise unused negative BirthID range. Coordinates are limited to the native signed-short range. Offline/out-of-town accounts do not appear.

Client release **2026102516** patches two classes on the reviewed current client:
- RoleCanControlTwo uses separate title counters, fixing corruption/truncation when a batch contains multiple actors with titles.
- MainScene waits for map data, clears old remote actors, announces its spawn and requests an authenticated fresh roster after map load. The request is idempotent (remove/re-add, no duplicates).
- Initial peer locations use server-provided coordinates; ordinary actor click handling is preserved.

Rebuild: `python sunucu-kok/cikarim/town-presence/build-client.py`. It refuses unrelated canonical client changes. Non-ABC SWF tags are verified unchanged, and compiled methods are re-exported for inspection/tests. Existing title and Myoboku fixes are retained. Restart the server/launcher once and reconnect to load the new gateway/client code.

Validation: 28 combined authentication/profile/title/presence checks passed. The eight presence checks include an actual two-worker TCP game-protocol test: token authentication, enter/leave town, real identity packets, movement without NewRole replay, exact-role inspection and disconnect removal. The compiled AS3 method-body tests cover mixed title counts across three actors, map-ready gating, normal clicks and packed coordinate decoding. Integration fixtures use isolated temporary accounts/files; no existing player account was modified. Full interactive Flash gameplay was not automated.
