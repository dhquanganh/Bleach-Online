"""Asuma native records, lossless compact actor atlases and complete inventory items."""
from pathlib import Path
from PIL import Image,ImageOps
import importlib.util,json,copy,struct,zlib,shutil,xml.etree.ElementTree as ET
B=Path(__file__).resolve().parent;ROOT=B.parents[1];SOURCE=ROOT.parent/'asset/Asuma_Wind_Blade_Full'
s=importlib.util.spec_from_file_location('packing',B.parent/'shared-animation/packing.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p);n=p.native
s=importlib.util.spec_from_file_location('items',B.parent/'ninja-fragments/build.py');f=importlib.util.module_from_spec(s);s.loader.exec_module(f)
C=json.loads((ROOT/'sunucu/asuma-wind.json').read_text());A=json.loads((B/'animation.json').read_text());H=C['heroId'];HIT=13623801;FRAGMENT=14131011;TOKEN=14141011;ICON=FRAGMENT+0x200000;OFFER=41121011
def records():
 effects={}
 for ident,name in A['moves'].items():
  clip=A['clips'][name];node={'target':1,'backPoint':{str(clip['returnFrame']):1}}
  if name not in ['courage']:
   hits=clip['hitFrames'];weights=[100//len(hits)]*len(hits);weights[-1]+=100-sum(weights)
   node['appendEffect']={str(frame):{'effectId':HIT,'target':2,'hitIndex':i,'hitCount':len(hits),'anmyhp':{'0':weight,'checkDie':int(i==len(hits)-1)}} for i,(frame,weight) in enumerate(zip(hits,weights))}
  effects[ident]=node
 template=next(r for r in json.loads((n.DATA/'BaseHero.json').read_text(encoding='utf-8')) if int(r['id'],16)==11120994)
 hero=copy.deepcopy(template);hero.update(id=n.hexid(H),name=C['name'],assess=C['assess'],quality=C['quality'],profession=1,isMain=0,isSummon=0,sex=1,level=1,needLevel=1,desc='S+. Any formation position. '+C['balanceNote'],active=C['mystery']['id'],normalAttack=C['standard']['id'],talent=13221011,attackEffect=json.dumps(effects,separators=(',',':')),tags=C['tags'],headStyle='',heroSoul='',speed=180,speedGrow=2.5)
 s=importlib.util.spec_from_file_location('balance',ROOT/'cikarim/balance-heroes.py');balance=importlib.util.module_from_spec(s);s.loader.exec_module(balance);hero=balance.balance(hero)
 db={'BaseHero':[hero],'RoleModel':[{'id':n.hexid(H),'model':H,'roleStyle':H,'roleHead':H}],'HeroTalent':[{'id':n.hexid(13221011),'talentName':'Pose of Invincibility','talentDesc':' '.join(C[k]['name']+': '+C[k]['description'] for k in ['courage','aura'])}],'SkillConfig':[]}
 for key in C['skillKeys']:
  move=C[key];desc=move['description']+(' All damage scales with Physical ATK against Physical DEF.' if move.get('damageType') else '')
  db['SkillConfig'].append({'id':n.hexid(move['id']),'skillId':move['id'],'name':move['name'],'desc':desc,'icon':move['id'],'sortId':move['id']-13122800})
 return db
def main():
 db=records();changes={}
 articles=json.loads((n.DATA/'Article.json').read_text(encoding='utf-8'));attrs=json.loads((n.DATA/'HeroChangeAttr.json').read_text(encoding='utf-8'));market=json.loads((n.DATA/'BlackMarket.json').read_text(encoding='utf-8'))
 fragment=copy.deepcopy(next(r for r in articles if int(r['id'],16)==14131010));fragment.update(id=n.hexid(FRAGMENT),name=C['name']+' Modify Fragment',quality=5,sort=FRAGMENT,picture=ICON,functionDesc='<p>Asuma [Wind Blade] Modify Fragment. Used for star upgrades and reincarnation.</p>')
 token=copy.deepcopy(next(r for r in articles if int(r['id'],16)==14141010));token.update(id=n.hexid(TOKEN),name=C['name']+' Recruit Token',quality=5,sort=TOKEN,picture=ICON,f16=H,functionDesc='<p>Use to recruit Asuma [Wind Blade]. Not consumed if already owned.</p>')
 attr=copy.deepcopy(next(r for r in attrs if int(r['id'],16)==11121010));attr.update(id=n.hexid(H),chipValue=FRAGMENT)
 price=json.dumps({'type':1,'code':14900001,'amount':100},separators=(',',':'));offer={'id':n.hexid(OFFER),'model':1,'itemID':FRAGMENT,'oldPrice':price,'price':price,'number':1,'totalTimes':2147483647}
 extras={2:[fragment,token],0xCC:[attr],0xCB:[offer]}
 def patch(raw):
  kind=struct.unpack_from('<I',raw)[0]-0x1000000
  if kind in extras:
   old=f.records(raw,kind);rep={int(r['id'],16):f.serialize(kind,r) for r in extras[kind]};have=dict(old);pairs=[(i,rep.get(i,b)) for i,b in old]+[(i,b) for i,b in rep.items() if i not in have];out=raw[:4]+n.u32(len(pairs))+b''.join(b for i,b in pairs);check=dict(f.records(out,kind));assert all(check[i]==b for i,b in old if i not in rep);return out
  return n.patch(raw,db)
 s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
 active=json.loads((n.PUBLIC/'client-release.json').read_text())['version'];files=set()
 for key,ver in m.rows((n.PUBLIC/active/'version.swf').read_bytes()):
  if key.startswith(b'Resources/Bin/') and key.endswith((b'.bin',b'.binPackage')):files.add(n.PUBLIC/ver.decode()/key.decode())
 for version in ['2017112917','2026090619']:files.update((n.PUBLIC/version/'Resources/Bin').rglob('*.bin'));files.update((n.PUBLIC/version/'Resources/Bin').rglob('*.binPackage'))
 for path in files:
  if not path.is_file():continue
  raw=path.read_bytes()
  if path.suffix=='.bin':
   decoded=zlib.decompress(raw);out=patch(decoded)
   if out!=decoded:changes[path]=zlib.compress(out)
  else:
   pos=6;parts=[raw[:6]];changed=False
   for _ in range(struct.unpack_from('<H',raw,4)[0]):
    size=struct.unpack_from('<I',raw,pos)[0];pos+=4;chunk=raw[pos:pos+size];pos+=size;decoded=zlib.decompress(chunk);out=patch(decoded)
    if out!=decoded:chunk=zlib.compress(out);changed=True
    parts.extend([n.u32(len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+raw[pos:]
 sourceSkills={int(r.get('id')):r for r in ET.parse(SOURCE/'config_reference/config/skill/skillConfig.xml').getroot()}
 for version in ['2017112917','2026090619']:
  dest=n.PUBLIC/version/'Resources/Textures'
  for suffix,names in A['models'][str(H)].items():
   seq=[];ident=int(f'{H:X}'+suffix,16)
   for name in [names] if isinstance(names,str) else names:
    clip=A['clips'][name];images=[Image.open(B/'frames'/f'{i:04}.png').convert('RGBA') for i in clip['assets']];pivots=[A['framePivots'][str(i)] for i in clip['assets']]
    seq.append(dict(frames=images,loop=clip['loop'],duration=40,pivots=pivots))
   changes[dest/'Model'/f'{ident:08X}.TexClient']=n.texture_sequences(ident,seq)
  for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(220,300)),('MiddlePicture',(220,300))]:
   source=SOURCE/('assets/user/ninja/ninjaBigImg/11003911.png' if category in ['LargeIcon','MiddlePicture'] else 'assets/battle/role/head_110_100/11003911.png')
   image=ImageOps.contain(Image.open(source).convert('RGBA'),size,Image.Resampling.LANCZOS);changes[dest/category/f'{H:08X}.TexClient']=n.texture(H,[image],pivot=False)
  for key in C['skillKeys']:
   move=C[key];icon=int(sourceSkills[move['sourceId']].get('iconId'));image=Image.open(SOURCE/'assets/skill/40'/f'{icon}.png').convert('RGBA');changes[dest/'SkillIcon'/f'{move["id"]:08X}.TexClient']=n.texture(move['id'],[image],pivot=False);changes[dest/'Skill'/f'{move["id"]:08X}.TexClient']=n.texture(move['id'],[Image.new('RGBA',(1,1))],duration=40)
  changes[dest/'Skill'/f'{HIT:08X}.TexClient']=n.texture(HIT,[Image.new('RGBA',(1,1))],duration=40)
  icon=ImageOps.contain(Image.open(SOURCE/'assets/battle/role/head_45_45/11003911.png').convert('RGBA'),(40,40),Image.Resampling.LANCZOS);changes[dest/'Article'/f'{ICON:08X}.TexClient']=f.inventory_texture(ICON,icon)
 for name,extra in list(db.items())+[('Article',extras[2]),('HeroChangeAttr',extras[0xCC]),('BlackMarket',extras[0xCB])]:
  path=n.DATA/(name+'.json');old=json.loads(path.read_text(encoding='utf-8'));ids={r['id'] for r in extra};changes[path]=(json.dumps([r for r in old if r['id'] not in ids]+extra,ensure_ascii=False,indent=2)+'\n').encode()
 path=ROOT/'sunucu/naruto-recruit-items.json';catalog=json.loads(path.read_text(encoding='utf-8'));catalog=[r for r in catalog if r['heroId']!=H]+[{'heroId':H,'itemId':TOKEN,'fragmentId':FRAGMENT,'picture':ICON,'name':token['name']}];changes[path]=(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n').encode()
 path=ROOT/'sunucu/mystic-shop-config.json';marketConfig=json.loads(path.read_text());marketConfig['revision']=marketConfig.get('revision',0)+1;marketConfig['offers']=[r for r in marketConfig['offers'] if r.get('heroID')!=H]+[{'id':OFFER,'model':1,'heroID':H,'itemID':FRAGMENT,'number':1,'price':json.loads(price),'totalTimes':2147483647}];changes[path]=(json.dumps(marketConfig,ensure_ascii=False,indent=2)+'\n').encode()
 for path,data in changes.items():
  backup=B/'backups'/path.relative_to(ROOT)
  if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 (B/'build-report.json').write_text(json.dumps({'heroId':H,'fragmentId':FRAGMENT,'tokenId':TOKEN,'textureBytes':sum(len(v) for k,v in changes.items() if k.suffix=='.TexClient' and '2026090619' in str(k)),'files':len(changes)},indent=2))
 print('PASS Asuma tables/items/atlases',len(changes),'files')
if __name__=='__main__':main()
