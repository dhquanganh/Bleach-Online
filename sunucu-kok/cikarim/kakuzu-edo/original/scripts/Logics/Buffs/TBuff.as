package Logics.Buffs
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TBuff extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIDName:uint;
      
      protected var FIDDescription:uint;
      
      protected var FIDIcon:uint;
      
      protected var FTimingCategory:uint;
      
      protected var FTimingTime:uint;
      
      public function TBuff(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get IDName() : uint
      {
         return this.FIDName;
      }
      
      public function set IDName(param1:uint) : void
      {
         this.FIDName = param1;
      }
      
      public function get IDDescription() : uint
      {
         return this.FIDDescription;
      }
      
      public function set IDDescription(param1:uint) : void
      {
         this.FIDDescription = param1;
      }
      
      public function get IDIcon() : uint
      {
         return this.FIDIcon;
      }
      
      public function set IDIcon(param1:uint) : void
      {
         this.FIDIcon = param1;
      }
      
      public function get TimingCategory() : uint
      {
         return this.FTimingCategory;
      }
      
      public function set TimingCategory(param1:uint) : void
      {
         this.FTimingCategory = param1;
      }
      
      public function get TimingTime() : uint
      {
         return this.FTimingTime;
      }
      
      public function set TimingTime(param1:uint) : void
      {
         this.FTimingTime = param1;
      }
      
      public function Reset() : void
      {
         FIdentifier = 0;
         this.FIDName = 0;
         this.FIDDescription = 0;
         this.FIDIcon = 0;
         this.FTimingCategory = 0;
         this.FTimingTime = 0;
      }
      
      public function Assign(param1:TBuff) : void
      {
         FIdentifier = param1.Identifier;
         this.FIDName = param1.IDName;
         this.FIDDescription = param1.IDDescription;
         this.FIDIcon = param1.IDIcon;
         this.FTimingCategory = param1.TimingCategory;
         this.FTimingTime = param1.TimingTime;
      }
   }
}

