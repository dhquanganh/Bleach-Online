package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTimeLimitTurntableConfig extends THDActivityBase
   {
      
      private var FLowTurntableGoldVec:Vector.<int>;
      
      private var FLowTurntableIndexVec:Vector.<int>;
      
      private var FHighTurntableGoldVec:Vector.<int>;
      
      private var FHighTurntableIndexVec:Vector.<int>;
      
      private var FLowMaxTime:int;
      
      private var FLowGold:int;
      
      private var FHighMaxTime:int;
      
      private var FHighGold:int;
      
      private var FLowExtractIndex:int;
      
      private var FHighExtractIndex:int;
      
      private var FLowFinishExtractIndex:int;
      
      private var FHighFinishExtractIndex:int;
      
      private var FRechargeIndex:int;
      
      private var FRecordMaxNum:int;
      
      private var FLowDesc:String;
      
      private var FLowMaxDesc:String;
      
      private var FExtractMaxDesc:String;
      
      private var FExtractLackDesc:String;
      
      public function THDTimeLimitTurntableConfig()
      {
         super();
         this.FLowTurntableGoldVec = new Vector.<int>();
         this.FLowTurntableIndexVec = new Vector.<int>();
         this.FHighTurntableGoldVec = new Vector.<int>();
         this.FHighTurntableIndexVec = new Vector.<int>();
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
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FLowTurntableGoldVec[_loc2_] = _loc4_[_loc2_].gold;
            this.FLowTurntableIndexVec[_loc2_] = _loc4_[_loc2_].index;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FHighTurntableGoldVec[_loc2_] = _loc4_[_loc2_].gold;
            this.FHighTurntableIndexVec[_loc2_] = _loc4_[_loc2_].index;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ == 0)
            {
               this.FLowMaxTime = _loc4_[_loc2_].maxTime;
               this.FLowGold = _loc4_[_loc2_].rechargeGold;
            }
            else
            {
               this.FHighMaxTime = _loc4_[_loc2_].maxTime;
               this.FHighGold = _loc4_[_loc2_].rechargeGold;
            }
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLowExtractIndex = _loc6_.lowIndex;
         this.FHighExtractIndex = _loc6_.highIndex;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLowFinishExtractIndex = _loc6_.lowFinishIndex;
         this.FHighFinishExtractIndex = _loc6_.highFinishIndex;
         this.FRechargeIndex = param1.readUnsignedInt();
         this.FRecordMaxNum = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FLowDesc = _loc6_.lowDesc;
         this.FLowMaxDesc = _loc6_.lowMaxDesc;
         this.FExtractMaxDesc = _loc6_.extractMaxDesc;
         this.FExtractLackDesc = _loc6_.extractLackDesc;
      }
      
      public function get LowTurntableGoldVec() : Vector.<int>
      {
         return this.FLowTurntableGoldVec;
      }
      
      public function get LowTurntableIndexVec() : Vector.<int>
      {
         return this.FLowTurntableIndexVec;
      }
      
      public function get HighTurntableGoldVec() : Vector.<int>
      {
         return this.FHighTurntableGoldVec;
      }
      
      public function get HighTurntableIndexVec() : Vector.<int>
      {
         return this.FHighTurntableIndexVec;
      }
      
      public function get LowMaxTime() : int
      {
         return this.FLowMaxTime;
      }
      
      public function get LowGold() : int
      {
         return this.FLowGold;
      }
      
      public function get HighMaxTime() : int
      {
         return this.FHighMaxTime;
      }
      
      public function get HighGold() : int
      {
         return this.FHighGold;
      }
      
      public function get LowExtractIndex() : int
      {
         return this.FLowExtractIndex;
      }
      
      public function get HighExtractIndex() : int
      {
         return this.FHighExtractIndex;
      }
      
      public function get LowFinishExtractIndex() : int
      {
         return this.FLowFinishExtractIndex;
      }
      
      public function get HighFinishExtractIndex() : int
      {
         return this.FHighFinishExtractIndex;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get RecordMaxNum() : int
      {
         return this.FRecordMaxNum;
      }
      
      public function get LowDesc() : String
      {
         return this.FLowDesc;
      }
      
      public function get LowMaxDesc() : String
      {
         return this.FLowMaxDesc;
      }
      
      public function get ExtractMaxDesc() : String
      {
         return this.FExtractMaxDesc;
      }
      
      public function get ExtractLackDesc() : String
      {
         return this.FExtractLackDesc;
      }
   }
}

