package Processors.Game.Lobby.TeamBattle.HonorShop
{
   import Components.Pages.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.HonorShop.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.HonorShop.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   
   public class TProcessorWindowInventory extends TProcessorLobbyWindow
   {
      
      protected static const MAX_COUNT_Slot:uint = 12;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FScene:Sprite;
      
      protected var FUIInventoryVect:Vector.<TUIHonorShopInventory>;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FDataHonorShop:THonorShopData;
      
      protected var FDataInventory:Vector.<THonorShopItem>;
      
      protected var FHonorShopItem:THonorShopItem;
      
      protected var FCharacter:TCharacter;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FOnExchange:Function;
      
      public function TProcessorWindowInventory(param1:TUIComponent)
      {
         super(param1);
         this.FPageIndex = 0;
         this.FCharacter = SLogicsCore.Character;
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FScene.visible)
         {
            return;
         }
         if(this.FUIInventoryVect != null && this.FUIInventoryVect.length > 0)
         {
            _loc2_ = int(MAX_COUNT_Slot);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUIInventoryVect[_loc1_].ProcessorUpdateSlot();
               _loc1_++;
            }
         }
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIHonorShopInventory = null;
         this.FScene = param1;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_PageRight];
         this.FUIPage.LabelPage = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_Page];
         this.FUIPage.PageSize = MAX_COUNT_Slot;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         _loc3_ = int(MAX_COUNT_Slot);
         this.FUIInventoryVect = new Vector.<TUIHonorShopInventory>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIHonorShopInventory(this);
            _loc4_.OnSceneClick = this.ProcessorOnInventoryClick;
            _loc4_.OnSlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnSlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc4_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc4_.Perform_UIDispatch(this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_SlotVect + _loc2_]);
            _loc4_.Hide();
            this.FUIInventoryVect[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(MAX_COUNT_Slot);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPageIndex * MAX_COUNT_Slot + _loc1_;
            if(_loc3_ < this.FDataInventory.length)
            {
               this.FUIInventoryVect[_loc1_].ProcessorUpdateUI(this.FDataHonorShop.HonorCount,this.FDataInventory[_loc3_]);
               this.FUIInventoryVect[_loc1_].Show();
            }
            else
            {
               this.FUIInventoryVect[_loc1_].Clear();
               this.FUIInventoryVect[_loc1_].Hide();
            }
            _loc1_++;
         }
         this.UpdateUIPage();
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUIPage.TotalQuantity = this.FDataInventory.length;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FUIInventoryVect != null && this.FUIInventoryVect.length > 0)
         {
            _loc2_ = int(this.FUIInventoryVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUIInventoryVect[_loc1_].Clear();
               _loc1_++;
            }
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         if(this.FPageIndex == param2)
         {
            return;
         }
         this.FPageIndex = param2;
         this.UpdateUI();
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         var _loc2_:TPurchaseRequest = null;
         _loc2_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc2_.IDTemplate = this.FHonorShopItem.Mall.Identifier;
         _loc2_.Quantity = 1;
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,_loc2_,this.FPurchaseParameters);
         }
      }
      
      protected function WindowInformationOnCancel(param1:Object) : void
      {
         this.FHonorShopItem = null;
      }
      
      protected function ProcessorOnInventoryClick(param1:THonorShopItem) : void
      {
         this.FHonorShopItem = param1;
         if(this.FDataHonorShop.CanBuyCount <= 0)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_57));
            }
            return;
         }
         if(this.FCharacter.CreditGold >= this.FHonorShopItem.Mall.Gold || this.FCharacter.CreditGiftCertificate >= this.FHonorShopItem.Mall.Gold)
         {
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_60),this.FHonorShopItem.Mall.Gold);
            this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.FUIWindowRecharge.SetGoldNum(this.FHonorShopItem.Mall.Gold);
            this.FUIWindowRecharge.Visible = true;
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
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function ProcessorUpdateUI(param1:THonorShopData) : void
      {
         this.FDataHonorShop = param1;
         this.FDataInventory = this.FDataHonorShop.InventoryItems;
         if(this.FScene.visible)
         {
            this.UpdateUI();
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
      
      public function Show() : void
      {
         this.FScene.visible = true;
      }
      
      public function Hide() : void
      {
         this.FScene.visible = false;
      }
   }
}

