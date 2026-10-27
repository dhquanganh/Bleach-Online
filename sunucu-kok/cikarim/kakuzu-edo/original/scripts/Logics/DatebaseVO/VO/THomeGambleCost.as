package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THomeGambleCost extends TDatebaseVO
   {
      
      protected var FCostSilver:int;
      
      protected var FCostGold:int;
      
      protected var FWinSilver:String;
      
      protected var FWinGold:String;
      
      protected var FWinSilverVect:Vector.<Object>;
      
      protected var FWinGoldVect:Vector.<Object>;
      
      public function THomeGambleCost()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.FCostSilver = param1.readInt();
         this.FCostGold = param1.readInt();
         this.FWinSilver = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FWinSilver) as Array;
         this.FWinSilverVect = new Vector.<Object>();
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FWinSilverVect.push(_loc5_[_loc2_]);
            _loc2_++;
         }
         this.FWinGold = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FWinGold) as Array;
         this.FWinGoldVect = new Vector.<Object>();
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FWinGoldVect.push(_loc5_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get CostSilver() : int
      {
         return this.FCostSilver;
      }
      
      public function get CostGold() : int
      {
         return this.FCostGold;
      }
      
      public function get WinSilver() : String
      {
         return this.FWinSilver;
      }
      
      public function get WinGold() : String
      {
         return this.FWinGold;
      }
      
      public function get WinSilverVect() : Vector.<Object>
      {
         return this.FWinSilverVect;
      }
      
      public function get WinGoldVect() : Vector.<Object>
      {
         return this.FWinGoldVect;
      }
   }
}

