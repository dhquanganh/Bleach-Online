package Logics.HDLottery
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityLottery extends TActivityOSBase
   {
      
      protected var FCurScore:uint;
      
      protected var FCurPrize:uint;
      
      protected var FListCodes:Vector.<uint>;
      
      protected var FLastNames:Vector.<String>;
      
      protected var FLastCodes:Vector.<uint>;
      
      protected var FLastGetMoneys:Vector.<uint>;
      
      protected var FDisplayInventories:TInventories;
      
      protected var FIfNewTicketCreate:Boolean;
      
      protected var FTimeStore:int;
      
      protected var FIfGoldHeadChange:Boolean;
      
      public function TActivityLottery()
      {
         super();
         this.FListCodes = new Vector.<uint>();
         this.FLastNames = new Vector.<String>();
         this.FLastCodes = new Vector.<uint>();
         this.FLastGetMoneys = new Vector.<uint>();
         this.FDisplayInventories = new TInventories();
      }
      
      public function get CurScore() : uint
      {
         return this.FCurScore;
      }
      
      public function set CurScore(param1:uint) : void
      {
         this.FCurScore = param1;
      }
      
      public function get CurPrize() : uint
      {
         return this.FCurPrize;
      }
      
      public function set CurPrize(param1:uint) : void
      {
         this.FCurPrize = param1;
      }
      
      public function get ListCodes() : Vector.<uint>
      {
         return this.FListCodes;
      }
      
      public function set ListCodes(param1:Vector.<uint>) : void
      {
         this.FListCodes = param1;
      }
      
      public function get LastNames() : Vector.<String>
      {
         return this.FLastNames;
      }
      
      public function set LastNames(param1:Vector.<String>) : void
      {
         this.FLastNames = param1;
      }
      
      public function get LastCodes() : Vector.<uint>
      {
         return this.FLastCodes;
      }
      
      public function set LastCodes(param1:Vector.<uint>) : void
      {
         this.FLastCodes = param1;
      }
      
      public function get LastGetMoneys() : Vector.<uint>
      {
         return this.FLastGetMoneys;
      }
      
      public function set LastGetMoneys(param1:Vector.<uint>) : void
      {
         this.FLastGetMoneys = param1;
      }
      
      public function get IfNewTicketCreate() : Boolean
      {
         return this.FIfNewTicketCreate;
      }
      
      public function set IfNewTicketCreate(param1:Boolean) : void
      {
         this.FIfNewTicketCreate = param1;
      }
      
      public function get TimeStore() : int
      {
         return this.FTimeStore;
      }
      
      public function set TimeStore(param1:int) : void
      {
         this.FTimeStore = param1;
      }
      
      public function get IfGoldHeadChange() : Boolean
      {
         return this.FIfGoldHeadChange;
      }
      
      public function set IfGoldHeadChange(param1:Boolean) : void
      {
         this.FIfGoldHeadChange = param1;
      }
      
      public function get DisplayInventories() : TInventories
      {
         return this.FDisplayInventories;
      }
   }
}

