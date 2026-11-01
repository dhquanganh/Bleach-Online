"""Publish the verified Ryoka client and matching native text at a fresh cache URL."""
from pathlib import Path
import importlib.util,json,hashlib,struct,zlib,shutil
B=Path(__file__).resolve().parent;R=B.parents[1];P=R/'kaynak/login.gogames.me/public';C=P/'2026090619';VERSION='2026103101'
spec=importlib.util.spec_from_file_location('manifest',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
def swap(data):
 d=bytearray(data)
 for a,b in [(1,10),(20,200)]:d[a],d[b]=d[b],d[a]
 return bytes(d)
def tags(data):
 raw=data[:8]+zlib.decompress(data[8:]);assert len(raw)==struct.unpack_from('<I',raw,4)[0]
 pos=8+(5+4*(raw[8]>>3)+7)//8+4;out=[]
 while pos<len(raw):
  head=struct.unpack_from('<H',raw,pos)[0];pos+=2;kind,n=head>>6,head&63
  if n==63:n=struct.unpack_from('<I',raw,pos)[0];pos+=4
  out.append((kind,raw[pos:pos+n]));pos+=n
  if kind==0:break
 assert pos==len(raw);return out
def main():
 active=json.loads((P/'client-release.json').read_text())['version'];source=(B/'source.swf').read_bytes();compiled=(B/'compiled.swf').read_bytes();old=(C/'TApplication.swf').read_bytes()
 assert swap(old)==source,'Current client changed during build'
 assert old==(P/active/'TApplication.swf').read_bytes()
 assert [t for t in tags(source) if t[0]!=82]==[t for t in tags(compiled) if t[0]!=82],'Non-code assets changed'
 verified=B/'verify/scripts'
 t=(verified/'Processors/Game/Lobby/TraitorAttack/TProcessorTraitorAttack.as').read_text(encoding='utf8')
 for token in ['DeferRyoka','new TPacket(0,bytes)','EntryDeadSeconds','this.FightPending = true;','this.FProcessorWindowResurrection.OnResurrection = this.OnResurrection;','this.FProcessorWindowResurrection.StartCountdown(until,_loc2_);']:assert token in t,token
 assert 'TBattleHandle.IsInBattle = true;' not in t
 battle=(verified/'Processors/Game/Battle/TBattleHandle.as').read_text(encoding='utf8');assert 'this.FEnterType == ENTER_TYPE_CITYDEFEND || this.FEnterType == ENTER_TYPE_TRAITORATTACK' in battle
 menu=(verified/'Processors/Game/Lobby/DailyActivity/TProcessorDailyActivity.as').read_text(encoding='utf8');assert '_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD || _loc2_.ActivityType == TYPE_ORGACTIVITY_TRAITORATTACK' in menu
 file=R/'cikarim/veri-json/DailyActivity.json';rows=json.loads(file.read_text(encoding='utf8'));row=next(r for r in rows if r['activityType']==8);before=dict(row)
 row.update(activityTime='["Event Start Time: ","00:00 - 24:00"]',activityDescription='Open all day. Each personal run lasts 30 minutes. Five Ryoka per wave; 10 seconds between waves. Re-entering preserves HP, damage and cooldown.',activityRewards='Damage grants Silver, EXP and Souls immediately. Killing a Ryoka grants 1 Common Material Chest, or 1 Epic Material Chest on every fifth wave. The damage list and clan score show this personal run. No offline registration or ranking mail.')
 pairs=[(before[k],row[k]) for k in ['activityTime','activityDescription','activityRewards']]
 langFile=R/'cikarim/veri-json/SystemLanguage.json';lang=json.loads(langFile.read_text(encoding='utf8'));helpRow=next(r for r in lang if r['id'].upper()=='042EB5A9');oldHelp=helpRow['desc'];helpRow['desc']='<p><font color="#66FF66">Ryoka Attack</font><br/>Open all day. Personal runs last 30 minutes, up to 100 waves of five Ryoka. Wait 10 seconds between waves. Damage grants Silver, EXP and Souls; kills grant material chests. Progress and cooldown persist when re-entering. Damage ranking and clan score are local to your run. No offline registration or ranking mail.</p>';pairs.append((oldHelp,helpRow['desc']))
 pairs=[(struct.pack('<H',len(a.encode()))+a.encode(),struct.pack('<H',len(b.encode()))+b.encode()) for a,b in pairs];hits=[0]*len(pairs)
 def patch(raw):
  for i,(a,b) in enumerate(pairs):hits[i]+=raw.count(a);raw=raw.replace(a,b)
  return raw
 manifest=m.rows((C/'version.swf').read_bytes());changes={}
 for key,ver in manifest:
  name=key.decode()
  if not name.startswith('Resources/Bin/') or not name.endswith(('.bin','.binPackage')):continue
  src=next((p for p in [P/ver.decode()/name,C/name,P/'2017112917'/name] if p.is_file()),None)
  if src is None:continue
  data=src.read_bytes()
  if name.endswith('.bin'):updated=zlib.compress(patch(zlib.decompress(data)))
  else:
   pos=6;parts=[data[:6]]
   for _ in range(struct.unpack_from('<H',data,4)[0]):
    n=struct.unpack_from('<I',data,pos)[0];pos+=4;block=data[pos:pos+n];pos+=n;raw=zlib.decompress(block);new=patch(raw)
    if new!=raw:block=zlib.compress(new)
    parts.extend([struct.pack('<I',len(block)),block])
   updated=b''.join(parts)+data[pos:]
  if updated!=data:changes[name]=updated
 assert all(hits),('Native strings not found',hits)
 dest=P/VERSION;assert not dest.exists(),'Release already exists'
 backup=B/'release-backup';backup.mkdir(exist_ok=True)
 for f in [C/'TApplication.swf',C/'version.swf',P/'client-release.json',file,langFile]:shutil.copy2(f,backup/f.name)
 dest.mkdir()
 for key,data in changes.items():
  target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
 for row in manifest:
  if row[0].decode() in changes or row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 data=m.encode(manifest);protected=swap(compiled)
 for directory in [dest,C]:(directory/'TApplication.swf').write_bytes(protected);(directory/'version.swf').write_bytes(data)
 shutil.copy2(C/'index.swf',dest/'index.swf')
 file.write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf8');langFile.write_text(json.dumps(lang,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
 pointer=P/'client-release.json';temp=pointer.with_suffix('.tmp');temp.write_text(json.dumps({'version':VERSION})+'\n');temp.replace(pointer)
 report={'version':VERSION,'nativeStringMatches':hits,'resources':list(changes),'sha256':hashlib.sha256(protected).hexdigest(),'nonCodeAssetsUnchanged':True}
 (B/'release.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
