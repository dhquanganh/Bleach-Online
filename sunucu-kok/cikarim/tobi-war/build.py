from pathlib import Path
from PIL import Image,ImageOps
import importlib.util,json,copy,struct,zlib,shutil,xml.etree.ElementTree as ET
B=Path(__file__).resolve().parent;ROOT=B.parents[1]
s=importlib.util.spec_from_file_location('packed',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);n=p.native
C=json.loads((ROOT/'sunucu/tobi-war.json').read_text());A=json.loads((B/'animation.json').read_text());H=C['heroId'];SOURCE=ROOT.parent/'asset/Tobi_Great_Ninja_War_Full';HIT=13622801
def rows():
 source=ET.parse(SOURCE/'config_reference/config/skill/skillConfig.xml').getroot();skills={int(e.get('id')):e for e in source}
 desc={13121801:skills[21015518].findtext('desc'),13121802:skills[21015511].findtext('desc'),13121803:skills[21015513].findtext('desc'),13121804:skills[21015514].findtext('desc'),13121805:skills[21015515].findtext('desc'),13121806:'Summons 2 White Zetsus with 60% of Tobi\'s max HP.',13121807:'Sacrifices the White Zetsu with the lowest HP to revive Tobi to 40% HP.',13121808:'White Zetsu attacks an opponent. Damage scales with max HP.',13121809:'Spore Jutsu: recovers 50% HP at the end of the round.',13121810:skills[21015516].findtext('desc'),13121811:'Tobi is immune to Debuffs. Whenever Tobi executes a Trigger skill, recovers 20 Chakra. Whenever Tobi suffers fatal damage, if there is a White Zetsu in your lineup, sacrifice the Clone with the lowest HP to revive Tobi to 40% HP.',13121812:'White Zetsu cannot be defeated by Mystery skills and recovers 50% HP at the end of the round. While White Zetsu is alive, whenever a ninja in your lineup is attacked for the first time in a round, all units in your lineup will have their Mystery\'s Chakra Cost decreased by 10 and if that damage is a Mystery\'s damage, decreases 20 instead (stackable up to 40), lasts until the end of the round.'}
 names={13121801:C['mystery']['name'],13121802:'Taijutsu Attack',13121803:'Taijutsu Attack',13121804:C['chases'][0]['name'],13121805:C['summit']['name'],13121806:'White Zetsu Call',13121807:'Wood Style Chakra - Revival',13121808:'White Zetsu Attack',13121809:'Spore Jutsu - Recovery',13121810:'White Zetsu Mutation',13121811:'Wood Style Chakra',13121812:'Spore Jutsu'}
 (B/'descriptions.json').write_text(json.dumps(desc,indent=2)+'\n')
 db={'BaseHero':[],'RoleModel':[],'HeroTalent':[],'SkillConfig':[{'id':n.hexid(i),'skillId':i,'name':names[i],'desc':desc[i]+(' All damage scales with maximum HP and is reduced by Physical DEF.' if i<=13121805 else ''),'icon':i,'sortId':i-13121800} for i in names]}
 template=next(x for x in json.loads((n.DATA/'BaseHero.json').read_text(encoding='utf-8')) if int(x['id'],16)==11120992)
 for hero in [H,C['summonId']]:
  effects={}
  for ident,name in A['moves'].items():
   if (hero==C['summonId'])!=name.startswith('zetsu'):continue
   clip=A['clips'][name];node={'target':1,'backPoint':{str(clip['returnFrame']):1}}
   if name in ['summon','revive','zetsu-heal']:node['friendhp']={str(clip['hitFrames'][0]):100}
   else:
    hits=clip['hitFrames'];weights=[100//len(hits)]*len(hits);weights[-1]+=100-sum(weights)
    node['appendEffect']={str(frame):{'effectId':HIT,'target':2,'hitIndex':i,'hitCount':len(hits),'anmyhp':{'0':weight,'checkDie':int(i==len(hits)-1)}} for i,(frame,weight) in enumerate(zip(hits,weights))}
   effects[ident]=node
  h=copy.deepcopy(template);h.update(id=n.hexid(hero),name=C['name'] if hero==H else 'White Zetsu',assess='SSS',quality=7,profession=1,isMain=0,sex=1,level=1,needLevel=1,desc='SSS. Any formation position. All damage scales with maximum HP. '+desc[13121810],active=13121801 if hero==H else 0,normalAttack=13121802 if hero==H else 13121808,talent=13220995 if hero==H else 13220996,attackEffect=json.dumps(effects,separators=(',',':')),tags=C['tags'] if hero==H else [30,52,12,14],headStyle='',heroSoul='',power=8000,agile=8000,intelligence=8000,life=16000,speed=120,powerGrow=3.4,agileGrow=3.4,intelligenceGrow=3.4,lifeGrow=5,speedGrow=2.5)
  h['isSummon']=int(hero==C['summonId']);db['BaseHero'].append(h);db['RoleModel'].append({'id':n.hexid(hero),'model':hero,'roleStyle':hero,'roleHead':hero})
  db['HeroTalent'].append({'id':n.hexid(13220995 if hero==H else 13220996),'talentName':'White Zetsu Mutation / Wood Style Chakra' if hero==H else 'Spore Jutsu','talentDesc':(desc[13121810]+'<br>'+desc[13121811]+'<br>'+desc[13121812]) if hero==H else desc[13121812]})
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
     clip=A['clips'][name];images=[Image.open(B/'frames'/f'{i:03}.png').convert('RGBA') for i in clip['assets']];pivots=[A['framePivots'][str(i)] for i in clip['assets']]
     # Lobby retains its first pivot; use one fixed canvas for every idle frame.
     if suffix=='0e':
      left=min(-v[0] for v in pivots);top=min(-v[1] for v in pivots);right=max(im.width-v[0] for im,v in zip(images,pivots));bottom=max(im.height-v[1] for im,v in zip(images,pivots));fixed=[]
      for im,v in zip(images,pivots):
       canvas=Image.new('RGBA',(right-left,bottom-top));canvas.alpha_composite(im,(-v[0]-left,-v[1]-top));fixed.append(canvas)
      images=fixed;pivots=[(-left,-top+13)]*len(images)
     else:
      images=[im.resize((max(1,round(im.width*.9)),max(1,round(im.height*.9))),Image.Resampling.LANCZOS) for im in images]
      pivots=[(round(x*.9),round(y*.9)) for x,y in pivots]
     seq.append(dict(frames=images,loop=clip['loop'],duration=40,pivots=pivots))
    changes[dest/'Model'/f'{ident:08X}.TexClient']=n.texture_sequences(ident,seq)
  for hero,source in [(H,SOURCE),(C['summonId'],SOURCE/'White_Zetsu_Tobi_Summon')]:
   asset=11015511 if hero==H else 19019401
   for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(220,300)),('MiddlePicture',(220,300))]:
    path=source/('assets/user/ninja/ninjaBigImg/11015511.png' if hero==H and category in ['LargeIcon','MiddlePicture'] else f'assets/battle/role/head_110_100/{asset}.png')
    im=ImageOps.contain(Image.open(path).convert('RGBA'),size,Image.Resampling.LANCZOS);changes[dest/category/f'{hero:08X}.TexClient']=n.texture(hero,[im],pivot=False)
  for i in range(13121801,13121813):
   icon={1:21015518,2:21015513,3:21015513,4:21015514,5:21015515}.get(i-13121800,21015516);im=Image.open(SOURCE/'assets/skill/40'/f'{icon}.png').convert('RGBA')
   changes[dest/'SkillIcon'/f'{i:08X}.TexClient']=n.texture(i,[im],pivot=False);changes[dest/'Skill'/f'{i:08X}.TexClient']=n.texture(i,[Image.new('RGBA',(1,1))],duration=40)
  changes[dest/'Skill'/f'{HIT:08X}.TexClient']=n.texture(HIT,[Image.new('RGBA',(1,1))],duration=40)
 for kind,extra in db.items():
  path=n.DATA/(kind+'.json');old=json.loads(path.read_text(encoding='utf-8'));ids={x['id'] for x in extra};changes[path]=(json.dumps([x for x in old if x['id'] not in ids]+extra,ensure_ascii=False,indent=2)+'\n').encode()
 for path,data in changes.items():
  backup=B/'backups'/path.relative_to(ROOT)
  if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 print('PASS Tobi/White Zetsu native tables and lossless textures:',len(changes))
if __name__=='__main__':main()
