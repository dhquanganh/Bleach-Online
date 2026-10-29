"""Publish Hashirama facing and twenty-hit timing without changing base stats."""
from pathlib import Path
import importlib.util,json,struct,zlib,shutil
ROOT=Path(__file__).resolve().parents[2];B=ROOT/'cikarim/asura-tags';B.mkdir(exist_ok=True)
def load(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
f=load('final',ROOT/'cikarim/asura-guardian/build.py');n=f.n
r=load('manifest',ROOT/'cikarim/kakuzu-edo/release.py');VERSION='2026102903'
def main():
 P=n.PUBLIC;canonical=P/'2026090619';assert json.loads((P/'client-release.json').read_text())['version']=='2026102902'
 replacements={k:[] for k in ['BaseHero','RoleModel','HeroTalent','SkillConfig']}
 heroPath=n.DATA/'BaseHero.json';heroes=json.loads(heroPath.read_text(encoding='utf-8'));hero=next(row for row in heroes if int(row['id'],16)==11121008)
 hero['tags']=[27,52,13,14,49,56,58];replacements['BaseHero']=[hero]
 for kind in ['BaseHero']:
  path=n.DATA/(kind+'.json');data=json.loads(path.read_text(encoding='utf-8'));ids={x['id']:x for x in replacements[kind]}
  backup=B/'backup'/path.name;backup.parent.mkdir(exist_ok=True)
  shutil.copy2(path,backup);path.write_text(json.dumps([ids.get(x['id'],x) for x in data],ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 def patch(raw):
  return n.patch(raw,replacements) if struct.unpack_from('<I',raw)[0] in [0x1000005] else raw
 def update(path):
  data=path.read_bytes()
  if path.suffix=='.bin':
   raw=zlib.decompress(data);new=patch(raw);return data if raw==new else zlib.compress(new)
  pos=6;out=data[:6]
  for _ in range(struct.unpack_from('<H',data,4)[0]):
   size=struct.unpack_from('<I',data,pos)[0];pos+=4;chunk=data[pos:pos+size];pos+=size;raw=zlib.decompress(chunk);new=patch(raw)
   if raw!=new:chunk=zlib.compress(new)
   out+=struct.pack('<I',len(chunk))+chunk
  return out+data[pos:]
 entries=r.rows((canonical/'version.swf').read_bytes());dest=P/VERSION;assert not dest.exists() or not any(dest.iterdir());dest.mkdir(exist_ok=True);changed=[]
 for entry in entries:
  key,ver=[v.decode() for v in entry]
  if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
  source=P/ver/key;out=update(source)
  if out==source.read_bytes():continue
  backup=B/'backup'/key;backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,backup)
  for base in [dest,canonical]:
   path=base/key;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(out)
  entry[1]=VERSION.encode();changed.append(key)
 # Tags are stored in client tag maps; BaseHero serialization has no tags field.
 for name in ['version.swf','TApplication.swf']:shutil.copy2(canonical/name,B/'backup'/name)
 shutil.copy2(P/'client-release.json',B/'backup/client-release.json')
 client=nativeClient=(B/'compiled.swf').read_bytes()
 shared=load('shared',ROOT/'cikarim/tsunade-asian/build-client.py')
 assert shared.h.swap((canonical/'TApplication.swf').read_bytes())==(B/'source.swf').read_bytes()
 for entry in entries:
  if entry[0]==b'TApplication.swf':entry[1]=VERSION.encode()
 for base in [canonical,dest]:
  (base/'version.swf').write_bytes(r.encode(entries))
  (base/'TApplication.swf').write_bytes(shared.h.swap(client))
 shutil.copy2(canonical/'index.swf',dest/'index.swf')
 shutil.copy2(B/'tags.json',P/'character-tags/heroes.json')
 shutil.copy2(B/'tags.json',ROOT/'cikarim/asura-guardian/tags.json')
 shutil.copy2(ROOT.parent/'asset/All_Character_Tag_Assets/assets/user/ninja/propertyIcon/56.png',P/'character-tags/56.png')
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 report={'version':VERSION,'tables':len(changed),'animationUnchanged':(dest/'TApplication.swf').read_bytes()==(B/'backup/TApplication.swf').read_bytes()}
 (B/'result.json').write_text(json.dumps(report,indent=2)+'\n');print('PASS',report)
if __name__=='__main__':main()
