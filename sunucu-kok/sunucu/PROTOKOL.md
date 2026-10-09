# Bleach Online — protokol notları (tersine mühendislik)

Kaynak: `TApplication_dec.swf` decompile (2865 AS dosyası, `tersine/TApp_src`) + canlı yakalama (`yakala/`).

## Koruma
- İstemci SWF'leri **DoSWF** ile korunuyor. `index.swf` içindeki loader:
  - Gömülü binary → XOR-strided (header: A,K,S8,S4) + zlib → mini-loader SWF.
  - Mini-loader `TApplication.swf`'i CDN'den çeker, `Ǽ.Ȭ(data, keys)` ile **bayt-pozisyon permütasyonu** (anahtar `ǻ`: zlib açılmış virgüllü index listesi; çiftler swap) uygular → geçerli CWS.
  - Bu oyunda anahtar sadece 4 index (1,10,20,200) → 2 swap; gerisi sağlam CWS.

## Tel protokolü (Foundation/Network/TTransceiver.as)
- **Düz metin** (bu sunucuda `IsCipher=false`). Cipher (`TPacketCipher`) mevcut ama devrede değil.
- Çerçeve (big-endian):
  ```
  [uint32 total][uint32 packetID][payload...]
  total = 4(total) + 4(id) + payload.length     // total KENDİNİ sayar
  ```
- Boyutlar: SIZE_PacketLength=4, SIZE_PacketID=4, SIZE_CheckCode=1 (cipher'da), PACKET_MAX=65535.

## Opcode şeması (CONST_GT_NETWORK)
- `(kategori<<16) + index`. Yön orta baytla kodlanır:
  - **CS (client→sunucu): `0x0181xxxx`** (lobby), `0x0161xxxx` (AS/login), `0x0145xxxx` (?)
  - **SC (sunucu→client): `0x0118xxxx`** (lobby), `0x0116xxxx` (AS)
- **Kural: istek `0x0181abcd` → cevap `0x0118abcd`** (orta bayt 81↔18).
- `0x00000001` = heartbeat/ping (payload boş).

## Ana akış (yakalanan)
1. conn1 (kapı): C2S `0x01810000` (login bilgisi) → S2C `0x01180000` (8B: `00000000 00000036` = agent 54).
2. conn2 (oyun): C2S `0x01810001` (login) → S2C `0x01180102` (karakter verisi, 650B).
   - Login payload: `UTF(agentUserId="352354512635355")`, `u32 agent=54`, `u32 server=974`, `UTF(token md5)`, ..., `UTF(time)`.
3. Sonra lobi isteği seli: hero (`0x01812302`), harita/hareket (`0x01810300`), vb.

## Karakter paketi 0x01180102 — TUnstreamizerCharacter.BasicProperties
Sıra (hepsi u32 BE, UTF = u16 len + bytes):
```
u32 AgentOperatorId        (=54)
u32 ServerId               (=974)
UTF AgentUserId
u32 RoleId_hi, u32 RoleId_lo   (Coerce)
UTF NickName               ("Miho Hinata")
u32 Country
u32 MilitaryRank
u32 Prestige
u32 CreditSilverCoin.High
u32 CreditSilverCoin.Low   // gümüş = 64-bit
u32 CreditGold             // <<< ALTIN (premium)
u32 CreditGiftCertificate  // <<< kupon
u32 CreditMilitaryOrders
u32 VipLevel, u32 VipExp
u16 BackpackCapacity
u8  BackpackExpandCount
u32 TownID
u32 StarMapIndex
u32 GeneralsSoul
u32 HeroSoulBlueSoul, PurpleSoul, GoldSoul, OrangeSoul
... (heroes, inventory, quests — devam)
```

## Sunucu planı
- `sunucu/oyun-sunucu.js`: 10025'te dinler, çerçeveyi çözer, C2S→S2C opcode-swap ile yakalanan cevabı verir; char paketinde altın/gümüş/kupon'u `veri.json`'dan enjekte eder.
- `serve.mjs`: dosyalar (7420) + Flash policy (843). Özel sunucu modunda 10025 proxy KAPALI, yerine oyun-sunucu.
- Admin panel: `veri.json` düzenler (altın, hero listesi, item).

## Void Region Flash flow
- `TVoidSoulWorldData.GameStart()` gates the entrance pointers, join-award button, and player movement on Organization activity status `Battle`; changing `DailyActivity` hours alone does not satisfy that gate. The local test SWF makes this Void-specific check return `true`.
- `0x01818b01` (`InfoSubmitReq`) must return `0x01188b01` as `[u32 error][i32 submitTime][i16 formCount][formCount * (i32 heroId, i32 position)]`. Returning an empty form leaves `HaveForm()` false and blocks every entrance.
- Flash sends `0x01818b02` (`FightEnterReq`) with one byte containing the selected front index (0-3). Its `0x01188b02` response is `[u32 error][u32 roleIdHi][u32 roleIdLo][u8 front][i32 warTimeSeconds][i32 heroTemplateId][i32 quality][UTF name]`.
- `0x01188b02` contains only the `FightEnterRet` fields above. On a successful response, the Void processor updates the front UI if its resources are ready and invokes the normal battle-status/init callbacks; those callbacks must not be gated on the Void window's resource-ready flag. Selecting Void battle status clears the shared handler's stale `IsInBattle` guard before the separate BattleReport (`0x01458000`) and SingleBattleResult (`0x01458001`) arrive; otherwise the shared handler silently discards the report. `RankRet` (`0x01188b05`) follows, and battle return switches back to Void Region.
- The battle loading bar is the shared `TProcessorBattleLoading` phase; it uses primary asset requests. Once complete, `TBattleHandle` populates the stage, closes loading, and plays the `BattleReady` clip; `StartBattle()` is triggered only at the clip's penultimate frame. Reset that clip to frame 1 before showing it so a prior/invisible timeline position cannot skip the start trigger.
- The Void battle report is generated from the player's current formation and the same upcoming-date boss `EnemyArmy`. Unlike ordinary stages, Void does not scale boss stats to the team and does not force a final-round lethal hit; accumulated boss damage is the sum of the team's simulated attack statistics over the 24-turn battle. No unrelated stage rewards are granted. `DeadRet` is sent only to clean up the native Void entrance sprite after starting the battle scene.
- The copied Ulquiorra stage (`15102099`) is server-only: the Flash client receives the existing Gin stage ID (`15102003`) for battle context/background because the copy is not present in the client's ResourceBin. The server report still supplies only Ulquiorra as the enemy.
- `RankRet` updates current boss HP and damage rank without rebuilding front sprites. Boss max HP is calculated from the same `EnemyArmy` and `Enemy` records the Flash client uses for its HP-bar denominator; older local state is migrated while preserving accumulated damage. The Flash UI overlays current and maximum HP text inside the HP bar.
- On Void Init, the server removes stale front entries (older than the configured interval plus a 5-second margin); a fresh Init response therefore allows the player to attack again after a restart.
- The local `DailyActivity` resource is configured to open `00:00-23:59` for testing. The boss HP, damage, and participant state handled by this prototype are per-player, not shared across accounts.

## FightPet boss defeat flow
- When a FightPet hit reduces boss HP to zero, the server sends the final battle result, `MonsterInfo` with HP `0`, and the updated damage ranking before `0x01182608` (`GameOver`).
- A positive gold payout is followed by `0x0118260A` with one big-endian `u32` amount; the client displays it as a localized Gold toast. `GameOver` (`0x01182608`) has an empty payload and returns the client to town after its existing 5-second cooldown.
- Boss HP and damage tracking are reset server-side for the next round before the death packet is sent.

## Sky Tower / Trial Tower
- `Challenge_Req` (`0x01810a01`) carries `[u8 mode][u8 type][u32 towerId][u32 layerId]`; the PVE stage is the final `layerId` at byte offset 6, not a generic stage ID at offset 4.
- Tower floors are `TemplePoint` records. Their `battleScene.army` selects the real `EnemyArmy` formation and its `awardId`; server battle reports and victory rewards must resolve that same floor record.
- A successful PVE result records the cleared floor by tower. The next `Enter_SkyTower` response puts the active tower first and restores its cleared-floor count; invalid tower/floor combinations are rejected rather than falling back to a previous stage.
- The Flash client uses the tower and floor IDs echoed in the successful challenge response before starting the battle, so battle completion updates the same floor whose enemies and rewards the server used.

## Meru Realm / KillHeros
- `Enter_KillHeros` (`0x01810203`) returns `[u32 error][u16 clearedCount][clearedCount * (u32 stageId, u8 enterCount, u8 resetCount)][u16 firstBestCount][firstBestCount * (u32 stageId, utf firstReportId, utf firstName, utf bestReportId, utf bestName)]`; clear state and the local player's first/best display names are saved per account, and daily attempt/reset counters roll over by local server date.
- A challenge uses `Enter_Hurdle` (`0x01810202`) with `[u32 cityId][u32 RaidersDailyConfigId]`. The city must be a type-3 Meru Realm city and the stage must be inside that city's configured `start..last` range.
- `RaidersDailyConfig.enemyId.army` selects the actual enemy armies and their `awardId` records provide the win rewards; `raiderAward.award` is the client-facing reward preview item list. Failed fights grant no stage rewards or clear progress.
- A successful result updates clear state and sends `KillHeros_BestFirstNotify` (`0x01180702`) plus `KillHeros_Notify` (`0x01180700`). The next stage opens immediately after a clear; the client does not hold progression behind the level gate. Report links remain disabled when no battle-report ID exists.
- `KillHeros_ResetReq` (`0x01810701`) accepts either a single cleared stage or a type-3 city for reset-all. The server returns only eligible cleared stages for that city, applies configured Gold cost and the current VIP reset limit, and persists reset counters.
