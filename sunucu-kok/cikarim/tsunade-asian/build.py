"""Install Nagato Gaara Swimsuit SSSS in native tables and both texture sets."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('packed',BASE.parent/'shared-animation/packing.py');packed=importlib.util.module_from_spec(spec);spec.loader.exec_module(packed)
native=packed.native;CFG=json.loads((ROOT/'sunucu/tsunade-asian.json').read_text());ANIM=json.loads((BASE/'animation.json').read_text());HERO=CFG['heroId'];HIT=13622601
SOURCE=ROOT.parent/'asset/Tsunade_Asian_Style_Full'
MOVES=[CFG[k] for k in ['mystery','standard','healing','revival','summoning','healingMystery']]
multi_spec=importlib.util.spec_from_file_location('itachi_multihit',BASE.parent/'ninja-multihit.py');multihit=importlib.util.module_from_spec(multi_spec);multi_spec.loader.exec_module(multihit)
None
DESC=json.loads((BASE/'descriptions.json').read_text())
DESC['passive']+=' All attack damage is physical, scales with Physical ATK and is mitigated by Physical DEF.'
for move in MOVES:
    if move.get('hitCount'):DESC[str(move['id'])]+=f" Deals {move['hitCount']} consecutive damage hits; the listed damage coefficient is the total per cast."
def rows():
    old=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
    h=copy.deepcopy(next(h for h in old if h['assess']=='SSS'));effects={}
    for move in MOVES:
        clip=ANIM['clips'][ANIM['moves'][str(move['id'])]]
        effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
        if move.get('support'):
            heal_frame=16 if move['id']==13121602 else clip.get('hitFrames',[0])[0]
            effect['friendhp']={str(heal_frame):100}
        elif 'hitFrames' in clip:effect['appendEffect']=multihit.append_effect(clip,HIT)
        effects[str(move['id'])]=effect
    h.update(id=native.hexid(HERO),name=CFG['name'],assess=CFG['assess'],profession=1,quality=CFG['quality'],isMain=0,sex=2,level=1,needLevel=1,
        desc=CFG['assess']+'. Any formation position: front, middle or rear. Water / Asian Style. '+DESC['passive'],active=CFG['mystery']['id'],normalAttack=CFG['standard']['id'],talent=13220992,
        attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',power=8700,agile=7900,intelligence=8700,life=12000,speed=125,
        powerGrow=3.7,agileGrow=3.3,intelligenceGrow=3.7,lifeGrow=4.6,speedGrow=2.7)
    for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[field]=0
    h['hitRate']=1
    h['tags']=CFG['tags'][:]
    slug=copy.deepcopy(h);slug.update(id=native.hexid(11120993),name='Small Katsuyu',isSummon=True,tags=[],active=0,normalAttack=13121609,talent=0,attackEffect=json.dumps({'13121609':{'target':1,'friendhp':{'10':100},'backPoint':{str(len(json.loads((BASE/'katsuyu/animation.json').read_text())['clips']['standard']['frames'])-1):1}}}))
    return {'BaseHero':[h,slug],'RoleModel':[{'id':native.hexid(i),'model':i,'roleStyle':i,'roleHead':i} for i in [HERO,11120993]],
        'HeroTalent':[{'id':native.hexid(13220992),'talentName':'Reserve Seal / The Legendary Sannin / Giant Katsuyu','talentDesc':DESC['passive']}],
        'SkillConfig':[{'id':native.hexid(m['id']),'skillId':m['id'],'name':m['name'],'desc':DESC[str(m['id'])]+(' Deals physical damage, scales with Physical ATK and is mitigated by Physical DEF.' if m.get('multiplier',0)>0 else ''),'icon':m['id'],'sortId':i+1} for i,m in enumerate(MOVES)]+[{'id':native.hexid(13121609),'skillId':13121609,'name':'Small Katsuyu - Healing','desc':DESC['13121609'],'icon':13121609,'sortId':9}]}

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args();db=rows();changes={}
    for ident,name,desc in [(13121607,'Reserve Seal',DESC['13121604']),(13121608,'The Legendary Sannin',DESC['passive'])]:db['SkillConfig'].append({'id':native.hexid(ident),'skillId':ident,'name':name,'desc':desc,'icon':ident,'sortId':ident-13121600})
    for f in native.PUBLIC.glob('*/Resources/Bin/**/*'):
        if not f.is_file():continue
        b=f.read_bytes()
        if f.suffix=='.bin' and f.stem.upper() in ['01000005','0100001F','01000038','0100003F']:
            raw=zlib.decompress(b);new=native.patch(raw,db)
            if new!=raw:changes[f]=zlib.compress(new)
        elif f.suffix=='.binPackage':
            p=6;parts=[b[:6]];changed=False
            for _ in range(struct.unpack_from('<H',b,4)[0]):
                n=struct.unpack_from('<I',b,p)[0];p+=4;c=b[p:p+n];p+=n;raw=zlib.decompress(c);new=native.patch(raw,db)
                if new!=raw:c=zlib.compress(new);changed=True
                parts.extend([native.u32(len(c)),c])
            if changed:changes[f]=b''.join(parts)+b[p:]
    for version in ['2017112917','2026090619']:
        dest=native.PUBLIC/version/'Resources/Textures'
        for suffix,names in ANIM['models'][str(HERO)].items():
            ident=int(f'{HERO:X}'+suffix,16);sequences=[]
            for name in ([names] if isinstance(names,str) else names):
                clip=ANIM['clips'][name];ims=[Image.open(BASE/'frames'/f'{i:03}.png').convert('RGBA') for i in clip['assets']]
                sequences.append(dict(frames=ims,loop=clip['loop'],duration=40,pivots=[tuple(ANIM['framePivots'][str(i)]) for i in clip['assets']]))
            changes[dest/'Model'/f'{ident:08X}.TexClient']=native.texture_sequences(ident,sequences)
        for category,source,size in [('HeadIcon','assets/battle/role/head_45_45/11002371.png',(48,48)),('SmallIcon','assets/battle/role/head_45_45/11002371.png',(48,48)),('LargeIcon','assets/user/ninja/ninjaBigImg/11002371.png',(220,300)),('MiddlePicture','assets/bag/ninja/preview/11002371.png',(220,300))]:
            portrait=Image.open(SOURCE/source)
            im=ImageOps.contain(portrait.convert('RGBA'),size,Image.Resampling.LANCZOS)
            changes[dest/category/f'{HERO:08X}.TexClient']=native.texture(HERO,[im],pivot=False)
        for ident in [HIT,13121609]+[m['id'] for m in MOVES]:
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=native.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
        icons={13121601:21002378,13121602:21002373,13121603:21002377,13121604:21002374,13121605:21002376,13121606:21002377}
        for m in MOVES:
            path=SOURCE/'assets/skill/40'/(str(icons[m['id']])+'.png')
            im=Image.open(path).convert('RGBA')
            changes[dest/'SkillIcon'/f'{m["id"]:08X}.TexClient']=native.texture(m['id'],[ImageOps.contain(im,(64,64),Image.Resampling.LANCZOS)],pivot=False)
        for ident,icon in [(13121607,21002374),(13121608,21002376),(13121609,21002373)]:
            im=Image.open(SOURCE/'assets/skill/40'/f'{icon}.png').convert('RGBA');changes[dest/'SkillIcon'/f'{ident:08X}.TexClient']=native.texture(ident,[ImageOps.contain(im,(64,64),Image.Resampling.LANCZOS)],pivot=False)
    kat_spec=importlib.util.spec_from_file_location('katsuyu',BASE/'katsuyu.py');kat=importlib.util.module_from_spec(kat_spec);kat_spec.loader.exec_module(kat)
    changes.update(kat.textures())
    for kind,extra in db.items():
        f=native.DATA/(kind+'.json');old=json.loads(f.read_text(encoding='utf-8'));byid={r['id']:r for r in extra}
        new=[byid.get(r['id'],r) for r in old]+[r for r in extra if r['id'] not in {o['id'] for o in old}]
        if old!=new:changes[f]=(json.dumps(new,ensure_ascii=False,indent=2)+'\n').encode()
    if args.apply:
        for f,b in changes.items():
            if f.exists() and f.read_bytes()==b:continue
            backup=BASE/'backups'/f.relative_to(ROOT)
            if f.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,backup)
            f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(b)
    (BASE/'manifest.json').write_text(json.dumps({'applied':args.apply,'heroId':HERO,'files':[{'path':str(f.relative_to(ROOT)),'sha256':hashlib.sha256(b).hexdigest()} for f,b in changes.items()]},indent=2))
    print('PASS SSS all formation positions,',len(MOVES),'skills, native databases and textures;',len(changes),'files; applied',args.apply)
if __name__=='__main__':main()
