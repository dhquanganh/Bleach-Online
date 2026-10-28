"""Collect original Minato New Year resources and referenced summon dependencies.

Read-only source tree; output preserves original game paths and file bytes.
"""
from pathlib import Path
from collections import defaultdict,deque
import copy,hashlib,json,re,shutil,struct,zlib,xml.etree.ElementTree as ET

SOURCE=Path('E:/Naruto_Online_Full_Resources/resources')
ROOT=Path(__file__).resolve().parents[1]
DEST=ROOT/'asset/Minato_New_Year_Full'
SEEDS={'11004471','11004472','11004473'}
CONFIGS=[p.relative_to(ROOT/'asset/Madara_The_Final_Battle_Full/config_reference').as_posix()
         for p in (ROOT/'asset/Madara_The_Final_Battle_Full/config_reference').rglob('*.xml')]
NUMBERS=re.compile(r'(?<!\d)\d{4,10}(?!\d)')
PATHS=re.compile(r'(?:assets|sound|music)/[^\s"<>|;,]+?\.(?:swf|png|jpg|jpeg|gif|mp3|wav|ogg|flv|mp4|xml|cfg)',re.I)

def decode(path):
    raw=path.read_bytes()
    try:return zlib.decompress(raw)
    except zlib.error:return raw

def identifier(node):
    return next((v for v in [node.get('id'),node.get('ninjaId'),node.get('buffId'),node.findtext('id'),node.findtext('ninjaId')] if v and v.isdigit()),None)

def values(node):
    # Descriptions remain in excerpts but are not dependency declarations.
    for e in node.iter():
        for k,v in e.attrib.items():
            if k.lower() not in ['name','desc','title'] and not any(x in k.lower() for x in ['icon','card','item']) and not k.lower().startswith(('base','growth')):yield v
        if e.text and e.tag.lower() not in ['name','desc','title'] and not any(x in e.tag.lower() for x in ['icon','card','item']) and not e.tag.lower().startswith(('base','growth')):yield e.text

def main():
    previous=json.loads((DEST/'manifest.json').read_text(encoding='utf-8')) if (DEST/'manifest.json').exists() else {}
    tables={};index=defaultdict(list)
    for rel in CONFIGS:
        p=SOURCE/rel
        if not p.exists():continue
        root=ET.fromstring(decode(p));tables[rel]=root
        for number,node in enumerate(root):
            ident=identifier(node)
            if ident:index[ident].append((rel,number,node))
    # Include all artistic variants of this precise Minato costume.
    for node in tables['config/user/NinjaInfoConfig.xml']:
        if node.get('artisticId')=='11004471':SEEDS.add(identifier(node))
    queue=deque(sorted(SEEDS));seen=set();selected=defaultdict(dict);resources=set();icon_refs=set();reasons=defaultdict(set)
    while queue:
        ident=queue.popleft()
        if ident in seen:continue
        seen.add(ident)
        for rel,number,node in index.get(ident,[]):
            # Ninja IDs and logic-effect IDs share numeric values in the source.
            # An effect reference must never import an unrelated summon record.
            if not ident.startswith('1') and any(x in rel for x in ['NinjaInfo','NinjaBattleInfo','NinjaSkill','ninjaSkill','NinjaBaseInfo']):continue
            if number in selected[rel]:continue
            selected[rel][number]=node
            for e in node.iter():
                for key,value in list(e.attrib.items())+([(e.tag,e.text)] if e.text else []):
                    if 'icon' in key.lower() or 'card' in key.lower():
                        for icon in NUMBERS.findall(value):
                            icon_refs.add(icon)
                            for size in ['40','60','80','100']:resources.add('assets/skill/'+size+'/'+icon+'.png') if (SOURCE/('assets/skill/'+size+'/'+icon+'.png')).is_file() else None
            for value in values(node):
                for path in PATHS.findall(value):resources.add(path);reasons[path].add(rel+':'+ident)
                for ref in NUMBERS.findall(value):
                    if ref not in seen and ref in index:queue.append(ref)
        assert len(seen)<10000,'Dependency graph unexpectedly broad; review reference types'
    # Include every art/icon/portrait/map/sound variant named by a referenced ID.
    files=[]
    for p in SOURCE.rglob('*'):
        if not p.is_file():continue
        rel=p.relative_to(SOURCE).as_posix()
        if not rel.startswith(('assets/','sound/','music/')):continue
        refs=set(NUMBERS.findall(rel))&(seen|icon_refs)
        if refs:resources.add(rel);reasons[rel].update('filename:'+ref for ref in refs)
    # SWF bytecode can reference additional textures, effects, sounds or videos.
    pending=deque(sorted(resources));processed=set()
    while pending:
        rel=pending.popleft()
        if rel in processed:continue
        processed.add(rel);p=SOURCE/rel
        if not p.is_file():continue
        raw=p.read_bytes()
        if p.suffix.lower()=='.swf' and raw[:3]==b'CWS':raw=raw[:8]+zlib.decompress(raw[8:])
        if p.suffix.lower() in ['.swf','.xml','.cfg']:
            for extra in PATHS.findall(raw.decode('utf-8',errors='ignore')):
                if extra not in resources:resources.add(extra);pending.append(extra)
                reasons[extra].add('embedded:'+rel)
    DEST.mkdir(parents=True,exist_ok=True);missing=[];unchecked=[]
    for rel in sorted(resources):
        src=SOURCE/rel
        if not src.is_file():missing.append({'file':rel,'referencedBy':sorted(reasons[rel])});continue
        raw=src.read_bytes();target=DEST/rel;target.parent.mkdir(parents=True,exist_ok=True)
        if target.exists():assert target.read_bytes()==raw,'Refuse to overwrite a different existing asset: '+rel
        else:shutil.copy2(src,target)
        if src.suffix.lower()=='.swf':
            if raw[:3] in [b'FWS',b'CWS']:
                body=zlib.decompress(raw[8:]) if raw[:3]==b'CWS' else raw[8:]
                assert len(body)+8==struct.unpack_from('<I',raw,4)[0],rel
            else:unchecked.append(rel)
        files.append({'file':rel,'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest(),'referencedBy':sorted(reasons[rel])})
    for old in previous.get('files',[]):
        if old['file'] in resources:continue
        path=(DEST/old['file']).resolve();assert path.is_relative_to(DEST.resolve())
        if path.is_file():
            assert hashlib.sha256(path.read_bytes()).hexdigest()==old['sha256'],'Generated file was modified: '+str(path)
            path.unlink()
    for rel in previous.get('config_excerpts',{}):
        if rel not in selected:
            path=(DEST/'config_reference'/rel).resolve();assert path.is_relative_to(DEST.resolve())
            if path.is_file():path.unlink()
    for rel,nodes in selected.items():
        source=tables[rel];out=ET.Element(source.tag,source.attrib)
        for number,node in sorted(nodes.items()):out.append(copy.deepcopy(node))
        path=DEST/'config_reference'/rel;path.parent.mkdir(parents=True,exist_ok=True)
        ET.ElementTree(out).write(path,encoding='utf-8',xml_declaration=True)
    entities=[]
    for node in selected['config/user/NinjaInfoConfig.xml'].values():
        if node.get('id') in SEEDS:entities.append({k:node.get(k) for k in ['id','name','title','type','artisticId']})
    battle=tables['config/battle/NinjaInfos.xml'];summons=[dict(e.attrib) for e in battle if e.get('id') in seen and e.get('callupType') not in [None,'','0']]
    manifest={'source':str(SOURCE),'files':files,'entities':entities,'resource_ids':sorted({e['artisticId'] for e in entities}),
              'summons':summons,'referenced_ids':sorted(seen),'config_excerpts':{rel:len(nodes) for rel,nodes in selected.items()},
              'missing_files':missing,'unchecked_swfs':unchecked,'total_bytes':sum(f['bytes'] for f in files)}
    (DEST/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (DEST/'HUONG_DAN.txt').write_text('MINATO NAMIKAZE [NEW YEAR]\nAsset goc: 11004471. Bien the: 11004471, 11004472. Yellow Flash Clone: 11004473 (dung chung model 11004471).\n\nassets/: giu nguyen duong dan va byte file goc.\nconfig_reference/: XML da giai nen, chi gom cac entry lien quan va phu thuoc.\nmanifest.json: SHA-256, danh sach file, cau hinh, summon va file nguon con thieu neu co.\nKhong tao nhan vat hay thay doi logic game. Khong nhan ban model dung chung cua summon.\n',encoding='utf-8')
    print(json.dumps({'folder':str(DEST),'files':len(files),'MiB':round(manifest['total_bytes']/2**20,2),'references':len(seen),'entities':entities,'summons':summons,'missing':missing,'uncheckedSwfs':len(unchecked)},ensure_ascii=False))

if __name__=='__main__':main()
