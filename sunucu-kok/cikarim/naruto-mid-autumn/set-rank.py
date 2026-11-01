"""Change only Naruto Mid-Autumn's grade; preserve stats, skills and animation."""
from pathlib import Path
import importlib.util,json,struct,zlib,shutil,hashlib,sys
B=Path(__file__).resolve().parent
sys.path.insert(0,str(B.parent/'naruto-sage'))
s=importlib.util.spec_from_file_location('native',B.parent/'naruto-sage/build.py');n=importlib.util.module_from_spec(s);s.loader.exec_module(n)
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
P=n.PUBLIC;C=P/'2026090619';active=json.loads((P/'client-release.json').read_text())['version'];assert active=='2026103107'
config=json.loads((B.parents[1]/'sunucu/naruto-mid-autumn.json').read_text());table=n.DATA/'BaseHero.json';heroes=json.loads(table.read_text(encoding='utf-8'));hero=next(h for h in heroes if int(h['id'],16)==config['heroId']);before=dict(hero)
hero.update(assess=config['assess'],quality=config['quality'],desc=hero['desc'].replace('SS+.','SS.',1));assert set(k for k in hero if hero[k]!=before[k])<=set(['assess','quality','desc'])
def patch(raw):return n.patch(raw,{'BaseHero':[hero]}) if struct.unpack_from('<I',raw)[0]==0x1000005 else raw
rows=m.rows((C/'version.swf').read_bytes());files=set()
for key,ver in rows:
 if key.startswith(b'Resources/Bin/') and key.endswith((b'.bin',b'.binPackage')):files.add(P/ver.decode()/key.decode())
for version in ['2017112917','2026090619']:files.update((P/version/'Resources/Bin').rglob('*.bin'));files.update((P/version/'Resources/Bin').rglob('*.binPackage'))
changes={}
for path in files:
 if not path.is_file():continue
 data=path.read_bytes()
 if path.suffix=='.bin':
  raw=zlib.decompress(data);out=patch(raw)
  if out!=raw:changes[path]=zlib.compress(out)
 else:
  p=6;parts=[data[:6]];changed=False
  for _ in range(struct.unpack_from('<H',data,4)[0]):
   size=struct.unpack_from('<I',data,p)[0];p+=4;chunk=data[p:p+size];p+=size;raw=zlib.decompress(chunk);out=patch(raw)
   if out!=raw:chunk=zlib.compress(out);changed=True
   parts.extend([n.u32(len(chunk)),chunk])
  if changed:changes[path]=b''.join(parts)+data[p:]
changes[table]=(json.dumps(heroes,ensure_ascii=False,indent=2)+'\n').encode()
backup=B/'rank-backup'
for path,data in changes.items():
 dest=backup/path.relative_to(B.parents[1]);dest.parent.mkdir(parents=True,exist_ok=True);assert not dest.exists();shutil.copy2(path,dest);path.write_bytes(data)
version='2026110101';dest=P/version;assert not dest.exists();dest.mkdir()
for row in rows:
 key,ver=[x.decode() for x in row]
 if key.startswith('Resources/Bin/') and key.endswith(('.bin','.binPackage')):
  src=next((p for p in [C/key,P/ver/key] if p.is_file()),None)
  if src:target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target);row[1]=version.encode()
 if key=='TApplication.swf':row[1]=version.encode()
for src in (C/'Resources/Bin').rglob('*'):
 if src.is_file() and src.suffix in ('.bin','.binPackage'):
  target=dest/src.relative_to(C)
  if not target.exists():target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target)
for name in ['version.swf','TApplication.swf']:shutil.copy2(C/name,backup/name)
shutil.copy2(P/'client-release.json',backup/'client-release.json')
client=(C/'TApplication.swf').read_bytes();assert client==(P/active/'TApplication.swf').read_bytes()
for name in ['TApplication.swf','index.swf']:shutil.copy2(C/name,dest/name)
manifest=m.encode(rows);(C/'version.swf').write_bytes(manifest);(dest/'version.swf').write_bytes(manifest);(P/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(B/'rank-release.json').write_text(json.dumps({'version':version,'heroId':config['heroId'],'assess':hero['assess'],'quality':hero['quality'],'clientSha256':hashlib.sha256(client).hexdigest(),'statsSkillsAndAnimationsUnchanged':True,'patchedFiles':len(changes)},indent=2))
print('PASS Naruto Mid-Autumn SS / quality 5; stats and animations unchanged;',version)
