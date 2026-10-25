from pathlib import Path
import importlib.util,subprocess,shutil,json,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('h',B.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
s=importlib.util.spec_from_file_location('r',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
current=h.PUBLIC/'2026090619/TApplication.swf'
previous=json.loads((B/'release.json').read_text())
assert hashlib.sha256(current.read_bytes()).hexdigest()==previous['sha256'],'Client changed since previous build'
(B/'source.swf').write_bytes(h.swap(current.read_bytes()))
rel=Path('Processors/Game/Lobby/TeamBattle/TProcessorTeamBattle.as')
t=(B/'original/scripts'/rel).read_text(encoding='utf-8')
anchor='   import flash.utils.ByteArray;'
assert anchor in t
t=t.replace(anchor,anchor+'\n   import flash.external.ExternalInterface;',1)
for method,tab in [('ProcessorOnEnterHallPVE','campaign'),('ProcessorOnEnterHallPVP','battle'),('ProcessorOnAutoPVP','auto'),('ProcessorOnMallHonor','shop')]:
 a=t.index('      protected function '+method+'(');brace=t.index('{',a);depth=1;end=brace+1
 while depth:
  if t[end]=='{':depth+=1
  if t[end]=='}':depth-=1
  end+=1
 t=t[:brace+1]+'\n         if(ExternalInterface.available){ExternalInterface.call("openAllianceWar","'+tab+'");}\n      '+t[end-1:]
p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(t,encoding='utf-8');paths=[rel]
rel=Path('Processors/Game/Lobby/TeamBattle/TProcessorWindowTeamBattleChoose.as')
t=(B/'original/scripts'/rel).read_text(encoding='utf-8')
t=t.replace('         this.FBtn_AutoPVP.Enabled = false;','         this.FBtn_AutoPVP.Enabled = this.FTeamBattle.PvpStatus;',1)
t=t.replace('            this.FBtn_EnterPVP.Enabled = param1;','            this.FBtn_EnterPVP.Enabled = param1;\n            this.FBtn_AutoPVP.Enabled = param1;',1)
needle='      public function Update() : void\n      {'
assert needle in t
t=t.replace(needle,needle+'\n         if(!this.FInitialization)return;',1)
p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(t,encoding='utf-8');paths.append(rel)
def write_native(rel,t):
 rel=Path(rel);p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(t,encoding='utf-8');paths.append(rel)
s=importlib.util.spec_from_file_location('native_patch',B/'patch-native.py');native_patch=importlib.util.module_from_spec(s);s.loader.exec_module(native_patch);native_patch.build(B,write_native)
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
raw=(B/'compiled.swf').read_bytes();source=(B/'source.swf').read_bytes();assert [x for x in h.tags(source) if x[0]!=82]==[x for x in h.tags(raw) if x[0]!=82]
ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in paths),'-export','script',B/'verify',B/'compiled.swf')
for rel in paths:assert (B/'verify/scripts'/rel).exists()
verified=(B/'verify/scripts/Processors/Game/Lobby/TeamBattle/TProcessorTeamBattle.as').read_text(encoding='utf-8')
assert 'import flash.external.ExternalInterface;' in verified,'Bridge class must resolve the Flash ExternalInterface API'
mini=(B/'verify/scripts/Processors/Game/MiniBattle/Decoder/TUnstreamizerBattleInfor.as').read_text(encoding='utf-8')
assert mini.count('LastHp = param1.readDouble();')==2,'Native HP wire format must match the server'
version='2026102525';canonical=h.PUBLIC/'2026090619';old=(canonical/'TApplication.swf').read_bytes();assert h.swap(old) in [source,raw],'Current client changed; refusing overwrite'
backup=B/'backups';backup.mkdir(exist_ok=True)
for f in [canonical/'TApplication.swf',canonical/'version.swf',h.PUBLIC/'client-release.json']:
 if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
manifest=r.rows((canonical/'version.swf').read_bytes());found=0
for row in manifest:
 if row[0]==b'TApplication.swf':row[1]=version.encode();found+=1
assert found==1
out=h.PUBLIC/version;out.mkdir(exist_ok=True);protected=h.swap(raw)
(out/'TApplication.swf').write_bytes(protected);(canonical/'TApplication.swf').write_bytes(protected)
data=r.encode(manifest);(canonical/'version.swf').write_bytes(data);(out/'version.swf').write_bytes(data)
shutil.copy2(canonical/'index.swf',out/'index.swf');(h.PUBLIC/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(B/'release.json').write_text(json.dumps({'version':version,'classes':[str(x) for x in paths],'sha256':hashlib.sha256(protected).hexdigest()},indent=2))
print('PASS Alliance War launcher bridge',version)
