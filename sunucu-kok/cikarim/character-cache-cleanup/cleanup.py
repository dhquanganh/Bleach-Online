"""Remove reproducible character render caches, preserving runtime data and sources."""
from pathlib import Path
import argparse,hashlib,json

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
WORKSPACE=ROOT.parent
CIKARIM=(ROOT/'cikarim').resolve()
PUBLIC=(ROOT/'kaynak/login.gogames.me/public').resolve()
SOURCES={
 'sasuke-shinden':'Sasuke_Shinden_Full','mecha-naruto':'Mecha_Naruto','itachi-rtn':'Itachi_Road_to_Ninja',
 'gaara-swimsuit':'Gaara_Swimsuit_Full','hashirama-final':'Hashirama_Senju_Final_Battle',
 'tobi-war':'Tobi_Great_Ninja_War_Full','kakuzu-edo':'Kakuzu_Edo_Tensei_Full','tsunade-asian':'Tsunade_Asian_Style_Full',
 'naruto-nine-tails':'Naruto_Nine_Tails_Chakra_Full','naruto-sage-native':'Naruto_Sage_Mode',
 'pain-tendo':'Pain_Tendo_Six_Paths_Rinnegan','obito-rage':'Extracted_Obito_Rage','nagato-frog':'Nagato_Frog_Squad_Full',
}
CACHES={'frames','native-export','native-export-hd','gale-hd','surf-hd','camera-export','portrait-export'}
IMAGES={'.png','.jpg','.jpeg','.gif','.bmp','.argb'}
MARKERS={'complete.json','export-complete','render-complete.json'}
PROTECTED={'original','patched','source-config','validation'}

def sha(file):return hashlib.sha256(file.read_bytes()).hexdigest()

def checked(file):
    file=file.resolve();assert file.is_relative_to(CIKARIM),file
    relative=file.relative_to(CIKARIM);assert relative.parts[0] in SOURCES,file
    return file

def candidates():
    files=[]
    for character,source in SOURCES.items():
        original=WORKSPACE/'asset'/source
        assert original.is_dir() and any(original.rglob('*.swf')),'Original source unavailable: '+str(original)
        root=CIKARIM/character
        for file in root.rglob('*'):
            if not file.is_file() or file.suffix.lower() not in IMAGES:continue
            parts=file.relative_to(root).parts[:-1]
            if any('backup' in p.lower() or p in PROTECTED for p in parts):continue
            if any(p in CACHES for p in parts):files.append(checked(file))
    return sorted(files)

def protected_state():
    # Character builders are development inputs. JSON tables and opcode data
    # are runtime inputs, so hash their complete directories independently.
    state={}
    for name in ['veri-json','veri-json-yedek','db']:
        for file in (CIKARIM/name).rglob('*'):
            if file.is_file():state[str(file.relative_to(CIKARIM))]=sha(file)
    release=json.loads((PUBLIC/'client-release.json').read_text())['version']
    for name in ['TApplication.swf','version.swf']:
        state['client/'+name]=sha(PUBLIC/release/name)
    state['client/release']=release
    return state

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    files=candidates();markers={}
    for file in files:
        root=CIKARIM/file.relative_to(CIKARIM).parts[0]
        parent=file.parent
        while parent!=root:
            for name in MARKERS:
                marker=parent/name
                if marker.is_file():markers[str(marker.relative_to(CIKARIM))]=marker.read_text(encoding='utf-8')
            parent=parent.parent
    total=sum(f.stat().st_size for f in files)
    report={'applied':False,'files':len(files),'bytes':total,'cacheMarkers':len(markers),'characters':{},'paths':[str(f.relative_to(CIKARIM)) for f in files]}
    for file in files:
        name=file.relative_to(CIKARIM).parts[0]
        row=report['characters'].setdefault(name,{'files':0,'bytes':0});row['files']+=1;row['bytes']+=file.stat().st_size
    print('Reproducible image caches:',len(files),'files;',round(total/1048576,2),'MiB;',len(markers),'render markers')
    (B/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    if not args.apply:return
    assert files
    state=protected_state()
    # Keep old marker settings as rebuild information, but remove the markers
    # themselves: otherwise exporters would incorrectly skip the missing PNGs.
    (B/'removed-render-markers.json').write_text(json.dumps(markers,indent=2)+'\n')
    for file in files:
        checked(file);assert file.suffix.lower() in IMAGES
        assert (WORKSPACE/'asset'/SOURCES[file.relative_to(CIKARIM).parts[0]]).is_dir()
    for file in files:file.unlink()
    for relative in markers:
        file=checked(CIKARIM/relative);assert file.name in MARKERS;file.unlink()
    # Only empty generated directories are removed. Source XML/SWF/AS3 and
    # existing backups, evidence and build scripts stay at their current paths.
    parents={file.parent for file in files}
    for parent in sorted(parents,key=lambda p:len(p.parts),reverse=True):
        checked(parent)
        if parent.is_dir() and not any(parent.iterdir()):parent.rmdir()
    assert protected_state()==state,'Runtime data or installed client changed'
    assert not candidates()
    report['applied']=True;report['protectedRuntimeFiles']=len(state)
    (B/'result.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS removed',round(total/1048576,2),'MiB of reproducible caches;',len(state),'runtime data/client fingerprints unchanged')

if __name__=='__main__':main()
