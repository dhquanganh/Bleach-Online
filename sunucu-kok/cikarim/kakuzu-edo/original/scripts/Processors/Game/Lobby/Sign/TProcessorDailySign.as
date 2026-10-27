package Processors.Game.Lobby.Sign
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.DailySign.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Logics.Streamization.Dailysign.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorDailySign extends TProcessorLobbyWindows
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var SIZE_Window_Width:uint = 626;
      
      protected var SIZE_Window_Height:uint = 442;
      
      protected var FProcessorWindowDailySign:TProcessorWindowDailySign;
      
      protected var FDailyBounds:TBounds;
      
      protected var FUnstreamizerDailySign:TUnstreamizerDailySign;
      
      protected var FDailySign:TDailySign;
      
      protected var FOnEffectSign:Function;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorDailySign(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowDailySign = new TProcessorWindowDailySign(this);
         this.FProcessorWindowDailySign.OnClose = this.ProcessorOnClose;
         this.FProcessorWindowDailySign.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowDailySign.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowDailySign.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowDailySign.OnCompensate = this.ProcessorOnCompensate;
         this.FProcessorWindowDailySign.DownHintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowDailySign.DownHintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowDailySign.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowDailySign.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowDailySign.OnExchange = this.ProcessorOnExchange;
         this.FProcessorWindowDailySign.OnGetReward = this.ProcessorOnGetReward;
         this.FProcessorWindowDailySign.OnGetCouponReward = this.ProcessorOnGetCouponReward;
         this.FDailyBounds = new TBounds();
         this.FDailyBounds.Width = this.SIZE_Window_Width;
         this.FDailyBounds.Height = this.SIZE_Window_Height;
         this.FDailyBounds.X = this.FProcessorWindowDailySign.X;
         this.FDailyBounds.Y = this.FProcessorWindowDailySign.Y;
         ComponentBoundsCenter(this.FProcessorWindowDailySign,this.FDailyBounds);
         this.FDailyBounds = null;
         this.FUnstreamizerDailySign = new TUnstreamizerDailySign();
         this.FDailySign = new TDailySign();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DAILYSIGN.RESOURCESID_Swf_DailySign);
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
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Sign_Load,this.PacketPerform_SC_SignLoad);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Sign_Commit,this.PacketPerform_SC_SignCommit);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Sign_Reward,this.PacketPerform_SC_SignReward);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Coupon_Reward,this.PacketPerform_SC_MonthCardReward);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_MonthCard_Notice,this.PacketPerform_SC_MonthCardNotice);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:Date = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!Visible)
         {
            return;
         }
         _loc1_ = new Date(STimingCore.ServerTime * 1000);
         if(this.FDailySign.CurrentMonth != _loc1_.month)
         {
            _loc3_ = this.FDailySign.DayList.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FDailySign.DayList.pop();
               _loc2_++;
            }
            this.FDailySign.DayList[0] = "0";
            this.FDailySign.CurrentMonth = _loc1_.month;
            this.FProcessorWindowDailySign.UpdateUI();
         }
         super.LogicsPerform();
      }
      
      protected function PacketPerform_SC_SignLoad(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerDailySign.Unstreamize(_loc2_,this.FDailySign,SLogicsCore.Character.InventorySamples);
         if(this.FDailySign.DayList[this.FDailySign.DayList.length - 1] == "0")
         {
            this.PlayEffectNewSign(true);
         }
      }
      
      protected function PacketPerform_SC_MonthCardNotice(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         this.FUnstreamizerDailySign.MonthCardNotice(_loc2_,this.FDailySign);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FProcessorWindowDailySign.Init(this.FDailySign);
      }
      
      protected function PacketPerform_SC_MonthCardReward(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FDailySign.FirstRewardState = _loc2_.readUnsignedInt();
         this.FDailySign.MonthRewardState = _loc2_.readUnsignedInt();
         this.FProcessorWindowDailySign.Init(this.FDailySign);
      }
      
      protected function PacketPerform_SC_SignCommit(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         _loc4_ = param1.Data;
         _loc2_ = int(_loc4_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = int(_loc4_.readUnsignedInt());
         EffectGenerateText(this.FProcessorWindowDailySign.RewardStr);
         this.FProcessorWindowDailySign.RewardStr = "";
         if(new Date(STimingCore.ServerTime * 1000).date == _loc3_)
         {
            this.PlayEffectNewSign(false);
         }
         this.FDailySign.DayList[_loc3_ - 1] = "1";
         ++this.FDailySign.SignTotalDays;
         this.FProcessorWindowDailySign.UpdateUI();
      }
      
      protected function PacketPerform_SC_SignReward(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:TSignReward = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         _loc8_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_12);
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedInt());
         _loc6_ = this.FDailySign.SignReward.Desc.split("\\n");
         _loc7_ = _loc6_.length;
         var _loc9_:int = 1;
         while(_loc9_ < _loc7_)
         {
            _loc8_ += _loc6_[_loc9_] + "\n";
            _loc9_++;
         }
         EffectGenerateText(_loc8_);
         this.FDailySign.RewardID = _loc4_;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SignReward,_loc4_) as TSignReward;
         this.FDailySign.SignReward = _loc5_;
         this.FProcessorWindowDailySign.UpdateReward();
      }
      
      protected function PlayEffectNewSign(param1:Boolean) : void
      {
         if(this.FOnEffectSign != null)
         {
            this.FOnEffectSign(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Sign,param1);
         }
      }
      
      protected function ProcessorOnGetReward(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Sign_Reward);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOnGetCouponReward(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Coupon_Reward);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOnCompensate(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc3_ = param2 as int;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Sign_Commit);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(_loc3_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorOnExchange(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function get OnEffectSign() : Function
      {
         return this.FOnEffectSign;
      }
      
      public function set OnEffectSign(param1:Function) : void
      {
         this.FOnEffectSign = param1;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowDailySign.Load();
            return;
         }
         this.FProcessorWindowDailySign.Visible = true;
         this.FProcessorWindowDailySign.Init(this.FDailySign);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenSign);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseSign);
         this.FProcessorWindowDailySign.Reset();
      }
      
      public function AchievementInforUpdateNotify(param1:TAchievementInfor) : void
      {
         this.FProcessorWindowDailySign.AchievementInforUpdateNotify(param1);
      }
   }
}

