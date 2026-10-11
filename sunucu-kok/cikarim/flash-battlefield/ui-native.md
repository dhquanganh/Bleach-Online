# Battlefield interface and Void Regions actors

The battlefield retains the authoritative formation rules and real native combat
reports. This revision changes its presentation and map actors.

Formation mode now uses three configurable straight routes from faction base to
opposite base. Server positions are constrained to these lines. Factions distribute
participants evenly across lanes; AI marches toward the opposite endpoint, stops
at an opposing actor, and never chases into another lane. Both manual and automatic
duels require matching lane IDs and proximity. Cooldown/dead actors are hidden and
do not obstruct visible runners. Reaching the opposite endpoint starts a cooldown;
when it expires, the actor returns to its own base on the same lane for a new run.
Humans can select another lane only at their own base by
clicking its departure circle. Respawn retains the selected lane. An active old
free-roaming match is projected onto routes once, preserving scores and honor.
The client displays route guides, highlights the local lane and filters attack
targets by lane. `battlefield-lanes.test.js` verifies these rules.

`methods.as.txt` draws the HUD, reports, ranking, registration, results, formations,
companions and honor shop with the existing Bleach panel/button textures
(`boss-native-panel.png`, `boss-native-button.png`). HUD panels have viewport
margins; ranking is limited to ten rows; modal windows block map clicks underneath.
The resource bar is a separate display object above the panel bitmap.

Map actors use the original Void Regions library `Resources/Swf/Lobby/3E000000.swf`,
requested through `SResourcesCore.TexturesSwfLobby.LoadPrimary`. The renderer uses
the same `Role_<Profession>_<Sex>_<up|down>` symbols as Void's `TPlayerSprite` and
`TFrontController`, rather than battle showcase textures. The original library
contains professions 1, 3 and 4 with both sexes and directions. Other professions
use profession 1 with the same sex; their actual combat formation is unchanged.

Moving actors advance the native timeline with a cumulative elapsed animation
clock; stationary actors stop at frame one. Each snapshot interpolates position
over one second instead of an exponential jump followed by a stationary gap.
Direction follows movement, with horizontal mirroring. Timeline frame/direction
and elapsed animation time survive each server snapshot. `MC_Fighting` indicates an ongoing formation duel;
the embedded Void name field is replaced by faction-colored battlefield names.
The local player's name stays visible. Other labels are suppressed when they
overlap at their interpolated screen positions and appear on hover/selection.
During cooldown the entire actor (model, name, HP, effects and selection ring) is
removed. Cached positions are discarded so respawn/return cannot interpolate from
an old battle position across the map. Lane/team changes and large discontinuities
also reset interpolation. Void clip artwork is anchored at its lower center to
align its feet with the battlefield ground coordinate, including mirrored poses.

Rebuild with `prepare.py` followed by `build.py --install`, then publish a fresh
local client version using `loader.py --install`. Build verifies non-code SWF
assets remain unchanged and retains the existing native replay return routes.
