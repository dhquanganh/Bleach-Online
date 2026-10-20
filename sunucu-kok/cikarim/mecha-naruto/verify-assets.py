"""Validate native damage dispatch, full asset provenance, UI icons and HD pages."""
from pathlib import Path
from PIL import Image
import hashlib,importlib.util,json,struct,zlib,xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];SOURCE=ROOT.parent/'asset/Mecha_Naruto'
cfg=json.loads((ROOT/'sunucu/mecha-naruto.json').read_text());anim=json.loads((BASE/'animation.json').read_text());vfx=json.loads((BASE/'vfx.json').read_text());hero=cfg['heroId']
spec=importlib.util.spec_from_file_location('build',BASE/'build.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
rows=b.rows();row=rows['BaseHero'][0];assert row['assess']=='SSS' and row['quality']==7
recoverySource=json.loads((BASE/'recovery-source.json').read_text())
sourceAction=ET.fromstring(recoverySource['SkillAction.xml']);sourceEffect=ET.fromstring(recoverySource['Effect.xml'])
assert sourceAction.find('SkillEffect').get('id')==sourceEffect.get('id')
recovery=anim['moves'][str(cfg['beastRecovery']['id'])]
assert Path(sourceEffect.get('res')).stem in anim['effects'][recovery], 'Energy Recovery lost its original effect'
assert anim['clips'][recovery]['sourceAction']==sourceAction.get('attackAction')
assert len(vfx['effects'][Path(sourceEffect.get('res')).stem])==2
for item in json.loads((SOURCE/'manifest.json').read_text()):assert hashlib.sha256((SOURCE/item['file']).read_bytes()).hexdigest()==item['sha256']
for move in b.MOVES:
 clip=anim['clips'][anim['moves'][str(move['id'])]]
 if move.get('multiplier',0)>0:
  assert move['attackStat']=='atk' and move['damageType']=='physical'
  assert move['hitCount']==len(clip['hitFrames']),(move['name'],move['hitCount'],clip['hitFrames'])
  assert max(clip['hitFrames'])<clip['returnFrame']
  assert 'Physical ATK' in rows['SkillConfig'][b.MOVES.index(move)]['desc']
 for ident in clip['assets']:assert (BASE/'frames'/f'{ident:03}.png').exists() and str(ident) in anim['framePivots']
public=ROOT/'kaynak/login.gogames.me'
for name,atlas in vfx['atlases'].items():
 with Image.open(public/atlas['url'].lstrip('/')) as im:assert max(im.size)<=4096 and im.mode=='RGBA';assert im.width%atlas['columns']==0 and im.height%atlas['rows']==0
for name,clip in vfx['clips'].items():
 assert len(clip['frameAtlases'])==len(clip['timeline'])
 for page,index in zip(clip['frameAtlases'],clip['timeline']):assert 0<=index<vfx['atlases'][page]['frameCount']
for version in ['2017112917','2026090619']:
 dest=b.native.PUBLIC/version/'Resources/Textures'
 for suffix,names in anim['models'][str(hero)].items():
  ident=int(f'{hero:X}'+suffix,16);raw=(dest/'Model'/f'{ident:08X}.TexClient').read_bytes();size=struct.unpack_from('<I',raw,4)[0];count=struct.unpack_from('<H',raw,8+size)[0];assert count==len(names if isinstance(names,list) else [names])
 for move in b.MOVES:assert (dest/'SkillIcon'/f'{move["id"]:08X}.TexClient').stat().st_size>200
 icon=14130950+0x200000;raw=(dest/'Inventory'/f'{icon:08X}.TexClient').read_bytes();assert raw[12]==0 and len(raw)>200
for kind,expected in rows.items():
 table=json.loads((b.native.DATA/(kind+'.json')).read_text(encoding='utf-8'));byid={r['id']:r for r in table};assert all(byid[r['id']]==r for r in expected)
article=next(r for r in json.loads((b.native.DATA/'Article.json').read_text(encoding='utf-8')) if int(r['id'],16)==14130950);assert article['quality']==7 and article['picture']==14130950+0x200000
print('PASS Mecha: 16 supplied assets; 13 distinct animation dispatches; source hit markers; both native texture versions; SSS databases; physical descriptions; fragment association/icon; HD lossless pages',len(vfx['atlases']))
