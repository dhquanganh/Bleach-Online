"""Audit Sasuke source assets, packed actor pixels, VFX pages and release routes."""
from pathlib import Path
from PIL import Image
import hashlib,importlib.util,json
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];PUBLIC=ROOT/'kaynak/login.gogames.me/public'
s=importlib.util.spec_from_file_location('pixels',BASE.parent/'naruto-sage-native/verify.py');pixels=importlib.util.module_from_spec(s);s.loader.exec_module(pixels)
def main():
 anim=json.loads((BASE/'animation.json').read_text());pixels.BASE=BASE;pixels.ANIM=anim
 count=0
 for version in ['2017112917','2026090619']:
  for suffix in ['', '0A','0B','0C','0D','0E','0F']:
   ident=int(f'{11120970:X}'+suffix,16);count+=pixels.verify_model(PUBLIC/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient',11120970)
 fx=json.loads((BASE/'vfx.json').read_text())
 streams=json.loads((BASE/'streaming.json').read_text())
 for meta in fx['atlases'].values():
  p=ROOT/'kaynak/login.gogames.me'/meta['url'].lstrip('/');im=Image.open(p);assert im.width<=2048 and im.height<=2048;assert im.mode=='RGBA'
 for name,record in streams.items():
  p=ROOT/'kaynak/login.gogames.me'/fx['atlases'][name]['url'].lstrip('/');assert hashlib.sha256(p.with_suffix('.argb').read_bytes()).hexdigest()==record['fileSha256']
 db=ROOT/'cikarim/veri-json';heroes=json.loads((db/'BaseHero.json').read_text(encoding='utf8'));hero=next(x for x in heroes if int(x['id'],16)==11120970);assert hero['quality']==7 and hero['assess']=='SSS'
 cfg=json.loads((ROOT/'sunucu/sasuke-shinden.json').read_text());effects=json.loads(hero['attackEffect'])
 for key,move in cfg.items():
  if not isinstance(move,dict) or not move.get('id'):continue
  clip=anim['clips'][key]
  if move['multiplier']>0:
   assert move['attackStat']=='atk' and move['damageType']=='physical' and move['target']=='all'
   assert len(clip['hitFrames'])==move['hitCount']
   assert len(effects[str(move['id'])]['appendEffect'])==move['hitCount']
   if not move.get('prompt'):assert move['cooldown']==0
 article=next(x for x in json.loads((db/'Article.json').read_text(encoding='utf8')) if int(x['id'],16)==14130970);assert article['quality']==7
 assoc=next(x for x in json.loads((db/'HeroChangeAttr.json').read_text(encoding='utf8')) if int(x['id'],16)==11120970);assert assoc['chipValue']==14130970
 release=json.loads((BASE/'release.json').read_text())
 for entry in release['files']:assert hashlib.sha256((PUBLIC/release['version']/entry['path']).read_bytes()).hexdigest()==entry['sha256']
 print('PASS',count,'lossless actor frames,',len(fx['atlases']),'bounded RGBA VFX pages, SSS, physical AOE multihit, Mystery-only cooldown, fragment/icon and release hashes')
if __name__=='__main__':main()
