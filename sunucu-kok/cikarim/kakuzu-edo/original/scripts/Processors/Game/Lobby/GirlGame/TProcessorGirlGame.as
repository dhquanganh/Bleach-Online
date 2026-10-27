package Processors.Game.Lobby.GirlGame
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.GirlGame.TGirlGameInfor;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.GirlGame.Decoder.TUnstreamizerGameGirl;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_GIRLGAME;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorGirlGame extends TProcessorLobbyWindows
   {
      
      protected var FProcessorWindowGirlGame:TProcessorWindowGirlGame;
      
      protected var FGirlGameBounds:TBounds;
      
      protected var FGameInfor:TGirlGameInfor;
      
      protected var FUnstreamizerGameGirl:TUnstreamizerGameGirl;
      
      public function TProcessorGirlGame(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowGirlGame = new TProcessorWindowGirlGame(this);
         this.FProcessorWindowGirlGame.OnClose = this.CallBack_OnBtnClick;
         this.FProcessorWindowGirlGame.OnEffectText = ProcessorsOnEffectText;
         this.FGameInfor = new TGirlGameInfor();
         this.FUnstreamizerGameGirl = new TUnstreamizerGameGirl();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GIRLGAME.RESOURCE_GIRLGAME);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GirlGameInforRet,this.PacketPerform_GirlGameInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GirlGameUndressRet,this.PacketPerform_GirlGameUndressRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UndressOneKeyRet,this.PacketPerform_UndressOneKeyRet);
      }
      
      protected function PacketPerform_GirlGameInforRet(param1:TPacket) : void
      {
         this.FUnstreamizerGameGirl.Unstreamize(param1.Data,this.FGameInfor,null);
         this.FProcessorWindowGirlGame.ShowGirl(this.FGameInfor);
         this.FProcessorWindowGirlGame.Visible = true;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenGirlGame);
      }
      
      protected function PacketPerform_GirlGameUndressRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         SToolReward.ShowReward(param1.Data);
      }
      
      protected function PacketPerform_UndressOneKeyRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         SToolReward.ShowReward(param1.Data);
         this.FProcessorWindowGirlGame.OneKeySuccess();
      }
      
      protected function RequstGameInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GirlGameInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function LoadGameGirlInfor() : void
      {
         if(this.FGameInfor.GameGirls.length != 0)
         {
            return;
         }
         this.FUnstreamizerGameGirl.UnstreamizationByDataBase(null,this.FGameInfor,null);
      }
      
      protected function CallBack_OnBtnClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.LoadGameGirlInfor();
            this.FProcessorWindowGirlGame.Load();
            return;
         }
         this.RequstGameInfor();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowGirlGame.Reset();
         this.FProcessorWindowGirlGame.Visible = false;
      }
   }
}

