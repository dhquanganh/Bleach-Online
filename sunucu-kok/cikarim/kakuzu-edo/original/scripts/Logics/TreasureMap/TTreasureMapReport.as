package Logics.TreasureMap
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TTreasureMapReport
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FPlayerNick:String;
      
      protected var FPlayerGeneralStarId:int;
      
      protected var FRobberyPlayerNick:String;
      
      protected var FRobberyGeneralStarId:int;
      
      protected var FMapQuality:int;
      
      protected var FGetMoney:uint;
      
      public function TTreasureMapReport()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get PlayerNick() : String
      {
         return this.FPlayerNick;
      }
      
      public function set PlayerNick(param1:String) : void
      {
         this.FPlayerNick = param1;
      }
      
      public function get PlayerGeneralStarId() : int
      {
         return this.FPlayerGeneralStarId;
      }
      
      public function set PlayerGeneralStarId(param1:int) : void
      {
         this.FPlayerGeneralStarId = param1;
      }
      
      public function get RobberyPlayerNick() : String
      {
         return this.FRobberyPlayerNick;
      }
      
      public function set RobberyPlayerNick(param1:String) : void
      {
         this.FRobberyPlayerNick = param1;
      }
      
      public function get RobberyGeneralStarId() : int
      {
         return this.FRobberyGeneralStarId;
      }
      
      public function set RobberyGeneralStarId(param1:int) : void
      {
         this.FRobberyGeneralStarId = param1;
      }
      
      public function get MapQuality() : int
      {
         return this.FMapQuality;
      }
      
      public function set MapQuality(param1:int) : void
      {
         this.FMapQuality = param1;
      }
      
      public function get GetMoney() : uint
      {
         return this.FGetMoney;
      }
      
      public function set GetMoney(param1:uint) : void
      {
         this.FGetMoney = param1;
      }
   }
}

