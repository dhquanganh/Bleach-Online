package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecoration;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationBleachAgentIcon;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.ISpriteActionContorl;
   import Resources.Constants.CONST_MAP;
   
   public class TSceneSpriteMoudleInMap extends TSceneSpriteMoudle
   {
      
      protected var FALPHA_MASK:Number = 0.6;
      
      protected var FMapCoordinate:TCoordinate;
      
      protected var FTalkCoordinate:TCoordinate;
      
      protected var FMapParameter:TMapParameter;
      
      protected var FActionQuery:ISpriteActionContorl;
      
      protected var FHeadDecoration:Vector.<TDecoration>;
      
      protected var FSpriteBounds:TBounds;
      
      protected var FLayer:int;
      
      protected var FUpdateTick:int;
      
      public function TSceneSpriteMoudleInMap()
      {
         super();
         this.FMapCoordinate = new TCoordinate();
         this.FTalkCoordinate = new TCoordinate();
         this.FSpriteBounds = new TBounds();
         this.FHeadDecoration = new Vector.<TDecoration>();
         this.CreateDecoration();
         this.CreateSpriteActionQuery();
      }
      
      protected function CreateDecoration() : void
      {
      }
      
      protected function CreateSpriteActionQuery() : void
      {
      }
      
      protected function UpdateCoordinate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FMapCoordinate.X - this.FMapParameter.ScreenBounds.X;
         _loc2_ = this.FMapCoordinate.Y - this.FMapParameter.ScreenBounds.Y;
         if(x != _loc1_)
         {
            x = _loc1_;
         }
         if(y != _loc2_)
         {
            y = _loc2_;
         }
         if(FCurrentFrame == null)
         {
            this.FSpriteBounds.X = this.FMapCoordinate.X;
            this.FSpriteBounds.Y = this.FMapCoordinate.Y;
            this.FSpriteBounds.Width = this.width;
            this.FSpriteBounds.Height = this.height;
         }
         else
         {
            this.FSpriteBounds.X = this.FMapCoordinate.X - width / 2;
            this.FSpriteBounds.Y = this.FMapCoordinate.Y - height - FCurrentFrame.Pivot.Y + FCurrentFrame.Surface.height;
            this.FSpriteBounds.Width = this.width;
            this.FSpriteBounds.Height = this.height;
         }
      }
      
      protected function UpdateAlpha() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(this.FMapParameter == null || this.FMapParameter.MapData == null)
         {
            return;
         }
         _loc2_ = this.FMapCoordinate.X / this.FMapParameter.MapData.PathTileWidth;
         _loc1_ = this.FMapCoordinate.Y / this.FMapParameter.MapData.PathTileHeight;
         _loc3_ = this.FMapParameter.MapData.PathTile_NumRow * _loc1_ + _loc2_;
         if(this.FMapParameter.MapData.PathTileData[_loc3_] == CONST_MAP.FLAG_PATHTILE_MASK)
         {
            _loc4_ = this.FALPHA_MASK;
         }
         else
         {
            _loc4_ = 1;
         }
         if(alpha != _loc4_)
         {
            alpha = _loc4_;
         }
      }
      
      protected function UpdateAction() : void
      {
         var _loc1_:int = 0;
         if(!this.HaveRoleMoudle())
         {
            return;
         }
         _loc1_ = this.FActionQuery.ActionQuery(this);
         FRoleActionID = _loc1_;
         UpdateMoudle();
      }
      
      protected function HaveRoleMoudle() : Boolean
      {
         return true;
      }
      
      protected function UpdateDecoration() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TDecoration = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = FRoleBitMap.y;
         _loc1_ = 0;
         while(_loc1_ < this.FHeadDecoration.length)
         {
            _loc2_ = this.FHeadDecoration[_loc1_];
            _loc2_.UpdateView();
            if(!this.SpecialLayout(_loc2_))
            {
               _loc4_ = _loc2_.Position;
               switch(_loc4_)
               {
                  case TDecoration.POSITION_TOP:
                     _loc3_ -= _loc2_.height;
                     _loc3_ += _loc2_.YOffset;
                     break;
                  case TDecoration.POSITION_BOTTOM:
                     _loc3_ = 0;
               }
               if(_loc2_.y != _loc3_)
               {
                  _loc2_.y = _loc3_;
               }
            }
            _loc1_++;
         }
      }
      
      protected function SpecialLayout(param1:TDecoration) : Boolean
      {
         var _loc2_:TDecoration = null;
         if(param1 is TDecorationBleachAgentIcon)
         {
            _loc2_ = this.FHeadDecoration[0];
            param1.x = _loc2_.x - _loc2_.width / 2 - param1.width;
            param1.y = _loc2_.y + (_loc2_.height - param1.height) / 2;
            return true;
         }
         return false;
      }
      
      public function UpdateHeadDecoration_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TDecoration = null;
         _loc1_ = 0;
         while(_loc1_ < this.FHeadDecoration.length)
         {
            _loc2_ = this.FHeadDecoration[_loc1_];
            _loc2_.Update(this);
            _loc1_++;
         }
      }
      
      public function get MapCoordinate() : TCoordinate
      {
         return this.FMapCoordinate;
      }
      
      public function get SpriteBounds() : TBounds
      {
         return this.FSpriteBounds;
      }
      
      public function set MapParameter(param1:TMapParameter) : void
      {
         this.FMapParameter = param1;
      }
      
      public function get MapParameter() : TMapParameter
      {
         return this.FMapParameter;
      }
      
      public function get TalkCoordinate() : TCoordinate
      {
         return this.FTalkCoordinate;
      }
      
      public function set TalkCoordinate(param1:TCoordinate) : void
      {
         this.FTalkCoordinate = param1;
      }
      
      public function get Layer() : int
      {
         return this.FLayer;
      }
      
      public function set Layer(param1:int) : void
      {
         this.FLayer = param1;
      }
      
      public function get UpdateTick() : int
      {
         return this.FUpdateTick;
      }
      
      public function set UpdateTick(param1:int) : void
      {
         this.FUpdateTick = param1;
      }
      
      override public function UpdateData() : void
      {
         this.UpdateCoordinate();
         super.UpdateData();
      }
      
      override public function UpdateView() : void
      {
         this.UpdateAlpha();
         super.UpdateView();
         this.UpdateDecoration();
      }
      
      public function AddHeadDecoration(param1:TDecoration) : void
      {
         this.FHeadDecoration.push(param1);
      }
      
      public function UpdateHeadDecoration() : void
      {
         this.UpdateHeadDecoration_Perform();
      }
      
      override public function Release() : void
      {
         var _loc1_:int = 0;
         super.Release();
         this.FMapCoordinate.X = 0;
         this.FMapCoordinate.Y = 0;
         this.FTalkCoordinate.X = 0;
         this.FTalkCoordinate.Y = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FHeadDecoration.length)
         {
            this.FHeadDecoration[_loc1_].Release();
            _loc1_++;
         }
      }
   }
}

