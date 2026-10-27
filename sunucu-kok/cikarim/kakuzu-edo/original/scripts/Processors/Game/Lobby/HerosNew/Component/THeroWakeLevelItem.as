package Processors.Game.Lobby.HerosNew.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TWakeUp;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class THeroWakeLevelItem
   {
      
      protected static const Glow_Fly_Duration:int = 200;
      
      protected var FMainUI:MovieClip;
      
      protected var FMap:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FIconVec:Vector.<Sprite>;
      
      protected var FGlow:Sprite;
      
      protected var FGlowMove:TMovementLinear;
      
      protected var FCurIndex:int;
      
      protected var FIsShow:Boolean;
      
      protected var FWakeLevel:MovieClip;
      
      protected var FHero:THero;
      
      protected var FStartMove:Boolean;
      
      protected var FStartTick:int;
      
      protected var FMapTip:THeroWakeMapTip;
      
      public function THeroWakeLevelItem(param1:MovieClip)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TWakeUp = null;
         var _loc5_:Sprite = null;
         super();
         this.FMainUI = param1;
         this.FMainUI.gotoAndStop(1);
         this.FMainUI.addFrameScript(this.FMainUI.totalFrames - 1,this.OnLastFrame);
         this.FMainUI.addFrameScript(1,this.OnFirstFrame);
         this.FMap = this.FMainUI["MC_Map"];
         this.FMap.visible = false;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMap["Btn_Close"];
         this.FBtnClose.Visible = false;
         this.FBtnClose.OnClick = this.BtnOnClose;
         this.FGlow = this.FMap["MC_Glow"];
         this.FGlow.mouseChildren = false;
         this.FGlow.mouseEnabled = false;
         this.FGlowMove = new TMovementLinear();
         this.FCurIndex = -1;
         this.FIconVec = new Vector.<Sprite>();
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_WakeUp).GetDatebaseByIndex(0) as TWakeUp;
         _loc3_ = _loc4_.WakeLevelCount;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FMap["MC_Icon_" + _loc2_];
            _loc5_.addEventListener(MouseEvent.MOUSE_MOVE,this.IconOnOver);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.IconOnOut);
            this.FIconVec.push(_loc5_);
            _loc2_++;
         }
         this.FWakeLevel = this.FMainUI["WakeUpLevel"];
         this.FWakeLevel.buttonMode = true;
         this.FWakeLevel.addEventListener(MouseEvent.CLICK,this.WakeLevelOnClick);
         this.FMapTip = new THeroWakeMapTip();
         this.FMapTip.UIDispatch();
         this.FMapTip.visible = false;
         this.FMapTip.WakeTotalLevel = _loc4_.WakeLevelCount;
         this.FMainUI.addChild(this.FMapTip);
      }
      
      protected function WakeLevelOnClick(param1:MouseEvent) : void
      {
         this.FIsShow = !this.FIsShow;
         this.Pingpong();
      }
      
      protected function OnLastFrame() : void
      {
         this.FMap.visible = false;
      }
      
      protected function OnFirstFrame() : void
      {
         this.FBtnClose.Visible = true;
         this.FStartTick = STimingCore.TickCount;
      }
      
      protected function IconOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FIconVec.indexOf(param1.target as Sprite);
         this.FMapTip.x = this.FMainUI.mouseX;
         this.FMapTip.y = this.FMainUI.mouseY;
         if(_loc2_ == this.FCurIndex)
         {
            return;
         }
         this.FMapTip.SetData(this.FHero.Identifier,_loc2_);
         this.FCurIndex = _loc2_;
         this.FGlowMove.SetupSegmentByDuration(this.FIconVec[this.FCurIndex].x,this.FGlow.y,this.FGlow.x,this.FGlow.y,Glow_Fly_Duration);
         this.FStartMove = true;
         this.FMapTip.visible = true;
      }
      
      protected function IconOnOut(param1:MouseEvent) : void
      {
         this.FStartTick = STimingCore.TickCount;
         this.FCurIndex = -1;
         this.FMapTip.visible = false;
      }
      
      protected function BtnOnClose(param1:Object, param2:MouseEvent) : void
      {
         this.FIsShow = false;
         this.Pingpong();
      }
      
      protected function Pingpong() : void
      {
         if(this.FIsShow)
         {
            this.FMainUI.gotoAndStop(this.FMainUI.totalFrames);
            this.FGlow.x = this.FIconVec[this.FHero.WakeupLevel].x;
         }
         else
         {
            this.FMainUI.gotoAndPlay(2);
         }
         this.FBtnClose.Visible = false;
         this.FMap.visible = true;
      }
      
      public function set WakeAttributes(param1:TWakeHeroAttributes) : void
      {
         this.FMapTip.WakeAttributes = param1;
      }
      
      public function SetData(param1:THero) : void
      {
         this.FHero = param1;
         this.FWakeLevel.visible = this.FHero != SLogicsCore.Character.MainHero;
         this.FWakeLevel.gotoAndStop(this.FHero.WakeupLevel + 1);
      }
      
      public function Update() : void
      {
         if(!this.FMap.visible)
         {
            return;
         }
         if(!this.FIsShow)
         {
            return;
         }
         if(this.FMainUI.currentFrame != 1)
         {
            this.FMainUI.gotoAndStop(this.FMainUI.currentFrame - 1);
         }
         if(this.FGlowMove.MoveOver)
         {
            this.FStartMove = false;
            return;
         }
         if(!this.FStartMove)
         {
            return;
         }
         this.FGlowMove.Move(STimingCore.TickCount - this.FStartTick);
         this.FGlow.x = this.FGlowMove.X;
      }
      
      public function Close() : void
      {
         if(this.FIsShow)
         {
            this.FIsShow = false;
            this.Pingpong();
         }
      }
   }
}

