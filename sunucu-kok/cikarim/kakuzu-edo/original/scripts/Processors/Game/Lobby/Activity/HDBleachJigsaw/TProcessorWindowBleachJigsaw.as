package Processors.Game.Lobby.Activity.HDBleachJigsaw
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDBleachJigsaw.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Activity.HDBleachJigsaw.Component.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowBleachJigsaw extends TProcessorLobbyWindow
   {
      
      public static const COUNT_FINALAWARD:uint = 5;
      
      public static const COUNT_JIGSAW:uint = 25;
      
      public static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      public static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      public static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const TYPE_StartTime:uint = 0;
      
      protected static const TYPE_EndTime:uint = 1;
      
      protected var FBtn_close:TUIButton;
      
      protected var FMC_HDDesc:Sprite;
      
      protected var FTF_OpenTime:TextField;
      
      protected var FTF_CoolingTime:TextField;
      
      protected var FMC_Jigsaw:Sprite;
      
      protected var FTF_FreeCD:TextField;
      
      protected var FBtn_NormalOpen:TUIButton;
      
      protected var FBtn_LuckyOpen:TUIButton;
      
      protected var FBtn_AllOpen:TUIButton;
      
      protected var FMC_ScollBar:TScrollBar;
      
      protected var FMC_Bar:Sprite;
      
      protected var FMC_FinalAwardsVec:Vector.<TUISlot>;
      
      protected var FBtn_GetAward:TUIButton;
      
      protected var FMC_AwardBar:Vector.<TUIAwardItem>;
      
      protected var FMC_AllGet:MovieClip;
      
      protected var FMC_JigsawSlot:Vector.<Sprite>;
      
      protected var FIsShowOneGet:Boolean;
      
      protected var FCurStatus:uint;
      
      protected var FActivityAtoms:TActivityAtoms;
      
      protected var FHDActivityConfig:THDBleachJigSaw;
      
      protected var FData:TActivityBleachJigsaw;
      
      protected var FHint:THint;
      
      protected var FTF_Desc:TextField;
      
      protected var FDate:Date;
      
      protected var FEndTime:uint;
      
      protected var FIsInitCoolingTime:Boolean;
      
      protected var FAwardBins:TBins;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TProcessorWindowBleachJigsaw(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FDate = new Date();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FIsInitCoolingTime = false;
         this.FCurStatus = 0;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIAwardItem = null;
         var _loc5_:Sprite = null;
         var _loc6_:TUISlot = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MC_BleachJigsaw") as Sprite;
         addChild(_loc1_);
         this.FBtn_close = new TUIButton();
         this.FBtn_close.Substrate = _loc1_["btn_close"];
         this.FBtn_close.OnClick = this.CloseOnClick;
         this.FMC_HDDesc = _loc1_["MC_HDDesc"];
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_MOVE,this.OnDescOnOver);
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_OUT,this.OnDescOut);
         this.FTF_OpenTime = _loc1_["TF_OpenTime"];
         this.FTF_CoolingTime = _loc1_["TF_CoolingTime"];
         this.FMC_Jigsaw = _loc1_["MC_Jigsaw"];
         this.FMC_AllGet = this.FMC_Jigsaw["MC_AllGet"];
         this.FMC_JigsawSlot = new Vector.<Sprite>(COUNT_JIGSAW);
         _loc3_ = int(COUNT_JIGSAW);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_JigsawSlot[_loc2_] = this.FMC_Jigsaw["MC_Slot_" + _loc2_];
            _loc2_++;
         }
         this.FTF_FreeCD = _loc1_["TF_FreeCD"];
         this.FBtn_NormalOpen = new TUIButton();
         this.FBtn_NormalOpen.Substrate = _loc1_["Btn_NormalOpen"];
         this.FBtn_NormalOpen.OnClick = this.NormalOpenOnClick;
         this.FBtn_NormalOpen.OnMove = this.OnBtnNormalOnOver;
         this.FBtn_NormalOpen.OnOut = this.ProcessorOnHintOut;
         this.FBtn_LuckyOpen = new TUIButton();
         this.FBtn_LuckyOpen.Substrate = _loc1_["Btn_LuckyOpen"];
         this.FBtn_LuckyOpen.OnClick = this.LuckyOpenOnClick;
         this.FBtn_LuckyOpen.OnMove = this.OnBtnLuckyOnOver;
         this.FBtn_LuckyOpen.OnOut = this.ProcessorOnHintOut;
         this.FBtn_AllOpen = new TUIButton();
         this.FBtn_AllOpen.Substrate = _loc1_["Btn_AllOpen"];
         this.FBtn_AllOpen.OnClick = this.AllOpenOnClick;
         this.FBtn_AllOpen.OnMove = this.OnBtnAllGetOnOver;
         this.FBtn_AllOpen.OnOut = this.ProcessorOnHintOut;
         this.FMC_ScollBar = new TScrollBar(_loc1_["MC_ScollBar"],300,false,0,60);
         this.FMC_Bar = _loc1_["MC_Bar"];
         this.FMC_FinalAwardsVec = new Vector.<TUISlot>(COUNT_FINALAWARD);
         _loc3_ = int(COUNT_FINALAWARD);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = _loc1_["MC_Slot_" + _loc2_];
            _loc6_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc6_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc6_.OnOver = this.ProcessorOnSlotOver;
            _loc6_.OnOut = this.ProcessorOnSlotOut;
            _loc6_.Init();
            this.FMC_FinalAwardsVec[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FBtn_GetAward = new TUIButton();
         this.FBtn_GetAward.Substrate = _loc1_["Btn_GetAward"];
         this.FBtn_GetAward.OnClick = this.GetAwardOnClick;
         this.FBtn_GetAward.OnMove = this.OnBtnFinalGetOnOver;
         this.FBtn_GetAward.OnOut = this.ProcessorOnHintOut;
         _loc3_ = 5;
         this.FMC_AwardBar = new Vector.<TUIAwardItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIAwardItem(this);
            _loc4_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc4_.OnSlotOver = this.ProcessorOnSlotOver;
            _loc4_.OnSlotOut = this.ProcessorOnSlotOut;
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_JigsawAward") as Sprite;
            _loc4_.Perform_UIDispatch(_loc5_);
            this.FMC_AwardBar[_loc2_] = _loc4_;
            this.FMC_ScollBar.AddItem(_loc4_);
            _loc2_++;
         }
         this.FMC_ScollBar.Visible = true;
         if(this.FAwardBins == null)
         {
            this.FAwardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         this.ProcessorFormatActivityDesc();
         this.ProcessorFormatActivityTimeFromNowOn(this.FActivityAtoms.EndTime);
         this.ProcessorFormatActivityCountDown(this.FActivityAtoms.EndTime);
         _loc2_ = this.FHDActivityConfig.JigSawFinalAwardVec.length;
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHDActivityConfig.JigSawFinalAwardVec[_loc1_].Award;
            _loc1_++;
         }
         this.FAwardInventories = this.ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_FinalAwardsVec[_loc1_].Context = this.FAwardInventories[0].GetInventoryByIndex(_loc1_);
            this.FMC_FinalAwardsVec[_loc1_].Update();
            _loc1_++;
         }
         _loc2_ = this.FHDActivityConfig.JigSawNeedsVec.length;
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHDActivityConfig.JigSawNeedsVec[_loc1_][0].Award;
            _loc1_++;
         }
         this.FAwardInventories = this.ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardBar[_loc1_].UpdateUI(_loc1_,this.FAwardInventories[_loc1_].GetInventoryByIndex(0),this.FHDActivityConfig.JigSawNeedsVec[_loc1_]);
            _loc1_++;
         }
         this.Update();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(this.FHDActivityConfig == null)
         {
            return;
         }
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_FinalAwardsVec[_loc1_].Update();
            _loc1_++;
         }
         if(this.FIsShowOneGet == true)
         {
            this.ShowOneGet();
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
      
      protected function HDDescOnMove(param1:MouseEvent) : void
      {
         if(this.FMC_HDDesc != null)
         {
            this.FHDActivityConfig.Tip;
         }
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function NormalOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FIsShowOneGet)
         {
            this.FCurStatus = 24;
            this.ShowOneGet();
         }
         this.ShowOneGet();
      }
      
      protected function LuckyOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function AllOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ShowAllGet();
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function ShowAllGet() : void
      {
         this.FMC_AllGet.play();
      }
      
      protected function ShowOneGet() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:uint = 0;
         _loc4_ = new Vector.<uint>();
         _loc3_ = 25;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_.push(uint(25 * Math.random()));
            _loc2_++;
         }
         this.FIsShowOneGet = true;
         _loc1_ = this.FMC_JigsawSlot[_loc4_[this.FCurStatus]]["MC_Mask"]["MC_Border"] as MovieClip;
         _loc1_.play();
         if(_loc1_.currentFrame == _loc1_.totalFrames && this.FCurStatus < 24)
         {
            ++this.FCurStatus;
            _loc1_.gotoAndStop(0);
         }
         if(this.FCurStatus == 24)
         {
            this.FIsShowOneGet = false;
            this.FCurStatus = 0;
            _loc1_ = this.FMC_JigsawSlot[5]["MC_Mask"]["MC_Border"] as MovieClip;
            _loc1_.gotoAndPlay(1);
            _loc1_ = this.FMC_JigsawSlot[5]["MC_Mask"]["MC_Get"] as MovieClip;
            _loc1_.gotoAndPlay(1);
         }
      }
      
      protected function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         _loc2_ = COUNT_JIGSAW;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
         }
      }
      
      protected function Reset() : void
      {
      }
      
      protected function OnBtnNormalOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = "1";
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnBtnLuckyOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = "2";
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnBtnAllGetOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = "3";
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnBtnFinalGetOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = "4";
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function ProcessorOnHintOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
      }
      
      protected function OnDescOnOver(param1:MouseEvent) : void
      {
         this.FHint.Caption = this.FHDActivityConfig.Tip;
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnDescOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
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
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         if(param1 != null)
         {
            this.FActivityAtoms = param1;
         }
         if(param2 != null)
         {
            this.FHDActivityConfig = param2 as THDBleachJigSaw;
            this.UpdateUIConfig();
         }
         if(param3 != null)
         {
            this.FData = param3 as TActivityBleachJigsaw;
         }
         this.visible = true;
      }
      
      public function Hide() : void
      {
         this.visible = false;
         this.Reset();
      }
   }
}

