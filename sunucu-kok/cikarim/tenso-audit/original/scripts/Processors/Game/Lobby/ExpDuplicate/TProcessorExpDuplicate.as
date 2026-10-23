package Processors.Game.Lobby.ExpDuplicate
{
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.ExpDuplicate.TExpDuplicateData;
   import Logics.SLogicsCore;
   import Logics.Streamization.ExpDuplicate.TUnstreamizerExpDuplicate;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorExpDuplicate extends TProcessorLobbyWindows
   {
      
      protected const RESOURCESID_Swf:uint = 771751936;
      
      protected var FMainWin:TProcessorWindowExpDuplicate;
      
      protected var FUnstreamizer:TUnstreamizerExpDuplicate;
      
      protected var FData:TExpDuplicateData;
      
      protected var FOnInitBattle:Function;
      
      public function TProcessorExpDuplicate(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowExpDuplicate(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FData = SLogicsCore.ExpDuplicateData;
         this.FUnstreamizer = new TUnstreamizerExpDuplicate(this.FData);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ExpDuplicate_InitInfoRet,this.PacketPerform_SC_InitInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ExpDuplicate_SkillRet,this.PacketPerform_SC_SkillRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ExpDuplicate_RefreshRet,this.PacketPerform_SC_RefreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ExpDuplicate_FigntRet,this.PacketPerform_SC_FigntRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ExpDuplicate_BattleCountRet,this.PacketPerform_SC_BattleCountRet);
      }
      
      protected function PacketPerform_SC_InitInfoRet(param1:TPacket) : void
      {
         this.FUnstreamizer.InitRet(param1.Data);
         this.FMainWin.Visible = true;
         this.FMainWin.Update();
      }
      
      protected function PacketPerform_SC_SkillRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizer.SkillRet(param1.Data);
            this.FMainWin.OpenBattleWin();
         }
      }
      
      protected function PacketPerform_SC_RefreshRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizer.RefreshRet(param1.Data);
            this.FMainWin.Update();
         }
      }
      
      protected function PacketPerform_SC_FigntRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            if(this.FOnInitBattle != null)
            {
               this.FOnInitBattle(this);
            }
         }
      }
      
      protected function PacketPerform_SC_BattleCountRet(param1:TPacket) : void
      {
         this.FUnstreamizer.BattleCountRet(param1.Data);
         this.FMainWin.Update();
      }
      
      protected function PacketReqSuc(param1:TPacket) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return false;
         }
         return true;
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FMainWin.OnSetBattleStatus = param1;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         this.FUnstreamizer.InitReq();
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.Update();
         }
      }
   }
}

