package Logics.Streamization.Characters
{
   import Foundation.Resources.*;
   import Foundation.Streamization.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.MoveRole.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerRoleCanControlTwo extends TUnstreamizer
   {
      
      public function TUnstreamizerRoleCanControlTwo()
      {
         super();
      }
      
      public static function CreatePet(param1:uint, param2:TSceneSpriteMoudleInMapCanRunPlayer) : TSceneSpriteMoudleInMapCanRunPlayer
      {
         var _loc3_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc3_ = SLogicsCore.PoolMap.AcquirePlayer();
         _loc3_.MapParameter = param2.MapParameter;
         _loc3_.MouseEventHander = null;
         _loc3_.Name = GetPetNameByPetID(param1,param2.Name);
         _loc3_.UpdateHeadDecoration();
         _loc3_.MapCoordinate.Assign(param2.MapCoordinate);
         _loc3_.RoleTempleteID = param1;
         _loc3_.SetFollower(param2,CONST_MAP.FOLLOW_TYPE_CIRCLE);
         return _loc3_;
      }
      
      public static function CreateKnifeOfKillSoul(param1:uint, param2:TSceneSpriteMoudleInMapCanRunPlayer) : TSceneSpriteMoudleInMapCanRunPlayer
      {
         var _loc3_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc3_ = SLogicsCore.PoolMap.AcquirePlayer();
         _loc3_.MapParameter = param2.MapParameter;
         _loc3_.MouseEventHander = null;
         _loc3_.Name = GetKnifeNameByTextureID(param1,param2.Name);
         _loc3_.UpdateHeadDecoration();
         _loc3_.MapCoordinate.Assign(param2.MapCoordinate);
         _loc3_.MapCoordinate.Y -= 30;
         _loc3_.RoleTempleteID = param1;
         _loc3_.SetFollower(param2,CONST_MAP.FOLLOW_TYPE_NORMAL);
         return _loc3_;
      }
      
      protected static function GetTextureIDByKnifeID(param1:uint) : int
      {
         var _loc2_:TKnife = null;
         var _loc3_:TKnifeExpand = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1) as TKnifeExpand;
         return _loc3_.RelationID;
      }
      
      protected static function GetKnifeNameByTextureID(param1:uint, param2:String) : String
      {
         var _loc3_:TKnife = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,param1) as TKnife;
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_1),param2,_loc3_.Name);
      }
      
      protected static function GetPetNameByPetID(param1:uint, param2:String) : String
      {
         return "";
      }
      
      protected static function GetKnifeNameByKnifeID(param1:uint, param2:String) : String
      {
         var _loc3_:TKnife = null;
         var _loc4_:TKnifeExpand = null;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1) as TKnifeExpand;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc4_.RelationID) as TKnife;
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_1),param2,_loc3_.Name);
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:Vector.<TSceneSpriteMoudleInMapCanRunPlayer> = null;
         var _loc5_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:TKnife = null;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:TPetLevelUp = null;
         var _loc15_:Boolean = false;
         _loc4_ = param2 as Vector.<TSceneSpriteMoudleInMapCanRunPlayer>;
         _loc8_ = int(param1.readUnsignedShort());
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc5_ = SLogicsCore.PoolMap.AcquirePlayer();
            _loc5_.UserIDHigh = param1.readUnsignedInt();
            _loc5_.UserIDLow = param1.readUnsignedInt();
            _loc5_.RoleTempleteID = param1.readUnsignedInt();
            _loc5_.Name = TUtilityString.FetchUTF(param1);
            _loc5_.MilitaryRank = param1.readUnsignedInt();
            _loc5_.Level = param1.readUnsignedInt();
            _loc5_.FamilyID = param1.readUnsignedInt();
            _loc6_ = param1.readByte() != 0;
            _loc7_ = param1.readUnsignedInt();
            _loc6_ = _loc7_ != 0;
            if(_loc6_)
            {
               _loc7_ = uint(GetTextureIDByKnifeID(_loc7_));
            }
            if(_loc6_)
            {
               _loc5_.KnifeOfKillSoul = CreateKnifeOfKillSoul(_loc7_,_loc5_);
               _loc4_.push(_loc5_.KnifeOfKillSoul);
            }
            _loc5_.BirthID = param1.readUnsignedInt();
            _loc5_.Quality = param1.readByte();
            _loc5_.ReplaceID = param1.readUnsignedInt();
            _loc5_.IFYearYellowDiamondUser = param1.readUnsignedByte() != 0;
            _loc5_.YellowDiamondLevel = param1.readUnsignedByte();
            _loc13_ = param1.readInt();
            if(_loc13_ != 0)
            {
               _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc13_) as TPetLevelUp;
               _loc5_.Pet = CreatePet(_loc14_.PetResourceID,_loc5_);
               _loc4_.push(_loc5_.Pet);
            }
            var titleCount:int=int(param1.readUnsignedShort());
            var titleIndex:int=0;
            while(titleIndex<titleCount){
               _loc12_=param1.readUnsignedInt();
               if(_loc12_!=0)_loc5_.TitlesID.push(_loc12_);
               titleIndex++;
            }
            _loc15_ = Boolean(param1.readInt());
            _loc5_.OpenBleachAgent = _loc15_;
            _loc5_.RebirthNum = param1.readByte();
            _loc4_.push(_loc5_);
            _loc9_++;
         }
      }
   }
}

