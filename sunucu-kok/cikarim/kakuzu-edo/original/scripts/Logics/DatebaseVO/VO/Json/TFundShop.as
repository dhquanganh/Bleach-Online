package Logics.DatebaseVO.VO.Json
{
   public class TFundShop
   {
      
      protected var FGold:uint;
      
      protected var FDay:uint;
      
      protected var FGoods:Vector.<uint>;
      
      protected var FName:String;
      
      protected var FTicket:uint;
      
      public function TFundShop(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FGold = param1.gold;
         this.FDay = param1.day;
         _loc2_ = param1.goods as Array;
         _loc4_ = _loc2_.length;
         this.FGoods = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FGoods[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function get Goods() : Vector.<uint>
      {
         return this.FGoods;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Ticket() : uint
      {
         return this.FTicket;
      }
      
      public function SetShopName(param1:Object) : void
      {
         this.FName = param1.name;
         this.FTicket = param1.ticket;
      }
   }
}

