from pathlib import Path
import importlib.util,json,shutil,hashlib,struct,zlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('build',B/'build-client.py');b=importlib.util.module_from_spec(s);s.loader.exec_module(b);c=b.c
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
P=c.h.PUBLIC;C=P/'2026090619';VERSION='2026110103'
def main():
 probe=json.loads((B/'validation/native/result.json').read_text());assert probe['completed'] and probe['cases']==8 and not probe['errors'] and probe['remainingLayers']==0
 checked=json.loads((B/'client-validation.json').read_text());assert checked['unchangedMethods']['TRole']>=280
 assert json.loads((P/'client-release.json').read_text())['version']=='2026110102'
 assert c.h.swap((C/'TApplication.swf').read_bytes())==(B/'source.swf').read_bytes()
 dest=P/VERSION;assert not dest.exists();dest.mkdir();backup=B/'release-backup';backup.mkdir(exist_ok=True)
 for name in ['TApplication.swf','version.swf','index.swf']:shutil.copy2(C/name,backup/name)
 shutil.copy2(P/'client-release.json',backup/'client-release.json')
 rows=m.rows((C/'version.swf').read_bytes());tables=0
 for row in rows:
  key,ver=[x.decode() for x in row]
  if key.startswith('Resources/Bin/') and key.endswith(('.bin','.binPackage')):
   src=next((p for p in [C/key,P/ver/key,P/'2017112917'/key] if p.is_file()),None)
   if src:
    target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target);row[1]=VERSION.encode();tables+=1
  if key=='TApplication.swf':row[1]=VERSION.encode()
 for src in (C/'Resources/Bin').rglob('*'):
  if src.is_file() and src.suffix in ('.bin','.binPackage'):
   target=dest/src.relative_to(C)
   if not target.exists():target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target)
 metadata={r[0].decode():r for r in rows};ids=[11121012,16228164,13623901]+list(range(13122901,13122906));textures=0;textureBytes=0
 for src in (C/'Resources/Textures').glob('*/*.TexClient'):
  if int(src.stem,16) not in ids and not src.stem.startswith(f'{11121012:X}'):continue
  key=src.relative_to(C).as_posix();target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target);textures+=1;textureBytes+=src.stat().st_size
  if key in metadata:metadata[key][1]=VERSION.encode()
  else:rows.append([key.encode(),VERSION.encode()])
 client=c.h.swap((B/'compiled.swf').read_bytes());manifest=m.encode(rows)
 for base in [dest,C]:(base/'version.swf').write_bytes(manifest);(base/'TApplication.swf').write_bytes(client)
 shutil.copy2(C/'index.swf',dest/'index.swf');shutil.copy2(B/'tags.json',P/'character-tags/heroes.json')
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 effects=sum(p.stat().st_size for p in (P/'hoichi-vfx/native').glob('*.swf'))
 (B/'release.json').write_text(json.dumps({'version':VERSION,'heroId':11121012,'fragmentId':14131012,'recruitItemId':14141012,'textureCount':textures,'textureBytes':textureBytes,'nativeEffectBytes':effects,'probe':probe,'unchangedMethods':checked['unchangedMethods'],'clientSha256':hashlib.sha256(client).hexdigest(),'tables':tables},indent=2)+'\n')
 print('PASS Hoichi release',VERSION,textures,'textures;',textureBytes+effects,'character asset bytes')
if __name__=='__main__':main()
