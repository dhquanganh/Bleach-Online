"""Build Naruto's native databases and TexClient animations from the supplied PNGs.
Run with --apply to install. Existing unrelated records remain byte-for-byte intact.
"""
from pathlib import Path
from PIL import Image, ImageOps
import argparse, copy, hashlib, io, json, shutil, struct, zlib
import vfx

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[1]
PUBLIC = ROOT / 'kaynak/login.gogames.me/public'
DATA = ROOT / 'cikarim/veri-json'
CONFIG = json.loads((ROOT/'sunucu/naruto-sage.json').read_text())
ANIMATION = json.loads((BASE/'animation.json').read_text())
HERO, CLONE = CONFIG['heroId'], CONFIG['cloneId']
TALENT = 13220901
hexid = lambda n: f'{n:08X}'
u32 = lambda n: struct.pack('<I', n)
def utf(s):
    b=s.encode('utf-8'); return struct.pack('<H',len(b))+b

def serialize_hero(h):
    fields=lambda names,fmt: b''.join(struct.pack(fmt,h[n]) for n in names.split())
    return (u32(int(h['id'],16))+u32(h['isMain'])+utf(h['desc'])+utf(h['name'])+utf(h['assess'])
        +fields('sex level needLevel profession source quality power agile intelligence life speed','<I')
        +fields('powerGrow agileGrow intelligenceGrow lifeGrow speedGrow','<f')
        +fields('nearAttack nearDefense farAttack farDefense strategyAttack strategyDefense','<I')
        +fields('hitRate dodgeRate critRate blockRate punchRate helpRate hurtRate avoidHurtRate wreckRate antiknockRate attachRate deFenceRate recoverRate','<f')
        +u32(h['active'])+utf(h['attackEffect'])+fields('normalAttack talent sound weakness','<I')
        +utf(h['headStyle'])+u32(h['country'])+utf(h['heroSoul'])+utf(h['f48']))

def record_end(raw,p,kind):
    def skip_utf(p): return p+2+struct.unpack_from('<H',raw,p)[0]
    if kind=='RoleModel': return p+16
    if kind=='HeroTalent': return skip_utf(skip_utf(p+4))
    if kind=='SkillConfig': return skip_utf(skip_utf(p+8))+8
    p+=8
    for _ in range(3):p=skip_utf(p)
    p+=144
    p=skip_utf(p)+16
    p=skip_utf(p)+4
    return skip_utf(skip_utf(p))

def records(raw,kind):
    p=8; result=[]
    for _ in range(struct.unpack_from('<I',raw,4)[0]):
        end=record_end(raw,p,kind);result.append((struct.unpack_from('<I',raw,p)[0],raw[p:end]));p=end
    assert p==len(raw),(kind,p,len(raw))
    return result

def database_rows():
    heroes=json.loads((DATA/'BaseHero.json').read_text(encoding='utf-8'))
    template=next(h for h in heroes if h['isMain']==0)
    h=copy.deepcopy(template)
    moves=[CONFIG[k] for k in ['mystery','standard','barrage']]+CONFIG['chases']
    effects={}
    for move in moves:
        clip=ANIMATION['clips']['mystery' if move.get('prompt') else 'summon' if move.get('summon') else 'chase' if move.get('requires') else 'barrage']
        effect={'target':1,'backPoint':{str(clip['returnFrame']):1}}
        if not move.get('summon'):
            hitframes=clip['hitFrames'];amounts=[100//len(hitframes)]*len(hitframes);amounts[-1]+=100-sum(amounts)
            visual=vfx.CONFIG['skills'][str(move['id'])]
            impact=vfx.CONFIG['effects'][visual['impact']]
            effect['appendEffect']={str(frame):{'target':2,'effectId':impact['id'],
                'anmyhp':{str(visual['damageFrame']):amount,'checkDie':int(i==len(hitframes)-1)}} for i,(frame,amount) in enumerate(zip(hitframes,amounts))}
            effect['appendEffect'][str(visual['chargeFrame'])]={'target':1,'effectId':vfx.CONFIG['effects'][visual['charge']]['id']}
        if not move.get('prompt') and not move.get('summon'):effect['runPoint']={'0':{'target':2}}
        effects[str(move['id'])]=effect
    h.update(id=hexid(HERO),isMain=0,desc='Wind / Senjutsu / Konoha. Naruto Online base three-star kit.',name=CONFIG['name'],assess='S',sex=1,
        level=1,needLevel=1,profession=3,source=4,quality=4,power=70,agile=80,intelligence=100,life=240,
        powerGrow=2.0,agileGrow=2.2,intelligenceGrow=3.0,lifeGrow=2.5,speedGrow=2.0,
        active=moves[0]['id'],normalAttack=CONFIG['barrage']['id'],talent=TALENT,
        attackEffect=json.dumps(effects,separators=(',',':')),headStyle='',heroSoul='')
    for key in ['dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','recoverRate']:h[key]=0
    h['hitRate']=1
    clone=copy.deepcopy(h);clone.update(id=hexid(CLONE),name='Sage Shadow Clone',isSummon=True,desc='Summon only; Lightning resistant.',active=moves[2]['id'])
    talents=[{'id':hexid(TALENT),'talentName':'Sage Jutsu Chakra / Shadow Clone',
        'talentDesc':'+20 team chakra before the first move each round. Summon a Lightning-resistant clone at battle start. Summon and Rasengan Barrage share a 2-round cooldown and primary action. Chase Repulse -> Knockdown: 2-round cooldown, no bonus bypass. Rasen Shuriken: 40 chakra, cooldown 3 rounds, battlefield cooldown 1; consumes the primary action; 10 COMBO to lineup and Repulse to selected target.'}]
    roles=[{'id':hexid(n),'model':HERO,'roleStyle':HERO,'roleHead':HERO} for n in [HERO,CLONE]]
    skillrows=[{'id':hexid(m['id']),'skillId':m['id'],'name':m['name'],'desc':
        ('Wind damage to lineup, 10 COMBO; selected target suffers Repulse. Prompt. Chakra 40 / Cooldown 3 rounds / Battlefield cooldown 1. Consumes the primary action.' if m.get('prompt') else
         'Summons a Lightning-resistant Sage Shadow Clone. Shares a 2-round cooldown with Rasengan Barrage; uses the primary action.' if m.get('summon') else
         'Chase Repulse and cause Knockdown. Cooldown 2 rounds; no Chase bonus bypass.' if m.get('requires') else 'Combined Taijutsu and Ninjutsu with the clone; always causes Low Float on hit. Shares a 2-round cooldown with Summon; uses the primary action and waits while recovering.'),
        'icon':m['id'],'sortId':i+1} for i,m in enumerate(moves)]
    return {'BaseHero':[h,clone],'RoleModel':roles,'HeroTalent':talents,'SkillConfig':skillrows}

def serialize(kind,row):
    ident=u32(int(row['id'],16))
    if kind=='BaseHero':return serialize_hero(row)
    if kind=='RoleModel':return ident+b''.join(u32(row[k]) for k in ['model','roleStyle','roleHead'])
    if kind=='HeroTalent':return ident+utf(row['talentName'])+utf(row['talentDesc'])
    return ident+u32(row['skillId'])+utf(row['name'])+utf(row['desc'])+u32(row['icon'])+u32(row['sortId'])

def patch(raw,rows):
    kind={0x1000005:'BaseHero',0x100001f:'HeroTalent',0x1000038:'RoleModel',0x100003f:'SkillConfig'}.get(struct.unpack_from('<I',raw)[0])
    if not kind:return raw
    old=records(raw,kind);replacements={int(r['id'],16):serialize(kind,r) for r in rows[kind]}
    result=[(ident,replacements.get(ident,b)) for ident,b in old]
    result.extend((ident,b) for ident,b in replacements.items() if ident not in dict(old))
    out=raw[:4]+u32(len(result))+b''.join(b for ident,b in result)
    check=dict(records(out,kind))
    assert all(check[ident]==b for ident,b in old if ident not in replacements)
    assert all(check[ident]==b for ident,b in replacements.items())
    return out

def texture_sequence(index,frames,loop,duration,pivots):
    # One big-endian PAK atlas; red-channel alpha occupies its lower half.
    w=max(im.width for im in frames);h=max(im.height for im in frames)
    width=sum(im.width for im in frames);atlas=Image.new('RGB',(width,h*2));rects=[];x=0
    seq=struct.pack('<IBH',index,2 if loop else 1,len(frames))
    for i,im in enumerate(frames):
        atlas.paste(im.convert('RGB'),(x,0));atlas.paste(im.getchannel('A').convert('RGB'),(x,h))
        rects.append(struct.pack('>hhhh',x,0,im.width,im.height))
        px,py=pivots[i]
        seq+=struct.pack('<hhhhhhH',0,0,im.width,im.height,px,py,duration)
        x+=im.width
    buf=io.BytesIO();atlas.save(buf,format='PNG');png=buf.getvalue()
    pak=zlib.compress(struct.pack('>BHHBBBH',1,width,h,100,100,0,len(frames))+b''.join(rects)+struct.pack('>I',len(png))+png)
    return seq,pak

def texture_sequences(ident,sequences):
    built=[texture_sequence(index,**sequence) for index,sequence in enumerate(sequences)]
    seq=b''.join(s for s,p in built)
    return u32(ident)+u32(len(seq))+seq+struct.pack('<H',len(built))+b''.join(u32(len(p))+p for s,p in built)+struct.pack('<H',len(built))

def texture(ident,frames,loop=False,duration=70,pivot=True):
    return texture_sequences(ident,[dict(frames=frames,loop=loop,duration=duration,
        pivots=[(im.width//2,im.height) if pivot else (0,0) for im in frames])])

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    rows=database_rows();changes={};counts={}
    # Individual bins as well as all combined/language packages must agree.
    for f in PUBLIC.glob('*/Resources/Bin/**/*'):
        if not f.is_file():continue
        b=f.read_bytes()
        if f.suffix=='.bin' and f.stem in ['01000005','0100001F','01000038','0100003F']:
            raw=zlib.decompress(b);new=patch(raw,rows)
            if new!=raw:changes[f]=zlib.compress(new)
        elif f.suffix=='.binPackage':
            p=6;parts=[b[:6]];changed=False
            for _ in range(struct.unpack_from('<H',b,4)[0]):
                n=struct.unpack_from('<I',b,p)[0];p+=4;c=b[p:p+n];p+=n
                raw=zlib.decompress(c);new=patch(raw,rows)
                if new!=raw:c=zlib.compress(new);changed=True
                parts.extend([u32(len(c)),c])
            parts.append(b[p:])
            if changed:changes[f]=b''.join(parts)
    files={int(p.stem.rsplit('_',1)[1]):p for p in (ROOT.parent/'asset/Browser Games - Naruto Online - Recruitable Characters - Naruto Uzumaki (Sage Mode)').rglob('*.png')}
    def images(ids):return [Image.open(files[n]).convert('RGBA') for n in ids]
    portrait=Image.open(ROOT/'gorsel/naruto-sage-thumb.png').convert('RGBA')
    for version in ['2017112917','2026090619']:
        dest=PUBLIC/version/'Resources/Textures'
        for suffix,names in ANIMATION['modelTextures'].items():
            ident=int(f'{HERO:X}'+suffix,16)
            sequences=[]
            for name in ([names] if isinstance(names,str) else names):
                clip=ANIMATION['clips'][name]
                sequences.append(dict(frames=images(clip['assets']),loop=clip['loop'],duration=clip['duration'],
                    pivots=[ANIMATION['anchors'][str(n)] for n in clip['assets']]))
            changes[dest/'Model'/f'{ident:08X}.TexClient']=texture_sequences(ident,sequences)
        for category,size in [('HeadIcon',(48,48)),('SmallIcon',(48,48)),('LargeIcon',(180,240)),('MiddlePicture',(180,240))]:
            if category in ['HeadIcon','SmallIcon']:
                im=ImageOps.fit(portrait,size,Image.Resampling.LANCZOS)
            else:
                im=portrait.copy()
                im.thumbnail(size,Image.Resampling.LANCZOS)
            changes[dest/category/f'{HERO:08X}.TexClient']=texture(HERO,[im],pivot=False)
        for m in [CONFIG[k] for k in ['mystery','standard','barrage']]+CONFIG['chases']:
            ident=m['id'];ims=images(list(range(119,128)))
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=texture(ident,ims)
            icon=images([130 if ident!=CONFIG['mystery']['id'] else 119])[0];icon.thumbnail((64,64))
            changes[dest/'SkillIcon'/f'{ident:08X}.TexClient']=texture(ident,[icon],pivot=False)
        for visual in vfx.CONFIG['effects'].values():
            ident=visual['id']
            changes[dest/'Skill'/f'{ident:08X}.TexClient']=texture_sequences(ident,[dict(frames=vfx.frames(visual),
                loop=False,duration=visual['duration'],pivots=vfx.pivots(visual))])
    # JSON DBs are authoritative for the server. Do not touch live player saves.
    for kind,extra in rows.items():
        f=DATA/(kind+'.json');old=json.loads(f.read_text(encoding='utf-8'));byid={r['id']:r for r in extra}
        new=[byid.get(r['id'],r) for r in old]+[r for r in extra if r['id'] not in {o['id'] for o in old}]
        if old!=new:changes[f]=(json.dumps(new,ensure_ascii=False,indent=2)+'\n').encode()
    backup=BASE/'backups'
    if args.apply:
        for f,b in changes.items():
            if f.exists() and f.read_bytes()==b:continue
            dest=backup/f.relative_to(ROOT)
            if f.exists() and not dest.exists():dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,dest)
            f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(b)
    images([51])[0].save(BASE/'naruto-preview.png')
    manifest={'applied':args.apply,'heroId':HERO,'cloneId':CLONE,'files':[{ 'path':str(f.relative_to(ROOT)), 'sha256':hashlib.sha256(b).hexdigest()} for f,b in changes.items()]}
    (BASE/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('Verified Naruto native resources:',len(changes),'files. Applied:',args.apply)

if __name__=='__main__':main()
