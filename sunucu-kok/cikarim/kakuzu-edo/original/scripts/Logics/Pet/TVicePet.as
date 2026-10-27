package Logics.Pet
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TVicePet extends TPetBase
   {
      
      protected var FConditionCompositePropID:uint;
      
      protected var FConditionCompositePropQuantity:uint;
      
      protected var FConditionCompositePrice:uint;
      
      protected var FCompositeState:Boolean;
      
      protected var FConditionAdvancePropID:uint;
      
      protected var FConditionAdvancePropQuantity:uint;
      
      protected var FConditionAdvancePrice:uint;
      
      protected var FConditionAdvancePetLevel:uint;
      
      protected var FAdvanceState:Boolean;
      
      public function TVicePet(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FCompositeState = true;
         this.FAdvanceState = true;
      }
      
      override public function GetTemplateIDByLevel(param1:uint) : uint
      {
         return FTemplateID * 1000 + param1;
      }
      
      public function GetTemplateIDByID(param1:uint) : uint
      {
         return param1 * 1000 + Level;
      }
      
      public function GetTemplateIDByIDLevel(param1:uint, param2:uint) : uint
      {
         return param1 * 1000 + param2;
      }
      
      public function get ConditionCompositePropID() : uint
      {
         return this.FConditionCompositePropID;
      }
      
      public function set ConditionCompositePropID(param1:uint) : void
      {
         this.FConditionCompositePropID = param1;
      }
      
      public function get ConditionCompositePropQuantity() : uint
      {
         return this.FConditionCompositePropQuantity;
      }
      
      public function set ConditionCompositePropQuantity(param1:uint) : void
      {
         this.FConditionCompositePropQuantity = param1;
      }
      
      public function get ConditionCompositePrice() : uint
      {
         return this.FConditionCompositePrice;
      }
      
      public function set ConditionCompositePrice(param1:uint) : void
      {
         this.FConditionCompositePrice = param1;
      }
      
      public function get CompositeState() : Boolean
      {
         return this.FCompositeState;
      }
      
      public function set CompositeState(param1:Boolean) : void
      {
         this.FCompositeState = param1;
      }
      
      public function get ConditionAdvancePropID() : uint
      {
         return this.FConditionAdvancePropID;
      }
      
      public function set ConditionAdvancePropID(param1:uint) : void
      {
         this.FConditionAdvancePropID = param1;
      }
      
      public function get ConditionAdvancePropQuantity() : uint
      {
         return this.FConditionAdvancePropQuantity;
      }
      
      public function set ConditionAdvancePropQuantity(param1:uint) : void
      {
         this.FConditionAdvancePropQuantity = param1;
      }
      
      public function get ConditionAdvancePrice() : uint
      {
         return this.FConditionAdvancePrice;
      }
      
      public function set ConditionAdvancePrice(param1:uint) : void
      {
         this.FConditionAdvancePrice = param1;
      }
      
      public function get ConditionAdvancePetLevel() : uint
      {
         return this.FConditionAdvancePetLevel;
      }
      
      public function set ConditionAdvancePetLevel(param1:uint) : void
      {
         this.FConditionAdvancePetLevel = param1;
      }
      
      public function get AdvanceState() : Boolean
      {
         return this.FAdvanceState;
      }
      
      public function set AdvanceState(param1:Boolean) : void
      {
         this.FAdvanceState = param1;
      }
      
      override public function GetRank() : int
      {
         var _loc1_:TBins = null;
         var _loc2_:TPetLevelUp = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PetLevelUp);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(this.GetTemplateIDByLevel(FLevel)) as TPetLevelUp;
         return (_loc2_.PetId - _loc2_.SourcePet) / 100;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         FIdentifier0 = 0;
         FIdentifier1 = 0;
         this.FConditionCompositePropID = 0;
         this.FConditionCompositePropQuantity = 0;
         this.FConditionCompositePrice = 0;
         this.FCompositeState = true;
         this.FConditionAdvancePropID = 0;
         this.FConditionAdvancePropQuantity = 0;
         this.FConditionAdvancePrice = 0;
         this.FConditionAdvancePetLevel = 0;
         this.FAdvanceState = true;
      }
   }
}

