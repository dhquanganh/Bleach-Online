package Processors.Game.Lobby.SevenKing.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.SLogicsCore;
   import Logics.Vip.TVip;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TBigPillar extends TPillar
   {
      
      public static const MONSTER_NUM:uint = 3;
      
      public static const COUNT_PRACTICE:uint = 1;
      
      public static const COUNT_ONEPRACTICE:uint = 10;
      
      public static const STATE_PASSED:uint = 1;
      
      public static const STATE_FRIGHTING:uint = 2;
      
      public static const STATE_UNOPENED:uint = 3;
      
      protected var FMC_Monster:Sprite;
      
      protected var FMonsterButtons:Vector.<TUIButton>;
      
      protected var FMarks:Vector.<MovieClip>;
      
      protected var FMC_Practice:Sprite;
      
      protected var FBT_Practice:TUIButton;
      
      protected var FBT_OnePractice:TUIButton;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FMC_HightLight:MovieClip;
      
      protected var FMC_Yellow:MovieClip;
      
      protected var FOnMonsterClick:Function;
      
      protected var FOnPracticeClick:Function;
      
      protected var FOnPracticeMove:Function;
      
      protected var FOnPracticeOut:Function;
      
      protected var FProgressing:uint;
      
      protected var FPracticeCount:uint;
      
      public function TBigPillar(param1:TUIComponent)
      {
         super(param1);
         this.FMonsterButtons = new Vector.<TUIButton>(MONSTER_NUM);
         this.FMarks = new Vector.<MovieClip>(MONSTER_NUM);
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
      }
      
      override protected function UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:MovieClip = null;
         super.UIDispatch();
         this.FMC_Monster = FScence["MC_Monster"];
         this.FMC_Monster.mouseEnabled = false;
         this.FMC_Monster.visible = false;
         _loc2_ = MONSTER_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = this.FMC_Monster["MC_Head_" + _loc1_];
            _loc3_.OnClick = this.MonsterOnClick;
            this.FMonsterButtons[_loc1_] = _loc3_;
            _loc4_ = this.FMC_Monster["MC_Mark_" + _loc1_];
            _loc4_.visible = false;
            this.FMarks[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FMC_Practice = FScence["MC_Practice"];
         this.FMC_Practice.visible = false;
         this.FBT_Practice = new TUIButton();
         this.FBT_Practice.Substrate = this.FMC_Practice["BT_Practice"];
         this.FBT_Practice.OnClick = this.PracticeOnClick;
         this.FBT_Practice.OnMove = this.PracticeOnMove;
         this.FBT_Practice.OnOut = this.PracticeOnOut;
         this.FBT_OnePractice = new TUIButton();
         this.FBT_OnePractice.Substrate = this.FMC_Practice["BT_OnePractice"];
         this.FBT_OnePractice.OnClick = this.PracticeOnClick;
         this.FBT_OnePractice.OnMove = this.PracticeOnMove;
         this.FBT_OnePractice.OnOut = this.PracticeOnOut;
         this.FMC_HightLight = FScence["MC_HightLight"];
         this.FMC_HightLight.stop();
         this.FMC_Yellow = FScence["MC_Yellow"];
         this.FMC_Yellow.stop();
      }
      
      protected function UpdatePillarState(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         switch(param1)
         {
            case STATE_PASSED:
               this.FMC_Practice.visible = true;
               this.FMC_Monster.visible = false;
               if(this.FVipData.SevenHeroOneKey)
               {
                  this.FBT_OnePractice.Enabled = true;
               }
               else
               {
                  this.FBT_OnePractice.Enabled = false;
               }
               this.SetPracticeState();
               break;
            case STATE_FRIGHTING:
               this.FMC_Practice.visible = false;
               this.FMC_Monster.visible = true;
               _loc3_ = MONSTER_NUM;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  if(_loc2_ < this.FProgressing - 1)
                  {
                     this.FMonsterButtons[_loc2_].Enabled = false;
                     this.FMarks[_loc2_].visible = true;
                  }
                  else if(_loc2_ == this.FProgressing - 1)
                  {
                     this.FMonsterButtons[_loc2_].Enabled = true;
                     this.FMarks[_loc2_].visible = false;
                  }
                  else
                  {
                     this.FMonsterButtons[_loc2_].Enabled = false;
                     this.FMarks[_loc2_].visible = false;
                  }
                  _loc2_++;
               }
               break;
            case STATE_UNOPENED:
               this.FMC_Practice.visible = false;
               this.FMC_Monster.visible = false;
         }
      }
      
      protected function SetPracticeState() : void
      {
         if(this.FVipData.SevenHeroOneKey)
         {
            this.FBT_OnePractice.Enabled = true;
         }
         else
         {
            this.FBT_OnePractice.Enabled = false;
         }
      }
      
      protected function MonsterOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         _loc4_ = param1 as TUIButton;
         _loc3_ = this.FMonsterButtons.indexOf(_loc4_);
         if(this.FOnMonsterClick != null)
         {
            this.FOnMonsterClick(this,_loc3_);
         }
      }
      
      protected function PracticeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:uint = 0;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBT_Practice:
               _loc4_ = COUNT_PRACTICE;
               break;
            case this.FBT_OnePractice:
               _loc4_ = COUNT_ONEPRACTICE;
         }
         if(this.FOnPracticeClick != null)
         {
            this.FOnPracticeClick(this,Tag,_loc4_);
         }
      }
      
      protected function PracticeOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:uint = 0;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBT_Practice:
               _loc4_ = COUNT_PRACTICE;
               break;
            case this.FBT_OnePractice:
               _loc4_ = COUNT_ONEPRACTICE;
         }
         if(this.FOnPracticeMove != null)
         {
            this.FOnPracticeMove(this,Tag,_loc4_);
         }
      }
      
      protected function PracticeOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnPracticeOut != null)
         {
            this.FOnPracticeOut(this);
         }
      }
      
      public function get OnMonsterClick() : Function
      {
         return this.FOnMonsterClick;
      }
      
      public function set OnMonsterClick(param1:Function) : void
      {
         this.FOnMonsterClick = param1;
      }
      
      public function get OnPracticeClick() : Function
      {
         return this.FOnPracticeClick;
      }
      
      public function set OnPracticeClick(param1:Function) : void
      {
         this.FOnPracticeClick = param1;
      }
      
      public function get OnPracticeMove() : Function
      {
         return this.FOnPracticeMove;
      }
      
      public function set OnPracticeMove(param1:Function) : void
      {
         this.FOnPracticeMove = param1;
      }
      
      public function get OnPracticeOut() : Function
      {
         return this.FOnPracticeOut;
      }
      
      public function set OnPracticeOut(param1:Function) : void
      {
         this.FOnPracticeOut = param1;
      }
      
      public function get Progressing() : uint
      {
         return this.FProgressing;
      }
      
      public function set Progressing(param1:uint) : void
      {
         this.FProgressing = param1;
      }
      
      public function get PracticeCount() : uint
      {
         return this.FPracticeCount;
      }
      
      public function set PracticeCount(param1:uint) : void
      {
         this.FPracticeCount = param1;
      }
      
      public function UpdateState(param1:uint) : void
      {
         this.UpdatePillarState(param1);
      }
      
      public function PlayEffect(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.visible)
            {
               this.FMC_HightLight.play();
               this.FMC_Yellow.play();
               this.FMC_HightLight.visible = true;
               this.FMC_Yellow.visible = true;
            }
            else
            {
               this.FMC_HightLight.stop();
               this.FMC_Yellow.stop();
               this.FMC_HightLight.visible = false;
               this.FMC_Yellow.visible = false;
            }
         }
         else
         {
            this.FMC_HightLight.stop();
            this.FMC_Yellow.stop();
            this.FMC_HightLight.visible = false;
            this.FMC_Yellow.visible = false;
         }
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FMC_HightLight.stop();
      }
   }
}

