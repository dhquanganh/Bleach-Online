package Processors.Game.Lobby.GirlGame
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.ui.Keyboard;
   
   public class TComponentGameLogic extends TProcessorLobbyWindow
   {
      
      protected static const FrameIndexInit:int = 1;
      
      protected static const FrameIndexRuning:int = 2;
      
      protected static const StarEffectNum:int = 3;
      
      protected var FMainUI:MovieClip;
      
      protected var FRedRect:Sprite;
      
      protected var FYellowRect:Sprite;
      
      protected var FGreenRect:Sprite;
      
      protected var FGrayRect:Sprite;
      
      protected var FWhiteRect:Sprite;
      
      protected var FBalckRect:Sprite;
      
      protected var FGameBar:Sprite;
      
      protected var FBarStandard:Sprite;
      
      protected var FWaitFillBar:Bitmap;
      
      protected var FBitMapData:BitmapData;
      
      protected var FMatrix:Matrix;
      
      protected var FRectClear:Rectangle;
      
      protected var FStarEffects:Vector.<MovieClip>;
      
      protected var FCurrentStarEffect:MovieClip;
      
      protected var FBombEffect:MovieClip;
      
      protected var FCursor:Sprite;
      
      protected var FBoundsYellow:TBounds;
      
      protected var FBoundsRed:TBounds;
      
      protected var FRuning:Boolean;
      
      protected var FCurrentCursorX:int;
      
      protected var FStarLevel:int;
      
      protected var FOnGameOver:Function;
      
      protected var FSpeed:int;
      
      public function TComponentGameLogic(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         this.FRedRect = this.FMainUI["RedRect"];
         this.FYellowRect = this.FMainUI["YellowRect"];
         this.FGreenRect = this.FMainUI["GreenRect"];
         this.FGrayRect = this.FMainUI["GrayColor"];
         this.FWhiteRect = this.FMainUI["WhiteColor"];
         this.FBalckRect = this.FMainUI["BlackRect"];
         this.FStarEffects = new Vector.<MovieClip>();
         _loc2_ = this.FMainUI["LevelStar"];
         this.FBombEffect = _loc2_["BombEffect"];
         _loc1_ = 0;
         while(_loc1_ < StarEffectNum)
         {
            this.FStarEffects.push(_loc2_["StarEffect" + _loc1_]);
            _loc1_++;
         }
         this.FBoundsYellow = new TBounds();
         this.FBoundsRed = new TBounds();
         this.FGameBar = this.FMainUI["GameBar"];
         this.FCursor = this.FGameBar["Cursor"];
         this.FBarStandard = this.FGameBar["BarStandard"];
         this.FWaitFillBar = new Bitmap();
         this.FBitMapData = new BitmapData(this.FBarStandard.width,this.FBarStandard.height);
         this.FWaitFillBar.bitmapData = this.FBitMapData;
         this.FBarStandard.addChild(this.FWaitFillBar);
         this.FMatrix = new Matrix();
         this.FRectClear = new Rectangle(0,0,this.FBarStandard.width,this.FBarStandard.height);
      }
      
      protected function UILocation() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < StarEffectNum)
         {
            this.FStarEffects[_loc1_].visible = false;
            _loc1_++;
         }
         this.FBombEffect.visible = false;
         this.FCursor.visible = false;
         this.FRedRect.visible = false;
         this.FYellowRect.visible = false;
         this.FGreenRect.visible = false;
         this.FGrayRect.visible = false;
         this.FWhiteRect.visible = false;
         this.FBalckRect.visible = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            if(this.FRuning)
            {
               this.FCurrentCursorX += this.FSpeed;
               if(this.FCurrentCursorX > this.FBarStandard.width)
               {
                  this.FCurrentCursorX = this.FBarStandard.width;
                  this.FSpeed *= -1;
               }
               else if(this.FCurrentCursorX < 0)
               {
                  this.FCurrentCursorX = 0;
                  this.FSpeed *= -1;
               }
               this.FCursor.x = this.FCurrentCursorX;
            }
            if(this.FCurrentStarEffect != null && this.FCurrentStarEffect.currentFrame == this.FCurrentStarEffect.totalFrames)
            {
               this.FCurrentStarEffect.stop();
               this.FCurrentStarEffect.visible = false;
               this.FCurrentStarEffect = null;
               this.BackScore(this.FStarLevel);
            }
         }
      }
      
      protected function CreateRandomPosition(param1:int, param2:int) : void
      {
         this.FBoundsYellow.Width = param1;
         this.FBoundsRed.Width = param2;
         this.FBoundsYellow.X = Math.random() * (this.FBarStandard.width / 2 - param1) + this.FBarStandard.width / 2;
         this.FBoundsRed.X = this.FBoundsYellow.X + (param1 - param2) / 2;
      }
      
      protected function ClearBitmapData(param1:Sprite) : void
      {
         this.FMatrix.a = this.FRectClear.width;
         this.FMatrix.tx = 0;
         this.FBitMapData.draw(param1,this.FMatrix);
      }
      
      protected function FillGameBar(param1:Sprite, param2:TBounds) : void
      {
         this.FMatrix.a = param2.Width;
         this.FMatrix.tx = param2.X;
         this.FBitMapData.draw(param1,this.FMatrix);
      }
      
      protected function ListenKeyBoardEvent() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
      }
      
      protected function UnlistenKeyBoardEvent() : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
      }
      
      protected function StartGame() : void
      {
      }
      
      protected function EndGame() : void
      {
      }
      
      protected function GetStarLevel() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FCurrentCursorX >= this.FBoundsRed.X && this.FCurrentCursorX <= this.FBoundsRed.XEnd)
         {
            return CONST_GIRLGAME.StartLevel_Perfect;
         }
         if(this.FCurrentCursorX >= this.FBoundsYellow.X && this.FCurrentCursorX <= this.FBoundsYellow.XEnd)
         {
            return CONST_GIRLGAME.StartLevel_Good;
         }
         return CONST_GIRLGAME.StartLevel_Oops;
      }
      
      protected function BackScore(param1:int) : void
      {
         if(this.FOnGameOver != null)
         {
            this.FOnGameOver(param1,this.FCurrentCursorX + this.FBarStandard.x + this.FGameBar.x + this.FMainUI.x,this.FCursor.y + this.FBarStandard.y + this.FGameBar.y + this.FMainUI.y);
         }
      }
      
      protected function PlayStarLevelEffect(param1:int) : void
      {
         this.FCurrentStarEffect = this.FStarEffects[param1];
         this.FBombEffect.gotoAndPlay(1);
         this.FCurrentStarEffect.gotoAndPlay(1);
         this.FCurrentStarEffect.visible = true;
      }
      
      protected function CallBack_KeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE)
         {
            this.UnlistenKeyBoardEvent();
            this.FRuning = false;
            this.FStarLevel = this.GetStarLevel();
            this.PlayStarLevelEffect(this.FStarLevel);
         }
      }
      
      public function set OnGameOver(param1:Function) : void
      {
         this.FOnGameOver = param1;
      }
      
      public function LoadResources(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.UIDispatch();
         this.UILocation();
      }
      
      public function Run(param1:int) : void
      {
         this.FSpeed = param1;
         this.FMainUI.gotoAndStop(FrameIndexRuning);
         this.ClearBitmapData(this.FGreenRect);
         this.FillGameBar(this.FYellowRect,this.FBoundsYellow);
         this.FillGameBar(this.FRedRect,this.FBoundsRed);
         this.ListenKeyBoardEvent();
         this.FCursor.x = 0;
         this.FCurrentCursorX = 0;
         this.FCursor.visible = true;
         this.FRuning = true;
      }
      
      public function Init(param1:int, param2:int) : void
      {
         this.CreateRandomPosition(param1,param2);
         this.FMainUI.gotoAndStop(FrameIndexInit);
         this.ClearBitmapData(this.FBalckRect);
         this.FillGameBar(this.FGrayRect,this.FBoundsYellow);
         this.FillGameBar(this.FWhiteRect,this.FBoundsRed);
         this.FCursor.visible = false;
      }
      
      public function Reset() : void
      {
      }
   }
}

