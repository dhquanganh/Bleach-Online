package Logics.OrganizationalWar
{
   public class TOraganizationalInfor
   {
      
      protected var FID:int;
      
      protected var FName:String;
      
      protected var FScore:uint;
      
      public function TOraganizationalInfor()
      {
         super();
      }
      
      public function get ID() : int
      {
         return this.FID;
      }
      
      public function set ID(param1:int) : void
      {
         this.FID = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
   }
}

