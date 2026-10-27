package Processors.Game.Lobby.HerosNew
{
   import Components.Slots.TUISlot;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import flash.events.MouseEvent;
   
   public class TMainHeroWakeSlot extends TUISlot
   {
      
      protected var FHint:THint;
      
      public function TMainHeroWakeSlot(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SlotOnOut(param1:MouseEvent) : void
      {
         var _loc2_:THeroWakeEquipment = null;
         FUICore.MouseHoverRelease();
         FRenderingHoveringState = RENDERINGSTATE_Normal;
         if(Context == null)
         {
            return;
         }
         if(FOnOut != null)
         {
            _loc2_ = Context as THeroWakeEquipment;
            if(_loc2_.WakeUpConfig.WakeStage == 0 && !THeroWakeData.IsAll(_loc2_) && this.FHint != null)
            {
               FOnOut(this,this.FHint);
            }
            else
            {
               FOnOut(this,Context);
            }
         }
      }
      
      override protected function RenderingPerform_Overlay() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:THeroWakeEquipment = null;
         if(!FDragging)
         {
            if(FUICore.DragSource != null)
            {
               return;
            }
            _loc1_ = FUICore.MouseHovering(this);
            if(_loc1_)
            {
               if(FOnOver != null)
               {
                  _loc2_ = Context as THeroWakeEquipment;
                  if(_loc2_.WakeUpConfig.WakeStage == 0 && !THeroWakeData.IsAll(_loc2_) && this.FHint != null)
                  {
                     FOnOver(this,this.FHint);
                  }
                  else
                  {
                     FOnOver(this,Context);
                  }
               }
            }
         }
      }
      
      public function set Hint(param1:THint) : void
      {
         this.FHint = param1;
      }
      
      override public function set Context(param1:Object) : void
      {
         var _loc2_:THeroWakeEquipment = null;
         super.Context = param1;
         if(FContext != null && FResource != null)
         {
            _loc2_ = FContext as THeroWakeEquipment;
            if(THeroWakeData.IsEquips(_loc2_))
            {
               FResource["TF_EquipLevel"].text = "Lv." + _loc2_.CurStreng;
            }
            else
            {
               FResource["TF_EquipLevel"].text = "";
            }
         }
      }
   }
}

