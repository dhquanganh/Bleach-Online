"""Publish current Sasuke app/data/models/icons without resetting older routes."""
from pathlib import Path
import hashlib,importlib.util,json,shutil
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];PUBLIC=ROOT/'kaynak/login.gogames.me/public';CANON=PUBLIC/'2026090619';VERSION='2026102233'
s=importlib.util.spec_from_file_location('version_codec',BASE.parent/'naruto-sage-native/release.py');codec=importlib.util.module_from_spec(s);s.loader.exec_module(codec)
def main():
 files={'TApplication.swf'}
 manifest=json.loads((BASE/'manifest.json').read_text())
 prefix='kaynak/login.gogames.me/public/2026090619/'
 for entry in manifest['files']:
  path=entry['path'].replace('\\','/')
  if path.startswith(prefix):files.add(path[len(prefix):])
 for p in (CANON/'Resources/Bin').rglob('*'):
  if p.is_file() and p.suffix in ('.bin','.binPackage'):files.add(p.relative_to(CANON).as_posix())
 files.add(f'Resources/Textures/Inventory/{14130970+0x200000:08X}.TexClient')
 release=PUBLIC/VERSION;release.mkdir(exist_ok=True)
 for rel in files:
  src=CANON/rel;assert src.exists(),src
  dst=release/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
 path=CANON/'version.swf';rows=codec.decode(path.read_bytes());replacements={r.encode():VERSION.encode() for r in files};keys={k for k,v in rows}
 rows=[(k,replacements.get(k,v)) for k,v in rows]+[(k,v) for k,v in replacements.items() if k not in keys]
 backup=BASE/'backups/version.swf'
 if not backup.exists():backup.write_bytes(path.read_bytes())
 path.write_bytes(codec.encode(rows))
 # Version the bootstrap too: an old cached version.swf can otherwise keep
 # pointing at the previous application even when its replacement is installed.
 shutil.copy2(CANON/'index.swf',release/'index.swf')
 shutil.copy2(path,release/'version.swf')
 files.update({'index.swf','version.swf'})
 (BASE/'release.json').write_text(json.dumps({'version':VERSION,'files':[{'path':f,'sha256':hashlib.sha256((release/f).read_bytes()).hexdigest()} for f in sorted(files)],'cinematics':json.loads((BASE/'cinematics.json').read_text())},indent=2)+'\n')
 # Publish last, after all files are ready. Launcher reads this without cache.
 pointer=PUBLIC/'client-release.json';temp=pointer.with_suffix('.tmp')
 temp.write_text(json.dumps({'version':VERSION})+'\n');temp.replace(pointer)
 print('PASS Sasuke release',VERSION,len(files),'app/data/texture routes')
if __name__=='__main__':main()
