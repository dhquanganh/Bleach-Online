package Logics.NijiaStar
{
   public class TNijiaStarAtom
   {
      
      protected var FIdentifier:int;
      
      protected var FBigStar:uint;
      
      protected var FSort:uint;
      
      protected var FPreLittleStar:int;
      
      protected var FIsLast:uint;
      
      protected var FCostSoul:uint;
      
      protected var FLittleStarName:String;
      
      protected var FIsActivate:Boolean;
      
      protected var FAddValues:Vector.<uint>;
      
      public function TNijiaStarAtom()
      {
         super();
         this.FAddValues = new Vector.<uint>();
      }
      
      public function get BigStar() : uint
      {
         return this.FBigStar;
      }
      
      public function set BigStar(param1:uint) : void
      {
         this.FBigStar = param1;
      }
      
      public function get Sort() : uint
      {
         return this.FSort;
      }
      
      public function set Sort(param1:uint) : void
      {
         this.FSort = param1;
      }
      
      public function get PreLittleStar() : int
      {
         return this.FPreLittleStar;
      }
      
      public function set PreLittleStar(param1:int) : void
      {
         this.FPreLittleStar = param1;
      }
      
      public function get IsLast() : uint
      {
         return this.FIsLast;
      }
      
      public function set IsLast(param1:uint) : void
      {
         this.FIsLast = param1;
      }
      
      public function get CostSoul() : uint
      {
         return this.FCostSoul;
      }
      
      public function set CostSoul(param1:uint) : void
      {
         this.FCostSoul = param1;
      }
      
      public function get LittleStarName() : String
      {
         return this.FLittleStarName;
      }
      
      public function set LittleStarName(param1:String) : void
      {
         this.FLittleStarName = param1;
      }
      
      public function get Identifier() : int
      {
         return this.FIdentifier;
      }
      
      public function set Identifier(param1:int) : void
      {
         this.FIdentifier = param1;
      }
      
      public function get AddValues() : Vector.<uint>
      {
         return this.FAddValues;
      }
      
      public function set AddValues(param1:Vector.<uint>) : void
      {
         this.FAddValues = param1;
      }
      
      public function get IsActivate() : Boolean
      {
         return this.FIsActivate;
      }
      
      public function set IsActivate(param1:Boolean) : void
      {
         this.FIsActivate = param1;
      }
   }
}

