"""Stable profile-only canvases and original Flash Rasengan compositing."""
from pathlib import Path
from PIL import Image
import importlib.util,json,re,math,shutil,hashlib
B=Path(__file__).resolve().parent;W=B/'profile-rasengan'
s=importlib.util.spec_from_file_location('builder',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
def textures():
 spec=importlib.util.spec_from_file_location('packed',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
 a=json.loads((B/'animation.json').read_text());ids=a['clips']['idle']['assets'];pivots=[a['framePivots'][str(i)] for i in ids];images=[Image.open(B/'frames'/f'{i:03}.png').convert('RGBA') for i in ids]
 left=min(-v[0] for v in pivots);top=min(-v[1] for v in pivots);right=max(im.width-v[0] for im,v in zip(images,pivots));bottom=max(im.height-v[1] for im,v in zip(images,pivots));frames=[]
 for im,pivot in zip(images,pivots):
  canvas=Image.new('RGBA',(right-left,bottom-top));canvas.alpha_composite(im,(-pivot[0]-left,-pivot[1]-top));frames.append(canvas)
 ident=int(f'{11120994:X}0E',16);data=p.native.texture_sequences(ident,[dict(frames=frames,loop=True,duration=40,pivots=[(-left,-top+20)]*len(frames))])
 for version in ['2017112917','2026090619']:
  path=c.h.PUBLIC/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient';backup=W/'texture-backups'/version;backup.mkdir(parents=True,exist_ok=True)
  if not (backup/path.name).exists():shutil.copy2(path,backup/path.name)
  path.write_bytes(data)
 (W/'profile.json').write_text(json.dumps({'frames':len(frames),'canvas':[right-left,bottom-top],'pivot':[-left,-top+20],'profileOnlyTexture':f'{ident:08X}'},indent=2)+'\n')
def patch(before):
 helper=(B/'native-rasengan.as.txt').read_text();after=before.replace('      override public function UpdateActive()',helper+'\n      override public function UpdateActive()',1)
 preload=c.m.extract(after,'PreloadNineTailsVfx');after=after.replace(preload,re.sub(r'"1nrv_luoxuanwan"\s*,?','',preload),1)
 after=c.inject(after,'PrepareBattleRole','         if(FId==11120994)PreloadNineTailsNative();')
 method=c.m.extract(after,'ShowNineTailsVfx');start=re.search(r'if\(skill\s*==\s*13121701\)',method).start();end=c.b.method_end(method,start)
 method2=method[:start]+'''         if(skill==13121701){PlayNineTailsNativeRasengan("zlxw");PlayNineTailsNativeRasengan("lian",31);return;}
'''+method[end:];after=after.replace(method,method2,1)
 method=c.m.extract(after,'NineTailsVfxManifest');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);data=json.loads(json.loads(match.group(1)))
 spec=importlib.util.spec_from_file_location('source_mme',B.parent/'pain-tendo/prepare-assets.py');m2=importlib.util.module_from_spec(spec);spec.loader.exec_module(m2);xml,images=m2.decode(B.parents[2]/'asset/Naruto_Nine_Tails_Chakra_Full/assets/battle/role/left/11000131.swf');action=next(x for x in xml.findall('action') if x.get('name')=='SP_skill1');nodes=list(action.find('layer').findall('frame'));roots=[]
 count=len(json.loads((B/'animation.json').read_text())['clips']['mystery']['assets'])
 for i in range(count):
  tick=round(i*24/25);node=next((n for n in nodes if int(n.get('index'))<=tick<int(n.get('index'))+int(n.get('length','1'))),None);roots.append(float(node.find('element').get('x','0')) if node is not None and node.find('element') is not None else 0)
 data['actorMotion']['13121701']['roots']=roots
 after=after.replace(method,method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):],1)
 method=c.m.extract(after,'NineTailsStrikePose');at=method.index('         var motion:Object');method2=method[:at]+'''         if(FSkillId==13121701){var travel:Point=NineTailsRasenganTravel();var config:Object=NineTailsVfxManifest().actorMotion["13121701"];var root:Number=Number(config.roots[Math.min(Math.max(0,FFrameIndex),config.roots.length-1)]);FBitmap.x=-frame.Pivot.X+root+travel.x;FBitmap.y=-frame.Pivot.Y+travel.y;return;}
'''+method[at:];after=after.replace(method,method2,1)
 return after
def main():
 textures();rel=c.b.ROLE;before=(W/'original/scripts'/rel).read_text(encoding='utf-8');after=patch(before);dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(after,encoding='utf-8')
 public=c.h.PUBLIC/'nine-tails-vfx/native-v2';public.mkdir(parents=True,exist_ok=True);shutil.copy2(B.parents[2]/'asset/Naruto_Nine_Tails_Chakra_Full/assets/battle/effect/1nrv_luoxuanwan.swf',public/'rasengan.swf')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 source=(W/'source.swf').read_bytes();raw=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 c.ff('-selectclass','Processors.Game.Battle.Character.TRole','-export','script',W/'verify',W/'compiled.swf')
 new=(W/'verify/scripts'/rel).read_text(encoding='utf-8');changed={'PreloadNineTailsVfx','PrepareBattleRole','NineTailsVfxManifest','ShowNineTailsVfx','NineTailsStrikePose'};count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in changed:assert c.m.extract(before,name)==c.m.extract(new,name),name;count+=1
 (W/'result.json').write_text(json.dumps({'unchangedMethods':count,'sha256':hashlib.sha256(raw).hexdigest(),'nativeOriginalSwf':True},indent=2)+'\n');print('PASS native original Rasengan and stable profile;',count,'methods preserved')
if __name__=='__main__':main()
