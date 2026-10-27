package Processors.Game.Lobby.Common.Achievement
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TAchievementInfors;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TProcessorWindowGetAchievementEffect extends TProcessorLobbyWindow
   {
      
      protected static const EFFECT_NUM:int = 1;
      
      protected static const STATE_IDLE:int = 0;
      
      protected static const STATE_BUSY:int = 1;
      
      protected static const StarAppearFreamIndex:int = 12;
      
      protected var FAchievementEffectBoard:Vector.<MovieClip>;
      
      protected var FAchievementEffectStar:Vector.<MovieClip>;
      
      protected var FTFAchievementName:Vector.<TextField>;
      
      protected var FAchievementEffectState:Vector.<int>;
      
      protected var FAchievementWaitToShow:TAchievementInfors;
      
      public function TProcessorWindowGetAchievementEffect(param1:TUIComponent)
      {
         super(param1);
         this.FAchievementWaitToShow = new TAchievementInfors();
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         this.FAchievementEffectBoard = new Vector.<MovieClip>();
         this.FAchievementEffectStar = new Vector.<MovieClip>();
         this.FTFAchievementName = new Vector.<TextField>();
         this.FAchievementEffectState = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < EFFECT_NUM)
         {
            _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("AchievementEffectUI") as MovieClip;
            addChild(_loc2_);
            _loc2_.x = (CONST_COMMON.STAGE_Width - _loc2_.width) / 2;
            _loc2_.y = CONST_COMMON.STAGE_Height - (_loc1_ + 1) * _loc2_.height + 50;
            this.FAchievementEffectBoard.push(_loc2_);
            this.FAchievementEffectStar.push(_loc2_["Star"]);
            this.FTFAchievementName.push(_loc2_["Star"]["Star"]["Name"]["Name"]);
            _loc1_++;
         }
      }
      
      protected function Resources_UILocations() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < EFFECT_NUM)
         {
            this.FAchievementEffectState.push(STATE_IDLE);
            this.FAchievementEffectBoard[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.UpdateEffect();
         }
      }
      
      protected function UpdateEffect() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < EFFECT_NUM)
         {
            if(this.FAchievementEffectState[_loc1_] == STATE_BUSY)
            {
               if(this.FAchievementEffectStar[_loc1_].currentFrame == this.FAchievementEffectStar[_loc1_].totalFrames)
               {
                  this.ResetEffect(_loc1_);
               }
               if(this.FAchievementEffectBoard[_loc1_].currentFrame == StarAppearFreamIndex)
               {
                  this.FAchievementEffectBoard[_loc1_].gotoAndStop(StarAppearFreamIndex);
                  this.FAchievementEffectStar[_loc1_].play();
               }
            }
            _loc1_++;
         }
      }
      
      protected function StartEffect(param1:int, param2:TAchievementInfor) : void
      {
         this.FAchievementEffectBoard[param1].gotoAndPlay(1);
         this.FAchievementEffectStar[param1].gotoAndStop(1);
         this.FTFAchievementName[param1].text = param2.Name;
         this.FAchievementEffectBoard[param1].visible = true;
         this.FAchievementEffectState[param1] = STATE_BUSY;
      }
      
      protected function ResetEffect(param1:int) : void
      {
         this.FAchievementEffectBoard[param1].gotoAndStop(1);
         this.FAchievementEffectStar[param1].gotoAndStop(1);
         this.FTFAchievementName[param1].text = "";
         this.FAchievementEffectBoard[param1].visible = false;
         this.FAchievementEffectState[param1] = STATE_IDLE;
         this.Update();
      }
      
      protected function SelectIdleEffect() : int
      {
         var _loc1_:int = 0;
         return int(this.FAchievementEffectState.indexOf(STATE_IDLE));
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(SLogicsCore.Character.RoleSencePosition);
         if(_loc2_ == CONST_COMMON.SCENEPOSITION_MAINCITY && this.FAchievementWaitToShow.Count != 0)
         {
            _loc1_ = this.SelectIdleEffect();
            if(_loc1_ != -1)
            {
               this.StartEffect(_loc1_,this.FAchievementWaitToShow.GetAchievementByIndex(0));
               this.FAchievementWaitToShow.DeleteAchievementByIndex(0);
            }
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
      }
      
      public function Show(param1:TAchievementInfor) : void
      {
         this.FAchievementWaitToShow.Add(param1);
         this.Update();
         this.Visible = true;
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
   }
}

