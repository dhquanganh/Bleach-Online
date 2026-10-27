"""Publish the validated, smaller native Hashirama effect client."""
from pathlib import Path
import importlib.util, json, shutil, hashlib

B = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('kakuzu_release', B.parent / 'kakuzu-edo/release.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
P = mod.P
VERSION = '2026102702'

def main():
    probe = json.loads((B/'validation/native/result.json').read_text())
    assert probe['completed'] and probe['cases'] == 24 and probe['remainingLayers'] == 0
    assert not any('HTTP 404' in e or 'timeout' in e for e in probe['errors']), probe['errors']
    validation = json.loads((B/'client-validation.json').read_text())
    assert validation['sourceVersion'] == '2026102701' and validation['unchangedMethods'] == 210

    canonical = P/'2026090619'
    active = json.loads((P/'client-release.json').read_text())['version']
    assert active == '2026102701', active
    old = (canonical/'TApplication.swf').read_bytes()
    assert old == (P/active/'TApplication.swf').read_bytes()
    assert (canonical/'version.swf').read_bytes() == (P/active/'version.swf').read_bytes()
    client_spec = importlib.util.spec_from_file_location('hashirama_build', B/'build-client.py')
    client = importlib.util.module_from_spec(client_spec)
    client_spec.loader.exec_module(client)
    assert client.c.h.swap(old) == (B/'source.swf').read_bytes()
    compiled = client.c.h.swap((B/'compiled.swf').read_bytes())
    assert hashlib.sha256((B/'compiled.swf').read_bytes()).hexdigest() == validation['sha256']

    target = P/VERSION
    assert not target.exists(), target
    backup = B/'release-backup'
    backup.mkdir(exist_ok=True)
    for name in ['TApplication.swf','version.swf']:
        shutil.copy2(canonical/name, backup/name)
    shutil.copy2(P/'client-release.json', backup/'client-release.json')

    manifest = mod.rows((canonical/'version.swf').read_bytes())
    found = False
    for row in manifest:
        if row[0] == b'TApplication.swf':
            row[1] = VERSION.encode()
            found = True
    assert found
    data = mod.encode(manifest)
    target.mkdir()
    (target/'TApplication.swf').write_bytes(compiled)
    (target/'version.swf').write_bytes(data)
    shutil.copy2(canonical/'index.swf', target/'index.swf')
    (canonical/'TApplication.swf').write_bytes(compiled)
    (canonical/'version.swf').write_bytes(data)
    (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
    (B/'release.json').write_text(json.dumps({'version':VERSION,'clientSha256':hashlib.sha256(compiled).hexdigest(),'probe':probe},indent=2)+'\n')
    print('PASS Hashirama native release', VERSION)

if __name__ == '__main__':
    main()
