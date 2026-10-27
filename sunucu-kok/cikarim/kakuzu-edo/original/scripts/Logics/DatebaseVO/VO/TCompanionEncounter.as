package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TArticalItem;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TCompanionEncounter extends TDatebaseVO
   {
      
      protected var FEncounterCards:Vector.<int>;
      
      protected var FAward:TArticalItem;
      
      protected var FStartTime:Vector.<int>;
      
      protected var FEndTime:Vector.<int>;
      
      public function TCompanionEncounter()
      {
         super();
         this.FEncounterCards = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc5_) as Array;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            this.FEncounterCards.push(_loc2_[_loc4_]);
            _loc4_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc5_);
         this.FAward = new TArticalItem(_loc3_);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc5_) as Array;
         this.FStartTime = Vector.<int>(_loc2_);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc5_) as Array;
         this.FEndTime = Vector.<int>(_loc2_);
      }
      
      public function get EncounterCards() : Vector.<int>
      {
         return this.FEncounterCards;
      }
      
      public function get Award() : TArticalItem
      {
         return this.FAward;
      }
      
      public function get StartTime() : Vector.<int>
      {
         return this.FStartTime;
      }
      
      public function get EndTime() : Vector.<int>
      {
         return this.FEndTime;
      }
   }
}

