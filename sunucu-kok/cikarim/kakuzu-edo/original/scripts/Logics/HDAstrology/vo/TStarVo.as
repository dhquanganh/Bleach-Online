package Logics.HDAstrology.vo
{
   public class TStarVo
   {
      
      private var FStarIndex:int;
      
      private var FStarAmount:int;
      
      private var FStarType:int;
      
      private var FStarCardPrice:int;
      
      private var FDesc:String;
      
      public function TStarVo()
      {
         super();
      }
      
      public function get StarIndex() : int
      {
         return this.FStarIndex;
      }
      
      public function set StarIndex(param1:int) : void
      {
         this.FStarIndex = param1;
      }
      
      public function get StarAmount() : int
      {
         return this.FStarAmount;
      }
      
      public function set StarAmount(param1:int) : void
      {
         this.FStarAmount = param1;
      }
      
      public function get StarType() : int
      {
         return this.FStarType;
      }
      
      public function set StarType(param1:int) : void
      {
         this.FStarType = param1;
      }
      
      public function get StarCardPrice() : int
      {
         return this.FStarCardPrice;
      }
      
      public function set StarCardPrice(param1:int) : void
      {
         this.FStarCardPrice = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
   }
}

