from pathlib import Path
from PIL import Image,ImageOps
import importlib.util,json,copy,struct,zlib,shutil,xml.etree.ElementTree as ET
B=Path(__file__).resolve().parent;ROOT=B.parents[1]
s=importlib.util.spec_from_file_location('packed',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);n=p.native
C=json.loads((ROOT/'sunucu/madara-infinite.json').read_text());A=json.loads((B/'animation.json').read_text());H=C['heroId'];SOURCE=ROOT.parent/'asset/Madara_Infinite_Tsukuyomi_Full';HIT=13623201
def rows():
 skills=[C[k] for k in ['mystery','standard','standard2','standard3','standard4','susanoo','chase','limboChase','counter','barrier','evade','revive']]
 db={'BaseHero':[],'RoleModel':[],'HeroTalent':[],'SkillConfig':[]}
 for move in skills:
  desc=n.plain_description(move['description'])
  if not move.get('support'):desc+=' All damage scales with Physical ATK and is reduced by Physical DEF.'
  db['SkillConfig'].append({'id':n.hexid(move['id']),'skillId':move['id'],'name':move['name'],'desc':desc,'icon':move['id'],'sortId':move['id']-13122200})
 template=next(x for x in json.loads((n.DATA/'BaseHero.json').read_text(encoding='utf-8')) if int(x['id'],16)==11120995)
 effects={}
 for ident,name in A['moves'].items():
  clip=A['clips'][name];node={'target':1,'backPoint':{str(clip['returnFrame']):1}}
  hits=clip['hitFrames'];weights=[100//len(hits)]*len(hits);weights[-1]+=100-sum(weights)
  if name=='revive':node['friendhp']={str(hits[0]):100}
  elif name not in ['mystery','barrier','evade']:node['appendEffect']={str(frame):{'effectId':HIT,'target':2,'hitIndex':i,'hitCount':len(hits),'anmyhp':{'0':weight,'checkDie':int(i==len(hits)-1)}} for i,(frame,weight) in enumerate(zip(hits,weights))}
  effects[ident]=node
 for hero in [H]:
  h=copy.deepcopy(template);h.update(id=n.hexid(hero),name=C['name'] if hero==H else 'Yellow Flash Clone',assess='SSS',quality=7,profession=1,isMain=0,sex=1,level=1,needLevel=1,desc='SSS. Any formation position. '+C['balanceNote'],active=C['mystery']['id'] if hero==H else 0,normalAttack=C['standard']['id'] if hero==H else C['cloneCounter']['id'],talent=13221005,attackEffect=json.dumps(effects,separators=(',',':')),tags=C['tags'],headStyle='',heroSoul='',speed=120,speedGrow=2.5)
  h['isSummon']=int(hero!=H)
  spec=importlib.util.spec_from_file_location('balance',ROOT/'cikarim/balance-heroes.py');balance=importlib.util.module_from_spec(spec);spec.loader.exec_module(balance);h=balance.balance(h)
  db['BaseHero'].append(h);db['RoleModel'].append({'id':n.hexid(hero),'model':H,'roleStyle':H,'roleHead':H})
  desc=n.plain_description('<br>'.join(m['name']+': '+m['description'] for m in (C['passives'] if hero==H else [C['passives'][-1],C['passives'][-2]])))
  db['HeroTalent'].append({'id':n.hexid(h['talent']),'talentName':'Ten-Tails Jinchuriki / Divine Absorption' if hero==H else 'Yellow Flash / Space-Time Counter','talentDesc':desc})
 return db

def main():
 db=rows();changes={};spec=importlib.util.spec_from_file_location('release',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
 active=json.loads((n.PUBLIC/'client-release.json').read_text())['version'];assert (n.PUBLIC/active/'TApplication.swf').read_bytes()==(n.PUBLIC/'2026090619/TApplication.swf').read_bytes()
 files=set()
 for key,ver in r.rows((n.PUBLIC/active/'version.swf').read_bytes()):
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
  for hero,models in A['models'].items():
   for suffix,names in models.items():
    ident=int(f'{int(hero):X}'+suffix,16);seq=[]
    for name in [names] if isinstance(names,str) else names:
     clip=A['clips'][name];images=[Image.open(B/'frames'/f'{i:04}.png').convert('RGBA') for i in clip['assets']];pivots=[A['framePivots'][str(i)] for i in clip['assets']]
     # Lobby retains its first pivot; use one fixed canvas for every idle frame.
     if suffix=='0e':
      left=min(-v[0] for v in pivots);top=min(-v[1] for v in pivots);right=max(im.width-v[0] for im,v in zip(images,pivots));bottom=max(im.height-v[1] for im,v in zip(images,pivots));fixed=[]
      for im,v in zip(images,pivots):
       canvas=Image.new('RGBA',(right-left,bottom-top));canvas.alpha_composite(im,(-v[0]-left,-v[1]-top));fixed.append(canvas)
      images=fixed;pivots=[(-left,-top+10)]*len(images)
     else:
      images=[im.resize((max(1,round(im.width*.84)),max(1,round(im.height*.84))),Image.Resampling.LANCZOS) for im in images]
      pivots=[(round(x*.84),round(y*.84)) for x,y in pivots]
     seq.append(dict(frames=images,loop=clip['loop'],duration=40,pivots=pivots))
    changes[dest/'Model'/f'{ident:08X}.TexClient']=n.texture_sequences(ident,seq)
  for hero in [H]:
   for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(220,300)),('MiddlePicture',(220,300))]:
    source=SOURCE/('assets/user/ninja/ninjaBigImg/11011761.png' if category in ('LargeIcon','MiddlePicture') else 'assets/battle/role/head_110_100/11011761.png')
    im=ImageOps.contain(Image.open(source).convert('RGBA'),size,Image.Resampling.LANCZOS);changes[dest/category/f'{hero:08X}.TexClient']=n.texture(hero,[im],pivot=False)
  icon_ids={m['id']:m['sourceId'] for m in [C[k] for k in ['mystery','standard','standard2','standard3','standard4','susanoo','chase','limboChase','counter','barrier','evade','revive']]}
  source_skills={int(e.get('id')):e for e in ET.parse(SOURCE/'config_reference/config/skill/skillConfig.xml').getroot()}
  for key in ['mystery','standard','standard2','standard3','standard4','susanoo','chase','limboChase','counter','barrier','evade','revive']:
   move=C[key];icon_ids[move['id']]=int(source_skills[move['sourceId']].get('iconId'))

  for ident,icon in icon_ids.items():
   iconpath=SOURCE/'assets/skill/40'/f'{icon}.png'
   if not iconpath.exists():iconpath=SOURCE/'assets/skill/40/21011773.png'
   im=Image.open(iconpath).convert('RGBA')
   changes[dest/'SkillIcon'/f'{ident:08X}.TexClient']=n.texture(ident,[im],pivot=False);changes[dest/'Skill'/f'{ident:08X}.TexClient']=n.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
  changes[dest/'Skill'/f'{HIT:08X}.TexClient']=n.texture(HIT,[Image.new('RGBA',(1,1))],duration=40)
 for kind,extra in db.items():
  path=n.DATA/(kind+'.json');old=json.loads(path.read_text(encoding='utf-8'));ids={x['id'] for x in extra};changes[path]=(json.dumps([x for x in old if x['id'] not in ids]+extra,ensure_ascii=False,indent=2)+'\n').encode()
 for path,data in changes.items():
  backup=B/'backups'/path.relative_to(ROOT)
  if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 print('PASS Infinite Tsukuyomi native tables and lossless textures:',len(changes))
if __name__=='__main__':main()
