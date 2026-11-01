"""Publish Fortune Coin tables/icon at fresh URLs; preserve all native animation code."""
from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
P=B.parents[1]/'kaynak/login.gogames.me/public';VERSION='2026103103'
def main():
 probe=json.loads((B/'validation/native/result.json').read_text());assert probe['completed'] and probe['cases']==1 and not probe['errors'],probe
 assert json.loads((B/'validation/ui/result.json').read_text(encoding='utf-8'))['ok']
 assert json.loads((P/'client-release.json').read_text())['version']=='2026103102'
 canonical=P/'2026090619';client=(canonical/'TApplication.swf').read_bytes()
 assert client==(P/'2026103102/TApplication.swf').read_bytes()
 dest=P/VERSION;assert not dest.exists();dest.mkdir()
 backup=B/'release-backup';backup.mkdir(exist_ok=True)
 for name in ['version.swf','TApplication.swf','index.swf']:shutil.copy2(canonical/name,backup/name)
 shutil.copy2(P/'client-release.json',backup/'client-release.json')
 rows=m.rows((canonical/'version.swf').read_bytes());changed=[]
 for row in rows:
  key,version=[v.decode() for v in row]
  if key.startswith('Resources/Bin/') and key.endswith(('.bin','.binPackage')):
   source=next((p for p in [P/version/key,canonical/key,P/'2017112917'/key] if p.is_file()),None)
   if source:
    target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target);row[1]=VERSION.encode();changed.append(key)
  if key=='TApplication.swf':row[1]=VERSION.encode()
 for source in (canonical/'Resources/Bin').rglob('*'):
  if source.is_file() and source.suffix in ('.bin','.binPackage'):
   target=dest/source.relative_to(canonical)
   if not target.exists():target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target)
 key='Resources/Textures/Inventory/00E35B22.TexClient';target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(canonical/key,target)
 row=next((r for r in rows if r[0].decode()==key),None)
 if row:row[1]=VERSION.encode()
 else:rows.append([key.encode(),VERSION.encode()])
 data=m.encode(rows)
 for base in [canonical,dest]:(base/'version.swf').write_bytes(data)
 (dest/'TApplication.swf').write_bytes(client);shutil.copy2(canonical/'index.swf',dest/'index.swf')
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 assert (canonical/'TApplication.swf').read_bytes()==client
 (B/'release.json').write_text(json.dumps({'version':VERSION,'coinId':14900002,'tables':changed,'clientSha256':hashlib.sha256(client).hexdigest(),'nativeCodeUnchanged':True,'probe':probe},indent=2)+'\n')
 print('PASS Fortune Store release',VERSION,len(changed),'tables; native animation code unchanged')
if __name__=='__main__':main()
