package Processors.Game.Lobby.Pet.PetHouse.Components
{
   import Components.Slots.*;
   import Foundation.Queries.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Pet.*;
   import flash.display.*;
   
   public class TUIItemSlot extends TUISlot
   {
      
      protected var FSP_Current:Sprite;
      
      protected var FSP_Selected:Sprite;
      
      protected var FSP_Activated:Sprite;
      
      protected var FMC_ActivateEffect:MovieClip;
      
      protected var FActivateStatus:Boolean;
      
      protected var FActivateEffectDisplay:Boolean;
      
      protected var FQueryActivated:TQueryBoolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FTopLine:Sprite;
      
      protected var FBottomLine:Sprite;
      
      protected var FOnQueryActivated:Function;
      
      protected var FRowIndex:int;
      
      public function TUIItemSlot(param1:TUIComponent)
      {
         super(param1);
         this.FQueryActivated = new TQueryBoolean();
      }
      
      override protected function Initialization() : void
      {
         super.Initialization();
         this.FSP_Current = FResource["SP_Current"];
         this.FSP_Selected = FResource["SP_Selected"];
         this.FSP_Activated = FResource["SP_Activated"];
         this.FMC_ActivateEffect = FResource["MC_ActivateEffect"];
         this.Reset();
      }
      
      protected function UpdateUIItemSlot() : void
      {
         var _loc1_:TMainPet = null;
         var _loc2_:TMainPet = null;
         var _loc3_:Boolean = false;
         _loc1_ = FContext as TMainPet;
         if(SLogicsCore.Character.GetMainHero().MainPetID == _loc1_.Identifier0)
         {
            this.FSP_Current.visible = true;
         }
         _loc2_ = SLogicsCore.PetData.MainPetSelected;
         if(_loc2_ != null && _loc2_.Identifier0 == _loc1_.Identifier0)
         {
            this.FSP_Selected.visible = true;
         }
         _loc1_ = SLogicsCore.PetData.OwnMainPets.GetPetByIdentifier(_loc1_.Identifier0,_loc1_.Identifier1) as TMainPet;
         _loc3_ = true;
         if(_loc1_ == null)
         {
            _loc3_ = false;
         }
         SetDefaultFilters(!_loc3_);
      }
      
      override public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != FResource)
         {
            FResource = param1;
         }
         if(!this.FIsInitialization)
         {
            this.Initialization();
         }
      }
      
      override public function set Context(param1:Object) : void
      {
         super.Context = param1;
         if(param1 != null)
         {
            this.UpdateUIItemSlot();
         }
      }
      
      public function get TopLine() : Sprite
      {
         return this.FTopLine;
      }
      
      public function set TopLine(param1:Sprite) : void
      {
         this.FTopLine = param1;
      }
      
      public function get BottomLine() : Sprite
      {
         return this.FBottomLine;
      }
      
      public function set BottomLine(param1:Sprite) : void
      {
         this.FBottomLine = param1;
      }
      
      public function get OnQueryActivated() : Function
      {
         return this.FOnQueryActivated;
      }
      
      public function set OnQueryActivated(param1:Function) : void
      {
         this.FOnQueryActivated = param1;
      }
      
      public function get RowIndex() : int
      {
         return this.FRowIndex;
      }
      
      public function set RowIndex(param1:int) : void
      {
         this.FRowIndex = param1;
      }
      
      public function get CellIndex() : int
      {
         return FTag;
      }
      
      public function set CellIndex(param1:int) : void
      {
         FTag = param1;
      }
      
      public function get ActivateStatus() : Boolean
      {
         return this.FActivateStatus;
      }
      
      public function set ActivateStatus(param1:Boolean) : void
      {
         this.FActivateStatus = param1;
         this.FSP_Activated.visible = param1;
         if(this.FSP_Current.visible)
         {
            this.FSP_Activated.visible = false;
         }
      }
      
      public function Reset() : void
      {
         this.FSP_Current.visible = false;
         this.FSP_Selected.visible = false;
         this.FSP_Activated.visible = false;
         this.FMC_ActivateEffect.visible = false;
         this.FMC_ActivateEffect.gotoAndStop(1);
         if(this.FTopLine != null)
         {
            this.FTopLine.visible = false;
         }
         if(this.FBottomLine != null)
         {
            this.FBottomLine.visible = false;
         }
      }
      
      public function SetSelected(param1:Boolean) : void
      {
         if(this.FSP_Selected.visible != param1)
         {
            this.FSP_Selected.visible = param1;
         }
      }
      
      public function UpdateState() : void
      {
         this.FQueryActivated.Value = false;
         if(this.FOnQueryActivated != null)
         {
            this.FOnQueryActivated(this,FContext,this.FQueryActivated);
         }
         if(this.FQueryActivated.Value)
         {
            if(this.FBottomLine != null)
            {
               this.FBottomLine.visible = true;
            }
         }
      }
      
      public function PlayActivateEffect() : void
      {
         var _loc1_:TMainPet = null;
         var _loc2_:Boolean = false;
         _loc1_ = FContext as TMainPet;
         _loc1_ = SLogicsCore.PetData.OwnMainPets.GetPetByIdentifier(_loc1_.Identifier0,_loc1_.Identifier1) as TMainPet;
         _loc2_ = true;
         if(_loc1_ == null)
         {
            _loc2_ = false;
         }
         if(!_loc2_ && this.FSP_Activated.visible)
         {
            this.FSP_Activated.visible = false;
            this.FMC_ActivateEffect.visible = true;
            this.FMC_ActivateEffect.play();
         }
      }
      
      public function UpdateWashPointEffect() : void
      {
         var _loc1_:TMainPet = null;
         var _loc2_:Boolean = false;
         _loc1_ = FContext as TMainPet;
         _loc1_ = SLogicsCore.PetData.OwnMainPets.GetPetByIdentifier(_loc1_.Identifier0,_loc1_.Identifier1) as TMainPet;
         _loc2_ = true;
         if(_loc1_ == null)
         {
            _loc2_ = false;
         }
         if(!_loc2_ && this.FSP_Activated.visible)
         {
            this.FSP_Activated.visible = false;
         }
      }
      
      public function UpdateWashPoint() : void
      {
         this.FSP_Activated.visible = false;
         this.FMC_ActivateEffect.visible = false;
         this.FMC_ActivateEffect.gotoAndStop(1);
      }
   }
}

