"""Extend the current Flash client; retain all unrelated ABC methods and UI tags."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;VERSION=b'2026102009'
def extract(s,name):
 start=re.search(r'      (?:override )?(?:public|private|protected) (?:static )?function '+name+r'\(',s).start();return s[start:b.method_end(s,start)]
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');a=p.parse_args()
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old);(BASE/'source.swf').write_bytes(decoded)
 classes=','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in [b.ROLE,b.ACTIVE,b.STAGE,b.FORMATION])
 def ff(*args):subprocess.run(['java','-Xmx3g','-jar',a.ffdec,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
 ff('-selectclass',classes,'-export','script',BASE/'original',BASE/'source.swf')
 before=(BASE/'original/scripts'/b.ROLE).read_text()
 if 'function UpdateMechaVfx(' in before:
  assert old==h.swap((BASE/'compiled.swf').read_bytes()),'Client changed outside this builder; refusing rollback'
  backup=BASE/'backups/TApplication.swf';assert backup.exists();decoded=h.swap(backup.read_bytes());(BASE/'source.swf').write_bytes(decoded);ff('-selectclass',classes,'-export','script',BASE/'original',BASE/'source.swf');before=(BASE/'original/scripts'/b.ROLE).read_text()
 role=before;assert 'function UpdateMechaVfx(' not in role
 role=role.replace('      private var FCombatVfxSerial:', '      private var FMechaVfxStarted:Boolean=false;\n      private var FMechaActiveVfx:Array=[];\n      private static var FMechaFxCache:Object={};\n      private static var FMechaFxLoading:Object={};\n      private var FCombatVfxSerial:',1)
 runtime='\n'.join(extract(before,n).replace('Hashirama','Mecha').replace('hashirama','mecha').replace('13121009','13121199') for n in ['PreloadHashiramaVfx','LoadHashiramaVfxAtlas','TrimHashiramaVfxCache','PlayHashiramaVfxAsset'])
 data=json.loads((BASE/'vfx.json').read_text());anim=json.loads((BASE/'animation.json').read_text());data.update(moves=anim['moves'],actions=anim['effects'])
 streams=json.loads((BASE/'streaming.json').read_text());assert set(streams)==set(data['atlases'])
 for key,meta in data['atlases'].items():
  stream=h.PUBLIC.parent/meta['url'].lstrip('/')
  assert hashlib.sha256(stream.read_bytes()).hexdigest()==streams[key]['sourcePngSha256'],key
  assert hashlib.sha256(stream.with_suffix('.argb').read_bytes()).hexdigest()==streams[key]['fileSha256'],key
 runtime=runtime.replace('["Zhujianzhongyanhuashujiejianglin","Zhujianzhongyanmingshenfenglong","Zhujianzhongyanmingshenfenglong_texie"]',json.dumps(sorted(set(e for effects in anim['effects'].values() for e in effects))))
 runtime=runtime.replace('if(key != keep &&','if(key != keep && !MechaFirstAtlas(key) &&')
 runtime+='\n      private static function MechaFirstAtlas(key:String):Boolean{var m:Object=MechaVfxManifest();for each(var c:Object in m.clips)if(String(c.atlas)==key)return true;return false;}\n'
 runtime+='\n      private static function MechaVfxManifest() : Object {return JSON.parse('+json.dumps(json.dumps(data,separators=(',',':')))+');}\n'+(BASE/'runtime.as.txt').read_text()
 role=role.replace('      override public function UpdateActive()',runtime+'\n      override public function UpdateActive()',1)
 role=role.replace('         ++FCombatVfxSerial;','         ++FCombatVfxSerial;\n         if(FId==11120950){FMechaVfxStarted=false;if(FSkillId==13121109)FMechaBeast=true;}',1)
 role=role.replace('         this.UpdateHashiramaVfx();','         this.UpdateHashiramaVfx();\n         this.UpdateMechaVfx();',1)
 role=role.replace('            this.HashiramaStrikePose(_loc4_);','            this.HashiramaStrikePose(_loc4_);\n            this.MechaStrikePose(_loc4_);\n            this.FitMechaPose();',1)
 start=role.index('      public function PrepareBattleRole(');body=role.index('{',start)+1;role=role[:body]+'\n         if(FId==11120950)PreloadMechaVfx();\n'+role[body:]
 start=role.index('      public function AddTextEffectByCMD(');body=role.index('{',start)+1
 labels='''
         var mechaMarker:uint=uint(param1.ResultInfo.BuffId);
         if(param1.CMD==TTargetInfo.CMD_FLOAT && mechaMarker>=19001001 && mechaMarker<=19001015)
         {
            var mechaNames:Array=["","CHAKRA BOMB / INTERRUPTION","SUPPRESS SUPER ARMOR","MYSTERY COOLDOWN +1","TEAM MYSTERY COST REDUCED","IMMOBILE / MODIFIED RASENGAN","SUPPRESS IMMUNITY","STOLEN STANDARD ATTACKS","ADVANCE TECHNOLOGY","JET / CHAKRA +20","TAILED BEAST MODE","ENERGY RECOVERY / ADVANCED IMMUNITY","MYSTERY LOCKED AT 1","KURAMA ATK GROWTH","LEVEL 2 IGNITION","INFLAMMATION"];
            var mechaMessage:String=mechaNames[mechaMarker-19001000];
            if(mechaMarker==19001007)mechaMessage+=" +"+param1.ResultInfo.BuffTurn;
            if(mechaMarker==19001008)mechaMessage+=" ATK +"+(int(param1.ResultInfo.BuffTurn)*15)+"% CRIT +"+(int(param1.ResultInfo.BuffTurn)*8)+"%";
            ShowHashiramaStatusText(mechaMessage,0xFFD36B);return;
         }
'''
 role=role[:body]+labels+role[body:]
 active=(BASE/'original/scripts'/b.ACTIVE).read_text()
 active=active.replace('      protected var FTextures:', '      protected var FMechaBeast:Boolean=false;\n      protected var FTextures:',1)
 def inject(s,name,text):start=s.index('function '+name+'(');body=s.index('{',start)+1;return s[:body]+'\n'+text+'\n'+s[body:]
 active=inject(active,'Reset','         this.FMechaBeast=false;')
 active=inject(active,'IsSkill','         if(this.FId==11120950 && param1>=13121101 && param1<=13121113)return param1!=13121102 && param1!=13121103;')
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(this.FId==11120950 && this.FTextureAttack.Count>=2)_loc1_=uint(this.FSkillId==13121103?1:0);\n'+token,1)
 active=inject(active,'PlaySkill','         if(this.FId==11120950 && (this.FSkillId==13121102 || this.FSkillId==13121103)){this.FCallBackDict[TYPE_ACTIVE_ATTACK]=this.FCallBackDict[TYPE_ACTIVE_SKILL];this.FTimeDict[TYPE_ACTIVE_ATTACK]=this.FTimeDict[TYPE_ACTIVE_SKILL];this.PlayAttack();return;}')
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert token in active;active=active.replace(token,'         if(this.FId==11120950 && this.FTextureSkill.Count>=11)_loc1_=uint(this.FSkillId==13121104?1:this.FSkillId==13121105?2:this.FSkillId==13121106?3:this.FSkillId==13121107?4:this.FSkillId==13121108?5:this.FSkillId==13121109?6:this.FSkillId==13121110?7:this.FSkillId==13121111?8:this.FSkillId==13121112?9:this.FSkillId==13121113?10:0);\n'+token,1)
 active=active.replace('this.FCurSequence = this.FTextureFightIdle.GetAnimationSequenceByIndex(0);','this.FCurSequence = this.FTextureFightIdle.GetAnimationSequenceByIndex(this.FId==11120950 && this.FMechaBeast && this.FTextureFightIdle.Count>1?1:0);')
 for texture in ['FightIdle','Run','Attacked']:
  token='         this.FCurSequence = this.FTexture'+texture+'.GetAnimationSequenceByIndex(_loc1_);';assert token in active
  active=active.replace(token,'         if(this.FId==11120950)_loc1_=uint(this.FMechaBeast && this.FTexture'+texture+'.Count>1?1:0);\n'+token,1)
 stage=(BASE/'original/scripts'/b.STAGE).read_text().replace('battleRasterHost.getChildAt(battleRasterIndex).name == "hashiramaSkillVfx"','(battleRasterHost.getChildAt(battleRasterIndex).name == "hashiramaSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "mechaSkillVfx")')
 formation=(BASE/'original/scripts'/b.FORMATION).read_text();formation=formation.replace('this.FSelectHero.Identifier == 11120940','(this.FSelectHero.Identifier == 11120940 || this.FSelectHero.Identifier == 11120950)').replace('this.FSelectHero.Identifier != 11120940','(this.FSelectHero.Identifier != 11120940 && this.FSelectHero.Identifier != 11120950)')
 optimizer=importlib.util.spec_from_file_location('optimizer',BASE/'optimize-runtime.py');opt=importlib.util.module_from_spec(optimizer);optimizer.loader.exec_module(opt)
 role=opt.optimize(role,extract)
 for rel,text in [(b.ROLE,role),(b.ACTIVE,active),(b.STAGE,stage),(b.FORMATION,formation)]:
  dest=BASE/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text)
 output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',BASE/'source.swf',output,BASE/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass',classes,'-export','script',BASE/'verify',output)
 verified=(BASE/'verify/scripts'/b.ROLE).read_text()
 for token in ['UpdateMechaVfx','MechaStrikePose','mechaSkillVfx','13121108','UpdateHashiramaVfx','UpdatePainVfx','UpdateObitoVfx']:assert token in verified,token
 changed={'PrepareBattleRole','ActivePlay','UpdateActive','UpdateAnimationFrame','AddTextEffectByCMD'}
 for name in re.findall(r'      private (?:static )?function (\w+)\(',before):
  if name not in changed:assert extract(before,name)==extract(verified,name),name
 if a.install:
  assert canonical.read_bytes()==old;version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
   if k==b'TApplication.swf':v=VERSION;found+=1
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  assert found==1 and pos==len(raw);backup=BASE/'backups';backup.mkdir(exist_ok=True)
  for original in [canonical,version]:
   if not (backup/original.name).exists():shutil.copy2(original,backup/original.name)
  protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS Mecha Flash client',VERSION.decode(),'installed',a.install)
if __name__=='__main__':main()
