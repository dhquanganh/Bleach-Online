"""Publish updated Madara descriptions without rebuilding animations."""
from pathlib import Path
import importlib.util,json,struct,zlib,shutil
ROOT=Path(__file__).resolve().parents[1];B=ROOT/'cikarim/naruto-restoration-update';B.mkdir(exist_ok=True)
def load(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
f=load('final',ROOT/'cikarim/naruto-final/build.py');n=f.n
r=load('manifest',ROOT/'cikarim/kakuzu-edo/release.py');VERSION='2026102811'
def main():
 P=n.PUBLIC;canonical=P/'2026090619';assert json.loads((P/'client-release.json').read_text())['version']=='2026102810'
 replacements={k:[] for k in ['BaseHero','RoleModel','HeroTalent','SkillConfig']}
 for builder in [f]:
  rows=builder.rows()
  for kind,field in [('HeroTalent','talentDesc'),('SkillConfig','desc')]:
   for row in rows[kind]:row[field]=n.plain_description(row[field])
   replacements[kind]+=rows[kind]
 for kind in ['HeroTalent','SkillConfig']:
  path=n.DATA/(kind+'.json');data=json.loads(path.read_text(encoding='utf-8'));ids={x['id']:x for x in replacements[kind]}
  backup=B/'backup'/path.name;backup.parent.mkdir(exist_ok=True)
  shutil.copy2(path,backup);path.write_text(json.dumps([ids.get(x['id'],x) for x in data],ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 def patch(raw):
  return n.patch(raw,replacements) if struct.unpack_from('<I',raw)[0] in [0x100001f,0x100003f] else raw
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
 entries=r.rows((canonical/'version.swf').read_bytes());dest=P/VERSION;assert not dest.exists();dest.mkdir();changed=[]
 for entry in entries:
  key,ver=[v.decode() for v in entry]
  if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
  source=P/ver/key;out=update(source)
  if out==source.read_bytes():continue
  backup=B/'backup'/key;backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,backup)
  for base in [dest,canonical]:
   path=base/key;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(out)
  entry[1]=VERSION.encode();changed.append(key)
 assert changed
 for name in ['version.swf','TApplication.swf']:shutil.copy2(canonical/name,B/'backup'/name)
 shutil.copy2(P/'client-release.json',B/'backup/client-release.json')
 for base in [canonical,dest]:(base/'version.swf').write_bytes(r.encode(entries))
 for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,dest/name)
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 report={'version':VERSION,'tables':len(changed),'animationUnchanged':(dest/'TApplication.swf').read_bytes()==(B/'backup/TApplication.swf').read_bytes()}
 (B/'result.json').write_text(json.dumps(report,indent=2)+'\n');print('PASS',report)
if __name__=='__main__':main()
