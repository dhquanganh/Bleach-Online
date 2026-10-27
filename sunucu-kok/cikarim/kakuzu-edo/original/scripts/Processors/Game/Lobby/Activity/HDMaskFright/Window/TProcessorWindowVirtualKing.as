package Processors.Game.Lobby.Activity.HDMaskFright.Window
{
   import Components.Slots.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDActivityRecharge.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDMaskFright.Component.TVirtualGiftItem;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowVirtualKing extends THDOSTabWindowBase
   {
      
      protected static const GIFTITEM_NUM:uint = 10;
      
      protected static const COUNT_SLOT_Equip:uint = 8;
      
      protected static const FIXEDAWARDS_SUPEREQUIPMENT:Vector.<Object> = Vector.<Object>([{
         "type":1,
         "code":14210057,
         "amount":1
      },{
         "type":1,
         "code":14210058,
         "amount":1
      },{
         "type":1,
         "code":14210059,
         "amount":1
      },{
         "type":1,
         "code":14210060,
         "amount":1
      },{
         "type":1,
         "code":14210061,
         "amount":1
      },{
         "type":1,
         "code":14210062,
         "amount":1
      },{
         "type":1,
         "code":14210063,
         "amount":1
      },{
         "type":1,
         "code":14210064,
         "amount":1
      }]);
      
      protected var FTotalCostBin:THDTotalCost;
      
      protected var FTotalCostData:THDTotalCostData;
      
      protected var FStateBox:Vector.<int>;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FGiftBoxList:Vector.<TVirtualGiftItem>;
      
      protected var FInventoriesList:Vector.<TInventories>;
      
      protected var FTF_NextNeed:TextField;
      
      protected var FTF_TodayCur:TextField;
      
      protected var FTF_Bar:TextField;
      
      protected var FMC_Bar:MovieClip;
      
      protected var FSlots_Equip:Vector.<TUISlot>;
      
      protected var FEquipInventories:TInventories;
      
      protected var FFixedAwards:Vector.<TFixedAward>;
      
      public function TProcessorWindowVirtualKing(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_TotaleCost;
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FStateBox = new Vector.<int>();
         FBoxStatus = this.FStateBox;
         this.FGiftBoxList = new Vector.<TVirtualGiftItem>(GIFTITEM_NUM);
         this.FInventoriesList = new Vector.<TInventories>(GIFTITEM_NUM);
         this.FTotalCostData = new THDTotalCostData();
         this.FEquipInventories = new TInventories();
         this.FFixedAwards = new Vector.<TFixedAward>(COUNT_SLOT_Equip);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityMaskFright);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FSlots_Equip == null || this.FSlots_Equip.length <= 0)
         {
            return;
         }
         _loc2_ = int(this.FSlots_Equip.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots_Equip[_loc1_].Update();
            _loc1_++;
         }
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TVirtualGiftItem = null;
         var _loc6_:TUISlot = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_VirtualKing) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc3_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Exp];
         this.FTF_NextNeed = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_NextNeed];
         this.FTF_TodayCur = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_TodayCur];
         this.FTF_Bar = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_Bar];
         this.FMC_Bar = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         _loc2_ = int(GIFTITEM_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_GiftBoxs + _loc1_];
            _loc5_ = new TVirtualGiftItem(this,_loc4_);
            _loc5_.Tag = _loc1_;
            _loc5_.OnBoxMove = this.GiftBoxOnMove;
            _loc5_.OnBoxOut = this.GiftBoxOnOut;
            _loc5_.OnBoxGet = this.BtnOKOnClick;
            _loc5_.Init();
            this.FGiftBoxList[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc3_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_SuperEquip];
         if(_loc3_ != null)
         {
            _loc2_ = int(COUNT_SLOT_Equip);
            this.FSlots_Equip = new Vector.<TUISlot>(_loc2_);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc6_ = new TUISlot(this);
               _loc6_.OnOver = ProcessorOnSlotOver;
               _loc6_.OnOut = ProcessorOnSlotOut;
               _loc6_.OnQueryEdgeColor = SlotsOnQueryEdgeColor;
               _loc6_.OnQuerySubscript = SlotsOnQuerySubscript;
               _loc6_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
               _loc6_.Resource = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc1_];
               _loc6_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
               _loc6_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
               _loc6_.Init();
               this.FSlots_Equip[_loc1_] = _loc6_;
               _loc1_++;
            }
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:TFixedAward = null;
         var _loc5_:Vector.<Object> = null;
         super.UpdateUIConfig();
         this.FTotalCostBin = FHDActivityConfig as THDTotalCost;
         this.FStateBox.length = this.FTotalCostBin.ActAwards.length;
         _loc3_ = new Vector.<uint>(GIFTITEM_NUM);
         _loc2_ = int(GIFTITEM_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FTotalCostBin.ActAwards[_loc1_].Awards[0];
            _loc1_++;
         }
         this.FInventoriesList = ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc5_ = this.FTotalCostBin.EquipShowVec;
         _loc2_ = int(COUNT_SLOT_Equip);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TFixedAward(_loc5_[_loc1_]);
            this.FFixedAwards[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FEquipInventories = ProcessorGetInventories(0,this.FFixedAwards);
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FTotalCostData = param1 as THDTotalCostData;
         this.FStateBox.length = 0;
         _loc3_ = this.FTotalCostData.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStateBox.push(this.FTotalCostData.GetAwardByIndex(_loc2_).State);
            _loc2_++;
         }
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         this.UpdateTotalCost();
         _loc2_ = int(COUNT_SLOT_Equip);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots_Equip[_loc1_].Context = this.FEquipInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      private function UpdateTotalCost() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TAwardData = null;
         var _loc5_:TVirtualGiftItem = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         _loc2_ = GIFTITEM_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FGiftBoxList[_loc1_];
            _loc4_ = this.FTotalCostData.GetAwardByIndex(_loc1_);
            _loc5_.UpdateState(_loc4_.State,_loc4_.Name);
            _loc1_++;
         }
         this.FTF_TodayCur.text = this.FTotalCostData.TotalCost.toString();
         _loc2_ = GIFTITEM_NUM;
         _loc7_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FTotalCostData.GetAwardByIndex(_loc1_);
            if(_loc4_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               _loc7_ = uint(_loc4_.Name) - this.FTotalCostData.TotalCost;
               break;
            }
            _loc1_++;
         }
         _loc9_ = uint(this.FTotalCostData.GetAwardByIndex(GIFTITEM_NUM - 1).Name);
         _loc8_ = this.FTotalCostData.TotalCost / _loc9_;
         if(_loc8_ > 1)
         {
            _loc8_ = 1;
         }
         this.FMC_Bar.scaleX = _loc8_;
         if(_loc1_ == GIFTITEM_NUM)
         {
            this.FTF_Bar.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_18),_loc9_,_loc9_,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_20));
            this.FTF_NextNeed.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_22);
         }
         else
         {
            this.FTF_Bar.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_18),this.FTotalCostData.TotalCost,_loc9_,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_20));
            this.FTF_NextNeed.text = _loc7_.toString();
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDTotalCost,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FTotalCostBin = FHDActivityConfig as THDTotalCost;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetTotalCostData(FActivityInitRetData,this.FTotalCostData);
         this.UpdateDataBase(this.FTotalCostData);
      }
      
      private function SetTotalCostData(param1:TActivityInitRetData, param2:THDTotalCostData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TAwardData = null;
         param2.ClearAward();
         _loc4_ = param1.AwardStates.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.AwardStates[_loc3_];
            _loc6_ = new TAwardData();
            _loc6_.State = _loc5_.State;
            _loc6_.BoxIndex = _loc5_.BoxIndex;
            param2.AddAward(_loc6_);
            _loc3_++;
         }
         param2.TotalCost = param1.ParameterVec[0];
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateTotalCost(param2,this.FTotalCostBin);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(this.FSlots_Equip == null || this.FSlots_Equip.length <= 0)
         {
            return;
         }
         _loc2_ = int(this.FSlots_Equip.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots_Equip[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
      }
      
      protected function GiftBoxOnMove(param1:Object, param2:uint) : void
      {
         ProcessorOnGiftBoxMove(param1,this.FInventoriesList[param2]);
      }
      
      protected function GiftBoxOnOut(param1:Object) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:TAwardData = null;
         super.ChangeActivityStatus(param1,param2);
         _loc3_ = this.FTotalCostData.GetAwardByIndex(param2.Index);
         _loc3_.State = param2.Status;
         this.UpdateDataBase(this.FTotalCostData);
         UpDateStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

