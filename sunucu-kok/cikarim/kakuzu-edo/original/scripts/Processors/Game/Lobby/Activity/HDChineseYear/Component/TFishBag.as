package Processors.Game.Lobby.Activity.HDChineseYear.Component
{
   import Foundation.UI.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TFishBag extends TUIActivityOSAwardList
   {
      
      protected var FMC_Square:MovieClip;
      
      protected var FMC_BgEffect:MovieClip;
      
      protected var FMC_ClickEffect:MovieClip;
      
      public function TFishBag(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         super.Resources_UIDispatch(param1,param2);
         this.FMC_Square = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Square];
         if(this.FMC_Square != null)
         {
            this.FMC_Square.stop();
            this.FMC_Square.visible = false;
            this.FMC_Square.mouseChildren = false;
            this.FMC_Square.mouseEnabled = false;
         }
         this.FMC_BgEffect = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_BgEffect];
         if(this.FMC_BgEffect != null)
         {
            this.FMC_BgEffect.stop();
            this.FMC_BgEffect.mouseChildren = false;
            this.FMC_BgEffect.mouseEnabled = false;
         }
         this.FMC_ClickEffect = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_ClickEffect];
         if(this.FMC_ClickEffect != null)
         {
            this.FMC_ClickEffect.stop();
            this.FMC_ClickEffect.visible = false;
            this.FMC_ClickEffect.mouseChildren = false;
            this.FMC_ClickEffect.mouseEnabled = false;
         }
      }
      
      override protected function UpdateUI(param1:Vector.<String> = null, param2:TInventories = null) : void
      {
         super.UpdateUI(param1,param2);
         if(this.FMC_BgEffect != null)
         {
            this.FMC_BgEffect.play();
         }
      }
      
      override protected function UpdateBtn() : void
      {
         if(FBtn_OK == null)
         {
            return;
         }
         if(FAwardBoxStatus == Activity_CanNotReceive)
         {
            FBtn_OK.Visible = true;
            FBtn_OK.Enabled = false;
            this.FMC_Square.stop();
            this.FMC_Square.visible = false;
            if(FMC_AlreadyGet != null)
            {
               FMC_AlreadyGet.visible = false;
            }
         }
         else if(FAwardBoxStatus >= Activity_CanReceive)
         {
            FBtn_OK.Visible = true;
            FBtn_OK.Enabled = true;
            this.FMC_Square.play();
            this.FMC_Square.visible = true;
            if(FMC_AlreadyGet != null)
            {
               FMC_AlreadyGet.visible = false;
            }
         }
         else if(FAwardBoxStatus == Activity_AlreadyReceive)
         {
            FBtn_OK.Visible = true;
            FBtn_OK.Enabled = false;
            this.FMC_Square.stop();
            this.FMC_Square.visible = false;
            if(FMC_AlreadyGet != null)
            {
               FMC_AlreadyGet.visible = true;
            }
         }
      }
      
      protected function UpdateClickEffect() : void
      {
         if(this.FMC_ClickEffect != null)
         {
            this.FMC_ClickEffect.play();
            this.FMC_ClickEffect.visible = true;
         }
      }
      
      public function ClickBackFun() : void
      {
         this.UpdateClickEffect();
      }
      
      public function ClickEffectDisable() : void
      {
         if(this.FMC_ClickEffect == null)
         {
            return;
         }
         if(this.FMC_ClickEffect.currentFrame == this.FMC_ClickEffect.totalFrames && this.FMC_ClickEffect.visible)
         {
            this.FMC_ClickEffect.visible = false;
         }
      }
      
      public function Reset() : void
      {
         if(this.FMC_ClickEffect != null)
         {
            this.FMC_ClickEffect.stop();
         }
         if(this.FMC_BgEffect != null)
         {
            this.FMC_BgEffect.stop();
         }
         this.FMC_Square.stop();
      }
   }
}

