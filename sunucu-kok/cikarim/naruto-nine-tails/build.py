"""Install Naruto's opt-in tables and original lossless actor textures."""
from pathlib import Path
from PIL import Image,ImageOps
import importlib.util,json,copy,struct,zlib,shutil
B=Path(__file__).resolve().parent;ROOT=B.parents[1]
s=importlib.util.spec_from_file_location('packed',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);n=p.native
C=json.loads((ROOT/'sunucu/naruto-nine-tails.json').read_text());A=json.loads((B/'animation.json').read_text());D=json.loads((B/'descriptions.json').read_text());H=C['heroId'];HIT=13622701;SOURCE=ROOT.parent/'asset/Naruto_Nine_Tails_Chakra_Full'
def rows():
 h=copy.deepcopy(next(x for x in json.loads((n.DATA/'BaseHero.json').read_text(encoding='utf-8')) if x['assess']=='S+'));effects={}
 for ident,name in A['moves'].items():
  clip=A['clips'][name];node={'target':1,'backPoint':{str(clip['returnFrame']):1}}
  if name=='healing':node['friendhp']={str(clip['hitFrames'][0]):100}
  else:
   hits=clip['hitFrames'];weights=[100//len(hits)]*len(hits);weights[-1]+=100-sum(weights)
   node['appendEffect']={str(frame):{'effectId':HIT,'target':2,'hitIndex':i,'hitCount':len(hits),'anmyhp':{'0':weight,'checkDie':int(i==len(hits)-1)}} for i,(frame,weight) in enumerate(zip(hits,weights))}
  effects[ident]=node
 h.update(id=n.hexid(H),name=C['name'],assess='S+',quality=5,profession=1,isMain=0,sex=1,level=1,needLevel=1,desc='S+. Any formation position. '+D['passive'],active=13121701,normalAttack=13121702,talent=13220994,attackEffect=json.dumps(effects,separators=(',',':')),tags=C['tags'],headStyle='',heroSoul='',power=6500,agile=6500,intelligence=6500,life=9000,speed=115,powerGrow=3.1,agileGrow=3.1,intelligenceGrow=3.1,lifeGrow=4.0,speedGrow=2.3)
 for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[field]=0
 h['hitRate']=1
 names={13121701:'Tornado Rasengan!',13121702:'Taijutsu Attack',13121703:'Taijutsu Attack',13121704:'Taijutsu Attack',13121705:'Tailed Beast Coat',13121706:'Tailed Beast Chakra - Wars',13121707:'Tailed Beast Chakra (Immunity)'}
 return {'BaseHero':[h],'RoleModel':[{'id':n.hexid(H),'model':H,'roleStyle':H,'roleHead':H}], 'HeroTalent':[{'id':n.hexid(13220994),'talentName':'Tailed Beast Coat / Tailed Beast Chakra - Wars','talentDesc':D['passive']}], 'SkillConfig':[{'id':n.hexid(i),'skillId':i,'name':name,'desc':D[str(i)] if str(i) in D else D['13121702'],'icon':i,'sortId':i-13121700} for i,name in names.items()]}
def main():
 db=rows();changes={}
 spec=importlib.util.spec_from_file_location('mme',B.parent/'pain-tendo/prepare-assets.py');mme=importlib.util.module_from_spec(spec);spec.loader.exec_module(mme)
 source,images=mme.decode(SOURCE/'assets/battle/effect/dianran.swf');fire,_=mme.mme.render(source,images,'dran',scale=1.3)
 # Patch only active mapped packages plus canonical roots, preserving older releases.
 spec=importlib.util.spec_from_file_location('release',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
 files=set()
 for key,ver in r.rows((n.PUBLIC/'2026090619/version.swf').read_bytes()):
  if key.startswith(b'Resources/Bin/') and key.endswith((b'.bin',b'.binPackage')):files.add(n.PUBLIC/ver.decode()/key.decode())
 for version in ['2017112917','2026090619']:files.update((n.PUBLIC/version/'Resources/Bin').rglob('*.bin'));files.update((n.PUBLIC/version/'Resources/Bin').rglob('*.binPackage'))
 for path in files:
  if not path.is_file():continue
  raw=path.read_bytes()
  if path.suffix=='.bin':
   decoded=zlib.decompress(raw);updated=n.patch(decoded,db)
   if updated!=decoded:changes[path]=zlib.compress(updated)
  else:
   pos=6;parts=[raw[:6]];changed=False
   for _ in range(struct.unpack_from('<H',raw,4)[0]):
    size=struct.unpack_from('<I',raw,pos)[0];pos+=4;chunk=raw[pos:pos+size];pos+=size;decoded=zlib.decompress(chunk);updated=n.patch(decoded,db)
    if updated!=decoded:chunk=zlib.compress(updated);changed=True
    parts.extend([n.u32(len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+raw[pos:]
 for version in ['2017112917','2026090619']:
  dest=n.PUBLIC/version/'Resources/Textures'
  for suffix,names in A['models'][str(H)].items():
   ident=int(f'{H:X}'+suffix,16);seq=[]
   for name in [names] if isinstance(names,str) else names:
    clip=A['clips'][name];seq.append(dict(frames=[Image.open(B/'frames'/f'{i:03}.png').convert('RGBA') for i in clip['assets']],loop=clip['loop'],duration=40,pivots=[A['framePivots'][str(i)] for i in clip['assets']]))
   changes[dest/'Model'/f'{ident:08X}.TexClient']=n.texture_sequences(ident,seq)
  for category,source,size in [('HeadIcon','battle/role/head_45_45/11000131.png',(48,48)),('SmallIcon','battle/role/head_45_45/11000131.png',(48,48)),('LargeIcon','user/ninja/ninjaBigImg/11000131.png',(220,300)),('MiddlePicture','bag/ninja/preview/11000131.png',(220,300))]:
   im=ImageOps.contain(Image.open(SOURCE/'assets'/source).convert('RGBA'),size,Image.Resampling.LANCZOS);changes[dest/category/f'{H:08X}.TexClient']=n.texture(H,[im],pivot=False)
  for i,icon in {13121701:21000134,13121702:20000101,13121703:20000101,13121704:20000101,13121705:21000135,13121706:21000136,13121707:21000136}.items():
   im=Image.open(SOURCE/'assets/skill/40'/f'{icon}.png').convert('RGBA');changes[dest/'SkillIcon'/f'{i:08X}.TexClient']=n.texture(i,[im],pivot=False)
   changes[dest/'Skill'/f'{i:08X}.TexClient']=n.texture(i,[Image.new('RGBA',(1,1))],duration=40)
  changes[dest/'Skill'/f'{HIT:08X}.TexClient']=n.texture(HIT,[Image.new('RGBA',(1,1))],duration=40)
  changes[dest/'Skill'/f'{13622702:08X}.TexClient']=n.texture_sequences(13622702,[dict(frames=fire,loop=False,duration=40,pivots=[im.info['pivot'] for im in fire])])
 for kind,extra in db.items():
  path=n.DATA/(kind+'.json');old=json.loads(path.read_text(encoding='utf-8'));ids={x['id'] for x in extra};changes[path]=(json.dumps([x for x in old if x['id'] not in ids]+extra,ensure_ascii=False,indent=2)+'\n').encode()
 for path,data in changes.items():
  backup=B/'backups'/path.relative_to(ROOT)
  if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 spec=importlib.util.spec_from_file_location('profile',B/'repair-profile-rasengan.py');profile=importlib.util.module_from_spec(spec);spec.loader.exec_module(profile);profile.textures()
 print('PASS Naruto S+ native data and textures:',len(changes),'files')
if __name__=='__main__':main()
