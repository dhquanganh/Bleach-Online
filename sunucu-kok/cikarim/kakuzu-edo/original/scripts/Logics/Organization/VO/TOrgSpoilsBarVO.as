package Logics.Organization.VO
{
   public class TOrgSpoilsBarVO
   {
      
      protected var FType:uint;
      
      protected var FCode:uint;
      
      protected var FCount:uint;
      
      protected var FAppCount:uint;
      
      protected var FRank:uint;
      
      protected var FIsApp:Boolean;
      
      public function TOrgSpoilsBarVO()
      {
         super();
         this.FType = 1;
      }
      
      public function get Code() : uint
      {
         return this.FCode;
      }
      
      public function set Code(param1:uint) : void
      {
         this.FCode = param1;
      }
      
      public function get Count() : uint
      {
         return this.FCount;
      }
      
      public function set Count(param1:uint) : void
      {
         this.FCount = param1;
      }
      
      public function get AppCount() : uint
      {
         return this.FAppCount;
      }
      
      public function set AppCount(param1:uint) : void
      {
         this.FAppCount = param1;
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
      
      public function set Rank(param1:uint) : void
      {
         this.FRank = param1;
      }
      
      public function get IsApp() : Boolean
      {
         return this.FIsApp;
      }
      
      public function set IsApp(param1:Boolean) : void
      {
         this.FIsApp = param1;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
   }
}

