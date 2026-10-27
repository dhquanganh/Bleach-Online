package Processors.Game.MiniBattle.BattleControl
{
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Map.*;
   import Processors.*;
   import Processors.Game.Battle.GoneWord.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.MiniBattle.Decoder.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Processors.Game.MiniBattle.ScriptAction.*;
   import Resources.Constants.*;
   
   public class TSoldierControl extends TProcessor
   {
      
      protected var FSoldierMe:TBattleSoldierInfor;
      
      protected var FSoldierMeView:TSceneSpriteMoudleInMapBattleRole;
      
      protected var FSoldierEnemy:TBattleSoldierInfor;
      
      protected var FSoldierEnemyView:TSceneSpriteMoudleInMapBattleRole;
      
      protected var FAttrackScripSequence:Vector.<TScriptAction>;
      
      protected var FUnstreamizerScrip:TUnstreamizerScrip;
      
      protected var FScripFrameTime:int;
      
      protected var FScripActionIndex:int;
      
      protected var FAttrackOver:Boolean;
      
      protected var FQueryMoudle:TMoudleInfor;
      
      protected var FAnimationSequnce:Vector.<TSceneSpriteMoudle>;
      
      protected var FDelaySequnce:Vector.<int>;
      
      protected var FOneAttrack:TOneAttrack;
      
      protected var FOnAttrackOver:Function;
      
      public function TSoldierControl(param1:TUIComponent)
      {
         super(param1);
         this.FAttrackScripSequence = new Vector.<TScriptAction>();
         this.FUnstreamizerScrip = new TUnstreamizerScrip();
         this.FQueryMoudle = new TMoudleInfor();
         this.FAnimationSequnce = new Vector.<TSceneSpriteMoudle>();
         this.FDelaySequnce = new Vector.<int>();
         this.FAttrackOver = true;
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:TScriptAction = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FAttrackScripSequence.length <= this.FScripActionIndex + 1)
         {
            if(this.FSoldierMeView.IsNormal && this.FAnimationSequnce.length == 0)
            {
               this.AttrackOver();
            }
         }
         else
         {
            _loc1_ = this.FAttrackScripSequence[this.FScripActionIndex + 1];
            if(_loc1_.TriggerFrameTime <= this.FScripFrameTime)
            {
               _loc1_.SetSoldierInfor(this.FSoldierMe,this.FSoldierMeView,this.FSoldierEnemy,this.FSoldierEnemyView,this.FOneAttrack);
               _loc1_.Trigger();
               ++this.FScripActionIndex;
               this.Update_Perform();
            }
         }
         this.UpdateAnimation();
         this.FScripFrameTime += CONST_COMMON.ElapseTime;
      }
      
      protected function UpdateAnimation() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         _loc1_ = int(this.FAnimationSequnce.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = this.FDelaySequnce[_loc1_];
            if(_loc2_ <= 0)
            {
               this.FAnimationSequnce[_loc1_].UpdateView();
            }
            else
            {
               _loc2_ -= CONST_COMMON.ElapseTime;
               this.FDelaySequnce[_loc1_] = _loc2_;
               if(_loc2_ <= 0)
               {
                  addChild(this.FAnimationSequnce[_loc1_]);
               }
            }
            _loc1_--;
         }
      }
      
      protected function AttrackOver() : void
      {
         this.FAttrackOver = true;
         if(this.FOnAttrackOver != null)
         {
            this.FOnAttrackOver(this);
         }
      }
      
      protected function InitSoldier(param1:TBattleSoldierInfor, param2:TSceneSpriteMoudleInMapBattleRole) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FSoldierMeView.RoleTempleteID = param1.TemplateID;
         if(param1.CampID == CONST_MINIBATTLE.CampType_Friend)
         {
            param2.x = CONST_MINIBATTLE.LeftSoldierScreenX[this.FSoldierMe.Position];
            param2.y = CONST_MINIBATTLE.LeftSoldierScreenY[this.FSoldierMe.Position];
         }
         else
         {
            param2.x = CONST_MINIBATTLE.RightSoldierScreenX[this.FSoldierMe.Position];
            param2.y = CONST_MINIBATTLE.RightSoldierScreenY[this.FSoldierMe.Position];
         }
         param2.OnPlayOver = this.CallBack_AnimationPlayOver;
         param2.BattleStand(this.FSoldierMe.Direction);
         param2.alpha = 1;
         this.FSoldierMeView.visible = true;
         param2.ChangeBloodRate(this.FSoldierMe.CurrentHP / this.FSoldierMe.TotalHP);
         param2.ChangeName(this.FSoldierMe.Name,this.FSoldierMe.Quality);
         this.FSoldierMeView.HideWin();
         this.ResetActionScript();
         this.FUnstreamizerScrip.UnstreamizationScrip(null,this.FAttrackScripSequence,param1);
         _loc4_ = int(this.FAttrackScripSequence.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FAttrackScripSequence[_loc3_].OnPlayAnimation = this.PlayAnimation;
            this.FAttrackScripSequence[_loc3_].OnPlayGoneWorld = this.PlayGoneWord;
            _loc3_++;
         }
      }
      
      protected function PlayAnimation(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc7_:TSceneSpriteMoudle = null;
         _loc7_ = SLogicsCore.PoolMap.AcquireMoudel();
         _loc7_.ChangeRoleMoudle(param1,param4,param6);
         _loc7_.x = param2;
         _loc7_.y = param3;
         _loc7_.OnPlayOver = this.CallBack_AnimationPlayOver;
         this.FAnimationSequnce.push(_loc7_);
         this.FDelaySequnce.push(param5);
         if(param5 == 0)
         {
            addChild(_loc7_);
         }
      }
      
      protected function PlayGoneWord(param1:int, param2:int, param3:String, param4:Number, param5:Number, param6:int, param7:uint) : void
      {
         var _loc8_:TGoneWord = null;
         _loc8_ = TPoolEffectGoneWord.GetGoneWord();
         _loc8_.SetGoneWordWithBg(param1,param2,param3,param4,param5);
         _loc8_.StartFloat();
         addChild(_loc8_);
         this.FSoldierEnemyView.BeAttrack(this.FSoldierEnemy.Direction);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FSoldierMeView != null)
         {
            this.FSoldierMeView.UpdateView();
         }
         if(!this.FAttrackOver)
         {
            this.Update_Perform();
         }
      }
      
      protected function ResetActionScript() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FAttrackScripSequence.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAttrackScripSequence[_loc1_].Reset();
            SLogicsCore.PoolScript.Release(this.FAttrackScripSequence[_loc1_]);
            _loc1_++;
         }
         this.FAttrackScripSequence.length = 0;
      }
      
      protected function CallBack_AnimationPlayOver(param1:TSceneSpriteMoudle) : void
      {
         var _loc2_:int = 0;
         if(param1 == this.FSoldierMeView)
         {
            this.FSoldierMeView.BattleStand(this.FSoldierMe.Direction);
         }
         else
         {
            removeChild(param1);
            _loc2_ = this.FAnimationSequnce.indexOf(param1);
            this.FAnimationSequnce.splice(_loc2_,1);
            this.FDelaySequnce.splice(_loc2_,1);
            param1.Release();
            SLogicsCore.PoolMap.Release(param1);
         }
      }
      
      public function SetBattleSoldier(param1:TBattleSoldierInfor, param2:TBattleSoldierInfor, param3:TSceneSpriteMoudleInMapBattleRole, param4:TSceneSpriteMoudleInMapBattleRole) : void
      {
         this.FSoldierMe = param1;
         this.FSoldierEnemy = param2;
         this.FSoldierMeView = param3;
         this.FSoldierEnemyView = param4;
         this.InitSoldier(this.FSoldierMe,this.FSoldierMeView);
      }
      
      public function set OnAttrackOver(param1:Function) : void
      {
         this.FOnAttrackOver = param1;
      }
      
      public function StartAttrack(param1:TOneAttrack) : void
      {
         this.FOneAttrack = param1;
         this.FScripFrameTime = 0;
         this.FScripActionIndex = -1;
         this.FAttrackOver = false;
         Visible = true;
      }
      
      public function EndAttrack() : void
      {
         this.Reset();
      }
      
      public function Reset() : void
      {
         this.FAttrackOver = true;
         Visible = true;
         this.FScripFrameTime = 0;
         this.FScripActionIndex = 0;
         this.ResetActionScript();
      }
   }
}

