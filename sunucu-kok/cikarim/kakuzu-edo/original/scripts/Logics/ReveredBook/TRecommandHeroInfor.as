package Logics.ReveredBook
{
   public class TRecommandHeroInfor
   {
      
      protected var FHeroID:uint;
      
      protected var FPosition:int;
      
      protected var FDescription:String;
      
      protected var FLable:String;
      
      protected var FLevel:int;
      
      protected var FSmallIconID:uint;
      
      public function TRecommandHeroInfor()
      {
         super();
      }
      
      public function get HeroID() : uint
      {
         return this.FHeroID;
      }
      
      public function set HeroID(param1:uint) : void
      {
         this.FHeroID = param1;
      }
      
      public function get Position() : int
      {
         return this.FPosition;
      }
      
      public function set Position(param1:int) : void
      {
         this.FPosition = param1;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function set Description(param1:String) : void
      {
         this.FDescription = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get SmallIconID() : uint
      {
         return this.FSmallIconID;
      }
      
      public function set SmallIconID(param1:uint) : void
      {
         this.FSmallIconID = param1;
      }
      
      public function get Lable() : String
      {
         return this.FLable;
      }
      
      public function set Lable(param1:String) : void
      {
         this.FLable = param1;
      }
   }
}

