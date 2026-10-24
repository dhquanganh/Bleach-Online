from pathlib import Path
import sys,subprocess,importlib.util,json,shutil
B=Path(__file__).resolve().parent
sys.path.insert(0,str(B.parent/'flash-hueco'))
from build import swap,tags,CLIENT
J=Path('.tools/ffdec/ffdec.jar').resolve()
s=(B/'original/scripts/Rendering/Overlayers/TOverlayer.as').read_text()
a=s.index('         _loc2_ = param1.X + 50;');b=s.index('         TUtilityCartisian.CoordinateSet(this.FCoordinateOverlay',a)
s=s[:a]+'''         // Prefer the right side and clamp long descriptions inside the stage.
         _loc2_ = Math.max(8,Math.min(param1.X + 20,STAGE_Width - _loc4_ - 8));
         _loc3_ = Math.max(8,Math.min(param1.Y,STAGE_Height - _loc5_ - 8));
'''+s[b:]
p=B/'patched/Rendering/Overlayers/TOverlayer.as';p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s)
assert swap(CLIENT.read_bytes())==(B/'source.swf').read_bytes()
subprocess.run(['java','-Xmx2g','-jar',str(J),'-onerror','abort','-importScript',str(B/'source.swf'),str(B/'compiled.swf'),str(B/'patched')],check=True)
compiled=(B/'compiled.swf').read_bytes()
assert [t for t in tags(compiled) if t[0]!=82]==[t for t in tags((B/'source.swf').read_bytes()) if t[0]!=82]
subprocess.run(['java','-jar',str(J),'-selectclass','Rendering.Overlayers.TOverlayer','-export','script',str(B/'verify'),str(B/'compiled.swf')],check=True)
v=(B/'verify/scripts/Rendering/Overlayers/TOverlayer.as').read_text()
assert 'Math.max(8,Math.min(param1.X + 20' in v
# Check short and long descriptions at both edges and the screenshot's overflow case.
for x in [0,200,500,1240]:
 for w in [60,440,650]:
  left=max(8,min(x+20,1250-w-8));assert 8<=left and left+w<=1242
for y in [0,400,640]:
 for h in [40,140,500]:
  top=max(8,min(y,650-h-8));assert 8<=top and top+h<=642
P=CLIENT.parents[1];C=CLIENT.parent;V='2026102406';D=P/V
spec=importlib.util.spec_from_file_location('codec',B.parent/'naruto-sage-native/release.py');codec=importlib.util.module_from_spec(spec);spec.loader.exec_module(codec)
for f in [CLIENT,C/'version.swf',P/'client-release.json']:shutil.copy2(f,B/(f.name+'.before'))
D.mkdir(exist_ok=True)
CLIENT.write_bytes(swap(compiled));shutil.copy2(CLIENT,D/'TApplication.swf')
rows=codec.decode((C/'version.swf').read_bytes());assert any(k==b'TApplication.swf' for k,v in rows)
rows=[(k,V.encode() if k==b'TApplication.swf' else v) for k,v in rows]
(C/'version.swf').write_bytes(codec.encode(rows))
for name in ['index.swf','version.swf']:shutil.copy2(C/name,D/name)
temp=P/'client-release.tmp';temp.write_text(json.dumps({'version':V})+'\n');temp.replace(P/'client-release.json')
print('PASS: compiled tooltip position, preserved assets, checked edge positions, published '+V)
