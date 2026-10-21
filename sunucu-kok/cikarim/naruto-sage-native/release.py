"""Publish an incremental cache-busting Naruto Sage release without changing application bytecode."""
from pathlib import Path
import hashlib,json,shutil,struct,zlib

BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public';CANON=PUBLIC/'2026090619';VERSION='2026102124'

def decode(data):
 raw=zlib.decompress(data);pos=2;rows=[]
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;value=raw[pos:pos+n];pos+=n;rows.append((key,value))
 assert pos==len(raw);return rows

def encode(rows):
 raw=struct.pack('<H',len(rows))+b''.join(struct.pack('<H',len(k))+k+struct.pack('<H',len(v))+v for k,v in rows)
 return zlib.compress(raw)

def main():
 release=PUBLIC/VERSION;release.mkdir(parents=True,exist_ok=True)
 files=['TApplication.swf']
 for suffix in ['', '0A','0B','0C','0D','0E','0F']:
  files.append('Resources/Textures/Model/'+f'{int(f"{11120901:X}"+suffix,16):08X}.TexClient')
 for category in ['HeadIcon','SmallIcon','LargeIcon','MiddlePicture']:
  files.append(f'Resources/Textures/{category}/{11120901:08X}.TexClient')
 files.append(f'Resources/Textures/Inventory/{14130901:08X}.TexClient')
 for ident in range(13621901,13621908):files.append(f'Resources/Textures/Skill/{ident:08X}.TexClient')
 # Publish the current canonical databases so the release includes the latest
 # clone profile and skill metadata instead of inheriting an older snapshot.
 for mode in ['combine','normal']:
  for name in ['01000005.bin','0F000000.binPackage']:
   rel=f'Resources/Bin/{mode}/{name}';src=CANON/rel
   if src.exists():
    dst=release/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst);files.append(rel)
 for rel in files:
  if rel.startswith('Resources/Bin/'):continue
  src=CANON/rel;dst=release/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
 manifest=CANON/'version.swf';rows=decode(manifest.read_bytes());replacements={f.encode():VERSION.encode() for f in files};keys={k for k,_ in rows}
 rows=[(k,replacements.get(k,v)) for k,v in rows]+[(k,v) for k,v in replacements.items() if k not in keys]
 backup=BASE/'backups/kaynak/login.gogames.me/public/2026090619/version.swf';backup.parent.mkdir(parents=True,exist_ok=True)
 if not backup.exists():shutil.copy2(manifest,backup)
 manifest.write_bytes(encode(rows))
 result={'version':VERSION,'files':[{'path':f,'sha256':hashlib.sha256((release/f).read_bytes()).hexdigest()} for f in files]}
 (BASE/'release.json').write_text(json.dumps(result,indent=2)+'\n')
 print('PASS incremental release',VERSION,'with',len(files),'cache-busted application/data/model/icon routes')

if __name__=='__main__':main()
