"""Install Obito SSS Vanguard in native JSON/Bin packages and both texture sets."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('packed',BASE.parent/'kabuto-gnw/build.py');packed=importlib.util.module_from_spec(spec);spec.loader.exec_module(packed)
native=packed.native;CFG=json.loads((ROOT/'sunucu/obito-rage.json').read_text());ANIM=json.loads((BASE/'animation.json').read_text());HERO=CFG['heroId'];HIT=13621951
SOURCE=ROOT.parent/'asset/Extracted_Obito_Rage'
MOVES=[CFG[k] for k in ['mystery','rageMystery','standard','rageStandard']]+CFG['chases']+CFG['rageChases']+[CFG['transformation']]
DESC={
13120951:'Prompt. Consume 10% max HP; high chance to evade the next attack this round. The first 5 Chase or Standard attacks cannot defeat Obito this round. Cooldown 2 rounds, battlefield cooldown 0, chakra 0. Does not consume a Standard. Rage: enhanced Kamui activates free at the beginning of every round (no cooldown), guarantees next evasion; Mystery becomes Underground Roots.',
13120952:'Rage Mystery. Damage all enemies, Low Float to selected target; +40% Chase damage until round end (does not stack). Chakra 40, reduced by 20 after each use to minimum 0. Cooldown 3 rounds, battlefield cooldown 0. Prompt; does not consume a Standard. Local automatic combat casts at most once per round.',
13120953:'Consume 5% max HP; attack lowest HP enemy. High chance of Knockdown and Level 2 Kamui Tag. Never misses; bypasses defensive skills. Kamui Tag: evasion capped at 35%, Defense and Resistance -15% until end of next round.',
13120954:'Rage Standard: attack lowest HP enemy without HP cost. High chance of Knockdown and Level 2 Kamui Tag. Never misses; bypasses defensive skills.',
13120955:'Triggered at 20 Combo: damage up to 7 enemies and absorb 20 shared chakra per hit enemy. Once per round.',
13120956:'Chase Low Float: consumes 5% max HP, damages all enemies in the same line, causes Knockdown, Immobile for 1 round and Level 2 Kamui Tag. Ignores a portion of Defense and Resistance. Once per round.',
13120957:'Rage 20 Combo Chase: damage up to 7 enemies; Suppress Immunity for 1 round; absorb 20 chakra per hit enemy. Once per round.',
13120958:'Rage Chase Low Float: no HP cost; damage all enemies in the same line, Knockdown, Immobile for 1 round and Level 2 Kamui Tag. Ignores a portion of Defense and Resistance. Twice per round.',
13120959:'Two Standards every round. Once per battle below 50% HP: enter Rage and recover 50% max HP. Rage grants enhanced Mystery, Standards and Chases, 12% Life Steal, enhanced Kamui at the beginning of every round (no cooldown) and one additional Standard after defeating an enemy with a Standard.'}
for sid in [13120955,13120956,13120957,13120958]:DESC[sid]+=' No cooldown. Per-round Chase limits still apply.'
for move in MOVES:
    if move.get('attackStat')=='atk':DESC[move['id']]+=' Damage scales with Physical ATK.'

def rows():
    old=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
    h=copy.deepcopy(next(h for h in old if h['assess']=='SSS' and h['profession']==2))
    effects={}
    for move in MOVES:
        name=ANIM['moves'][str(move['id'])];clip=ANIM['clips'][name]
        effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
        if 'hitFrames' in clip:effect['appendEffect']={str(clip['hitFrames'][0]):{'target':2,'effectId':HIT,'anmyhp':{'0':100,'checkDie':1}}}
        # The original standard includes spatial Kamui choreography; caster stays anchored.
        effects[str(move['id'])]=effect
    h.update(id=native.hexid(HERO),name=CFG['name'],assess='SSS',profession=2,quality=7,isMain=0,sex=1,level=1,needLevel=1,
             desc='SSS Vanguard / Front Row. Wood Style and Kamui. '+DESC[13120959],active=CFG['mystery']['id'],normalAttack=CFG['standard']['id'],talent=13220920,
             attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',power=8000,agile=6500,intelligence=7500,life=11000,speed=110,
             powerGrow=3.4,agileGrow=2.8,intelligenceGrow=3.2,lifeGrow=4.4,speedGrow=2.5)
    for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[field]=0
    h['hitRate']=1
    return {'BaseHero':[h],'RoleModel':[{'id':native.hexid(HERO),'model':HERO,'roleStyle':HERO,'roleHead':HERO}],
            'HeroTalent':[{'id':native.hexid(13220920),'talentName':'Outrage - Darkness Commitment / Rage Mode','talentDesc':' '.join(DESC[sid] for sid in [13120959,13120955,13120956,13120957,13120958,13120952])}],
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
        for category,source,size in [('HeadIcon','battle/role/head_45_45/11006051.png',(48,48)),('SmallIcon','battle/role/head_45_45/11006051.png',(48,48)),('LargeIcon','user/ninja/ninjaBigImg/11006051.png',(220,300)),('MiddlePicture','bag/ninja/preview/11006051.png',(220,300))]:
            portrait=Image.open(BASE/'validation/extracted/showcase.png') if category=='MiddlePicture' else Image.open(SOURCE/source)
            im=ImageOps.contain(portrait.convert('RGBA'),size,Image.Resampling.LANCZOS)
            changes[dest/category/f'{HERO:08X}.TexClient']=native.texture(HERO,[im],pivot=False)
        for ident in [HIT]+[m['id'] for m in MOVES]:
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=native.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
        for m in MOVES:
            name=ANIM['moves'][str(m['id'])];clip=ANIM['clips'][name];im=Image.open(BASE/'frames'/f'{clip["assets"][len(clip["assets"])//3]:03}.png').convert('RGBA')
            if im.getbbox():im=im.crop(im.getbbox())
            if name=='kamui':im=Image.open(SOURCE/'battle/role/head_176_68/11006051.png').convert('RGBA').crop((0,0,68,68))
            if name=='rage':im=Image.open(SOURCE/'bag/ninja/preview/11006051.png').convert('RGBA')
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
    print('PASS SSS Vanguard,',len(MOVES),'skills, native databases and textures;',len(changes),'files; applied',args.apply)
if __name__=='__main__':main()
