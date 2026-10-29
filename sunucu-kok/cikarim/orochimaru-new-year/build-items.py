"""Madara Modify Fragment + one-use recruit token; no admin overlay offer."""
from pathlib import Path
from PIL import Image,ImageOps
import importlib.util,json,copy,struct,zlib,shutil
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('fragments',B.parent/'ninja-fragments/build.py');f=importlib.util.module_from_spec(s);s.loader.exec_module(f)
H=11121009;FRAGMENT=14131009;TOKEN=14141009;ICON=FRAGMENT+0x200000

def main():
 articles=json.loads((f.native.DATA/'Article.json').read_text(encoding='utf-8'));attrs=json.loads((f.native.DATA/'HeroChangeAttr.json').read_text(encoding='utf-8'))
 fragment=copy.deepcopy(next(r for r in articles if int(r['id'],16)==14130997))
 fragment.update(id=f'{FRAGMENT:08X}',name='Orochimaru [New Year] Modify Fragment',sort=FRAGMENT,picture=ICON,functionDesc='<p>Orochimaru [New Year] Modify Fragment. Used for star upgrades and reincarnation.</p>')
 token=copy.deepcopy(next(r for r in articles if int(r['id'],16)==14140997))
 token.update(id=f'{TOKEN:08X}',name='Orochimaru [New Year] Recruit Token',sort=TOKEN,picture=ICON,f16=H,functionDesc='<p>Use to recruit Orochimaru [New Year]. Not consumed if already owned.</p>')
 attr=copy.deepcopy(next(r for r in attrs if int(r['id'],16)==11120997));attr.update(id=f'{H:08X}',chipValue=FRAGMENT)
 replacements={2:{FRAGMENT:f.serialize(2,fragment),TOKEN:f.serialize(2,token)},0xCC:{H:f.serialize(0xCC,attr)}}
 def patch(raw):
  kind=struct.unpack_from('<I',raw)[0]-0x1000000
  if kind not in replacements:return raw
  old=f.records(raw,kind);rep=replacements[kind];existing=dict(old)
  pairs=[(i,rep.get(i,b)) for i,b in old]+[(i,b) for i,b in rep.items() if i not in existing]
  updated=raw[:4]+f.u32(len(pairs))+b''.join(b for i,b in pairs)
  check=dict(f.records(updated,kind));assert all(check[i]==b for i,b in old if i not in rep)
  return updated
 changes={}
 for path in f.native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file() or path.suffix not in ('.bin','.binPackage'):continue
  data=path.read_bytes()
  if path.suffix=='.bin':
   raw=zlib.decompress(data);out=patch(raw)
   if out!=raw:changes[path]=zlib.compress(out)
  else:
   pos=6;parts=[data[:6]];changed=False
   for _ in range(struct.unpack_from('<H',data,4)[0]):
    size=struct.unpack_from('<I',data,pos)[0];pos+=4;chunk=data[pos:pos+size];pos+=size;raw=zlib.decompress(chunk);out=patch(raw)
    if raw!=out:chunk=zlib.compress(out);changed=True
    parts.extend([f.u32(len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+data[pos:]
 for name,old,extra in [('Article',articles,[fragment,token]),('HeroChangeAttr',attrs,[attr])]:
  ids={r['id'] for r in extra};changes[f.native.DATA/(name+'.json')]=(json.dumps([r for r in old if r['id'] not in ids]+extra,ensure_ascii=False,indent=2)+'\n').encode()
 icon=ImageOps.fit(Image.open(B.parents[2]/'asset/Orochimaru_New_Year_Full/assets/battle/role/head_45_45/11002191.png').convert('RGBA'),(40,40),Image.Resampling.LANCZOS)
 for version in ['2017112917','2026090619']:changes[f.native.PUBLIC/version/'Resources/Textures/Article'/f'{ICON:08X}.TexClient']=f.inventory_texture(ICON,icon)
 path=f.ROOT/'sunucu/naruto-recruit-items.json';catalog=json.loads(path.read_text(encoding='utf-8'));catalog=[r for r in catalog if r['heroId']!=H]+[{'heroId':H,'itemId':TOKEN,'fragmentId':FRAGMENT,'picture':ICON,'name':token['name']}];changes[path]=(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n').encode()
 for path,data in changes.items():
  backup=B/'item-backup'/path.relative_to(f.ROOT)
  if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
  path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 print('PASS Infinite items',FRAGMENT,TOKEN,len(changes))
if __name__=='__main__':main()
