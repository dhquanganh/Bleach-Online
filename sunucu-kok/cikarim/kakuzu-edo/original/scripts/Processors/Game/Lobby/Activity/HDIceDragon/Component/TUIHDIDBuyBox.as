package Processors.Game.Lobby.Activity.HDIceDragon.Component
{
   import Foundation.UI.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TUIHDIDBuyBox extends TUIActivityOSAwardList
   {
      
      protected var FMC_Effect:MovieClip;
      
      public function TUIHDIDBuyBox(param1:TUIComponent)
      {
         super(param1);
      }
      
      override public function Perform_UIDispatch(param1:Sprite, param2:int, param3:int, param4:Boolean = true) : void
      {
         super.Perform_UIDispatch(param1,param2,param3,param4);
         this.FMC_Effect = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_List_MC_SingleEffect];
         if(this.FMC_Effect != null)
         {
            this.FMC_Effect.mouseChildren = false;
            this.FMC_Effect.mouseEnabled = false;
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
      }
      
      override protected function UpdateUI(param1:Vector.<String> = null, param2:TInventories = null) : void
      {
         super.UpdateUI(param1,param2);
      }
      
      protected function ProcessorPlayEffectMC(param1:Boolean) : void
      {
         if(this.FMC_Effect != null)
         {
            if(param1)
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
      }
      
      override protected function DoClear() : void
      {
         super.DoClear();
         this.ProcessorPlayEffectMC(false);
      }
      
      public function PlayEffectOnOff(param1:Boolean) : void
      {
         this.ProcessorPlayEffectMC(param1);
      }
   }
}

