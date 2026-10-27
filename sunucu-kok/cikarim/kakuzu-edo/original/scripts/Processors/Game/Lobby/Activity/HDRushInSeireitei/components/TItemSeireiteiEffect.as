package Processors.Game.Lobby.Activity.HDRushInSeireitei.components
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TItemSeireiteiEffect
   {
      
      public static const Animation_Fail:int = 1;
      
      public static const Animation_Succ:int = 2;
      
      public static const Animation_Nomal:int = 3;
      
      public static const Animation_Special:int = 4;
      
      protected var FMainUI:Sprite;
      
      protected var FMCResult:MovieClip;
      
      protected var FMCInner:MovieClip;
      
      protected var FNomalFight:MovieClip;
      
      protected var FSpecialFight:MovieClip;
      
      protected var FCurMC:MovieClip;
      
      protected var FCallAnimationBack:Function;
      
      public function TItemSeireiteiEffect()
      {
         super();
      }
      
      protected function CallBack() : void
      {
         if(this.FCurMC == null)
         {
            return;
         }
         this.FCurMC.stop();
         this.FCurMC.visible = false;
         if(this.FCallAnimationBack != null)
         {
            this.FCallAnimationBack();
         }
      }
      
      public function get CallAnimationBack() : Function
      {
         return this.FCallAnimationBack;
      }
      
      public function set CallAnimationBack(param1:Function) : void
      {
         this.FCallAnimationBack = param1;
      }
      
      public function InitView(param1:Sprite) : void
      {
         this.FMainUI = param1;
         this.FMCResult = this.FMainUI["MC_Result"];
         this.FMCInner = this.FMCResult["mc_resultInner"];
         this.FNomalFight = this.FMainUI["MC_Fight"];
         this.FSpecialFight = this.FMainUI["MC_SpecialFight"];
         this.FMCResult.addFrameScript(this.FMCResult.totalFrames - 1,this.CallBack);
         this.FNomalFight.addFrameScript(this.FNomalFight.totalFrames - 1,this.CallBack);
         this.FSpecialFight.addFrameScript(this.FSpecialFight.totalFrames - 1,this.CallBack);
      }
      
      public function InvisibleAll() : void
      {
         this.FMCResult.visible = false;
         this.FNomalFight.visible = false;
         this.FSpecialFight.visible = false;
      }
      
      public function PlayAnimation(param1:int) : void
      {
         switch(param1)
         {
            case Animation_Fail:
               this.FMCResult.visible = true;
               this.FMCResult.gotoAndPlay(1);
               this.FMCInner.gotoAndStop(2);
               this.FCurMC = this.FMCResult;
               break;
            case Animation_Succ:
               this.FMCResult.visible = true;
               this.FMCResult.gotoAndPlay(1);
               this.FMCInner.gotoAndStop(1);
               this.FCurMC = this.FMCResult;
               break;
            case Animation_Nomal:
               this.FNomalFight.visible = true;
               this.FNomalFight.gotoAndPlay(1);
               this.FCurMC = this.FNomalFight;
               break;
            case Animation_Special:
               this.FSpecialFight.visible = true;
               this.FSpecialFight.gotoAndPlay(1);
               this.FCurMC = this.FSpecialFight;
         }
      }
      
      public function SetPosition(param1:DisplayObject) : void
      {
         this.FMainUI.x = param1.x;
         this.FMainUI.y = param1.y;
      }
   }
}

