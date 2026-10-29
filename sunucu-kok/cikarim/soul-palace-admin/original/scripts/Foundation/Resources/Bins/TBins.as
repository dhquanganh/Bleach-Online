package Foundation.Resources.Bins
{
   import Foundation.Resources.Common.*;
   import Foundation.Resources.Spaces.*;
   import Logics.DatebaseVO.*;
   
   use namespace ResourcesSpace;
   
   public class TBins extends TResource
   {
      
      protected var FIdentifiers:Vector.<uint>;
      
      protected var FValues:Vector.<TDatebaseVO>;
      
      public function TBins(param1:uint)
      {
         super(param1);
         this.FIdentifiers = new Vector.<uint>();
         this.FValues = new Vector.<TDatebaseVO>();
      }
      
      ResourcesSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      ResourcesSpace function DatebaseAppend(param1:uint, param2:TDatebaseVO) : void
      {
         this.FIdentifiers.push(param1);
         this.FValues.push(param2);
      }
      
      public function get Count() : int
      {
         return this.FIdentifiers.length;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TDatebaseVO = null;
         _loc1_ = int(this.FValues.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FValues[_loc2_];
            _loc3_.Clear();
            _loc2_++;
         }
         this.FIdentifiers.length = 0;
         this.FValues.length = 0;
      }
      
      public function GetDatebaseByIndex(param1:int) : TDatebaseVO
      {
         return this.FValues[param1];
      }
      
      public function GetDatebaseByIdentifier(param1:uint) : TDatebaseVO
      {
         var _loc2_:int = 0;
         var _loc3_:TDatebaseVO = null;
         _loc3_ = null;
         _loc2_ = this.FIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            _loc3_ = this.FValues[_loc2_];
         }
         return _loc3_;
      }
   }
}

