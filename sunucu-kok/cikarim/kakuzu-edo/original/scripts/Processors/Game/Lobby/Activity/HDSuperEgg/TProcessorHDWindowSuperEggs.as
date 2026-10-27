package Processors.Game.Lobby.Activity.HDSuperEgg
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityChineseYear.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Activity.HDSuperEgg.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorHDWindowSuperEggs extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_RECHARGEBOX:uint = 2;
      
      protected static const COUNT_MC_LAYER:uint = 2;
      
      protected static const COUNT_MC_BUYBOX_LAYER0:uint = 3;
      
      protected static const COUNT_MC_BUYBOX_LAYER1:uint = 2;
      
      protected static const COUNT_TF_BUYBOX:uint = 3;
      
      protected static const COUNT_AWARD:uint = 1;
      
      protected static const BOX_CONDITION:Vector.<uint> = Vector.<uint>([1,50]);
      
      protected static const FRAME_LAYER_CanNotBuy:uint = 1;
      
      protected static const FRAME_LAYER_ShowBuy:uint = 28;
      
      protected static const FRAME_LAYER_CanBuy:uint = 51;
      
      protected static const GETTYPE_Activity_AwardRecive:uint = CONST_ACTIVITY_MODE.GETTYPE_Activity_AwardRecive;
      
      protected static const GETTYPE_Activity_AwardBuy:uint = CONST_ACTIVITY_MODE.GETTYPE_Activity_AwardBuy;
      
      protected var FMC_RechargeBoxes:Vector.<TUISuperEggsRechargeBox>;
      
      protected var FMC_Layer0BuyBoxes:Vector.<TUIActivityOSAwardList>;
      
      protected var FMC_Layer1BuyBoxes:Vector.<TUIActivityOSAwardList>;
      
      protected var FMC_Layer0:MovieClip;
      
      protected var FMC_Layer1:MovieClip;
      
      protected var FMC_Layer0EffectVect:Vector.<MovieClip>;
      
      protected var FMC_Layer1EffectVect:Vector.<MovieClip>;
      
      protected var FData_SuperEggs:TActivityChineseYearLion;
      
      protected var FHD_SuperEggs:THDNewYearEgg;
      
      protected var FData_RechargeBoxes:Vector.<TActivityLion>;
      
      protected var FData_Layer0BuyBoxes:Vector.<TActivityLion>;
      
      protected var FData_Layer1BuyBoxes:Vector.<TActivityLion>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsOpreate:Boolean;
      
      protected var FUIndex_BuyBox:uint;
      
      protected var FAwardIDs:Vector.<uint>;
      
      public function TProcessorHDWindowSuperEggs(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleSuperEggs;
         this.FIsInitWindow = false;
         this.FIsOpreate = false;
         FActivityID = CONST_ACTIVITY_MODE.Activity_NewYear;
         this.FData_RechargeBoxes = new Vector.<TActivityLion>();
         this.FData_Layer0BuyBoxes = new Vector.<TActivityLion>();
         this.FData_Layer1BuyBoxes = new Vector.<TActivityLion>();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_MC_RECHARGEBOX);
         this.FMC_RechargeBoxes = new Vector.<TUISuperEggsRechargeBox>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_RechargeBoxes[_loc2_] = new TUISuperEggsRechargeBox(this);
            this.FMC_RechargeBoxes[_loc2_].OnBtnOkMove = this.BoxOnOver;
            this.FMC_RechargeBoxes[_loc2_].OnBtnOkOut = this.BoxOnOut;
            this.FMC_RechargeBoxes[_loc2_].OnBtnOkClick = this.RechargeBoxOnClick;
            this.FMC_RechargeBoxes[_loc2_].Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_RechargeBox + _loc2_],0,0,false);
            _loc2_++;
         }
         this.FMC_Layer0 = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Layers + 0];
         _loc3_ = int(COUNT_MC_BUYBOX_LAYER0);
         this.FMC_Layer0BuyBoxes = new Vector.<TUIActivityOSAwardList>(_loc3_);
         this.FMC_Layer0EffectVect = new Vector.<MovieClip>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_Layer0EffectVect[_loc2_] = this.FMC_Layer0[CONST_ACTIVITY.RESOURCE_Link_MC_Effect + _loc2_];
            this.FMC_Layer0EffectVect[_loc2_].mouseChildren = false;
            this.FMC_Layer0EffectVect[_loc2_].mouseEnabled = false;
            _loc4_ = this.FMC_Layer0[CONST_ACTIVITY.RESOURCE_Link_MC_BuyBox];
            this.FMC_Layer0BuyBoxes[_loc2_] = new TUIActivityOSAwardList(this);
            this.FMC_Layer0BuyBoxes[_loc2_].OnBtnOkMove = this.BoxOnOver;
            this.FMC_Layer0BuyBoxes[_loc2_].OnBtnOkOut = this.BoxOnOut;
            this.FMC_Layer0BuyBoxes[_loc2_].OnBtnOkClick = this.BuyBoxOnClick;
            this.FMC_Layer0BuyBoxes[_loc2_].Perform_UIDispatch(_loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_BuyBoxes + _loc2_],COUNT_TF_BUYBOX,0,false);
            _loc2_++;
         }
         this.FMC_Layer1 = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Layers + 1];
         _loc3_ = int(COUNT_MC_BUYBOX_LAYER1);
         this.FMC_Layer1BuyBoxes = new Vector.<TUIActivityOSAwardList>(_loc3_);
         this.FMC_Layer1EffectVect = new Vector.<MovieClip>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_Layer1EffectVect[_loc2_] = this.FMC_Layer1[CONST_ACTIVITY.RESOURCE_Link_MC_Effect + _loc2_];
            this.FMC_Layer1EffectVect[_loc2_].mouseChildren = false;
            this.FMC_Layer1EffectVect[_loc2_].mouseEnabled = false;
            _loc4_ = this.FMC_Layer1[CONST_ACTIVITY.RESOURCE_Link_MC_BuyBox];
            this.FMC_Layer1BuyBoxes[_loc2_] = new TUIActivityOSAwardList(this);
            this.FMC_Layer1BuyBoxes[_loc2_].OnBtnOkMove = this.BoxOnOver;
            this.FMC_Layer1BuyBoxes[_loc2_].OnBtnOkOut = this.BoxOnOut;
            this.FMC_Layer1BuyBoxes[_loc2_].OnBtnOkClick = this.BuyBoxOnClick;
            this.FMC_Layer1BuyBoxes[_loc2_].Perform_UIDispatch(_loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_BuyBoxes + _loc2_],COUNT_TF_BUYBOX,0,false);
            _loc2_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_SuperEggs = FHDActivityConfig as THDNewYearEgg;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FData_SuperEggs = param1 as TActivityChineseYearLion;
         this.UpdateFormatDatabase();
         this.UpdateUI();
      }
      
      protected function UpdateFormatDatabase() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityLion = null;
         _loc2_ = int(this.FData_RechargeBoxes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FData_RechargeBoxes[_loc1_] = null;
            _loc1_++;
         }
         this.FData_RechargeBoxes.length = 0;
         _loc2_ = int(this.FData_Layer0BuyBoxes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FData_Layer0BuyBoxes[_loc1_] = null;
            _loc1_++;
         }
         this.FData_Layer0BuyBoxes.length = 0;
         _loc2_ = int(this.FData_Layer1BuyBoxes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FData_Layer1BuyBoxes[_loc1_] = null;
            _loc1_++;
         }
         this.FData_Layer1BuyBoxes.length = 0;
         _loc2_ = this.FData_SuperEggs.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData_SuperEggs.GetAwardByIndex(_loc1_);
            if(_loc3_.GetType == GETTYPE_Activity_AwardRecive)
            {
               this.FData_RechargeBoxes.push(_loc3_);
            }
            else if(_loc3_.Condition == BOX_CONDITION[0])
            {
               this.FData_Layer0BuyBoxes.push(_loc3_);
            }
            else
            {
               this.FData_Layer1BuyBoxes.push(_loc3_);
            }
            _loc1_++;
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:TActivityLion = null;
         super.UpdateUI();
         _loc2_ = int(this.FMC_RechargeBoxes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_RechargeBoxes[_loc1_].UpDateUI(this.FData_RechargeBoxes[_loc1_].Index);
            this.FMC_RechargeBoxes[_loc1_].UpDateBtn(this.FData_RechargeBoxes[_loc1_].Status);
            _loc1_++;
         }
         this.PlayLayerMC();
         _loc2_ = int(this.FMC_Layer0BuyBoxes.length);
         _loc3_ = new Vector.<String>(COUNT_TF_BUYBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FData_Layer0BuyBoxes[_loc1_].Cost.toString();
            _loc3_[1] = this.FData_Layer0BuyBoxes[_loc1_].RateStr;
            _loc3_[2] = "";
            if(this.FData_Layer0BuyBoxes[_loc1_].Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc3_[2] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_15),this.FData_Layer0BuyBoxes[_loc1_].Status.toString());
            }
            else if(this.FData_Layer0BuyBoxes[_loc1_].Status == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               _loc3_[2] = "";
            }
            this.FMC_Layer0BuyBoxes[_loc1_].UpDateUI(this.FData_Layer0BuyBoxes[_loc1_].Index,null,_loc3_);
            this.FMC_Layer0BuyBoxes[_loc1_].UpDateBtn(this.FData_Layer0BuyBoxes[_loc1_].Status);
            _loc1_++;
         }
         _loc2_ = int(this.FMC_Layer1BuyBoxes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FData_Layer1BuyBoxes[_loc1_].Cost.toString();
            _loc3_[1] = this.FData_Layer1BuyBoxes[_loc1_].RateStr;
            _loc3_[2] = "";
            if(this.FData_Layer1BuyBoxes[_loc1_].Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc3_[2] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_15),this.FData_Layer1BuyBoxes[_loc1_].Status.toString());
            }
            else if(this.FData_Layer1BuyBoxes[_loc1_].Status == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               _loc3_[2] = "";
            }
            this.FMC_Layer1BuyBoxes[_loc1_].UpDateUI(this.FData_Layer1BuyBoxes[_loc1_].Index,null,_loc3_);
            this.FMC_Layer1BuyBoxes[_loc1_].UpDateBtn(this.FData_Layer1BuyBoxes[_loc1_].Status);
            _loc1_++;
         }
      }
      
      protected function PlayLayerMC() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FIsOpreate)
         {
            if(this.FData_RechargeBoxes[0].Status == Activity_CanNotReceive)
            {
               this.FMC_Layer0.gotoAndPlay(FRAME_LAYER_CanNotBuy);
            }
            else
            {
               this.FMC_Layer0.gotoAndPlay(FRAME_LAYER_ShowBuy);
               _loc2_ = int(COUNT_MC_BUYBOX_LAYER0);
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FMC_Layer0EffectVect[_loc1_].gotoAndPlay(2);
                  _loc1_++;
               }
            }
            if(this.FData_RechargeBoxes[1].Status == Activity_CanNotReceive)
            {
               this.FMC_Layer1.gotoAndPlay(FRAME_LAYER_CanNotBuy);
            }
            else
            {
               this.FMC_Layer1.gotoAndPlay(FRAME_LAYER_ShowBuy);
               _loc2_ = int(COUNT_MC_BUYBOX_LAYER1);
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FMC_Layer1EffectVect[_loc1_].gotoAndPlay(2);
                  _loc1_++;
               }
            }
         }
      }
      
      protected function GetSingleInventoriesByUIndex(param1:uint) : TInventories
      {
         var _loc2_:TInventories = null;
         var _loc3_:TActivityLion = null;
         _loc3_ = this.FData_SuperEggs.GetAwardByUniqueIndex(param1);
         this.FAwardIDs = _loc3_.Awards;
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FAwardIDs);
         return FInventoriesVect[this.FData_SuperEggs.CurDay];
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         this.FIsOpreate = false;
         if(!this.FIsInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FMC_RechargeBoxes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_RechargeBoxes[_loc1_].Clear();
            _loc1_++;
         }
         _loc2_ == this.FMC_Layer0EffectVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Layer0EffectVect[_loc1_].stop();
            _loc1_++;
         }
         _loc2_ = int(this.FMC_Layer1EffectVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Layer1EffectVect[_loc1_].stop();
            _loc1_++;
         }
         this.FMC_Layer0.stop();
         this.FMC_Layer1.stop();
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FUIndex_BuyBox);
         this.FIsOpreate = true;
      }
      
      override protected function WindowInformationOnCancel(param1:Object) : void
      {
         super.WindowInformationOnCancel(param1);
         this.FIsOpreate = false;
      }
      
      protected function BuyBoxOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TActivityLion = null;
         _loc3_ = this.FData_SuperEggs.GetAwardByUniqueIndex(param2);
         if(FCharacter.CreditGold >= _loc3_.Cost)
         {
            this.FUIndex_BuyBox = param2;
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_59),_loc3_.Cost);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function RechargeBoxOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      protected function BoxOnOver(param1:Object, param2:uint) : void
      {
         var _loc3_:TInventories = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         _loc7_ = false;
         _loc5_ = int(BOX_CONDITION.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(this.FData_SuperEggs.GetAwardByUniqueIndex(param2).Condition == BOX_CONDITION[_loc4_])
            {
               _loc6_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         if(this.FData_RechargeBoxes[_loc6_].Status == Activity_CanNotReceive)
         {
            _loc5_ = int(this.FData_RechargeBoxes.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(this.FData_RechargeBoxes[_loc4_].Index == param2)
               {
                  _loc7_ = true;
                  break;
               }
               _loc4_++;
            }
            if(!_loc7_)
            {
               return;
            }
         }
         _loc3_ = this.GetSingleInventoriesByUIndex(param2);
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,_loc3_);
         }
      }
      
      protected function BoxOnOut(param1:Object, param2:uint) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
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

