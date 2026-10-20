from pathlib import Path
import importlib.util,struct,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fix',BASE/'fix-first-open.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
w=BASE/'first-open';canonical=b.h.PUBLIC/'2026090619/TApplication.swf'
assert canonical.read_bytes()==(b.h.PUBLIC/'2026101983/TApplication.swf').read_bytes()
profile_exact=BASE/'profile-star-exact-position';profile_anchor=BASE/'profile-star-anchor';profile_layer=BASE/'profile-star-layer';profile_position=BASE/'profile-star-position';profile_display=BASE/'profile-star-display';profile_stars=BASE/'profile-stars';ranking=BASE.parent/'flash-boss/real-ranking'
removed=BASE.parent/'flash-battlefield/removed'
assert b.h.swap(canonical.read_bytes())==(removed/'compiled.swf').read_bytes()
assert (removed/'source.swf').read_bytes()==(profile_exact/'compiled.swf').read_bytes()
assert (profile_exact/'source.swf').read_bytes()==(profile_anchor/'compiled.swf').read_bytes()
assert (profile_anchor/'source.swf').read_bytes()==(profile_layer/'compiled.swf').read_bytes()
assert (profile_layer/'source.swf').read_bytes()==(profile_position/'compiled.swf').read_bytes()
assert (profile_position/'source.swf').read_bytes()==(profile_display/'compiled.swf').read_bytes()
assert (profile_display/'source.swf').read_bytes()==(profile_stars/'compiled.swf').read_bytes()
assert (profile_stars/'source.swf').read_bytes()==(ranking/'compiled.swf').read_bytes()
assert (ranking/'source.swf').read_bytes()==(w/'compiled.swf').read_bytes()
source=(w/'verify/scripts'/b.INSPECTOR).read_text();method=b.method(source,'RequestShowHero')
for token in ['if(this.FProcessorWindowPlayerAssets.Visible)','if(this.FProcessorWindowInventoryInfor.Visible)','FHeros.Clear()', 'writeUnsignedInt(param1)','writeUnsignedInt(param2)']:
 assert token in method,token
assert 'FProcessorWindowInventoryInfor.Inventory = null' not in method
assert method.index('FHeros.Clear()')<method.index('PacketTransmit(')
reset=b.method((w/'verify/scripts'/b.WINDOW).read_text(),'Reset')
assert reset.index('if(this.FHeros == null)')<reset.index('this.FUITabHeros.Reset()')<reset.index('this.FHeros.Clear()')
for rel in [b.b.ROLE,Path('Processors/Game/Battle/TBattleHandle.as'),Path('Processors/Game/Battle/Effect/TEffectControl.as')]:
 assert (w/'original/scripts'/rel).read_bytes()==(w/'verify/scripts'/rel).read_bytes(),rel
raw=zlib.decompress((canonical.parent/'version.swf').read_bytes());pos=2;found=False
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;value=raw[pos:pos+n];pos+=n
 if key==b'TApplication.swf':assert value==b'2026101983';found=True
assert found and pos==len(raw)
display=(profile_exact/'verify/scripts/Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as').read_text()
assert 'this.FProfileStarBadge.text = "x " + _loc5_' in display and 'this.FProfileStarMarker.x = 120' in display and 'this.FProfileStarMarker.y = 300' in display
assert '_loc3_.addChild(this.FProfileStarMarker)' in display and 'this.FProfileStarMarker.parent.setChildIndex' in display
assert 'this.FHeroChangeLightStars[_loc1_].visible = _loc1_ < _loc4_.ChangeSchedule' in display
print('PASS installed Inspector 2026101983: preserved profile stars, role IDs and battle/HP/no-shake controls after Battlefield removal')
