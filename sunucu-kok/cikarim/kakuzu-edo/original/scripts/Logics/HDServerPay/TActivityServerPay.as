package Logics.HDServerPay
{
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDIceHeros.TActivityIHAward;
   
   public class TActivityServerPay extends TActivityOSBase
   {
      
      protected var FRanks:Vector.<TActivityServerRank>;
      
      protected var FRankAwards:Vector.<TActivitySPAwards>;
      
      protected var FHeros:Vector.<TActivitySPHero>;
      
      protected var FHerosData:Vector.<TActivityIHAward>;
      
      protected var FCurScore:uint;
      
      protected var FExchangeShops:Vector.<TActivitySPExchangeShop>;
      
      public function TActivityServerPay()
      {
         super();
      }
      
      public function get CurScore() : uint
      {
         return this.FCurScore;
      }
      
      public function set CurScore(param1:uint) : void
      {
         this.FCurScore = param1;
      }
      
      public function get Heros() : Vector.<TActivitySPHero>
      {
         return this.FHeros;
      }
      
      public function set Heros(param1:Vector.<TActivitySPHero>) : void
      {
         this.FHeros = param1;
      }
      
      public function get Ranks() : Vector.<TActivityServerRank>
      {
         return this.FRanks;
      }
      
      public function set Ranks(param1:Vector.<TActivityServerRank>) : void
      {
         this.FRanks = param1;
      }
      
      public function get RankAwards() : Vector.<TActivitySPAwards>
      {
         return this.FRankAwards;
      }
      
      public function set RankAwards(param1:Vector.<TActivitySPAwards>) : void
      {
         this.FRankAwards = param1;
      }
      
      public function get ExchangeCount() : uint
      {
         if(this.FExchangeShops == null)
         {
            return 0;
         }
         return this.FExchangeShops.length;
      }
      
      public function set ExchangeShops(param1:Vector.<TActivitySPExchangeShop>) : void
      {
         this.FExchangeShops = param1;
      }
      
      public function get HerosData() : Vector.<TActivityIHAward>
      {
         return this.FHerosData;
      }
      
      public function set HerosData(param1:Vector.<TActivityIHAward>) : void
      {
         this.FHerosData = param1;
      }
      
      public function UpdateStatus(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivitySPExchangeShop = null;
         _loc5_ = this.GetExchangeByUIndex(param1);
         if(_loc5_ != null)
         {
            _loc5_.Status = param2;
         }
         else
         {
            _loc4_ = int(this.FHerosData.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(this.FHerosData[_loc3_].Index == param1)
               {
                  this.FHerosData[_loc3_].Status = param2;
               }
               _loc3_++;
            }
         }
      }
      
      public function GetExchangeByUIndex(param1:uint) : TActivitySPExchangeShop
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FExchangeShops == null)
         {
            return null;
         }
         _loc3_ = int(this.FExchangeShops.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FExchangeShops[_loc2_].Index == param1)
            {
               return this.FExchangeShops[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetExchangeByIndex(param1:int) : TActivitySPExchangeShop
      {
         if(this.FExchangeShops == null)
         {
            return null;
         }
         return this.FExchangeShops[param1];
      }
   }
}

