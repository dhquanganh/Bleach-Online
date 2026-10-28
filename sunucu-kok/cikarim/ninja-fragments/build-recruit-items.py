"""Create native Naruto recruit tokens, reusing each Modify Fragment's icon.

Run --apply to update Article JSON and all native Article bin/package copies.
Unrelated native table records are preserved byte for byte.
"""
from pathlib import Path
import argparse,copy,importlib.util,json,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fragments',BASE/'build.py')
f=importlib.util.module_from_spec(spec);spec.loader.exec_module(f)

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    rows=json.loads((f.native.DATA/'Article.json').read_text(encoding='utf-8'))
    heroes=json.loads((f.native.DATA/'BaseHero.json').read_text(encoding='utf-8'))
    attrs=json.loads((f.native.DATA/'HeroChangeAttr.json').read_text(encoding='utf-8'))
    allowed=set(json.loads(subprocess.check_output(['node','-e',"console.log(JSON.stringify(require('./sunucu-kok/sunucu/herolar').gecerliHerolar().map(h=>h.id)))"],cwd=f.ROOT.parent,text=True)))
    template=next(r for r in rows if r['functionValue']==9 and r['majorType']==1)
    articles={int(r['id'],16):r for r in rows};roster={int(r['id'],16):r for r in heroes}
    extras={};catalog=[]
    for association in attrs:
        hero=int(association['id'],16)
        if not 11120900<=hero<11122000 or hero not in allowed:continue
        fragment=articles[int(association['chipValue'])];item=hero+3020000;name=roster[hero]['name']
        row=copy.deepcopy(template)
        row.update(id=f'{item:08X}',name=name+' Recruit Token',level=1,quality=fragment['quality'],sort=item,overlayNumber=999,bindMode=1,obtain=0,
          functionDesc=f'<p>Dùng 1 vật phẩm để nhận nhân vật {name}. Nếu đã sở hữu nhân vật, vật phẩm sẽ không bị tiêu hao.</p>',
          picture=fragment['picture'],sellPrice=0,itemFunction=0,functionValue=9,f16=hero)
        if item in articles:assert articles[item]['functionValue']==9 and articles[item]['f16']==hero,'Item ID collision'
        extras[item]=row;catalog.append({'heroId':hero,'itemId':item,'fragmentId':int(association['chipValue']),'picture':row['picture'],'name':row['name']})
    assert len(catalog)==18,('Review changed Naruto roster before applying',catalog)
    replacement={i:f.serialize(2,r) for i,r in extras.items()}
    def patch(raw):
        if struct.unpack_from('<I',raw)[0]!=0x1000002:return raw
        old=f.records(raw,2);oldmap=dict(old)
        result=[(i,replacement.get(i,data)) for i,data in old]+[(i,data) for i,data in replacement.items() if i not in oldmap]
        updated=raw[:4]+f.u32(len(result))+b''.join(data for i,data in result)
        check=dict(f.records(updated,2));assert all(check[i]==data for i,data in old if i not in replacement)
        assert all(check[i]==data for i,data in replacement.items());return updated
    changes={}
    for path in f.native.PUBLIC.glob('*/Resources/Bin/**/*'):
        if not path.is_file():continue
        data=path.read_bytes()
        if path.suffix=='.bin':
            raw=zlib.decompress(data);updated=patch(raw)
            if updated!=raw:changes[path]=zlib.compress(updated)
        elif path.suffix=='.binPackage':
            pos=6;parts=[data[:6]];changed=False
            for _ in range(struct.unpack_from('<H',data,4)[0]):
                size=struct.unpack_from('<I',data,pos)[0];pos+=4;packed=data[pos:pos+size];pos+=size
                raw=zlib.decompress(packed);updated=patch(raw)
                if updated!=raw:packed=zlib.compress(updated);changed=True
                parts.extend([f.u32(len(packed)),packed])
            if changed:changes[path]=b''.join(parts)+data[pos:]
    merged=[extras.get(int(r['id'],16),r) for r in rows]+[r for i,r in extras.items() if i not in articles]
    changes[f.native.DATA/'Article.json']=(json.dumps(merged,ensure_ascii=False,indent=2)+'\n').encode()
    changes[f.ROOT/'sunucu/naruto-recruit-items.json']=(json.dumps(sorted(catalog,key=lambda r:r['heroId']),ensure_ascii=False,indent=2)+'\n').encode()
    if args.apply:
        for path,data in changes.items():
            if path.exists() and path.read_bytes()==data:continue
            backup=BASE/'backups/recruit-items'/path.relative_to(f.ROOT)
            if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
            path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
    print('PASS:',len(catalog),'Naruto recruit items; identical Modify Fragment icon IDs;',len(changes),'resource files; applied:',args.apply)

if __name__=='__main__':main()
