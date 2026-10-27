package Processors.Game.Lobby.Activity.HDActivityLimitBuy
{
   import Externals.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityLimitBuy.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityLimitBuy.Compoent.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowLimitBuy extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_Awards:uint = 8;
      
      protected var FTF_FlushTime:TextField;
      
      protected var FTF_UsedValue:TextField;
      
      protected var FAwards:Vector.<TUIActivityGiftBag>;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FSP_ActivityPrompt:Sprite;
      
      protected var FMC_Gifts:Vector.<Sprite>;
      
      protected var FData:TActivityLimitBuy;
      
      protected var FHDLimitBuy:THDActivityLimitBuy;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FCurLimitBuyItem:TActivityLimitBuyItem;
      
      public function TProcessorHDWindowLimitBuy(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleLimitBuy;
         this.FIsInitWindow = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsInitWindow && this.FHDLimitBuy != null)
         {
            this.FTF_FlushTime.text = FormatTime(ProcessorGetFlushTime(this.FHDLimitBuy.FlushTime));
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityGiftBag = null;
         var _loc5_:Sprite = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_MC_Awards);
         this.FAwards = new Vector.<TUIActivityGiftBag>(_loc3_);
         this.FMC_Gifts = new Vector.<Sprite>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Awards + _loc2_];
            _loc4_ = new TUIActivityGiftBag(this);
            _loc4_.OnOkClick = this.PorcessorAwardOnBuyClick;
            _loc4_.Perform_UIDispatch(_loc5_);
            this.FAwards[_loc2_] = _loc4_;
            this.FMC_Gifts[_loc2_] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Gifts + _loc2_];
            this.FMC_Gifts[_loc2_].addEventListener(MouseEvent.MOUSE_MOVE,this.GiftOnOver);
            this.FMC_Gifts[_loc2_].addEventListener(MouseEvent.ROLL_OUT,this.GiftOnOut);
            _loc2_++;
         }
         this.FTF_FlushTime = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_FlushTime];
         this.FTF_FlushTime.mouseEnabled = false;
         this.FTF_UsedValue = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_UsedValue];
         this.FTF_UsedValue.mouseEnabled = false;
         this.FMC_Effect = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_MC_SingleEffect];
         this.FMC_Effect.mouseChildren = false;
         this.FMC_Effect.mouseEnabled = false;
         this.FMC_Effect.stop();
         this.FSP_ActivityPrompt = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_ActivityPrompt];
         this.FSP_ActivityPrompt.addEventListener(MouseEvent.MOUSE_MOVE,this.SPActivityPromptOnMove);
         this.FSP_ActivityPrompt.addEventListener(MouseEvent.MOUSE_OUT,this.SPActivityPromptOnOut);
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHDLimitBuy = FHDActivityConfig as THDActivityLimitBuy;
         _loc2_ = int(this.FHDLimitBuy.BuyLimitItems.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHDLimitBuy.BuyLimitItems[_loc1_].Awards[0];
            _loc1_++;
         }
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc3_);
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FData = param1 as TActivityLimitBuy;
         this.ProcessorCheckEffect();
         this.UpdateUI();
      }
      
      protected function ProcessorCheckEffect() : void
      {
         if(FUpdateStatus != null)
         {
            if(FUpdateStatus != null)
            {
               FUpdateStatus(this);
            }
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         _loc2_ = int(COUNT_MC_Awards);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwards[_loc1_].UpdateUI(this.FData.GetLimitBuyItemByIndex(_loc1_),this.FHDLimitBuy);
            _loc1_++;
         }
         this.FTF_UsedValue.text = this.FData.GetLimitBuyItemByIndex(0).Value.toString();
      }
      
      protected function ProcessorPlayEffect() : void
      {
         if(this.FIsInitWindow)
         {
            this.FMC_Effect.play();
         }
      }
      
      protected function ClearTextField() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FTF_FlushTime.text = "";
         this.FTF_UsedValue.text = "";
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.ClearTextField();
         this.FMC_Effect.stop();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function PorcessorAwardOnBuyClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TActivityLimitBuyItem = null;
         _loc3_ = this.FData.GetItemByUniqueIndex(param2);
         if(_loc3_ == null)
         {
            return;
         }
         this.FCurLimitBuyItem = _loc3_;
         if(FCharacter.CreditGold >= _loc3_.Cost)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(this.FHDLimitBuy.Prompts[0],_loc3_.Cost);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurLimitBuyItem.Index);
      }
      
      protected function SPActivityPromptOnMove(param1:MouseEvent) : void
      {
         FHint.Caption = this.FHDLimitBuy.Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function SPActivityPromptOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function GiftOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TInventories = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc4_ = param1.currentTarget.name;
         _loc3_ = int(_loc4_.split("_")[2]);
         _loc2_ = FInventoriesVect[_loc3_];
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,_loc2_);
         }
      }
      
      protected function GiftOnOut(param1:MouseEvent) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.ProcessorPlayEffect();
      }
      
      public function ValuesChange(param1:TActivityLimitBuy) : void
      {
         this.UpdateDataBase(param1);
      }
   }
}

