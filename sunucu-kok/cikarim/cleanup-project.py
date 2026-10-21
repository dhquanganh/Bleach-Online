"""Remove reproducible preview/export caches; never traverse junctions.

Default is a dry run. --apply deletes only the exact files recorded in the plan.
Runtime resources, source assets, frames needed by builders, backups and Git stay.
"""
from pathlib import Path
import argparse,collections,datetime,hashlib,json,os,stat

ROOT=Path(__file__).resolve().parents[2]
BUILD=ROOT/'sunucu-kok/cikarim'
EXPORTS={'native-export','camera-export','effect-inspect','native-effects'}
MEDIA={'.png','.jpg','.jpeg','.gif','.mp4','.webm','.log'}

def walk(root):
 for base,dirs,files in os.walk(root,followlinks=False):
  dirs[:]=[d for d in dirs if not os.lstat(Path(base)/d).st_file_attributes & stat.FILE_ATTRIBUTE_REPARSE_POINT]
  for name in files:
   p=Path(base)/name
   if not p.is_symlink():yield p

def protected_digest():
 roots=[ROOT/'asset',ROOT/'sunucu-kok/kaynak',ROOT/'sunucu-kok/sunucu',BUILD/'veri-json',BUILD/'veri-json-yedek']
 result={}
 for root in roots:
  for p in walk(root):
   if '__pycache__' in p.parts:continue
   # Database can change while a running server writes it. Never delete it;
   # compare static resources separately instead of blocking legitimate writes.
   if p.suffix in {'.db','.db-wal','.db-shm'}:continue
   result[str(p.relative_to(ROOT))]=hashlib.sha256(p.read_bytes()).hexdigest()
 return result

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--apply',action='store_true');args=ap.parse_args()
 targets=[];groups=collections.Counter()
 for p in walk(BUILD):
  parts=p.relative_to(BUILD).parts;category=None
  if '__pycache__' in parts:category='python-cache'
  elif 'backups' not in parts:
   if any(name in parts for name in EXPORTS):category='reproducible-exports'
   elif 'validation' in parts and p.suffix.lower() in MEDIA:category='preview-media'
  if category:
   resolved=p.resolve();assert resolved.is_relative_to(BUILD.resolve())
   size=p.stat().st_size;targets.append({'path':str(p.relative_to(ROOT)),'bytes':size,'category':category});groups[category]+=size
 report={'date':datetime.datetime.now().isoformat(),'applied':False,'bytes':sum(t['bytes'] for t in targets),'groups':dict(groups),'files':targets}
 output=BUILD/'cleanup-report.json';output.write_text(json.dumps(report,indent=2),encoding='utf8')
 print(json.dumps({'files':len(targets),'bytes':report['bytes'],'groups':dict(groups),'apply':args.apply}))
 if not args.apply:return
 before=protected_digest()
 for item in targets:
  p=ROOT/item['path'];assert p.resolve().is_relative_to(BUILD.resolve());p.unlink()
 # Empty directories are harmless and are retained to preserve script expectations.
 after=protected_digest();assert before==after,'Protected runtime/source files changed during cleanup'
 report['applied']=True;report['protectedFilesVerified']=len(before)
 output.write_text(json.dumps(report,indent=2),encoding='utf8')
 print('PASS deleted planned caches only; protected runtime/source hashes unchanged:',len(before))

if __name__=='__main__':main()
