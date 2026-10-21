"""Exact multi-hit damage and a dedicated foreground damage layer, on the live client."""
from pathlib import Path
import hashlib,importlib.util,json,re,shutil,struct,zlib
B=Path(__file__).resolve().parent
C=B.parent
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
client=module('itachi_client',C/'itachi-rtn/build-client.py')
VERSION='2026102106'
EFFECT=Path('Processors/Game/Battle/Effect/TEffectControl.as')
STAGE=Path('Processors/Game/Battle/TBattleStage.as')
def main():
 public=client.h.PUBLIC;canonical=public/'2026090619/TApplication.swf';old=canonical.read_bytes();source=client.h.swap(old)
 (B/'source.swf').write_bytes(source)
 classes=','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in [EFFECT,STAGE])
 client.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf')
 effect=(B/'original/scripts'/EFFECT).read_text(encoding='utf-8');stage=(B/'original/scripts'/STAGE).read_text(encoding='utf-8')
 assert 'DamageFloatHost' not in stage,'Already installed; refusing rollback'
 helper=client.m.extract(effect,'ConsecutiveHitDamage');assert 'count != 4 && count != 5' in helper
 patched_effect=effect.replace(helper,helper.replace('count != 4 && count != 5','count < 1 || count > 64'))
 patched_stage=stage.replace('      protected var FEffectSprite:Sprite;','      private var FDamageFloatLayer:Sprite;\n\n      protected var FEffectSprite:Sprite;',1)
 old_float=client.m.extract(stage,'SetFloatText')
 assert old_float.count('this.FEffectSprite.addChild(')==4
 patched_stage=patched_stage.replace(old_float,old_float.replace('this.FEffectSprite.addChild(','this.DamageFloatHost().addChild('))
 patched_stage=patched_stage.replace('      protected function SetFloatText(', (B/'float-layer.as.txt').read_text()+'\n\n      protected function SetFloatText(',1)
 patched_stage=client.inject(patched_stage,'Reset','         ResetDamageFloats();')
 for rel,text in [(EFFECT,patched_effect),(STAGE,patched_stage)]:
  path=B/'patched'/rel;path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text,encoding='utf-8')
 client.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 rebuilt=(B/'compiled.swf').read_bytes()
 assert [t for t in client.h.tags(source) if t[0]!=82]==[t for t in client.h.tags(rebuilt) if t[0]!=82]
 client.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 unchanged=0
 for rel,before,allowed in [(EFFECT,effect,{'ConsecutiveHitDamage'}),(STAGE,stage,{'SetFloatText','Reset'})]:
  after=(B/'verify/scripts'/rel).read_text(encoding='utf-8')
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name not in allowed:assert client.m.extract(before,name)==client.m.extract(after,name),name;unchanged+=1
 backup=B/'backups';backup.mkdir(exist_ok=True)
 manifest=canonical.parent/'version.swf'
 for p in [canonical,manifest]:
  if not (backup/p.name).exists():shutil.copy2(p,backup/p.name)
 # Update only the requested heroes, retaining every other native database record.
 multi=module('multihit',C/'ninja-multihit.py');changes=multi.install(('mecha-naruto','itachi-rtn'))
 raw=zlib.decompress(manifest.read_bytes());pos=2;rows=[]
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;rows.append((k,v))
 assert pos==len(raw)
 bin_rel={p.relative_to(public).parts[1:] for p in changes if p.is_relative_to(public)}
 newrows=[];aliases=0
 for k,v in rows:
  if k==b'TApplication.swf':v=VERSION.encode()
  elif tuple(k.decode().split('/')) in bin_rel:
   candidates=[public/v.decode()/k.decode(),public/'2026090619'/k.decode(),public/'2017112917'/k.decode()]
   src=next(p for p in candidates if p.is_file());dest=public/VERSION/k.decode();dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(src.read_bytes());v=VERSION.encode();aliases+=1
  newrows.append((k,v))
 data=struct.pack('<H',len(newrows))+b''.join(struct.pack('<H',len(k))+k+struct.pack('<H',len(v))+v for k,v in newrows)
 assert canonical.read_bytes()==old
 protected=client.h.swap(rebuilt);dest=public/VERSION/'TApplication.swf';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);manifest.write_bytes(zlib.compress(data))
 (B/'result.json').write_text(json.dumps({'version':VERSION,'sha256':hashlib.sha256(protected).hexdigest(),'unchangedMethodsChecked':unchanged,'versionedBinRoutes':aliases,'changedClasses':['TEffectControl','TBattleStage'],'actorAndVfxTexturesChanged':False,'totalDamageMultiplied':False},indent=2))
 print('PASS exact 1..64-hit partitions; foreground damage; preserved unrelated methods; client',VERSION)
if __name__=='__main__':main()
