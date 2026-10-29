"""Publish Madara at fresh URLs without rebuilding any existing animation."""
from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py');build=importlib.util.module_from_spec(s);s.loader.exec_module(build);c=build.c;P=c.h.PUBLIC
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');manifest=importlib.util.module_from_spec(s);s.loader.exec_module(manifest)
VERSION='2026102904'

def main():
 probe=json.loads((B/'validation/native/result.json').read_text())
 assert probe['completed'] and probe['cases']==22 and not probe['errors'] and probe['remainingLayers']==0,probe
 validation=json.loads((B/'client-validation.json').read_text());assert validation['unchangedMethods']['TRole']>=252
 canonical=P/'2026090619';active=json.loads((P/'client-release.json').read_text())['version']
 assert active=='2026102903'
 original=(canonical/'TApplication.swf').read_bytes();assert c.h.swap(original)==(B/'source.swf').read_bytes()
 dest=P/VERSION;assert not dest.exists();dest.mkdir()
 backup=B/'release-backup';backup.mkdir(exist_ok=True)
 for name in ['version.swf','TApplication.swf','index.swf']:shutil.copy2(canonical/name,backup/name)
 shutil.copy2(P/'client-release.json',backup/'client-release.json')
 rows=manifest.rows((canonical/'version.swf').read_bytes());changed=[]
 for row in rows:
  key,version=[v.decode() for v in row]
  if key.startswith('Resources/Bin/') and key.endswith(('.bin','.binPackage')):
   source=next((p for p in [P/version/key,canonical/key,P/'2017112917'/key] if p.is_file()),None)
   if source:
    target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target);row[1]=VERSION.encode();changed.append(key)
  if key=='TApplication.swf':row[1]=VERSION.encode()
 # Preserve translated fallback tables under the new version, too.
 for source in (canonical/'Resources/Bin').rglob('*'):
  if source.is_file() and source.suffix in ('.bin','.binPackage'):
   target=dest/source.relative_to(canonical)
   if not target.exists():target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target)
 metadata={r[0].decode():r for r in rows};ids=[11121009,14131009+0x200000]+list(range(13122601,13122612))+[13623601]
 textures=0
 for source in (canonical/'Resources/Textures').glob('*/*.TexClient'):
  if int(source.stem,16) not in ids and not source.stem.startswith(f'{11121009:X}'):continue
  key=source.relative_to(canonical).as_posix();target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target);textures+=1
  if key in metadata:metadata[key][1]=VERSION.encode()
  else:rows.append([key.encode(),VERSION.encode()])
 data=manifest.encode(rows);client=c.h.swap((B/'compiled.swf').read_bytes())
 for base in [dest,canonical]:(base/'version.swf').write_bytes(data);(base/'TApplication.swf').write_bytes(client)
 shutil.copy2(canonical/'index.swf',dest/'index.swf');shutil.copy2(B/'tags.json',P/'character-tags/heroes.json')
 shutil.copy2(B.parents[2]/'asset/All_Character_Tag_Assets/assets/user/ninja/propertyIcon/15.png',P/'character-tags/15.png')
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 report={'version':VERSION,'heroId':11121009,'fragmentId':14131009,'recruitItemId':14141009,'textures':textures,'tables':changed,'clientSha256':hashlib.sha256(client).hexdigest(),'probe':probe,'unchangedMethods':validation['unchangedMethods']}
 (B/'release.json').write_text(json.dumps(report,indent=2)+'\n')
 print('PASS release',VERSION,textures,'textures;',len(changed),'tables')
if __name__=='__main__':main()
