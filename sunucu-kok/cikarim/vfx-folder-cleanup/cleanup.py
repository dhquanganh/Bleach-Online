"""Archive and retire superseded rasters after the native-effect migration."""
from pathlib import Path
import argparse,hashlib,json,zipfile

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
WORKSPACE=ROOT.parent
PUBLIC=(ROOT/'kaynak/login.gogames.me/public').resolve()
NATIVE=ROOT/'cikarim/four-ninja-native-lite'
ROOTS=['sasuke-vfx','mecha-vfx','itachi-vfx','gaara-vfx']
ARCHIVE=WORKSPACE/'.tools/vfx-archive/2026102707-retired-vfx.zip'

def digest(file):
    value=hashlib.sha256()
    with file.open('rb') as stream:
        for chunk in iter(lambda:stream.read(1024*1024),b''):value.update(chunk)
    return value.hexdigest()

def checked(relative):
    path=(PUBLIC/relative).resolve()
    assert path.is_relative_to(PUBLIC) and path.relative_to(PUBLIC).parts[0] in ROOTS,path
    assert not path.is_relative_to(PUBLIC/'sasuke-vfx/cinematic-v1'),path
    return path

def active_files():
    assert json.loads((PUBLIC/'client-release.json').read_text())['version']=='2026102707'
    release=json.loads((NATIVE/'release.json').read_text())
    assert digest(PUBLIC/'2026102707/TApplication.swf')==release['sha256']
    assert digest(PUBLIC/'2026090619/TApplication.swf')==release['sha256']
    evidence=json.loads((NATIVE/'verification.json').read_text())
    assert evidence['probeCases']==180
    protected=set()
    for result in evidence['probes']:
        assert result['completed'] and not result['errors'] and result['remainingLayers']==0
        for url in result['requests']:
            if url.startswith('/public/'):
                path=(PUBLIC.parent/url.lstrip('/')).resolve()
                assert path.is_relative_to(PUBLIC) and path.is_file(),path
                protected.add(path)
    for file in (PUBLIC/'ninja-native-lite').rglob('*'):
        if file.is_file():protected.add(file.resolve())
    return protected

def candidates(protected):
    files=[]
    for name in ROOTS:
        for file in (PUBLIC/name).rglob('*'):
            if not file.is_file() or file.is_relative_to(PUBLIC/'sasuke-vfx/cinematic-v1'):continue
            file=checked(file.relative_to(PUBLIC));assert file not in protected,file
            files.append(file)
    return sorted(files)

def verify_archive(archive):
    with zipfile.ZipFile(archive) as data:
        manifest=json.loads(data.read('MANIFEST.json'))
        assert len(data.infolist())==len(manifest['files'])+1
        for index,row in enumerate(manifest['files']):
            checked(row['path']);value=hashlib.sha256();size=0
            with data.open(row['path']) as stream:
                for chunk in iter(lambda:stream.read(1024*1024),b''):value.update(chunk);size+=len(chunk)
            assert size==row['size'] and value.hexdigest()==row['sha256'],row['path']
            if (index+1)%1000==0:print('Verified archive',index+1,'files',flush=True)
    return manifest

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    protected=active_files();files=candidates(protected)
    total=sum(f.stat().st_size for f in files)
    report={'activeVersion':'2026102707','retiredFiles':len(files),'retiredBytes':total,'protectedRuntimeFiles':len(protected),'archive':str(ARCHIVE.relative_to(WORKSPACE)),'applied':False}
    print('Retired candidates:',len(files),'files;',round(total/1048576,2),'MiB; protected',len(protected),'active files',flush=True)
    if not args.apply:
        (B/'audit.json').write_text(json.dumps(report,indent=2)+'\n');return
    assert files,'No retired files remain'
    ARCHIVE.parent.mkdir(parents=True,exist_ok=True)
    if ARCHIVE.exists():
        manifest=verify_archive(ARCHIVE)
        assert {r['path'] for r in manifest['files']}=={f.relative_to(PUBLIC).as_posix() for f in files}
    else:
        temporary=ARCHIVE.with_suffix('.partial.zip');assert not temporary.exists(),temporary
        manifest={'version':report['activeVersion'],'publicRoot':str(PUBLIC),'files':[]}
        with zipfile.ZipFile(temporary,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=1,allowZip64=True) as data:
            for index,file in enumerate(files):
                relative=file.relative_to(PUBLIC).as_posix();value=hashlib.sha256();size=0
                with file.open('rb') as source,data.open(relative,'w',force_zip64=True) as output:
                    for chunk in iter(lambda:source.read(1024*1024),b''):output.write(chunk);value.update(chunk);size+=len(chunk)
                manifest['files'].append({'path':relative,'size':size,'sha256':value.hexdigest()})
                if (index+1)%250==0:print('Archived',index+1,'/',len(files),'files',flush=True)
            data.writestr('MANIFEST.json',json.dumps(manifest,indent=2)+'\n')
        verify_archive(temporary)
        temporary.rename(ARCHIVE)
    # Check every original before deleting any file. The backup above has already
    # been read back in full and compared by SHA-256, independently of ZIP CRC.
    for row in manifest['files']:
        file=checked(row['path'])
        assert file not in protected and file.stat().st_size==row['size'] and digest(file)==row['sha256'],file
    for row in manifest['files']:checked(row['path']).unlink()
    for name in ROOTS:
        root=PUBLIC/name
        for directory in sorted((f for f in root.rglob('*') if f.is_dir()),key=lambda f:len(f.parts),reverse=True):
            checked(directory.relative_to(PUBLIC)) if not directory.is_relative_to(PUBLIC/'sasuke-vfx/cinematic-v1') else None
            if directory.is_relative_to(PUBLIC/'sasuke-vfx/cinematic-v1'):continue
            if not any(directory.iterdir()):directory.rmdir()
    assert active_files()==protected
    report.update(applied=True,archiveBytes=ARCHIVE.stat().st_size,remainingRetiredFiles=len(candidates(protected)),netDiskSavedBytes=total-ARCHIVE.stat().st_size)
    (B/'result.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS retired VFX archived and removed;',round(total/1048576,2),'MiB removed from public;',round(ARCHIVE.stat().st_size/1048576,2),'MiB archive;',len(protected),'active files verified',flush=True)

if __name__=='__main__':main()
