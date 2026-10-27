package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.Inventories.TInventories;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYearFly extends THDActivityBase
   {
      
      public static const STRING_MSG_0:int = 0;
      
      public static const STRING_MSG_1:int = 1;
      
      public static const STRING_MSG_2:int = 2;
      
      public static const STRING_MSG_3:int = 3;
      
      protected var FFriendIndex:int;
      
      protected var FCharmCountIndex:int;
      
      protected var FGoodCountIndex:int;
      
      protected var FActAwardCount:int;
      
      protected var FCharmCardIndexVec:Vector.<int>;
      
      protected var FCharmCardNumVec:Vector.<int>;
      
      protected var FCharmCardAwardVec:Vector.<int>;
      
      protected var FGoodCardIndexVec:Vector.<int>;
      
      protected var FGoodCardNumVec:Vector.<int>;
      
      protected var FGoodCardAwardVec:Vector.<int>;
      
      protected var FGoodInventories:Vector.<TInventories>;
      
      protected var FCharmInventories:Vector.<TInventories>;
      
      protected var FActIndexVec:Vector.<int>;
      
      protected var FActGoldsVec:Vector.<Vector.<int>>;
      
      protected var FActAwardsVec:Vector.<Vector.<int>>;
      
      protected var FStringMsgVec:Vector.<String>;
      
      public function THDNewYearFly()
      {
         super();
         this.FCharmCardIndexVec = new Vector.<int>();
         this.FCharmCardNumVec = new Vector.<int>();
         this.FCharmCardAwardVec = new Vector.<int>();
         this.FGoodCardIndexVec = new Vector.<int>();
         this.FGoodCardNumVec = new Vector.<int>();
         this.FGoodCardAwardVec = new Vector.<int>();
         this.FActIndexVec = new Vector.<int>();
         this.FStringMsgVec = new Vector.<String>();
         this.FActGoldsVec = new Vector.<Vector.<int>>();
         this.FActAwardsVec = new Vector.<Vector.<int>>();
         this.FGoodInventories = new Vector.<TInventories>();
         this.FCharmInventories = new Vector.<TInventories>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFriendIndex = param1.readUnsignedInt();
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc10_);
         _loc5_ = int(_loc4_.length);
         _loc7_ = new Array();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FActIndexVec.push(_loc4_[_loc6_].index);
            _loc7_.length = 0;
            _loc7_ = _loc4_[_loc6_].gold;
            _loc3_ = new Vector.<int>();
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc3_.push(_loc7_[_loc9_]);
               _loc9_++;
            }
            this.FActGoldsVec.push(_loc3_);
            _loc7_.length = 0;
            _loc7_ = _loc4_[_loc6_].award;
            _loc2_ = new Vector.<int>();
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc2_.push(_loc7_[_loc9_]);
               _loc9_++;
            }
            this.FActAwardsVec.push(_loc2_);
            _loc6_++;
         }
         this.FActAwardCount = _loc8_;
         this.FCharmCountIndex = param1.readUnsignedInt();
         this.FGoodCountIndex = param1.readUnsignedInt();
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc10_);
         _loc5_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FGoodCardIndexVec.push(_loc4_[_loc6_].index);
            this.FGoodCardNumVec.push(_loc4_[_loc6_].exchangeNum);
            this.FGoodCardAwardVec.push(_loc4_[_loc6_].award);
            _loc6_++;
         }
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc10_);
         _loc5_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FCharmCardIndexVec.push(_loc4_[_loc6_].index);
            this.FCharmCardNumVec.push(_loc4_[_loc6_].exchangeNum);
            this.FCharmCardAwardVec.push(_loc4_[_loc6_].award);
            _loc6_++;
         }
         _loc10_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc10_);
         _loc5_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.FStringMsgVec.push(_loc4_[_loc6_]);
            _loc6_++;
         }
      }
      
      public function get FriendIndex() : int
      {
         return this.FFriendIndex;
      }
      
      public function set FriendIndex(param1:int) : void
      {
         this.FFriendIndex = param1;
      }
      
      public function get CharmCountIndex() : int
      {
         return this.FCharmCountIndex;
      }
      
      public function set CharmCountIndex(param1:int) : void
      {
         this.FCharmCountIndex = param1;
      }
      
      public function get GoodCountIndex() : int
      {
         return this.FGoodCountIndex;
      }
      
      public function set GoodCountIndex(param1:int) : void
      {
         this.FGoodCountIndex = param1;
      }
      
      public function get CharmCardIndexVec() : Vector.<int>
      {
         return this.FCharmCardIndexVec;
      }
      
      public function get CharmCardNumVec() : Vector.<int>
      {
         return this.FCharmCardNumVec;
      }
      
      public function get CharmCardAwardVec() : Vector.<int>
      {
         return this.FCharmCardAwardVec;
      }
      
      public function get GoodCardIndexVec() : Vector.<int>
      {
         return this.FGoodCardIndexVec;
      }
      
      public function get GoodCardNumVec() : Vector.<int>
      {
         return this.FGoodCardNumVec;
      }
      
      public function get GoodCardAwardVec() : Vector.<int>
      {
         return this.FGoodCardAwardVec;
      }
      
      public function get ActIndexVec() : Vector.<int>
      {
         return this.FActIndexVec;
      }
      
      public function get ActAwardCount() : int
      {
         return this.FActAwardCount;
      }
      
      public function set ActAwardCount(param1:int) : void
      {
         this.FActAwardCount = param1;
      }
      
      public function get ActCount() : int
      {
         return this.FActAwardsVec.length;
      }
      
      public function get GoodInventories() : Vector.<TInventories>
      {
         return this.FGoodInventories;
      }
      
      public function get CharmInventories() : Vector.<TInventories>
      {
         return this.FCharmInventories;
      }
      
      public function get StringMsgVec() : Vector.<String>
      {
         return this.FStringMsgVec;
      }
      
      public function GetActGoldsByPos(param1:int) : Vector.<int>
      {
         return this.FActGoldsVec[param1];
      }
      
      public function GetActAwardsByPos(param1:int) : Vector.<int>
      {
         return this.FActAwardsVec[param1];
      }
      
      public function GetGoodIndexByCode(param1:int) : int
      {
         return this.FGoodCardIndexVec.indexOf(param1);
      }
      
      public function GetCharmIndexByCode(param1:int) : int
      {
         return this.FCharmCardIndexVec.indexOf(param1);
      }
   }
}

