# Ryoka Attack repair

Native Flash scene and real battle simulation; event type 8, module 0x3400.
Open all day as requested. Each account has a persistent personal 30-minute run,
up to 100 waves of five monsters from the original Enemy table. Re-entering
preserves surviving monster HP, damage, cooldown, death timer and end time.

Damage grants Silver (damage/100, cap 50,000), EXP (damage/250, cap 20,000)
and Souls (damage/5,000, cap 1,000), rounded down with a minimum of one for
positive damage. A kill grants one Common Material Chest (14800020), or an
Epic Material Chest (14800022) on waves divisible by five. No reward on entry,
invalid requests or repeated attacks during cooldown. Currency overflow and
item overflow reject the battle. Failed state saves restore currency.

This implementation does not provide server-wide shared monsters, cross-account
rankings, clan ranking mail or offline auto-registration. The native list and
clan scores describe the personal run; frontend descriptions explicitly say so.
The existing native auto-movement and auto-battle options remain available.

Client fixes: decode the report before setting IsInBattle; suppress duplicate
fight requests; postpone monster/death/wave/end updates until battle return;
restore entry HP and scores; show accurate death expiry and revive cost;
clear the pending request when mounting after battle; avoid unsigned timer
underflow. Revive uses gold then coupons, at the native escalating rate for
each remaining ten seconds. Natural revival remains free.

Validation:

```
node --test sunucu-kok/sunucu/tests/ryoka-attack.test.js sunucu-kok/sunucu/tests/guild.test.js sunucu-kok/sunucu/tests/protect-seireitei.test.js sunucu-kok/sunucu/tests/protect-balance.test.js
python sunucu-kok/cikarim/ryoka-attack/build-client.py
python sunucu-kok/cikarim/ryoka-attack/release.py
```

Client sources are exported from the current canonical SWF, never from an old
character build. Release asserts all non-code SWF tags are unchanged, verifies
the re-exported patched classes and publishes native table strings at fresh
resource URLs. Backups are in `release-backup`. Visual in-game validation has
not been performed in this session.
