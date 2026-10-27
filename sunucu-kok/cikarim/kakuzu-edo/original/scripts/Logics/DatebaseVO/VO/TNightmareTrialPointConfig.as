package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TNightmareTrialPointConfig extends TDatebaseVO
   {
      
      private var FNameDesc:String;
      
      private var FArmyVec:Vector.<int>;
      
      private var FRoleModel:uint;
      
      private var FBattleSceneId:int;
      
      private var FCondition:Vector.<int>;
      
      private var FHelpHeroId:int;
      
      private var FHelpHeroPos:int;
      
      private var FCoordinate:Object;
      
      private var FToTarget:Array;
      
      public function TNightmareTrialPointConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         this.FNameDesc = TUtilityString.FetchUTF(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc4_);
         this.FArmyVec = Vector.<int>(_loc2_.army);
         this.FBattleSceneId = param1.readUnsignedInt();
         this.FRoleModel = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc4_);
         this.FCondition = Vector.<int>(_loc3_);
         this.FHelpHeroId = param1.readUnsignedInt();
         this.FHelpHeroPos = param1.readUnsignedInt();
         this.FCoordinate = Json.decode(TUtilityString.FetchUTF(param1));
         this.FToTarget = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get NameDesc() : String
      {
         return this.FNameDesc;
      }
      
      public function get ArmyVec() : Vector.<int>
      {
         return this.FArmyVec;
      }
      
      public function get Condition() : Vector.<int>
      {
         return this.FCondition;
      }
      
      public function get BattleSceneId() : int
      {
         return this.FBattleSceneId;
      }
      
      public function get HelpHeroId() : int
      {
         return this.FHelpHeroId;
      }
      
      public function get HelpHeroPos() : int
      {
         return this.FHelpHeroPos;
      }
      
      public function get RoleModel() : int
      {
         return this.FRoleModel;
      }
      
      public function get Coordinate() : Object
      {
         return this.FCoordinate;
      }
      
      public function get ToTarget() : Array
      {
         return this.FToTarget;
      }
   }
}

