"""Raise both Hellwing equipment sets to the highest native equipment quality."""
from pathlib import Path
import argparse,hashlib,json,shutil,struct,zlib

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
DATA=ROOT/'cikarim/veri-json'
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
U32=lambda b,p:struct.unpack_from('<I',b,p)[0]

def patch_article(raw,ids,quality):
    if len(raw)<8 or U32(raw,0)!=0x1000002:return raw,0
    out=bytearray(raw);p=8;found=0;allowed=set()
    def skip(pos):return pos+2+struct.unpack_from('<H',raw,pos)[0]
    for _ in range(U32(raw,4)):
        ident=U32(raw,p);name_end=skip(p+4);qpos=name_end+12
        if ident in ids:
            assert U32(raw,qpos) in range(8),(ident,U32(raw,qpos))
            struct.pack_into('<I',out,qpos,quality);found+=1
            allowed.update(range(qpos,qpos+4))
        p=skip(name_end+36)+4;p=skip(p)+16
    assert p==len(raw)
    assert all(a==b or i in allowed for i,(a,b) in enumerate(zip(raw,out)))
    return bytes(out),found

def patch_equipment(raw,ids,edge):
    if len(raw)<8 or U32(raw,0)!=0x1000004:return raw,0
    out=bytearray(raw);p=8;found=0;allowed=set()
    for _ in range(U32(raw,4)):
        ident=U32(raw,p);p+=4
        for _ in range(3):p+=2+struct.unpack_from('<H',raw,p)[0]
        # Native TBaseEquip: five u32 properties, EdgeColor, float, DrillHoleNum.
        # Exported JSON labels are shifted: drillHoleNum is native EdgeColor.
        if ident in ids:
            struct.pack_into('<I',out,p+20,edge);found+=1;allowed.update(range(p+20,p+24))
        p+=32
    assert p==len(raw)
    assert all(a==b or i in allowed for i,(a,b) in enumerate(zip(raw,out)))
    return bytes(out),found

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    article=json.loads((DATA/'Article.json').read_text(encoding='utf-8'))
    equipment=[a for a in article if a.get('majorType')==2]
    quality=max(a['quality'] for a in equipment)
    targets=[a for a in equipment if a['name'].startswith(('Hellwing ','Spirit\u00b7Hellwing '))]
    assert len(targets)==16 and quality==7
    ids={int(a['id'],16) for a in targets};changes={};copies=0;matched_files=[];equipment_files=[]
    base_file=DATA/'BaseEquip.json';base_rows=json.loads(base_file.read_text(encoding='utf-8'))
    edge=max(row['drillHoleNum'] for row in base_rows);assert edge==4
    for row in base_rows:
        if int(row['id'],16) in ids:row['drillHoleNum']=edge
    encoded=(json.dumps(base_rows,ensure_ascii=False,indent=2)+'\n').encode()
    if base_file.read_bytes()!=encoded:changes[base_file]=encoded
    def patch(raw):
        raw,article=patch_article(raw,ids,quality);raw,equipment=patch_equipment(raw,ids,edge)
        return raw,article,equipment
    for name in ['Article','items']:
        file=DATA/(name+'.json');rows=json.loads(file.read_text(encoding='utf-8'));old={a['id']:dict(a) for a in rows}
        count=0
        for row in rows:
            if int(row['id'],16) in ids:row['quality']=quality;count+=1
        assert count==16
        for row in rows:
            expected=dict(old[row['id']])
            if int(row['id'],16) in ids:expected['quality']=quality
            assert row==expected
        encoded=(json.dumps(rows,ensure_ascii=False,indent=2)+'\n').encode()
        if file.read_bytes()!=encoded:changes[file]=encoded
    for file in PUBLIC.glob('*/Resources/Bin/**/*'):
        if not file.is_file() or file.suffix not in ['.bin','.binPackage']:continue
        original=file.read_bytes();count=0;equip_count=0
        if file.suffix=='.bin':
            raw=zlib.decompress(original);patched,count,equip_count=patch(raw)
            result=zlib.compress(patched) if patched!=raw else original
        else:
            pos=6;parts=[original[:6]];changed=False
            for _ in range(struct.unpack_from('<H',original,4)[0]):
                n=U32(original,pos);pos+=4;packed=original[pos:pos+n];pos+=n
                raw=zlib.decompress(packed);patched,hits,equip_hits=patch(raw);count+=hits;equip_count+=equip_hits
                if patched!=raw:packed=zlib.compress(patched);changed=True
                parts.extend([struct.pack('<I',len(packed)),packed])
            assert pos<=len(original)
            result=b''.join(parts)+original[pos:] if changed else original
        if count:
            assert count==16,(file,count)
            copies+=1;matched_files.append(str(file.relative_to(ROOT)))
        if equip_count:
            assert equip_count==16,(file,equip_count)
            equipment_files.append(str(file.relative_to(ROOT)))
        if result!=original:changes[file]=result
    assert copies>=2,'Both client resource versions must contain Article'
    assert len(equipment_files)>=2
    glow=PUBLIC/'2017112917/Resources/Textures/Lobby/00CFAC85.TexClient'
    glow_data=glow.read_bytes();assert struct.unpack_from('<H',glow_data,8+U32(glow_data,4))[0]>=edge
    for version in ['2017112917','2026090619']:
        dest=PUBLIC/version/'Resources/Textures/Lobby/00CFAC85.TexClient'
        if not dest.exists():changes[dest]=glow_data
    if args.apply:
        for file,data in changes.items():
            backup=B/'backups'/file.relative_to(ROOT)
            if file.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(file,backup)
            file.parent.mkdir(parents=True,exist_ok=True)
            file.write_bytes(data)
    manifest={'applied':args.apply,'quality':quality,'nativeEdgeColor':edge,'items':[{'id':int(a['id'],16),'name':a['name']} for a in targets],
              'articleCopies':matched_files,'baseEquipCopies':equipment_files,'changedFiles':[{ 'path':str(p.relative_to(ROOT)),'sha256':hashlib.sha256(data).hexdigest()} for p,data in changes.items()]}
    (B/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    print('PASS 16 Hellwing/Spirit Hellwing equipment templates; quality',quality,';',copies,'native Article copies;',len(changes),'changed files; applied',args.apply)

if __name__=='__main__':main()
