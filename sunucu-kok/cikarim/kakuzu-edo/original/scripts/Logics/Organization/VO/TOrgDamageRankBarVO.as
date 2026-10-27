package Logics.Organization.VO
{
   public class TOrgDamageRankBarVO
   {
      
      protected var FRank:uint;
      
      protected var FName:String;
      
      protected var FDamage:Number;
      
      public function TOrgDamageRankBarVO()
      {
         super();
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
      
      public function set Rank(param1:uint) : void
      {
         this.FRank = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Damage() : Number
      {
         return this.FDamage;
      }
      
      public function set Damage(param1:Number) : void
      {
         this.FDamage = param1;
      }
   }
}

