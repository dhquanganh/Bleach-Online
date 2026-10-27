package Logics.HDRandCard
{
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityRCAwardCard extends TActivityEntity
   {
      
      protected var FAward:uint;
      
      protected var FFixedAward:TFixedAward;
      
      protected var FIsDelete:Boolean;
      
      protected var FIsSelect:Boolean;
      
      public function TActivityRCAwardCard(param1:uint)
      {
         super(param1);
      }
      
      public function get FixedAward() : TFixedAward
      {
         return this.FFixedAward;
      }
      
      public function set FixedAward(param1:TFixedAward) : void
      {
         this.FFixedAward = param1;
      }
      
      public function get IsDelete() : Boolean
      {
         return this.FIsDelete;
      }
      
      public function set IsDelete(param1:Boolean) : void
      {
         this.FIsDelete = param1;
      }
      
      public function get IsSelect() : Boolean
      {
         return this.FIsSelect;
      }
      
      public function set IsSelect(param1:Boolean) : void
      {
         this.FIsSelect = param1;
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
      
      public function set Award(param1:uint) : void
      {
         this.FAward = param1;
      }
   }
}

