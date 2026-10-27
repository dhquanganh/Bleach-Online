package Logics.CustomHero
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TCustomHeroInfo extends TDatebaseVO
   {
      
      protected var FGrowth:Vector.<Number>;
      
      protected var FBasicNumber:Vector.<uint>;
      
      protected var FBasisGrow:Vector.<uint>;
      
      protected var FExclusiveSkill:Vector.<uint>;
      
      protected var FGrowthLimit:Vector.<uint>;
      
      protected var FExclusiveLimit:Vector.<uint>;
      
      public function TCustomHeroInfo()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FGrowth = new Vector.<Number>();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FGrowth[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FBasicNumber = new Vector.<uint>();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FBasicNumber[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FBasisGrow = new Vector.<uint>();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FBasisGrow[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FExclusiveSkill = new Vector.<uint>();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FExclusiveSkill[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FGrowthLimit = new Vector.<uint>();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FGrowthLimit[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FExclusiveLimit = new Vector.<uint>();
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FExclusiveLimit[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
      }
      
      public function get Growth() : Vector.<Number>
      {
         return this.FGrowth;
      }
      
      public function get BasisGrow() : Vector.<uint>
      {
         return this.FBasisGrow;
      }
      
      public function get ExclusiveSkill() : Vector.<uint>
      {
         return this.FExclusiveSkill;
      }
      
      public function get BasicNumber() : Vector.<uint>
      {
         return this.FBasicNumber;
      }
      
      public function get GrowthLimit() : Vector.<uint>
      {
         return this.FGrowthLimit;
      }
      
      public function get ExclusiveLimit() : Vector.<uint>
      {
         return this.FExclusiveLimit;
      }
   }
}

