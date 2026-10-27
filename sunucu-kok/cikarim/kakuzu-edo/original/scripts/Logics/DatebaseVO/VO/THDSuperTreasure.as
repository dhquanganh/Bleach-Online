package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.TConditionStyleB;
   import Logics.DatebaseVO.VO.Json.TConditionStyleC;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDSuperTreasure extends THDActivityBase
   {
      
      protected var FPage1:Vector.<TConditionStyleB>;
      
      protected var FPage2:Vector.<TConditionStyleB>;
      
      protected var FPage3:Vector.<TConditionStyleC>;
      
      protected var FPage3PromptVect:Vector.<Vector.<String>>;
      
      protected var FEnterNames:Vector.<String>;
      
      protected var FPage1Awards:Vector.<uint>;
      
      protected var FPage2Awards:Vector.<uint>;
      
      protected var FPage3AwardsVect:Vector.<Vector.<uint>>;
      
      public function THDSuperTreasure()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Vector.<String> = null;
         var _loc10_:TConditionStyleB = null;
         var _loc11_:TConditionStyleC = null;
         var _loc12_:Vector.<uint> = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc7_.length);
         this.FPage1 = new Vector.<TConditionStyleB>(_loc3_);
         this.FPage1Awards = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = new TConditionStyleB(_loc7_[_loc2_]);
            this.FPage1[_loc2_] = _loc10_;
            this.FPage1Awards[_loc2_] = _loc10_.Awards[0];
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc7_.length);
         this.FPage2 = new Vector.<TConditionStyleB>(_loc3_);
         this.FPage2Awards = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = new TConditionStyleB(_loc7_[_loc2_]);
            this.FPage2[_loc2_] = _loc10_;
            this.FPage2Awards[_loc2_] = _loc10_.Awards[0];
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc7_.length);
         this.FPage3 = new Vector.<TConditionStyleC>(_loc3_);
         this.FPage3AwardsVect = new Vector.<Vector.<uint>>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = new TConditionStyleC(_loc7_[_loc2_]);
            this.FPage3[_loc2_] = _loc11_;
            _loc5_ = int(_loc11_.Value.length);
            _loc12_ = new Vector.<uint>(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc12_[_loc4_] = _loc11_.Value[_loc4_].Awards[0];
               this.FPage3AwardsVect[_loc2_] = _loc12_;
               _loc4_++;
            }
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = new Array(Json.decode(_loc6_));
         _loc3_ = int(_loc7_[0].length);
         this.FPage3PromptVect = new Vector.<Vector.<String>>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = int(_loc7_[0][_loc2_].length);
            _loc9_ = new Vector.<String>(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_[_loc4_] = _loc7_[0][_loc2_][_loc4_];
               _loc4_++;
            }
            this.FPage3PromptVect[_loc2_] = _loc9_;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = new Array(Json.decode(_loc6_));
         _loc3_ = int(_loc7_[0].length);
         this.FEnterNames = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FEnterNames[_loc2_] = _loc7_[0][_loc2_];
            _loc2_++;
         }
      }
      
      public function get Page1() : Vector.<TConditionStyleB>
      {
         return this.FPage1;
      }
      
      public function get Page2() : Vector.<TConditionStyleB>
      {
         return this.FPage2;
      }
      
      public function get Page3() : Vector.<TConditionStyleC>
      {
         return this.FPage3;
      }
      
      public function get EnterNames() : Vector.<String>
      {
         return this.FEnterNames;
      }
      
      public function get Page1Awards() : Vector.<uint>
      {
         return this.FPage1Awards;
      }
      
      public function get Page2Awards() : Vector.<uint>
      {
         return this.FPage2Awards;
      }
      
      public function get Page3AwardsVect() : Vector.<Vector.<uint>>
      {
         return this.FPage3AwardsVect;
      }
      
      public function get Page3PromptVect() : Vector.<Vector.<String>>
      {
         return this.FPage3PromptVect;
      }
   }
}

