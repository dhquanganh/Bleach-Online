package Logics.OrganizationalWar
{
   public class TRankInfor
   {
      
      protected var FRankID:int;
      
      protected var FDescribtion:String;
      
      protected var FKeyValue:Object;
      
      public function TRankInfor()
      {
         super();
      }
      
      public function get RankID() : int
      {
         return this.FRankID;
      }
      
      public function set RankID(param1:int) : void
      {
         this.FRankID = param1;
      }
      
      public function get Describtion() : String
      {
         return this.FDescribtion;
      }
      
      public function set Describtion(param1:String) : void
      {
         this.FDescribtion = param1;
      }
      
      public function get KeyValue() : Object
      {
         return this.FKeyValue;
      }
      
      public function set KeyValue(param1:Object) : void
      {
         this.FKeyValue = param1;
      }
   }
}

