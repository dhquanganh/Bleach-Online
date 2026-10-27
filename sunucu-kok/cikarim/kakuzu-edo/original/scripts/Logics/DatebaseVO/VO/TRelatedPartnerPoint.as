package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TRelatedPartnerPoint extends TDatebaseVO
   {
      
      protected const Star_Num:int = 3;
      
      protected var FName:String;
      
      protected var FIsBoss:Boolean;
      
      protected var FBattleScene:int;
      
      protected var FArmy:Vector.<int>;
      
      protected var FStars:Vector.<Vector.<int>>;
      
      public function TRelatedPartnerPoint()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FIsBoss = param1.readUnsignedInt() == 1;
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc3_);
         this.FArmy = Vector.<int>(_loc4_.army);
         this.FBattleScene = param1.readUnsignedInt();
         this.FStars = new Vector.<Vector.<int>>(this.Star_Num);
         _loc2_ = 0;
         while(_loc2_ < this.Star_Num)
         {
            _loc3_ = TUtilityString.FetchUTF(param1);
            _loc5_ = Json.decode(_loc3_);
            this.FStars[_loc2_] = Vector.<int>(_loc5_);
            _loc2_++;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get IsBoss() : Boolean
      {
         return this.FIsBoss;
      }
      
      public function get BattleScene() : int
      {
         return this.FBattleScene;
      }
      
      public function get Army() : Vector.<int>
      {
         return this.FArmy;
      }
      
      public function GetStarConditionsByIndex(param1:int) : Vector.<int>
      {
         return this.FStars[param1];
      }
   }
}

