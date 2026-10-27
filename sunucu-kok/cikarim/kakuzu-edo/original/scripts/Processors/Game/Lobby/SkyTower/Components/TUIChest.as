package Processors.Game.Lobby.SkyTower.Components
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.TTemplePliesNumber;
   import Logics.SLogicsCore;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TUIChest
   {
      
      protected var FSP_Selected:Sprite;
      
      protected var FMC_Chest:MovieClip;
      
      protected var FSP_Chest:Sprite;
      
      protected var FTag:int;
      
      protected var FResource:Sprite;
      
      protected var FContext:uint;
      
      protected var FOnClick:Function;
      
      protected var FOnMove:Function;
      
      protected var FOnOut:Function;
      
      public function TUIChest()
      {
         super();
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FSP_Selected = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_Selected];
         this.FMC_Chest = this.FResource[CONST_SKYTOWER.RESOURCE_Link_MC_Chest];
         this.FSP_Chest = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_Chest];
         this.addEventListenerOver();
         this.Reset();
      }
      
      protected function addEventListenerClick() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.addEventListener(MouseEvent.CLICK,this.UIChestOnClick,false,0,true);
      }
      
      protected function RemoveEventListenerClick() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.removeEventListener(MouseEvent.CLICK,this.UIChestOnClick);
      }
      
      protected function addEventListenerOver() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.addEventListener(MouseEvent.MOUSE_MOVE,this.UIChestOnMove,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.UIChestOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerOver() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.removeEventListener(MouseEvent.MOUSE_MOVE,this.UIChestOnMove);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OUT,this.UIChestOnOut);
      }
      
      protected function UpdateUIChest() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TTemplePliesNumber = null;
         if(this.FResource == null)
         {
            return;
         }
         _loc1_ = uint(SLogicsCore.SkyTower.ReceiveChestID);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TemplePliesNumber,this.FTag) as TTemplePliesNumber;
         if(this.FContext >= _loc2_.NumberPlies)
         {
            this.FSP_Chest.visible = true;
            this.FMC_Chest.gotoAndStop(CONST_SKYTOWER.INDEX_FRAME_CHEST_STATE_ENABLED);
            this.addEventListenerClick();
            if(_loc1_ == 0)
            {
               this.FResource.buttonMode = true;
            }
         }
         if(_loc1_ == this.FTag)
         {
            this.FSP_Selected.visible = true;
         }
      }
      
      protected function UIChestOnClick(param1:MouseEvent) : void
      {
         if(!this.FResource.buttonMode)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FTag);
         }
         this.FSP_Selected.visible = true;
      }
      
      protected function UIChestOnMove(param1:MouseEvent) : void
      {
         if(this.FOnMove != null)
         {
            this.FOnMove(this,this.FTag);
         }
      }
      
      protected function UIChestOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FTag);
         }
      }
      
      public function get Tag() : int
      {
         return this.FTag;
      }
      
      public function set Tag(param1:int) : void
      {
         this.FTag = param1;
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : uint
      {
         return this.FContext;
      }
      
      public function set Context(param1:uint) : void
      {
         this.Reset();
         this.FContext = param1;
         if(param1 != 0)
         {
            this.UpdateUIChest();
         }
         else
         {
            this.RemoveEventListenerClick();
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnMove() : Function
      {
         return this.FOnMove;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function set Selected(param1:Boolean) : void
      {
         this.FSP_Selected.visible = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Dispose() : void
      {
         this.RemoveEventListenerOver();
         this.FSP_Chest = null;
         this.FSP_Selected = null;
         this.FMC_Chest = null;
         this.FResource = null;
      }
      
      public function Reset() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FSP_Chest.visible = false;
         this.FSP_Selected.visible = false;
         this.FMC_Chest.gotoAndStop(CONST_SKYTOWER.INDEX_FRAME_CHEST_STATE_DISABLED);
         this.FResource.buttonMode = false;
      }
   }
}

