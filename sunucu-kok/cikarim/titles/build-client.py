from pathlib import Path
import importlib.util,subprocess,shutil,json,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('h',B.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
s=importlib.util.spec_from_file_location('r',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
paths=[]
def patch(rel,text):
 p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8');paths.append(rel)
rel=Path('Processors/Game/Lobby/Achievement/TProcessorAchievement.as');t=(B/'original/scripts'/rel).read_text();t=t.replace('      protected var FIfAlreadyInitTitle:Boolean;', '      protected var FIfAlreadyInitTitle:Boolean;\n      private var FTitleTimer:Timer;\n      private var FTitleReady:Boolean=false;');t=t.replace('         super(param1,param2);','''         super(param1,param2);
         this.FTitleTimer=new Timer(5000);
         this.FTitleTimer.addEventListener("timer",this.PollTitles);
         this.FTitleTimer.start();''',1);needle='      override protected function ResourcesPerform_UIRequest() : void';t=t.replace(needle,'''      private function PollTitles(event:Object):void
      {
         if(!this.FTitleReady)return;
         try{var packet:TPacket=SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievenmentTitleInforReq);SNetworkCore.Transceiver.PacketTransmit(packet);if(Visible&&!this.FShowOther){packet=SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementInforReq);SNetworkCore.Transceiver.PacketTransmit(packet);}}catch(error:Error){}
      }
'''+needle,1)
t=t.replace('         this.CheckIfCanGetReward();','         this.CheckIfCanGetReward();\n         if(Visible&&!this.FShowOther)this.FProcessorWindowAchievement.Update();',1)
needle='         this.ChangeCurrentEquipTitle(param1.Data);';t=t.replace(needle,'''         this.FTitleReady=true;
         for(var index:int=0;index<SLogicsCore.Character.AchievementData.Count;index++){
            var achievement:TAchievementInfor=SLogicsCore.Character.AchievementData.GetAchievementByIndex(index);
            if(achievement.Title!=null){achievement.Title.IfGetTitle=false;achievement.Title.IfOverTime=false;achievement.Title.TargetTime=0;}
         }
'''+needle,1)
t=t.replace('         this.AddAlreadyGetAchievementTitle(param1.Data,_loc2_);','         this.AddAlreadyGetAchievementTitle(param1.Data,_loc2_);\n         if(Visible)this.FProcessorWindowAchievement.Update();',1)
start=t.index('protected function PacketPerform_SC_EquipAchievenmentTitleRet');pos=t.index('            EffectGenerateTextByErrorCode(_loc4_);',start);t=t[:pos]+t[pos:].replace('            EffectGenerateTextByErrorCode(_loc4_);','            EffectGenerateTextByErrorCode(_loc4_);\n            return;',1)
start=t.index('protected function PacketPerform_SC_OtherAchievenmentInforRet');pos=t.index('            EffectGenerateTextByErrorCode(_loc2_);',start);t=t[:pos]+t[pos:].replace('            EffectGenerateTextByErrorCode(_loc2_);','            EffectGenerateTextByErrorCode(_loc2_);\n            return;',1)
t=t.replace('               SLogicsCore.Character.CurrentEquipTitles.Add(this.GotTitleByID(_loc4_));','               if(this.GotTitleByID(_loc4_)!=null)SLogicsCore.Character.CurrentEquipTitles.Add(this.GotTitleByID(_loc4_));',1)
old='''            _loc8_ = this.GotTitleByID(_loc9_);
            if(_loc8_ == null)
            {
               return;
            }
            _loc8_.IfOverTime = param1.readByte() == 1;
            _loc8_.TargetTime = param1.readUnsignedInt();''';assert old in t;t=t.replace(old,'''            var expired:Boolean=param1.readByte()==1;
            var expires:uint=param1.readUnsignedInt();
            _loc8_ = this.GotTitleByID(_loc9_);
            if(_loc8_ == null){_loc3_++;continue;}
            _loc7_=0;
            _loc8_.IfOverTime = expired;
            _loc8_.TargetTime = expires;''',1);patch(rel,t)
rel=Path('Processors/Game/Lobby/Achievement/TProcessorWindowTitle.as');t=(B/'original/scripts'/rel).read_text();t=t.replace('         var _loc3_:uint = 0;\n         if(param2 != null)','         var _loc3_:int = 0;\n         if(param2 != null)',1);t=t.replace('               _loc3_ = param2.TargetTime - STimingCore.ServerTick;\n               param1.text = TUtilityTiming.fomatTime(_loc3_);','''               _loc3_ = Math.max(0,Number(param2.TargetTime)-Number(STimingCore.ServerTick));
               if(_loc3_<=0){param2.IfOverTime=true;param1.text="Expired";}
               else param1.text = TUtilityTiming.fomatTime(_loc3_);''',1);patch(rel,t)
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
prior=(B/'compiled.swf').read_bytes() if (B/'compiled.swf').exists() else b''
ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
raw=(B/'compiled.swf').read_bytes();source=(B/'source.swf').read_bytes();assert [x for x in h.tags(source) if x[0]!=82]==[x for x in h.tags(raw) if x[0]!=82]
ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in paths),'-export','script',B/'verify',B/'compiled.swf')
for rel in paths:assert (B/'verify/scripts'/rel).exists()
version='2026102513';canonical=h.PUBLIC/'2026090619';old=(canonical/'TApplication.swf').read_bytes();assert h.swap(old) in [source,prior,raw],'Current client changed; refusing overwrite'
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
print('PASS native titles client',version)
