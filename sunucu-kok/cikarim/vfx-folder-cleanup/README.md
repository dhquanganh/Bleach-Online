# Retired VFX cleanup

The active 2026102707 client uses the `ninja-native-lite/v1` SWFs for Sasuke, Mecha Naruto, Itachi RTN and Gaara. Sasuke's four Kirin movies under `sasuke-vfx/cinematic-v1` remain active too.

`cleanup.py` selects only superseded files in those four legacy VFX folders. It refuses any path used by the recorded 180 successful x1/x2 Flash cases, preserves the cinematic directory, and verifies the exact installed client hash. Other characters and original source assets under `asset/` are untouched.

Run without arguments for the audit, then with `--apply`. The apply step writes a ZIP64 backup to `.tools/vfx-archive/2026102707-retired-vfx.zip`, with original relative public paths and a SHA-256 manifest. It reads every archived file back and verifies every original again before removing any file. Empty legacy subdirectories are removed only after checking they are inside the explicitly selected VFX roots. All active asset requests are checked again afterward.

The archive is outside the public game distribution and is ignored by Git. To restore the old raster resources, extract the archive into `sunucu-kok/kaynak/login.gogames.me/public` (the ZIP's `MANIFEST.json` is backup metadata). Historical clients before 2026102707 require those legacy resources; current clients should be reloaded onto 2026102707.
