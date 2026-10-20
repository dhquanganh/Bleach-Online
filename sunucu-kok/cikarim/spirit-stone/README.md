# Spirit Stone receipt / native client 2026102012

Root cause: `TProcessorBackpack.PerformPacket_SC_InventoryNtf` updated existing inventory instances and mounted equipment, then discarded unmatched instances. The backend consistently uses this notification for shop rewards, chest loot and event awards. A newly acquired Spirit Stone template therefore persisted on the server but did not enter the visible `FCharacter.Gems` collection until a full bag reload. Previous backend-only tests validated balances and packets but could not detect this missing client insertion.

The native handler now inserts an unmatched, positive-quantity inventory into its corresponding bag after all existing-bag and mounted-equipment update attempts. It uses the original `TInventories.Add` reference ownership and native sorting. Clearing the packet's scratch collection retains the bag's reference. Repeated notifications update the existing instance; zero quantities create no new entries. Temporary inventory remains separate. The same correction also covers newly received normal items/materials and equipment without duplicating mounted items.

Only the backpack notification handler and its new insertion helper change. `build-client.py` recompiles the class against the current client, compares every other original class method, preserves all non-ABC tags, saves backups, and installs protected canonical/alias SWFs with version 2026102012. Battle animation assets/code are outside this patch. No player inventory is modified or compensated: reloading the game reads previously persisted items normally.

Validation:

- `node --test sunucu-kok/sunucu/tests/spirit-stone.test.js`: real shop purchase, gold deduction, Spirit Stone box opening, exact stone balances, consumption, inventory notifications and persistence in an isolated account directory.
- `node --test sunucu-kok/sunucu/tests/anniversary-feast-handler.test.js`: all 42 shell awards and 24 point-shop awards still persist with correct packets.
- `build-probe.py` extracts the actual production insertion/update methods. `runtime-electron.js` executes them with the native inventory classes in Flash 22, reproduces the original drop, and passes 11 assertions for new stones, existing total quantity, multiple templates, zero quantity, normal/material items, reference retention and temporary bag separation. Evidence: `validation/native.json`. This is a native component test, not a complete interactive game session.
- The broader legacy `usable-items.test.js` fails its pre-existing EXP fixture at line 13 before reaching chest tests; it reads mutable live baseline fixtures. No unrelated EXP code was changed. The dedicated isolated Spirit Stone test passes.

Reload the game to fetch the new version. This patch needs no backend restart because the fix is in the Flash client.
