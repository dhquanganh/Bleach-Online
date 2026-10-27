package Logics.Characters.MoveRole
{
   import Foundation.Common.Stubs.TStubReferences;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TRoleCanControl extends TRole
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FLevel:uint;
      
      protected var FFamilyID:uint;
      
      protected var FMilitaryRank:uint;
      
      protected var FQuality:uint;
      
      protected var FChangeShape:Boolean;
      
      protected var FNewShapeBaseHeroID:uint;
      
      protected var FRelexBoo:Boolean;
      
      protected var FTextureID:uint;
      
      protected var FMapX:Number;
      
      protected var FMapY:Number;
      
      protected var FRebirthNum:uint;
      
      public function TRoleCanControl(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get MilitaryRank() : uint
      {
         return this.FMilitaryRank;
      }
      
      public function set MilitaryRank(param1:uint) : void
      {
         this.FMilitaryRank = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function get ChangeShape() : Boolean
      {
         return this.FChangeShape;
      }
      
      public function set ChangeShape(param1:Boolean) : void
      {
         this.FChangeShape = param1;
      }
      
      public function get NewShapeBaseHeroID() : uint
      {
         return this.FNewShapeBaseHeroID;
      }
      
      public function set NewShapeBaseHeroID(param1:uint) : void
      {
         this.FNewShapeBaseHeroID = param1;
      }
      
      public function get RelexBoo() : Boolean
      {
         return this.FRelexBoo;
      }
      
      public function set RelexBoo(param1:Boolean) : void
      {
         this.FRelexBoo = param1;
      }
      
      public function get TextureID() : uint
      {
         return this.FTextureID;
      }
      
      public function set TextureID(param1:uint) : void
      {
         this.FTextureID = param1;
      }
      
      public function get MapX() : Number
      {
         return this.FMapX;
      }
      
      public function set MapX(param1:Number) : void
      {
         this.FMapX = param1;
      }
      
      public function get MapY() : Number
      {
         return this.FMapY;
      }
      
      public function set MapY(param1:Number) : void
      {
         this.FMapY = param1;
      }
      
      public function get FamilyID() : uint
      {
         return this.FFamilyID;
      }
      
      public function set FamilyID(param1:uint) : void
      {
         this.FFamilyID = param1;
      }
      
      public function get RebirthNum() : uint
      {
         return this.FRebirthNum;
      }
      
      public function set RebirthNum(param1:uint) : void
      {
         this.FRebirthNum = param1;
      }
   }
}

