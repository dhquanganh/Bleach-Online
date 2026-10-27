package Processors.Game.Lobby.Sign.Components
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Inventories.TInventory;
   import Logics.Inventories.TInventorySample;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DAILYSIGN;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIIntegralItem extends TUIComponent
   {
      
      protected var FMC_IntegralItem:MovieClip;
      
      protected var FMC_Lock:MovieClip;
      
      protected var FMC_Slot:TUISlot;
      
      protected var FTF_Integral:TextField;
      
      protected var FBTN_Exchange:TUIButton;
      
      protected var FMC_Level:MovieClip;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_VIP:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FInventorySample:TInventorySample;
      
      protected var FResource:Sprite;
      
      protected var FOnExchange:Function;
      
      protected var FDownHintOnOver:Function;
      
      protected var FDownHintOnOut:Function;
      
      public function TUIIntegralItem(param1:TUIComponent)
      {
         super(param1);
         this.FMC_Slot = new TUISlot(this);
      }
      
      protected function UIDispatch() : void
      {
         this.FMC_IntegralItem = this.FResource as MovieClip;
         this.FMC_Lock = this.FMC_IntegralItem[CONST_DAILYSIGN.RESOURCE_Link_MC_Lock];
         this.FMC_Lock.mouseEnabled = false;
         this.FMC_Lock.visible = false;
         this.FTF_Integral = this.FMC_IntegralItem[CONST_DAILYSIGN.RESOURCE_Link_TF_Integral];
         this.FBTN_Exchange = new TUIButton();
         this.FBTN_Exchange.Substrate = this.FMC_IntegralItem[CONST_DAILYSIGN.RESOURCE_Link_BTN_Exchange];
         this.FBTN_Exchange.OnClick = this.ExchangeOnClick;
         this.FMC_Level = this.FMC_IntegralItem[CONST_DAILYSIGN.RESOURCE_Link_MC_Level];
         this.FTF_Level = this.FMC_Level[CONST_DAILYSIGN.RESOURCE_Link_TF_Level];
         this.FTF_VIP = this.FMC_Level[CONST_DAILYSIGN.RESOURCE_Link_TF_VIP];
         this.FTF_Name = this.FMC_IntegralItem[CONST_DAILYSIGN.RESOURCE_Link_TF_Name];
         this.FMC_Slot.Resource = this.FMC_IntegralItem[CONST_DAILYSIGN.RESOURCE_Link_MC_Slot];
         this.FMC_Slot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_Slot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FMC_Slot.OnOver = this.UIDownHintOnOver;
         this.FMC_Slot.OnOut = this.UIDownHintOnOut;
         this.FMC_Slot.Init();
      }
      
      protected function UpdateItemInfo() : void
      {
         if(SLogicsCore.Character.GetMainLevel() >= this.FInventorySample.UnlockLevel)
         {
            if(this.FInventorySample.IsVip)
            {
               if(SLogicsCore.Character.VipLevel > 0)
               {
                  this.FTF_Level.visible = false;
                  this.FTF_VIP.visible = false;
                  this.FBTN_Exchange.Visible = true;
               }
               else
               {
                  this.FTF_Level.visible = false;
                  this.FTF_VIP.visible = true;
                  this.FBTN_Exchange.Visible = false;
               }
            }
            else
            {
               this.FTF_Level.visible = false;
               this.FTF_VIP.visible = false;
               this.FBTN_Exchange.Visible = true;
            }
         }
         else if(this.FInventorySample.IsVip)
         {
            if(SLogicsCore.Character.VipLevel > 0)
            {
               this.FTF_Level.visible = true;
               this.FTF_VIP.visible = false;
               this.FBTN_Exchange.Visible = false;
            }
            else
            {
               this.FTF_Level.visible = true;
               this.FTF_VIP.visible = true;
               this.FBTN_Exchange.Visible = false;
            }
         }
         else
         {
            this.FTF_Level.visible = true;
            this.FTF_VIP.visible = false;
            this.FBTN_Exchange.Visible = false;
         }
         this.FTF_Integral.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_11),this.FInventorySample.Integration);
         this.FTF_Name.text = this.FInventorySample.Name;
         this.FTF_Name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FInventorySample.Inventory.Quality];
         this.UpdateExchange();
      }
      
      protected function UpdateExchange() : void
      {
         if(SLogicsCore.Character.CreditIntegral >= this.FInventorySample.Integration)
         {
            this.FBTN_Exchange.Enabled = true;
         }
         else
         {
            this.FBTN_Exchange.Enabled = false;
         }
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_10),this.FInventorySample.UnlockLevel);
      }
      
      protected function UpdateSlotInfo() : void
      {
         this.FMC_Slot.Context = this.FInventorySample.Inventory;
      }
      
      protected function ExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,this.FInventorySample);
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
      
      protected function UIDownHintOnOver(param1:Object, param2:Object) : void
      {
         if(this.FDownHintOnOver != null)
         {
            this.FDownHintOnOver(this,param2);
         }
      }
      
      protected function UIDownHintOnOut(param1:Object, param2:Object) : void
      {
         if(this.FDownHintOnOut != null)
         {
            this.FDownHintOnOut(this,param2);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function get DownHintOnOver() : Function
      {
         return this.FDownHintOnOver;
      }
      
      public function set DownHintOnOver(param1:Function) : void
      {
         this.FDownHintOnOver = param1;
      }
      
      public function get DownHintOnOut() : Function
      {
         return this.FDownHintOnOut;
      }
      
      public function set DownHintOnOut(param1:Function) : void
      {
         this.FDownHintOnOut = param1;
      }
      
      public function Init() : void
      {
         this.UIDispatch();
      }
      
      public function SetItemInfo(param1:TInventorySample) : void
      {
         this.FInventorySample = param1;
         this.UpdateItemInfo();
         this.UpdateSlotInfo();
      }
      
      public function UpdateSlot() : void
      {
         if(this.FMC_Slot != null)
         {
            this.FMC_Slot.Update();
         }
      }
      
      public function Reset() : void
      {
         this.FMC_Slot.Context = null;
         this.FInventorySample = null;
      }
   }
}

