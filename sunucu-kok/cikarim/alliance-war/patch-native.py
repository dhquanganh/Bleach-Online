"""Restore native Alliance playback while retaining the existing scene assets."""
def build(B,write):
 root=B/'native/scripts'
 def read(rel):return (root/rel).read_text(encoding='utf-8')
 def body(t,name,fn):
  a=t.index('function '+name+'(');start=t.index('{',a);depth=1;end=start+1
  while depth:
   if t[end]=='{':depth+=1
   if t[end]=='}':depth-=1
   end+=1
  return t[:a]+fn(t[a:end])+t[end:]
 rel='Processors/Game/TProcessorGameRoot.as';t=(B/'native-root/scripts'/rel).read_text(encoding='utf-8')
 t=body(t,'PacketPerform_ProcessorMiniBattle',lambda old:old.replace('{','{\n         if(!this.FProcessorMiniBattle.Visible)this.FProcessorLobby.Visible=false;',1))
 t=body(t,'ProcessorOnMiniBattleReturn',lambda old:old.replace('{','{\n         this.FProcessorLobby.Visible=true;',1));write(rel,t)
 rel='Processors/Game/MiniBattle/TProcessorMiniBattle.as';t=read(rel)
 anchor='   import Foundation.Network.TPacket;';assert anchor in t
 t=t.replace(anchor,anchor+'\n   import Foundation.Network.SNetworkCore;\n   import flash.external.ExternalInterface;')
 t=t.replace('      protected var FCurrentState:int;','      protected var FCurrentState:int;\n      protected var FAlliancePlaybackId:String="";')
 t=body(t,'PerformPacket_SC_MiniBattleHeadInfor',lambda old:'''function PerformPacket_SC_MiniBattleHeadInfor(param1:TPacket) : void
      {
         if(FIsResourcesLoadCompleted)this.Reset();
         this.Setup();
         this.Visible=true;
         this.FCurrentState=State_Unstreamization;
         this.FMiniBattleInfor.Reset();
         this.FUnstreamizerBattleInfor.UnstreamizationBattleInfor(param1.Data,this.FMiniBattleInfor,null);
         this.FAlliancePlaybackId=param1.Data.bytesAvailable>0?param1.Data.readUTF():"";
         if(ExternalInterface.available)ExternalInterface.call("allianceWarBattleStarted",this.FAlliancePlaybackId);
      }''')
 t=body(t,'ProcessorWindowOnClose',lambda old:old.replace('{','''{
         var finished:TPacket=SNetworkCore.PacketAcquire(0x01816303);
         finished.Data.writeUTF(this.FAlliancePlaybackId);
         SNetworkCore.Transceiver.PacketTransmit(finished);''',1).rsplit('}',1)[0]+'''         if(ExternalInterface.available)ExternalInterface.call("allianceWarBattleEnded");
      }''')
 write(rel,t)
 rel='Processors/Game/MiniBattle/Decoder/TUnstreamizerBattleInfor.as';t=read(rel)
 assert t.count('LastHp = param1.readUnsignedInt();')==2
 t=t.replace('LastHp = param1.readUnsignedInt();','LastHp = param1.readDouble();')
 for name in ['GetHpHurtByCampID','GetTotalHpHurtByCampID','GetTotalHpByCampID','GetCurrentHpByCampID']:
  def numbers(old):
   old=old.replace(') : int',') : Number',1)
   result='_loc7_' if name=='GetTotalHpHurtByCampID' else '_loc6_'
   return old.replace('var '+result+':int = 0;','var '+result+':Number = 0;')
  t=body(t,name,numbers)
 t=body(t,'GetEnemyLeaderInfor',lambda old:old.replace('return null;','return _loc5_.RoleCount>0?_loc5_.RoleBattleInfos[0]:null;'))
 needle='         _loc4_ = _loc10_.ScriptAction;';assert needle in t
 t=t.replace(needle,'         if(_loc10_==null)_loc10_=SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueAction,11100005) as TLeagueAction;\n'+needle,1);write(rel,t)
 rel='Processors/Game/MiniBattle/Decoder/TUnstreamizerScrip.as';t=read(rel);needle='         param2.ScriptAction = _loc3_.ScriptAction;';assert needle in t
 t=t.replace(needle,'         if(_loc3_==null)_loc3_=SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueAction,11100005) as TLeagueAction;\n'+needle,1);write(rel,t)
 rel='Processors/Game/MiniBattle/Mode/TBattleSoldierInfor.as';t=read(rel)
 for name in ['CurrentHP','TotalHP','LastHp']:
  t=t.replace('F'+name+':int','F'+name+':Number').replace('get '+name+'() : int','get '+name+'() : Number').replace('set '+name+'(param1:int)','set '+name+'(param1:Number)')
 write(rel,t)
 rel='Processors/Game/MiniBattle/Mode/TOneAttrack.as';t=read(rel)
 for name in ['MyBloodChangeValue','EnemyBloodChangeValue']:
  t=t.replace('F'+name+':int','F'+name+':Number').replace('get '+name+'() : int','get '+name+'() : Number').replace('set '+name+'(param1:int)','set '+name+'(param1:Number)')
 write(rel,t)
 rel='Processors/Game/MiniBattle/ScriptAction/TScriptActionCheckHP.as';t=read(rel).replace('var _loc1_:int = 0;','var _loc1_:Number = 0;').replace('var _loc6_:int = 0;','var _loc6_:Number = 0;');write(rel,t)
 rel='Processors/Game/MiniBattle/TComponentReportTable.as';t=read(rel);pos=t.index('   import ');t=t[:pos]+'   import flash.external.ExternalInterface;\n'+t[pos:]
 t=body(t,'ReportItemOnClick',lambda old:'''function ReportItemOnClick(param1:Object, param2:int) : void
      {
         var item:TListItemBattleReport=param1 as TListItemBattleReport;
         var address:String=this.FBattleReportAddr[int(item.UserData)];
         if(ExternalInterface.available)ExternalInterface.call("playAllianceWarReport",address);
      }''');write(rel,t)
