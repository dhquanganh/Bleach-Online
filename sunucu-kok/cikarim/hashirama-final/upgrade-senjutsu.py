"""Update Senjutsu healing descriptions in native databases without rebuilding art."""
from pathlib import Path
import importlib.util,json,struct,sys,zlib
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native',BASE.parent/'naruto-sage/build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
def main():
 cfg=json.loads((BASE.parents[1]/'sunucu/hashirama-final.json').read_text());percent=round(cfg['senjutsuHealRatio']*100)
 rows={k:[] for k in ['BaseHero','HeroTalent','RoleModel','SkillConfig']};changes={}
 for kind,ident,field in [('BaseHero',cfg['heroId'],'desc'),('HeroTalent',13220940,'talentDesc')]:
  path=native.DATA/(kind+'.json');data=json.loads(path.read_text(encoding='utf-8'))
  row=next(r for r in data if int(r['id'],16)==ident)
  row[field]=row[field].replace('heal 5% max HP',f'heal {percent}% max HP')
  assert f'heal {percent}% max HP' in row[field]
  rows[kind].append(row);changes[path]=(json.dumps(data,ensure_ascii=False,indent=2)+'\n').encode()
 for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file() or path.suffix not in ['.bin','.binPackage']:continue
  b=path.read_bytes()
  if path.suffix=='.bin':
   if path.stem.upper() not in ['01000005','0100001F']:continue
   raw=zlib.decompress(b);new=native.patch(raw,rows)
   if new!=raw:changes[path]=zlib.compress(new)
  else:
   pos=6;parts=[b[:6]];changed=False
   for _ in range(struct.unpack_from('<H',b,4)[0]):
    n=struct.unpack_from('<I',b,pos)[0];pos+=4;c=b[pos:pos+n];pos+=n
    raw=zlib.decompress(c);new=native.patch(raw,rows)
    if new!=raw:c=zlib.compress(new);changed=True
    parts.extend([native.u32(len(c)),c])
   if changed:changes[path]=b''.join(parts)+b[pos:]
 updated=0
 for path,content in changes.items():
  if path.read_bytes()!=content:path.write_bytes(content);updated+=1
 print('PASS Senjutsu healing',percent,'% max HP;',updated,'databases updated; all unrelated records preserved')
if __name__=='__main__':main()
