Shinigami Academy (Spirit School), native requests 0x01811406/07.

Preserves existing level and EXP. Three daily free cultivations reset at UTC+7 midnight, then each paid cultivation consumes the configured ten Shino Pills. Cultivation grants the existing 100 EXP; batch processes only affordable turns, up to fifty. Level 72, VIP 3 for batch, and level 500 cap follow native ConfigValue rows. State, pill deduction and EXP are prepared on a clone, saved before sending inventory/stat notifications. Save failure changes nothing.

Frontend computes affordable batch size, blocks repeated requests while awaiting response, releases its pending guard on both success and failure, and clamps remaining free turns to zero. Native full bag/stat updates precede the response so all six bonuses and balances refresh immediately. All owned partner attributes are refreshed.

Tests: tests/academy.test.js validates daily reset, free/paid/batch boundaries, strict packet inputs, level/VIP/cap restrictions, atomic rollback and immediate main/partner updates. Native classes recompiled and decompiled; non-code assets unchanged. Both canonical and manifest-selected application paths updated.
