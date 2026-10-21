"""Check the launcher -> version map -> application chain through the real HTTP server."""
from pathlib import Path
import hashlib, importlib.util, json, subprocess, time, urllib.request

BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
spec=importlib.util.spec_from_file_location('codec',BASE.parent/'naruto-sage-native/release.py')
codec=importlib.util.module_from_spec(spec);spec.loader.exec_module(codec)
server=subprocess.Popen(['node',str(ROOT/'serve.mjs'),'--port','7476'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
def get(path):
 with urllib.request.urlopen('http://127.0.0.1:7476'+path,timeout=10) as response:
  assert response.headers['Cache-Control']=='no-store'
  return response.read()
try:
 for attempt in range(50):
  try:
   pointer=json.loads(get('/public/client-release.json?t=bootstrap-check'));break
  except OSError:
   if server.poll() is not None:raise RuntimeError('HTTP server exited')
   time.sleep(.1)
 else:raise RuntimeError('HTTP server did not start')
 version=pointer['version']
 launcher=get('/').decode('utf-8')
 assert "base + 'client-release.json?t='" in launcher
 assert 'flashvars.version = String(clientRelease.version)' in launcher
 index=get(f'/public/{version}/index.swf?release={version}')
 assert index==(PUBLIC/'2026090619/index.swf').read_bytes()
 mapping=dict(codec.decode(get(f'/public/{version}/version.swf')))
 app_version=mapping[b'TApplication.swf'].decode()
 assert app_version==version
 app=get(f'/public/{app_version}/TApplication.swf')
 assert app==(PUBLIC/'2026090619/TApplication.swf').read_bytes()
 release=json.loads((BASE/'release.json').read_text())
 for entry in release['files']:
  data=get(f'/public/{version}/'+entry['path'])
  assert hashlib.sha256(data).hexdigest()==entry['sha256'],entry['path']
 for entry in release.get('cinematics',{}).values():
  assert hashlib.sha256(get(entry['url'])).hexdigest()==entry['sha256']
 print('PASS HTTP bootstrap',version,': launcher, index, version map and',len(release['files']),'release files match disk; no-store headers')
finally:
 server.terminate();server.wait(timeout=10)
