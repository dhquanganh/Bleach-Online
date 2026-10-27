"""Publish the Kakuzu revive and target-aligned effect client patch."""
from pathlib import Path
import hashlib, importlib.util, json, shutil

B=Path(__file__).resolve().parent
W=B/'revival-repair'
P=B.parents[1]/'kaynak/login.gogames.me/public'
VERSION='2026102705'

def main():
    spec=importlib.util.spec_from_file_location('prior',B/'release.py')
    prior=importlib.util.module_from_spec(spec);spec.loader.exec_module(prior)
    assert json.loads((P/'client-release.json').read_text())['version']=='2026102704'
    canonical=P/'2026090619';source=P/'2026102704'
    old=canonical/'TApplication.swf'
    assert old.read_bytes()==(source/'TApplication.swf').read_bytes()
    compiled=W/'compiled.swf'
    c=importlib.util.spec_from_file_location('client',B/'build-client.py')
    client=importlib.util.module_from_spec(c);c.loader.exec_module(client)
    validation=json.loads((W/'client-validation.json').read_text())
    assert validation['sourceVersion']=='2026102704' and validation['unchangedMethods']==210
    assert hashlib.sha256(compiled.read_bytes()).hexdigest()==validation['sha256']
    assert client.c.h.swap(old.read_bytes())==(W/'source.swf').read_bytes()
    probe=json.loads((W/'validation/native/result.json').read_text())
    recovery=json.loads((W/'validation/recovery-native/result.json').read_text())
    assert probe['completed'] and probe['cases']==22 and probe['remainingLayers']==0 and not probe['errors'],probe
    assert recovery['completed'] and recovery['cases']==recovery['restores']==recovery['stableRestores']==8 and not recovery['errors'],recovery
    updated=client.c.h.swap(compiled.read_bytes())
    assert updated!=old.read_bytes()
    dest=P/VERSION;assert not dest.exists();dest.mkdir()
    rows=prior.rows((canonical/'version.swf').read_bytes())
    for row in rows:
        if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
    manifest=prior.encode(rows)
    backup=W/('release-backup-'+VERSION);backup.mkdir(exist_ok=True)
    for name in ['TApplication.swf','version.swf']:shutil.copy2(canonical/name,backup/name)
    shutil.copy2(P/'client-release.json',backup/'client-release.json')
    (dest/'TApplication.swf').write_bytes(updated)
    (dest/'version.swf').write_bytes(manifest)
    shutil.copy2(canonical/'index.swf',dest/'index.swf')
    old.write_bytes(updated)
    (canonical/'version.swf').write_bytes(manifest)
    (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
    (W/'release.json').write_text(json.dumps({'version':VERSION,'sha256':hashlib.sha256(updated).hexdigest(),'animationProbe':probe,'revivalProbe':recovery},indent=2)+'\n')
    print('PASS Kakuzu revival client',VERSION,hashlib.sha256(updated).hexdigest())

if __name__=='__main__':main()
