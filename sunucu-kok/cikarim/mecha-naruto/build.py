"""Install Mecha Naruto SSS (all formation positions) in native JSON/Bin packages and both texture sets."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('packed',BASE.parent/'shared-animation/packing.py');packed=importlib.util.module_from_spec(spec);spec.loader.exec_module(packed)
native=packed.native;CFG=json.loads((ROOT/'sunucu/mecha-naruto.json').read_text());ANIM=json.loads((BASE/'animation.json').read_text());HERO=CFG['heroId'];HIT=13622101
packing_spec=importlib.util.spec_from_file_location('mecha_model_packing',BASE/'model-packing.py');packing=importlib.util.module_from_spec(packing_spec);packing_spec.loader.exec_module(packing)
native.texture_sequence=packing.packed_sequence
multi_spec=importlib.util.spec_from_file_location('mecha_multihit',BASE.parent/'ninja-multihit.py');multihit=importlib.util.module_from_spec(multi_spec);multi_spec.loader.exec_module(multihit)
multihit.configure(BASE.name,ANIM)
SOURCE=ROOT.parent/'asset/Mecha_Naruto'
MOVES=[CFG[k] for k in ['mystery','standard','beam']]+CFG['chases']+[CFG[k] for k in ['modifiedChase','extremeBeam','highHpMystery','jet','transform','beastRecovery','beastBomb','beastClaw','beastSweep']]
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
        if 'hitFrames' in clip:effect['appendEffect']=multihit.append_effect(clip,HIT)
        effects[str(move['id'])]=effect
    h.update(id=native.hexid(HERO),name=CFG['name'],assess='SSS',profession=1,quality=7,isMain=0,sex=1,level=1,needLevel=1,
        desc='SSS. Any formation position: front, middle or rear. Mechanical ninja. '+DESC['passive'],active=CFG['mystery']['id'],normalAttack=CFG['standard']['id'],talent=13220950,
        attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',power=8700,agile=7900,intelligence=8700,life=12000,speed=125,
        powerGrow=3.7,agileGrow=3.3,intelligenceGrow=3.7,lifeGrow=4.6,speedGrow=2.7)
    for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[field]=0
    h['hitRate']=1
    h['tags']=CFG['tags'][:]
    return {'BaseHero':[h],'RoleModel':[{'id':native.hexid(HERO),'model':HERO,'roleStyle':HERO,'roleHead':HERO}],
        'HeroTalent':[{'id':native.hexid(13220950),'talentName':"Orochimaru's Advance Technology / Mecha-Naruto - Jet / Tailed Beast Mode",'talentDesc':DESC['passive']}],
        'SkillConfig':[{'id':native.hexid(m['id']),'skillId':m['id'],'name':m['name'],'desc':DESC[str(m['id'])]+(' Deals physical damage, scales with Physical ATK and is mitigated by Physical DEF.' if m.get('multiplier',0)>0 else ''),'icon':m['id'],'sortId':i+1} for i,m in enumerate(MOVES)]}

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args();db=rows();changes={}
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
        for category,source,size in [('HeadIcon','assets/battle/role/head_45_45/11015001.png',(48,48)),('SmallIcon','assets/battle/role/head_45_45/11015001.png',(48,48)),('LargeIcon','assets/user/ninja/ninjaBigImg/11015001.png',(220,300)),('MiddlePicture','assets/bag/ninja/preview/11015001.png',(220,300))]:
            portrait=Image.open(BASE/'validation/showcase-11015001.png') if category=='MiddlePicture' else Image.open(SOURCE/source)
            im=ImageOps.contain(portrait.convert('RGBA'),size,Image.Resampling.LANCZOS)
            changes[dest/category/f'{HERO:08X}.TexClient']=native.texture(HERO,[im],pivot=False)
        for ident in [HIT]+[m['id'] for m in MOVES]:
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=native.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
        icons={13121101:21015007,13121102:21015003,13121103:21015008,13121104:21015004,13121105:21015004,13121106:21015008,13121107:21015016,13121108:21015006,13121109:21015005,13121110:21015017,13121111:21015016,13121112:21015024,13121113:21015025}
        for m in MOVES:
            path=SOURCE/'icons'/(str(icons[m['id']])+'.png')
            im=Image.open(path).convert('RGBA')
            changes[dest/'SkillIcon'/f'{m["id"]:08X}.TexClient']=native.texture(m['id'],[ImageOps.contain(im,(64,64),Image.Resampling.LANCZOS)],pivot=False)
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
