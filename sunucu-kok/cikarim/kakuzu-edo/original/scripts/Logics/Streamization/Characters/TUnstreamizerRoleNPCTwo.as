package Logics.Streamization.Characters
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerRoleNPCTwo extends TUnstreamizer
   {
      
      protected var FBins:TBins;
      
      public function TUnstreamizerRoleNPCTwo()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Digests(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Digests(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Database(param2,param3);
      }
      
      protected function UnstreamizationPerform_Database(param1:Object, param2:Object) : void
      {
         var _loc3_:Vector.<TSceneSpriteMoudleInMapNpc> = null;
         var _loc4_:TCoordinate = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TSceneSpriteMoudleInMapNpc = null;
         var _loc8_:TBins = null;
         var _loc9_:TNPC = null;
         _loc3_ = param1 as Vector.<TSceneSpriteMoudleInMapNpc>;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_NPC) as TBins;
         _loc5_ = _loc8_.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = _loc8_.GetDatebaseByIndex(_loc6_) as TNPC;
            _loc7_ = new TSceneSpriteMoudleInMapNpc();
            _loc7_.RoleTempleteID = _loc9_.Identifier;
            this.SetDetails(_loc7_);
            _loc3_.push(_loc7_);
            _loc6_++;
         }
      }
      
      protected function SetDetails(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         var _loc2_:TRoleModel = null;
         var _loc3_:TNPC = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_NPC,param1.RoleTempleteID) as TNPC;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1.RoleTempleteID) as TRoleModel;
         param1.Name = _loc3_.Name;
         param1.NpcCityID = _loc3_.Cityid;
         param1.UserType = _loc3_.UserType;
         param1.NpcQuestMin = _loc3_.StartTime;
         param1.NpcQuestMax = _loc3_.EndTime;
         param1.MapCoordinate.X = _loc3_.X;
         param1.MapCoordinate.Y = _loc3_.Y;
         param1.NormalTalkText = _loc3_.Talk;
         param1.TalkCoordinate.X = _loc3_.TalkX;
         param1.TalkCoordinate.Y = _loc3_.TalkY;
         param1.NpcStartTextureID = _loc2_.Model;
         param1.NpcStyleTextureID = _loc2_.RoleStyle;
         param1.NpcFunctionOpenConditionType = _loc3_.NpcFunctionOpenType;
         param1.NpcFunctionOpenCondition = _loc3_.NpcFunctionOpenCondition;
         param1.NpcFunctionCloseCondition = _loc3_.NpcFunctionCloseCondition;
      }
   }
}

