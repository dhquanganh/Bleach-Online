"""Verify installed Naruto Sage TexClient pixels, pivots, timelines and isolation."""
from pathlib import Path
from PIL import Image
import hashlib,io,json,struct,zlib

BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public';ANIM=json.loads((BASE/'animation.json').read_text())

def verify_model(path,actor):
 b=path.read_bytes();assert struct.unpack_from('<I',b)[0]==int(path.stem,16)
 seq_size=struct.unpack_from('<I',b,4)[0];seqpos=8;pakpos=8+seq_size
 names=ANIM['models'][str(actor)][path.stem[-2:].lower() if path.stem[-2:].lower() in ANIM['models'][str(actor)] else '']
 names=[names] if isinstance(names,str) else names
 pak_count=struct.unpack_from('<H',b,pakpos)[0];pakpos+=2;assert pak_count==len(names)
 checked=0
 for seq_index,name in enumerate(names):
  sid,timing,n=struct.unpack_from('<IBH',b,seqpos);seqpos+=7
  clip=ANIM['clips'][name];assert sid==seq_index and timing==(2 if clip['loop'] else 1) and n==len(clip['assets'])
  metadata=[struct.unpack_from('<hhhhhhH',b,seqpos+i*14) for i in range(n)];seqpos+=14*n
  length=struct.unpack_from('<I',b,pakpos)[0];pakpos+=4;pak=zlib.decompress(b[pakpos:pakpos+length]);pakpos+=length
  _,width,height,_,_,_,pn=struct.unpack_from('>BHHBBBH',pak);assert pn==n and width<=4096 and height*2<=4096
  pngpos=10+n*8;pnglen=struct.unpack_from('>I',pak,pngpos)[0];sheet=Image.open(io.BytesIO(pak[pngpos+4:pngpos+4+pnglen])).convert('RGB')
  for i,asset in enumerate(clip['assets']):
   x,y,w,h=struct.unpack_from('>hhhh',pak,10+i*8);actual=sheet.crop((x,y,x+w,y+h)).convert('RGBA');actual.putalpha(sheet.crop((x,y+height,x+w,y+height+h)).getchannel('R'))
   expected=Image.open(BASE/'frames'/f'{asset:04}.png').convert('RGBA')
   assert actual.tobytes()==expected.tobytes(),(name,i)
   assert list(metadata[i][4:6])==ANIM['framePivots'][str(asset)] and metadata[i][6]==40
   checked+=1
 assert seqpos==8+seq_size and struct.unpack_from('<H',b,pakpos)[0]==len(names) and pakpos+2==len(b)
 return checked

def main():
 assert ANIM['clips']['barrage']['sourceAction']=='A_1hit'
 assert ANIM['clips']['mystery']['sourceAction']=='SP_skill2'
 assert ANIM['clips']['chase']['sourceAction']=='SP_skill3'
 source=ROOT.parent/'asset/Naruto_Sage_Mode_Skill_Effects';audit=json.loads((BASE/'skill-effects.json').read_text())
 assert audit['source']=='asset/Naruto_Sage_Mode_Skill_Effects' and set(map(int,audit['ids']))==set(range(13621901,13621908))
 for item in audit['files']:assert hashlib.sha256((source/item['file']).read_bytes()).hexdigest()==item['sha256']
 checked=0
 for version in ['2017112917','2026090619']:
  for actor in [11120901]:
   for suffix in ['', '0A','0B','0C','0D','0E','0F']:
    ident=int(f'{actor:X}'+suffix,16);checked+=verify_model(PUBLIC/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient',actor)
  for category,src in [('HeadIcon','assets/battle/role/head_45_45/11000171.png'),('LargeIcon','assets/user/ninja/ninjaBigImg/11000171.png')]:
   assert (PUBLIC/version/'Resources/Textures'/category/f'{11120901:08X}.TexClient').stat().st_size>100
 cfg=json.loads((ROOT/'sunucu/naruto-sage.json').read_text());assert cfg['quality']==7 and cfg['formation']=='middle'
 for move in [cfg['mystery'],cfg['barrage'],*cfg['chases']]:assert move['attackStat']=='atk' and move['damageType']=='physical'
 assert cfg['mystery']['cooldown']==2 and all(m.get('cooldown',0)==0 for m in [cfg['standard'],cfg['barrage'],*cfg['chases']])
 heroes=json.loads((ROOT/'cikarim/veri-json/BaseHero.json').read_text());sage=next(r for r in heroes if int(r['id'],16)==11120901);effects=json.loads(sage['attackEffect'])
 expected={13120901:(13621904,13621902),13120903:(13621903,13621901),13120904:(13621905,13621906)}
 for sid,(charge,impact) in expected.items():
  entries=effects[str(sid)]['appendEffect'].values();assert any(e['effectId']==charge and 'anmyhp' not in e for e in entries);assert any(e['effectId']==impact and 'anmyhp' in e for e in entries)
  start=next(e for e in entries if e['effectId']==charge);assert start['target']==1
  assert all(e.get('target')==2 for e in entries if 'anmyhp' in e)
  for version in ['2017112917','2026090619']:
   for ident in [charge,impact]:assert (PUBLIC/version/'Resources/Textures/Skill'/f'{ident:08X}.TexClient').stat().st_size>1000
 clone=next(r for r in json.loads((ROOT/'cikarim/veri-json/RoleModel.json').read_text()) if int(r['id'],16)==11120902)
 assert clone['model']==11120901 and clone['roleStyle']==11120901
 print('PASS',checked,'installed native frames plus all six supplied Naruto Sage effect sources: bounded lossless atlases, shared clone cache; physical-only logic and Mystery-only cooldown')

if __name__=='__main__':main()
