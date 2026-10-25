from pathlib import Path
import importlib.util,subprocess,shutil,json,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('h',B.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
s=importlib.util.spec_from_file_location('r',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
paths=[]
def patch(rel,text):
 p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8');paths.append(rel)
rel=Path('Logics/Streamization/HDActivitySingle/TUnstreamizerActivitySingle.as');t=(B/'original/scripts'/rel).read_text();needle='         _loc6_.ClearRank();\n         _loc5_ = int(_loc7_.AddtionalVecs[0].length);';assert needle in t;t=t.replace(needle,'         _loc6_.MyRank = -1;\n'+needle,1);patch(rel,t)
rel=Path('Processors/Game/Lobby/Activity/HDGeneralSell/TProcessorHDWindowGeneralSellHerosRank.as');t=(B/'original/scripts'/rel).read_text();t=t.replace('this.FTF_MyRank.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_26);','this.FTF_MyRank.text = "Not ranked";',1);t=t.replace('this.FTF_RankDesc.text = this.FIceHerosBin.RankDesc;','this.FTF_RankDesc.text = "5,000 Crystal Pieces to enter. Updates every 3 seconds. Equal scores: account ID order. Admin sends Top 50 rewards by mail; each account receives once per event.";',1);patch(rel,t)
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
raw=(B/'compiled.swf').read_bytes();source=(B/'source.swf').read_bytes();assert [x for x in h.tags(source) if x[0]!=82]==[x for x in h.tags(raw) if x[0]!=82]
ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in paths),'-export','script',B/'verify',B/'compiled.swf')
assert 'MyRank = -1' in (B/'verify/scripts'/paths[0]).read_text()
version='2026102509';canonical=h.PUBLIC/'2026090619';old=(canonical/'TApplication.swf').read_bytes();assert h.swap(old) in [source,raw],'Current client changed; refusing overwrite'
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
print('PASS native Ultimate BP rankings client',version)
