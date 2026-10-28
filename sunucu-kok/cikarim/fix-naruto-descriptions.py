"""Repair Naruto plain-text tooltips; preserve every unrelated table record."""
from pathlib import Path
import importlib.util,json,struct,zlib,shutil,sys
ROOT=Path(__file__).resolve().parents[1];B=ROOT/'cikarim/naruto-description-repair';B.mkdir(exist_ok=True)
sys.path.insert(0,str(ROOT/'cikarim/naruto-sage'))
s=importlib.util.spec_from_file_location('native',ROOT/'cikarim/naruto-sage/build.py');n=importlib.util.module_from_spec(s);s.loader.exec_module(n)
s=importlib.util.spec_from_file_location('manifest',ROOT/'cikarim/kakuzu-edo/release.py');manifest=importlib.util.module_from_spec(s);s.loader.exec_module(manifest)
VERSION='2026102803'

def main():
 P=n.PUBLIC;canonical=P/'2026090619';active=json.loads((P/'client-release.json').read_text())['version'];assert active=='2026102802'
 heroes=json.loads((n.DATA/'BaseHero.json').read_text(encoding='utf-8'));talents=set();skills=set()
 for h in heroes:
  if not 11120900<=int(h['id'],16)<11122000:continue
  talents.add(h['talent']);skills.update(map(int,json.loads(h['attackEffect']).keys()));skills.update([h['active'],h['normalAttack']])
 rows={k:[] for k in ['BaseHero','RoleModel','HeroTalent','SkillConfig']};json_changes={};counts={}
 for kind,ids,field in [('HeroTalent',talents,'talentDesc'),('SkillConfig',skills,'desc')]:
  path=n.DATA/(kind+'.json');data=json.loads(path.read_text(encoding='utf-8'));count=0
  for row in data:
   if int(row['id'],16) not in ids:continue
   clean=n.plain_description(row[field])
   if clean!=row[field]:row[field]=clean;rows[kind].append(row);count+=1
  json_changes[path]=data;counts[kind]=count
 assert counts['HeroTalent'] and counts['SkillConfig']
 def patch(raw):
  if struct.unpack_from('<I',raw)[0] not in [0x100001f,0x100003f]:return raw
  return n.patch(raw,rows)
 def file_patch(path):
  data=path.read_bytes()
  if path.suffix=='.bin':
   raw=zlib.decompress(data);out=patch(raw);return data if out==raw else zlib.compress(out)
  pos=6;out=data[:6]
  for _ in range(struct.unpack_from('<H',data,4)[0]):
   size=struct.unpack_from('<I',data,pos)[0];pos+=4;chunk=data[pos:pos+size];pos+=size;raw=zlib.decompress(chunk);updated=patch(raw)
   if updated!=raw:chunk=zlib.compress(updated)
   out+=struct.pack('<I',len(chunk))+chunk
  return out+data[pos:]
 entries=manifest.rows((canonical/'version.swf').read_bytes());changes={}
 for row in entries:
  key,version=[f.decode() for f in row]
  if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
  source=next((p for p in [P/version/key,canonical/key] if p.is_file()),None)
  if source is None:continue
  out=file_patch(source)
  if out!=source.read_bytes():changes[key]=(source,out);row[1]=VERSION.encode()
 assert changes
 dest=P/VERSION;assert not dest.exists();dest.mkdir();backup=B/'backup';backup.mkdir(exist_ok=True)
 for key,(source,out) in changes.items():
  saved=backup/key;saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,saved)
  for base in [dest,canonical]:
   target=base/key;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(out)
 for path,data in json_changes.items():
  shutil.copy2(path,backup/path.name);path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 # Keep server character descriptions consistent with the published tooltip text.
 for name in ['madara-final.json','tobi-war.json','kakuzu-edo.json']:
  path=ROOT/'sunucu'/name;data=json.loads(path.read_text(encoding='utf-8'))
  def clean(value):
   if isinstance(value,dict):return {k:n.plain_description(v) if k in ['description','desc','talentDesc'] and isinstance(v,str) else clean(v) for k,v in value.items()}
   if isinstance(value,list):return [clean(v) for v in value]
   return value
  shutil.copy2(path,backup/name);path.write_text(json.dumps(clean(data),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 for name in ['version.swf','TApplication.swf']:shutil.copy2(canonical/name,backup/name)
 shutil.copy2(P/'client-release.json',backup/'client-release.json')
 packed=manifest.encode(entries)
 for base in [dest,canonical]:(base/'version.swf').write_bytes(packed)
 for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,dest/name)
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 report={'version':VERSION,'counts':counts,'tables':list(changes),'clientAnimationUnchanged':(dest/'TApplication.swf').read_bytes()==(backup/'TApplication.swf').read_bytes()}
 (B/'result.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
