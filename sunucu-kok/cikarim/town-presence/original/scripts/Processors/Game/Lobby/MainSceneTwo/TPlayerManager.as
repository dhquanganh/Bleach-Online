package Processors.Game.Lobby.MainSceneTwo
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Registries.TRegistryRoutine;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.Map.*;
   import Logics.SLogicsCore;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Lobby.Common.Map.MouseEventHander.TMouseEventHanderPlayer;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_MainScene;
   
   public class TPlayerManager
   {
      
      protected var FPlayers:Vector.<TSceneSpriteMoudleInMapCanRunPlayer>;
      
      protected var FUnstreamizerPlayers:Vector.<TSceneSpriteMoudleInMapCanRunPlayer>;
      
      protected var FUnstreamizerRoleCanControl:TUnstreamizerRoleCanControlTwo;
      
      protected var FSpriteMouseHander:TMouseEventHanderPlayer;
      
      protected var FRegistryRoutine:TRegistryRoutine;
      
      protected var FTargetCoordinate:TCoordinate;
      
      protected var FOnSearchWay:Function;
      
      protected var FMapParamater:TMapParameter;
      
      protected var FFunOnClickPlayer:Function;
      
      protected var FFunCreateRandomCoordinate:Function;
      
      public function TPlayerManager(param1:TMapParameter)
      {
         super();
         this.FMapParamater = param1;
         this.FPlayers = new Vector.<TSceneSpriteMoudleInMapCanRunPlayer>();
         this.FUnstreamizerPlayers = new Vector.<TSceneSpriteMoudleInMapCanRunPlayer>();
         this.FUnstreamizerRoleCanControl = new TUnstreamizerRoleCanControlTwo();
         this.FSpriteMouseHander = new TMouseEventHanderPlayer();
         this.FSpriteMouseHander.Callback = this.OnPlayerClicked;
         this.FRegistryRoutine = new TRegistryRoutine();
         this.ConstructPlayerUpdateRoutines();
         this.FTargetCoordinate = new TCoordinate();
      }
      
      protected function AddPlayerByPacket_Perform(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         this.FUnstreamizerPlayers.length = 0;
         this.FUnstreamizerRoleCanControl.Unstreamize(param1.Data,this.FUnstreamizerPlayers,null);
         this.InitPlayers(this.FUnstreamizerPlayers);
         _loc2_ = 0;
         while(_loc2_ < this.FUnstreamizerPlayers.length)
         {
            this.FPlayers.push(this.FUnstreamizerPlayers[_loc2_]);
            _loc2_++;
         }
      }
      
      protected function DeletePlayerByUserID_Perform(param1:TPacket) : TSceneSpriteMoudleInMapCanRunPlayer
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         var _loc8_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc4_ = param1.Data.readUnsignedInt();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc2_ = 0;
         while(_loc2_ < this.FPlayers.length)
         {
            _loc3_ = this.FPlayers[_loc2_];
            if(_loc3_.UserIDHigh == _loc4_ && _loc3_.UserIDLow == _loc5_)
            {
               this.FPlayers.splice(_loc2_,1);
               _loc7_ = _loc3_.KnifeOfKillSoul;
               _loc8_ = _loc3_.Pet;
               this.ReleaseSprite(_loc3_);
               if(_loc7_ != null)
               {
                  _loc6_ = this.FPlayers.indexOf(_loc7_);
                  if(_loc6_ > -1)
                  {
                     this.FPlayers.splice(_loc6_,1);
                     this.ReleaseSprite(_loc7_);
                  }
               }
               if(_loc8_ != null)
               {
                  _loc6_ = this.FPlayers.indexOf(_loc8_);
                  if(_loc6_ > -1)
                  {
                     this.FPlayers.splice(_loc6_,1);
                     this.ReleaseSprite(_loc8_);
                  }
               }
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function MovePlayerByPacket_Perform(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         this.FTargetCoordinate.X = param1.Data.readUnsignedShort();
         this.FTargetCoordinate.Y = param1.Data.readUnsignedShort();
         _loc4_ = this.GetPlayerByID(_loc2_,_loc3_);
         if(_loc4_ != null)
         {
            this.PlayerMove(_loc4_,this.FTargetCoordinate);
         }
      }
      
      protected function ConstructPlayerUpdateRoutines() : void
      {
         this.FRegistryRoutine.Register(CONST_MainScene.UpdateType_ChangeShape,this.PlayerUpdate_ChangeShape);
         this.FRegistryRoutine.Register(CONST_MainScene.UpdateType_MountKnifeOfKillSoul,this.PlayerUpdate_ShowKnifeOfKillSoul);
         this.FRegistryRoutine.Register(CONST_MainScene.UpdateType_UnmountKnifeOfKillSoul,this.PlayerUpdate_HideKnifeOfKillSoul);
         this.FRegistryRoutine.Register(CONST_MainScene.UpdateType_ChangePet,this.PlayerUpdate_ChangePet);
      }
      
      protected function PlayerUpdate_ChangeShape(param1:TSceneSpriteMoudleInMapCanRunPlayer, param2:uint) : void
      {
         param1.ReplaceID = param2;
      }
      
      protected function PlayerUpdate_ShowKnifeOfKillSoul(param1:TSceneSpriteMoudleInMapCanRunPlayer, param2:uint) : void
      {
         var _loc3_:TKnifeExpand = null;
         var _loc4_:int = 0;
         if(param1.KnifeOfKillSoul != null)
         {
            _loc4_ = this.FPlayers.indexOf(param1.KnifeOfKillSoul);
            if(_loc4_ > -1)
            {
               this.FPlayers.splice(_loc4_,1);
               this.ReleaseSprite(param1.KnifeOfKillSoul);
            }
            param1.KnifeOfKillSoul = null;
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param2) as TKnifeExpand;
         param1.KnifeOfKillSoul = TUnstreamizerRoleCanControlTwo.CreateKnifeOfKillSoul(_loc3_.RelationID,param1);
         param1.KnifeOfKillSoul.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_PLAYERS;
         this.FPlayers.push(param1.KnifeOfKillSoul);
      }
      
      protected function PlayerUpdate_HideKnifeOfKillSoul(param1:TSceneSpriteMoudleInMapCanRunPlayer, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(param1.KnifeOfKillSoul != null)
         {
            _loc3_ = this.FPlayers.indexOf(param1.KnifeOfKillSoul);
            if(_loc3_ > -1)
            {
               this.FPlayers.splice(_loc3_,1);
               this.ReleaseSprite(param1.KnifeOfKillSoul);
            }
            param1.KnifeOfKillSoul = null;
         }
      }
      
      protected function PlayerUpdate_ChangePet(param1:TSceneSpriteMoudleInMapCanRunPlayer, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPetLevelUp = null;
         if(param1.Pet != null)
         {
            _loc3_ = this.FPlayers.indexOf(param1.Pet);
            if(_loc3_ > -1)
            {
               this.FPlayers.splice(_loc3_,1);
               this.ReleaseSprite(param1.Pet);
            }
            param1.Pet = null;
         }
         if(param2 != 0)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,param2) as TPetLevelUp;
            param1.Pet = TUnstreamizerRoleCanControlTwo.CreatePet(_loc4_.PetResourceID,param1);
            param1.Pet.RoleDirection = CONST_MAP.DIRECTION_RIGHT;
            param1.Pet.ChangeToStandBy();
            param1.Pet.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_PLAYERS;
            this.FPlayers.push(param1.Pet);
         }
      }
      
      protected function PlayerUpdate_HidePet(param1:TSceneSpriteMoudleInMapCanRunPlayer, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(param1.Pet != null)
         {
            _loc3_ = this.FPlayers.indexOf(param1.Pet);
            if(_loc3_ > -1)
            {
               this.FPlayers.splice(_loc3_,1);
               this.ReleaseSprite(param1.Pet);
            }
            param1.Pet = null;
         }
      }
      
      protected function UpdatePlayerByPacket_Perform(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Function = null;
         var _loc7_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedByte();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc6_ = this.FRegistryRoutine.GetRoutineByIndentifier(_loc4_);
         _loc7_ = this.GetPlayerByUserID(_loc2_,_loc3_);
         if(_loc7_ != null && _loc6_ != null)
         {
            _loc6_(_loc7_,_loc5_);
         }
      }
      
      protected function InitPlayers(param1:Vector.<TSceneSpriteMoudleInMapCanRunPlayer>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc3_.MapParameter = this.FMapParamater;
            _loc3_.UpdateHeadDecoration();
            _loc3_.RoleDirection = CONST_MAP.DIRECTION_DOWN;
            _loc3_.ChangeToStandBy();
            _loc3_.MouseEventHander = null;
            if(_loc3_.Follower == null)
            {
               if(this.FFunCreateRandomCoordinate != null)
               {
                  this.FFunCreateRandomCoordinate(_loc3_.BirthID,_loc3_.MapCoordinate);
                  if(_loc3_.KnifeOfKillSoul != null)
                  {
                     _loc3_.KnifeOfKillSoul.MapCoordinate.Assign(_loc3_.MapCoordinate);
                  }
                  if(_loc3_.Pet != null)
                  {
                     _loc3_.Pet.RoleDirection = CONST_MAP.DIRECTION_RIGHT;
                     _loc3_.Pet.ChangeToStandBy();
                  }
               }
               _loc3_.MouseEventHander = this.FSpriteMouseHander;
            }
            _loc3_.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_PLAYERS;
            _loc2_++;
         }
      }
      
      protected function GetPlayerByID(param1:uint, param2:uint) : TSceneSpriteMoudleInMapCanRunPlayer
      {
         var _loc3_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this.FPlayers.length)
         {
            _loc3_ = this.FPlayers[_loc4_];
            if(_loc3_.UserIDHigh == param1 && _loc3_.UserIDLow == param2)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      protected function PlayerMove(param1:TSceneSpriteMoudleInMapCanRunPlayer, param2:TCoordinate) : void
      {
         if(this.FOnSearchWay != null)
         {
            this.FOnSearchWay(param1,param2.X,param2.Y);
         }
      }
      
      protected function OnPlayerClicked(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         if(this.FFunOnClickPlayer != null)
         {
            this.FFunOnClickPlayer(param1);
         }
      }
      
      protected function ReleaseSprite(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         SLogicsCore.PoolMap.Release(param1);
         param1.Release();
      }
      
      public function set OnSearchWay(param1:Function) : void
      {
         this.FOnSearchWay = param1;
      }
      
      public function get Players() : Vector.<TSceneSpriteMoudleInMapCanRunPlayer>
      {
         return this.FPlayers;
      }
      
      public function set FunOnClickPlayer(param1:Function) : void
      {
         this.FFunOnClickPlayer = param1;
      }
      
      public function get UnstreamizerPlayers() : Vector.<TSceneSpriteMoudleInMapCanRunPlayer>
      {
         return this.FUnstreamizerPlayers;
      }
      
      public function set FunCreateRandomCoordinate(param1:Function) : void
      {
         this.FFunCreateRandomCoordinate = param1;
      }
      
      public function AddPlayerByPacket(param1:TPacket) : void
      {
         this.AddPlayerByPacket_Perform(param1);
      }
      
      public function DeletePlayerByPacket(param1:TPacket) : TSceneSpriteMoudleInMapCanRunPlayer
      {
         return this.DeletePlayerByUserID_Perform(param1);
      }
      
      public function MovePlayerByPacket(param1:TPacket) : void
      {
         this.MovePlayerByPacket_Perform(param1);
      }
      
      public function UpdatePlayerByPacket(param1:TPacket) : void
      {
         this.UpdatePlayerByPacket_Perform(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FPlayers.length)
         {
            this.ReleaseSprite(this.FPlayers[_loc1_]);
            _loc1_++;
         }
         this.FPlayers.length = 0;
         this.FUnstreamizerPlayers.length = 0;
      }
      
      public function GetPlayerByUserID(param1:uint, param2:uint) : TSceneSpriteMoudleInMapCanRunPlayer
      {
         return this.GetPlayerByID(param1,param2);
      }
   }
}

