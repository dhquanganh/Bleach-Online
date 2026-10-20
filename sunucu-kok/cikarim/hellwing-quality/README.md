Hellwing and Spirit·Hellwing equipment now use quality 7, the highest quality
supported by the existing equipment templates. This covers 16 templates:
Sword, Blade, Rune, Headband, Armor, Cloak, Shoe and Belt in both sets.

Run `python sunucu-kok/cikarim/hellwing-quality/build.py --apply` to reproduce.
The script updates Article.json, items.json and every native Article table in
both client resource versions/languages. Original files are saved in backups/.
Item IDs, icons, base attributes, level requirements and set associations stay
unchanged. Existing equipment instances reference these templates directly.

Verified: all 16 server inventory templates resolve quality 7; 25 native Article
tables contain quality 7 for all 16 IDs; non-quality JSON fields are unchanged;
all six equipment types have existing quality-7 upgrade values/cost support.
Restart the server and reopen the game to reload cached item catalogs/databases.

Frontend sparkle correction: quality alone only changes item quality/color.
`TUnstreamizerEquipment` copies `TBaseEquip.EdgeColor` to `TEquipment.IsEdgeColor`;
inventory and equipment slot query handlers feed that value to
`TUISlot.RenderingPerform_AdvancedEffect`, selecting animation index EdgeColor-1.
The exported BaseEquip JSON labels are shifted: `drillHoleNum` is the native
EdgeColor field, while JSON `edgeColor` is the set association and must be kept.

The builder now sets native EdgeColor=4 for all 16 templates and patches all 25
native BaseEquip copies alongside the quality data. This matches the highest
existing equipment sparkle setting. Both client texture versions include the
original Lobby/00CFAC85.TexClient effect bank; its fourth animation has 7 frames.
Verified all other BaseEquip JSON fields are unchanged, including attributes,
set IDs, sockets and refinement coefficients. No Flash code change is needed.
