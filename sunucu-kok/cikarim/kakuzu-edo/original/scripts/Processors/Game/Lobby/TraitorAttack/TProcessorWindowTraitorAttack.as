package Processors.Game.Lobby.TraitorAttack
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.TraitorAttack.*;
   import Processors.Game.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTraitorAttack extends TProcessorGame
   {
      
      protected static const MaxCount_Family:uint = 3;
      
      protected static const MaxCount_Hero:uint = 10;
      
      protected var FScene:MovieClip;
      
      protected var FUICredits:TUICredits;
      
      protected var FTraitorAttackData:TTraitorAttackData;
      
      protected var FCharacter:TCharacter;
      
      protected var FAttackIndex:uint;
      
      protected var FAttackIndexMax:uint;
      
      protected var FAttackBuff:int;
      
      protected var FAttackNeed:Vector.<uint>;
      
      protected var FHelpTips:THint;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FHelpHintOnOver:Function;
      
      protected var FHelpHintOnOut:Function;
      
      public function TProcessorWindowTraitorAttack(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FHelpTips = new THint();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FCharacter.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TRAITORATTACK)
         {
            this.FUICredits.UpdateEffect();
         }
      }
      
      protected function GetTextColor(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = CONST_COMMON.QUALITYCOLOR_INDEX[6];
               break;
            case 1:
               _loc2_ = CONST_COMMON.QUALITYCOLOR_INDEX[4];
               break;
            case 2:
               _loc2_ = CONST_COMMON.QUALITYCOLOR_INDEX[3];
         }
         return _loc2_;
      }
      
      protected function GetHarmAttackIndex(param1:Number) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FAttackNeed.length)
         {
            if(param1 < this.FAttackNeed[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return _loc2_;
      }
      
      protected function OnHintMove(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_BUFF);
         _loc2_ = _loc2_.split("%lv%").join(this.FAttackIndex * this.FAttackBuff);
         this.FHelpTips.Caption = _loc2_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(param1,this.FHelpTips);
         }
      }
      
      protected function OnHintOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHelpTips);
         }
      }
      
      protected function OnHintActivityDescMove(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_TRAITORATTACK);
         }
         if(this.FHelpHintOnOver != null)
         {
            this.FHelpHintOnOver(this,this.FHelpTips);
         }
      }
      
      protected function OnHintActivityDescOut(param1:MouseEvent) : void
      {
         if(this.FHelpHintOnOut != null)
         {
            this.FHelpHintOnOut(this,this.FHelpTips);
         }
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HelpHintOnOver() : Function
      {
         return this.FHelpHintOnOver;
      }
      
      public function set HelpHintOnOver(param1:Function) : void
      {
         this.FHelpHintOnOver = param1;
      }
      
      public function get HelpHintOnOut() : Function
      {
         return this.FHelpHintOnOut;
      }
      
      public function set HelpHintOnOut(param1:Function) : void
      {
         this.FHelpHintOnOut = param1;
      }
      
      public function SetScene(param1:MovieClip) : void
      {
         this.FScene = param1;
         addChild(this.FScene);
      }
      
      public function InitUI(param1:TTraitorAttackData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:TConfigValue = null;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TraitorAttack_Attackneed) as TConfigValue;
         this.FAttackNeed = _loc6_.Value as Vector.<uint>;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TraitorAttack_Attackbuff) as TConfigValue;
         this.FAttackBuff = _loc6_.Value as int;
         this.FTraitorAttackData = param1;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FScene.MC_PanelCredits;
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.UpdatePanel();
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = this.FScene["mc_Rank_" + _loc4_];
            _loc2_ = this.GetTextColor(_loc4_);
            _loc5_.tf_Name.textColor = _loc2_;
            _loc5_.tf_Damage.textColor = _loc2_;
            _loc4_++;
         }
         this.FScene.mc_activity.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintActivityDescMove);
         this.FScene.mc_activity.addEventListener(MouseEvent.ROLL_OUT,this.OnHintActivityDescOut);
         this.FScene.mc_attackBuff.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintMove);
         this.FScene.mc_attackBuff.addEventListener(MouseEvent.ROLL_OUT,this.OnHintOut);
      }
      
      public function UpdataRankUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:TTraitorAttackRankHero = null;
         var _loc5_:TTraitorAttackRankHeros = null;
         _loc5_ = this.FTraitorAttackData.RankList;
         _loc1_ = 0;
         while(_loc1_ < MaxCount_Hero)
         {
            _loc2_ = this.FScene["mc_Rank_" + _loc1_];
            _loc2_.mouseEnabled = false;
            if(_loc1_ < _loc5_.Count)
            {
               _loc2_.visible = true;
               _loc4_ = _loc5_.GetRankHeroByIndex(_loc1_);
               _loc2_.tf_Name.text = _loc1_ + 1 + ". " + _loc4_.HeroName;
               _loc2_.tf_Damage.text = _loc4_.HeroHarm.ToString();
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc1_++;
         }
         this.FScene.tf_MyDamage.text = String(this.FTraitorAttackData.RankList.MySelfHarm.ToString());
         this.FScene.tf_TotleDamage.text = String(this.FTraitorAttackData.RankList.TotleHarm.ToString());
         this.FAttackIndex = this.GetHarmAttackIndex(this.FTraitorAttackData.RankList.TotleHarm.ToNumber());
         this.FAttackIndexMax = this.FAttackNeed.length;
         if(this.FAttackIndex >= this.FAttackIndexMax)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_MAXBUFF);
         }
         else
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_BUFFTIP);
            _loc3_ = _loc3_.split("%count%").join(this.FAttackNeed[this.FAttackIndex]);
            _loc3_ = _loc3_.split("%lv%").join(this.FAttackBuff * (this.FAttackIndex + 1));
         }
         this.FScene.tf_tips.text = _loc3_;
      }
      
      public function UpdataScoreUI() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < MaxCount_Family)
         {
            this.FScene["tf_BattlePower_" + _loc1_].text = String(this.FTraitorAttackData.ScoreList[_loc1_]);
            _loc1_++;
         }
      }
      
      public function UpdataWave() : void
      {
         var _loc1_:String = null;
         _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_WAVE);
         _loc1_ = _loc1_.split("%count%").join(this.FTraitorAttackData.CurWave);
         this.FScene.tf_Wave.text = _loc1_;
      }
      
      public function UpdataPlayerCountUI() : void
      {
         this.FScene.tf_AllPlayer.text = String(this.FTraitorAttackData.EnterHeroCount);
      }
   }
}

