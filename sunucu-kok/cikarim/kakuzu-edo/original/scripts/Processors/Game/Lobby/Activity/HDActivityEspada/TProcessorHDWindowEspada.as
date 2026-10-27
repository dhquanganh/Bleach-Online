package Processors.Game.Lobby.Activity.HDActivityEspada
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDActivitySingle.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityEspada.Component.TUIActivitySingleAwardList;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowEspada extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_TAB:uint = 10;
      
      protected static const COUNT_SLOT_AwardList:uint = 6;
      
      protected static const COUNT_TF_AwardList:uint = 2;
      
      protected static const COUNT_SLOT_BuyList:uint = 6;
      
      protected static const COUNT_TF_BuyList:uint = 3;
      
      protected static const COUNT_EFFECT_TabMovieclip:uint = 3;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const MAX_STAGE:uint = 10;
      
      protected var FMC_Award:Sprite;
      
      protected var FMC_BuyBag:Sprite;
      
      protected var FMC_TabVect:Vector.<TUIButton>;
      
      protected var FMC_TabOKVect:Vector.<TUIButton>;
      
      protected var FMC_TabNOVect:Vector.<TUIButton>;
      
      protected var FMC_SelectVect:Vector.<Sprite>;
      
      protected var FTF_CurIndex:TextField;
      
      protected var FTF_CurReCharge:TextField;
      
      protected var FTabEffects:Vector.<MovieClip>;
      
      protected var FDataEspada:TActivitySingleEspada;
      
      protected var FHDEspada:THDActivityEspada;
      
      protected var FSelectIndex:int;
      
      protected var FCurIndex:int;
      
      protected var FAwardList:TUIActivitySingleAwardList;
      
      protected var FBuyList:TUIActivityOSAwardList;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FBuyInventoriesVect:Vector.<TInventories>;
      
      protected var FTabSerchStatus:Vector.<int>;
      
      public function TProcessorHDWindowEspada(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleEspada;
         this.FAwardInventoriesVect = new Vector.<TInventories>();
         this.FBuyInventoriesVect = new Vector.<TInventories>();
         this.FSelectIndex = 0;
         this.FTabSerchStatus = new Vector.<int>(COUNT_TAB);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FAwardList != null)
         {
            this.FAwardList.UpDateSlot();
         }
         if(this.FBuyList != null)
         {
            this.FBuyList.UpDateSlot();
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TUIButton = null;
         super.InitWindow(param1);
         this.FMC_Award = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FMC_BuyBag = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_BuyBag];
         this.FAwardList = new TUIActivitySingleAwardList(this);
         this.FAwardList.OnBtnOkClick = this.AwardBtnOnClick;
         this.FAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FAwardList.Perform_UIDispatch(this.FMC_Award,COUNT_TF_AwardList,COUNT_SLOT_AwardList,false);
         this.FBuyList = new TUIActivityOSAwardList(this);
         this.FBuyList.OnBtnOkClick = this.BuyBtnOnClick;
         this.FBuyList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FBuyList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FBuyList.OnSlotOver = ProcessorOnSlotOver;
         this.FBuyList.OnSlotOut = ProcessorOnSlotOut;
         this.FBuyList.Perform_UIDispatch(this.FMC_BuyBag,COUNT_TF_BuyList,COUNT_SLOT_BuyList,false);
         _loc3_ = int(COUNT_TAB);
         this.FTabEffects = new Vector.<MovieClip>(COUNT_EFFECT_TabMovieclip);
         this.FMC_TabNOVect = new Vector.<TUIButton>(_loc3_);
         this.FMC_TabOKVect = new Vector.<TUIButton>(_loc3_);
         this.FMC_TabVect = new Vector.<TUIButton>(_loc3_);
         this.FMC_SelectVect = new Vector.<Sprite>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabNO + _loc2_];
            _loc4_.OnClick = this.TabOnClick;
            _loc4_.Visible = false;
            this.FMC_TabNOVect[_loc2_] = _loc4_;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabOK + _loc2_];
            _loc5_.OnClick = this.TabOnClick;
            _loc5_.Visible = false;
            this.FMC_TabOKVect[_loc2_] = _loc5_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabNormal + _loc2_];
            _loc6_.OnClick = this.TabOnClick;
            _loc6_.Visible = false;
            this.FMC_TabVect[_loc2_] = _loc6_;
            this.FMC_SelectVect[_loc2_] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Select + _loc2_];
            this.FMC_SelectVect[_loc2_].mouseChildren = false;
            this.FMC_SelectVect[_loc2_].mouseEnabled = false;
            this.FMC_SelectVect[_loc2_].visible = false;
            if(_loc2_ == _loc3_ - 1)
            {
               this.FTabEffects[0] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabNO + _loc2_][CONST_ACTIVITY.RESOURCE_Link_MC_BtnElement];
               this.FTabEffects[0].stop();
               this.FTabEffects[1] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabOK + _loc2_][CONST_ACTIVITY.RESOURCE_Link_MC_BtnElement];
               this.FTabEffects[1].stop();
               this.FTabEffects[2] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabNormal + _loc2_][CONST_ACTIVITY.RESOURCE_Link_MC_BtnElement];
               this.FTabEffects[2].stop();
            }
            _loc2_++;
         }
         this.FTF_CurIndex = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurIndex];
         this.FTF_CurIndex.mouseEnabled = false;
         this.FTF_CurIndex.text = "";
         this.FTF_CurReCharge = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurRecharge];
         this.FTF_CurReCharge.mouseEnabled = false;
         this.FTF_CurReCharge.text = "";
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDEspada = FHDActivityConfig as THDActivityEspada;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDEspada.Awards);
         this.FBuyInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDEspada.BuyAwards);
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UpdateDataBase(param1);
         this.FDataEspada = param1 as TActivitySingleEspada;
         _loc3_ = int(COUNT_TAB);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataEspada.AwardStatus[_loc2_] == Activity_AlreadyReceive)
            {
               this.FTabSerchStatus[_loc2_] = Activity_AlreadyReceive;
            }
            else
            {
               this.FTabSerchStatus[_loc2_] = Activity_CanReceive;
            }
            _loc2_++;
         }
         if(this.FTabSerchStatus.indexOf(Activity_CanReceive) == -1)
         {
            this.FSelectIndex = COUNT_TAB - 1;
         }
         else
         {
            this.FSelectIndex = this.FTabSerchStatus.indexOf(Activity_CanReceive);
         }
         this.UpdateUI();
         this.CheckEffectStatus();
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateUITab();
         this.FTF_CurReCharge.text = this.FDataEspada.TotalPay.toString();
         if(MAX_STAGE - this.FDataEspada.CurIndex > MAX_STAGE)
         {
            this.FTF_CurIndex.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
         }
         else
         {
            this.FTF_CurIndex.text = (MAX_STAGE - this.FDataEspada.CurIndex).toString();
         }
         this.UpdateUIList();
      }
      
      protected function UpdateUITab() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FCurIndex = this.FDataEspada.CurIndex;
         _loc2_ = int(COUNT_TAB);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ <= this.FCurIndex)
            {
               this.TabVisibleNotify(this.FMC_TabNOVect,_loc1_,false);
               this.TabVisibleNotify(this.FMC_TabVect,_loc1_,true);
               if(this.FDataEspada.AwardStatus[_loc1_] == Activity_AlreadyReceive && this.FDataEspada.BuyStatus[_loc1_] == Activity_AlreadyReceive)
               {
                  this.TabVisibleNotify(this.FMC_TabVect,_loc1_,false);
                  this.TabVisibleNotify(this.FMC_TabOKVect,_loc1_,true);
               }
               else
               {
                  this.TabVisibleNotify(this.FMC_TabOKVect,_loc1_,false);
                  this.TabVisibleNotify(this.FMC_TabVect,_loc1_,true);
               }
            }
            else
            {
               this.TabVisibleNotify(this.FMC_TabVect,_loc1_,false);
               this.TabVisibleNotify(this.FMC_TabNOVect,_loc1_,true);
            }
            _loc1_++;
         }
      }
      
      protected function TabVisibleNotify(param1:Vector.<TUIButton>, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2 == COUNT_TAB - 1)
         {
            _loc5_ = int(COUNT_EFFECT_TabMovieclip);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(param3)
               {
                  this.FTabEffects[_loc4_].play();
               }
               else
               {
                  this.FTabEffects[_loc4_].stop();
               }
               _loc4_++;
            }
         }
         param1[param2].Visible = param3;
      }
      
      protected function UpdateUIList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:Vector.<String> = null;
         _loc2_ = int(this.FMC_SelectVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == this.FSelectIndex)
            {
               this.FMC_SelectVect[_loc1_].visible = true;
            }
            else
            {
               this.FMC_SelectVect[_loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc3_ = new Vector.<String>(COUNT_TF_AwardList);
         _loc4_ = new Vector.<String>(COUNT_TF_BuyList);
         _loc3_[0] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_36),MAX_STAGE - this.FSelectIndex);
         _loc3_[1] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_37),MAX_STAGE - this.FSelectIndex);
         this.FAwardList.UpDateUI(this.FSelectIndex,this.FAwardInventoriesVect[this.FSelectIndex],_loc3_);
         this.FAwardList.UpdateUIProgressBar(this.FDataEspada.TotalPay,this.FHDEspada.AwardsConditions[this.FSelectIndex].Key);
         _loc4_[0] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_37),MAX_STAGE - this.FSelectIndex);
         _loc4_[1] = this.FHDEspada.BuyConditions[this.FSelectIndex].Need.toString();
         if(this.FDataEspada.BuyStatus[this.FSelectIndex] == Activity_AlreadyReceive)
         {
            _loc4_[2] = "0";
         }
         else
         {
            _loc4_[2] = this.FDataEspada.BuyStatus[this.FSelectIndex].toString();
         }
         this.FBuyList.UpDateUI(this.FSelectIndex,this.FBuyInventoriesVect[this.FSelectIndex],_loc4_);
         this.UpdateUIBtn();
      }
      
      protected function UpdateUIBtn() : void
      {
         this.FAwardList.UpDateBtn(this.FDataEspada.AwardStatus[this.FSelectIndex]);
         this.FBuyList.UpDateBtn(this.FDataEspada.BuyStatus[this.FSelectIndex]);
      }
      
      protected function CheckEffectStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FDataEspada.AwardStatus.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FDataEspada.AwardStatus[_loc1_] >= Activity_CanReceive)
            {
               FActivityAtoms.Status = Activity_CanReceive;
               break;
            }
            FActivityAtoms.Status = Activity_CanNotReceive;
            _loc1_++;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(this,CONST_SHORTCUTS.TYPE_ActiveList_Espada);
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(this.FAwardList != null)
         {
            this.FAwardList.Clear();
         }
         if(this.FBuyList != null)
         {
            this.FBuyList.Clear();
         }
         if(this.FTabEffects != null && this.FTabEffects.length > 0)
         {
            _loc2_ = int(COUNT_EFFECT_TabMovieclip);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTabEffects[_loc1_].stop();
               _loc1_++;
            }
         }
      }
      
      protected function AwardBtnOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = this.FHDEspada.AwardsConditions[param2].Index;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_,CONST_ACTIVITY_MODE.TYPE_Operate_Award);
      }
      
      protected function BuyBtnOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = this.FHDEspada.BuyConditions[param2].Index;
         FBoxIndex = _loc3_;
         if(FCharacter.CreditGold >= this.FHDEspada.BuyConditions[param2].Need)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHDEspada.BuyConditions[param2].Need);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(this.FHDEspada.BuyConditions[param2].Need);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,FBoxIndex,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
      }
      
      override protected function WindowInformationOnCancel(param1:Object) : void
      {
         super.WindowInformationOnCancel(param1);
      }
      
      protected function TabOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         _loc3_ = param2.currentTarget.name;
         this.FSelectIndex = _loc3_.split("_")[2];
         this.UpdateUIList();
         this.UpdateUIBtn();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
   }
}

