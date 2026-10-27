package Processors.Game.Lobby.GeneralStar
{
   import Components.Slots.*;
   import Components.Standard.TUIButton;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Skills.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class TProcessorWindowSkillUpgrade extends TProcessorLobbyWindow
   {
      
      protected var FScence:MovieClip;
      
      protected var FSkillConfigBin:TBins;
      
      protected var FSoulSkill:TBins;
      
      protected var FConfigValue:TBins;
      
      protected var FInventory:TAppliance;
      
      protected var FUnstreamizerAppliance:TUnstreamizerAppliance;
      
      protected var FSlot:TUISlot;
      
      protected var FBT_Upgrade:TUIButton;
      
      protected var FContext:Object;
      
      protected var FOnUpgrade:Function;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      public function TProcessorWindowSkillUpgrade(param1:TUIComponent)
      {
         super(param1);
         this.FInventory = new TAppliance(0);
         this.FUnstreamizerAppliance = new TUnstreamizerAppliance();
         this.FSlot = new TUISlot(this);
      }
      
      private function SkillUpgradeInit() : void
      {
         var _loc1_:TConfigValue = null;
         this.FScence = TUtilityReflection.CreateDisplayObjectInstance(CONST_GENERAL_STAR.RESOURCESID_CLASSNAME_SKILL_UPGRADE) as MovieClip;
         this.addChild(this.FScence);
         this.FBT_Upgrade = new TUIButton();
         this.FBT_Upgrade.Substrate = this.FScence.mc_upgrade;
         this.FBT_Upgrade.OnClick = this.UpgradeOnClick;
         this.FBT_Upgrade.Enabled = true;
         this.FSkillConfigBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FSoulSkill = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoulSkill);
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         this.FSlot.Resource = this.FScence.iconSlot;
         this.FSlot.OnOver = this.SlotOnOver;
         this.FSlot.OnOut = this.SlotOnOut;
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FSlot.Init();
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SoulSkill_NeedItem) as TConfigValue;
         this.FInventory.IDTemplate = _loc1_.Value as uint;
         this.FUnstreamizerAppliance.UnstreamizeAdditionalDataAppliance(null,this.FInventory,null);
         this.FSlot.Context = this.FInventory;
         this.FScence.close.addEventListener(MouseEvent.CLICK,this.CloseOnClick);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FSlot.Context != null)
         {
            this.FSlot.Update();
         }
      }
      
      private function UpdateText() : void
      {
         var _loc1_:TSoulSkill = null;
         var _loc2_:TSkillConfig = null;
         this.FScence.tf_nowName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_06),this.FContext.Name);
         this.FScence.tf_nowLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_07),this.FContext.Level);
         this.FScence.tf_nowInfo.htmlText = this.FContext.Description.split("%colour%").join(CONST_COMMON.TextColor[2]);
         _loc1_ = this.FSoulSkill.GetDatebaseByIdentifier(this.FContext.NextID) as TSoulSkill;
         if(_loc1_ == null)
         {
            this.FScence.tf_nextName.text = "";
            this.FScence.tf_nextLevel.text = "";
            this.FScence.tf_nextInfo.htmlText = "";
            return;
         }
         _loc2_ = this.FSkillConfigBin.GetDatebaseByIdentifier(this.FContext.NextID) as TSkillConfig;
         this.FScence.tf_nextName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_06),_loc2_.Name);
         this.FScence.tf_nextLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_07),_loc1_.SkillLv);
         this.FScence.tf_nextInfo.htmlText = _loc2_.Desc.split("%colour%").join(CONST_COMMON.TextColor[6]);
      }
      
      private function UpdatePellet() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TConfigValue = null;
         _loc1_ = SLogicsCore.Character.Appliances;
         _loc4_ = uint(_loc1_.Count);
         _loc5_ = 0;
         _loc6_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SoulSkill_NeedItem) as TConfigValue;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc3_);
            if(_loc2_.IDTemplate == _loc6_.Value)
            {
               _loc5_ += _loc2_.Quantity;
            }
            _loc3_++;
         }
         this.FScence.tf_havePellet.text = _loc5_.toString();
         this.FScence.tf_needPellet.text = this.FContext.NeedItem.Amount.toString();
         if(_loc5_ < this.FContext.NeedItem.Amount)
         {
            this.FBT_Upgrade.Enabled = false;
         }
         else
         {
            this.FBT_Upgrade.Enabled = true;
            if(this.FContext.NextID == 0)
            {
               this.FBT_Upgrade.Enabled = false;
            }
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
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
      
      private function CloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      private function UpgradeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnUpgrade != null)
         {
            this.FOnUpgrade(this,this.FContext);
         }
      }
      
      private function SlotOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOut != null)
         {
            this.FOnSlotMouseOut(this,param2);
         }
      }
      
      private function SlotOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOver != null)
         {
            this.FOnSlotMouseOver(this,param2);
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
      }
      
      public function get OnUpgrade() : Function
      {
         return this.FOnUpgrade;
      }
      
      public function set OnUpgrade(param1:Function) : void
      {
         this.FOnUpgrade = param1;
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function SkillUpgrade() : void
      {
         this.SkillUpgradeInit();
      }
      
      public function Update() : void
      {
         this.UpdateText();
         this.UpdatePellet();
      }
   }
}

