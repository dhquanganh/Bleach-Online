package Logics.DatebaseVO.VO.Json
{
   public class TXmasExchangeAward
   {
      
      protected var FSugarName:String;
      
      protected var FRandomAward:Vector.<uint>;
      
      protected var FSugarId:uint;
      
      protected var FGetSugarCount:uint;
      
      protected var FCost:uint;
      
      public function TXmasExchangeAward(param1:Object)
      {
         super();
         this.FSugarId = param1.sugarId;
         this.FGetSugarCount = param1.sugarAmount;
         this.FCost = param1.gold;
      }
      
      public function get SugarName() : String
      {
         return this.FSugarName;
      }
      
      public function get RandomAward() : Vector.<uint>
      {
         return this.FRandomAward;
      }
      
      public function get SugarId() : uint
      {
         return this.FSugarId;
      }
      
      public function get GetSugarCount() : uint
      {
         return this.FGetSugarCount;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function SetRandomAward(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.awardId as Array;
         _loc4_ = _loc2_.length;
         this.FRandomAward = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FRandomAward[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
      
      public function SetName(param1:String) : void
      {
         this.FSugarName = param1;
      }
   }
}

