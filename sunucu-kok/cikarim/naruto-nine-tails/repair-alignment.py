"""Patch Naruto alignment on the current client; preserve every unrelated method."""
from pathlib import Path
from PIL import Image
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent;W=B/'scale-alignment'
s=importlib.util.spec_from_file_location('builder',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
def patch(before):
 a=json.loads((B/'animation.json').read_text());method=c.m.extract(before,'NineTailsVfxManifest')
 match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',method);assert match
 previous=json.loads(json.loads(match.group(1)));data=json.loads((B/'vfx.json').read_text());data.update(moves=a['moves'],actions=a['effects']);data['actorMotion']={}
 for ident,name in a['moves'].items():
  if name=='healing':continue
  clip=a['clips'][name];hits=clip['hitFrames'];data['actorMotion'][ident]={'start':24 if name=='mystery' else 0,'first':hits[0],'last':hits[-1],'end':clip['returnFrame'],'hits':hits}
 for name,clip in data['clips'].items():
  if name=='MRzy-29':continue
  bounds=[]
  for page,index in zip(clip['frameAtlases'],clip['timeline']):
   meta=data['atlases'][page];path=c.h.PUBLIC.parent/meta['url'].lstrip('/')
   with Image.open(path) as image:
    x=index%meta['columns']*clip['width'];y=index//meta['columns']*clip['height'];cell=image.crop((x,y,x+clip['width'],y+clip['height']));box=cell.getchannel('A').point(lambda p:255 if p>=20 else 0).getbbox()
   bounds.append(list(box) if box else None)
  clip['contactBounds']=bounds
 after=before.replace(method,method[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+method[match.end(1):],1)
 runtime=(B/'alignment.as.txt').read_text()
 after=after.replace(c.m.extract(after,'ShowNineTailsVfx'),c.m.extract(runtime,'ShowNineTailsVfx'),1)
 after=after.replace('      override public function UpdateActive()',c.m.extract(runtime,'NineTailsStrikePose')+'\n      override public function UpdateActive()',1)
 after=after.replace('            this.FitNineTailsPose();','            this.NineTailsStrikePose(_loc4_);\n            this.FitNineTailsPose();',1)
 method=c.m.extract(after,'PlayNineTailsVfxAsset');token='               if(clip.tint != null)';assert token in method
 method2=method.replace(token,'''               if(clip.contactBounds!=null){
                  var bounds:Array=clip.contactBounds[frame] as Array;
                  if(bounds!=null){image.x=-width*(Number(bounds[0])+Number(bounds[2]))/(2*clip.width);image.y=-height*(Number(bounds[1])+Number(bounds[3]))/(2*clip.height);}
               }
'''+token,1)
 after=after.replace(method,method2,1)
 return after
def main():
 rel=c.b.ROLE;before=(W/'original/scripts'/rel).read_text(encoding='utf-8');after=patch(before)
 dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(after,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 source=(W/'source.swf').read_bytes();raw=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 c.ff('-selectclass','Processors.Game.Battle.Character.TRole','-export','script',W/'verify',W/'compiled.swf')
 verified=(W/'verify/scripts'/rel).read_text(encoding='utf-8');changed={'ShowNineTailsVfx','NineTailsVfxManifest','PlayNineTailsVfxAsset','UpdateActive'};checked=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in changed:assert c.m.extract(before,name)==c.m.extract(verified,name),name;checked+=1
 (W/'result.json').write_text(json.dumps({'unchangedMethods':checked,'sha256':hashlib.sha256(raw).hexdigest(),'bodyScale':1.0,'previousBodyScale':1.5},indent=2)+'\n')
 print('PASS Naruto scale/alignment client;',checked,'unrelated methods preserved')
if __name__=='__main__':main()
