package Processors.Game.Lobby.CrashJade
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.CrashJade.TCrashJadeShopItemVO;
   import Logics.Inventories.TCrashJade;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TCrashJadeShopItem
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TCrashJadeShopItemVO;
      
      protected var FSlot:TUISlot;
      
      protected var FExchangeBtn:TUIButton;
      
      protected var FParent:TUIComponent;
      
      protected var FOnExchange:Function;
      
      public function TCrashJadeShopItem(param1:TUIComponent)
      {
         super();
         this.FParent = param1;
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TCrashJade = null;
         if(param2 is TCrashJade)
         {
            _loc4_ = param2 as TCrashJade;
            param3.Value = 1;
         }
      }
      
      protected function OnExchangeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnExchange(this.FData,this.FData.Mall.Identifier,1,this.FData.Mall.Items.Amount);
      }
      
      public function UIDispose(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FSlot = new TUISlot(this.FParent);
         this.FSlot.Resource = this.FMainUI.Slot;
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.OnQuerySubscript = null;
         this.FSlot.Init();
         this.FExchangeBtn = new TUIButton();
         this.FExchangeBtn.Substrate = this.FMainUI.Btn_Exchange;
         this.FExchangeBtn.OnClick = this.OnExchangeBtnClick;
      }
      
      public function LogicsPerform() : void
      {
         if(this.FSlot != null)
         {
            this.FSlot.Update();
         }
      }
      
      public function set Data(param1:TCrashJadeShopItemVO) : void
      {
         this.FData = param1;
         this.UpdateUI();
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function Show() : void
      {
         this.FMainUI.visible = true;
      }
      
      public function Hide() : void
      {
         this.FMainUI.visible = false;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         this.FSlot.Context = this.FData.Inventory;
         if(this.FData.Inventory is TCrashJade)
         {
            this.FSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier((this.FData.Inventory as TCrashJade).EffectID);
         }
         else
         {
            this.FSlot.TextureAdvancedEffect = null;
         }
         this.FMainUI.Txt_Value.text = this.FData.Mall.Items.Amount.toString();
         if(this.FData.Mall.Times == 0 && this.FData.Mall.TotalTimes == 0)
         {
            this.FExchangeBtn.Enabled = true;
            this.FMainUI.MC_ExchangeFinish.visible = false;
         }
         else
         {
            _loc1_ = this.FData.Mall.Times != 0 ? uint(this.FData.Mall.Times) : this.FData.Mall.TotalTimes;
            if(this.FData.BuyCont >= _loc1_)
            {
               this.FExchangeBtn.Enabled = false;
               this.FMainUI.MC_ExchangeFinish.visible = true;
            }
            else
            {
               this.FExchangeBtn.Enabled = true;
               this.FMainUI.MC_ExchangeFinish.visible = false;
            }
         }
      }
   }
}

