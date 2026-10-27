package Logics.NijiaStar
{
   import Resources.Constants.CONST_NIJIASTAR;
   
   public class TNijiaStar
   {
      
      protected var FTag:uint;
      
      protected var FIdentifier:int;
      
      protected var FIsLastPoint:Boolean;
      
      protected var FNijiaStarAtoms:Vector.<TNijiaStarAtom>;
      
      protected var FSevenHeroID:uint;
      
      protected var FHeroName:String;
      
      protected var FDesc:String;
      
      protected var FFinalStarName:String;
      
      protected var FAddValues:Vector.<uint>;
      
      protected var FExtraAddValues:Vector.<uint>;
      
      public function TNijiaStar()
      {
         super();
         this.FNijiaStarAtoms = new Vector.<TNijiaStarAtom>(CONST_NIJIASTAR.CAPACITY_NijiaPoint);
         this.FAddValues = new Vector.<uint>(CONST_NIJIASTAR.CAPACITY_Attribute);
         this.FExtraAddValues = new Vector.<uint>(CONST_NIJIASTAR.CAPACITY_Attribute);
      }
      
      public function get AddValues() : Vector.<uint>
      {
         return this.FAddValues;
      }
      
      public function set AddValues(param1:Vector.<uint>) : void
      {
         this.FAddValues = param1;
      }
      
      public function get Identifier() : int
      {
         return this.FIdentifier;
      }
      
      public function set Identifier(param1:int) : void
      {
         this.FIdentifier = param1;
      }
      
      public function get IsLastPoint() : Boolean
      {
         return this.FIsLastPoint;
      }
      
      public function set IsLastPoint(param1:Boolean) : void
      {
         this.FIsLastPoint = param1;
      }
      
      public function get Tag() : uint
      {
         return this.FTag;
      }
      
      public function set Tag(param1:uint) : void
      {
         this.FTag = param1;
      }
      
      public function get HeroName() : String
      {
         return this.FHeroName;
      }
      
      public function set HeroName(param1:String) : void
      {
         this.FHeroName = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
      
      public function get FinalStarName() : String
      {
         return this.FFinalStarName;
      }
      
      public function set FinalStarName(param1:String) : void
      {
         this.FFinalStarName = param1;
      }
      
      public function get ExtraAddValues() : Vector.<uint>
      {
         return this.FExtraAddValues;
      }
      
      public function set ExtraAddValues(param1:Vector.<uint>) : void
      {
         this.FExtraAddValues = param1;
      }
      
      public function get SevenHeroID() : uint
      {
         return this.FSevenHeroID;
      }
      
      public function set SevenHeroID(param1:uint) : void
      {
         this.FSevenHeroID = param1;
      }
      
      public function GetNijiaStarAtomByIndex(param1:int) : TNijiaStarAtom
      {
         return this.FNijiaStarAtoms[param1];
      }
      
      public function get Count() : uint
      {
         return this.FNijiaStarAtoms.length;
      }
      
      public function SetTotalVaulesByIndex(param1:int, param2:uint) : void
      {
         this.FAddValues[param1] = param2;
      }
      
      public function SetNijiaStarAtomByIndex(param1:int, param2:TNijiaStarAtom) : void
      {
         this.FNijiaStarAtoms[param1] = param2;
      }
   }
}

