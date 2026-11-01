"""Fix native Hueco shop quantity limits, empty slots and insufficient balance."""
from pathlib import Path
import importlib.util,json,shutil,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
s=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
W=B/'hueco-client';W.mkdir(exist_ok=True);P=c.h.PUBLIC;canonical=P/'2026090619'
SHOP=Path('Processors/Game/Lobby/VainTravel/TProcessorWindowShop.as');PROCESSOR=Path('Processors/Game/Lobby/VainTravel/TProcessorVainTravel.as')
source=(canonical/'TApplication.swf').read_bytes();(W/'source.swf').write_bytes(c.h.swap(source))
c.ff('-selectclass',','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in [SHOP,PROCESSOR]),'-export','script',W/'original',W/'source.swf')
before=(W/'original/scripts'/SHOP).read_text(encoding='utf-8');text=before
old='this.FVainTravelShopData.BuiedTime[_loc4_] != 0';assert old in text
text=text.replace(old,'this.FVainTravelShopData.BuiedTime[_loc4_] >= this.FVainTravelShopData.Configs[_loc4_].TotalTimes',1)
method=c.m.extract(text,'RenderShop');assert 'this.FGoodSlots[_loc3_].Context = null;' in method
text=text.replace(method,method.replace('this.FGoodSlots[_loc3_].Context = null;','this.FGoodSlots[_loc4_].Context = null;'),1)
method=c.m.extract(text,'BtnExchangeOnClick');new=method
token='         if(this.FVainTravelShopData.Configs[_loc3_].Price.amount';assert token in new
new=new.replace(token,'         if(_loc3_ < 0 || _loc3_ >= this.FVainTravelShopData.Configs.length || this.FVainTravelShopData.BuiedTime[_loc3_] >= this.FVainTravelShopData.Configs[_loc3_].TotalTimes) return;\n'+token,1)
token='this.FVainTravelCoinName));';assert token in new;new=new.replace(token,token+'\n            return;',1)
text=text.replace(method,new,1)
target=W/'patched'/SHOP;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
# Ignore a delayed buy response for an offer from a replaced shop snapshot.
text=(W/'original/scripts'/PROCESSOR).read_text(encoding='utf-8');method=c.m.extract(text,'MallBuyGoodRet');token='         ++this.FVainTravelData.VainTravelShopData.BuiedTime[_loc4_];';assert token in method
text=text.replace(method,method.replace(token,'         if(_loc4_ < 0) return;\n'+token,1),1)
target=W/'patched'/PROCESSOR;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
c.ff('-selectclass',','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in [SHOP,PROCESSOR]),'-export','script',W/'verify',W/'compiled.swf')
verified=(W/'verify/scripts'/SHOP).read_text(encoding='utf-8');assert '.TotalTimes' in verified and 'this.FGoodSlots[_loc4_].Context = null;' in verified
assert [t for t in c.h.tags((W/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((W/'compiled.swf').read_bytes()) if t[0]!=82]
active=json.loads((P/'client-release.json').read_text())['version'];assert active=='2026103104';assert source==(P/active/'TApplication.swf').read_bytes()
version='2026103105';dest=P/version;assert not dest.exists();dest.mkdir()
backup=W/'backup';backup.mkdir(exist_ok=True)
for name in ['TApplication.swf','version.swf']:shutil.copy2(canonical/name,backup/name)
shutil.copy2(P/'client-release.json',backup/'client-release.json')
rows=m.rows((canonical/'version.swf').read_bytes());tables=0
for row in rows:
 key,ver=[v.decode() for v in row]
 if key.startswith('Resources/Bin/') and key.endswith(('.bin','.binPackage')):
  src=next((p for p in [canonical/key,P/ver/key,P/'2017112917'/key] if p.is_file()),None)
  if src:
   dst=dest/key;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst);row[1]=version.encode();tables+=1
 if key=='TApplication.swf':row[1]=version.encode()
for src in (canonical/'Resources/Bin').rglob('*'):
 if src.is_file() and src.suffix in ('.bin','.binPackage'):
  dst=dest/src.relative_to(canonical)
  if not dst.exists():dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
client=c.h.swap((W/'compiled.swf').read_bytes());manifest=m.encode(rows)
for base in [canonical,dest]:(base/'TApplication.swf').write_bytes(client);(base/'version.swf').write_bytes(manifest)
shutil.copy2(canonical/'index.swf',dest/'index.swf');(P/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(W/'validation.json').write_text(json.dumps({'version':version,'artworkUnchanged':True,'tables':tables,'changedMethods':['RenderShop','BtnExchangeOnClick','MallBuyGoodRet'],'clientSha256':hashlib.sha256(client).hexdigest()},indent=2))
print('PASS Hueco native shop fixes and Fortune Coin offer release',version)
