package Processors.Game.Lobby.GeneralStar
{
   import Components.Slots.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Skills.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.GeneralStar.PackageStarPoint.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TProcessorWindowSkill extends TProcessorLobbyWindow
   {
      
      protected var FSkillMC:MovieClip;
      
      protected var FTF_PelletNum:TextField;
      
      protected var FSkills:TUISkills;
      
      protected var FMySkill:MovieClip;
      
      protected var FSlot:TUISlot;
      
      protected var FConfigValue:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FCurSkillPicID:uint;
      
      protected var FMySkillOver:Function;
      
      protected var FMySkillOut:Function;
      
      protected var FOnSkillUpgrade:Function;
      
      protected var FOnBoxClick:Function;
      
      protected var FOnBoxOut:Function;
      
      protected var FOnBoxOver:Function;
      
      public function TProcessorWindowSkill(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FSkillMC = param2;
         this.FCharacter = SLogicsCore.Character;
      }
      
      private function SkillInit() : void
      {
         addChild(this.FSkillMC);
         this.FSkills = new TUISkills(this,this.FSkillMC.mc_skill);
         this.FSkills.OnSkillUpgrade = this.FOnSkillUpgrade;
         this.FSkills.OnBoxClick = this.FOnBoxClick;
         this.FSkills.OnBoxOver = this.FOnBoxOver;
         this.FSkills.OnBoxOut = this.FOnBoxOut;
         this.FSkills.Init();
         this.FTF_PelletNum = this.FSkillMC.tf_pelletNum;
         this.FMySkill = this.FSkillMC.mc_mySkill;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMySkill.icon;
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FSlot.OnOver = this.OnMySkillOver;
         this.FSlot.OnOut = this.OnMySkillOut;
         this.FSlot.Init();
         this.FMC_Effect = this.FSkillMC.MC_Effect;
         this.FMC_Effect.visible = false;
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FSkills.Context != null)
            {
               this.FSkills.UpdateSkills();
            }
            if(this.FSlot.Context != null)
            {
               this.FSlot.Update();
            }
         }
         if(this.FMC_Effect != null)
         {
            if(this.FMC_Effect.currentFrame == this.FMC_Effect.totalFrames)
            {
               this.FMC_Effect.visible = false;
               this.FSkillMC.mouseChildren = true;
               this.FSkillMC.mouseEnabled = true;
            }
         }
      }
      
      private function UpdateSkills() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventory = null;
         var _loc6_:TConfigValue = null;
         this.FSkills.Context = SLogicsCore.Character.Skills;
         this.CheckCurEffect();
         this.FMySkill.tf_skill.text = "Lv." + this.FCharacter.MainHero.Skill.Level + " " + this.FCharacter.MainHero.Skill.Name;
         this.FSlot.Context = this.FCharacter.MainHero.Skill;
         _loc6_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SoulSkill_NeedItem) as TConfigValue;
         _loc1_ = SLogicsCore.Character.Appliances;
         _loc3_ = uint(_loc1_.Count);
         _loc4_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc1_.GetInventoryByIndex(_loc2_);
            if(_loc5_.IDTemplate == _loc6_.Value)
            {
               _loc4_ += _loc5_.Quantity;
            }
            _loc2_++;
         }
         this.FTF_PelletNum.text = _loc4_.toString();
      }
      
      protected function CheckCurEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSkill = null;
         var _loc4_:TSkills = null;
         _loc4_ = SLogicsCore.Character.Skills;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetSkillByIndex(_loc1_);
            if(_loc3_.IDTexture == this.FCurSkillPicID)
            {
               this.FSkills.UpdateCurEffect(_loc1_,true);
            }
            else
            {
               this.FSkills.UpdateCurEffect(_loc1_,false);
            }
            _loc1_++;
         }
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
      
      private function OnMySkillOut(param1:Object, param2:TSkill) : void
      {
         var _loc3_:TSkill = null;
         _loc3_ = param2 as TSkill;
         if(this.FMySkillOut != null)
         {
            this.FMySkillOut(this,_loc3_);
         }
      }
      
      private function OnMySkillOver(param1:Object, param2:TSkill) : void
      {
         var _loc3_:TSkill = null;
         _loc3_ = param2 as TSkill;
         if(this.FMySkillOver != null)
         {
            this.FMySkillOver(this,_loc3_);
         }
      }
      
      public function get MySkillOver() : Function
      {
         return this.FMySkillOver;
      }
      
      public function set MySkillOver(param1:Function) : void
      {
         this.FMySkillOver = param1;
      }
      
      public function get MySkillOut() : Function
      {
         return this.FMySkillOut;
      }
      
      public function set MySkillOut(param1:Function) : void
      {
         this.FMySkillOut = param1;
      }
      
      public function get OnSkillUpgrade() : Function
      {
         return this.FOnSkillUpgrade;
      }
      
      public function set OnSkillUpgrade(param1:Function) : void
      {
         this.FOnSkillUpgrade = param1;
      }
      
      public function get OnBoxClick() : Function
      {
         return this.FOnBoxClick;
      }
      
      public function set OnBoxClick(param1:Function) : void
      {
         this.FOnBoxClick = param1;
      }
      
      public function get OnBoxOut() : Function
      {
         return this.FOnBoxOut;
      }
      
      public function set OnBoxOut(param1:Function) : void
      {
         this.FOnBoxOut = param1;
      }
      
      public function get OnBoxOver() : Function
      {
         return this.FOnBoxOver;
      }
      
      public function set OnBoxOver(param1:Function) : void
      {
         this.FOnBoxOver = param1;
      }
      
      public function Skill() : void
      {
         this.SkillInit();
      }
      
      public function Update() : void
      {
         this.UpdateSkills();
      }
      
      public function UpdateSkillEffect(param1:uint) : void
      {
         this.FCurSkillPicID = param1;
      }
      
      public function PlayEffect() : void
      {
         if(!Visible)
         {
            return;
         }
         this.FSkillMC.mouseChildren = false;
         this.FSkillMC.mouseEnabled = false;
         this.FMC_Effect.visible = true;
         this.FMC_Effect.gotoAndPlay(1);
      }
      
      public function Reset() : void
      {
         this.FSkills.Reset();
         this.FCurSkillPicID = 0;
      }
   }
}

