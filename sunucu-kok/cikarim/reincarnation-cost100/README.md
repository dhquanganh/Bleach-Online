# Reincarnation: 100 partner fragments — client 2026102109

Partner reincarnation now requires and consumes 100 of the mapped Modify Fragment
instead of 50. Main-character exemption, reincarnation stones, EXP, star-upgrade
requirements and other costs are unchanged.

The current live client is patched only in TProcessorWindowHeroRebirth: available
fragment check, requirement line, item tooltip quantity and both insufficient-item
messages use 100. Other window methods/non-code SWF tags are checked after compile.
Character animation classes and textures are not imported or regenerated. Previous
model/Bin version routes are retained. Backups are in `backups/`.

The existing reincarnation test confirms rejection at 50 and 99, exact deduction at
100, and the main exemption. Its later unrelated battle-HP assertion fails with
247746 vs 247021. Running the unmodified HEAD reincarnation module and test against
the same workspace reproduces that exact failure, before this cost change. The
complete suite therefore does not pass; the cost checks do.

Restart the backend and reload the game completely to apply both sides.
