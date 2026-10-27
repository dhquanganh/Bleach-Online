"""Normalize LV1/LV159 base stats and publish only BaseHero numeric fields.

Uses the live resource manifest; translated names, animations and other tables
remain byte-identical. Backups make the balance change reversible.
"""
from pathlib import Path
import json, struct, zlib, shutil, hashlib

ROOT=Path(__file__).resolve().parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
POLICY=json.loads((ROOT/'sunucu/hero-base-balance.json').read_text())
VERSION='2026102708'

def balance(hero):
    if hero['assess'] not in POLICY['ranks']: return dict(hero)
    t=POLICY['ranks'].index(hero['assess'])/(len(POLICY['ranks'])-1)
    at=lambda xs: xs[0]+(xs[1]-xs[0])*t
    rounded=lambda x: int(x+0.5)
    life=rounded(at(POLICY['hp']['level1'])/POLICY['hpPerLife'])
    primary=rounded(at(POLICY['attack']['level1'])/POLICY['attackPerPrimary'])
    grow=(at(POLICY['attack']['level159'])/POLICY['attackPerPrimary']-primary)/(POLICY['maxLevel']-1)
    return dict(hero,power=primary,agile=primary,intelligence=primary,life=life,
                powerGrow=grow,agileGrow=grow,intelligenceGrow=grow,
                lifeGrow=(at(POLICY['hp']['level159'])/POLICY['hpPerLife']-life)/(POLICY['maxLevel']-1))

def manifest(data):
    data=zlib.decompress(data);p=2;rows=[]
    for _ in range(struct.unpack_from('<H',data)[0]):
        row=[]
        for _ in range(2):
            n=struct.unpack_from('<H',data,p)[0];p+=2;row.append(data[p:p+n]);p+=n
        rows.append(row)
    assert p==len(data)
    return rows

def encode(rows):
    return zlib.compress(struct.pack('<H',len(rows))+b''.join(struct.pack('<H',len(f))+f for row in rows for f in row))

def patch_raw(raw,heroes):
    if len(raw)<8 or struct.unpack_from('<I',raw)[0]!=0x1000005:return raw
    out=bytearray(raw);p=8
    def utf(p):return p+2+struct.unpack_from('<H',raw,p)[0]
    for _ in range(struct.unpack_from('<I',raw,4)[0]):
        ident=struct.unpack_from('<I',raw,p)[0];q=p+8
        for _ in range(3):q=utf(q)
        hero=heroes.get(ident)
        if hero:
            struct.pack_into('<4I',out,q+24,*(hero[k] for k in ['power','agile','intelligence','life']))
            struct.pack_into('<4f',out,q+44,*(hero[k] for k in ['powerGrow','agileGrow','intelligenceGrow','lifeGrow']))
        p=utf(q+144)+16;p=utf(p)+4;p=utf(utf(p))
    assert p==len(raw)
    return bytes(out)

def patch(data,suffix,heroes):
    if suffix=='.bin':
        raw=zlib.decompress(data);out=patch_raw(raw,heroes)
        return data if out==raw else zlib.compress(out)
    p=6;out=data[:6]
    for _ in range(struct.unpack_from('<H',data,4)[0]):
        n=struct.unpack_from('<I',data,p)[0];p+=4;chunk=data[p:p+n];p+=n
        raw=zlib.decompress(chunk);updated=patch_raw(raw,heroes)
        packed=chunk if updated==raw else zlib.compress(updated)
        out+=struct.pack('<I',len(packed))+packed
    return out+data[p:]

def main():
    canonical=PUBLIC/'2026090619';active=json.loads((PUBLIC/'client-release.json').read_text())['version']
    assert active!=VERSION,'Already published'
    dest=PUBLIC/VERSION;assert not dest.exists()
    backup=ROOT/'cikarim/hero-base-balance-backup';backup.mkdir(exist_ok=True)
    files=[ROOT/'cikarim/veri-json/BaseHero.json',ROOT/'cikarim/veri-json-yedek/BaseHero.json']
    source=json.loads(files[0].read_text(encoding='utf-8'))
    balanced=[balance(h) for h in source];heroes={int(h['id'],16):h for h in balanced}
    rows=manifest((canonical/'version.swf').read_bytes());updates={}
    # Include translated fallback tables beside every referenced table version.
    for key,version in rows:
        key=key.decode();version=version.decode()
        if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
        src=PUBLIC/version/key
        if not src.is_file():src=canonical/key
        if not src.is_file():continue
        candidates={src}
        candidates.update((PUBLIC/version/'Resources/Bin').glob('**/'+src.name))
        candidates.update((canonical/'Resources/Bin').glob('**/'+src.name))
        for candidate in candidates:
            rel=candidate.relative_to(PUBLIC/candidate.relative_to(PUBLIC).parts[0]).as_posix()
            if rel in updates:continue
            data=candidate.read_bytes();out=patch(data,candidate.suffix,heroes)
            if out!=data:updates[rel]=(candidate,data,out)
    assert updates,'No BaseHero table found'
    dest.mkdir()
    for rel,(src,old,out) in updates.items():
        save=backup/rel;save.parent.mkdir(parents=True,exist_ok=True);save.write_bytes(old)
        for base in [dest,canonical]:
            target=base/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(out)
    for f in files:
        if not f.exists():continue
        shutil.copy2(f,backup/(f.parent.name+'-BaseHero.json'))
        old=json.loads(f.read_text(encoding='utf-8'))
        f.write_text(json.dumps([balance(h) for h in old],ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    for name in ['version.swf','TApplication.swf','index.swf']:shutil.copy2(canonical/name,backup/name)
    shutil.copy2(PUBLIC/'client-release.json',backup/'client-release.json')
    for row in rows:
        if row[0].decode() in updates or row[0]==b'TApplication.swf':row[1]=VERSION.encode()
    data=encode(rows)
    for base in [dest,canonical]:(base/'version.swf').write_bytes(data)
    for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,dest/name)
    (PUBLIC/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
    report={'version':VERSION,'heroes':len(balanced),'tables':list(updates),'clientSha256':hashlib.sha256((dest/'TApplication.swf').read_bytes()).hexdigest()}
    (backup/'result.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))

if __name__=='__main__':main()
