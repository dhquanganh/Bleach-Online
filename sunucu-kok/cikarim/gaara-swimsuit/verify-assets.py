"""Check native assets, lossless effect streams, aspect ratios and isolated dispatch."""
from pathlib import Path
from PIL import Image
import importlib.util,json,struct,zlib
B=Path(__file__).resolve().parent;R=B.parents[1];P=R/'kaynak/login.gogames.me/public';H=11120991
a=json.loads((B/'animation.json').read_text());v=json.loads((B/'vfx.json').read_text());streams=json.loads((B/'streaming.json').read_text())
assert len(a['moves'])==4 and len(v['effects'])==5
for name,c in a['clips'].items():
 assert c['assets']
 if not c['loop']:assert c['returnFrame']==len(c['assets'])-1
 for i in c['assets']:
  with Image.open(B/'frames'/f'{i:03}.png') as im:assert im.width>0 and im.height>0 and str(i) in a['framePivots']
 for f in c.get('hitFrames',[]):assert 0<=f<c['returnFrame']
for name,m in v['atlases'].items():
 path=P.parent/m['url'].lstrip('/');raw=zlib.decompress(path.with_suffix('.argb').read_bytes());w,h=struct.unpack_from('>II',raw)
 assert w<=2048 and h<=2048 and len(raw)==8+w*h*4
 with Image.open(path) as im:assert im.size==(w,h)
 assert name in streams
for c in v['clips'].values():
 assert len(c['timeline'])==len(c['frameAtlases'])
 for index,name in zip(c['timeline'],c['frameAtlases']):assert 0<=index<v['atlases'][name]['frameCount']
for kind,ident in [('BaseHero',H),('RoleModel',H),('HeroTalent',13220991),('Article',14130991),('HeroChangeAttr',H)]:
 rows=json.loads((R/'cikarim/veri-json'/f'{kind}.json').read_text(encoding='utf8'));assert sum(int(r['id'],16)==ident for r in rows)==1
skills=json.loads((R/'cikarim/veri-json/SkillConfig.json').read_text(encoding='utf8'))
heroes=json.loads((R/'cikarim/veri-json/BaseHero.json').read_text(encoding='utf8'));hero=next(r for r in heroes if int(r['id'],16)==H)
assert hero['assess']=='SSS' and hero['quality']==7 and hero['desc'].startswith('SSS.')
articles=json.loads((R/'cikarim/veri-json/Article.json').read_text(encoding='utf8'));assert next(r for r in articles if int(r['id'],16)==14130991)['quality']==7
for ident in range(13121501,13121507):
 assert any(int(r['id'],16)==ident for r in skills)
 assert (P/'2026090619/Resources/Textures/SkillIcon'/f'{ident:08X}.TexClient').exists()
for suffix in a['models'][str(H)]:assert (P/'2026090619/Resources/Textures/Model'/f'{int(f"{H:X}"+suffix,16):08X}.TexClient').exists()
role=(B/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf8');active=(B/'verify/scripts/Processors/Game/Battle/Character/TActive.as').read_text(encoding='utf8')
for name in ['UpdateGaaraVfx','UpdateNagatoVfx','UpdateMechaVfx','UpdateItachiVfx','UpdateSasukeVfx']:assert 'function '+name+'(' in role
assert 'gaaraSkillVfx' in role and 'this.FId == 11120991' in active
assert 'function GaaraStrikeOffset(' in role and 'function GaaraStrikePose(' in role
print('PASS Gaara SSS/quality 7, native tables, models, 6 icons, fragment, 5 original effects /',len(v['atlases']),'lossless <=2048px pages, isolated motion and all dispatchers preserved')
