"""Delete the two kits from JSON, native tables and texture/version indexes."""
from pathlib import Path
import importlib.util,json,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];PUBLIC=ROOT/'kaynak/login.gogames.me/public';DATA=ROOT/'cikarim/veri-json'
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
native=load('table_codec',BASE.parent/'naruto-sage/build.py')
fragment=load('inventory_codec',BASE.parent/'shared-animation/inventory-tables.py')
heroes=set(range(11120910,11120915))|set(range(11120980,11120985))
skills=set(range(13120931,13120943))|set(range(13121401,13121413))
talents=set(range(13220910,13220915))|set(range(13220980,13220985))
items={14130910,14130980};offers={41120910,41120980};effects={13621931,13622401}
own=heroes|skills|talents|items|offers|effects
textures=heroes|skills|items|{i+0x200000 for i in items}|effects
textures|={int(f'{hero:X}'+suffix,16) for hero in heroes for suffix in ['0a','0b','0c','0d','0e','0f']}
report={'jsonRows':0,'binaryRows':0,'binaryFiles':0,'textures':[]}
def ident(v):
    try:return int(v,16) if isinstance(v,str) else int(v)
    except (TypeError,ValueError):return -1
def unwanted(row):
    if not isinstance(row,dict):return False
    if ident(row.get('id')) in own:return True
    if any(row.get(k) in own for k in ['heroId','heroID','awardId','itemID','chipValue'] if isinstance(row.get(k),(int,float))):return True
    return any('kabuto' in str(row.get(k,'')).lower() for k in ['name','talentName'])
for file in DATA.glob('*.json'):
    rows=json.loads(file.read_text(encoding='utf-8'))
    if not isinstance(rows,list):continue
    new=[r for r in rows if not unwanted(r)]
    if new!=rows:report['jsonRows']+=len(rows)-len(new);file.write_text(json.dumps(new,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def patch(raw):
    if len(raw)<8:return raw
    kind=struct.unpack_from('<I',raw)[0]-0x1000000
    name={5:'BaseHero',0x1f:'HeroTalent',0x38:'RoleModel',0x3f:'SkillConfig'}.get(kind)
    if name:rows=native.records(raw,name)
    elif kind in (2,0xCC,0xCB):rows=fragment.records(raw,kind)
    else:return raw
    new=[(i,b) for i,b in rows if i not in own]
    if len(new)==len(rows):return raw
    report['binaryRows']+=len(rows)-len(new)
    return raw[:4]+struct.pack('<I',len(new))+b''.join(b for i,b in new)

# Include pipeline snapshots so a future rebuild cannot restore removed rows.
for file in ROOT.rglob('*'):
    if not file.is_file() or file.suffix not in ('.bin','.binPackage'):continue
    if file.suffix=='.bin':
        try:raw=zlib.decompress(file.read_bytes())
        except zlib.error:continue
        new=patch(raw)
        if new!=raw:file.write_bytes(zlib.compress(new));report['binaryFiles']+=1
    else:
        data=file.read_bytes()
        if len(data)<6:continue
        try:
            pos=6;parts=[data[:6]];changed=False
            for _ in range(struct.unpack_from('<H',data,4)[0]):
                n=struct.unpack_from('<I',data,pos)[0];pos+=4;compressed=data[pos:pos+n];pos+=n
                raw=zlib.decompress(compressed);new=patch(raw)
                if new!=raw:compressed=zlib.compress(new);changed=True
                parts.extend([struct.pack('<I',len(compressed)),compressed])
            if changed:file.write_bytes(b''.join(parts)+data[pos:]);report['binaryFiles']+=1
        except (zlib.error,struct.error):continue
    
for file in ROOT.rglob('*.TexClient'):
    try:i=int(file.stem,16)
    except ValueError:continue
    if i in textures:report['textures'].append(str(file.resolve()))

# Keep the deletion list reviewable; actual filesystem deletion uses PowerShell.
(BASE/'texture-deletions.json').write_text(json.dumps(report['textures'],indent=2))
for file in PUBLIC.glob('*/version.swf'):
    try:raw=zlib.decompress(file.read_bytes());pos=2;rows=[]
    except zlib.error:continue
    for _ in range(struct.unpack_from('<H',raw)[0]):
        n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
        try:remove=int(Path(key.decode()).stem,16) in textures
        except ValueError:remove=False
        if not remove:rows.append((key,v))
    assert pos==len(raw)
    encoded=struct.pack('<H',len(rows))+b''.join(struct.pack('<H',len(k))+k+struct.pack('<H',len(v))+v for k,v in rows)
    if encoded!=raw:file.write_bytes(zlib.compress(encoded))
(BASE/'data-report.json').write_text(json.dumps(report,indent=2))
print('PASS removed',report['jsonRows'],'JSON rows and',report['binaryRows'],'native rows in',report['binaryFiles'],'files;',len(report['textures']),'owned textures queued')
