# Old release-folder cleanup

`2017112917` is the base resource depot and an explicit SWF/texture fallback in `serve.mjs`. The current resource manifest still points at 8,903 keys in that version. Its contents, all original pre-202610 versions, the canonical `2026090619` folder and active `2026102707` folder are preserved.

The cleanup selects only unused release entry files (`TApplication.swf`, `index.swf`, `version.swf`) and unused `Resources/Bin` snapshots in older 202610 releases. Every exact path in the active resource map is protected, as are language substitutions that the server can select. Art, textures, SWFs under `Resources/Swf`, maps, sound and all other fallback resources are preserved in every version. Folder names alone do not indicate whether an asset is obsolete.

Run `cleanup.py` for an audit, or `cleanup.py --apply` to archive and clean. The backup is `.tools/version-archive/2026102707-unused-snapshots.zip`. ZIP entries use paths relative to `public`, with sizes and SHA-256 checksums in `MANIFEST.json`. The complete archive and every original are verified before deleting any file, and the active manifest/client hashes are checked again before and after cleanup. Only empty, explicitly eligible version directories are removed.

To recover a historical client or rebuild an old patch that explicitly references a retired release, extract the archive into `sunucu-kok/kaynak/login.gogames.me/public`. The backup is outside the public game distribution. Clients should load the current release rather than a retired historical entry point.
