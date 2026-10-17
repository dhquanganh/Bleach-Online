"""Install Jiraiya without changing unrelated DB records or Naruto textures."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('naruto_native',BASE.parent/'naruto-sage/build.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
CFG=json.loads((ROOT/'sunucu/jiraiya-toads.json').read_text())
ANIM=json.loads((BASE/'animation.json').read_text())
HERO=CFG['heroId'];TALENT=13220903;HIT=13621921
SKILLS=[CFG[k] for k in ['mystery','additional','standard']]+CFG['chases']+[CFG[k] for k in ['power','revival']]
NAMES=['toad-mouth-barrier','toad-confrontation-chant','giant-gallant-rasengan','raging-lions-mane','senjutsu-power','tale-of-jiraiya-revival']
def frames(ids):return [Image.open(BASE/'frames'/f'{i:03}.png').convert('RGBA') for i in ids]
def rows():
    heroes=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
    template=next(h for h in heroes if h['assess']=='SSS' and h['profession']==4 and h['quality']==7)
    h=copy.deepcopy(template);effects={}
    for move,name in zip(SKILLS,NAMES):
        clip=ANIM['clips'][name]
        effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
        if 'hitFrames' in clip:
            effect['appendEffect']={str(clip['hitFrames'][0]):{'target':2,'effectId':HIT,'anmyhp':{'0':100,'checkDie':1}}}
            if name in ['giant-gallant-rasengan','raging-lions-mane']:effect['runPoint']={'0':{'target':2}}
        effects[str(move['id'])]=effect
    h.update(id=native.hexid(HERO),name=CFG['name'],assess='SSS',profession=4,quality=7,isMain=0,
        desc='Fire / Senjutsu. SSS Assaulter. Toad Esophagus, Extreme Chaos and 15-hit Chase.',
        active=CFG['mystery']['id'],normalAttack=CFG['standard']['id'],talent=TALENT,
        attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',sex=1,
        level=1,needLevel=1,power=8500,agile=7000,intelligence=6500,life=8000,speed=110,
        powerGrow=3.5,agileGrow=3.0,intelligenceGrow=3.0,lifeGrow=3.5,speedGrow=2.5)
    for key in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[key]=0
    h['hitRate']=1
    descriptions=[
      'Prompt. Chakra 20; cooldown 2; battlefield cooldown 0. Toad Esophagus for 2 rounds: barrier creators/destroyers on both sides cannot cast Mystery. Immediately casts Toad Confrontation Chant.',
      'Damage up to 2 enemies. Suppress Immunity until end of next round; Extreme Chaos on hit.',
      'Unavoidable lineup damage, 5 COMBO. Stackable -10% Resistance. High chance (local: 70%) of Knockdown to selected target.',
      'At least 15 COMBO. Damage up to 4 enemies, Repulse to selected target. +1 Chase limit for allies this round, non-stacking.',
      'Round start: restore chakra limit to 100; +2% team Initiative each round, up to 10%. Cleanse Jiraiya and up to 2 other Senjutsu allies; +20 shared chakra for each.',
      'After defeat, revive at 30% HP after allies cast 3 Mysteries. On revival reduce own Mystery cooldown by 1.']
    return {'BaseHero':[h],'RoleModel':[{'id':native.hexid(HERO),'model':HERO,'roleStyle':HERO,'roleHead':HERO}],
      'HeroTalent':[{'id':native.hexid(TALENT),'talentName':'Senjutsu Power / Tale of Jiraiya the Gallant','talentDesc':' '.join(descriptions)}],
      'SkillConfig':[{'id':native.hexid(m['id']),'skillId':m['id'],'name':m['name'],'desc':d,'icon':m['id'],'sortId':i+1} for i,(m,d) in enumerate(zip(SKILLS,descriptions))]}
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    db=rows();changes={}
    for f in native.PUBLIC.glob('*/Resources/Bin/**/*'):
        if not f.is_file():continue
        b=f.read_bytes()
        if f.suffix=='.bin' and f.stem.upper() in ['01000005','0100001F','01000038','0100003F']:
            raw=zlib.decompress(b);new=native.patch(raw,db)
            if new!=raw:changes[f]=zlib.compress(new)
        elif f.suffix=='.binPackage':
            p=6;parts=[b[:6]];changed=False
            for _ in range(struct.unpack_from('<H',b,4)[0]):
                n=struct.unpack_from('<I',b,p)[0];p+=4;c=b[p:p+n];p+=n
                raw=zlib.decompress(c);new=native.patch(raw,db)
                if new!=raw:c=zlib.compress(new);changed=True
                parts.extend([native.u32(len(c)),c])
            if changed:changes[f]=b''.join(parts)+b[p:]
    for version in ['2017112917','2026090619']:
        dest=native.PUBLIC/version/'Resources/Textures'
        for suffix,names in ANIM['modelTextures'].items():
            ident=int(f'{HERO:X}'+suffix,16);seq=[]
            for name in ([names] if isinstance(names,str) else names):
                clip=ANIM['clips'][name]
                seq.append(dict(frames=frames(clip['assets']),loop=clip['loop'],duration=clip['duration'],pivots=[ANIM['anchors'][str(i)] for i in clip['assets']]))
            changes[dest/'Model'/f'{ident:08X}.TexClient']=native.texture_sequences(ident,seq)
        # Transparent timing-only impact; the skill graphics are baked into the actor frames.
        changes[dest/'Skill'/f'{HIT:08X}.TexClient']=native.texture(HIT,[Image.new('RGBA',(1,1))],duration=30)
        portrait=Image.open(BASE/'portrait.png').convert('RGBA')
        icon=Image.open(ROOT/'gorsel/jiraiya-icon-input.png').convert('RGBA')
        for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(180,240)),('MiddlePicture',(180,240))]:
            im=ImageOps.fit(icon,size,Image.Resampling.LANCZOS) if category in ['HeadIcon','SmallIcon'] else ImageOps.contain(portrait,size,Image.Resampling.LANCZOS)
            changes[dest/category/f'{HERO:08X}.TexClient']=native.texture(HERO,[im],pivot=False)
        for move,name in zip(SKILLS,NAMES):
            ident=move['id'];im=frames([ANIM['clips'][name]['sourceAssets'][6]])[0]
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=native.texture(ident,[Image.new('RGBA',(1,1))],duration=30)
            changes[dest/'SkillIcon'/f'{ident:08X}.TexClient']=native.texture(ident,[ImageOps.contain(im,(64,64))],pivot=False)
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
    print('PASS Jiraiya SSS Assaulter DB records and native textures:',len(changes),'files. Applied:',args.apply)
if __name__=='__main__':main()
