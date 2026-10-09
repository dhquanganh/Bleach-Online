package Logics.VoidSoulWorld.VO
{
   public class TPlayerHurtVO
   {
      
      protected var FPlayerName:String;
      
      protected var FServerID:uint;
      
      protected var FHurt:Number;
      
      protected var FQuality:uint;
      
      protected var FServerName:String;
      
      public function TPlayerHurtVO()
      {
         super();
      }
      
      public function get PlayerName() : String
      {
         return this.FPlayerName;
      }
      
      public function set PlayerName(param1:String) : void
      {
         this.FPlayerName = param1;
      }
      
      public function get ServerID() : uint
      {
         return this.FServerID;
      }
      
      public function set ServerID(param1:uint) : void
      {
         this.FServerID = param1;
      }
      
      public function get Hurt() : Number
      {
         return this.FHurt;
      }
      
      public function set Hurt(param1:Number) : void
      {
         this.FHurt = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function get ServerName() : String
      {
         return this.FServerName;
      }
      
      public function set ServerName(param1:String) : void
      {
         this.FServerName = param1;
      }
   }
}

