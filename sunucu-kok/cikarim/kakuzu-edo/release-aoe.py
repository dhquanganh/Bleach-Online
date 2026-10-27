"""Publish Kakuzu's all-enemy Mystery tooltip in the client resource map."""
from pathlib import Path
import importlib.util, json, shutil, struct, zlib

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
P=ROOT/'kaynak/login.gogames.me/public'
VERSION='2026102703'

def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    return mod

release=load('prior_release',B/'release.py')
native=load('kakuzu_packing',B.parent/'shared-animation/packing.py').native

def patch_blob(data,row):
    rows={kind:[] for kind in ['BaseHero','RoleModel','HeroTalent','SkillConfig']}
    rows['SkillConfig']=[row]
    if data[:4]==struct.pack('<I',0x100003f):return native.patch(data,rows)
    return data

def patch_file(path,row):
    raw=path.read_bytes()
    if path.suffix=='.bin':
        decoded=zlib.decompress(raw);updated=patch_blob(decoded,row)
        return zlib.compress(updated) if updated!=decoded else None
    if path.suffix!='.binPackage':return None
    pos=6;parts=[raw[:6]];changed=False
    for _ in range(struct.unpack_from('<H',raw,4)[0]):
        size=struct.unpack_from('<I',raw,pos)[0];pos+=4
        chunk=raw[pos:pos+size];pos+=size
        decoded=zlib.decompress(chunk);updated=patch_blob(decoded,row)
        if updated!=decoded:chunk=zlib.compress(updated);changed=True
        parts.extend([struct.pack('<I',len(chunk)),chunk])
    return b''.join(parts)+raw[pos:] if changed else None

def main():
    assert json.loads((P/'client-release.json').read_text())['version']=='2026102702'
    target=P/VERSION
    assert not target.exists()
    row=next(x for x in json.loads((ROOT/'cikarim/veri-json/SkillConfig.json').read_text(encoding='utf-8')) if x.get('skillId')==13121901)
    assert 'all enemy units' in row['desc']
    canonical=P/'2026090619';manifest=release.rows((canonical/'version.swf').read_bytes());changes=[]
    for entry in manifest:
        key,version=[v.decode() for v in entry]
        if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
        choices=[P/version/key,canonical/key,P/'2017112917'/key]
        source=next((f for f in choices if f.is_file()),None)
        if source is None:continue
        patched=patch_file(source,row)
        if patched is not None:changes.append((entry,key,patched))
    assert changes, 'No client SkillConfig table changed'
    backup=B/'aoe-backup';backup.mkdir(exist_ok=True)
    shutil.copy2(canonical/'version.swf',backup/'version.swf')
    shutil.copy2(P/'client-release.json',backup/'client-release.json')
    target.mkdir()
    for entry,key,patched in changes:
        dest=target/key;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(patched)
        old=canonical/key
        if old.exists():
            saved=backup/key;saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(old,saved)
            old.write_bytes(patched)
        entry[1]=VERSION.encode()
    data=release.encode(manifest)
    (target/'version.swf').write_bytes(data)
    for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,target/name)
    (canonical/'version.swf').write_bytes(data)
    (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
    (B/'aoe-release.json').write_text(json.dumps({'version':VERSION,'tables':[key for _,key,_ in changes]},indent=2)+'\n')
    print('PASS Kakuzu AoE client tooltip release',VERSION,len(changes),'tables')

if __name__=='__main__':main()
