"""Incremental CoolSummer patch. Preserve combat code and all non-ABC SWF tags."""
from pathlib import Path
import hashlib,importlib.util,json,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('mecha',BASE.parent/'mecha-naruto/build-client.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
h=m.h
jar='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
U=Path('Logics/Streamization/HDCoolSummer/TUnstreamizerCoolSummer.as')
V=Path('Processors/Game/Lobby/Activity/HDCoolSummer/Windows/TProcessorCoolSummerView.as')
def ff(*args):subprocess.run(['java','-Xmx3g','-jar',jar,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 # Never rebuild on a different base silently.
 source=(BASE/'source.swf').read_bytes();assert source==decoded or old==h.swap((BASE/'compiled.swf').read_bytes()),'Current client differs from reviewed source and latest build'
 for rel in [U,V]:
  s=(BASE/'original/scripts'/rel).read_text(encoding='utf-8')
  if rel==U:
   s=s.replace('   import Logics.HDCoolSummer.TCoolSummerData;','   import Logics.HDCoolSummer.TCoolSummerData;\n   import Processors.Game.Utilities.EffectTextReward.SToolReward;')
   token='         if(this.DisposeShell(param1,param2,param3,param4))'
   s=s.replace(token,'''         if(param1==62000001 && param3.length==4)
         {
            param4.Config.MainAward.showID=uint(param3[0]);
            param4.Config.MainAward.score=uint(param3[1]);
            param4.Config.MainAward.revision=uint(param3[2]);
            param4.Config.MainAward.eventEnd=uint(param3[3]);
            return;
         }
'''+'''         if(param1==62000002)
         {
            var notice:String="";
            if(param2==1)notice="Opened: match two identical rewards to receive the item.";
            else if(param2==2)notice="Reward received! The item has been added to your main bag.";
            else if(param2==4)notice="Hot Sale hero received! Check your hero roster.";
            else if(param2==5)notice="Selection saved for the NEXT round. Click Refresh to start it.";
            else if(param2==6)notice="New round ready. Match two identical rewards to receive an item.";
            else if(param2==7)notice="Cannot receive reward: your bag or item stack is full. Free space and retry.";
            if(notice!="")SToolReward.ShowMessage(notice);
            return;
         }
'''+token,1)
   s=s.replace('for each(_loc5_ in param3)','for each(_loc5_ in param3)',1).replace('               _loc6_ = int(param4.AwardIDToPos[_loc5_]);','               if(param1>=param4.RandomItemIndexs.length || param4.AwardIDToPos[_loc5_]===undefined)continue;\n               _loc6_ = int(param4.AwardIDToPos[_loc5_]);',1)
  else:
   s=s.replace('   import flash.events.MouseEvent;','   import flash.events.MouseEvent;\n   import flash.utils.getTimer;')
   s=s.replace('      protected const ChooseMax:uint = 3;','      private var FFeastHero:uint=0;\n      private var FFeastPending:int=0;\n      protected const ChooseMax:uint = 3;')
   oldtime=m.extract(s,'UpdateUIConfig');s=s.replace(oldtime,'''      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.UpdateFeastTime();
      }
      private function UpdateFeastTime():void
      {
         if(this.FData==null)return;
         var end:uint=uint(this.FData.Config.MainAward.eventEnd);
         if(end>0){ProcessorFormatActivityTimeFromNowOn(end);ProcessorFormatActivityCountDown(end);}
         else{FIsInitCoolingTime=false;if(FTF_OpenTime!=null)FTF_OpenTime.text="Ongoing / Daily reset at midnight";if(FTF_CoolingTime!=null)FTF_CoolingTime.text="--";}
      }
      private function BeginFeastRequest():Boolean
      {
         if(getTimer()<this.FFeastPending)return false;
         this.FFeastPending=getTimer()+3000;
         return true;
      }''')
   s=s.replace('         this.FData = param1 as TCoolSummerData;','         this.FFeastPending=0;\n         this.FData = param1 as TCoolSummerData;\n         this.UpdateFeastTime();',1)
   render='         this.FShowAwardUI.SetData(this.FData.Config.MainAward.showType,this.FData.Config.MainAward.awardID,this.FData.Config.MainAward.showID,TOverlayerGiftBox.TYPE_ALL);'
   assert render in s;s=s.replace(render,'         if(this.FFeastHero!=uint(this.FData.Config.MainAward.showID)){this.FFeastHero=uint(this.FData.Config.MainAward.showID);\n'+render+'\n         }',1)
   s=s.replace('         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.MainAward.index);','         if(!this.BeginFeastRequest())return;\n         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.MainAward.index,0,Vector.<int>([int(this.FData.Config.MainAward.revision)]));',1)
   for name in ['OnRefreshBtnClickOK','OnChooseOKBtnClickOK','OnRandomItemClickOk','OnAllOpenBtnClickOK']:
    start=s.index('function '+name+'(');pos=s.index('{',start)+1;s=s[:pos]+'\n         if(!this.BeginFeastRequest())return;'+s[pos:]
   s=s.replace('         SToolReward.ShowMessage(this.FData.Config.Language.refreshSuccess);','').replace('         SToolReward.ShowMessage(this.FData.Config.Language.lock);','')
   # Release() discards the showcase texture, so reopen must render it again.
   start=s.index('function Reset(');pos=s.index('{',start)+1;s=s[:pos]+'\n         this.FFeastHero=0;this.FFeastPending=0;'+s[pos:]
  dest=BASE/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(s,encoding='utf-8')
 output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',BASE/'source.swf',output,BASE/'patched')
 rebuilt=output.read_bytes();assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass',','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in [U,V]),'-export','script',BASE/'verify',output)
 assert '62000001' in (BASE/'verify/scripts'/U).read_text();assert 'BeginFeastRequest' in (BASE/'verify/scripts'/V).read_text()
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=b'2026102011';found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw) and canonical.read_bytes()==old
 backup=BASE/'backups';backup.mkdir(exist_ok=True)
 for original in [canonical,version]:
  if not (backup/original.name).exists():shutil.copy2(original,backup/original.name)
 protected=h.swap(rebuilt);dest=h.PUBLIC/'2026102011/TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS native Anniversary Feast client 2026102011')
if __name__=='__main__':main()
