# Character tags

Itachi Road to Ninja (`11120960`) has, in order: Fire (26), Male (52),
Konoha (1), Akatsuki (11), Blood Limit (14), Uchiha Clan (31), and
Secret Jutsu User (48).

Mecha Naruto (`11120950`) has Wind (27), Male (52), and Confusion (12).
Its `tagNames` override retains the screenshot's name "Confusion" for the
question-mark icon that the source asset catalog translates as "Mystery".

Sasuke Shinden (`11120970`) has Lightning (28), Sasuke Shinden (61), Male
(52), Konoha (1), Hidden Sound (3), Akatsuki (11), Blood Limit (14), Uchiha
Clan (31), Rinnegan (46), Secret Jutsu User (48), and Sword User (49).
Its `tagNames` override uses "Hidden Sound" for the catalog's "Sound" icon.

Obito Rage (`11120920`) has Fire (26), Male (52), Konoha (1), Blood Limit
(14), Uchiha Clan (31), and Secret Jutsu User (48).

Gaara Swimsuit (`11120991`) has Wind (27), Swimsuit (64), Male (52),
Hidden Sand (2), Jinchuriki (13), Kage (18), and Allied Shinobi Forces (57).
Its `tagNames` override uses "Hidden Sand" for the catalog's "Sand" icon.

Hashirama Final Battle (`11120940`) has Earth (30), Male (52), Konoha (1),
Kage (18), Blood Limit (14), Senju Clan (32), Secret Jutsu User (48),
Sword User (49), and Senjutsu (58).

Pain Tendo (`11120930`) has Lightning (28), Male (52), Hidden Rain (6),
Akatsuki (11), Blood Limit (14), and Rinnegan (46). Its `tagNames`
override uses "Hidden Rain" for the catalog's "Rain" icon.

Naruto Sage (`11120901`) has Wind (27), Male (52), Konoha (1), Jinchuriki
(13), Uzumaki Clan (47), and Senjutsu (58). These tags are assigned to
Naruto's hero record; the summoned Shadow Clone is unchanged.

Nagato Frog Squad (`11120990`) has Wind (27), Male (52), Hidden Rain (6),
Blood Limit (14), Rinnegan (46), and Uzumaki Clan (47).

Tsunade Asian Style (`11120992`) has Water (29), Asian Style (67), Female
(54), Konoha (1), Kage (18), Senju Clan (32), Secret Jutsu User (48), and
Allied Shinobi Forces (57). Its name override uses "Asian Style" for the
catalog's "Chinese Style" icon.

The sources of truth are `sunucu/itachi-rtn.json`, `sunucu/mecha-naruto.json`,
`sunucu/sasuke-shinden.json`, `sunucu/obito-rage.json`, and
`sunucu/gaara-swimsuit.json`, `sunucu/hashirama-final.json`, and
`sunucu/pain-tendo.json`, `sunucu/naruto-sage.json`, and
`sunucu/nagato-frog.json`, and `sunucu/tsunade-asian.json` → `tags`.
All ten hero build scripts retain
these IDs in generated `BaseHero.json`.
The fixed native binary table schema is unchanged. `build.py` generates the
client tag metadata from the same configuration and the asset tag catalog;
the generated metadata is also saved at `/public/character-tags/heroes.json`.
PNG files are exact copies from `asset/All_Character_Tag_Assets`.

The native `TWindowAttribute` adds a 140×20 row immediately after the PVP
attribute tab, in the blank header space. Each icon uses the existing native
hint overlay to show its English tag name. Switching heroes clears the row
and hint; heroes without configured tags show no icons. The row is hidden
on the awakening view, where the third attribute tab uses the same space.
Rows with more than seven tags scale their icon slots uniformly to fit the
same 140-pixel width; eleven tags use approximately 12.73-pixel icons,
vertically centered. Itachi and Mecha retain their original 20-pixel icons.

The other-player profile (`TProcessorWindowPlayerAssets`) displays the same
tag row immediately after `BtnPvP`, using its own selected hero from `FHeros`.
Changing heroes/pages updates the row; resetting the profile removes icons
and the active hint, including before first initialization. Untagged heroes
show an empty header. Both profile attribute tabs share the same tag row.
The existing profile hint callbacks handle hover/out. Future builds update
both the own-hero and profile metadata from the same source configurations.

Installed client: `2026102418`. The release pointer, bootstrap, and resource
manifest are updated together. Reload the game to load the new client.

Validation: native AS3 compilation/decompilation, original icon byte checks,
all 34 existing methods preserved (allowing only redundant Number/String
casts introduced by FFDec), non-script SWF tags preserved, unchanged hero
records except Itachi's added tags, and the Itachi combat regression suite.
The Mecha combat regression suite also passes. Full interactive login and
hover were not exercised in a full logged-in session. The isolated native
Flash profile component passes 33 checks covering selected hero changes,
hover/out for all Pain tags, long rows, unknown/null heroes, reset/reopen,
relative placement and successful loading of original PNGs. This probe uses
the production tag methods with a minimal profile host and hint callbacks.
Run `probe-profile.py`, then `run-profile-probe.js` with the bundled Electron
and `ELECTRON_RUN_AS_NODE` unset. Results are in `2026102416/probe-result.json`.

`python sunucu-kok/cikarim/character-tags/build.py` builds and installs onto
the current client. For an existing tag row it replaces the generated
metadata initializer and row renderer, preserving all other methods. Existing backups are
never overwritten. Versioned build folders retain `original`, `patched`,
`verify`, and `backups` as implementation and recovery artifacts.
