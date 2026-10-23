from pathlib import Path
import struct,zlib,json,shutil,subprocess,importlib.util
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('helpers',B.parent/'flash-refinery/build.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
P=h.CLIENT.parent.parent;C=h.CLIENT.parent;V='2026102324';release=P/V
assert not release.exists()
(B/'source.swf').write_bytes(h.swap(h.CLIENT.read_bytes()))
jar=B.parents[2]/'.tools/ffdec/ffdec-cli.jar'
r=subprocess.run(['java','-Xmx2g','-jar',str(jar),'-onerror','abort','-importScript',str(B/'source.swf'),str(B/'compiled.swf'),str(B/'patched')],capture_output=True,text=True,errors='replace')
if r.returncode:raise RuntimeError(r.stdout+r.stderr)
new=(B/'compiled.swf').read_bytes();assert [t for t in h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in h.tags(new) if t[0]!=82]

def patch(data):
 pos=6;parts=[data[:6]];changed=0
 for _ in range(struct.unpack_from('<H',data,4)[0]):
  n=struct.unpack_from('<I',data,pos)[0];pos+=4;block=data[pos:pos+n];pos+=n;raw=zlib.decompress(block)
  # DailyTask resource ID 0x01000013; only point values change.
  if raw[:4]==struct.pack('<I',0x01000013):
   raw=bytearray(raw);o=8
   def skipstr(o):return o+2+struct.unpack_from('<H',raw,o)[0]
   for i in range(struct.unpack_from('<I',raw,4)[0]):
    o+=12;o=skipstr(o);o+=4;struct.pack_into('<I',raw,o,15);o+=8;o=skipstr(o);o+=8;o=skipstr(o);o+=4;o=skipstr(o)
   assert o==len(raw);block=zlib.compress(raw);changed+=1
  # Match full rows so unrelated rewards are untouched, regardless of language.
  else:
   replaced=0
   for row in json.loads((B.parent/'veri-json/DailyAward.json').read_text(encoding='utf-8')):
    if row['mark']!=150:continue
    old=b'[{"type":1,"code":14100140,"amount":2}]';value=row['rewards'].encode()
    oldrow=struct.pack('<IIIH',int(row['id'],16),150,row['level1'],len(old))+old
    newrow=struct.pack('<IIIH',int(row['id'],16),150,row['level1'],len(value))+value
    if oldrow in raw:assert raw.count(oldrow)==1;raw=raw.replace(oldrow,newrow);replaced+=1
    elif newrow in raw:replaced+=1
   if replaced:assert replaced==5;block=zlib.compress(raw);changed+=1
  parts.extend([struct.pack('<I',len(block)),block])
 parts.append(data[pos:]);return b''.join(parts),changed
changes=[]
for f in (C/'Resources/Bin').rglob('*.binPackage'):
 d,n=patch(f.read_bytes())
 if n:assert n==2;changes.append((f,d))
assert len(changes)>=3
backup=B/('backups-'+V);backup.mkdir(exist_ok=True)
for f in [h.CLIENT,C/'version.swf',P/'client-release.json']:shutil.copy2(f,backup/f.name)
release.mkdir();names={b'TApplication.swf'}
for f,d in changes:
 rel=f.relative_to(C);saved=backup/rel;saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,saved);f.write_bytes(d);dest=release/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(d);names.add(rel.as_posix().encode())
h.CLIENT.write_bytes(h.swap(new));raw=zlib.decompress((C/'version.swf').read_bytes());pos=2;rows=[]
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;rows.append((k,V.encode() if k in names else v))
assert pos==len(raw)
for k in names-{k for k,v in rows}:rows.append((k,V.encode()))
(C/'version.swf').write_bytes(zlib.compress(struct.pack('<H',len(rows))+b''.join(struct.pack('<H',len(k))+k+struct.pack('<H',len(v))+v for k,v in rows)))
for name in ['TApplication.swf','index.swf','version.swf']:shutil.copy2(C/name,release/name)
p=P/'client-release.json';temp=p.with_suffix('.tmp');temp.write_text(json.dumps({'version':V})+'\n');temp.replace(p)
print('PASS client and',len(changes),'data packages published',V)
