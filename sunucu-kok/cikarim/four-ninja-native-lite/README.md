# Native effects for Sasuke Shinden, Mecha Naruto, Itachi RTN and Gaara Swimsuit

Client release: `2026102707`, based on the active `2026102706` client.

The effect player now instantiates the supplied SWF symbols, as Tobi Great Ninja War does, instead of downloading and decoding paged raster animations. Each source SWF has its own ApplicationDomain, is cached by URL, and uses the battle frame clock. The four characters retain their own effect lists and active-layer cleanup. Existing movement, attack timing, model selectors, effect placement, mirroring, camera and fade settings feed the native player. Gaara's baked radial edges are reproduced with a live radial alpha mask around the cropped native movie.

| Character | Previous active effect payload | Native effect payload | Reduction |
|---|---:|---:|---:|
| Sasuke Shinden | 72.03 MiB | 24.95 MiB | 65.37% |
| Mecha Naruto | 180.89 MiB | 21.83 MiB | 87.93% |
| Itachi RTN | 301.24 MiB | 21.53 MiB | 92.85% |
| Gaara Swimsuit | 66.69 MiB | 7.34 MiB | 88.99% |

The total effect payload falls from 620.86 to 75.64 MiB (87.82%). These numbers count files the active effect loaders request, including Sasuke's already-native Kirin impacts and cinematic movies. They do not count actor textures, the shared client, or historical unused files retained in older public directories. They are download sizes, not measured FPS gains.

`native-manifest.json` retains the installed world rectangles, pivots, duration, blend mode, tint and edge treatment for 52 layers. `actor-baseline.json` checks all 28 model textures, including idle/profile, byte-for-byte. The 29 newly served SWFs are exact copies of the user's source assets. No frames are dropped or converted to JPEG. Direct URLs use a new `ninja-native-lite/v1` namespace to avoid old caches.

The patch changes the four preload and four playback methods. It also repairs three Sasuke cleanup methods: interrupted Kirin movies stop without changing their display list during REMOVED_FROM_STAGE, and the white screen-flash layer no longer removes itself recursively. This fixes Flash error #2094 during cancellation. Normal movie completion keeps its existing object pool.

Build order from the captured pre-update client:

1. `capture.py`, `prepare.py`, `build-client.py`.
2. `build-probes.py sasuke` (repeat for `mecha`, `itachi`, `gaara`).
3. Launch bundled Electron with `ELECTRON_RUN_AS_NODE` unset: `oyun/electron.exe sunucu-kok/cikarim/four-ninja-native-lite/runtime.js mecha`. Repeat each character with `NINJA_SPEED=2`.
4. `verify.py --probes`, then `release.py`.

The Flash component probes use the production actor textures and production effect methods. They cover both camps, all skills, base idle, persistent Mecha form, Itachi's crow decoy, cancellation and immediate repeat at x1 and x2: 180 cases total. They require zero HTTP/runtime errors and zero remaining effect layers. They do not log into a user account or constitute a full interactive gameplay recording. Five combat/presentation regression suites pass; client validation preserves 204 other methods, including Tobi, Kakuzu, Hashirama and revival handling.
