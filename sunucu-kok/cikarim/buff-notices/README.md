# Shared character buff float text

Release `2026102809`. All battle actors share the same mechanism; no hero-ID
whitelist is used. `sunucu/buff-notices.json` supplies stable markers and names.

The backend observes effective stat gains, ordinary positive buff applications
and duration refreshes, shield gains, immunity/armor states, private growth
stacks, extra actions, cooldown/cost reductions, transformations and the nine
resonances. Notices target the actual recipient's camp and position. Identical
unchanged state is not repeatedly emitted; decreases, expiration and dead actors
are excluded. Stat snapshots and notices do not spend actions or use RNG.

Snapshots run at battle start, round-start/end and after skill/passive resolution,
so both ordinary table-driven characters and custom Naruto kits are covered.
Only marker packets are added to reports; damage and stat formulas are retained.

The native client shows a multiline label above each recipient for 4000 wall-clock
milliseconds, independent of x1/x2 playback. Multiple different buffs have their
own expiry times. Repeated identical markers refresh that line rather than
creating overlapping copies. Labels live beside the role instead of inside its
mirrored sprite and are cleaned on Reset, scene removal or expiry.

Validation: backend ordinary/custom buff and actual binary-report tests, existing
Naruto/Madara/Minato/physical-scaling/Cross regressions. The six-role native probe
verifies holding through 3 seconds, expiry after 4 seconds, refreshed expiry,
mirroring and reset/removal cleanup. It is a component preview, not a logged-in
account battle. `validation.json` confirms 250 unrelated TRole methods unchanged.
