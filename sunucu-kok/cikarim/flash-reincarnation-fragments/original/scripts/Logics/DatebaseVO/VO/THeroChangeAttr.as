package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THeroChangeAttr extends TDatebaseVO
   {
      
      protected var FTabIndex:int;
      
      protected var FHeroStar:Vector.<int>;
      
      protected var FChipID:int;
      
      protected var FRebornGold:Vector.<int>;
      
      protected var FResetGold:Vector.<int>;
      
      protected var FStartTime:Vector.<int>;
      
      protected var FEndTime:Vector.<int>;
      
      protected var FIsOpen:Boolean;
      
      protected var FCityID:int;
      
      protected var FChipValue:int;
      
      public function THeroChangeAttr()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FTabIndex = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FHeroStar = Vector.<int>(Json.decode(_loc2_));
         this.FChipID = param1.readInt();
         this.FChipValue = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FRebornGold = Vector.<int>(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FResetGold = Vector.<int>(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FStartTime = Vector.<int>(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FEndTime = Vector.<int>(Json.decode(_loc2_));
         this.FIsOpen = param1.readInt() == 1;
         this.FCityID = param1.readInt();
      }
      
      public function get TabIndex() : int
      {
         return this.FTabIndex;
      }
      
      public function get HeroStar() : Vector.<int>
      {
         return this.FHeroStar;
      }
      
      public function get ChipID() : int
      {
         return this.FChipID;
      }
      
      public function get RebornGold() : Vector.<int>
      {
         return this.FRebornGold;
      }
      
      public function get ResetGold() : Vector.<int>
      {
         return this.FResetGold;
      }
      
      public function get StartTime() : Vector.<int>
      {
         return this.FStartTime;
      }
      
      public function get EndTime() : Vector.<int>
      {
         return this.FEndTime;
      }
      
      public function get IsOpen() : Boolean
      {
         return this.FIsOpen;
      }
      
      public function get CityID() : int
      {
         return this.FCityID;
      }
      
      public function get ChipValue() : int
      {
         return this.FChipValue;
      }
   }
}

