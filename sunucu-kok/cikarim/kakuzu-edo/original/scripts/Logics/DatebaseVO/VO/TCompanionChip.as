package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Processors.Game.Common.Effects.ListAutoScroll.IListAutoScrollDataRender;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TCompanionChip extends TDatebaseVO implements IListAutoScrollDataRender
   {
      
      protected var FName:String;
      
      protected var FPicture:int;
      
      protected var FNeedCounts:Vector.<int>;
      
      protected var FExchangeIds:Vector.<int>;
      
      public function TCompanionChip()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FPicture = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_) as Array;
         this.FNeedCounts = Vector.<int>(_loc4_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_) as Array;
         this.FExchangeIds = Vector.<int>(_loc4_);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Picture() : int
      {
         return this.FPicture;
      }
      
      public function get NeedCounts() : Vector.<int>
      {
         return this.FNeedCounts;
      }
      
      public function get ExchangeIds() : Vector.<int>
      {
         return this.FExchangeIds;
      }
   }
}

