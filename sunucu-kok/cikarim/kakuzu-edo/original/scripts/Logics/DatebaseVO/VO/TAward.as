package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TAward extends TDatebaseVO
   {
      
      protected var FFixedAwards:Vector.<TFixedAward> = new Vector.<TFixedAward>();
      
      protected var FRandomAwards:Vector.<TArticalItem> = new Vector.<TArticalItem>();
      
      protected var FFixed:String;
      
      public function TAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TFixedAward = null;
         var _loc8_:String = null;
         this; //unpopped
         this.FFixed = TUtilityString.FetchUTF(param1);
         if(!TUtilityString.Empty(this.FFixed))
         {
            _loc3_ = Json.decode(this.FFixed);
            _loc4_ = _loc3_.fixed as Array;
            _loc6_ = _loc4_.length;
            this.FFixedAwards = new Vector.<TFixedAward>(_loc6_);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = new TFixedAward(_loc4_[_loc5_]);
               this.FFixedAwards[_loc5_] = _loc7_;
               _loc5_++;
            }
         }
         _loc8_ = TUtilityString.FetchUTF(param1);
         if(!TUtilityString.Empty(_loc8_))
         {
            _loc3_ = Json.decode(_loc8_);
            _loc4_ = _loc3_.rewards as Array;
            _loc6_ = _loc4_.length;
            this.FRandomAwards = new Vector.<TArticalItem>();
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               this.FlushRandomAwardsByArr(_loc4_[_loc5_].value,this.FRandomAwards);
               _loc5_++;
            }
         }
      }
      
      protected function FlushRandomAwardsByArr(param1:Array, param2:Vector.<TArticalItem>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TArticalItem = null;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new TArticalItem(param1[_loc3_]);
            param2.push(_loc5_);
            _loc3_++;
         }
      }
      
      public function get FixedAwards() : Vector.<TFixedAward>
      {
         return this.FFixedAwards;
      }
      
      public function get Fixed() : String
      {
         return this.FFixed;
      }
      
      public function get RandomAwards() : Vector.<TArticalItem>
      {
         return this.FRandomAwards;
      }
   }
}

