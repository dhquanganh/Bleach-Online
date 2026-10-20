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
