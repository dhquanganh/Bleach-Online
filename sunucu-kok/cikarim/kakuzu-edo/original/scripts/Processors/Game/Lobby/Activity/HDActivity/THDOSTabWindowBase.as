package Processors.Game.Lobby.Activity.HDActivity
{
   import Components.Standard.*;
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
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivity.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class THDOSTabWindowBase extends TProcessorLobbyWindow
   {
      
      protected static const MAX_AWARD_COUNT:uint = 10;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_Scene:Sprite;
      
      protected var FMC_MountPoint:Sprite;
      
      protected var FBitmapTitle:Bitmap;
      
      protected var FTF_Title:TextField;
      
      protected var FMC_Prompt:Sprite;
      
      protected var FTF_OpenTime:TextField;
      
      protected var FTF_CoolingTime:TextField;
      
      protected var FTF_Desc:TextField;
      
      protected var FMC_GotoLink:MovieClip;
      
      protected var FBtn_GotoLink:TUIButton;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FHDActivityConfig:THDActivityBase;
      
      protected var FIsInitLoadConfig:Boolean;
      
      protected var FIsInitCoolingTime:Boolean;
      
      protected var FTitleSubstrateID:uint;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FDate:Date;
      
      protected var FEndTime:uint;
      
      protected var FAwardBins:TBins;
      
      protected var FBoxStatus:Vector.<int>;
      
      protected var FActivityAtoms:TActivityAtoms;
      
      protected var FMemoryID:uint;
      
      protected var FNeedBanner:Boolean;
      
      protected var FUnstreamizerActivity:TUnstreamizerActivity;
      
      protected var FActivityInitRetData:TActivityInitRetData;
      
      protected var FTabUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FTabUIWindowRecharge:TUIWindowRecharge;
      
      protected var FormatString_TimeStartToEnd:String;
      
      protected var FGetActivityConfig:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FUpdateStatus:Function;
      
      protected var FOnLookInfo:Function;
      
      protected var FActivityID:uint;
      
      protected var FOnGiftBoxMove:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      public function THDOSTabWindowBase(param1:TUIComponent)
      {
         super(param1);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FIsInitLoadConfig = false;
         this.FIsInitCoolingTime = false;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FDate = new Date();
         this.FMemoryID = 0;
         this.FUnstreamizerActivity = new TUnstreamizerActivity();
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
         if(this.FIsInitCoolingTime)
         {
            this.SetCountDown();
         }
      }
      
      protected function InitWindow() : void
      {
         this.FMC_Prompt = this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Prompt];
         this.FMC_MountPoint = this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_MountPoint];
         this.FBitmapTitle = new Bitmap();
         if(this.FMC_MountPoint != null)
         {
            this.FMC_MountPoint.addChild(this.FBitmapTitle);
            this.FNeedBanner = true;
         }
         this.FTF_Title = this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_TF_Title];
         this.FTF_OpenTime = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_OpenTime];
         this.FTF_CoolingTime = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_CoolingTime];
         this.FTF_Desc = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_Desc];
         this.FMC_GotoLink = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_BTN_GotoLink];
         if(this.FMC_GotoLink != null)
         {
            this.FBtn_GotoLink = new TUIButton();
            this.FBtn_GotoLink.Substrate = this.FMC_GotoLink;
            this.FBtn_GotoLink.OnClick = this.BtnGotoLinkOnClcik;
         }
         if(this.FAwardBins == null)
         {
            this.FAwardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         }
         this.FTabUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FTabUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FormatString_TimeStartToEnd = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_02);
      }
      
      protected function UpdateUI() : void
      {
         if(this.FNeedBanner)
         {
            this.ProcessorShowTitleImage();
         }
      }
      
      protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
      }
      
      protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc4_ = Activity_AlreadyReceive;
         this.FBoxStatus[param1] = param2;
         _loc5_ = this.FBoxStatus.length;
         param1 = 0;
         while(param1 < _loc5_)
         {
            if(this.FBoxStatus[param1] >= Activity_CanReceive)
            {
               _loc4_ = Activity_CanReceive;
               break;
            }
            if(this.FBoxStatus[param1] == Activity_CanNotReceive)
            {
               _loc4_ = Activity_CanNotReceive;
            }
            param1++;
         }
         if(this.FUpdateStatus != null)
         {
            this.FUpdateStatus(this.FActivityAtoms.Identifier,_loc4_);
         }
      }
      
      protected function UpdateUIConfig() : void
      {
         this.ProcessorShowTitle();
         if(this.FNeedBanner)
         {
            this.ProcessorShowTitleImage();
         }
         this.ProcessorFormatActivityDesc();
      }
      
      protected function ProcessorShowTitleImage() : void
      {
         this.FTitleSubstrateID = this.FHDActivityConfig.ImageID;
         SResourcesCore.TexturesActivityBanner.LoadAutoSecondary(this.FTitleSubstrateID,this.AutoLoadCallBack);
      }
      
      protected function ProcessorShowTitle() : void
      {
         if(this.FTF_Title != null)
         {
            this.FTF_Title.text = this.FHDActivityConfig.TName;
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FTitleSubstrateID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FBitmapTitle.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
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
         this.FTF_CoolingTime.text = this.FormatTime(this.FEndTime - STimingCore.ServerTime);
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
         this.FEndTime = param1;
         _loc2_ = uint(STimingCore.ServerTime);
         if(this.FEndTime - _loc2_ <= 0)
         {
            this.FTF_CoolingTime.text = this.FormatTime(0);
         }
         else
         {
            this.FIsInitCoolingTime = true;
            this.FTF_CoolingTime.text = this.FormatTime(this.FEndTime - _loc2_);
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
      
      protected function ProcessorGetDayFromTime(param1:uint) : String
      {
         var _loc2_:Date = null;
         var _loc3_:String = null;
         _loc2_ = new Date(param1 * 1000);
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_34),_loc2_.getMonth() + 1,_loc2_.getDate().toString());
      }
      
      protected function ProcessorFormatActivityDesc() : void
      {
         if(this.FTF_Desc != null)
         {
            this.FTF_Desc.text = this.FHDActivityConfig.Desc.toString();
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
      
      protected function Perform_CS_ActivityInitReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         if(param1 <= 0)
         {
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_InitReq);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function Perform_CS_ActivityOperateReq(param1:uint, param2:uint, param3:uint = 1) : void
      {
         var _loc4_:TPacket = null;
         if(param1 <= 0)
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc4_.Data.writeUnsignedInt(param1);
         _loc4_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function GetActivityConfigByActivityAtoms(param1:TActivityAtoms) : void
      {
         var _loc2_:uint = 0;
         if(this.FGetActivityConfig != null)
         {
            this.FHDActivityConfig = this.FGetActivityConfig(this,param1.ActivityNumber) as THDActivityBase;
         }
         this.UpdateUIConfig();
      }
      
      protected function UpdateUIList() : void
      {
      }
      
      protected function Reset() : void
      {
         this.FBitmapTitle.bitmapData = null;
      }
      
      protected function UpdateSCData(param1:ByteArray) : void
      {
         if(this.FActivityAtoms == null)
         {
            return;
         }
      }
      
      protected function TabWindowInformationOnOK(param1:Object) : void
      {
      }
      
      protected function TabWindowInformationOnCancel(param1:Object) : void
      {
      }
      
      protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         this.Perform_CS_ActivityOperateReq(this.FActivityAtoms.Identifier,param2);
      }
      
      protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function TextGotoLinkOnClick(param1:Object, param2:uint) : void
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
      
      protected function PorcessorOnHintOver(param1:Object, param2:THint) : void
      {
      }
      
      protected function ProcessorOnHintOut(param1:Object) : void
      {
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
      
      public function get GetActivityConfig() : Function
      {
         return this.FGetActivityConfig;
      }
      
      public function set GetActivityConfig(param1:Function) : void
      {
         this.FGetActivityConfig = param1;
      }
      
      public function set ActivityID(param1:uint) : void
      {
         this.FActivityID = param1;
      }
      
      public function get ActivityID() : uint
      {
         return this.FActivityID;
      }
      
      public function get UpdateStatus() : Function
      {
         return this.FUpdateStatus;
      }
      
      public function set UpdateStatus(param1:Function) : void
      {
         this.FUpdateStatus = param1;
      }
      
      public function get HDActivityConfig() : THDActivityBase
      {
         return this.FHDActivityConfig;
      }
      
      public function get OnLookInfo() : Function
      {
         return this.FOnLookInfo;
      }
      
      public function set OnLookInfo(param1:Function) : void
      {
         this.FOnLookInfo = param1;
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
      
      public function Show(param1:TActivityAtoms) : void
      {
         this.FActivityAtoms = param1;
         if(this.FMemoryID != param1.Identifier)
         {
            this.GetActivityConfigByActivityAtoms(param1);
            this.FMemoryID = param1.Identifier;
         }
         if(this.FBtn_GotoLink != null)
         {
            this.FBtn_GotoLink.Enabled = true;
         }
         this.visible = true;
      }
      
      public function Hide() : void
      {
         this.visible = false;
         this.Reset();
      }
      
      public function ActivityInitReq(param1:uint) : void
      {
         this.Perform_CS_ActivityInitReq(param1);
      }
      
      public function UpDateDataBase(param1:TActivityOSBase) : void
      {
         this.UpdateDataBase(param1);
      }
      
      public function UpDateStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         this.UpdataStatus(param1,param2,param3);
      }
      
      public function ActivityInitRet(param1:ByteArray, param2:TActivityAtoms) : void
      {
         this.FActivityAtoms = param2;
         this.UpdateSCData(param1);
      }
      
      public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
      }
      
      public function ChangeValue(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         if(!this.Visible)
         {
            return;
         }
      }
      
      public function OperateRet() : void
      {
         if(!this.Visible)
         {
            return;
         }
      }
      
      public function ProcessorReset() : void
      {
         this.Reset();
      }
   }
}

