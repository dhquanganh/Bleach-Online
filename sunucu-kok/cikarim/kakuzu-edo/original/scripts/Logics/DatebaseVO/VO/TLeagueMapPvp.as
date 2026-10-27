package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TLeagueMapPvp extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FDesc:String;
      
      protected var FSortIndex:uint;
      
      protected var FOpenLevel:uint;
      
      protected var FMapID:uint;
      
      protected var FImageID:uint;
      
      protected var FAwards:Vector.<uint>;
      
      public function TLeagueMapPvp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FSortIndex = param1.readInt();
         this.FOpenLevel = param1.readInt();
         this.FMapID = param1.readUnsignedInt();
         this.FImageID = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FAwards = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwards[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get SortIndex() : uint
      {
         return this.FSortIndex;
      }
      
      public function get OpenLevel() : uint
      {
         return this.FOpenLevel;
      }
      
      public function get MapID() : uint
      {
         return this.FMapID;
      }
      
      public function get ImageID() : uint
      {
         return this.FImageID;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
   }
}

