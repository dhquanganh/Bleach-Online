package Logics.Streamization.SkyTower
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SkyTower.*;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   import Resources.Constants.*;
   import flash.utils.*;
   
   use namespace LobbySpace;
   
   public class TUnstreamizerSkyTower extends TUnstreamizer
   {
      
      public function TUnstreamizerSkyTower()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:TSkyTower = null;
         var _loc13_:TTowers = null;
         var _loc14_:TTower = null;
         var _loc15_:TLayers = null;
         var _loc16_:TLayer = null;
         var _loc17_:TPvpDiarys = null;
         var _loc18_:TConfigValue = null;
         var _loc19_:TBins = null;
         var _loc20_:Vector.<uint> = null;
         _loc12_ = param2 as TSkyTower;
         _loc13_ = _loc12_.Towers;
         _loc19_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc18_ = _loc19_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SkyTower_PveEverydayNumber) as TConfigValue;
         _loc12_.PveMax = uint(_loc18_.Value);
         _loc12_.PVECount = param1.readUnsignedByte();
         _loc18_ = _loc19_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SkyTower_PvpEverydayNumber) as TConfigValue;
         _loc12_.PvpMax = uint(_loc18_.Value);
         _loc12_.PVPCount = param1.readUnsignedByte();
         _loc18_ = _loc19_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SkyTower_BuyPvePrice) as TConfigValue;
         _loc20_ = _loc18_.Value as Vector.<uint>;
         _loc12_.PVEBuyMax = _loc20_.length;
         _loc12_.PVEBuyCount = param1.readUnsignedByte();
         _loc18_ = _loc19_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SkyTower_BuyPvpPrice) as TConfigValue;
         _loc20_ = _loc18_.Value as Vector.<uint>;
         _loc12_.PVPBuyMax = _loc20_.length;
         _loc12_.PVPBuyCount = param1.readUnsignedByte();
         _loc12_.IsAKeyPve = !param1.readBoolean();
         _loc18_ = _loc19_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SkyTower_FightAgainPrice) as TConfigValue;
         _loc12_.AKeyPvePrice = uint(_loc18_.Value);
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc11_ = param1.readUnsignedByte();
            _loc14_ = _loc13_.GetTowerByIdentifier(_loc10_);
            if(_loc4_ == 0)
            {
               _loc12_.LockedTowerID = _loc10_;
               _loc8_ = 0;
               while(_loc8_ < _loc11_)
               {
                  if(_loc8_ >= _loc14_.Layers.Count)
                  {
                     break;
                  }
                  _loc16_ = _loc14_.Layers.GetLayerByIndex(_loc8_);
                  _loc16_.IsClear = true;
                  _loc8_++;
               }
            }
            else
            {
               _loc14_.Layers.MaxLayer = _loc11_;
            }
            _loc4_++;
         }
         this.UnstreamizationPerform_SkyTowerPvplayers(param1,_loc13_,param3);
         _loc17_ = _loc12_.PvpDiarys;
         _loc17_.Clear();
         this.UnstreamizationPerform_SkyTowerPvpDiarys(param1,_loc17_,param3);
         this.ApplyPalaceCatalog(param1,_loc12_);
      }
      
      protected function UnstreamizationPerform_SkyTowerPvpDiarys(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPvpDiary = null;
         var _loc7_:TPvpDiarys = null;
         _loc7_ = param2 as TPvpDiarys;
         _loc7_.SortPvpDiarys();
         _loc5_ = int(param1.readUnsignedShort());
         if(CONST_SKYTOWER.MAX_PvpDiary - _loc7_.Count < _loc5_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_ - (CONST_SKYTOWER.MAX_PvpDiary - _loc7_.Count))
            {
               _loc7_.DeleteByIndex(0);
               _loc4_++;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TPvpDiary();
            _loc6_.Time = param1.readUnsignedInt();
            _loc6_.IsInitiativeFight = param1.readBoolean();
            _loc6_.IsWin = param1.readBoolean();
            _loc6_.Nickname = TUtilityString.FetchUTF(param1);
            _loc6_.BattleReportID = TUtilityString.FetchUTF(param1);
            _loc7_.Add(_loc6_);
            _loc4_++;
         }
         _loc7_.SortPvpDiarys();
      }
      
      protected function UnstreamizationPerform_SkyTowerPvplayers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TTowers = null;
         var _loc11_:TTower = null;
         var _loc12_:TLayers = null;
         var _loc13_:TLayer = null;
         var _loc14_:uint = 0;
         var _loc15_:Boolean = false;
         _loc10_ = param2 as TTowers;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc15_ = false;
            _loc14_ = param1.readUnsignedInt();
            _loc7_ = _loc10_.Count;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc11_ = _loc10_.GetTowerByIndex(_loc6_);
               _loc12_ = _loc11_.Layers;
               _loc9_ = _loc12_.Count;
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  _loc13_ = _loc12_.GetLayerByIndex(_loc8_);
                  if(_loc14_ == _loc13_.PvpID)
                  {
                     this.UnstreamizationPerform_SkyTowerPvplayer(param1,_loc13_,null);
                     _loc15_ = true;
                     break;
                  }
                  _loc8_++;
               }
               if(_loc15_)
               {
                  break;
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_SkyTowerPvplayer(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TLayer = null;
         _loc4_ = param2 as TLayer;
         _loc4_.PvpRoleHighID = param1.readUnsignedInt();
         _loc4_.PvpRoleLowID = param1.readUnsignedInt();
         _loc4_.PvpRoleTempleteID = param1.readUnsignedInt();
         _loc4_.PvpLevel = param1.readUnsignedShort();
         _loc4_.PvpNickname = TUtilityString.FetchUTF(param1);
         _loc4_.PvpTimer = param1.readUnsignedInt();
      }
      
      protected function UnstreamizationPerform_SkyTowers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TCharacter = null;
         var _loc10_:TSkyTower = null;
         var _loc11_:TTowers = null;
         var _loc12_:TTower = null;
         var _loc13_:TLayers = null;
         var _loc14_:TLayer = null;
         var _loc15_:TCity = null;
         var _loc16_:TBins = null;
         var _loc17_:TBins = null;
         var _loc18_:TEnemyArmy = null;
         var _loc19_:TBins = null;
         var _loc20_:TEnemy = null;
         var _loc21_:TBins = null;
         var _loc22_:TTemplePoint = null;
         _loc10_ = param2 as TSkyTower;
         _loc9_ = param3 as TCharacter;
         _loc11_ = _loc10_.Towers;
         _loc11_.Clear();
         _loc8_ = int(_loc9_.GetMainLevel());
         _loc16_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         _loc19_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         _loc17_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         _loc21_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TemplePoint);
         _loc5_ = int(CONST_SKYTOWER.CAPACITY_TOWERS);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc15_ = _loc16_.GetDatebaseByIdentifier(CONST_SKYTOWER.TOWER_STARTID + _loc4_) as TCity;
            _loc12_ = new TTower(_loc15_.Identifier);
            _loc12_.Name = _loc15_.Name;
            _loc12_.OpenLevel = _loc15_.OpenLevel;
            _loc12_.Tag = _loc4_ + 1;
            _loc12_.IsUnlock = Boolean(_loc8_ >= _loc15_.OpenLevel);
            _loc13_ = _loc12_.Layers;
            _loc7_ = _loc15_.Start + (_loc15_.Last - _loc15_.Start + 1);
            _loc6_ = _loc15_.Start;
            while(_loc6_ < _loc7_)
            {
               _loc14_ = new TLayer(_loc6_);
               _loc22_ = _loc21_.GetDatebaseByIdentifier(_loc6_) as TTemplePoint;
               _loc18_ = _loc17_.GetDatebaseByIdentifier(_loc22_.ArmyID[0]) as TEnemyArmy;
               _loc20_ = _loc19_.GetDatebaseByIdentifier(_loc18_.LeaderID) as TEnemy;
               _loc14_.LayerName = _loc22_.Name;
               _loc14_.AkeyPrice = _loc22_.AkeyPrice;
               _loc14_.PveRoleTempleteID = _loc18_.LeaderID;
               _loc14_.PveLevel = _loc20_.Level;
               _loc14_.PveNickname = _loc18_.Name;
               this.SetLayerPvpAwardInfo(_loc14_);
               _loc13_.Add(_loc14_);
               _loc6_++;
            }
            _loc13_.SortLayers();
            _loc11_.Add(_loc12_);
            _loc4_++;
         }
         _loc11_.SortTowers();
      }
      
      protected function SetLayerPvpAwardInfo(param1:TLayer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTemplePVP = null;
         var _loc5_:TBins = null;
         var _loc6_:TAward = null;
         var _loc7_:TBins = null;
         var _loc8_:TArticle = null;
         var _loc9_:TBins = null;
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TemplePVP);
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetDatebaseByIndex(_loc2_) as TTemplePVP;
            if(_loc4_.LayerID == param1.Identifier)
            {
               _loc6_ = _loc7_.GetDatebaseByIdentifier(_loc4_.AwardID) as TAward;
               _loc8_ = _loc9_.GetDatebaseByIdentifier(_loc6_.FixedAwards[0].Code) as TArticle;
               param1.IsPvpMode = true;
               param1.PvpID = _loc4_.Identifier;
               param1.AwardName = _loc8_.Name;
               param1.AwardCount = _loc6_.FixedAwards[0].Amount;
               break;
            }
            _loc2_++;
         }
      }
      
      public function UnstreamizeSkyTowers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_SkyTowers(param1,param2,param3);
      }
      
      public function UnstreamizeSkyTowerPvplayers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_SkyTowerPvplayers(param1,param2,param3);
      }
      
      public function UnstreamizeSkyTowerPvpDiarys(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_SkyTowerPvpDiarys(param1,param2,param3);
      }
      public function ApplyPalaceCatalog(param1:ByteArray,target:TSkyTower) : void
      {
         if(param1.bytesAvailable >= 4)
         {
            var packed:ByteArray = new ByteArray();
            var packedLength:uint = param1.readUnsignedInt();
            if(packedLength > 0 && packedLength <= param1.bytesAvailable)
            {
               param1.readBytes(packed,0,packedLength);
               packed.uncompress();
               var catalog:Object = JSON.parse(packed.readUTFBytes(packed.length));
               target.Towers.Clear();
               for each(var towerData:Object in catalog.towers)
               {
                  var tower:TTower = new TTower(uint(towerData.id));
                  tower.Name = String(towerData.name);
                  tower.OpenLevel = uint(towerData.openLevel);
                  tower.Tag = (uint(towerData.tag) - 1) % 13 + 1;
                  tower.IsUnlock = Boolean(towerData.unlocked);
                  for each(var floorData:Object in towerData.floors)
                  {
                     var layer:TLayer = new TLayer(uint(floorData.id));
                     layer.LayerName = String(floorData.name);
                     layer.AkeyPrice = 0;
                     layer.PveRoleTempleteID = uint(floorData.model);
                     layer.PveLevel = uint(floorData.level);
                     layer.PveNickname = String(floorData.name);
                     layer.IsClear = Boolean(floorData.clear);
                     tower.Layers.Add(layer);
                  }
                  tower.Layers.MaxLayer = tower.Layers.Count;
                  target.Towers.Add(tower);
               }
               target.LockedTowerID = uint(catalog.locked);
            }
         }

      }
   }
}

