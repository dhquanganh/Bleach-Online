package Processors.Game.Lobby.MainSceneTwo
{
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Resources.Constants.CONST_MAP;
   
   public class TMainPlayerManager
   {
      
      protected var FMainRole:TSceneSpriteMoudleInMapCanRunPlayerMainPlayer;
      
      protected var FMainRoles:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FMapParameter:TMapParameter;
      
      public function TMainPlayerManager(param1:TMapParameter)
      {
         super();
         this.FMapParameter = param1;
      }
      
      public function get MainRole() : TSceneSpriteMoudleInMapCanRunPlayerMainPlayer
      {
         return this.FMainRole;
      }
      
      public function get MainRoles() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FMainRoles;
      }
      
      public function CreateMainRole() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TCharacter = null;
         _loc2_ = SLogicsCore.Character;
         _loc1_ = _loc2_.Heros.GetHeroByIndex(0);
         this.FMainRole = new TSceneSpriteMoudleInMapCanRunPlayerMainPlayer();
         this.FMainRole.MouseEventHander = null;
         this.FMainRoles = new Vector.<TSceneSpriteMoudleInMap>();
         this.FMainRole.MapParameter = this.FMapParameter;
         this.FMainRole.Name = _loc2_.NickName;
         this.FMainRole.OpenBleachAgent = SLogicsCore.BleachAgentData.Open;
         this.FMainRole.UpdateHeadDecoration();
         this.FMainRole.RoleTempleteID = _loc1_.Identifier;
         this.FMainRole.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_MAINROLE;
         this.FMainRole.RebirthNum = _loc1_.RebirthNum;
         this.FMainRoles.push(this.FMainRole);
      }
      
      public function ReLocation() : void
      {
         this.FMainRole.MapCoordinate.X = this.FMapParameter.MapData.BirthPlace_X;
         this.FMainRole.MapCoordinate.Y = this.FMapParameter.MapData.BirthPlace_Y;
      }
      
      public function DeleteRole(param1:TSceneSpriteMoudleInMap) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FMainRoles.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FMainRoles[_loc2_] == param1)
            {
               this.FMainRoles.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
   }
}

