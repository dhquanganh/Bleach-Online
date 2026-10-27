package Logics.Campaign
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TStar extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FStarCount:int;
      
      protected var FMaxLayerIndex:int;
      
      protected var FMaxEnemyIndex:int;
      
      public function TStar(param1:uint)
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
      
      public function get StarCount() : uint
      {
         return this.FStarCount;
      }
      
      public function set StarCount(param1:uint) : void
      {
         this.FStarCount = param1;
      }
      
      public function get MaxLayerIndex() : uint
      {
         return this.FMaxLayerIndex;
      }
      
      public function set MaxLayerIndex(param1:uint) : void
      {
         this.FMaxLayerIndex = param1;
      }
      
      public function get MaxEnemyIndex() : uint
      {
         return this.FMaxEnemyIndex;
      }
      
      public function set MaxEnemyIndex(param1:uint) : void
      {
         this.FMaxEnemyIndex = param1;
      }
   }
}

