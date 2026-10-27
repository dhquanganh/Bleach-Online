package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TLeaguePointPath extends TDatebaseVO
   {
      
      protected var FArmyID:Vector.<uint>;
      
      protected var FMapID:uint;
      
      public function TLeaguePointPath()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.army.length);
         this.FArmyID = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FArmyID[_loc2_] = _loc5_.army[_loc2_];
            _loc2_++;
         }
         this.FMapID = param1.readUnsignedInt();
      }
      
      public function get ArmyID() : Vector.<uint>
      {
         return this.FArmyID;
      }
      
      public function get MapID() : uint
      {
         return this.FMapID;
      }
   }
}

