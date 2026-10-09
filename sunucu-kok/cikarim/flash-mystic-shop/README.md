# Mystic Shop / Nguyen thach

Currency template: **14900001** (Nguyen thach), inventory major type 1, non-usable/non-sellable.
Test offer: **20900001**, **1 Blood War Ulquiorra Fragment (14130055)** for **100 gems**.
Mystic Shop is TimeMall type 1, permanently open, with unlimited exchanges and free catalog refresh.
Black Market type 0 and Hueco Mundo type 2 keep their currencies and limits.

Transactions validate currency and inventory capacity on a cloned player state, save the complete trade, then emit SC_Backpack_LoadBagResult (0x01180f00). Insufficient funds, saturated inventory, malformed requests and save failure do not commit either side. No gold/coupon charges.

Configuration: `../../sunucu/mystic-shop-config.json`. When changing offers or the currency definition, update the corresponding JSON resource tables and rerun `patch-resources.py` to keep native Flash tables in sync. It preserves all existing records and backs up changed packages. New icons use the real TexClient/PAK format and load through the native inventory texture repository.

Build from the current installed client, preserving other feature changes:

```powershell
python sunucu-kok/cikarim/flash-mystic-shop/build.py --ffdec C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar --install
node sunucu-kok/sunucu/tests/mystic-shop.test.js
```

The build checks that only AS3 bytecode changes, then decompiles the rebuilt classes for verification. Runtime interactive Flash testing remains necessary. Restart the backend and reopen the game to load the new client and resource tables; no F5 is needed between exchanges.
