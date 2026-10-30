from pathlib import Path
import importlib.util,re,json
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 rel=Path('Processors/Game/Lobby/CollectSoul/TProcessorCollectSoul.as');before=(B/'original/scripts'/rel).read_text(encoding='utf-8');text=before
 old=c.m.extract(text,'PACKETID_SC_CollectSoul_MallRet');a=old.index('         _loc2_ = this.FShopID.length;');z=old.index('         _loc9_ = SResourcesCore',a)
 new=old[:a]+'''         this.RememberSoulClaim(_loc7_,_loc8_);\n'''+old[z:];text=text.replace(old,new,1)
 old=c.m.extract(text,'PacketPerform_SC_InitInfoRet');new=old.replace('         _loc9_ = param1.Data.readUnsignedInt();','         this.FData.SuperInvs.Clear();\n         _loc9_ = param1.Data.readUnsignedInt();',1);assert old!=new;text=text.replace(old,new,1)
 pos=text.rfind('   }');text=text[:pos]+'''      public function RememberSoulClaim(id:uint,time:uint) : void
      {
         if(this.FShopID == null)this.FShopID = new Vector.<uint>();
         if(this.FShopTime == null)this.FShopTime = new Vector.<uint>();
         var claimIndex:int = this.FShopID.indexOf(id);
         if(claimIndex >= 0)
         {
            this.FShopTime[claimIndex] = time;
         }
         else
         {
            this.FShopID.push(id);
            this.FShopTime.push(time);
         }
      }
'''+text[pos:]
 target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8');c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched');c.ff('-selectclass','Processors.Game.Lobby.CollectSoul.TProcessorCollectSoul','-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in ['PACKETID_SC_CollectSoul_MallRet','PacketPerform_SC_InitInfoRet']:assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 (B/'client-validation.json').write_text(json.dumps({'unchangedAssets':True,'unchangedMethods':count,'changedMethods':['PACKETID_SC_CollectSoul_MallRet','PacketPerform_SC_InitInfoRet']},indent=2));print('PASS cultivation native claim tracking and preview cleanup')
if __name__=='__main__':main()
