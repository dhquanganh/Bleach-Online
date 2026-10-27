package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDFirstPayBagConfig extends THDActivityBase
   {
      
      private var FLoginIndex:int;
      
      private var FLoginAwardId:int;
      
      private var FPayAwardIndexVec:Vector.<int>;
      
      private var FPayAwardIDVec:Vector.<int>;
      
      private var FPayAwardGoldVec:Vector.<int>;
      
      private var FRechargeIndex:int;
      
      public function THDFirstPayBagConfig()
      {
         super();
         this.FPayAwardIndexVec = new Vector.<int>();
         this.FPayAwardIDVec = new Vector.<int>();
         this.FPayAwardGoldVec = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLoginIndex = _loc6_.index;
         this.FLoginAwardId = _loc6_.awardId;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPayAwardIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FPayAwardIDVec[_loc2_] = _loc4_[_loc2_].awardId;
            this.FPayAwardGoldVec[_loc2_] = _loc4_[_loc2_].payGold;
            _loc2_++;
         }
         this.FRechargeIndex = param1.readUnsignedInt();
      }
      
      public function get LoginIndex() : int
      {
         return this.FLoginIndex;
      }
      
      public function get LoginAwardId() : int
      {
         return this.FLoginAwardId;
      }
      
      public function get PayAwardIndexVec() : Vector.<int>
      {
         return this.FPayAwardIndexVec;
      }
      
      public function get PayAwardIDVec() : Vector.<int>
      {
         return this.FPayAwardIDVec;
      }
      
      public function get PayAwardGoldVec() : Vector.<int>
      {
         return this.FPayAwardGoldVec;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
   }
}

