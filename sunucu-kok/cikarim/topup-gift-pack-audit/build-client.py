from pathlib import Path
import importlib.util,re,json
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 rel=Path('Processors/Game/Lobby/Activity/HDFirstPay/TProcessorHDFirstPay.as');before=(B/'original/scripts'/rel).read_text(encoding='utf-8');text=before
 old=c.m.extract(text,'PerformPacket_SC_FirstPayRet');new=old.replace('         _loc5_ = this.FFirstPayData.CountForAward() - 1;','         if(this.FFirstPayData.CountForAward() == 0)return;\n         _loc5_ = this.FFirstPayData.CountForAward() - 1;',1).replace('if(_loc6_ == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)','if(AllTopUpAwardsClaimed(this.FFirstPayData))',1);new=new.replace('         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateFirstPay(this.FActivityInitRetData,this.FFirstPayData,this.FFirstPay);','         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateFirstPay(this.FActivityInitRetData,this.FFirstPayData,this.FFirstPay);\n         if(this.FFirstPayData.CountForAward() == 0)return;\n         this.CheckState(this.FFirstPayData);',1);assert old!=new;text=text.replace(old,new,1)
 pos=text.rfind('   }');text=text[:pos]+'''      public static function AllTopUpAwardsClaimed(data:THDFirstPayData) : Boolean
      {
         if(data == null || data.CountForAward() == 0)return false;
         for(var i:uint = 0;i < data.CountForAward();i++)
         {
            if(data.GetAwardByIndex(i).State != CONST_ACTIVITY_MODE.Activity_AlreadyReceive)return false;
         }
         return true;
      }
'''+text[pos:]
 target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8');c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched');c.ff('-selectclass','Processors.Game.Lobby.Activity.HDFirstPay.TProcessorHDFirstPay','-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='PerformPacket_SC_FirstPayRet':assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 (B/'client-validation.json').write_text(json.dumps({'unchangedAssets':True,'unchangedMethods':count,'changedMethod':'PerformPacket_SC_FirstPayRet'},indent=2));print('PASS First Top-up native completion checks')
if __name__=='__main__':main()
