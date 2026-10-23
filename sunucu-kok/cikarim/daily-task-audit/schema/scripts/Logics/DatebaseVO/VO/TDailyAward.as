package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TDailyAward extends TDatebaseVO
   {
      
      protected var FMark:int;
      
      protected var FLevel1:int;
      
      protected var FRewardsVect:Vector.<TFixedAward>;
      
      protected var FRewards:String;
      
      public function TDailyAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:TFixedAward = null;
         this.FMark = param1.readUnsignedInt();
         this.FLevel1 = param1.readUnsignedInt();
         this.FRewards = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FRewards);
         _loc5_ = _loc4_ as Array;
         _loc3_ = int(_loc5_.length);
         this.FRewardsVect = new Vector.<TFixedAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TFixedAward(_loc5_[_loc2_]);
            this.FRewardsVect[_loc2_] = _loc6_;
            _loc2_++;
         }
      }
      
      public function get RewardsVect() : Vector.<TFixedAward>
      {
         return this.FRewardsVect;
      }
      
      public function get Level1() : int
      {
         return this.FLevel1;
      }
      
      public function get Mark() : int
      {
         return this.FMark;
      }
      
      public function get Rewards() : String
      {
         return this.FRewards;
      }
   }
}

