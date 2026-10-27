package Processors.Game.Lobby.Activity.HDSuperEgg.Component
{
   import Foundation.UI.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TUISuperEggsRechargeBox extends TUIActivityOSAwardList
   {
      
      protected var FMC_LockElement:Sprite;
      
      protected var FMC_Effect:MovieClip;
      
      public function TUISuperEggsRechargeBox(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         super.Resources_UIDispatch(param1,param2);
         this.FMC_LockElement = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_LockElement];
         this.FMC_LockElement.mouseChildren = false;
         this.FMC_LockElement.mouseEnabled = false;
         this.FMC_LockElement.visible = false;
         this.FMC_Effect = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_List_MC_SingleEffect];
         this.FMC_Effect.mouseChildren = false;
         this.FMC_Effect.mouseEnabled = false;
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
      }
      
      override protected function UpdateBtn() : void
      {
         super.UpdateBtn();
         if(FAwardBoxStatus == Activity_CanNotReceive)
         {
            this.FMC_LockElement.visible = true;
         }
         else
         {
            this.FMC_LockElement.visible = false;
         }
         if(FAwardBoxStatus == Activity_CanReceive)
         {
            this.FMC_Effect.play();
            this.FMC_Effect.visible = true;
         }
         else
         {
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
      }
      
      override protected function DoClear() : void
      {
         super.DoClear();
         if(this.FMC_LockElement != null)
         {
            this.FMC_LockElement.visible = false;
         }
         if(this.FMC_Effect != null)
         {
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
      }
   }
}

