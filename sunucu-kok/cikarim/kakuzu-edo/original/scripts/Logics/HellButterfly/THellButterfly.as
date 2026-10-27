package Logics.HellButterfly
{
   public class THellButterfly
   {
      
      protected var FNowIdentifier0:uint;
      
      protected var FNowIdentifier1:uint;
      
      protected var FName:String;
      
      protected var FLevel:uint;
      
      protected var FCurExp:uint;
      
      protected var FCurCommunicationCount:int;
      
      protected var FNextCommunicationCount:uint;
      
      protected var FEatCount:uint;
      
      protected var FEatCD:uint;
      
      protected var FCollectionLevel:uint;
      
      protected var FIsMyself:Boolean;
      
      public function THellButterfly()
      {
         super();
      }
      
      public function get NowIdentifier0() : uint
      {
         return this.FNowIdentifier0;
      }
      
      public function set NowIdentifier0(param1:uint) : void
      {
         this.FNowIdentifier0 = param1;
      }
      
      public function get NowIdentifier1() : uint
      {
         return this.FNowIdentifier1;
      }
      
      public function set NowIdentifier1(param1:uint) : void
      {
         this.FNowIdentifier1 = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get CurExp() : uint
      {
         return this.FCurExp;
      }
      
      public function set CurExp(param1:uint) : void
      {
         this.FCurExp = param1;
      }
      
      public function get CurCommunicationCount() : int
      {
         return this.FCurCommunicationCount;
      }
      
      public function set CurCommunicationCount(param1:int) : void
      {
         this.FCurCommunicationCount = param1;
      }
      
      public function get NextCommunicationCount() : uint
      {
         return this.FNextCommunicationCount;
      }
      
      public function set NextCommunicationCount(param1:uint) : void
      {
         this.FNextCommunicationCount = param1;
      }
      
      public function get EatCount() : uint
      {
         return this.FEatCount;
      }
      
      public function set EatCount(param1:uint) : void
      {
         this.FEatCount = param1;
      }
      
      public function get EatCD() : uint
      {
         return this.FEatCD;
      }
      
      public function set EatCD(param1:uint) : void
      {
         this.FEatCD = param1;
      }
      
      public function get CollectionLevel() : uint
      {
         return this.FCollectionLevel;
      }
      
      public function set CollectionLevel(param1:uint) : void
      {
         this.FCollectionLevel = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get IsMyself() : Boolean
      {
         return this.FIsMyself;
      }
      
      public function set IsMyself(param1:Boolean) : void
      {
         this.FIsMyself = param1;
      }
      
      public function Reset() : void
      {
         this.FNowIdentifier0 = 0;
         this.FNowIdentifier1 = 0;
         this.FName = "";
         this.FLevel = 0;
         this.FCurExp = 0;
         this.FCurCommunicationCount = 0;
         this.FNextCommunicationCount = 0;
         this.FEatCount = 0;
         this.FEatCD = 0;
         this.FCollectionLevel = 0;
         this.FIsMyself = false;
      }
   }
}

