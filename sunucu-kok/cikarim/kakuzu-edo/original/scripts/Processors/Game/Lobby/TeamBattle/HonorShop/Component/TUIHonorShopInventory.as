package Processors.Game.Lobby.TeamBattle.HonorShop.Component
{
   import Components.Slots.TUISlot;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.HonorShop.THonorShopItem;
   import Logics.Inventories.TInventoryReference;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_HONORSHOP;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_MALL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIHonorShopInventory extends TUIComponent
   {
      
      protected var FScene:Sprite;
      
      protected var FTF_Name:TextField;
      
      protected var FUISlot:TUISlot;
      
      protected var FUICondition:TUIHonorShopOpenCondition;
      
      protected var FMC_PromptBuyOnce:Sprite;
      
      protected var FMC_PromptAlreadyGet:Sprite;
      
      protected var FTF_NeedCount:TextField;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FData:THonorShopItem;
      
      protected var FHonorCount:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FOnSceneClick:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      public function TUIHonorShopInventory(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventoryReference = new TInventoryReference();
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         this.FScene = param1;
         this.FTF_Name = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_Name];
         this.FTF_Name.mouseEnabled = false;
         this.FTF_Name.text = "";
         this.FMC_PromptBuyOnce = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_PromptBuyOnce];
         this.FMC_PromptBuyOnce.mouseChildren = false;
         this.FMC_PromptBuyOnce.mouseEnabled = false;
         this.FMC_PromptBuyOnce.visible = false;
         this.FMC_PromptAlreadyGet = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_PromptAlreadyGet];
         this.FMC_PromptAlreadyGet.mouseChildren = false;
         this.FMC_PromptAlreadyGet.mouseEnabled = false;
         this.FMC_PromptAlreadyGet.visible = false;
         this.FTF_NeedCount = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_NeedCount];
         this.FTF_NeedCount.mouseEnabled = false;
         this.FTF_NeedCount.text = "";
         this.FMC_Bg = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_Bg];
         this.FMC_Bg.gotoAndStop(1);
         this.FScene.addEventListener(MouseEvent.CLICK,this.SceneOnClick);
         this.FScene.addEventListener(MouseEvent.MOUSE_MOVE,this.SceneOnOver);
         this.FScene.addEventListener(MouseEvent.MOUSE_OUT,this.SceneOnOut);
         this.FUICondition = new TUIHonorShopOpenCondition(this);
         this.FUICondition.Perform_UIDispatch(this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_OpenCondition]);
         this.FUICondition.Hide();
         this.FUISlot = new TUISlot(this);
         this.FUISlot.Resource = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnQuerySequenceContext = this.FOnQuerySequenceContext;
         this.FUISlot.OnOver = this.FOnSlotOver;
         this.FUISlot.OnOut = this.FOnSlotOut;
         this.FUISlot.OnQuerySubscript = this.FOnQuerySubscript;
         this.FUISlot.Init();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:Vector.<String> = null;
         this.FTF_Name.text = this.FData.Mall.Name;
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoryByIdentified(null,this.FInventoryReference,this.FData.Mall.ItemID);
         this.FUISlot.Context = this.FInventoryReference.Inventory;
         if(this.FData.Mall.TotalTimes == CONST_MALL.TYPE_TOTALTIMES_Finitude)
         {
            if(this.FData.BoughtCount > 0)
            {
               this.FMC_PromptBuyOnce.visible = false;
               this.FMC_PromptAlreadyGet.visible = true;
            }
            else
            {
               this.FMC_PromptBuyOnce.visible = true;
               this.FMC_PromptAlreadyGet.visible = false;
            }
         }
         else
         {
            this.FMC_PromptBuyOnce.visible = false;
            this.FMC_PromptAlreadyGet.visible = false;
         }
         if(this.FHonorCount < this.FData.Mall.Honour || this.FCharacter.GetMainLevel() < this.FData.Mall.Level)
         {
            _loc1_ = new Vector.<String>(2);
            _loc1_[0] = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_53) + this.FData.Mall.Honour.toString();
            _loc1_[1] = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_54) + this.FData.Mall.Level.toString();
            this.FUICondition.ProcessorUpdateUI(_loc1_);
            this.FUICondition.Show();
            this.FMC_PromptBuyOnce.visible = false;
         }
         else
         {
            this.FUICondition.Clear();
            this.FUICondition.Hide();
         }
         this.FTF_NeedCount.text = this.FData.Mall.Gold.toString();
      }
      
      protected function DoClear() : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FTF_Name.text = "";
         this.FTF_NeedCount.text = "";
         this.FUICondition.Hide();
         this.FUISlot.Context = null;
         this.FInventoryReference.Inventory = null;
         this.FMC_PromptAlreadyGet.visible = false;
         this.FMC_PromptBuyOnce.visible = false;
      }
      
      protected function SceneOnClick(param1:MouseEvent) : void
      {
         if(this.FData.Mall.TotalTimes > 0)
         {
            if(this.FData.BoughtCount >= this.FData.Mall.TotalTimes)
            {
               return;
            }
         }
         if(this.FCharacter.GetMainLevel() < this.FData.Mall.Level || this.FHonorCount < this.FData.Mall.Honour)
         {
            return;
         }
         if(this.FOnSceneClick != null)
         {
            this.FOnSceneClick(this.FData);
         }
      }
      
      protected function SceneOnOver(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(2);
      }
      
      protected function SceneOnOut(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(1);
      }
      
      public function get OnSceneClick() : Function
      {
         return this.FOnSceneClick;
      }
      
      public function set OnSceneClick(param1:Function) : void
      {
         this.FOnSceneClick = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function ProcessorUpdateUI(param1:uint, param2:THonorShopItem) : void
      {
         this.FHonorCount = param1;
         this.FData = param2;
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      public function ProcessorUpdateSlot() : void
      {
         if(this.FUISlot != null)
         {
            this.FUISlot.Update();
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
      
      public function Show() : void
      {
         if(this.FScene != null)
         {
            this.FScene.visible = true;
         }
      }
      
      public function Hide() : void
      {
         if(this.FScene != null)
         {
            this.FScene.visible = false;
         }
      }
   }
}

