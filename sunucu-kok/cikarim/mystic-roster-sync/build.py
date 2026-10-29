"""Fill missing active-hero fragment offers and publish only changed native tables."""
from pathlib import Path
import json,struct,zlib,subprocess,importlib.util,shutil
B=Path(__file__).resolve().parent;R=B.parents[1];P=R/'kaynak/login.gogames.me/public';D=R/'cikarim/veri-json';VERSION='2026102908'
def u32(n):return struct.pack('<I',n)
def utf(s):
 b=s.encode();return struct.pack('<H',len(b))+b
def records(raw):
 p=8;out=[]
 for _ in range(struct.unpack_from('<I',raw,4)[0]):
  start=p;ident=struct.unpack_from('<I',raw,p)[0];p+=12
  for _ in range(2):p+=2+struct.unpack_from('<H',raw,p)[0]
  p+=8;out.append((ident,raw[start:p]))
 assert p==len(raw);return out
def serialize(o):
 price=json.dumps(o['price'],separators=(',',':'));return u32(o['id'])+u32(1)+u32(o['itemID'])+utf(price)+utf(price)+u32(1)+u32(o['totalTimes'])
def main():
 active=json.loads((P/'client-release.json').read_text())['version'];assert active=='2026102907'
 allowed=set(json.loads(subprocess.check_output(['node','-e',"process.stdout.write(JSON.stringify(require('./sunucu/herolar').gecerliHerolar().map(h=>h.id)))"],cwd=R)))
 cfg=json.loads((R/'sunucu/mystic-shop-config.json').read_text());known={o['heroID'] for o in cfg['offers']};articles={int(a['id'],16) for a in json.loads((D/'Article.json').read_text())};added=[]
 for a in json.loads((D/'HeroChangeAttr.json').read_text()):
  hero=int(a['id'],16);item=int(a['chipValue'])
  if hero not in allowed or hero in known or not item:continue
  assert item in articles
  o={'id':30000000+hero,'model':1,'heroID':hero,'itemID':item,'number':1,'price':{'type':1,'code':cfg['currencyID'],'amount':100},'totalTimes':2147483647};assert all(x['id']!=o['id'] for x in cfg['offers']);cfg['offers'].append(o);added.append(o)
 assert len(added)==7
 additions={o['id']:serialize(o) for o in added}
 def patch(raw):
  if struct.unpack_from('<I',raw)[0]!=0x10000cb:return raw
  old=records(raw);assert not set(additions)&set(i for i,b in old)
  result=raw[:4]+u32(len(old)+len(additions))+b''.join(b for i,b in old)+b''.join(additions.values())
  check=dict(records(result));assert all(check[i]==b for i,b in old);return result
 def resource(data,key):
  if key.endswith('.bin'):
   try:return patch(data)
   except struct.error:return data
  p=6;parts=[data[:6]]
  for _ in range(struct.unpack_from('<H',data,4)[0]):
   n=struct.unpack_from('<I',data,p)[0];p+=4;c=data[p:p+n];p+=n;raw=zlib.decompress(c);new=patch(raw);c=zlib.compress(new) if new!=raw else c;parts.extend([u32(len(c)),c])
  return b''.join(parts)+data[p:]
 spec=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
 canonical=P/'2026090619';entries=m.rows((canonical/'version.swf').read_bytes());assert (P/active/'version.swf').read_bytes()==(canonical/'version.swf').read_bytes()
 backup=B/'backup';backup.mkdir(exist_ok=True);dest=P/VERSION;assert not dest.exists();changes={}
 for row in entries:
  key,version=[v.decode() for v in row]
  if not key.startswith('Resources/Bin/') or not key.endswith(('.bin','.binPackage')):continue
  src=P/version/key
  if not src.exists():src=canonical/key
  if not src.exists():continue
  data=src.read_bytes();new=resource(data,key)
  if new!=data:changes[key]=new;row[1]=VERSION.encode();target=backup/key;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
 assert changes
 for f in [canonical/'version.swf',P/'client-release.json',R/'sunucu/mystic-shop-config.json',D/'BlackMarket.json']:shutil.copy2(f,backup/f.name)
 table=json.loads((D/'BlackMarket.json').read_text())
 for o in added:table.append({'id':f"{o['id']:08X}",'model':1,'itemID':o['itemID'],'oldPrice':json.dumps(o['price'],separators=(',',':')),'price':json.dumps(o['price'],separators=(',',':')),'number':1,'totalTimes':o['totalTimes']})
 dest.mkdir()
 for key,data in changes.items():
  for folder in [canonical,dest]:target=folder/key;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
 for name in ['TApplication.swf','index.swf']:shutil.copy2(canonical/name,dest/name)
 data=m.encode(entries)
 for folder in [canonical,dest]:(folder/'version.swf').write_bytes(data)
 (R/'sunucu/mystic-shop-config.json').write_text(json.dumps(cfg,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');(D/'BlackMarket.json').write_text(json.dumps(table,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 (P/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n');(B/'release.json').write_text(json.dumps({'version':VERSION,'added':added,'resources':list(changes),'clientUnchanged':True},indent=2)+'\n');print('PASS',len(added),'new offers;',len(changes),'native resources; version',VERSION)
if __name__=='__main__':main()
