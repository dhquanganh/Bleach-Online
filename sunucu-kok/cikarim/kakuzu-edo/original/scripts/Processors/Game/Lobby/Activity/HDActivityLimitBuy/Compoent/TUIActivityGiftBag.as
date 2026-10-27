package Processors.Game.Lobby.Activity.HDActivityLimitBuy.Compoent
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDActivityLimitBuy;
   import Logics.HDActivityLimitBuy.TActivityLimitBuyItem;
   import Resources.Constants.CONST_ACTIVITY;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIActivityGiftBag extends TUIComponent
   {
      
      protected var FMC:Sprite;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_Cost:TextField;
      
      protected var FTF_ServerCout:TextField;
      
      protected var FTF_BuyCount:TextField;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_Condition:Sprite;
      
      protected var FTF_Condition:TextField;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FData:TActivityLimitBuyItem;
      
      protected var FHDConfig:THDActivityLimitBuy;
      
      protected var FIsInitResource:Boolean;
      
      protected var FOnOkClick:Function;
      
      public function TUIActivityGiftBag(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitResource = false;
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         this.FMC = param1;
         this.FTF_Title = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Title];
         this.FTF_Title.mouseEnabled = false;
         this.FTF_Cost = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Cost];
         this.FTF_Cost.mouseEnabled = false;
         this.FTF_ServerCout = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_ServerCount];
         this.FTF_ServerCout.mouseEnabled = false;
         this.FTF_BuyCount = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_BuyCount];
         this.FTF_BuyCount.mouseEnabled = false;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.BtnOkOnClick;
         this.FBtn_OK.Enabled = false;
         this.FMC_Condition = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_OpenCondition];
         this.FMC_Condition.mouseChildren = false;
         this.FMC_Condition.mouseEnabled = false;
         this.FMC_Condition.visible = true;
         this.FTF_Condition = this.FMC_Condition[CONST_ACTIVITY.RESOURCE_Link_TF_OpenCondition];
         this.FMC_AlreadyGet = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FMC_AlreadyGet.mouseChildren = false;
         this.FMC_AlreadyGet.mouseEnabled = false;
         this.FMC_AlreadyGet.visible = false;
         this.FIsInitResource = true;
         this.ClearTextField();
      }
      
      protected function ProcessorUpdateUI() : void
      {
         this.FTF_Cost.text = this.FData.Cost.toString();
         this.FTF_ServerCout.text = this.FData.ServerCount.toString();
         this.FTF_BuyCount.text = this.FData.BuyCount.toString();
         this.FTF_Condition.text = TUtilityString.Format(this.FHDConfig.Prompts[1],this.FData.BuyCondition);
         if(this.FData.IsReachCondition)
         {
            this.FMC_Condition.visible = false;
         }
         else
         {
            this.FMC_Condition.visible = true;
         }
         if(this.FData.BuyCount > 0 && this.FData.ServerCount > 0)
         {
            this.FBtn_OK.Enabled = true;
         }
         else
         {
            this.FBtn_OK.Enabled = false;
         }
         if(this.FData.ServerCount > 0)
         {
            this.FMC_AlreadyGet.visible = false;
            this.FBtn_OK.Visible = true;
         }
         else
         {
            this.FMC_AlreadyGet.visible = true;
            this.FBtn_OK.Visible = false;
         }
      }
      
      protected function ClearTextField() : void
      {
         if(!this.FIsInitResource)
         {
            return;
         }
         this.FTF_Title.text = "";
         this.FTF_Cost.text = "";
         this.FTF_ServerCout.text = "";
         this.FTF_BuyCount.text = "";
         this.FTF_Condition.text = "";
      }
      
      protected function DoReset() : void
      {
         if(!this.FIsInitResource)
         {
            return;
         }
         this.ClearTextField();
      }
      
      protected function BtnOkOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOkClick != null)
         {
            this.FOnOkClick(this,this.FData.Index);
         }
      }
      
      public function get OnOkClick() : Function
      {
         return this.FOnOkClick;
      }
      
      public function set OnOkClick(param1:Function) : void
      {
         this.FOnOkClick = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:TActivityLimitBuyItem, param2:THDActivityLimitBuy) : void
      {
         this.FData = param1;
         this.FHDConfig = param2;
         this.ProcessorUpdateUI();
      }
      
      public function Reset() : void
      {
         this.DoReset();
      }
   }
}

