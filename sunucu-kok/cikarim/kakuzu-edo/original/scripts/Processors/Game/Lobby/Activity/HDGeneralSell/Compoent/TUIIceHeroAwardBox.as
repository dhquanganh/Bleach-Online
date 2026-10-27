package Processors.Game.Lobby.Activity.HDGeneralSell.Compoent
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDIceHeros.TActivityIHAward;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIIceHeroAwardBox extends TUIComponent
   {
      
      protected var FScene:Sprite;
      
      protected var FBtnOK:TUIButton;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_Condition:TextField;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FData:TActivityIHAward;
      
      protected var FDataOwned:uint;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FAddRate:uint;
      
      protected var FCurStage:uint;
      
      protected var FOnAwardBoxOKClick:Function;
      
      protected var FOnAwardBoxOver:Function;
      
      protected var FOnAwardBoxOut:Function;
      
      public function TUIIceHeroAwardBox(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitWindow = false;
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         this.FScene = param1;
         this.FBtnOK = new TUIButton();
         this.FBtnOK.Substrate = this.FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtnOK.OnClick = this.ProcessorBtnOKOnClick;
         this.FBtnOK.OnMove = this.ProcessorBtnOKOnOver;
         this.FBtnOK.OnOut = this.ProcessorBtnOKOnOut;
         this.FBtnOK.Enabled = false;
         this.FTF_Condition = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_OpenCondition];
         this.FTF_Condition.mouseEnabled = false;
         this.FTF_Condition.text = "";
         this.FSP_AlreadyGet = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         if(this.FSP_AlreadyGet)
         {
            this.FSP_AlreadyGet.mouseChildren = false;
            this.FSP_AlreadyGet.mouseEnabled = false;
            this.FSP_AlreadyGet.visible = false;
         }
         this.FMC_Effect = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_ClickEffect];
         if(this.FMC_Effect)
         {
            this.FMC_Effect.mouseChildren = false;
            this.FMC_Effect.mouseEnabled = false;
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
         this.FIsInitWindow = true;
      }
      
      protected function ProcessorUpdateUI() : void
      {
         this.DoReset();
         this.FTF_Condition.text = (this.FData.Condition + this.FAddRate * this.FCurStage).toString();
         if(this.FData.Status == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FSP_AlreadyGet.visible = true;
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
         else if(this.FData.Status == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
         {
            this.FBtnOK.Enabled = false;
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
         else
         {
            this.FBtnOK.Enabled = true;
            this.FMC_Effect.play();
            this.FMC_Effect.visible = true;
         }
      }
      
      protected function DoReset() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FTF_Condition.text = "";
         this.FSP_AlreadyGet.visible = false;
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
         this.FBtnOK.Enabled = false;
      }
      
      protected function ProcessorBtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAwardBoxOKClick != null)
         {
            this.FOnAwardBoxOKClick(this,this.FData.Index);
         }
      }
      
      protected function ProcessorBtnOKOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAwardBoxOver != null)
         {
            this.FOnAwardBoxOver(this,this.FData);
         }
      }
      
      protected function ProcessorBtnOKOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAwardBoxOut != null)
         {
            this.FOnAwardBoxOut(this,this.FData);
         }
      }
      
      public function get OnAwardBoxOver() : Function
      {
         return this.FOnAwardBoxOver;
      }
      
      public function set OnAwardBoxOver(param1:Function) : void
      {
         this.FOnAwardBoxOver = param1;
      }
      
      public function get OnAwardBoxOut() : Function
      {
         return this.FOnAwardBoxOut;
      }
      
      public function set OnAwardBoxOut(param1:Function) : void
      {
         this.FOnAwardBoxOut = param1;
      }
      
      public function get OnAwardBoxOKClick() : Function
      {
         return this.FOnAwardBoxOKClick;
      }
      
      public function set OnAwardBoxOKClick(param1:Function) : void
      {
         this.FOnAwardBoxOKClick = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:TActivityIHAward, param2:uint, param3:uint, param4:uint) : void
      {
         this.FData = param1;
         this.FDataOwned = param2;
         this.FAddRate = param3;
         this.FCurStage = param4;
         this.ProcessorUpdateUI();
      }
      
      public function Reset() : void
      {
         this.DoReset();
      }
   }
}

