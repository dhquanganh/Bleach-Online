package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TXmasAward;
   import Logics.DatebaseVO.VO.Json.TXmasExchangeAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChristmas extends THDActivityBase
   {
      
      protected var FExchangeList:Vector.<TXmasExchangeAward>;
      
      protected var FAwardList:Vector.<TXmasAward>;
      
      protected var FFreeTimes:uint;
      
      public function THDChristmas()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:TXmasExchangeAward = null;
         var _loc11_:TXmasAward = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FAwardList = new Vector.<TXmasAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = new TXmasAward(_loc5_[_loc2_]);
            this.FAwardList[_loc2_] = _loc11_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc8_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc7_ = Json.decode(_loc6_) as Array;
         _loc9_ = Json.decode(_loc8_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FExchangeList = new Vector.<TXmasExchangeAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = new TXmasExchangeAward(_loc5_[_loc2_]);
            _loc10_.SetRandomAward(_loc7_[_loc2_]);
            _loc10_.SetName(_loc9_[_loc2_]);
            this.FExchangeList[_loc2_] = _loc10_;
            _loc2_++;
         }
         this.FFreeTimes = param1.readUnsignedInt();
      }
      
      public function get ExchangeList() : Vector.<TXmasExchangeAward>
      {
         return this.FExchangeList;
      }
      
      public function get AwardList() : Vector.<TXmasAward>
      {
         return this.FAwardList;
      }
      
      public function get FreeTimes() : uint
      {
         return this.FFreeTimes;
      }
   }
}

