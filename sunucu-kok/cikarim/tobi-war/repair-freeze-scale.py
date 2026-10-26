"""Fix Tobi's passive-as-Mystery playback and resize only his/Zetsu's native actors."""
from pathlib import Path
from PIL import Image
import importlib.util,json,re,shutil,hashlib,struct
B=Path(__file__).resolve().parent;W=B/'repair-freeze-scale';VERSION='2026102607'
s=importlib.util.spec_from_file_location('client',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
s=importlib.util.spec_from_file_location('release',B/'release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
s=importlib.util.spec_from_file_location('packed',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);n=p.native
def frames():
 a=json.loads((B/'animation.json').read_text());out={}
 for hero,models in a['models'].items():
  for suffix,names in models.items():
   ident=int(f'{int(hero):X}'+suffix,16);seq=[]
   for name in [names] if isinstance(names,str) else names:
    clip=a['clips'][name];images=[Image.open(B/'frames'/f'{i:03}.png').convert('RGBA') for i in clip['assets']];pivots=[a['framePivots'][str(i)] for i in clip['assets']]
    if suffix=='0e':
     left=min(-v[0] for v in pivots);top=min(-v[1] for v in pivots);right=max(im.width-v[0] for im,v in zip(images,pivots));bottom=max(im.height-v[1] for im,v in zip(images,pivots));fixed=[]
     for im,v in zip(images,pivots):
      canvas=Image.new('RGBA',(right-left,bottom-top));canvas.alpha_composite(im,(-v[0]-left,-v[1]-top));fixed.append(canvas)
     images=fixed;pivots=[(-left,-top+13)]*len(images)
    else:
     images=[im.resize((max(1,round(im.width*.9)),max(1,round(im.height*.9))),Image.Resampling.LANCZOS) for im in images]
     pivots=[(round(x*.9),round(y*.9)) for x,y in pivots]
    seq.append(dict(frames=images,loop=clip['loop'],duration=40,pivots=pivots))
   out[f'{ident:08X}.TexClient']=n.texture_sequences(ident,seq)
 return out
def compile_client():
 pub=c.h.PUBLIC;active=json.loads((pub/'client-release.json').read_text())['version'];assert active=='2026102606'
 old=(pub/active/'TApplication.swf').read_bytes();assert old==(pub/'2026090619/TApplication.swf').read_bytes()
 source=W/'source.swf';source.parent.mkdir(exist_ok=True);source.write_bytes(c.h.swap(old))
 roles={c.b.ACTIVE:{'IsSkill'},c.b.ROLE:{'PlayTobiNative'}}
 classes=','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in roles)
 c.ff('-selectclass',classes,'-export','script',W/'original',source)
 for rel in roles:
  before=(W/'original/scripts'/rel).read_text(encoding='utf-8')
  if rel==c.b.ACTIVE:
   method=c.m.extract(before,'IsSkill');old='return param1 != 13121802 && param1 != 13121803;';assert old in method
   fixed=method.replace(old,'return param1 >= 13121801 && param1 <= 13121807 && param1 != 13121802 && param1 != 13121803;',1)
  else:
   method=c.m.extract(before,'PlayTobiNative');fixed=method.replace('new Point(70 + offset.x,offset.y)','new Point(63 + offset.x,offset.y)').replace('layer.scaleX = caster.scaleX < 0 ? -1 : 1;','layer.scaleX = caster.scaleX < 0 ? -0.9 : 0.9;\n               layer.scaleY = 0.9;')
   assert fixed!=method and 'new Point(63 + offset.x,offset.y)' in fixed and 'layer.scaleY = 0.9' in fixed
  dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(before.replace(method,fixed,1),encoding='utf-8')
 c.ff('-onerror','abort','-importScript',source,W/'compiled.swf',W/'patched')
 raw=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source.read_bytes()) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 c.ff('-selectclass',classes,'-export','script',W/'verify',W/'compiled.swf')
 checked={}
 for rel,changed in roles.items():
  before=(W/'original/scripts'/rel).read_text(encoding='utf-8');after=(W/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name not in changed:assert c.m.extract(before,name)==c.m.extract(after,name),str(rel)+':'+name;count+=1
  checked[rel.stem]=count
 active_method=c.m.extract((W/'verify/scripts'/c.b.ACTIVE).read_text(encoding='utf-8'),'IsSkill')
 assert 'param1 >= 13121801' in active_method or 'param1>=13121801' in active_method
 (W/'client-validation.json').write_text(json.dumps({'unchangedMethods':checked,'sourceVersion':active,'sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n')
 print('PASS scope-limited client fix',checked)
def publish():
 queue=json.loads((B/'queue-probe/validation/native/result.json').read_text());assert queue['completed'] and queue['cases']==2 and queue['remainingLayers']==0 and not queue['errors']
 assert (W/'compiled.swf').is_file() and (W/'client-validation.json').is_file()
 pub=c.h.PUBLIC;active=json.loads((pub/'client-release.json').read_text())['version'];assert active=='2026102606'
 canonical=pub/'2026090619';old=(pub/active/'TApplication.swf').read_bytes();assert old==(canonical/'TApplication.swf').read_bytes()
 manifest=(pub/active/'version.swf').read_bytes();assert manifest==(canonical/'version.swf').read_bytes();assert c.h.swap(old)==(W/'source.swf').read_bytes()
 dest=pub/VERSION;assert not dest.exists()
 texture=frames();backup=W/'backup';backup.mkdir(parents=True,exist_ok=True)
 for path in [canonical/'TApplication.swf',canonical/'version.swf',pub/'client-release.json']:
  shutil.copy2(path,backup/path.name)
 for version in ['2017112917','2026090619']:
  for name,data in texture.items():
   path=pub/version/'Resources/Textures/Model'/name;old_texture=path.read_bytes()
   saved=backup/version/name;saved.parent.mkdir(parents=True,exist_ok=True);saved.write_bytes(old_texture)
   if name.endswith('0E.TexClient'):
    size=struct.unpack_from('<I',old_texture,4)[0];assert old_texture[8+size:]==data[8+struct.unpack_from('<I',data,4)[0]:],name+': profile atlas changed'
   path.write_bytes(data)
 rows=r.rows(manifest);mapped={key.decode():row for row in rows for key in [row[0]]}
 dest.mkdir()
 for key,row in mapped.items():
  if key=='TApplication.swf':row[1]=VERSION.encode()
  if key.startswith('Resources/Textures/Model/') and key.rsplit('/',1)[-1] in texture:
   row[1]=VERSION.encode();path=dest/key;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(texture[path.name])
 binary=c.h.swap((W/'compiled.swf').read_bytes());new_manifest=r.encode(rows)
 for target in [dest,canonical]:
  (target/'TApplication.swf').write_bytes(binary);(target/'version.swf').write_bytes(new_manifest)
 shutil.copy2(pub/active/'index.swf',dest/'index.swf')
 (pub/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 assert (canonical/'TApplication.swf').read_bytes()==(dest/'TApplication.swf').read_bytes()
 assert (canonical/'version.swf').read_bytes()==(dest/'version.swf').read_bytes()
 (W/'result.json').write_text(json.dumps({'version':VERSION,'scale':0.9,'profileDownPixels':12,'changedModelTextures':len(texture),'freezeCause':'Tobi IsSkill treated event skill ID 0 as a long Mystery','clientSha256':hashlib.sha256(binary).hexdigest()},indent=2)+'\n')
 print('PASS published',VERSION,'model textures',len(texture))
if __name__=='__main__':
 import sys
 if '--publish' in sys.argv:publish()
 else:compile_client()
