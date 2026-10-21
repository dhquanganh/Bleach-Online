"""Shared native hit timing. Aggregate battle damage is divided, never multiplied."""
import json,re
from pathlib import Path

PATTERNS={
 'mecha-naruto':{'bomb':[22,85,108,126],'combo':[7,10,14,20,34,68,72,77],
  'beam':[18,28,34],'rasengan':[36,43,51,62],'modified':[36,43,51,62],
  'extreme':[18,28,34],'high-bomb':[22,85,108,126],
  'beast-bomb':[53,59,65,71],'claw':[38,42,46,50],'sweep':[51,61,72]},
 'itachi-rtn':{'mystery':[41,51,74,93],'modified':[41,51,74,93],
  'standard':[31,36,41,46],'deidara':[110,128],'pain':[58,131,160],'hidan':[12,81,95]},
 'pain-tendo':{'standard':[21,28,35,42],'almighty':[18,23,28,33],
  'extreme':[78,91,104,117,130],'chase':[20,25,30,35],
  'laser':[49,55,61,67],'super':[78,91,104,117,130]},
 'hashirama-final':{'taijutsu':[9,13,17,21],'sword':[20,26,32,38],
  'deity':[51,63,75,87,99],'rumbling':[93,114,135,156,177],
  'adamantine':[20,26,32,38],'severe':[20,31,42,53,64],
  'burst-severe':[20,31,42,53,64],'golem':[19,25,31,37,43]}}

def configure(character,animation):
 for name,frames in PATTERNS[character].items():
  clip=animation['clips'][name]
  assert frames==sorted(set(frames)) and frames[-1]<clip['returnFrame']
  clip['hitFrames']=frames[:]

def append_effect(clip,effect_id):
 frames=clip['hitFrames'];count=len(frames)
 return {str(frame):{'target':2,'effectId':effect_id,'hitIndex':i,'hitCount':count,
  'anmyhp':{'0':100//count,'checkDie':int(i==count-1)}} for i,frame in enumerate(frames)}

def install(characters=('pain-tendo','hashirama-final')):
 import importlib.util,struct,sys,zlib,shutil
 base=Path(__file__).resolve().parent
 sys.path.insert(0,str(base/'naruto-sage'))
 spec=importlib.util.spec_from_file_location('native',base/'naruto-sage/build.py')
 native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
 rows={k:[] for k in ['BaseHero','HeroTalent','SkillConfig','RoleModel']}
 data=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
 skills=json.loads((native.DATA/'SkillConfig.json').read_text(encoding='utf-8'))
 descriptions={};changes={};moves_checked=0
 for character,hero,effect_id in [('pain-tendo',11120930,13621971),('hashirama-final',11120940,13622001),('mecha-naruto',11120950,13622101),('itachi-rtn',11120960,13622201)]:
  if character not in characters:continue
  path=base/character/'animation.json';anim=json.loads(path.read_text());configure(character,anim)
  changes[path]=(json.dumps(anim,indent=2)+'\n').encode()
  row=next(r for r in data if int(r['id'],16)==hero);effects=json.loads(row['attackEffect'])
  cfgpath=base.parent/'sunucu'/(character+'.json');cfg=json.loads(cfgpath.read_text())
  def walk(v):
   if isinstance(v,dict):
    if str(v.get('id')) in anim['moves']:
     clip=anim['clips'][anim['moves'][str(v['id'])]]
     if 'hitFrames' in clip:
      count=len(clip['hitFrames']);v['hitCount']=count
      effects[str(v['id'])]['appendEffect']=append_effect(clip,effect_id)
      descriptions[v['id']]=f' Deals {count} consecutive damage hits; the listed damage coefficient is the total per cast.'
    for child in v.values():walk(child)
   elif isinstance(v,list):
    for child in v:walk(child)
  walk(cfg);moves_checked+=sum('hitFrames' in anim['clips'][name] for name in anim['moves'].values())
  changes[cfgpath]=(json.dumps(cfg,ensure_ascii=False,indent=2)+'\n').encode()
  row['attackEffect']=json.dumps(effects,separators=(',',':'));rows['BaseHero'].append(row)
 for row in skills:
  ident=int(row['id'],16)
  if ident in descriptions:
   suffix=descriptions[ident]
   desc=re.sub(r' Deals \d+ consecutive damage hits; the listed damage coefficient is the total per cast\.','',row['desc'])
   physical=' Deals physical damage, scales with Physical ATK and is mitigated by Physical DEF.'
   row['desc']=desc[:-len(physical)]+suffix+physical if 13121101<=ident<=13121207 and desc.endswith(physical) else desc+suffix
   rows['SkillConfig'].append(row)
 changes[native.DATA/'BaseHero.json']=(json.dumps(data,ensure_ascii=False,indent=2)+'\n').encode()
 changes[native.DATA/'SkillConfig.json']=(json.dumps(skills,ensure_ascii=False,indent=2)+'\n').encode()
 for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file() or path.suffix not in ['.bin','.binPackage']:continue
  b=path.read_bytes()
  if path.suffix=='.bin':
   if path.stem.upper() not in ['01000005','0100003F']:continue
   raw=zlib.decompress(b);new=native.patch(raw,rows)
   if new!=raw:changes[path]=zlib.compress(new)
  else:
   pos=6;parts=[b[:6]];changed=False
   for _ in range(struct.unpack_from('<H',b,4)[0]):
    n=struct.unpack_from('<I',b,pos)[0];pos+=4;c=b[pos:pos+n];pos+=n
    raw=zlib.decompress(c);new=native.patch(raw,rows)
    if new!=raw:c=zlib.compress(new);changed=True
    parts.extend([native.u32(len(c)),c])
   if changed:changes[path]=b''.join(parts)+b[pos:]
 updated=0
 for path,content in changes.items():
  if path.read_bytes()!=content:
   if any(c in characters for c in ['mecha-naruto','itachi-rtn']):
    backup=base/'damage-float/backups/data'/path.relative_to(base.parent);backup.parent.mkdir(parents=True,exist_ok=True)
    if not backup.exists():shutil.copy2(path,backup)
   path.write_bytes(content);updated+=1
 print('PASS',moves_checked,'damaging skills: consecutive impact markers; updated',updated,'files; unrelated native records preserved')
 return changes

if __name__=='__main__':install()
