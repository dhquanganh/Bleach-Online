package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TAddOther;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TMilitary extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FPrefixBefor:String;
      
      protected var FPrefixEnd:String;
      
      protected var FNeedCredit:int;
      
      protected var FCostCredit:int;
      
      protected var FMaxHeroNum:int;
      
      protected var FFightHeroNum:int;
      
      protected var FRewardSiliverCoin:int;
      
      protected var FRewardSpirit:int;
      
      protected var FAddOtherArray:Vector.<TAddOther>;
      
      protected var FSalary:String;
      
      protected var FAddOther:String;
      
      public function TMilitary()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:TAddOther = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FPrefixBefor = TUtilityString.FetchUTF(param1);
         this.FPrefixEnd = TUtilityString.FetchUTF(param1);
         this.FNeedCredit = param1.readUnsignedInt();
         this.FCostCredit = param1.readUnsignedInt();
         this.FSalary = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FSalary);
         _loc6_ = _loc2_.award as Array;
         this.FRewardSiliverCoin = _loc6_[0].amount;
         this.FRewardSpirit = _loc6_[1].amount;
         this.FMaxHeroNum = param1.readUnsignedInt();
         this.FFightHeroNum = param1.readUnsignedInt();
         this.FAddOther = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FAddOther);
         _loc6_ = _loc2_.addOther as Array;
         _loc4_ = int(_loc6_.length);
         this.FAddOtherArray = new Vector.<TAddOther>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = new TAddOther(_loc6_[_loc3_]);
            this.FAddOtherArray[_loc3_] = _loc7_;
            _loc3_++;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get PrefixBefor() : String
      {
         return this.FPrefixBefor;
      }
      
      public function get PrefixEnd() : String
      {
         return this.FPrefixEnd;
      }
      
      public function get NeedCredit() : int
      {
         return this.FNeedCredit;
      }
      
      public function get CostCredit() : int
      {
         return this.FCostCredit;
      }
      
      public function get RewardSiliverCoin() : int
      {
         return this.FRewardSiliverCoin;
      }
      
      public function get RewardSpirit() : int
      {
         return this.FRewardSpirit;
      }
      
      public function get AddOtherArray() : Vector.<TAddOther>
      {
         return this.FAddOtherArray;
      }
      
      public function get MaxHeroNum() : int
      {
         return this.FMaxHeroNum;
      }
      
      public function get FightHeroNum() : int
      {
         return this.FFightHeroNum;
      }
      
      public function get Salary() : String
      {
         return this.FSalary;
      }
      
      public function get AddOther() : String
      {
         return this.FAddOther;
      }
   }
}

