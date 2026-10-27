package Logics.HDActivityBigTurnTable
{
   public class TBigTurnTableBuyHero
   {
      
      protected var FIndex:Vector.<int>;
      
      protected var FCost:Vector.<int>;
      
      protected var FIfBuyed:Vector.<Boolean>;
      
      protected var FFightReportAddr:Vector.<String>;
      
      public function TBigTurnTableBuyHero(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super();
         this.FIndex = new Vector.<int>();
         this.FCost = new Vector.<int>();
         this.FIfBuyed = new Vector.<Boolean>();
         this.FFightReportAddr = new Vector.<String>();
         _loc2_ = param1 as Array;
         _loc4_ = int(_loc2_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FIndex.push(_loc2_[_loc3_].index);
            this.FCost.push(_loc2_[_loc3_].cost);
            this.FFightReportAddr.push(_loc2_[_loc3_].fightReportAddr);
            _loc3_++;
         }
      }
      
      public function get Cost() : Vector.<int>
      {
         return this.FCost;
      }
      
      public function set Cost(param1:Vector.<int>) : void
      {
         this.FCost = param1;
      }
      
      public function get IfBuyed() : Vector.<Boolean>
      {
         return this.FIfBuyed;
      }
      
      public function set IfBuyed(param1:Vector.<Boolean>) : void
      {
         this.FIfBuyed = param1;
      }
      
      public function get Index() : Vector.<int>
      {
         return this.FIndex;
      }
      
      public function set Index(param1:Vector.<int>) : void
      {
         this.FIndex = param1;
      }
      
      public function get FightReportAddr() : Vector.<String>
      {
         return this.FFightReportAddr;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FIndex.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FIndex[_loc3_] == param1)
            {
               this.FIfBuyed[_loc3_] = param2 == 1;
               return;
            }
            _loc3_++;
         }
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         this.ActivityDataInit(param1,param2);
      }
   }
}

