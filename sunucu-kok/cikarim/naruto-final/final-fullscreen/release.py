from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('build',B/'build.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c;P=c.h.PUBLIC
s=importlib.util.spec_from_file_location('manifest',B.parent.parent/'kakuzu-edo/release.py');manifest=importlib.util.module_from_spec(s);s.loader.exec_module(manifest)
VERSION='2026102810'
def main():
 result=json.loads((B/'validation/native/result.json').read_text());assert result['completed'] and result['cases']==2 and not result['errors'] and result['remainingLayers']==0,result
 validation=json.loads((B/'validation.json').read_text());assert validation['unchangedMethods']>=250
 canonical=P/'2026090619';assert json.loads((P/'client-release.json').read_text())['version']=='2026102809'
 assert c.h.swap((canonical/'TApplication.swf').read_bytes())==(B/'source.swf').read_bytes()
 backup=B/'release-backup';backup.mkdir(exist_ok=True)
 for name in ['TApplication.swf','version.swf']:shutil.copy2(canonical/name,backup/name)
 shutil.copy2(P/'client-release.json',backup/'client-release.json')
 rows=manifest.rows((canonical/'version.swf').read_bytes());changed=0
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode();changed+=1
 assert changed==1
 client=c.h.swap((B/'compiled.swf').read_bytes());packed=manifest.encode(rows);dest=P/VERSION;assert not dest.exists();dest.mkdir()
 for folder in [canonical,dest]:(folder/'TApplication.swf').write_bytes(client);(folder/'version.swf').write_bytes(packed)
 shutil.copy2(canonical/'index.swf',dest/'index.swf');(P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 (B/'release.json').write_text(json.dumps({'version':VERSION,'sha256':hashlib.sha256(client).hexdigest(),'probe':result,**validation},indent=2)+'\n')
 print('PASS Naruto final fullscreen release',VERSION)
if __name__=='__main__':main()
