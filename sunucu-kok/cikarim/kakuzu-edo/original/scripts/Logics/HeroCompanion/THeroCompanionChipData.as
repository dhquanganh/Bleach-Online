package Logics.HeroCompanion
{
   import Logics.DatebaseVO.VO.TCompanionChip;
   
   public class THeroCompanionChipData
   {
      
      protected var FChipId:int;
      
      protected var FChipData:TCompanionChip;
      
      protected var FAmount:int;
      
      protected var FType:int;
      
      protected var FLastId:int;
      
      public function THeroCompanionChipData()
      {
         super();
      }
      
      public function Format(param1:THeroCompanionChipData) : void
      {
         this.FChipId = param1.ChipId;
         this.FChipData = param1.ChipData;
         this.FAmount = param1.Amount;
         this.FType = param1.TypeId;
         this.FLastId = param1.LastId;
      }
      
      public function get ChipId() : int
      {
         return this.FChipId;
      }
      
      public function set ChipId(param1:int) : void
      {
         this.FChipId = param1;
      }
      
      public function get ChipData() : TCompanionChip
      {
         return this.FChipData;
      }
      
      public function set ChipData(param1:TCompanionChip) : void
      {
         this.FChipData = param1;
      }
      
      public function get Amount() : int
      {
         return this.FAmount;
      }
      
      public function set Amount(param1:int) : void
      {
         this.FAmount = param1;
      }
      
      public function get TypeId() : int
      {
         return this.FType;
      }
      
      public function set TypeId(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get LastId() : int
      {
         return this.FLastId;
      }
      
      public function set LastId(param1:int) : void
      {
         this.FLastId = param1;
      }
   }
}

