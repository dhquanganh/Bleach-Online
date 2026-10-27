package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDGBOnline extends THDActivityBase
   {
      
      protected var FActAward:String;
      
      protected var FActAwardVect:Vector.<Object>;
      
      protected var FAwardKeyVect:Vector.<uint>;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      public function THDGBOnline()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FActAward = TUtilityString.FetchUTF(param1);
         this.FActAwardVect = Vector.<Object>(Json.decode(this.FActAward));
         _loc3_ = int(this.FActAwardVect.length);
         this.FAwardKeyVect = new Vector.<uint>(_loc3_);
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardKeyVect[_loc2_] = this.FActAwardVect[_loc2_].key;
            this.FAwardValueVect[_loc2_] = this.FActAwardVect[_loc2_].value[0];
            _loc2_++;
         }
      }
      
      public function get ActAwardVect() : Vector.<Object>
      {
         return this.FActAwardVect;
      }
      
      public function get AwardKeyVect() : Vector.<uint>
      {
         return this.FAwardKeyVect;
      }
      
      public function get AwardValueVect() : Vector.<uint>
      {
         return this.FAwardValueVect;
      }
   }
}

