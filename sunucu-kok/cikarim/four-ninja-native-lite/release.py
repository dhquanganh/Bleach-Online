"""Publish the validated lightweight effects at fresh client/resource URLs."""
from pathlib import Path
import hashlib,importlib.util,json,shutil
from verify import verify
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py');build=importlib.util.module_from_spec(s);s.loader.exec_module(build)
c=build.c;P=c.h.PUBLIC;VERSION='2026102707'
s=importlib.util.spec_from_file_location('prior',B.parent/'kakuzu-edo/release.py');prior=importlib.util.module_from_spec(s);s.loader.exec_module(prior)

def main():
    evidence=verify(probes=True)
    assert json.loads((P/'client-release.json').read_text())['version']=='2026102706'
    canonical=P/'2026090619';active=P/'2026102706'
    for name in ['TApplication.swf','version.swf']:assert (canonical/name).read_bytes()==(active/name).read_bytes()
    assert c.h.swap((canonical/'TApplication.swf').read_bytes())==(B/'source.swf').read_bytes()
    output=P/VERSION;assert not output.exists()
    backup=B/'release-backup';backup.mkdir(exist_ok=True)
    for name in ['TApplication.swf','version.swf']:shutil.copy2(canonical/name,backup/name)
    shutil.copy2(P/'client-release.json',backup/'client-release.json')
    manifest=prior.rows((canonical/'version.swf').read_bytes());changed=0
    for row in manifest:
        if row[0]==b'TApplication.swf':row[1]=VERSION.encode();changed+=1
    assert changed==1
    packed=prior.encode(manifest);client=c.h.swap((B/'compiled.swf').read_bytes())
    output.mkdir();(output/'TApplication.swf').write_bytes(client);(output/'version.swf').write_bytes(packed)
    shutil.copy2(canonical/'index.swf',output/'index.swf')
    (canonical/'TApplication.swf').write_bytes(client);(canonical/'version.swf').write_bytes(packed)
    (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
    (B/'release.json').write_text(json.dumps({'version':VERSION,'sha256':hashlib.sha256(client).hexdigest(),'probeCases':evidence['probeCases'],'sizes':evidence['sizes']},indent=2)+'\n')
    print('PASS native four-character release',VERSION)

if __name__=='__main__':main()
