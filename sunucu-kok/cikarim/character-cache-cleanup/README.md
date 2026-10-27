# Character render-cache cleanup

Character subfolders in `cikarim` hold development sources, exported frames and verification evidence. The game reads installed resources from `kaynak/.../public` and runtime tables/opcode data from `cikarim/veri-json`, `veri-json-yedek` and `db`.

`cleanup.py` audits generated image caches for thirteen explicitly listed characters. `--apply` removes only images under `frames`, `native-export`, `native-export-hd`, `gale-hd`, `surf-hd`, `camera-export` and `portrait-export`. It excludes backups, `original`, `patched`, `source-config` and `validation`, and checks the corresponding original SWF asset directory exists before removal.

Scripts, JSON configuration/manifests, source XML, captured/compiled SWFs, AS3 source, backup files and verification screenshots/reports are retained. The complete runtime JSON/backup-table/opcode directories and active client are fingerprinted before and after cleanup.

These are regenerable caches and are removed directly to reclaim disk space. To rebuild animations or rerun checks that depend on exported PNGs, rerun that character's preparation/render steps first. Cached `complete.json`, `export-complete` and `render-complete.json` markers are invalidated where images were removed so exporters do not skip missing renders. Their former contents are retained in `removed-render-markers.json` as rebuild metadata. Do not delete all of `cikarim`: it also contains live server data.
