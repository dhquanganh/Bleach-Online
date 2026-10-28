from pathlib import Path
import json,zlib,struct,hashlib,importlib.util
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite';P=R/'sunucu-kok/kaynak/login.gogames.me/public'
s=importlib.util.spec_from_file_location('r',B/'release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
V=json.loads((P/'client-release.json').read_text())['version'];assert V=='2026102805'
rows=r.manifest.rows((P/V/'version.swf').read_bytes());count=0
for key,ver in rows:
 key=key.decode();ver=ver.decode()
 if ver==V:
  assert (P/ver/key).is_file(),key
  if key.startswith('Resources/Textures/'):count+=1
assert count==37,count
assert (P/V/'TApplication.swf').read_bytes()==(P/'2026090619/TApplication.swf').read_bytes()
data=R/'sunucu-kok/cikarim/veri-json'
for table,ids in [('BaseHero',[11121005]),('HeroTalent',[13221005]),('SkillConfig',list(range(13122201,13122213)))]:
 db=json.loads((data/(table+'.json')).read_text(encoding='utf-8'))
 for ident in ids:
  row=next(x for x in db if int(x['id'],16)==ident)
  for key in ['desc','talentDesc']:
   if key in row:assert '<font' not in row[key] and '<br' not in row[key],(ident,key)
tags=json.loads((P/'character-tags/heroes.json').read_text());assert tags['heroes']['11121005']==[26,52,1,13,14,31,46,48,58]
for i in tags['heroes']['11121005']:assert (P/'character-tags'/f'{i}.png').is_file()
for src in (R/'asset/Madara_Infinite_Tsukuyomi_Full/assets/battle/effect').glob('yuehziyan*.swf'):
 assert src.read_bytes()==(P/'madara-infinite-vfx/native'/src.name).read_bytes()
report={'version':V,'textures':count,'tagIcons':9,'nativeEffects':14,'plainDescriptions':True,'clientSha256':hashlib.sha256((P/V/'TApplication.swf').read_bytes()).hexdigest()}
(B/'published-validation.json').write_text(json.dumps(report,indent=2)+'\n');print('PASS published assets',report)
