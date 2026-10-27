package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TGSPVPDailyAward extends TDatebaseVO
   {
      
      protected var FQuality:int;
      
      protected var FType:int;
      
      protected var FCostType:int;
      
      protected var FCost:int;
      
      protected var FAwards:TRewards;
      
      public function TGSPVPDailyAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FQuality = param1.readInt();
         this.FType = param1.readInt();
         this.FCostType = param1.readInt();
         this.FCost = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FAwards = new TRewards(_loc2_);
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get CostType() : int
      {
         return this.FCostType;
      }
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function get Awards() : TRewards
      {
         return this.FAwards;
      }
   }
}

