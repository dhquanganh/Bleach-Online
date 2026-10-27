package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TTempleValue extends TDatebaseVO
   {
      
      protected var FLevelCoefficient:Number;
      
      protected var FTypeCoefficient:Number;
      
      protected var FFlushSpiritConsume:int;
      
      protected var FFlushSpiritSuccessrate:int;
      
      protected var FFlushSpiritStone:Vector.<int>;
      
      protected var FProtectedStone:int;
      
      public function TTempleValue()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         this.FLevelCoefficient = param1.readFloat();
         this.FTypeCoefficient = param1.readFloat();
         this.FFlushSpiritConsume = param1.readInt();
         this.FFlushSpiritSuccessrate = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FFlushSpiritStone = Vector.<int>(_loc3_);
         this.FProtectedStone = param1.readInt();
      }
      
      public function get LevelCoefficient() : Number
      {
         return this.FLevelCoefficient;
      }
      
      public function get TypeCoefficient() : Number
      {
         return this.FTypeCoefficient;
      }
      
      public function get ProtectedStone() : int
      {
         return this.FProtectedStone;
      }
      
      public function get FlushSpiritConsume() : int
      {
         return this.FFlushSpiritConsume;
      }
      
      public function get FlushSpiritSuccessrate() : int
      {
         return this.FFlushSpiritSuccessrate;
      }
      
      public function get FlushSpiritStone() : Vector.<int>
      {
         return this.FFlushSpiritStone;
      }
   }
}

