from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('capture',B/'capture.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c;P=c.h.PUBLIC
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
VERSION='2026102906'
def main():
 probe=json.loads((B/'validation/native/result.json').read_text());assert probe['completed'] and probe['cases']==6 and not probe['errors'] and not probe['accountAccess']
 validation=json.loads((B/'client-validation.json').read_text());assert validation['unchangedAssets'];canonical=P/'2026090619';assert json.loads((P/'client-release.json').read_text())['version']=='2026102905'
 original=(canonical/'TApplication.swf').read_bytes();assert c.h.swap(original)==(B/'source.swf').read_bytes()
 backup=B/'release-backup';backup.mkdir(exist_ok=True)
 for name in ['TApplication.swf','version.swf','index.swf']:shutil.copy2(canonical/name,backup/name)
 shutil.copy2(P/'client-release.json',backup/'client-release.json')
 entries=r.rows((canonical/'version.swf').read_bytes());changed=0
 for entry in entries:
  if entry[0]==b'TApplication.swf':entry[1]=VERSION.encode();changed+=1
 assert changed==1
 dest=P/VERSION;assert not dest.exists();dest.mkdir();data=r.encode(entries);client=c.h.swap((B/'compiled.swf').read_bytes())
 for folder in [canonical,dest]:(folder/'TApplication.swf').write_bytes(client);(folder/'version.swf').write_bytes(data)
 shutil.copy2(canonical/'index.swf',dest/'index.swf');(P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 report={'version':VERSION,'sha256':hashlib.sha256(client).hexdigest(),'probe':probe,'validation':validation,'changedManifestEntries':changed};(B/'release.json').write_text(json.dumps(report,indent=2)+'\n');print('PASS Tournament of Throne release',VERSION)
if __name__=='__main__':main()
