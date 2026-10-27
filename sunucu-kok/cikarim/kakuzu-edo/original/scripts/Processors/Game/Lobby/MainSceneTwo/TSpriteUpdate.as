package Processors.Game.Lobby.MainSceneTwo
{
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMap;
   
   public class TSpriteUpdate
   {
      
      protected var FHideSpriteClassID:int;
      
      protected var FSpritesCanShow:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FMapParameter:TMapParameter;
      
      protected var FSprites:Object;
      
      public function TSpriteUpdate(param1:TMapParameter)
      {
         super();
         this.FMapParameter = param1;
         this.FSpritesCanShow = new Vector.<TSceneSpriteMoudleInMap>();
         this.FSprites = new Vector.<TSceneSpriteMoudleInMap>();
         this.FHideSpriteClassID = -1;
      }
      
      protected function UpdateRoleData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FSprites.length)
         {
            this.FSprites[_loc1_].UpdateData();
            _loc1_++;
         }
      }
      
      protected function UpdateRoleView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:TSceneSpriteMoudleInMap = null;
         this.FSpritesCanShow.length = 0;
         _loc2_ = int(this.FSprites.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FSprites[_loc1_];
            _loc3_ = this.CheckIfCanUpdate(_loc4_);
            if(_loc3_)
            {
               _loc4_.UpdateView();
               this.FSpritesCanShow.push(_loc4_);
            }
            _loc1_++;
         }
      }
      
      protected function CheckIfCanUpdate(param1:TSceneSpriteMoudleInMap) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = TUtilityCartisian.CheckTwoBoundsCollision(this.FMapParameter.ScreenBounds,param1.SpriteBounds);
         if(!_loc2_)
         {
            return false;
         }
         if(param1.SpriteClassID == this.FHideSpriteClassID)
         {
            return false;
         }
         return true;
      }
      
      public function get SpritesCanShow() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FSpritesCanShow;
      }
      
      public function set SpritesCanShow(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         this.FSpritesCanShow = param1;
      }
      
      public function set Sprites(param1:Object) : void
      {
         this.FSprites = param1;
      }
      
      public function Update() : void
      {
         this.UpdateRoleData();
         this.UpdateRoleView();
      }
      
      public function HideSpriteBySpriteClassID(param1:int) : void
      {
         this.FHideSpriteClassID = param1;
      }
   }
}

