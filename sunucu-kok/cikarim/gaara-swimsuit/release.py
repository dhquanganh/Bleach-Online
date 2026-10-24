"""Publish the current client and Nagato resources through the local launcher's version map."""
from pathlib import Path
import hashlib,importlib.util,json,shutil
B=Path(__file__).resolve().parent;R=B.parents[1];P=R/'kaynak/login.gogames.me/public';C=P/'2026090619';V='2026102405'
s=importlib.util.spec_from_file_location('codec',B.parent/'naruto-sage-native/release.py');codec=importlib.util.module_from_spec(s);s.loader.exec_module(codec)
def main():
 files={'TApplication.swf',f'Resources/Textures/Inventory/{14130991+0x200000:08X}.TexClient'}
 prefix='kaynak/login.gogames.me/public/2026090619/'
 for e in json.loads((B/'manifest.json').read_text())['files']:
  path=e['path'].replace('\\','/')
  if path.startswith(prefix):files.add(path[len(prefix):])
 for f in (C/'Resources/Bin').rglob('*'):
  if f.is_file() and f.suffix in ('.bin','.binPackage'):files.add(f.relative_to(C).as_posix())
 dest=P/V;dest.mkdir(exist_ok=True)
 for name in sorted(files):
  src=C/name;assert src.exists(),src;out=dest/name;out.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,out)
 version=C/'version.swf';rows=codec.decode(version.read_bytes());updates={k.encode():V.encode() for k in files};keys={k for k,v in rows}
 rows=[(k,updates.get(k,v)) for k,v in rows]+[(k,v) for k,v in updates.items() if k not in keys]
 backup=B/'release-backups';backup.mkdir(exist_ok=True)
 for f in [version,P/'client-release.json']:
  if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
 version.write_bytes(codec.encode(rows))
 for name in ['version.swf','index.swf']:shutil.copy2(C/name,dest/name);files.add(name)
 result={'version':V,'heroId':11120991,'fragmentId':14130991,'files':[{'path':k,'sha256':hashlib.sha256((dest/k).read_bytes()).hexdigest()} for k in sorted(files)]}
 (B/'release.json').write_text(json.dumps(result,indent=2)+'\n')
 pointer=P/'client-release.json';temp=pointer.with_suffix('.tmp');temp.write_text(json.dumps({'version':V})+'\n');temp.replace(pointer)
 print('PASS Gaara local release',V,len(files),'client/data/texture resources')
if __name__=='__main__':main()
