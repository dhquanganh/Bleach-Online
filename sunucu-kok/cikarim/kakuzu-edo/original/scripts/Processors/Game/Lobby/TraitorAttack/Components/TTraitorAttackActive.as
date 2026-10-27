package Processors.Game.Lobby.TraitorAttack.Components
{
   import Foundation.Common.TCoordinate;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Battle.Character.TActive;
   import flash.display.Sprite;
   
   public class TTraitorAttackActive extends TActive
   {
      
      protected var FInitX:Number;
      
      protected var FInitY:Number;
      
      protected var FHpBg:Sprite;
      
      protected var FHp:Sprite;
      
      protected var FMoveTimes:uint;
      
      public function TTraitorAttackActive(param1:TUIComponent, param2:int, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
         this.FHpBg = new Sprite();
         this.FHpBg.graphics.beginFill(2958365);
         this.FHpBg.graphics.drawRect(-30,-2,60,9);
         this.FHpBg.graphics.endFill();
         addChild(this.FHpBg);
         this.FHp = new Sprite();
         this.FHp.graphics.beginFill(15256072);
         this.FHp.graphics.drawRect(0,0,56,5);
         this.FHp.graphics.endFill();
         this.FHpBg.addChild(this.FHp);
         this.FHp.x = -28;
      }
      
      protected function AutoPointRun() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:TCoordinate = null;
         if(FIsDie)
         {
            return;
         }
         _loc1_ = this.FInitY + Math.random() * 150;
         if(_loc1_ > 600)
         {
            _loc1_ -= 160;
         }
         _loc2_ = new TCoordinate();
         _loc2_.X = this.FInitX + Math.random() * 350;
         _loc2_.Y = _loc1_;
         MoveTo(this.AutoPointRun,_loc2_,220);
         this.FMoveTimes = STimingCore.ServerTick;
      }
      
      public function get IsDie() : Boolean
      {
         return FIsDie;
      }
      
      public function set IsDie(param1:Boolean) : void
      {
         FIsDie = param1;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this.FHpBg.scaleX = scaleX;
      }
      
      public function InitPos(param1:Number, param2:Number) : void
      {
         this.FInitX = param1;
         this.FInitY = param2;
         x = param1;
         y = param2;
      }
      
      public function RunToStage() : void
      {
         var _loc1_:TCoordinate = null;
         _loc1_ = new TCoordinate();
         _loc1_.X = this.FInitX - 450;
         _loc1_.Y = this.FInitY;
         MoveTo(this.StartAutoRun,_loc1_,220);
         PlayRun();
         this.FInitX -= 450;
      }
      
      public function StartAutoRun() : void
      {
         this.AutoPointRun();
      }
      
      public function SetHp(param1:Number) : void
      {
         if(FEnemy != null)
         {
            this.FHp.scaleX = param1 / FEnemy.Hp;
         }
      }
      
      override public function UpdateActive() : void
      {
         super.UpdateActive();
         FNameSprite.y -= 15;
         this.FHpBg.x = FNameSprite.x;
         this.FHpBg.y = FNameSprite.y + 25;
      }
   }
}

