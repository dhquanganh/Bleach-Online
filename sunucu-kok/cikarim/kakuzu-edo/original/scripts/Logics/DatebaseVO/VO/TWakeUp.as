package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventoryWake;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TWakeUp extends TDatebaseVO
   {
      
      protected var FIndexWakeUps:Vector.<Vector.<int>>;
      
      public function TWakeUp()
      {
         super();
         this.FIndexWakeUps = new Vector.<Vector.<int>>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:TInventories = null;
         var _loc10_:TInventoryWake = null;
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc2_);
         _loc3_ = _loc8_ as Array;
         _loc7_ = int(_loc3_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc7_)
         {
            _loc4_ = _loc3_[_loc5_];
            this.FIndexWakeUps[_loc5_] = new Vector.<int>();
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               this.FIndexWakeUps[_loc5_].push(_loc4_[_loc6_]);
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public function get WakeLevelCount() : int
      {
         return this.FIndexWakeUps.length;
      }
      
      public function GetIndexsByWakeLevel(param1:int) : Vector.<int>
      {
         if(this.FIndexWakeUps.length > 0)
         {
            return this.FIndexWakeUps[param1];
         }
         return null;
      }
   }
}

