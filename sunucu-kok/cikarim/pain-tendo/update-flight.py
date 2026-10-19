"""Replace Pain's flight motion in the live client, preserving later Tower patches."""
from pathlib import Path
import argparse,importlib.util,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('h',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
ROLE=Path('Processors/Game/Battle/Character/TRole.as')
VERSION=b'2026101956'

def replace_method(source,name,replacement):
    start=source.index('      private function '+name+'(');body=source.index('{',start);end=body+1;depth=1
    while depth:
        depth+=(source[end]=='{')-(source[end]=='}');end+=1
    return source[:start]+replacement+source[end:]

def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
    canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
    source=BASE/'flight-source.swf';source.write_bytes(decoded)
    def ff(*args2):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,args2)],check=True)
    ff('-selectclass','Processors.Game.Battle.Character.TRole','-export','script',BASE/'flight-original',source)
    role=(BASE/'flight-original/scripts'/ROLE).read_text(encoding='utf-8')
    runtime=(BASE/'runtime.as.txt').read_text(encoding='utf-8')
    def runtime_method(name):
        start=runtime.index('      private function '+name+'(');body=runtime.index('{',start);end=body+1;depth=1
        while depth:
            depth+=(runtime[end]=='{')-(runtime[end]=='}');end+=1
        return runtime[start:end]
    method=runtime_method('PainFlightPose')
    if 'function PainFlightPose(' in role:role=replace_method(role,'PainFlightPose',method)
    else:
        index=role.index('      private function PainStrikePose(')
        role=role[:index]+method+'\n\n'+role[index:]
    anchor='         if(FCurrentRebirthSequence != null)'
    hook='         if(!this.FHasFrozen) this.PainFlightPose(_loc4_);\n'
    assert role.count(anchor)==1
    if hook not in role:role=role.replace(anchor,hook+anchor)
    for dest in [BASE/'flight-patched'/ROLE,BASE/'patched'/ROLE]:
        dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role,encoding='utf-8')
    output=BASE/'flight-compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'flight-patched')
    rebuilt=output.read_bytes();assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
    classes='Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Lobby.SkyTower.TProcessorSkyTower'
    ff('-selectclass',classes,'-export','script',BASE/'flight-verify',output)
    verified=(BASE/'flight-verify/scripts'/ROLE).read_text(encoding='utf-8')
    for token in ['PainFlightPose','this.PainFlightPose(_loc4_)','ShowPainLaserImpact','Math.max(1500','Math.max(850','RestorePainAfterRevival','UpdateObitoVfx']:assert token in verified,token
    active=(BASE/'flight-verify/scripts/Processors/Game/Battle/Character/TActive.as').read_text(encoding='utf-8')
    tower=(BASE/'flight-verify/scripts/Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as').read_text(encoding='utf-8')
    assert 'FPainFinal' in active and 'GoldPrimogem' in tower and 'current.atk' in tower
    if args.install:
        assert canonical.read_bytes()==old,'Client changed during compilation'
        manifest=canonical.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];found=0
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
            if k==b'TApplication.swf':v=VERSION;found+=1
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        assert found==1 and pos==len(raw)
        for original in [canonical,manifest]:
            backup=BASE/'backups'/('flight-'+VERSION.decode()+'-'+original.name)
            backup.parent.mkdir(exist_ok=True)
            if not backup.exists():shutil.copy2(original,backup)
        protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected)
        canonical.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS continuous airborne motion; preserved Final idle, revival, Obito and Tower UI; client',VERSION.decode(),'installed',args.install)
if __name__=='__main__':main()
