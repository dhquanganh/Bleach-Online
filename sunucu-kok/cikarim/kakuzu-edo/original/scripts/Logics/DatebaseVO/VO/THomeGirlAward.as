package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THomeGirlAward extends TDatebaseVO
   {
      
      protected var FTitleLevel:int;
      
      protected var FInteractiveType:int;
      
      protected var FInteractiveCost:TFixedAward;
      
      protected var FInteractiveGetScore:int;
      
      protected var FInteractiveAward:TFixedAward;
      
      public function THomeGirlAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.FTitleLevel = param1.readInt();
         this.FInteractiveType = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FInteractiveCost = new TFixedAward(_loc3_[0]);
         this.FInteractiveGetScore = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FInteractiveAward = new TFixedAward(_loc3_[0]);
      }
      
      public function get TitleLevel() : int
      {
         return this.FTitleLevel;
      }
      
      public function get InteractiveType() : int
      {
         return this.FInteractiveType;
      }
      
      public function get InteractiveCost() : TFixedAward
      {
         return this.FInteractiveCost;
      }
      
      public function get InteractiveGetScore() : int
      {
         return this.FInteractiveGetScore;
      }
      
      public function get InteractiveAward() : TFixedAward
      {
         return this.FInteractiveAward;
      }
   }
}

