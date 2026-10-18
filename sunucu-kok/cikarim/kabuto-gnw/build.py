"""Install Kabuto SSS Support and four summon models; preserve unrelated records."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native_kabuto',BASE.parent/'naruto-sage/build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
CFG=json.loads((ROOT/'sunucu/kabuto-gnw.json').read_text());ANIM=json.loads((BASE/'animation.json').read_text())
HIT=13621931
MOVES=[(CFG['mystery'],'white-snake-assault'),(CFG['standard'],'bracken-dance'),(CFG['chases'][0],'white-extreme-attack'),
       (CFG['healing'],'self-healing'),(CFG['revival'],'white-snake-revival'),(CFG['summon'],'impure-world-reincarnation'),
       (CFG['mu']['standard'],'mu-strike'),(CFG['mu']['summon'],'mu-summon'),(CFG['mu']['barrier'],'mu-barrier')]
MOVES += [(CFG[k]['standard'],k+'-attack') for k in ['deidara','dan','pakura']]
DESCRIPTIONS={
13120931:'Prompt. 40 chakra, cooldown 3 rounds, battlefield cooldown 1. Consumes the primary action. Damage, 4 Combo and Level 2 Poison to up to 9 enemies; selected target Knockdown and Interruption. If selected target was already Poisoned or Strong Poisoned, unavoidable and adds Level 2 Strong Poison. Cooldown survives revival.',
13120932:'Melee attack a random enemy; stackable -12% Defense. 35% local chance to hit its lineup instead: this variant causes 6 Combo, Suppress Super Armor until round end and Low Float to a random hit target. Hit Edo Tensei units receive Curse Binding until end of next round.',
13120933:'Chase Low Float or High Float; Repulse. Never misses. Damage, Suppress Immunity until round end and Level 2 Blindness for 1 round to all units in the selected lineup. Once per round.',
13120934:'Before an action: recover 12% max HP, 40 shared chakra, restore team chakra limit to 100. Cooldown 2 rounds; at most once per round. Cooldown survives revival.',
13120935:'Immune to Debuffs unless Suppress Immunity is active. When ready, after defeat revive next round at 25% max HP and resummon Mu. Revival cooldown 4 rounds, starting on revival. A death during cooldown cannot revive later. Existing skill cooldowns are preserved. Cannot revive after a Deidara kill.',
13120936:'Battle start: summon Mu with 100% Kabuto max HP. Mu remains after Kabuto defeat. Mu summons Deidara after its standard once per round, Dan Kato at even-round start, Pakura at odd-round start.',
13120937:'Mu melee strike. Then summons Deidara once per round.',
13120938:'Summon a temporary Edo Tensei ninja from a coffin; the summon executes its skill then disappears.',
13120942:'Undispellable barrier for 2 rounds. Both camps: only Kabuto and Edo Tensei can standard attack. Owner camp shares 2 fatal-damage escapes per active round, each recovers to 50% max HP.',
13120939:'On summon: damage up to 12 enemies, Suppress Super Armor until round end, Knockdown to front target. Victims killed by this skill cannot revive. Then disappears.',
13120940:'On summon: front target damage and Suppress Immunity for 3 rounds; absorb all enemy shared chakra, capped by own team limit. Then disappears.',
13120941:'On summon: damage and Ignition to up to 9 enemies. +80% damage against effective Super Armor. Then disappears.'}
for sid in [13120932,13120933]:DESCRIPTIONS[sid]+=' Cooldown 2 rounds.'
for sid in [13120936,13120937,13120938,13120939,13120940,13120941]:DESCRIPTIONS[sid]+=' Each Edo guest type has a separate 3-round summon cooldown; resummoning Mu does not reset it.'
DESCRIPTIONS[13120942]+=' Cooldown 3 rounds; resummoning Mu does not reset it.'

def rows():
    heroes=json.loads((native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
    template=next(h for h in heroes if h['assess']=='SSS' and h['profession']==3 and h['quality']==7)
    effects={}
    for move,name in MOVES:
        clip=ANIM['clips'][name];effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
        if 'hitFrames' in clip:effect['appendEffect']={str(clip['hitFrames'][0]):{'target':2,'effectId':HIT,'anmyhp':{'0':100,'checkDie':1}}}
        if name in ['bracken-dance','mu-strike']:effect['runPoint']={'0':{'target':2}}
        effects[str(move['id'])]=effect
    heroes=[];roles=[];talents=[]
    for index,key in enumerate(['kabuto','mu','deidara','dan','pakura']):
        p=CFG if key=='kabuto' else CFG[key];ident=p['heroId'];h=copy.deepcopy(template)
        h.update(id=native.hexid(ident),name=p['name'],assess='SSS',profession=3,quality=7,isMain=0,isSummon=key!='kabuto',
          desc=('Water / Senjutsu. SSS Support; melee standard. '+DESCRIPTIONS[13120936]) if key=='kabuto' else 'Edo Tensei summon only; unavailable for recruitment.',
          active=CFG['mystery']['id'] if key=='kabuto' else CFG['mu']['barrier']['id'] if key=='mu' else p['standard']['id'],normalAttack=p['standard']['id'],talent=13220910+index,
          attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='',sex=2 if key=='pakura' else 1,
          level=1,needLevel=1,power=6500,agile=6500,intelligence=8500,life=7500,speed=105,
          powerGrow=2.8,agileGrow=2.8,intelligenceGrow=3.6,lifeGrow=3.2,speedGrow=2.4)
        for field in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[field]=0
        h['hitRate']=1;heroes.append(h)
        roles.append({'id':native.hexid(ident),'model':ident,'roleStyle':ident,'roleHead':ident})
        talents.append({'id':native.hexid(13220910+index),'talentName':'Impure World Reincarnation / Power of the White Snake' if key=='kabuto' else p['name'],
                        'talentDesc':' '.join(DESCRIPTIONS[sid] for sid in ([13120934,13120935,13120936] if key=='kabuto' else [p['standard']['id']]))})
    return {'BaseHero':heroes,'RoleModel':roles,'HeroTalent':talents,
            'SkillConfig':[{'id':native.hexid(move['id']),'skillId':move['id'],'name':move['name'],'desc':DESCRIPTIONS[move['id']],'icon':move['id'],'sortId':index+1} for index,(move,name) in enumerate(MOVES)]}

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
                n=struct.unpack_from('<I',b,p)[0];p+=4;c=b[p:p+n];p+=n;raw=zlib.decompress(c);new=native.patch(raw,db)
                if new!=raw:c=zlib.compress(new);changed=True
                parts.extend([native.u32(len(c)),c])
            if changed:changes[f]=b''.join(parts)+b[p:]
    for version in ['2017112917','2026090619']:
        dest=native.PUBLIC/version/'Resources/Textures'
        for hero,textures in ANIM['models'].items():
            hero=int(hero)
            for suffix,names in textures.items():
                ident=int(f'{hero:X}'+suffix,16);sequences=[]
                for name in ([names] if isinstance(names,str) else names):
                    clip=ANIM['clips'][name];ims=[Image.open(BASE/'frames'/f'{i:03}.png').convert('RGBA') for i in clip['assets']]
                    sequences.append(dict(frames=ims,loop=clip['loop'],duration=clip['duration'],pivots=[tuple(ANIM['pivot'])]*len(ims)))
                changes[dest/'Model'/f'{ident:08X}.TexClient']=native.texture_sequences(ident,sequences)
            idle=textures[''];pose=Image.open(BASE/'frames'/f'{ANIM["clips"][idle]["assets"][0]:03}.png').convert('RGBA')
            portrait=pose.crop(pose.getchannel('A').getbbox())
            icon=Image.open(ROOT/'gorsel/kabuto-icon-input.png').convert('RGBA') if hero==CFG['heroId'] else portrait.crop((0,0,portrait.width,max(1,portrait.height//2)))
            for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(180,240)),('MiddlePicture',(180,240))]:
                im=ImageOps.fit(icon,size,Image.Resampling.LANCZOS) if category in ['HeadIcon','SmallIcon'] else ImageOps.contain(portrait,size,Image.Resampling.LANCZOS)
                changes[dest/category/f'{hero:08X}.TexClient']=native.texture(hero,[im],pivot=False)
        changes[dest/'Skill'/f'{HIT:08X}.TexClient']=native.texture(HIT,[Image.new('RGBA',(1,1))],duration=40)
        for move,name in MOVES:
            ident=move['id'];clip=ANIM['clips'][name];im=Image.open(BASE/'frames'/f'{clip["keys"][min(1,len(clip["keys"])-1)]:03}.png').convert('RGBA')
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=native.texture(ident,[Image.new('RGBA',(1,1))],duration=40)
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
    (BASE/'manifest.json').write_text(json.dumps({'applied':args.apply,'heroId':CFG['heroId'],'summons':[CFG[k]['heroId'] for k in ['mu','deidara','dan','pakura']],
      'files':[{'path':str(f.relative_to(ROOT)),'sha256':hashlib.sha256(b).hexdigest()} for f,b in changes.items()]},indent=2))
    print('PASS Kabuto SSS Support, 4 summon-only heroes, 12 skills and native resources;',len(changes),'files. Applied:',args.apply)
if __name__=='__main__':main()
