package Logics.Organization.VO
{
   public class TOrgApplyListBarVO
   {
      
      protected var FRank:uint;
      
      protected var FName:String;
      
      public function TOrgApplyListBarVO()
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
   }
}

