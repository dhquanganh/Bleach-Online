"""Publish new native resources at fresh URLs while preserving every other map entry."""
from pathlib import Path
import hashlib,json,shutil,struct,zlib
B=Path(__file__).resolve().parent
P=B.parents[1]/'kaynak/login.gogames.me/public'
VERSION='2026102419'
def rows(data):
 raw=zlib.decompress(data);p=2;result=[]
 for _ in range(struct.unpack_from('<H',raw)[0]):
  fields=[]
  for _ in range(2):
   n=struct.unpack_from('<H',raw,p)[0];p+=2;fields.append(raw[p:p+n]);p+=n
  result.append(fields)
 assert p==len(raw)
 return result
def encode(items):
 return zlib.compress(struct.pack('<H',len(items))+b''.join(struct.pack('<H',len(f))+f for row in items for f in row))
def main():
 canonical=P/'2026090619';dest=P/VERSION;dest.mkdir(exist_ok=True)
 manifest=rows((canonical/'version.swf').read_bytes());changed=[]
 backup=B/'release-backups';backup.mkdir(exist_ok=True)
 for f in [canonical/'version.swf',P/'client-release.json']:
  if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
 for row in manifest:
  key,version=[f.decode() for f in row]
  if key.startswith('Resources/Bin/') and '/.svn/' not in key and key.endswith(('.bin','.binPackage')):
   choices=[P/version/key,canonical/key,P/'2017112917'/key]
   src=next((p for p in choices if p.is_file()),None)
   if src:
    target=dest/key;target.parent.mkdir(parents=True,exist_ok=True)
    if src.resolve()!=target.resolve():shutil.copy2(src,target)
    row[1]=VERSION.encode();changed.append(key)
  if key=='TApplication.swf':row[1]=VERSION.encode()
 # New IDs do not have old resource-map entries; add the native texture URLs.
 metadata={row[0].decode():row for row in manifest}
 ids=[11120992,11120993,14130992+0x200000]+list(range(13121601,13121610))+[13622601,13622609]
 textures=canonical/'Resources/Textures';count=0
 for src in textures.glob('*/*.TexClient'):
  ident=int(src.stem,16)
  if ident not in ids and not any(src.stem.startswith(f'{i:X}') for i in [11120992,11120993]):continue
  key=src.relative_to(canonical).as_posix();target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target);count+=1
  if key in metadata:metadata[key][1]=VERSION.encode()
  else:manifest.append([key.encode(),VERSION.encode()])
 data=encode(manifest);(canonical/'version.swf').write_bytes(data);(dest/'version.swf').write_bytes(data)
 for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,dest/name)
 assert rows(data)==manifest
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 (B/'release.json').write_text(json.dumps({'version':VERSION,'tables':changed,'nativeTextures':count,'clientSha256':hashlib.sha256((dest/'TApplication.swf').read_bytes()).hexdigest()},indent=2)+'\n')
 print('PASS release',VERSION,len(changed),'native tables;',count,'new native textures')
if __name__=='__main__':main()
