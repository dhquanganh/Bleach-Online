package Processors.Game.Lobby.GirlGame
{
   import Foundation.Movements.TMovementLinear;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.GirlGame.TGirlClothes;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_GIRLGAME;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TProcessorWindowPlayGame extends TProcessorLobbyWindow
   {
      
      protected static const AnswerMaxNum:int = 3;
      
      protected static const MaxGameBarNum:int = 5;
      
      protected static const StarNum:int = 1;
      
      protected static const PonterMinX:int = 35;
      
      protected static const PonterMaxX:int = 490;
      
      protected static const BarWidth:int = 456;
      
      protected static const MoveDuration:int = 500;
      
      protected static const ConfigSpeedID:uint = 60320004;
      
      protected static const MaskSpeed:Number = 0.05;
      
      protected var FMainUI:Sprite;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FTF_Question:TextField;
      
      protected var FAnswerUI:Vector.<Sprite>;
      
      protected var FTFAnswers:Vector.<TextField>;
      
      protected var FTextEffect:MovieClip;
      
      protected var FScoreMask:Sprite;
      
      protected var FMaskTargetScalex:Number;
      
      protected var FScorePointer:Sprite;
      
      protected var FComponentsGameLogics:Vector.<TComponentGameLogic>;
      
      protected var FCurrentGameIndex:int;
      
      protected var FComponentGuideView:TComponentGuideView;
      
      protected var FSpeedVec:Vector.<uint>;
      
      protected var FStarLevels:Vector.<int>;
      
      protected var FXCorrdinate:Vector.<int>;
      
      protected var FYCorrdinate:Vector.<int>;
      
      protected var FTargerX:int;
      
      protected var FTargerY:int;
      
      protected var FCurrentCollectIndex:int;
      
      protected var FAnswerIndex:int;
      
      protected var FFlyElement:MovieClip;
      
      protected var FFlyLittleStar:Vector.<MovieClip>;
      
      protected var FMovementLinear:TMovementLinear;
      
      protected var Flying:Boolean;
      
      protected var FIsShowTextEffect:Boolean;
      
      protected var FTickStore:int;
      
      protected var FClothes:TGirlClothes;
      
      protected var FGameOver:Function;
      
      public function TProcessorWindowPlayGame(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.Flying)
         {
            this.UpdateFly();
         }
         if(this.FIsShowTextEffect)
         {
            this.UpdateTextEffect();
         }
         if(this.FScoreMask.scaleX < this.FMaskTargetScalex)
         {
            this.FScoreMask.scaleX += MaskSpeed;
            if(this.FScoreMask.scaleX > this.FMaskTargetScalex)
            {
               this.FScoreMask.scaleX = this.FMaskTargetScalex;
            }
         }
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc6_:TComponentGameLogic = null;
         var _loc7_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("GameArea") as MovieClip;
         addChild(this.FMainUI);
         this.FPicMountPoint = new Bitmap();
         this.FMainUI["PicMountPoint"].addChild(this.FPicMountPoint);
         this.FTF_Question = this.FMainUI["Question"];
         this.FTextEffect = this.FMainUI["TextEffect"];
         this.FScorePointer = this.FMainUI["ScorePointer"];
         this.FScoreMask = this.FMainUI["GameBarMask"];
         this.FAnswerUI = new Vector.<Sprite>();
         this.FTFAnswers = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc5_ = this.FMainUI["Answer" + _loc1_];
            this.FAnswerUI.push(_loc5_);
            this.FTFAnswers.push(_loc5_["AnswerTF"]);
            _loc1_++;
         }
         this.FComponentsGameLogics = new Vector.<TComponentGameLogic>();
         _loc1_ = 0;
         while(_loc1_ < MaxGameBarNum)
         {
            _loc6_ = new TComponentGameLogic(this);
            _loc6_.OnGameOver = this.CallBack_GameLogic;
            _loc6_.LoadResources(this.FMainUI["GameSlot" + _loc1_]);
            this.FComponentsGameLogics.push(_loc6_);
            _loc1_++;
         }
         this.FComponentGuideView = new TComponentGuideView(this);
         this.FComponentGuideView.LoadResources();
         this.FComponentGuideView.OnUserTapKey = this.CallBack_GuideOver;
         this.FComponentGuideView.X = (this.FMainUI.width - this.FComponentGuideView.width) / 2;
         this.FComponentGuideView.Y = 260;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,ConfigSpeedID) as TConfigValue;
         this.FFlyElement = TUtilityReflection.CreateDisplayObjectInstance("FlyElement") as MovieClip;
         addChild(this.FFlyElement);
         this.FSpeedVec = _loc7_.Value as Vector.<uint>;
         this.FStarLevels = new Vector.<int>();
         this.FXCorrdinate = new Vector.<int>();
         this.FYCorrdinate = new Vector.<int>();
         this.FMovementLinear = new TMovementLinear();
      }
      
      protected function UILocation() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < MaxGameBarNum)
         {
            this.FComponentsGameLogics[_loc1_].Visible = false;
            _loc1_++;
         }
         this.FTargerX = this.FScoreMask.x;
         this.FTargerY = this.FScoreMask.y;
         this.FFlyElement.visible = false;
      }
      
      protected function InitQuestion(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FTF_Question.text = this.FClothes.QuestionTitle;
         this.FTextEffect.visible = false;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(param1,this.CallBack_PicArrive);
         _loc3_ = int(this.FClothes.QuestionAnswers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTFAnswers[_loc2_].text = this.FClothes.QuestionAnswers[_loc2_];
            this.FTFAnswers[_loc2_].textColor = CONST_COMMON.TEXT_Gray_Color;
            _loc2_++;
         }
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function InitExperienceBar() : void
      {
         this.FScoreMask.scaleX = 0;
         this.FMaskTargetScalex = 0;
      }
      
      protected function InitGameBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 40;
         _loc4_ = 10;
         _loc2_ = int(this.FClothes.GameBarScore.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FComponentsGameLogics[_loc1_].Init(_loc3_,_loc4_);
            this.FComponentsGameLogics[_loc1_].Visible = true;
            _loc1_++;
         }
         _loc2_ = int(this.FComponentsGameLogics.length);
         while(_loc1_ < _loc2_)
         {
            this.FComponentsGameLogics[_loc1_].Visible = false;
            _loc1_++;
         }
      }
      
      protected function StartGame() : void
      {
         this.FComponentGuideView.Visible = true;
         this.FComponentGuideView.StartGuide();
      }
      
      protected function CallBack_GuideOver(param1:Object) : void
      {
         this.FComponentGuideView.Visible = false;
         this.NextGame();
      }
      
      protected function NextGame() : void
      {
         var _loc1_:TComponentGameLogic = null;
         _loc1_ = this.FComponentsGameLogics[this.FClothes.CurrentSchedule];
         _loc1_.Visible = true;
         _loc1_.Run(this.FSpeedVec[this.FClothes.CurrentSchedule]);
      }
      
      protected function CallBack_GameLogic(param1:int, param2:int, param3:int) : void
      {
         this.FStarLevels.push(param1);
         this.FXCorrdinate.push(param2);
         this.FYCorrdinate.push(param3);
         if(this.CheckIfGameSuccess(param1))
         {
            ++this.FClothes.CurrentSchedule;
            if(this.FClothes.CurrentSchedule < this.FClothes.TotalSchedule)
            {
               this.NextGame();
            }
            else
            {
               this.FCurrentCollectIndex = 0;
               this.StartAccount();
            }
         }
         else
         {
            this.BackResult(0,false);
         }
      }
      
      protected function CheckIfGameSuccess(param1:int) : Boolean
      {
         return param1 != CONST_GIRLGAME.StartLevel_Oops;
      }
      
      protected function StartAccount() : void
      {
         if(this.FCurrentCollectIndex >= this.FClothes.TotalSchedule)
         {
            this.Flying = false;
            this.ShowTextEffect();
         }
         else
         {
            this.FTargerX = this.FScoreMask.x + this.FScoreMask.width + 20;
            this.FMovementLinear.SetupSegmentByDuration(this.FTargerX,this.FTargerY,this.FXCorrdinate[this.FCurrentCollectIndex],this.FYCorrdinate[this.FCurrentCollectIndex],MoveDuration);
            this.FFlyElement.x = this.FXCorrdinate[this.FCurrentCollectIndex];
            this.FFlyElement.y = this.FYCorrdinate[this.FCurrentCollectIndex];
            this.FFlyElement.visible = true;
            this.FTickStore = 0;
            this.Flying = true;
         }
      }
      
      protected function SetupLittleStars(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FFlyLittleStar.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1)
            {
               this.FFlyLittleStar[_loc2_].play();
            }
            else
            {
               this.FFlyLittleStar[_loc2_].stop();
            }
            _loc2_++;
         }
      }
      
      protected function UpdateFly() : void
      {
         if(this.FMovementLinear.MoveOver)
         {
            this.UpdateScoreBar();
            this.FFlyElement.visible = false;
            ++this.FCurrentCollectIndex;
            this.StartAccount();
         }
         this.FMovementLinear.Move(this.FTickStore);
         this.FFlyElement.x = this.FMovementLinear.X;
         this.FFlyElement.y = this.FMovementLinear.Y;
         this.FTickStore += CONST_COMMON.SIZE_FrameRatePerSecond;
      }
      
      protected function UpdateScoreBar() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FStarLevels[this.FCurrentCollectIndex];
         this.FClothes.CurrentScore += this.FClothes.GameBarScore[this.FCurrentCollectIndex][_loc1_];
         this.FMaskTargetScalex = this.FClothes.CurrentScore / 100;
      }
      
      protected function ShowTextEffect() : void
      {
         this.FTextEffect.visible = true;
         this.FTextEffect.y = this.SelectGameAnswerY();
         this.FTextEffect.gotoAndPlay(1);
         this.FIsShowTextEffect = true;
      }
      
      protected function UpdateTextEffect() : void
      {
         if(this.FTextEffect.currentFrame == this.FTextEffect.totalFrames)
         {
            this.FIsShowTextEffect = false;
            this.BackResult(this.FClothes.CurrentScore,true);
         }
      }
      
      protected function GetGameAnswerIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = int(this.FStarLevels.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FStarLevels[_loc1_];
            if(_loc3_ == CONST_GIRLGAME.StartLevel_Oops)
            {
               return 0;
            }
            _loc4_ += _loc3_;
            _loc1_++;
         }
         if(_loc4_ == CONST_GIRLGAME.StartLevel_Perfect)
         {
            return 2;
         }
         return 1;
      }
      
      protected function SelectGameAnswerY() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(this.FStarLevels.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FStarLevels[_loc1_];
            if(_loc3_ == CONST_GIRLGAME.StartLevel_Good)
            {
               this.FTFAnswers[1].textColor = CONST_COMMON.TEXT_Yellow_Color;
               this.FAnswerIndex = 1;
               return this.FAnswerUI[this.FAnswerIndex].y;
            }
            _loc1_++;
         }
         this.FAnswerIndex = 2;
         this.FTFAnswers[2].textColor = CONST_COMMON.TEXT_Yellow_Color;
         return this.FAnswerUI[this.FAnswerIndex].y;
      }
      
      protected function BackResult(param1:uint, param2:Boolean) : void
      {
         if(this.FGameOver != null)
         {
            this.FGameOver(param1,this.GetGameAnswerIndex(),param2);
         }
         this.Visible = false;
      }
      
      public function set GameOver(param1:Function) : void
      {
         this.FGameOver = param1;
      }
      
      public function LoadResources() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function PlayGame(param1:int, param2:TGirlClothes) : void
      {
         this.FClothes = param2;
         this.FClothes.CurrentScore = 0;
         this.FClothes.CurrentSchedule = 0;
         this.FStarLevels.length = 0;
         this.FXCorrdinate.length = 0;
         this.FYCorrdinate.length = 0;
         this.FCurrentGameIndex = 0;
         this.InitQuestion(param1);
         this.InitExperienceBar();
         this.InitGameBar();
         this.StartGame();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FComponentGuideView.Reset();
         _loc2_ = int(this.FComponentsGameLogics.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FComponentsGameLogics[_loc1_].Reset();
            _loc1_++;
         }
         this.FPicMountPoint.bitmapData = null;
      }
   }
}

