package Processors.Game.Lobby.Home.GirlFriend
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Home.GirlFriend.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowGirlFriendMakeTofu extends TProcessorLobbyWindow
   {
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FTF_MackTofuTime:TextField;
      
      protected var FTF_CDTime:TextField;
      
      protected var FTF_Infor:TextField;
      
      protected var FTF_DayTime:TextField;
      
      protected var FBTN_ClearTime:TUIButton;
      
      protected var FBTN_MakeTofu:TUIButton;
      
      protected var FEffect:MovieClip;
      
      protected var FFlowerEffect:MovieClip;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FCheckCondition:Vector.<Function>;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FTF_Orders:TextField;
      
      protected var FOrdersBar:Sprite;
      
      protected var FEffectAdd:MovieClip;
      
      protected var FHint:THint;
      
      protected var FHitMouseMove:Function;
      
      protected var FHitMouseOut:Function;
      
      public function TProcessorWindowGirlFriendMakeTofu(param1:TUIComponent)
      {
         super(param1);
         this.FGirlFriend = SLogicsCore.Home.GirlFriend;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Home_MakeTofu);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FTF_CDTime.text = TUtilityTiming.fomatTime(this.FTimeCoolDown.TimingTime);
            this.FBTN_ClearTime.Enabled = this.FTimeCoolDown.TimingTime > 0 && this.FGirlFriend.CurrentCostMakeTofuTime < this.FGirlFriend.CanMakeTofuTime;
         }
      }
      
      protected function UIDispatch_Peform(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         addChild(param1);
         this.FTF_MackTofuTime = param1["MakeTofuTime"];
         this.FTF_CDTime = param1["TF_CDTime"];
         this.FTF_Infor = param1["Infor"];
         this.FTF_DayTime = param1["DayTime"];
         this.FBTN_ClearTime = new TUIButton();
         this.FBTN_ClearTime.Substrate = param1["Btn_Cleartime"];
         this.FBTN_MakeTofu = new TUIButton();
         this.FBTN_MakeTofu.Substrate = param1["Btn_MakeTofu"];
         this.FEffect = param1["Effect"];
         this.FFlowerEffect = param1["FlowerEffect"];
         this.FTF_Orders = param1["TF_MilitaryOrders"];
         this.FOrdersBar = param1["MC_ProgressBarMilitaryOrder"];
         this.FEffectAdd = param1["EffectAdd"];
         this.FCheckCondition = new Vector.<Function>();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function UILocation_Peform() : void
      {
         this.FBTN_ClearTime.OnClick = this.BtnClearTimeClicked;
         this.FBTN_MakeTofu.OnClick = this.BtnMakeTofuClicked;
         this.FBTN_MakeTofu.OnMove = this.BtnMakeTofuMouseMove;
         this.FBTN_MakeTofu.OnOut = this.BtnMakeTofuMouseOut;
         this.FCheckCondition.push(this.CheckCanMakeTofuTime);
         this.FCheckCondition.push(this.CheckIfCDTime);
         this.FHint = new THint();
      }
      
      public function Update_Perform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TConfigValue = null;
         var _loc4_:Number = NaN;
         this.FTF_DayTime.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_26);
         this.FTF_MackTofuTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_1),this.FGirlFriend.CurrentCostMakeTofuTime,this.FGirlFriend.CanMakeTofuTime);
         _loc1_ = uint(SLogicsCore.Character.CreditMilitaryOrders);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.ORDER_RECOVER_LIMIT) as TConfigValue;
         _loc2_ = _loc3_.Value as uint;
         _loc2_ += SLogicsCore.Character.VipData.ActionLimit;
         this.FTF_Orders.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,_loc1_,_loc2_);
         _loc4_ = _loc1_ / _loc2_;
         if(_loc4_ > 1)
         {
            _loc4_ = 1;
         }
         this.FOrdersBar.scaleX = _loc4_;
         if(this.FGirlFriend.NeedPlayMakeTofuEffect)
         {
            this.FEffect.gotoAndPlay(1);
            this.FEffectAdd.gotoAndPlay(1);
            this.FGirlFriend.NeedPlayMakeTofuEffect = false;
         }
      }
      
      protected function CheckMackTofuCondition() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         _loc2_ = 0;
         while(_loc2_ < this.FCheckCondition.length)
         {
            _loc3_ = this.FCheckCondition[_loc2_];
            if(!_loc3_())
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      protected function CheckCanMakeTofuTime() : Boolean
      {
         if(this.FGirlFriend.CurrentCostMakeTofuTime >= this.FGirlFriend.CanMakeTofuTime)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_4));
            return false;
         }
         return true;
      }
      
      protected function CheckIfCDTime() : Boolean
      {
         if(this.FTimeCoolDown.TimingTime > 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_5));
            return false;
         }
         return true;
      }
      
      protected function RequestClearTime() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendClearMakeTofuCD);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function BtnClearTimeClicked(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = Math.ceil(this.FTimeCoolDown.TimingTime / 60);
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_24),_loc3_);
         this.FUIWindowConfirmation.OnOK = this.WindowOnOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function WindowOnOK(param1:Object) : void
      {
         this.RequestClearTime();
      }
      
      protected function BtnMakeTofuClicked(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:TPacket = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickMakeTofu);
         _loc3_ = this.CheckMackTofuCondition();
         if(_loc3_)
         {
            _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendMakeTofu);
            SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         }
      }
      
      protected function BtnMakeTofuMouseMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHitMouseMove != null)
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_25);
            this.FHitMouseMove(this,this.FHint);
         }
      }
      
      protected function BtnMakeTofuMouseOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHitMouseOut != null)
         {
            this.FHitMouseOut(this,this.FHint);
         }
      }
      
      public function set HitMouseMove(param1:Function) : void
      {
         this.FHitMouseMove = param1;
      }
      
      public function set HitMouseOut(param1:Function) : void
      {
         this.FHitMouseOut = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.UIDispatch_Peform(param1);
      }
      
      public function UILocation() : void
      {
         this.UILocation_Peform();
      }
      
      public function Update() : void
      {
         this.Update_Perform();
         this.FFlowerEffect.play();
      }
      
      public function Reset() : void
      {
         if(this.FFlowerEffect != null)
         {
            this.FFlowerEffect.stop();
            this.FEffectAdd.stop();
         }
      }
   }
}

