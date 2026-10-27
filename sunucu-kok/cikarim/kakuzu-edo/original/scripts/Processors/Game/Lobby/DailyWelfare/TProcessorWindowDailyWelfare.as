package Processors.Game.Lobby.DailyWelfare
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityDate;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Dailywelfare.TDailyWelfare;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TDailyGetBackReward;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.DailyWelfare.Component.TUIGetBackItem;
   import Processors.Game.Lobby.DailyWelfare.Component.TUIWelfareItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DAILYWELFARE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowDailyWelfare extends TProcessorLobbyWindow
   {
      
      protected static const TAB_INDEX_GETBACK:int = 0;
      
      protected static const TAB_INDEX_WELFARE:int = 1;
      
      protected static const CAPACITY_GETBACKITEMS:int = 4;
      
      protected static const CAPACITY_WELFAREITEMS:int = 3;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FMC_GetBack:Sprite;
      
      protected var FMC_Welfare:Sprite;
      
      protected var FTabs:TUITab;
      
      protected var FCurrentVisibleWindowIndex:int;
      
      protected var FMC_WelfareItems:Vector.<TUIWelfareItem>;
      
      protected var FMC_GetBackItems:Vector.<TUIGetBackItem>;
      
      protected var FBtn_OneKeyFree:TUIButton;
      
      protected var FBtn_OneKeyGold:TUIButton;
      
      protected var FTF_BossLv:TextField;
      
      protected var FData_DailyWelfare:TDailyWelfare;
      
      protected var FUIPageGetBack:TUIPage;
      
      protected var FPageGetBackIndex:int;
      
      protected var FUIPageWelfare:TUIPage;
      
      protected var FPageWelfareIndex:int;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FCount_OneKey:uint;
      
      protected var FCurStr:String;
      
      protected var FConfigValue:TBins;
      
      protected var FFreeRate:Number;
      
      protected var FGoldRate:Number;
      
      protected var FGetBackCost:uint;
      
      protected var FAcquire:Vector.<Object>;
      
      protected var FHit:THint;
      
      public function TProcessorWindowDailyWelfare(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TUIWelfareItem = null;
         var _loc6_:TUIGetBackItem = null;
         this.ReadConfigValue();
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_DailyWelfare") as Sprite;
         addChild(_loc4_);
         this.FTabs = new TUITab(this);
         _loc3_ = int(CONST_DAILYWELFARE.CAPACITY_TABS);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _loc4_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc2_];
            this.FTabs.SetTabByIndex(_loc1_,_loc2_);
            _loc2_++;
         }
         this.FTabs.OnSwitch = this.TabClick;
         this.FTabs.Init();
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = _loc4_["btn_close"];
         this.FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FMC_GetBack = _loc4_["MC_GetBack"];
         this.FMC_Welfare = _loc4_["MC_Welfare"];
         this.FTF_BossLv = this.FMC_Welfare["TF_BossLevel"];
         _loc3_ = CAPACITY_WELFAREITEMS;
         this.FMC_WelfareItems = new Vector.<TUIWelfareItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TUIWelfareItem(this);
            _loc5_.BtnOkOnClick = this.BtnWelfareOnClick;
            _loc5_.Perform_UIDispatch(this.FMC_Welfare["MC_WelfareItem_" + _loc2_]);
            _loc5_.UpdateUI(_loc2_,this.FData_DailyWelfare,this.FAcquire);
            this.FMC_WelfareItems[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = CAPACITY_GETBACKITEMS;
         this.FMC_GetBackItems = new Vector.<TUIGetBackItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TUIGetBackItem(this);
            _loc6_.BtnOkOnClick = this.BtnGetBackOnClick;
            _loc6_.Perform_UIDispatch(this.FMC_GetBack["MC_GetBackItem_" + _loc2_]);
            _loc6_.UpdateUI(_loc2_,this.FData_DailyWelfare,this.FFreeRate,this.FGetBackCost);
            this.FMC_GetBackItems[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FBtn_OneKeyFree = new TUIButton();
         this.FBtn_OneKeyFree.Substrate = this.FMC_GetBack["Btn_OnKeyFree"];
         this.FBtn_OneKeyFree.OnClick = this.OnekeyOnClick;
         this.FBtn_OneKeyGold = new TUIButton();
         this.FBtn_OneKeyGold.Substrate = this.FMC_GetBack["Btn_OnKeyGold"];
         this.FBtn_OneKeyGold.OnClick = this.OnekeyOnClick;
         this.FBtn_OneKeyGold.OnMove = this.BtnOkOnMove;
         this.FBtn_OneKeyGold.OnOut = this.BtnOnOut;
         this.FUIPageGetBack = new TUIPage(this);
         this.FUIPageGetBack.ButtonPrevious.Substrate = this.FMC_GetBack["MC_Page"]["MC_PageLeft"];
         this.FUIPageGetBack.ButtonNext.Substrate = this.FMC_GetBack["MC_Page"]["MC_PageRight"];
         this.FUIPageGetBack.LabelPage = this.FMC_GetBack["MC_Page"]["TF_Page"];
         this.FUIPageGetBack.LabelPage.text = "0/0";
         this.FUIPageGetBack.PageSize = CONST_DAILYWELFARE.CAPACITY_GETBACKITEMS;
         this.FUIPageGetBack.Init();
         this.FUIPageGetBack.OnChangePage = this.PageGetBackOnChange;
         this.FUIPageWelfare = new TUIPage(this);
         this.FUIPageWelfare.ButtonPrevious.Substrate = this.FMC_Welfare["MC_Page"]["MC_PageLeft"];
         this.FUIPageWelfare.ButtonNext.Substrate = this.FMC_Welfare["MC_Page"]["MC_PageRight"];
         this.FUIPageWelfare.LabelPage = this.FMC_Welfare["MC_Page"]["TF_Page"];
         this.FUIPageWelfare.LabelPage.text = "0/0";
         this.FUIPageWelfare.PageSize = CONST_DAILYWELFARE.CAPACITY_WELFAREITEMS;
         this.FUIPageWelfare.Init();
         this.FUIPageWelfare.OnChangePage = this.PageWelfareOnChange;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FHit = new THint();
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function PageGetBackOnChange(param1:Object, param2:int) : void
      {
         this.FPageGetBackIndex = param2;
      }
      
      protected function UpdateGetBackUIPage() : void
      {
         this.FUIPageGetBack.TotalQuantity = this.FData_DailyWelfare.GetBackItems.length;
         this.FUIPageGetBack.PageIndex = this.FPageGetBackIndex;
         this.FUIPageGetBack.Update();
      }
      
      protected function PageWelfareOnChange(param1:Object, param2:int) : void
      {
         this.FPageWelfareIndex = param2;
      }
      
      protected function UpdateWelfareUIPage() : void
      {
         this.FUIPageWelfare.TotalQuantity = this.FData_DailyWelfare.WelfareItems.length;
         this.FUIPageWelfare.PageIndex = this.FPageWelfareIndex;
         this.FUIPageWelfare.Update();
      }
      
      protected function OnekeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TDailyGetBackReward = null;
         var _loc5_:uint = 0;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DailyGetBackReward,SLogicsCore.Character.GetMainRebirthLevel()) as TDailyGetBackReward;
         _loc4_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FData_DailyWelfare.GetBackItems[_loc3_].Status == 1)
            {
               _loc5_++;
               _loc7_ += _loc8_.Reward_Exp[_loc3_];
               _loc6_ += _loc8_.Reward_Gold[_loc3_];
            }
            _loc3_++;
         }
         if(_loc5_ == 0)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_01);
            return;
         }
         switch(param2.currentTarget.name)
         {
            case "Btn_OnKeyFree":
               this.PacketPerform_CS_DailyWelfare_OneKeyReq(1);
               this.FCurStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_02),uint(_loc6_ * this.FFreeRate),uint(_loc7_ * this.FFreeRate));
               break;
            case "Btn_OnKeyGold":
               this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost * _loc5_);
               this.FUIWindowConfirmation.OnOK = this.OnOneKeyGoldOk;
               this.FUIWindowConfirmation.Visible = true;
               this.FCurStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_02),uint(_loc6_),uint(_loc7_));
         }
      }
      
      protected function OnOneKeyGoldOk(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_OneKeyReq(2);
      }
      
      protected function OnWelfare1Ok(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_DailyWelfareReq(4);
      }
      
      protected function OnWelfare2Ok(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_DailyWelfareReq(5);
      }
      
      protected function OnGetBack1Ok(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_GetBackReq(1,2);
      }
      
      protected function OnGetBack2Ok(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_GetBackReq(2,2);
      }
      
      protected function OnGetBack3Ok(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_GetBackReq(4,2);
      }
      
      protected function OnGetBack4Ok(param1:Object) : void
      {
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         this.PacketPerform_CS_DailyWelfare_GetBackReq(8,2);
      }
      
      protected function PacketPerform_CS_DailyWelfare_OneKeyReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyWelfare_OneKeyReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BtnWelfareOnClick(param1:Object, param2:String, param3:String) : void
      {
         this.FCurStr = param3;
         switch(param2)
         {
            case "0_0":
               this.PacketPerform_CS_DailyWelfare_DailyWelfareReq(1);
               break;
            case "1_0":
               this.PacketPerform_CS_DailyWelfare_DailyWelfareReq(2);
               break;
            case "2_0":
               this.PacketPerform_CS_DailyWelfare_DailyWelfareReq(3);
               break;
            case "1_1":
               this.FUIWindowConfirmation.Text = this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_09),this.FAcquire[3][0]);
               this.FUIWindowConfirmation.OnOK = this.OnWelfare1Ok;
               this.FUIWindowConfirmation.Visible = true;
               break;
            case "2_1":
               this.FUIWindowConfirmation.Text = this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_09),this.FAcquire[4][0]);
               this.FUIWindowConfirmation.OnOK = this.OnWelfare2Ok;
               this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function BtnGetBackOnClick(param1:Object, param2:String, param3:Vector.<uint>) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = uint(param2.split("_")[0]);
         _loc5_ = uint(param2.split("_")[1]);
         if(_loc5_ == 0)
         {
            this.FCurStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_02),uint(param3[0] * this.FFreeRate),uint(param3[1] * this.FFreeRate));
         }
         else
         {
            this.FCurStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_02),uint(param3[0]),uint(param3[1]));
         }
         switch(_loc4_)
         {
            case 0:
               if(_loc5_ == 0)
               {
                  this.PacketPerform_CS_DailyWelfare_GetBackReq(1,1);
               }
               else
               {
                  this.FUIWindowConfirmation.Text = this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost);
                  this.FUIWindowConfirmation.OnOK = this.OnGetBack1Ok;
                  this.FUIWindowConfirmation.Visible = true;
               }
               break;
            case 1:
               if(_loc5_ == 0)
               {
                  this.PacketPerform_CS_DailyWelfare_GetBackReq(2,1);
               }
               else
               {
                  this.FUIWindowConfirmation.Text = this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost);
                  this.FUIWindowConfirmation.OnOK = this.OnGetBack2Ok;
                  this.FUIWindowConfirmation.Visible = true;
               }
               break;
            case 2:
               if(_loc5_ == 0)
               {
                  this.PacketPerform_CS_DailyWelfare_GetBackReq(4,1);
               }
               else
               {
                  this.FUIWindowConfirmation.Text = this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost);
                  this.FUIWindowConfirmation.OnOK = this.OnGetBack3Ok;
                  this.FUIWindowConfirmation.Visible = true;
               }
               break;
            case 3:
               if(_loc5_ == 0)
               {
                  this.PacketPerform_CS_DailyWelfare_GetBackReq(8,1);
               }
               else
               {
                  this.FUIWindowConfirmation.Text = this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost);
                  this.FUIWindowConfirmation.OnOK = this.OnGetBack4Ok;
                  this.FUIWindowConfirmation.Visible = true;
               }
         }
      }
      
      protected function PacketPerform_CS_DailyWelfare_DailyWelfareReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyWelfare_DailyWelfareReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function PacketPerform_CS_DailyWelfare_GetBackReq(param1:uint, param2:int) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyWelfare_GetBackReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(param2);
         _loc4_.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function SwitchTab(param1:int) : void
      {
         this.FCurrentVisibleWindowIndex = param1;
         this.FMC_GetBack.visible = false;
         this.FMC_Welfare.visible = false;
         this.Update();
      }
      
      protected function BtnOkOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FData_DailyWelfare.GetBackItems[_loc3_].Status == 1)
            {
               _loc5_++;
            }
            _loc3_++;
         }
         if(_loc5_ == 0)
         {
            return;
         }
         this.FHit.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost * _loc5_);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHit);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHit);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabClick(param1:Object) : void
      {
         this.SwitchTab(param1 as int);
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      private function ReadConfigValue() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.WelFare_Free) as TConfigValue;
         this.FFreeRate = _loc1_.Value as Number;
         this.FFreeRate /= 100;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.WelFare_Gold_Bonus) as TConfigValue;
         this.FGoldRate = _loc1_.Value as Number;
         this.FGoldRate /= 100;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.WelFare_Expend) as TConfigValue;
         this.FGetBackCost = _loc1_.Value as uint;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.WelFare_acquire) as TConfigValue;
         this.FAcquire = _loc1_.Value as Vector.<Object>;
         _loc3_ = this.FAcquire.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAcquire[_loc2_][1] /= 100;
            _loc2_++;
         }
      }
      
      protected function CheckGoldIsEnough() : Boolean
      {
         var _loc1_:Boolean = false;
         if(SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate < this.FGetBackCost)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold);
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FMC_WelfareItems.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_WelfareItems[_loc1_].Reset();
            _loc1_++;
         }
         _loc2_ = this.FMC_GetBackItems.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_GetBackItems[_loc1_].Reset();
            _loc1_++;
         }
         this.FCurrentVisibleWindowIndex = 0;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         _loc2_ = this.FData_DailyWelfare.GetBackItems.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_GetBackItems[_loc1_].UpdateUI(_loc1_,this.FData_DailyWelfare,this.FFreeRate,this.FGetBackCost);
            _loc1_++;
         }
         _loc2_ = this.FData_DailyWelfare.WelfareItems.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_WelfareItems[_loc1_].UpdateUI(_loc1_,this.FData_DailyWelfare,this.FAcquire);
            _loc1_++;
         }
         switch(this.FCurrentVisibleWindowIndex)
         {
            case TAB_INDEX_GETBACK:
               this.UpdateGetBackUIPage();
               this.FMC_GetBack.visible = true;
               this.FMC_Welfare.visible = false;
               break;
            case TAB_INDEX_WELFARE:
               _loc4_ = new Date();
               _loc4_ = TUtilityDate.ToDateMaxFormat(new Date(STimingCore.ServerStartTime * 1000));
               _loc5_ = new Date();
               _loc5_ = new Date(STimingCore.ServerTime * 1000);
               _loc3_ = _loc5_.getTime() - _loc4_.getTime() > 0 ? true : false;
               this.FMC_Welfare["TF_Title"].visible = false;
               if(!_loc3_)
               {
                  _loc2_ = uint(this.FMC_Welfare.numChildren);
                  _loc1_ = 0;
                  while(_loc1_ < _loc2_)
                  {
                     this.FMC_Welfare.getChildAt(_loc1_).visible = false;
                     _loc1_++;
                  }
                  this.FMC_Welfare["MC_bg"].visible = true;
                  this.FMC_Welfare["TF_Title"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_11);
                  this.FMC_Welfare["TF_Title"].visible = true;
               }
               this.FTF_BossLv.text = this.FData_DailyWelfare.WorldBossLv.toString();
               this.UpdateWelfareUIPage();
               this.FMC_Welfare.visible = true;
               this.FMC_GetBack.visible = false;
         }
      }
      
      public function get Data_DailyWelfare() : TDailyWelfare
      {
         return this.FData_DailyWelfare;
      }
      
      public function set Data_DailyWelfare(param1:TDailyWelfare) : void
      {
         this.FData_DailyWelfare = param1;
      }
      
      public function get CurStr() : String
      {
         return this.FCurStr;
      }
   }
}

