package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TChangeHeroPoint extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FIsBoss:Boolean;
      
      protected var FOpenLevel:int;
      
      protected var FBattleScene:int;
      
      protected var FArmy:Vector.<int>;
      
      protected var FShowRateAward:Vector.<uint>;
      
      public function TChangeHeroPoint()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FIsBoss = param1.readInt() == 1;
         this.FOpenLevel = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FArmy = Vector.<int>(_loc3_.army);
         this.FBattleScene = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FShowRateAward = Vector.<uint>(_loc3_);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get IsBoss() : Boolean
      {
         return this.FIsBoss;
      }
      
      public function get OpenLevel() : int
      {
         return this.FOpenLevel;
      }
      
      public function get BattleScene() : int
      {
         return this.FBattleScene;
      }
      
      public function get Army() : Vector.<int>
      {
         return this.FArmy;
      }
      
      public function get ShowRateAward() : Vector.<uint>
      {
         return this.FShowRateAward;
      }
   }
}

