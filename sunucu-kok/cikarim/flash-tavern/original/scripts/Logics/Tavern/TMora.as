package Logics.Tavern
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TMora
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FTavernHeroId:uint;
      
      protected var FIsMoraWin:Boolean;
      
      protected var FReturnMoney:uint;
      
      public function TMora()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get TavernHeroId() : uint
      {
         return this.FTavernHeroId;
      }
      
      public function set TavernHeroId(param1:uint) : void
      {
         this.FTavernHeroId = param1;
      }
      
      public function get IsMoraWin() : Boolean
      {
         return this.FIsMoraWin;
      }
      
      public function set IsMoraWin(param1:Boolean) : void
      {
         this.FIsMoraWin = param1;
      }
      
      public function get ReturnMoney() : uint
      {
         return this.FReturnMoney;
      }
      
      public function set ReturnMoney(param1:uint) : void
      {
         this.FReturnMoney = param1;
      }
   }
}

