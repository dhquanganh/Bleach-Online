package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TKnifeAdd;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TKnifeExpand extends TDatebaseVO
   {
      
      protected var FRelationID:uint;
      
      protected var FLevel:int;
      
      protected var FSkillID:int;
      
      protected var FKnifeSoulLevelNeed:int;
      
      protected var FQuality:int;
      
      protected var FKnifeSoulAdded:int;
      
      protected var FEffects:String;
      
      protected var FAddedFront:Vector.<TKnifeAdd>;
      
      protected var FAddedMiddle:Vector.<TKnifeAdd>;
      
      protected var FAddedBack:Vector.<TKnifeAdd>;
      
      protected var FKnifeTurns:Vector.<int>;
      
      protected var FNormalExp:int;
      
      protected var FGoldExp:int;
      
      protected var FNeedExp:int;
      
      public function TKnifeExpand()
      {
         super();
         this.FAddedFront = new Vector.<TKnifeAdd>();
         this.FAddedMiddle = new Vector.<TKnifeAdd>();
         this.FAddedBack = new Vector.<TKnifeAdd>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         this.FRelationID = param1.readUnsignedInt();
         this.FLevel = param1.readInt();
         this.FSkillID = param1.readInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc6_ = _loc5_ as Array;
         _loc3_ = int(_loc6_.length);
         this.FKnifeTurns = new Vector.<int>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FKnifeTurns[_loc2_] = _loc6_[_loc2_];
            _loc2_++;
         }
         this.FEffects = TUtilityString.FetchUTF(param1);
         this.FKnifeSoulLevelNeed = param1.readInt();
         this.FQuality = param1.readInt();
         this.FKnifeSoulAdded = param1.readInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc6_ = _loc5_ as Array;
         _loc3_ = int(_loc6_.length);
         this.FAddedFront = new Vector.<TKnifeAdd>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAddedFront[_loc2_] = new TKnifeAdd(_loc6_[_loc2_]);
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc6_ = _loc5_ as Array;
         _loc3_ = int(_loc6_.length);
         this.FAddedMiddle = new Vector.<TKnifeAdd>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAddedMiddle[_loc2_] = new TKnifeAdd(_loc6_[_loc2_]);
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc6_ = _loc5_ as Array;
         _loc3_ = int(_loc6_.length);
         this.FAddedBack = new Vector.<TKnifeAdd>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAddedBack[_loc2_] = new TKnifeAdd(_loc6_[_loc2_]);
            _loc2_++;
         }
         this.FNormalExp = param1.readUnsignedInt();
         this.FGoldExp = param1.readUnsignedInt();
         this.FNeedExp = param1.readUnsignedInt();
      }
      
      public function get RelationID() : uint
      {
         return this.FRelationID;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get SkillID() : int
      {
         return this.FSkillID;
      }
      
      public function get Effects() : String
      {
         return this.FEffects;
      }
      
      public function get KnifeSoulLevelNeed() : int
      {
         return this.FKnifeSoulLevelNeed;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get KnifeSoulAdded() : int
      {
         return this.FKnifeSoulAdded;
      }
      
      public function get AddedFront() : Vector.<TKnifeAdd>
      {
         return this.FAddedFront;
      }
      
      public function get AddedMiddle() : Vector.<TKnifeAdd>
      {
         return this.FAddedMiddle;
      }
      
      public function get AddedBack() : Vector.<TKnifeAdd>
      {
         return this.FAddedBack;
      }
      
      public function get NeedExp() : int
      {
         return this.FNeedExp;
      }
      
      public function get NormalExp() : int
      {
         return this.FNormalExp;
      }
      
      public function get GoldExp() : int
      {
         return this.FGoldExp;
      }
      
      public function get KnifeTurns() : Vector.<int>
      {
         return this.FKnifeTurns;
      }
      
      public function set Effects(param1:String) : void
      {
      }
   }
}

