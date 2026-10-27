package Logics.Pet.Gift
{
   import Foundation.Common.*;
   import Logics.Inventories.*;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TGift extends TEntity
   {
      
      protected static const CAPACITY_CONDITION:uint = 3;
      
      protected static const INDEX_USERLEVEL:uint = 0;
      
      protected static const INDEX_MAINPETSTAGE:uint = 1;
      
      protected static const INDEX_VICEPETNUM:uint = 2;
      
      protected var FName:String;
      
      protected var FConditions:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FStatus:Boolean;
      
      protected var FIsUserLevel:Boolean;
      
      protected var FIsMainPetStage:Boolean;
      
      protected var FIsVicePetNum:Boolean;
      
      public function TGift(param1:uint)
      {
         super(param1);
         this.FConditions = new Vector.<uint>(CAPACITY_CONDITION);
         this.FInventories = new TInventories();
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Conditions() : Vector.<uint>
      {
         return this.FConditions;
      }
      
      public function get UserLevel() : uint
      {
         return this.FConditions[INDEX_USERLEVEL];
      }
      
      public function set UserLevel(param1:uint) : void
      {
         this.FConditions[INDEX_USERLEVEL] = param1;
      }
      
      public function get MainPetStage() : uint
      {
         return this.FConditions[INDEX_MAINPETSTAGE];
      }
      
      public function set MainPetStage(param1:uint) : void
      {
         this.FConditions[INDEX_MAINPETSTAGE] = param1;
      }
      
      public function get VicePetNum() : uint
      {
         return this.FConditions[INDEX_VICEPETNUM];
      }
      
      public function set VicePetNum(param1:uint) : void
      {
         this.FConditions[INDEX_VICEPETNUM] = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function get Status() : Boolean
      {
         return this.FStatus;
      }
      
      public function set Status(param1:Boolean) : void
      {
         this.FStatus = param1;
      }
      
      public function get IsUserLevel() : Boolean
      {
         return this.FIsUserLevel;
      }
      
      public function set IsUserLevel(param1:Boolean) : void
      {
         this.FIsUserLevel = param1;
      }
      
      public function get IsMainPetStage() : Boolean
      {
         return this.FIsMainPetStage;
      }
      
      public function set IsMainPetStage(param1:Boolean) : void
      {
         this.FIsMainPetStage = param1;
      }
      
      public function get IsVicePetNum() : Boolean
      {
         return this.FIsVicePetNum;
      }
      
      public function set IsVicePetNum(param1:Boolean) : void
      {
         this.FIsVicePetNum = param1;
      }
      
      public function Clear() : void
      {
         this.FInventories.Clear();
         this.FInventories = null;
      }
   }
}

