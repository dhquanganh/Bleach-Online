package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TJoyfunPay extends TDatebaseVO
   {
      
      protected var FDollars:Vector.<int>;
      
      protected var FCosts:Vector.<int>;
      
      protected var FAwards:Vector.<int>;
      
      protected var FFlag:int;
      
      protected var FRate:int;
      
      public function TJoyfunPay()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         this.FDollars = new Vector.<int>();
         this.FCosts = new Vector.<int>();
         this.FAwards = new Vector.<int>();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc5_);
         _loc4_ = int(_loc2_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FDollars.push(_loc2_[_loc3_].dollar);
            this.FCosts.push(_loc2_[_loc3_].cost);
            this.FAwards.push(_loc2_[_loc3_].award);
            _loc3_++;
         }
         this.FFlag = param1.readInt();
         this.FRate = param1.readInt();
      }
      
      public function get Dollars() : Vector.<int>
      {
         return this.FDollars;
      }
      
      public function get Costs() : Vector.<int>
      {
         return this.FCosts;
      }
      
      public function get Awards() : Vector.<int>
      {
         return this.FAwards;
      }
      
      public function get Flag() : int
      {
         return this.FFlag;
      }
      
      public function get Rate() : int
      {
         return this.FRate;
      }
   }
}

