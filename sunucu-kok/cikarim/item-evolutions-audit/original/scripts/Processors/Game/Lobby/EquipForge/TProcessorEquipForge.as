package Processors.Game.Lobby.EquipForge
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.EquipForge.TEquipForge;
   import Logics.Streamization.EquipForge.TUnstreamizerEquipForge;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorEquipForge extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 657;
      
      protected static const WINDOW_HEIGTH:int = 433;
      
      protected const RESOURCESID_Swf:uint = 1090519040;
      
      protected var FMainWin:TProcessorWindowEquipForge;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamizer:TUnstreamizerEquipForge;
      
      protected var FData:TEquipForge;
      
      protected var FInited:Boolean;
      
      public function TProcessorEquipForge(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowEquipForge(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGTH;
         ComponentBoundsCenter(this.FMainWin,this.FBounds);
         this.FUnstreamizer = new TUnstreamizerEquipForge();
         this.FData = new TEquipForge();
         this.FInited = false;
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
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_InitRet,this.PacketPerform_SC_InitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_ForgeRet,this.PacketPerform_SC_ForgeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_AdvancedRet,this.PacketPerform_SC_AdvancedRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_WorkRet,this.PacketPerform_SC_WorkRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_BuyEnergyRet,this.PacketPerform_SC_BuyEnergyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_CompleteRet,this.PacketPerform_SC_CompleteRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_UltimateEquip_AwardRet,this.PacketPerform_SC_AwardRet);
      }
      
      protected function PacketPerform_SC_InitRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FData.Energy = param1.Data.readUnsignedInt();
         this.FData.BuyCount = param1.Data.readUnsignedInt();
         this.FData.TimeStamp = param1.Data.readUnsignedInt();
         this.FData.GetCount = param1.Data.readUnsignedInt();
         this.FMainWin.SetData(this.FData);
      }
      
      protected function PacketPerform_SC_ForgeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(70950001));
         this.FMainWin.ResetMake();
      }
      
      protected function PacketPerform_SC_AdvancedRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(70950002));
         this.FMainWin.ResetAdvance();
      }
      
      protected function PacketPerform_SC_WorkRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FData.Energy = param1.Data.readUnsignedInt();
         this.FData.TimeStamp = param1.Data.readUnsignedInt();
         this.FData.GetCount = param1.Data.readUnsignedInt();
         this.FMainWin.SetData(this.FData);
      }
      
      protected function PacketPerform_SC_BuyEnergyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FData.Energy = param1.Data.readUnsignedInt();
         this.FData.BuyCount = param1.Data.readUnsignedInt();
         this.FMainWin.SetData(this.FData);
      }
      
      protected function PacketPerform_SC_CompleteRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FData.TimeStamp = 0;
         this.FMainWin.SetData(this.FData);
      }
      
      protected function PacketPerform_SC_AwardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FData.GetCount = param1.Data.readUnsignedInt();
         SToolReward.ShowReward(param1.Data);
         this.FMainWin.SetData(this.FData);
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
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
         this.FMainWin.SetData(this.FData);
         this.FMainWin.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

