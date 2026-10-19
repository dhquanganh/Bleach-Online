"""Install Pain SSS Assaulter in native JSON/Bin packages and both texture sets."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('packed',BASE.parent/'kabuto-gnw/build.py');packed=importlib.util.module_from_spec(spec);spec.loader.exec_module(packed)
native=packed.native;CFG=json.loads((ROOT/'sunucu/pain-tendo.json').read_text());ANIM=json.loads((BASE/'animation.json').read_text());HERO=CFG['heroId'];HIT=13621971
_multi_spec=importlib.util.spec_from_file_location('multihit',BASE.parent/'ninja-multihit.py');multihit=importlib.util.module_from_spec(_multi_spec);_multi_spec.loader.exec_module(multihit)
multihit.configure(BASE.name,ANIM)
SOURCE=ROOT.parent/'asset/Pain_Tendo_Six_Paths_Rinnegan'
MOVES=[CFG[k] for k in ['mystery','extremeMystery','finalMystery','standard']]+CFG['chases']+[CFG[k] for k in ['laser','transformation','finalRevival','superPush']]
DESC={
13120971:'Prompt. Consume 1 Technique Point and 20 Chakra. Damage and Interruption to up to 7 enemies. Selected target: Horror II and Mystery Chakra Cost +20 (stackable) through round end. Cooldown 2 rounds; battlefield cooldown 0. Below 60% HP becomes Extreme - Almighty Push.',
13120972:'Consume all Technique Points and 20 Chakra. Damage, 5 Combo and Interruption to all enemies; selected target: Repulse, Horror II, Mystery Chakra Cost +20 (stackable) through round end. Cooldown 3 rounds; battlefield cooldown 0. 7% Life Steal.',
13120973:'Final Mystery. Consume 2 Technique Points, Chakra 0, cooldown 2 rounds (up to two casts in an eligible round), battlefield cooldown 0. Unavoidable damage, 5 Combo and Interruption to all enemies; selected target: Repulse, Horror II and Mystery Chakra Cost +20 (stackable) through round end.',
13120974:'Attack up to 6 enemies, causes 4 Combo, reduces own Mystery cooldown by 1 and gains 1 Technique Point.',
13120975:'No cooldown. Chase Repulse or Knockdown. Causes Knockdown, Chakra Disruption II and Pain II; target Chakra Limit becomes 20 through round end. Causes 30% splash damage to units 1 grid away. Never misses; ignores part of Defense/Resistance. Chakra Disruption II: Attack/Ninjutsu -10% per opposing Rinnegan ninja through next round end. Pain II: Defense/Resistance suppressed to 75% of base stats; lose 10% current HP on every Standard through next round end.',
13120976:'No cooldown. At the beginning of every round, unleash a massive laser across ALL enemies in every row and remove 10 Chakra per hit unit. Gain 1 Technique Point; immune to Interruption for the round. Allied Rinnegan ninjas have unavoidable Mysteries through round end.',
13120977:'Outer Path - Six Paths of Pain: up to 5 Technique Points, each increases Attack and Ninjutsu by 12%. Gain 0.5 point whenever attacked. First defeat per battle: revive with 100% HP, lose ALL current skills, gain ONLY Final - Almighty Push and Final - The One called God.',
13120978:'Final - The One called God: Super Armor and immune to Debuffs; up to 2 Mysteries per round. Up to 5 Technique Points; Attack and Ninjutsu +20% per point. Gain 1 point whenever attacked. Critical Hits increase hit target Mystery Chakra Cost by 20. Once per battle, if another allied ninja is defeated, revive at 40% HP and trigger Super - Almighty Push.',
13120979:'Triggered after Final revival. Unavoidable damage, 5 Combo and Interruption to all enemies. All enemies Mystery Chakra Cost +20 (stackable) through round end. Does not consume Technique Points or Chakra.'}
BASE_PASSIVE='The One called God: every damage event scales Attack by 12%; Critical Hits inflict Chakra Disruption II. Cancel incoming Debuffs except Level 2; each cancellation increases Initiative by 2%, stacking up to 5. Horror II (Fear): cannot Standard Attack or receive external Buffs, stat increases or Shields until next round end or the affected unit executes a Mystery.'
for move in MOVES:
    if move.get('attackStat')=='atk':DESC[move['id']]+=' Deals physical damage, scales with Physical ATK and is mitigated by Physical DEF.'
    if move.get('hitCount'):DESC[move['id']]+=f" Deals {move['hitCount']} consecutive damage hits; the listed damage coefficient is the total per cast."
def rows():
    old=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
    h=copy.deepcopy(next(h for h in old if h['assess']=='SSS'))
    effects={}
    for move in MOVES:
        clip=ANIM['clips'][ANIM['moves'][str(move['id'])]]
        effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
        if 'hitFrames' in clip:effect['appendEffect']=multihit.append_effect(clip,HIT)
        effects[str(move['id'])]=effect
    h.update(id=native.hexid(HERO),name=CFG['name'],assess='SSS',profession=1,quality=7,isMain=0,sex=1,level=1,needLevel=1,
        desc='SSS Assaulter / Middle Row. Akatsuki, Rinnegan. '+DESC[13120977]+' '+BASE_PASSIVE,
        active=CFG['mystery']['id'],normalAttack=CFG['standard']['id'],talent=13220930,
        attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',power=8200,agile=7400,intelligence=8200,life=10500,speed=120,
        powerGrow=3.5,agileGrow=3.1,intelligenceGrow=3.5,lifeGrow=4.2,speedGrow=2.6)
    for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[field]=0
    h['hitRate']=1
    return {'BaseHero':[h],'RoleModel':[{'id':native.hexid(HERO),'model':HERO,'roleStyle':HERO,'roleHead':HERO}],
        'HeroTalent':[{'id':native.hexid(13220930),'talentName':'Outer Path / The One called God / Shurado - Laser Canon','talentDesc':' '.join(DESC[m['id']] for m in MOVES)+' '+BASE_PASSIVE}],
        'SkillConfig':[{'id':native.hexid(m['id']),'skillId':m['id'],'name':m['name'],'desc':DESC[m['id']],'icon':m['id'],'sortId':i+1} for i,m in enumerate(MOVES)]}

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
        for category,source,size in [('HeadIcon','assets/battle/role/head_45_45/11006531.png',(48,48)),('SmallIcon','assets/battle/role/head_45_45/11006531.png',(48,48)),('LargeIcon','assets/user/ninja/ninjaBigImg/11006531.png',(220,300)),('MiddlePicture','assets/bag/ninja/preview/11006531.png',(220,300))]:
            portrait=Image.open(BASE/'validation/showcase.png') if category=='MiddlePicture' else Image.open(SOURCE/source)
            im=ImageOps.contain(portrait.convert('RGBA'),size,Image.Resampling.LANCZOS)
            changes[dest/category/f'{HERO:08X}.TexClient']=native.texture(HERO,[im],pivot=False)
        for ident in [HIT]+[m['id'] for m in MOVES]:
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=native.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
        icons={13120971:21006527,13120972:21006527,13120973:21006527,13120974:21006523,13120975:21006524,13120976:21006528,13120977:21006525,13120978:21006526,13120979:21006527}
        for m in MOVES:
            path=SOURCE/'assets/skill/40'/(str(icons[m['id']])+'.png')
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
    print('PASS SSS Middle Row,',len(MOVES),'skills, native databases and textures;',len(changes),'files; applied',args.apply)
if __name__=='__main__':main()
