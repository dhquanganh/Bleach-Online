package Processors.Game.Battle.Components
{
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Battle.Character.TRole;
   import Processors.Game.Battle.TBattleHandle;
   import Resources.Constants.CONST_BATTLE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TBigSkill extends TUIComponent
   {
      
      protected var FScene:Sprite;
      
      protected var FBitMap:Bitmap;
      
      protected var FTF_SkillName:TextField;
      
      protected var FMC_Icon:Sprite;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMC_SkillName:MovieClip;
      
      protected var FGameEnd:Boolean;
      
      protected var FCallBack:Function;
      
      public function TBigSkill(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScene = param2;
         this.FGameEnd = false;
         this.BigSkillInit();
      }
      
      protected function BigSkillInit() : void
      {
         var _loc1_:Sprite = null;
         this.FMC_SkillName = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_SkillName];
         _loc1_ = this.FMC_SkillName[CONST_BATTLE.RESOURCE_Link_MC_SkillNameInner];
         this.FTF_SkillName = _loc1_[CONST_BATTLE.RESOURCE_Link_TF_SkillName];
         this.FMC_Effect = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_Effect];
         _loc1_ = this.FMC_Effect[CONST_BATTLE.RESOURCE_Link_MC_IconOut];
         this.FMC_Icon = _loc1_[CONST_BATTLE.RESOURCE_Link_MC_Icon];
         this.FBitMap = new Bitmap();
         this.FMC_Icon.addChild(this.FBitMap);
      }
      
      protected function ShowBigIcon(param1:TRole, param2:uint) : void
      {
         var _loc3_:TResourceRepositoryTexture = null;
         var _loc4_:TTexture = null;
         _loc3_ = SResourcesCore.TexturesLargeIcon;
         _loc4_ = _loc3_.GetTextureByIdentifier(param2);
         if(_loc4_ == null)
         {
            this.HideBigSkill();
            this.PlayBigSkillEffect();
            return;
         }
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(param2,this.AutoLoadCallBack);
         this.FMC_Effect.gotoAndPlay(1);
         this.FMC_SkillName.gotoAndPlay(1);
         this.FMC_Effect.MC_Background.play();
         TBattleHandle.PlaybackTimeout(this.PlayBigSkillEffect,500);
         TBattleHandle.PlaybackTimeout(this.HideBigSkill,1600);
      }
      
      protected function PlayBigSkillEffect() : void
      {
         if(this.FCallBack != null)
         {
            this.FCallBack();
         }
      }
      
      protected function HideBigSkill() : void
      {
         this.FMC_Effect.visible = false;
         this.FScene.visible = false;
         this.FMC_Effect.gotoAndStop(1);
         this.FMC_SkillName.gotoAndStop(1);
         if(this.FGameEnd)
         {
            return;
         }
         this.Reset();
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FBitMap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      public function set SetSkillName(param1:String) : void
      {
         this.FTF_SkillName.text = param1;
      }
      
      public function SetBigIcon(param1:TRole, param2:uint, param3:Function) : void
      {
         this.FCallBack = param3;
         this.ShowBigIcon(param1,param2);
      }
      
      public function set SetEffectVisible(param1:Boolean) : void
      {
         this.FMC_Effect.visible = param1;
         this.FScene.visible = param1;
      }
      
      public function Reset() : void
      {
         if(this.FBitMap.bitmapData != null)
         {
            this.FBitMap.bitmapData = null;
         }
      }
      
      public function SetStatues(param1:Boolean) : void
      {
         this.FGameEnd = param1;
      }
   }
}

