# Reincarnation: core stats and partner fragments

Every stage adds 100% core attributes: multiplier `1 + stage` (stage 1 x2, stage 2 x3, stage 5 x6), including equipment and Soul Stone attributes, then Refinery is applied with integer rounding. Applies to both PvE/PvP stat blocks, BattlePower, login serialization and actual combat via statPaketi. Float rates such as crit/block are unchanged.

Partners additionally consume 50 of their exact HeroChangeAttr fragment (raw table chipValue is the client ChipID field). Main character needs no fragments, explicitly chosen by the user. Both stone and fragment balances are checked before either is spent. A partner without a configured fragment cannot bypass the requirement.

Flash shows fragment icon, owned/required counts and current/next core bonus; confirmation rechecks the count, and material changes refresh while open. Existing authoritative level/EXP response handling and pending guards are included. Only reincarnation classes are imported into the current live client; Tower of Gold is preserved.

Test: `node sunucu-kok/sunucu/tests/reincarnation.test.js`.
Build: `python sunucu-kok/cikarim/flash-reincarnation-fragments/build.py --ffdec PATH/ffdec.jar --install`.
Build decompiles/validates the result and checks all non-code SWF tags remain unchanged. The installed SWF is backed up. Restart backend and game. Interactive Flash UI still requires manual validation.
