# Video reference audit

Reference: [Bình Luận Game Vua Hải Tặc HĐ Chiến Trường Hài Hước Kinh Khủng](https://www.youtube.com/watch?v=CUBUbuLkdFA), Vua Hải Tặc ZingMe, 18:32. The video was downloaded for local inspection; 37 frames at 30-second intervals cover the whole clip, with additional frames every 5 seconds around the first formation battles. Download and sampled source frames remain in the temporary reference-tools folder and are not bundled into the game.

## Directly observed

| Video segment | Visible behavior | Implementation |
| --- | --- | --- |
| Opening, about 00:15 | Harbor map, faction dragons, resources approximately 450 / 550 | Full-map harbor UI, red/blue faction HUD; 500 / 500 start |
| About 01:02–01:40 | Map switches into a separate formation battle and returns | Native v4 battle reports; native replay rendering with a dedicated return to the battlefield |
| About 01:45 onward | Subsequent formation duel; battle names correspond to players on the map | Autonomous bot-versus-bot formations and human-versus-bot formations, server-authoritative results |
| First half | Three orange rings in the lower-left harbor area; freeze countdown and Auto checkbox | Friendly spawn/respawn pads; independent duel cooldown, death timer and auto challenges |
| Around 07:30–09:00 | Return to town between halves; second half starts with rings toward upper-right | Return-to-town control; role/spawn swap for round two; scores stay with the roster |
| Around 09:15 | Second-half timer approximately 14:34 | Two 15-minute combat rounds |
| Second half to end | Faction resource pairs sum to 1000, e.g. 410/590 and 379/621 | Resource transfer on duel wins, not simultaneous creation of faction resources |
| Throughout | Leaderboard at right; personal accumulation below; reports with View links above | Live match/weekly ranking, personal accumulated points and native report viewing |
| Throughout | Bottom-right Formation / Companions / Return, not a skill bar or minimap | Formation/companion panels and return control |

No resource-channel capture, NPC guard or timed boss encounter is visible. `bossSH` is a player's name in the report, not evidence of a boss NPC. The video preset therefore disables guards, boss schedules and capture channels. The rings are treated as spawn pads. The clip does not prove what other activities or rules may exist outside the visible actions.

## Configurable reconstruction, not verified official numbers

The clip does not show a complete rules tooltip, so preparation/intermission length, exact death/freeze timers, strategy prices, matchmaking formula and all accumulation/reward formulas cannot be extracted exactly. Defaults are explicit in `battlefield-config.json`: preparation 90 seconds, intermission 30, respawn 15, freeze 25, win +5 accumulation and +1 Honor, strategy +2% attack/defense and +10 accumulation, 3 strategy uses per round. These are reconstruction settings and can be adjusted; they are not presented as verified 568 formulas.

The portable game's existing Bleach character and battle assets remain in use. Map actors now animate full native character sprites, while the clean harbor backdrop is generated from a video frame using the built-in imagegen tool. This reproduces the layout and gameplay flow, not an extraction of the original One Piece client assets.
