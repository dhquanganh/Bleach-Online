"""Sync the four-round revival and living-owner rescue rules to client tables."""
from pathlib import Path
import importlib.util, json, shutil, struct, zlib

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
P=ROOT/'kaynak/login.gogames.me/public'
VERSION='2026102706'

def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module

builder=load('kakuzu_builder',B/'build.py')
release=load('kakuzu_release',B/'release.py')

def patch_blob(raw,rows):
    if raw[:4] not in [struct.pack('<I',0x100003f),struct.pack('<I',0x100001f)]:return raw
    return builder.n.patch(raw,rows)

def patch_file(path,rows):
    raw=path.read_bytes()
    if path.suffix=='.bin':
        decoded=zlib.decompress(raw);updated=patch_blob(decoded,rows)
        return zlib.compress(updated) if updated!=decoded else None
    pos=6;parts=[raw[:6]];changed=False
    for _ in range(struct.unpack_from('<H',raw,4)[0]):
        size=struct.unpack_from('<I',raw,pos)[0];pos+=4
        chunk=raw[pos:pos+size];pos+=size
        decoded=zlib.decompress(chunk);updated=patch_blob(decoded,rows)
        if updated!=decoded:chunk=zlib.compress(updated);changed=True
        parts.extend([struct.pack('<I',len(chunk)),chunk])
    return b''.join(parts)+raw[pos:] if changed else None

def main():
    assert builder.C['reincarnationDelayRounds']==4
    assert 'revivalLimitPerBattle' not in builder.C
    active=json.loads((P/'client-release.json').read_text())['version']
    assert active=='2026102705'
    dest=P/VERSION;assert not dest.exists()
    generated=builder.rows()
    rows={kind:[] for kind in ['BaseHero','RoleModel','HeroTalent','SkillConfig']}
    rows['SkillConfig']=[r for r in generated['SkillConfig'] if r['skillId'] in [13121908,13121909]]
    rows['HeroTalent']=[r for r in generated['HeroTalent'] if int(r['id'],16)==13220997]
    assert len(rows['SkillConfig'])==2 and len(rows['HeroTalent'])==1
    assert '4 rounds after his defeat' in next(r['desc'] for r in rows['SkillConfig'] if r['skillId']==13121909)
    assert 'While Kakuzu is alive' in next(r['desc'] for r in rows['SkillConfig'] if r['skillId']==13121908)
    canonical=P/'2026090619'
    for name in ['TApplication.swf','version.swf']:assert (canonical/name).read_bytes()==(P/active/name).read_bytes()
    manifest=release.rows((canonical/'version.swf').read_bytes());changes=[]
    for entry in manifest:
        key,version=[v.decode() for v in entry]
        if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
        source=next((f for f in [P/version/key,canonical/key,P/'2017112917'/key] if f.is_file()),None)
        if source is None:continue
        updated=patch_file(source,rows)
        if updated is not None:changes.append((entry,key,updated))
    assert changes
    backup=B/'revival-logic-backup';backup.mkdir(exist_ok=True)
    for name in ['version.swf']:shutil.copy2(canonical/name,backup/name)
    shutil.copy2(P/'client-release.json',backup/'client-release.json')
    dest.mkdir()
    for kind,replacements in rows.items():
        if not replacements:continue
        file=ROOT/'cikarim/veri-json'/(kind+'.json')
        old=json.loads(file.read_text(encoding='utf-8'));byid={r['id']:r for r in replacements}
        assert set(byid)<=set(r['id'] for r in old)
        new=[byid.get(r['id'],r) for r in old]
        shutil.copy2(file,backup/file.name)
        file.write_text(json.dumps(new,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    for entry,key,updated in changes:
        output=dest/key;output.parent.mkdir(parents=True,exist_ok=True);output.write_bytes(updated)
        if (canonical/key).is_file():
            saved=backup/key;saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(canonical/key,saved)
            (canonical/key).write_bytes(updated)
        entry[1]=VERSION.encode()
    data=release.encode(manifest)
    (dest/'version.swf').write_bytes(data)
    for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,dest/name)
    (canonical/'version.swf').write_bytes(data)
    (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
    (B/'revival-logic-release.json').write_text(json.dumps({'version':VERSION,'delayRounds':4,'requiresLivingOwner':True,'tables':[key for _,key,_ in changes]},indent=2)+'\n')
    print('PASS Kakuzu four-round revival / living-owner tooltips',VERSION,len(changes),'tables')

if __name__=='__main__':main()
