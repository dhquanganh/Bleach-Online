from pathlib import Path
from PIL import Image,ImageOps
import importlib.util,json,copy,struct,zlib,shutil,xml.etree.ElementTree as ET
B=Path(__file__).resolve().parent;ROOT=B.parents[1]
s=importlib.util.spec_from_file_location('packed',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);n=p.native
C=json.loads((ROOT/'sunucu/kakuzu-edo.json').read_text());A=json.loads((B/'animation.json').read_text());H=C['heroId'];SOURCE=ROOT.parent/'asset/Kakuzu_Edo_Tensei_Full';HIT=13622901
def rows():
 source=ET.parse(SOURCE/'config_reference/config/skill/skillConfig.xml').getroot();skills={int(e.get('id')):e for e in source}
 source_ids={13121901:21305458,13121902:21005453,13121903:21005453,13121904:21005454,13121905:21205454,13121906:21305454,13121907:21005455,13121908:21005459,13121909:21005457,13121910:21005456}
 desc={i:skills[src].findtext('desc') for i,src in source_ids.items()}
 # Preserve the wording in the requested screenshot for the Mystery and round-end rescue.
 desc[13121901]='Causes unavoidable damage neglecting Shields and Interruption to the selected unit. After this skill is executed, dispels all Fear Kakuzu currently has. If the selected unit\'s HP is lower than 15%, this skill has additional Critical Rate increase.'
 desc[13121904]='Additional Skill; Wind: Causes unavoidable damage and Discouragement to all units in a random opponent\'s lineup and increases your lineup\'s Initiative by 3% (not stackable) until the end of the next round.'
 desc[13121905]='Additional Skill; Lightning: Causes unavoidable damage and Level 2 - Paralysis until the end of the round to all units in a random opponent\'s lineup and reduces Kakuzu\'s Mystery Cooldown by 1.'
 desc[13121906]='Additional Skill; Fire: Causes unavoidable damage and Suppress Immunity for 1 round to all units in a random opponent\'s lineup and dispels all Ignition Kakuzu currently has.'
 desc[13121908]='At the end of the round, revives a random ally ninja to 30% HP. This skill is still active even when Water Clone is controlled.'
 names={i:C[key]['name'] for i,key in [(13121901,'mystery'),(13121902,'standard'),(13121903,'cloneStandard'),(13121904,'pressure'),(13121905,'darkness'),(13121906,'migraine'),(13121907,'cloneCall'),(13121908,'reattachment'),(13121909,'reincarnation'),(13121910,'waterHiding')]}
 (B/'descriptions.json').write_text(json.dumps(desc,indent=2)+'\n')
 db={'BaseHero':[],'RoleModel':[],'HeroTalent':[],'SkillConfig':[{'id':n.hexid(i),'skillId':i,'name':names[i],'desc':desc[i]+(' All damage scales with Physical ATK and is reduced by Physical DEF.' if i<=13121906 else ''),'icon':i,'sortId':i-13121900} for i in names]}
 template=next(x for x in json.loads((n.DATA/'BaseHero.json').read_text(encoding='utf-8')) if int(x['id'],16)==11120995)
 for hero in [H,C['summonId']]:
  effects={}
  for ident,name in A['moves'].items():
   if hero==C['summonId'] and name not in ('clone-standard','reattach','summon','reincarnation'):continue
   if hero==H and name=='clone-standard':continue
   clip=A['clips'][name];node={'target':1,'backPoint':{str(clip['returnFrame']):1}}
   if name in ('summon','reattach','reincarnation'):node['friendhp']={str(clip['hitFrames'][0]):100}
   else:
    hits=clip['hitFrames'];weights=[100//len(hits)]*len(hits);weights[-1]+=100-sum(weights)
    node['appendEffect']={str(frame):{'effectId':HIT,'target':2,'hitIndex':i,'hitCount':len(hits),'anmyhp':{'0':weight,'checkDie':int(i==len(hits)-1)}} for i,(frame,weight) in enumerate(zip(hits,weights))}
   effects[ident]=node
  h=copy.deepcopy(template);h.update(id=n.hexid(hero),name=C['name'] if hero==H else 'Water Clone',assess='SSS',quality=7,profession=1,isMain=0,sex=1,level=1,needLevel=1,desc='SSS. Any formation position. All damage scales with Physical ATK. '+desc[13121907],active=13121901 if hero==H else 0,normalAttack=13121902 if hero==H else 13121903,talent=13220997 if hero==H else 13220998,attackEffect=json.dumps(effects,separators=(',',':')),tags=C['tags'] if hero==H else [29,52,7],headStyle='',heroSoul='',power=8500,agile=7800,intelligence=7000,life=16000,speed=120,powerGrow=3.5,agileGrow=3.1,intelligenceGrow=2.8,lifeGrow=5,speedGrow=2.5)
  h['isSummon']=int(hero==C['summonId']);db['BaseHero'].append(h);db['RoleModel'].append({'id':n.hexid(hero),'model':H,'roleStyle':H,'roleHead':H})
  db['HeroTalent'].append({'id':n.hexid(13220997 if hero==H else 13220998),'talentName':'Earth Grudge Fear / Water Clone' if hero==H else 'Water Clone Jutsu','talentDesc':'<br>'.join(desc[i] for i in range(13121904,13121911)) if hero==H else desc[13121907]})
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
  for hero in [H,C['summonId']]:
   for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(220,300)),('MiddlePicture',(220,300))]:
    source=SOURCE/('assets/user/ninja/ninjaBigImg/11005451.png' if category in ('LargeIcon','MiddlePicture') else 'assets/battle/role/head_110_100/11005451.png')
    im=ImageOps.contain(Image.open(source).convert('RGBA'),size,Image.Resampling.LANCZOS);changes[dest/category/f'{hero:08X}.TexClient']=n.texture(hero,[im],pivot=False)
  icon_ids={13121901:21005458,13121902:21005453,13121903:21005453,13121904:21005453,13121905:21005453,13121906:21005453,13121907:21005455,13121908:21005459,13121909:21005457,13121910:21005456}
  for ident,icon in icon_ids.items():
   im=Image.open(SOURCE/'assets/skill/40'/f'{icon}.png').convert('RGBA')
   changes[dest/'SkillIcon'/f'{ident:08X}.TexClient']=n.texture(ident,[im],pivot=False);changes[dest/'Skill'/f'{ident:08X}.TexClient']=n.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
  changes[dest/'Skill'/f'{HIT:08X}.TexClient']=n.texture(HIT,[Image.new('RGBA',(1,1))],duration=40)
 for kind,extra in db.items():
  path=n.DATA/(kind+'.json');old=json.loads(path.read_text(encoding='utf-8'));ids={x['id'] for x in extra};changes[path]=(json.dumps([x for x in old if x['id'] not in ids]+extra,ensure_ascii=False,indent=2)+'\n').encode()
 for path,data in changes.items():
  backup=B/'backups'/path.relative_to(ROOT)
  if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 print('PASS Kakuzu/Water Clone native tables and lossless textures:',len(changes))
if __name__=='__main__':main()
