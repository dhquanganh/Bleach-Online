package Processors.Game.Lobby.GeneralStar.PackageStarPoint
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Logics.Skills.TSkill;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlowTwo;
   import Resources.Constants.CONST_GENERAL_STAR;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUISkillBox extends TUIComponent
   {
      
      public static const FFilterColor:int = 16777113;
      
      public static const FilterGlowWidth:int = 4;
      
      public static const FilterGlowStrength:int = 20;
      
      protected var FScence:MovieClip;
      
      protected var FMC_CurEffect:MovieClip;
      
      protected var FSlot:TUISlot;
      
      protected var FInitialization:Boolean;
      
      protected var FGlowsFilter:TEffectBaseGlowTwo;
      
      protected var FBT_Upgrade:TUIButton;
      
      protected var FContext:Object;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnClick:Function;
      
      protected var FOnClickUpgrade:Function;
      
      public function TUISkillBox(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FScence = param2;
         this.FMC_CurEffect = this.FScence[CONST_GENERAL_STAR.RESOURCE_Link_MC_Effect];
         this.FMC_CurEffect.mouseChildren = false;
         this.FMC_CurEffect.mouseEnabled = false;
         this.FMC_CurEffect.stop();
         this.FMC_CurEffect.visible = false;
         this.FGlowsFilter = new TEffectBaseGlowTwo();
      }
      
      private function Initialization() : void
      {
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FScence.icon;
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FSlot.OnOver = this.BoxOnMove;
         this.FSlot.OnOut = this.OnBoxOut;
         this.FSlot.OnClick = this.OnBoxClick;
         this.FSlot.Init();
         this.FScence.lock.mouseChildren = false;
         this.FScence.lock.mouseEnabled = false;
         this.FBT_Upgrade = new TUIButton();
         this.FBT_Upgrade.Substrate = this.FScence.upgrade;
         this.FBT_Upgrade.OnClick = this.UpgradeOnClick;
         this.FBT_Upgrade.Visible = false;
         this.FGlowsFilter.SetParameters(this.FBT_Upgrade.Substrate,FFilterColor,FilterGlowWidth,FilterGlowStrength);
         this.FInitialization = true;
      }
      
      private function UpdateDetail() : void
      {
         if(this.FContext.IsUnlock)
         {
            this.FSlot.SetDefaultFilters(false);
            this.FBT_Upgrade.Visible = true;
            this.FScence.lock.visible = false;
            if(this.FContext.NextID == 0)
            {
               this.FBT_Upgrade.Visible = false;
            }
         }
         else
         {
            this.FSlot.SetDefaultFilters(true);
         }
         this.FScence.skill_name.text = this.FContext.Name;
         this.FScence.skill_level.text = "Lv." + this.FContext.Level.toString();
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TSkill = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TSkill;
         _loc6_ = SResourcesCore.TexturesSkillIcon;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      private function OnBoxClick(param1:Object, param2:TSkill) : void
      {
         var _loc3_:TSkill = null;
         _loc3_ = param2 as TSkill;
         if(!this.FContext.IsUnlock)
         {
            return;
         }
         if(_loc3_.Identifier == SLogicsCore.Character.MainHero.Skill.Identifier)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,_loc3_);
         }
         if(this.FMC_CurEffect.visible)
         {
            this.FMC_CurEffect.stop();
            this.FMC_CurEffect.visible = false;
         }
      }
      
      private function UpgradeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClickUpgrade != null)
         {
            this.FOnClickUpgrade(this,this.FContext);
         }
      }
      
      private function BoxOnMove(param1:Object, param2:TSkill) : void
      {
         var _loc3_:TSkill = null;
         _loc3_ = param2 as TSkill;
         if(this.FOnOver != null)
         {
            this.FOnOver(this,_loc3_);
         }
      }
      
      private function OnBoxOut(param1:Object, param2:TSkill) : void
      {
         var _loc3_:TSkill = null;
         _loc3_ = param2 as TSkill;
         if(this.FOnOut != null)
         {
            this.FOnOut(this,_loc3_);
         }
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         if(param1 is TSkill)
         {
            this.FContext = param1 as TSkill;
         }
         this.FSlot.Context = this.FContext;
         this.UpdateDetail();
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnClickUpgrade() : Function
      {
         return this.FOnClickUpgrade;
      }
      
      public function set OnClickUpgrade(param1:Function) : void
      {
         this.FOnClickUpgrade = param1;
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      public function UpdateSkill() : void
      {
         if(this.FContext == null)
         {
            return;
         }
         this.FSlot.Update();
      }
      
      public function SetLight(param1:Boolean) : void
      {
         if(param1)
         {
            this.FGlowsFilter.Run();
         }
         else
         {
            this.FGlowsFilter.Stop();
         }
      }
      
      public function SetCurEffect(param1:Boolean) : void
      {
         this.FMC_CurEffect.visible = param1;
         if(param1)
         {
            this.FMC_CurEffect.gotoAndPlay(1);
         }
         else
         {
            this.FMC_CurEffect.stop();
         }
      }
      
      public function Reset() : void
      {
         this.FSlot.Context = null;
         if(this.FMC_CurEffect != null)
         {
            this.FMC_CurEffect.stop();
         }
      }
   }
}

