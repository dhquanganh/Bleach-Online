"""Install Naruto Sage SSS data and native actor/portrait assets incrementally."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib

BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];SOURCE=ROOT.parent/'asset/Naruto_Sage_Mode'
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('legacy',BASE.parent/'naruto-sage/build.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
packing_spec=importlib.util.spec_from_file_location('model_packing',BASE.parent/'mecha-naruto/model-packing.py')
packing=importlib.util.module_from_spec(packing_spec);packing_spec.loader.exec_module(packing)
native.texture_sequence=packing.packed_sequence
CFG=json.loads((ROOT/'sunucu/naruto-sage.json').read_text(encoding='utf-8'))
ANIM=json.loads((BASE/'animation.json').read_text(encoding='utf-8'))
HERO=CFG['heroId'];CLONE=CFG['cloneId'];TALENT=13220901
MOVES=[CFG['mystery'],CFG['standard'],CFG['barrage'],*CFG['chases']]
VFX={
 13120901:{'charge':13621904,'chargeFrame':12,'impact':13621902},
 13120903:{'charge':13621903,'chargeFrame':1,'impact':13621901},
 13120904:{'charge':13621905,'chargeFrame':8,'impact':13621906},
}

def descriptions():
 return {
  13120901:'Prompt. Deals physical damage to all enemies, adds 10 COMBO and causes Repulse to the selected target. Chakra Cost: 40. Cooldown: 2. Battlefield Cooldown: 1.',
  13120902:'At battle start, summons a Lightning-resistant Sage Jutsu Shadow Clone. If the clone is absent, the Standard Attack summons it again. No cooldown.',
  13120903:'When a Sage Shadow Clone is active, replaces the Standard Attack with a combined Rasengan Barrage that deals physical damage and causes Low Float. No cooldown.',
  13120904:'Chases a Repulsed enemy, deals physical damage and causes Knockdown. Triggered once per round and has no cooldown.'}

def rows():
 base=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
 template=copy.deepcopy(next(h for h in base if h['assess']=='SSS'))
 desc=descriptions();effects={}
 for move in MOVES:
  clip=ANIM['clips'][ANIM['moves'][str(move['id'])]]
  effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
  if clip.get('hitFrames'):
   count=len(clip['hitFrames']);visual=VFX[move['id']]
   effect['appendEffect']={str(frame):{'target':2,'effectId':visual['impact'],'hitIndex':i,'hitCount':count,'anmyhp':{'0':100//count,'checkDie':int(i==count-1)}} for i,frame in enumerate(clip['hitFrames'])}
   assert visual['chargeFrame'] not in effect['appendEffect']
   effect['appendEffect'][str(visual['chargeFrame'])]={'target':1,'effectId':visual['charge']}
   move['hitCount']=count
  effects[str(move['id'])]=effect
 template.update(id=native.hexid(HERO),name=CFG['name'],assess='SSS',profession=2,quality=7,isMain=0,sex=1,level=1,needLevel=1,
   desc='SSS middle-row ninja. All damaging skills scale with Physical ATK and are mitigated by Physical DEF.',
   active=CFG['mystery']['id'],normalAttack=CFG['standard']['id'],talent=TALENT,
   attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',power=8500,agile=9000,intelligence=7200,life=9800,speed=135,
   powerGrow=3.6,agileGrow=4.0,intelligenceGrow=3.0,lifeGrow=4.1,speedGrow=2.9)
 for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:template[field]=0
 template['hitRate']=1
 clone=copy.deepcopy(template);clone.update(id=native.hexid(CLONE),name='Sage Jutsu Shadow Clone',assess='SSS',isSummon=True,desc='Inherits every Naruto [Sage Mode] skill except Sage Jutsu Shadow Clone. Its Standard Attack is always Sage Art - Rasengan Barrage. Lightning-resistant.',active=CFG['mystery']['id'],normalAttack=CFG['barrage']['id'])
 suffix=' All attack damage is physical, scales with Physical ATK and is mitigated by Physical DEF.'
 return {'BaseHero':[template,clone],
  'RoleModel':[{'id':native.hexid(HERO),'model':HERO,'roleStyle':HERO,'roleHead':HERO},
               {'id':native.hexid(CLONE),'model':HERO,'roleStyle':HERO,'roleHead':HERO}],
  'HeroTalent':[{'id':native.hexid(TALENT),'talentName':'Sage Jutsu Shadow Clone / Sage Jutsu Chakra','talentDesc':'Summons the clone at battle start and grants 20 Chakra before the first action of each round. Talents have no cooldown.'}],
  'SkillConfig':[{'id':native.hexid(m['id']),'skillId':m['id'],'name':m['name'],'desc':desc[m['id']]+(suffix if m.get('multiplier',0)>0 else ''),'icon':m['id'],'sortId':i+1} for i,m in enumerate(MOVES)]}

def main():
 parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args();db=rows();changes={}
 for f in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not f.is_file():continue
  b=f.read_bytes()
  if f.suffix=='.bin' and f.stem.upper() in ['01000005','0100001F','01000038','0100003F']:
   raw=zlib.decompress(b);new=native.patch(raw,db)
   if new!=raw:changes[f]=zlib.compress(new)
  elif f.suffix=='.binPackage':
   pos=6;parts=[b[:6]];changed=False
   for _ in range(struct.unpack_from('<H',b,4)[0]):
    n=struct.unpack_from('<I',b,pos)[0];pos+=4;c=b[pos:pos+n];pos+=n;raw=zlib.decompress(c);new=native.patch(raw,db)
    if new!=raw:c=zlib.compress(new);changed=True
    parts.extend([native.u32(len(c)),c])
   if changed:changes[f]=b''.join(parts)+b[pos:]
 for version in ['2017112917','2026090619']:
  dest=native.PUBLIC/version/'Resources/Textures'
  for actor in (HERO,):
   for suffix,names in ANIM['models'][str(actor)].items():
    ident=int(f'{actor:X}'+suffix,16);sequences=[]
    for name in ([names] if isinstance(names,str) else names):
     clip=ANIM['clips'][name];ims=[Image.open(BASE/'frames'/f'{i:04}.png').convert('RGBA') for i in clip['assets']]
     sequences.append(dict(frames=ims,loop=clip['loop'],duration=clip['duration'],pivots=[tuple(ANIM['framePivots'][str(i)]) for i in clip['assets']]))
    changes[dest/'Model'/f'{ident:08X}.TexClient']=native.texture_sequences(ident,sequences)
  portraits=[('HeadIcon','assets/battle/role/head_45_45/11000171.png',(48,48)),('SmallIcon','assets/battle/role/head_45_45/11000171.png',(48,48)),('LargeIcon','assets/user/ninja/ninjaBigImg/11000171.png',(220,300)),('MiddlePicture','assets/bag/ninja/preview/11000171.png',(220,300))]
  for category,src,size in portraits:
   im=ImageOps.contain(Image.open(SOURCE/src).convert('RGBA'),size,Image.Resampling.LANCZOS)
   changes[dest/category/f'{HERO:08X}.TexClient']=native.texture(HERO,[im],pivot=False)
 for kind,extra in db.items():
  f=native.DATA/(kind+'.json');old=json.loads(f.read_text(encoding='utf-8'));own={r['id']:r for r in extra}
  new=[own.get(r['id'],r) for r in old]+[r for r in extra if r['id'] not in {o['id'] for o in old}]
  if old!=new:changes[f]=(json.dumps(new,ensure_ascii=False,indent=2)+'\n').encode()
 changes[ROOT/'sunucu/naruto-sage.json']=(json.dumps(CFG,ensure_ascii=False,indent=2)+'\n').encode()
 if args.apply:
  for f,b in changes.items():
   if f.exists() and f.read_bytes()==b:continue
   backup=BASE/'backups'/f.relative_to(ROOT)
   if f.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,backup)
   f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(b)
 (BASE/'manifest.json').write_text(json.dumps({'applied':args.apply,'heroId':HERO,'cloneId':CLONE,'files':[{'path':str(f.relative_to(ROOT)),'sha256':hashlib.sha256(b).hexdigest()} for f,b in changes.items()]},indent=2)+'\n')
 print('PASS Naruto Sage SSS middle row, physical-only combat, native animation and portraits;',len(changes),'files; applied',args.apply)

if __name__=='__main__':main()
