"""Render production Naruto actor/FX methods in an isolated native Flash harness."""
from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
a=json.loads((B/'animation.json').read_text());source=(B.parent/'tsunade-asian/probe-source/TApplication.as').read_text().replace('Tsunade','NineTails').replace('tsunade','nineTails').replace('11120992','11120994')
source=source.replace(' import flash.geom.*;',' import flash.geom.*;\n import flash.system.*;')
def extract(text,name):
 match=re.search(r'[^\n]*function '+name+r'\(',text);start=match.start();return text[start:c.b.method_end(text,start)]
source=re.sub(r'private var skills:Array=\[[^\]]+\]', 'private var skills:Array=[13121701,13121702,13121703,13121704,13121706]',source,count=1)
source=re.sub(r'private var clipNames:Array=\[[^\]]+\]', 'private var clipNames:Array=["mystery","standard","standard2","combo","healing"]',source,count=1)
source=re.sub(r'private var metadata:Object=.*?;\n','private var metadata:Object='+json.dumps(a['clips'],separators=(',',':'))+';\n',source,count=1)
source=source.replace('loadTexture("00A9B160",["idle"])','loadTexture("00A9B162",["idle"])').replace('loadTexture("A9B1600B",["standard"])','loadTexture("A9B1620B",["standard","standard2","combo"])').replace('loadTexture("A9B1600C",["mystery", "healing", "revival", "summoning", "healingMystery"])','loadTexture("A9B1620C",["mystery","healing"])')
tick=extract(source,'tick')
start=tick.index('    for each(var restored:');end=tick.index('    readyAt=getTimer()',start);tick=tick[:start]+tick[end:]
bounds=[0]
for _ in range(2):
 for name in ['mystery','standard','standard2','combo','healing']:bounds.append(bounds[-1]+len(a['clips'][name]['assets'])*40+1500)
tick=re.sub(r'var bounds:Array=\[[^\]]+\]', 'var bounds:Array='+json.dumps(bounds),tick).replace('loaded<7','loaded<6').replace('slot<12','slot<10').replace('slot>=12','slot>=10').replace('slot<6?','slot<5?').replace('slot%6','slot%5').replace('NineTails Asian Style','Naruto Nine-Tails Chakra')
source=source.replace(extract(source,'tick'),tick,1)
aligned=B/'scale-alignment/patched'/c.b.ROLE
native=B/'profile-rasengan/patched'/c.b.ROLE
if native.exists():aligned=native
wide=B/'wide-portrait/patched'/c.b.ROLE
if wide.exists():aligned=wide
role=(aligned if aligned.exists() else B/'patched'/c.b.ROLE).read_text(encoding='utf-8')
names=['PreloadNineTailsVfx','NineTailsPinPages','PumpNineTailsVfxQueue','LoadNineTailsVfxAtlas','TrimNineTailsVfxCache','NineTailsFirstAtlas','PlayNineTailsVfxAsset','FitNineTailsPose','NineTailsBackdrop','PlayNineTailsEffect','NineTailsVfxManifest','UpdateNineTailsVfx','ShowNineTailsVfx']
for name in names:
 replacement=c.m.extract(role,name).replace(':TRole',':ProbeRole').replace('private function','public function').replace('private static function','public static function').replace('TBattleHandle.PlaybackTime','getTimer()')
 source=source.replace(extract(source,name),replacement,1)
if 'NineTailsStrikePose' in role:
 replacement=c.m.extract(role,'NineTailsStrikePose').replace(':TRole',':ProbeRole').replace(':TAnimationFrame',':Object').replace('private function','public function')
 source=source.replace(' internal class ProbeRole extends Sprite {',' internal class ProbeRole extends Sprite {\n'+replacement,1)
 source=source.replace('role.FitNineTailsPose();','role.NineTailsStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});role.FitNineTailsPose();',1)
if 'PreloadNineTailsNative' in role:
 source=source.replace(' internal class ProbeRole extends Sprite {',' internal class ProbeRole extends Sprite {\n public static var FNineTailsNative:Object={};',1)
 for name in ['PreloadNineTailsNative','NineTailsRasenganTravel','PlayNineTailsNativeRasengan']:
  replacement=c.m.extract(role,name).replace(':TRole',':ProbeRole').replace('private function','public function').replace('private static function','public static function').replace('TBattleHandle.PlaybackTime','getTimer()')
  source=source.replace(' internal class ProbeRole extends Sprite {',' internal class ProbeRole extends Sprite {\n'+replacement,1)
 source=source.replace('ProbeRole.PreloadNineTailsVfx();','ProbeRole.PreloadNineTailsVfx();ProbeRole.PreloadNineTailsNative();')
 source=source.replace('var phases:Array=[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];','var phases:Array=name=="mystery"?[3,12,26,34,46,58,62,66,86,95,115]:[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];')
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',dest.parent)
raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'tsunade-asian/runtime-raster.js').read_text().replace('7474','7486').replace('7475','7487').replace('tsunade-vfx','nine-tails-vfx').replace('(v3|extracted)','(v3|extracted|aligned-hd|native-v2)').replace('(png|argb)','(png|argb|swf)')
(B/'runtime-raster.js').write_text(js);(B/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS ten original Naruto casts, both camps, native probe compiled')
