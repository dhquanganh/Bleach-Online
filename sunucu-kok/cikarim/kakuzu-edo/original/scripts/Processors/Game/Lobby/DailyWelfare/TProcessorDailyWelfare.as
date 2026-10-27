package Processors.Game.Lobby.DailyWelfare
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.Dailywelfare.*;
   import Logics.Streamization.DailyWelfare.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorDailyWelfare extends TProcessorLobbyWindows
   {
      
      public static const SIZE_Width:uint = 661;
      
      public static const SIZE_Height:uint = 519;
      
      protected var FProcessorWindowDailyWelfare:TProcessorWindowDailyWelfare;
      
      protected var FData_DailyWelfare:TDailyWelfare;
      
      protected var FUnstreamizerDailyWelfare:TUnstreamizerDailyWelfare;
      
      protected var FOnEffectShortcut:Function;
      
      public function TProcessorDailyWelfare(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,FParameters);
         this.FProcessorWindowDailyWelfare = new TProcessorWindowDailyWelfare(this);
         this.FProcessorWindowDailyWelfare.Visible = false;
         this.FProcessorWindowDailyWelfare.OnClose = this.ProcessorOnClose;
         this.FProcessorWindowDailyWelfare.OnEffectText = ProcessorsOnEffectText;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_Width;
         _loc3_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowDailyWelfare,_loc3_);
         _loc3_ = null;
         this.FUnstreamizerDailyWelfare = new TUnstreamizerDailyWelfare();
         this.InitData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DAILYWELFARE.RESOURCESID_Swf_DailyWelf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyWelfare_DailyWelfareRet,this.PacketPerform_SC_DailyWelfareRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyWelfare_GetBackRet,this.PacketPerform_SC_GetBackRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyWelfare_InforRet,this.PacketPerform_SC_InforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyWelfare_OneKeyRet,this.PacketPerform_SC_OneKeyRet);
      }
      
      protected function InitData() : void
      {
         var _loc1_:TGetBackItem = null;
         var _loc2_:TWelfareItem = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData_DailyWelfare = new TDailyWelfare();
         this.FData_DailyWelfare.GetBackItems = new Vector.<TGetBackItem>();
         this.FData_DailyWelfare.WelfareItems = new Vector.<TWelfareItem>();
         _loc4_ = CONST_DAILYWELFARE.CAPACITY_GETBACKITEMS;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = new TGetBackItem();
            this.FData_DailyWelfare.GetBackItems.push(_loc1_);
            _loc3_++;
         }
         _loc4_ = CONST_DAILYWELFARE.CAPACITY_WELFAREITEMS;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = new TWelfareItem();
            this.FData_DailyWelfare.WelfareItems.push(_loc2_);
            _loc3_++;
         }
         this.FProcessorWindowDailyWelfare.Data_DailyWelfare = this.FData_DailyWelfare;
      }
      
      protected function PacketPerform_SC_OneKeyRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         _loc4_ = param1.Data;
         _loc5_ = _loc4_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         this.FUnstreamizerDailyWelfare.UnstreamizeUpdateAllItem(_loc4_,this.FData_DailyWelfare,null);
         _loc6_ = false;
         _loc3_ = this.FData_DailyWelfare.WelfareItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.WelfareItems[_loc2_].Status == 0)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         _loc3_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.GetBackItems[_loc2_].Status == 1)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         if(this.FOnEffectShortcut != null)
         {
            this.FOnEffectShortcut(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyWelfare,_loc6_);
         }
         if(this.FProcessorWindowDailyWelfare.Visible)
         {
            this.FProcessorWindowDailyWelfare.Update();
            EffectGenerateText(this.FProcessorWindowDailyWelfare.CurStr);
         }
      }
      
      protected function PacketPerform_SC_InforRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         _loc4_ = param1.Data;
         this.FUnstreamizerDailyWelfare.UnstreamizeUpdateDailyWelfareInfo(_loc4_,this.FData_DailyWelfare,null);
         _loc6_ = false;
         _loc3_ = this.FData_DailyWelfare.WelfareItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.WelfareItems[_loc2_].Status == 0)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         _loc3_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.GetBackItems[_loc2_].Status == 1)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         if(this.FOnEffectShortcut != null)
         {
            this.FOnEffectShortcut(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyWelfare,_loc6_);
         }
         if(this.FProcessorWindowDailyWelfare.Visible)
         {
            this.FProcessorWindowDailyWelfare.Update();
         }
      }
      
      protected function PacketPerform_SC_GetBackRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         _loc4_ = param1.Data;
         _loc5_ = _loc4_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         this.FUnstreamizerDailyWelfare.UnstreamizeUpdateAllItem(_loc4_,this.FData_DailyWelfare,null);
         _loc6_ = false;
         _loc3_ = this.FData_DailyWelfare.WelfareItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.WelfareItems[_loc2_].Status == 0)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         _loc3_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.GetBackItems[_loc2_].Status == 1)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         if(this.FOnEffectShortcut != null)
         {
            this.FOnEffectShortcut(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyWelfare,_loc6_);
         }
         if(this.FProcessorWindowDailyWelfare.Visible)
         {
            this.FProcessorWindowDailyWelfare.Update();
            EffectGenerateText(this.FProcessorWindowDailyWelfare.CurStr);
         }
      }
      
      protected function PacketPerform_SC_DailyWelfareRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         _loc4_ = param1.Data;
         _loc5_ = _loc4_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         this.FUnstreamizerDailyWelfare.UnstreamizeUpdateAllItem(_loc4_,this.FData_DailyWelfare,null);
         _loc6_ = false;
         _loc3_ = this.FData_DailyWelfare.WelfareItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.WelfareItems[_loc2_].Status == 0)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         _loc3_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_DailyWelfare.GetBackItems[_loc2_].Status == 1)
            {
               _loc6_ = true;
            }
            _loc2_++;
         }
         if(this.FOnEffectShortcut != null)
         {
            this.FOnEffectShortcut(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyWelfare,_loc6_);
         }
         if(this.FProcessorWindowDailyWelfare.Visible)
         {
            this.FProcessorWindowDailyWelfare.Update();
            EffectGenerateText(this.FProcessorWindowDailyWelfare.CurStr);
         }
      }
      
      protected function PacketPerform_CS_DailyWelfare_InforReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyWelfare_InforReq);
         _loc2_ = _loc1_.Data;
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowDailyWelfare.Load();
            return;
         }
         this.PacketPerform_CS_DailyWelfare_InforReq();
         this.FProcessorWindowDailyWelfare.Update();
         this.FProcessorWindowDailyWelfare.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowDailyWelfare.Reset();
      }
      
      public function RoleLevelUpNotify() : void
      {
         if(this.FProcessorWindowDailyWelfare.visible)
         {
            this.PacketPerform_CS_DailyWelfare_InforReq();
         }
      }
      
      public function InitDatas() : void
      {
         this.InitData();
         this.PacketPerform_CS_DailyWelfare_InforReq();
      }
      
      public function get OnEffectShortcut() : Function
      {
         return this.FOnEffectShortcut;
      }
      
      public function set OnEffectShortcut(param1:Function) : void
      {
         this.FOnEffectShortcut = param1;
      }
   }
}

