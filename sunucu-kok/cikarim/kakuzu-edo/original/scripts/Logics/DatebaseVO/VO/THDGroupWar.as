package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDGroupWar extends THDActivityBase
   {
      
      protected var FAwards:Vector.<uint>;
      
      public function THDGroupWar()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_) as Array;
         _loc5_ = int(_loc3_.length);
         this.FAwards = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FAwards[_loc4_] = _loc3_[0];
            _loc4_++;
         }
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
   }
}

