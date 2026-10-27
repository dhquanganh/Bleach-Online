package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDGBOpenServer extends THDActivityBase
   {
      
      protected var FActAward:uint;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      public function THDGBOpenServer()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FActAward = param1.readUnsignedInt();
         _loc3_ = 1;
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardValueVect[_loc2_] = this.FActAward;
            _loc2_++;
         }
      }
      
      public function get AwardValueVect() : Vector.<uint>
      {
         return this.FAwardValueVect;
      }
   }
}

