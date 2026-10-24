"""Build Small Katsuyu's original actor and healing effect, preserving source pivots."""
from pathlib import Path
import importlib.util,json,math,shutil,struct,zlib,hashlib,sys
B=Path(__file__).resolve().parent
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
p=module('katsuyu_mme',B.parent/'pain-tendo/prepare-assets.py')
packed=module('katsuyu_packing',B.parent/'shared-animation/packing.py');native=packed.native
SOURCE=B.parents[2]/'asset/Tsunade_Asian_Style_Full/Katsuyu_Tsunade_Asian_Style'
MAPPING={'idle':'C_idle','standard':'A_1hit','entry':'C_entry','dead':'C_dead','hit':'D_stand_behit1','run':'C_run1_2'}
def prepare():
 dest=B/'katsuyu';frames=dest/'frames';frames.mkdir(parents=True,exist_ok=True)
 c,images=p.decode(SOURCE/'assets/battle/role/left/19004611.swf')
 data={'actorId':11120993,'sourceActor':19004611,'scale':1.5,'frameMs':40,'clips':{}}
 for name,action in MAPPING.items():
  source,meta=p.mme.render(c,images,action,scale=1.5);rendered=[];pivots=[]
  for t in range(math.ceil(len(source)*25/24)):
   image=source[min(len(source)-1,round(t*24/25))];image.save(frames/f'{name}-{t:03}.png');rendered.append(f'{name}-{t:03}.png');pivots.append(image.info['pivot'])
  if name=='standard':
   from PIL import Image
   filename=f'{name}-{len(rendered):03}.png';Image.open(frames/data['clips']['idle']['frames'][0]).save(frames/filename);rendered.append(filename);pivots.append(data['clips']['idle']['pivots'][0])
  data['clips'][name]={'frames':rendered,'pivots':pivots,'sourceAction':action,'sourceFrames':len(source),'loop':name in ['idle','run']}
 c,images=p.decode(SOURCE/'assets/battle/effect/hphuifu.swf');fx,_=p.mme.render(c,images,'effect_battle_addhp',scale=1)
 data['healingEffect']={'id':13622609,'frames':[],'pivots':[]}
 for t in range(math.ceil(len(fx)*25/24)):
  image=fx[min(len(fx)-1,round(t*24/25))];name=f'healing-{t:03}.png';image.save(frames/name);data['healingEffect']['frames'].append(name);data['healingEffect']['pivots'].append(image.info['pivot'])
 (dest/'animation.json').write_text(json.dumps(data,indent=2)+'\n');return data
def textures(data=None):
 from PIL import Image
 data=data or json.loads((B/'katsuyu/animation.json').read_text());out={}
 def seq(clip):return dict(frames=[Image.open(B/'katsuyu/frames'/name).convert('RGBA') for name in clip['frames']],loop=clip.get('loop',False),duration=40,pivots=clip['pivots'])
 for version in ['2017112917','2026090619']:
  dest=native.PUBLIC/version/'Resources/Textures'
  for suffix,names in {'':['idle'],'0a':['idle'],'0b':['standard'],'0c':['entry','dead'],'0d':['hit'],'0e':['idle'],'0f':['run']}.items():
   ident=int(f'{11120993:X}'+suffix,16);out[dest/'Model'/f'{ident:08X}.TexClient']=native.texture_sequences(ident,[seq(data['clips'][name]) for name in names])
  fx=data['healingEffect'];out[dest/'Skill'/f'{fx["id"]:08X}.TexClient']=native.texture_sequences(fx['id'],[seq(fx)])
 return out
def main():
 data=prepare();changes=textures(data)
 if '--textures-only' in sys.argv:
  for path,content in changes.items():path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(content)
  print('PASS original Katsuyu textures with explicit idle return;',len(changes),'textures');return
 base=native.DATA/'BaseHero.json';rows=json.loads(base.read_text(encoding='utf-8'));slug=next(r for r in rows if int(r['id'],16)==11120993)
 # The actor performs the original A_1hit and returns to idle on completion.
 slug['attackEffect']=json.dumps({'13121609':{'target':1,'friendhp':{'10':100},'backPoint':{str(len(data['clips']['standard']['frames'])-1):1}}},separators=(',',':'))
 records={'BaseHero':[slug],'HeroTalent':[],'SkillConfig':[],'RoleModel':[]}
 changes[base]=(json.dumps(rows,ensure_ascii=False,indent=2)+'\n').encode()
 for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file() or path.suffix not in ['.bin','.binPackage']:continue
  raw=path.read_bytes()
  if path.suffix=='.bin':
   content=zlib.decompress(raw);updated=native.patch(content,records)
   if content!=updated:changes[path]=zlib.compress(updated)
  else:
   pos=6;parts=[raw[:6]];changed=False
   for _ in range(struct.unpack_from('<H',raw,4)[0]):
    size=struct.unpack_from('<I',raw,pos)[0];pos+=4;chunk=raw[pos:pos+size];pos+=size;content=zlib.decompress(chunk);updated=native.patch(content,records)
    if content!=updated:chunk=zlib.compress(updated);changed=True
    parts.extend([struct.pack('<I',len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+raw[pos:]
 for path,content in changes.items():
  saved=B/'katsuyu/backups'/path.relative_to(B.parents[1]);saved.parent.mkdir(parents=True,exist_ok=True)
  if path.exists() and not saved.exists():shutil.copy2(path,saved)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(content)
 (B/'katsuyu/result.json').write_text(json.dumps({'sourceActor':19004611,'actorId':11120993,'actions':list(MAPPING),'healingEffect':13622609,'changedFiles':len(changes),'sourceSha256':hashlib.sha256((SOURCE/'assets/battle/role/left/19004611.swf').read_bytes()).hexdigest()},indent=2)+'\n')
 print('PASS original Small Katsuyu: six actions, source pivots, native healing effect;',len(changes),'files')
if __name__=='__main__':main()
