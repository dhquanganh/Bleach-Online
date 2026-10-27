"""Retire unused release snapshots while preserving base assets and fallback art."""
from pathlib import Path
import argparse,hashlib,json,re,struct,zipfile,zlib

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
WORKSPACE=ROOT.parent
PUBLIC=(ROOT/'kaynak/login.gogames.me/public').resolve()
ARCHIVE=WORKSPACE/'.tools/version-archive/2026102707-unused-snapshots.zip'
KEEP={'2017112917','2026090619','2026102707'}

def sha(file):
    value=hashlib.sha256()
    with file.open('rb') as stream:
        for chunk in iter(lambda:stream.read(1024*1024),b''):value.update(chunk)
    return value.hexdigest()

def rows(data):
    raw=zlib.decompress(data);pos=2;result=[]
    for _ in range(struct.unpack_from('<H',raw)[0]):
        fields=[]
        for _ in range(2):
            size=struct.unpack_from('<H',raw,pos)[0];pos+=2
            fields.append(raw[pos:pos+size].decode());pos+=size
        result.append(fields)
    assert pos==len(raw)
    return result

def checked(relative):
    file=(PUBLIC/relative).resolve();assert file.is_relative_to(PUBLIC),file
    parts=file.relative_to(PUBLIC).parts;assert parts[0].isdecimal() and parts[0]>='2026100000' and parts[0] not in KEEP,file
    key=Path(*parts[1:]).as_posix()
    assert key in ['TApplication.swf','index.swf','version.swf'] or key.startswith('Resources/Bin/'),file
    return file

def live():
    version=json.loads((PUBLIC/'client-release.json').read_text())['version'];assert version=='2026102707'
    manifest=PUBLIC/version/'version.swf'
    assert manifest.read_bytes()==(PUBLIC/'2026090619/version.swf').read_bytes()
    assert (PUBLIC/version/'TApplication.swf').read_bytes()==(PUBLIC/'2026090619/TApplication.swf').read_bytes()
    entries=rows(manifest.read_bytes());protected=set();direct=set()
    for key,ver in entries:
        file=(PUBLIC/ver/key).resolve();assert file.is_relative_to(PUBLIC)
        protected.add(file)
        if file.is_file():direct.add(file)
        match=re.match(r'Resources/Bin/(?:normal|combine)/([^/]+)$',key)
        if match:
            # serve.mjs substitutes translated tables at the same version.
            for translated in (PUBLIC/ver/'Resources/Bin').glob('dil-*/'+match[1]):
                if translated.is_file():protected.add(translated.resolve())
    return {'version':version,'manifestSha256':sha(manifest),'clientSha256':sha(PUBLIC/version/'TApplication.swf'),'protected':protected,'direct':direct,'entries':len(entries),'baseReferences':sum(ver=='2017112917' for _,ver in entries)}

def candidates(state):
    files=[]
    for root in PUBLIC.iterdir():
        if not root.is_dir() or not root.name.isdecimal() or root.name<'2026100000' or root.name in KEEP:continue
        for file in root.rglob('*'):
            if not file.is_file():continue
            key=file.relative_to(root).as_posix()
            if key not in ['TApplication.swf','index.swf','version.swf'] and not key.startswith('Resources/Bin/'):continue
            file=checked(file.relative_to(PUBLIC))
            if file not in state['protected']:files.append(file)
    return sorted(files)

def verify_archive(file):
    with zipfile.ZipFile(file) as archive:
        manifest=json.loads(archive.read('MANIFEST.json'));assert len(archive.infolist())==len(manifest['files'])+1
        for index,row in enumerate(manifest['files']):
            checked(row['path']);value=hashlib.sha256();size=0
            with archive.open(row['path']) as stream:
                for chunk in iter(lambda:stream.read(1024*1024),b''):value.update(chunk);size+=len(chunk)
            assert size==row['size'] and value.hexdigest()==row['sha256'],row['path']
            if (index+1)%500==0:print('Verified archive',index+1,'files',flush=True)
    return manifest

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    before=live();files=candidates(before);total=sum(f.stat().st_size for f in files)
    report={'activeVersion':before['version'],'manifestEntries':before['entries'],'base2017112917References':before['baseReferences'],'protectedExistingManifestFiles':len(before['direct']),'retiredFiles':len(files),'retiredBytes':total,'archive':str(ARCHIVE.relative_to(WORKSPACE)),'applied':False}
    print('Candidates:',len(files),'files;',round(total/1048576,2),'MiB;',before['baseReferences'],'base references preserved',flush=True)
    (B/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    if not args.apply:return
    assert files
    ARCHIVE.parent.mkdir(parents=True,exist_ok=True)
    if ARCHIVE.exists():
        manifest=verify_archive(ARCHIVE)
        assert {r['path'] for r in manifest['files']}=={f.relative_to(PUBLIC).as_posix() for f in files}
    else:
        temporary=ARCHIVE.with_suffix('.partial.zip');assert not temporary.exists()
        manifest={'version':before['version'],'manifestSha256':before['manifestSha256'],'files':[]}
        with zipfile.ZipFile(temporary,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=1,allowZip64=True) as archive:
            for index,file in enumerate(files):
                relative=file.relative_to(PUBLIC).as_posix();value=hashlib.sha256();size=0
                with file.open('rb') as source,archive.open(relative,'w',force_zip64=True) as output:
                    for chunk in iter(lambda:source.read(1024*1024),b''):output.write(chunk);value.update(chunk);size+=len(chunk)
                manifest['files'].append({'path':relative,'size':size,'sha256':value.hexdigest()})
                if (index+1)%250==0:print('Archived',index+1,'/',len(files),'files',flush=True)
            archive.writestr('MANIFEST.json',json.dumps(manifest,indent=2)+'\n')
        verify_archive(temporary);temporary.rename(ARCHIVE)
    current=live();assert current==before,'Active resources changed during archive creation'
    for row in manifest['files']:
        file=checked(row['path']);assert file not in before['protected'] and file.stat().st_size==row['size'] and sha(file)==row['sha256']
    # All originals and backup entries have been validated before any removal.
    for row in manifest['files']:checked(row['path']).unlink()
    removed=[]
    for root in list(PUBLIC.iterdir()):
        if not root.is_dir() or not root.name.isdecimal() or root.name<'2026100000' or root.name in KEEP:continue
        assert root.resolve().is_relative_to(PUBLIC) and root.name not in KEEP
        for folder in sorted((f for f in root.rglob('*') if f.is_dir()),key=lambda f:len(f.parts),reverse=True):
            assert folder.resolve().is_relative_to(root.resolve())
            if not any(folder.iterdir()):folder.rmdir()
        if not any(root.iterdir()):root.rmdir();removed.append(root.name)
    assert live()==before,'Active manifest files must remain present'
    report.update(applied=True,archiveBytes=ARCHIVE.stat().st_size,removedFolders=removed,remainingCandidates=len(candidates(before)))
    (B/'result.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS removed',len(files),'obsolete snapshot files and',len(removed),'empty version folders;',round(total/1048576,2),'MiB removed from public',flush=True)

if __name__=='__main__':main()
