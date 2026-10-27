package Processors.Game.Lobby.Activity.HDActivity
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Externals.SExternalCore;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDSingleWindowBase extends TProcessorLobbyWindow
   {
      
      public static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      public static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      public static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const TYPE_StartTime:uint = 0;
      
      protected static const TYPE_EndTime:uint = 1;
      
      protected var FScene:Sprite;
      
      protected var FMC_Prompt:Sprite;
      
      protected var FTF_OpenTime:TextField;
      
      protected var FTF_CoolingTime:TextField;
      
      protected var FTF_Desc:TextField;
      
      protected var FMC_Close:MovieClip;
      
      protected var FMC_GotoLink:MovieClip;
      
      protected var FMC_Charge:MovieClip;
      
      protected var FBtn_Charge:TUIButton;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FBtn_GotoLink:TUIButton;
      
      protected var FUIPage:TUIPage;
      
      protected var FMC_PageLeft:MovieClip;
      
      protected var FMC_PageRight:MovieClip;
      
      protected var FAwardBins:TBins;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FPageIndex:int;
      
      protected var FSceneResourceName:String;
      
      protected var FCharacter:TCharacter;
      
      protected var FActivityAtoms:TActivityAtoms;
      
      protected var FHDActivityConfig:THDActivityBase;
      
      protected var FActivityID:uint;
      
      protected var FBoxStatus:Vector.<int>;
      
      protected var FInventoriesVect:Vector.<TInventories>;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FDate:Date;
      
      protected var FEndTime:uint;
      
      protected var FBoxIndex:int;
      
      protected var FIsInitLoadConfig:Boolean;
      
      protected var FIsInitCoolingTime:Boolean;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FHint:THint;
      
      protected var FormatString_TimeStartToEnd:String;
      
      protected var FOnShortcutHyperlinks:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FUpdateStatus:Function;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnBtnCloseClick:Function;
      
      protected var FOnGiftBoxMove:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      public function TProcessorHDSingleWindowBase(param1:TUIComponent)
      {
         super(param1);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FIsInitLoadConfig = false;
         this.FIsInitCoolingTime = false;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FDate = new Date();
         this.FPageIndex = 0;
         this.FCharacter = SLogicsCore.Character;
         this.FBoxIndex = -1;
         this.FHint = new THint();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.InitWindow();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FIsInitCoolingTime && this.FTF_CoolingTime != null)
         {
            this.SetCountDown();
         }
      }
      
      public function InitWindow(param1:Sprite = null) : void
      {
         if(param1 == null)
         {
            if(this.FSceneResourceName == "")
            {
               return;
            }
            this.FScene = TUtilityReflection.CreateDisplayObjectInstance(this.FSceneResourceName) as Sprite;
         }
         else
         {
            this.FScene = param1;
         }
         addChild(this.FScene);
         this.FMC_Close = this.FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Close];
         this.FMC_Prompt = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Prompt];
         if(this.FMC_Prompt != null)
         {
            this.FTF_OpenTime = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_OpenTime];
            this.FTF_CoolingTime = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_CoolingTime];
            this.FTF_Desc = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_Desc];
            this.FMC_GotoLink = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_BTN_GotoLink];
            this.FMC_PageLeft = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
            this.FMC_PageRight = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
            this.FMC_Charge = this.FMC_Prompt["Btn_Charge"];
         }
         if(this.FMC_PageLeft != null && this.FMC_PageRight != null)
         {
            this.FUIPage = new TUIPage(this);
            this.FUIPage.ButtonPrevious.Substrate = this.FMC_PageLeft;
            this.FUIPage.ButtonNext.Substrate = this.FMC_PageRight;
            this.FUIPage.OnChangePage = this.ProcessorPageOnChange;
            this.FUIPage.Init();
         }
         if(this.FMC_Close != null)
         {
            this.FBtn_Close = new TUIButton();
            this.FBtn_Close.Substrate = this.FMC_Close;
            this.FBtn_Close.OnClick = this.BtnCloseOnClick;
         }
         if(this.FMC_GotoLink != null)
         {
            this.FBtn_GotoLink = new TUIButton();
            this.FBtn_GotoLink.Substrate = this.FMC_GotoLink;
            this.FBtn_GotoLink.OnClick = this.BtnGotoLinkOnClcik;
         }
         if(this.FMC_Charge != null)
         {
            this.FBtn_Charge = new TUIButton();
            this.FBtn_Charge.Substrate = this.FMC_Charge;
            this.FBtn_Charge.OnClick = this.BtnChargeOnClcik;
         }
         if(this.FAwardBins == null)
         {
            this.FAwardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         }
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FormatString_TimeStartToEnd = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_02);
      }
      
      protected function UpdateUI() : void
      {
      }
      
      protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
      }
      
      protected function UpdateUIConfig() : void
      {
         this.ProcessorFormatActivityDesc();
      }
      
      protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<uint> = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TActivityAtoms = null;
         _loc4_ = Activity_AlreadyReceive;
         this.FBoxStatus[param1] = param2;
         _loc5_ = this.FBoxStatus.length;
         param1 = 0;
         while(param1 < _loc5_)
         {
            if(this.FBoxStatus[param1] >= Activity_CanReceive)
            {
               _loc4_ = Activity_CanReceive;
            }
            else if(this.FBoxStatus[param1] == Activity_CanNotReceive)
            {
               _loc4_ = Activity_CanNotReceive;
            }
            param1++;
         }
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      protected function ProcessorFormatActivityTime(param1:uint, param2:uint) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.FTF_OpenTime == null)
         {
            return;
         }
         this.FDate.setTime(param1 * 1000);
         _loc3_ = TUtilityDate.FormatDateChineseNew(this.FDate);
         if(false)
         {
            _loc3_ = TUtilityDate.FormatDateAmericanNew(this.FDate);
         }
         this.FDate.setTime(param2 * 1000);
         _loc4_ = TUtilityDate.FormatDateChineseNew(this.FDate);
         if(false)
         {
            _loc4_ = TUtilityDate.FormatDateAmericanNew(this.FDate);
         }
         this.FTF_OpenTime.text = TUtilityString.Format(this.FormatString_TimeStartToEnd,_loc3_,_loc4_);
      }
      
      protected function ProcessorFormatActivityTimeFromNowOn(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.FTF_OpenTime == null)
         {
            return;
         }
         this.FDate.setTime(param1 * 1000);
         _loc3_ = TUtilityDate.FormatDateChineseNew(this.FDate);
         if(false)
         {
            _loc3_ = TUtilityDate.FormatDateAmericanNew(this.FDate);
         }
         this.FTF_OpenTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_04),_loc3_);
      }
      
      protected function SetCountDown() : void
      {
         if(this.FTF_CoolingTime == null)
         {
            return;
         }
         if(this.FEndTime - STimingCore.ServerTime <= 0)
         {
            this.FTF_CoolingTime.text = "0";
         }
         else
         {
            this.FTF_CoolingTime.text = this.FormatTime(this.FEndTime - STimingCore.ServerTime);
         }
         if(this.FEndTime - STimingCore.ServerTime <= 0)
         {
            this.FIsInitCoolingTime = false;
         }
      }
      
      protected function ProcessorFormatActivityCountDown(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.FTF_CoolingTime == null)
         {
            return;
         }
         this.FIsInitCoolingTime = true;
         this.FEndTime = param1;
         _loc2_ = uint(STimingCore.ServerTime);
         if(param1 - _loc2_ <= 0)
         {
            this.FTF_CoolingTime.text = "0";
         }
         else
         {
            this.FTF_CoolingTime.text = this.FormatTime(param1 - _loc2_);
         }
      }
      
      protected function FormatTime(param1:uint) : String
      {
         var _loc2_:int = 0;
         _loc2_ = param1 / TUtilityTiming.CONST_DAY;
         if(_loc2_ > 0)
         {
            return _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TYPE_TIME_Day);
         }
         return TUtilityTiming.fomatTime(param1);
      }
      
      protected function GetTimeByTypeCycle(param1:uint, param2:Vector.<uint>, param3:Vector.<uint> = null) : uint
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Date = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         _loc4_ = int(param2[0]);
         _loc5_ = param2[1] - 1;
         _loc6_ = int(param2[2]);
         _loc7_ = int(param2[3]);
         _loc8_ = int(param2[4]);
         _loc9_ = int(param2[5]);
         _loc13_ = new Date(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
         _loc11_ = _loc13_.getTime() / 1000;
         _loc10_ = uint(STimingCore.ServerTime);
         _loc14_ = param3[0] + param3[1];
         _loc15_ = (_loc10_ - _loc11_) % (_loc14_ * 86400);
         _loc16_ = Math.floor((_loc10_ - _loc11_ - _loc15_) / (_loc14_ * 86400));
         if(param1 == TYPE_StartTime)
         {
            _loc12_ = _loc11_ + _loc16_ * _loc14_ * 86400;
         }
         else
         {
            _loc12_ = _loc11_ + _loc16_ * _loc14_ * 86400 + param3[0] * 86400;
         }
         return _loc12_;
      }
      
      protected function ProcessorGetFlushTime(param1:Vector.<uint>) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         _loc6_ = uint(STimingCore.ServerTick);
         _loc5_ = new Date(_loc6_ * 1000);
         _loc7_ = _loc5_.getFullYear();
         _loc8_ = _loc5_.getMonth();
         _loc9_ = _loc5_.getDate();
         _loc10_ = int(param1[0]);
         _loc11_ = int(param1[1]);
         _loc12_ = 0;
         _loc4_ = new Date(_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
         _loc3_ = _loc4_.getTime() / 1000;
         if(_loc5_ <= _loc4_)
         {
            _loc2_ = _loc3_ - _loc6_;
         }
         else
         {
            _loc2_ = _loc3_ + CONST_ACTIVITY.ALLDAY_TIME - _loc6_;
         }
         return _loc2_;
      }
      
      protected function ProcessorFormatActivityDesc() : void
      {
         if(this.FTF_Desc != null)
         {
            this.FTF_Desc.htmlText = this.FHDActivityConfig.Desc.toString();
         }
      }
      
      protected function ProcessorGetInventoriesVectByAwardID(param1:Vector.<uint>) : Vector.<TInventories>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TInventories> = null;
         _loc3_ = int(param1.length);
         _loc4_ = new Vector.<TInventories>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_[_loc2_] = this.ProcessorGetInventories(param1[_loc2_]);
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function ProcessorGetInventories(param1:uint = 0, param2:Vector.<TFixedAward> = null) : TInventories
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAward = null;
         var _loc6_:Vector.<TFixedAward> = null;
         var _loc7_:TInventories = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:TInventory = null;
         if(param2 != null)
         {
            _loc6_ = param2;
         }
         else
         {
            _loc5_ = this.FAwardBins.GetDatebaseByIdentifier(param1) as TAward;
            _loc4_ = int(_loc5_.FixedAwards.length);
            _loc6_ = new Vector.<TFixedAward>(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_[_loc3_] = _loc5_.FixedAwards[_loc3_];
               _loc3_++;
            }
         }
         _loc4_ = int(_loc6_.length);
         _loc8_ = new Vector.<uint>(_loc4_);
         _loc9_ = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_[_loc3_] = CONST_COMMON.RewardIDToTemplateID(_loc6_[_loc3_].Type,_loc6_[_loc3_].Code);
            _loc9_[_loc3_] = _loc6_[_loc3_].Amount;
            _loc3_++;
         }
         _loc7_ = new TInventories();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc7_,_loc8_);
         _loc4_ = _loc7_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc10_ = _loc7_.GetInventoryByIndex(_loc3_);
            _loc10_.Quantity = _loc9_[_loc3_];
            _loc3_++;
         }
         return _loc7_;
      }
      
      protected function Reset() : void
      {
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
      }
      
      protected function WindowInformationOnCancel(param1:Object) : void
      {
      }
      
      protected function Perform_CS_ActivityOperateReq(param1:uint, param2:uint, param3:uint = 0, param4:Vector.<int> = null) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 <= 0)
         {
            return;
         }
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc5_.Data.writeUnsignedInt(param1);
         _loc5_.Data.writeUnsignedInt(param2);
         if(param4 != null)
         {
            _loc7_ = int(param4.length);
            _loc5_.Data.writeShort(_loc7_);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc5_.Data.writeInt(param4[_loc6_]);
               _loc6_++;
            }
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function ProcessorPageOnChange(param1:Object, param2:int) : void
      {
         if(this.FPageIndex == param2)
         {
            return;
         }
         this.FPageIndex = param2;
         this.UpdateUIConfig();
         this.UpdateUI();
      }
      
      protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
      }
      
      protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function BtnChargeOnClcik(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param2);
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         if(this.FOnGiftBoxMove != null)
         {
            this.FOnGiftBoxMove(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         if(this.FOnGiftBoxOut != null)
         {
            this.FOnGiftBoxOut(param1);
         }
      }
      
      protected function GoldBuy(param1:uint, param2:Function, param3:String = null, param4:Boolean = false) : void
      {
         TUtilityLobby.GoldBuy(param1,param2,param3,param4);
      }
      
      public function get OnShortcutHyperlinks() : Function
      {
         return this.FOnShortcutHyperlinks;
      }
      
      public function set OnShortcutHyperlinks(param1:Function) : void
      {
         this.FOnShortcutHyperlinks = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnHintOver() : Function
      {
         return this.FOnHintOver;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function get OnHintOut() : Function
      {
         return this.FOnHintOut;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function get UpdateStatus() : Function
      {
         return this.FUpdateStatus;
      }
      
      public function set UpdateStatus(param1:Function) : void
      {
         this.FUpdateStatus = param1;
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function get OnBtnCloseClick() : Function
      {
         return this.FOnBtnCloseClick;
      }
      
      public function set OnBtnCloseClick(param1:Function) : void
      {
         this.FOnBtnCloseClick = param1;
      }
      
      public function get OnGiftBoxMove() : Function
      {
         return this.FOnGiftBoxMove;
      }
      
      public function set OnGiftBoxMove(param1:Function) : void
      {
         this.FOnGiftBoxMove = param1;
      }
      
      public function get OnGiftBoxOut() : Function
      {
         return this.FOnGiftBoxOut;
      }
      
      public function set OnGiftBoxOut(param1:Function) : void
      {
         this.FOnGiftBoxOut = param1;
      }
      
      public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         if(param1 != null)
         {
            this.FActivityAtoms = param1;
         }
         if(param2 != null)
         {
            this.FHDActivityConfig = param2;
            this.UpdateUIConfig();
         }
         if(param3 != null)
         {
            this.UpdateDataBase(param3);
         }
         this.visible = true;
      }
      
      public function Hide() : void
      {
         this.visible = false;
         this.Reset();
      }
      
      public function ProcessorUpDateDataBase(param1:TActivityOSBase) : void
      {
         this.UpdateDataBase(param1);
      }
      
      public function ProcessorUpDateStatus(param1:uint, param2:int, param3:Vector.<uint>) : void
      {
         this.UpdataStatus(param1,param2,param3);
      }
   }
}

