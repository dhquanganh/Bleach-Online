package Logics.FighterDetail
{
   import Logics.Characters.THeros;
   
   public class TFighterDetails
   {
      
      protected var FFighterDetails:Vector.<TFighterDetailData>;
      
      protected var FHeros:THeros;
      
      public function TFighterDetails()
      {
         super();
         this.FFighterDetails = new Vector.<TFighterDetailData>();
         this.FHeros = new THeros();
      }
      
      public function get Heros() : THeros
      {
         return this.FHeros;
      }
      
      public function set Heros(param1:THeros) : void
      {
         this.FHeros = param1;
      }
      
      public function get Count() : int
      {
         return this.FFighterDetails.length;
      }
      
      public function GetTFighterDetail(param1:int) : TFighterDetailData
      {
         return this.FFighterDetails[param1];
      }
      
      public function Add(param1:TFighterDetailData) : void
      {
         this.FFighterDetails.push(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFighterDetailData = null;
         _loc1_ = int(this.FFighterDetails.length);
         _loc2_ = 0;
         while(_loc2_ < this.FFighterDetails.length)
         {
            this.FFighterDetails.pop();
            _loc2_++;
         }
         this.FFighterDetails.length = 0;
         this.FHeros.Clear();
      }
   }
}

