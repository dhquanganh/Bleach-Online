from pathlib import Path
import importlib.util,subprocess,shutil,json,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('h',B.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
s=importlib.util.spec_from_file_location('release',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
paths=[]
def patch(rel,text):
 p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8');paths.append(rel)
rel=Path('Logics/HDIceHeros/TActivityIceHeros.as');t=(B/'original/scripts'/rel).read_text();t=t.replace('      protected var FAwards:', '      public var Runtime:Object;\n      protected var FAwards:');patch(rel,t)
rel=Path('Logics/Streamization/HDActivitySingle/TUnstreamizerActivitySingle.as');t=(B/'original/scripts'/rel).read_text();needle='         _loc8_ = param3 as THDIceHeros;';assert needle in t
t=t.replace(needle,needle+'''
         var bp:Vector.<int> = _loc7_.ParameterVec;
         if(bp.length>6 && bp[2]==62000450){
            var runtime:Object={revision:bp[3],hero:bp[4],price:bp[5],rewards:[]};
            var pos:int=6;
            _loc8_.Awards[0].HeroID=uint(bp[4]);
            _loc8_.Awards[0].HeroType=1;
            _loc8_.Awards[0].Condition=uint(bp[5]);
            for(var bi:int=0;bi<5;bi++){
               var condition:int=bp[pos++];var count:int=bp[pos++];var items:Array=[];
               for(var bj:int=0;bj<count;bj++)items.push({type:bp[pos++],code:bp[pos++],amount:bp[pos++]});
               _loc8_.Awards[bi+2].Condition=uint(condition);
               runtime.rewards.push(items);
            }
            _loc6_.Runtime=runtime;
         }
''',1);t=t.replace('            _loc12_.Status = _loc9_[_loc4_].State;','            if(_loc12_!=null)_loc12_.Status = _loc9_[_loc4_].State;',1);patch(rel,t)
rel=Path('Processors/Game/Lobby/Activity/HDGeneralSell/TProcessorHDWindowGeneralSellHeros.as');t=(B/'original/scripts'/rel).read_text();t=t.replace('this.FCountOfHeros = this.FHDIceHeros.HeroIDs.length;','this.FCountOfHeros = 1;');needle='         this.FDataIceHeros = param1 as TActivityIceHeros;';assert needle in t
t=t.replace(needle,needle+'''
         if(this.FDataIceHeros.Runtime!=null){
            this.FCountOfHeros=1;
            this.FMC_HeroList[1].Visible=false;
            FInventoriesVect=new Vector.<TInventories>();
            for each(var rewards:Array in this.FDataIceHeros.Runtime.rewards){
               var fixed:Vector.<TFixedAward> =new Vector.<TFixedAward>();
               for each(var reward:Object in rewards)fixed.push(new TFixedAward(reward));
               FInventoriesVect.push(ProcessorGetInventories(0,fixed));
            }
            FIsInitCoolingTime=false;
            if(FTF_OpenTime!=null)FTF_OpenTime.text="Ongoing";
            if(FTF_CoolingTime!=null)FTF_CoolingTime.text="--";
            if(FTF_Desc!=null)FTF_Desc.text="Spend 10 Gold = 1 Crystal Piece. Unspent remainder carries over. Coupons do not count. Hero exchange and gift claims do not consume Pieces. Each gift's next milestone increases after claiming. Admin settings refresh automatically.";
         }
''',1)
t=t.replace('Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);','Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2,0,Vector.<int>([int(this.FDataIceHeros.Runtime.revision)]));',1)
# The original cyclic stage surcharge is replaced by server-provided exact next thresholds.
t=t.replace('this.FHDIceHeros.AddValue,this.FDataIceHeros.CurStage','0,0');patch(rel,t)
rel=Path('Processors/Game/Lobby/Activity/HDGeneralSell/TProcessorHDGeneralSellHeros.as');t=(B/'original/scripts'/rel).read_text();t=t.replace('   import Foundation.Common.*;','   import Foundation.Common.*;\n   import flash.utils.Timer;\n   import flash.events.TimerEvent;')
t=t.replace('      protected var FDataIceHeros:', '      private var FBPTimer:Timer;\n      protected var FDataIceHeros:');needle='         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();';t=t.replace(needle,needle+'''
         this.FBPTimer=new Timer(3000);
         this.FBPTimer.addEventListener(TimerEvent.TIMER,this.PollUltimateBP);
         this.FBPTimer.start();
''',1);needle='      override protected function ResourcesPerform_UIRequest() : void';t=t.replace(needle,'''      private function PollUltimateBP(event:TimerEvent):void
      {
         if(this.Visible && FCurAtoms!=null)Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
      }
'''+needle,1);patch(rel,t)
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
raw=(B/'compiled.swf').read_bytes();source=(B/'source.swf').read_bytes();assert [x for x in h.tags(source) if x[0]!=82]==[x for x in h.tags(raw) if x[0]!=82]
ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in paths),'-export','script',B/'verify',B/'compiled.swf')
for rel in paths:assert (B/'verify/scripts'/rel).exists()
version='2026102508';canonical=h.PUBLIC/'2026090619';old=(canonical/'TApplication.swf').read_bytes();assert h.swap(old) in [source,raw],'Current client changed; refusing overwrite'
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
print('PASS native Ultimate BP client',version)

