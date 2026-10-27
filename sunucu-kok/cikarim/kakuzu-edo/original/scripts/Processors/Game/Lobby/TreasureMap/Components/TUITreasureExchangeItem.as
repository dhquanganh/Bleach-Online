package Processors.Game.Lobby.TreasureMap.Components
{
   import Components.Slots.*;
   import Components.Standard.TUIButton;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.data.*;
   
   public class TUITreasureExchangeItem extends TUIComponent
   {
      
      protected var FMC:MovieClip;
      
      protected var FMC_Slot:MovieClip;
      
      protected var FMC_Star:MovieClip;
      
      protected var FBtn_Exchange:TUIButton;
      
      protected var FTF_ExchangeCount:TextField;
      
      protected var FMC_NeedLevel:MovieClip;
      
      protected var FTF_NeedLv:TextField;
      
      protected var FSlot:TUISlot;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FMall:TMall;
      
      protected var FItemID:int;
      
      protected var FItemTypeArr:Array;
      
      protected var FItemType:int;
      
      protected var FNeedIntegration:uint;
      
      protected var FNeedLevel:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsInitSlot:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnExchange:Function;
      
      public function TUITreasureExchangeItem(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitSlot = false;
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FIDTemplates = new Vector.<uint>();
         this.FCharacter = SLogicsCore.Character;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         addChild(this.FMC);
         this.FMC_Slot = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_MC_Slot];
         this.FMC_Star = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_MC_Star];
         this.FMC_Star.gotoAndStop(1);
         this.FTF_ExchangeCount = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_TF_ExchangeCount];
         this.FMC_NeedLevel = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_MC_NeedLevel];
         this.FMC_NeedLevel.mouseEnabled = false;
         this.FTF_NeedLv = this.FMC_NeedLevel[CONST_TREASUREMAP.RESOURCE_Link_TF_NeedLv];
         this.FBtn_Exchange = new TUIButton();
         this.FBtn_Exchange.Substrate = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_Btn_Exchange];
         this.FBtn_Exchange.OnClick = this.ClickOnExchange;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMC_Slot;
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnOver = this.SlotOnOver;
         this.FSlot.OnOut = this.SlotOnOut;
         this.FSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FSlot.Init();
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         if(this.FMall == null)
         {
            return;
         }
         this.FIDTemplates.length = 0;
         this.FItemID = this.FMall.ItemID;
         this.FIDTemplates.push(this.FItemID);
         this.FItemTypeArr = Json.decode(this.FMall.Type) as Array;
         this.FItemType = this.FItemTypeArr[0];
         this.FNeedIntegration = this.FMall.Integration;
         this.FNeedLevel = this.FMall.Level;
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc3_ = this.FInventories.GetInventoryByIndex(0);
         _loc3_.Quantity = 1;
         this.FSlot.Context = _loc3_;
         this.FIsInitSlot = true;
         if(this.FItemType == 8)
         {
            this.FMC_Star.gotoAndStop(1);
         }
         else if(this.FItemType == 9)
         {
            this.FMC_Star.gotoAndStop(2);
         }
         this.FTF_ExchangeCount.text = this.FNeedIntegration.toString();
         this.CheckLevel();
      }
      
      protected function CheckLevel() : void
      {
         this.FTF_NeedLv.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_42),this.FNeedLevel);
         if(this.FCharacter.GetMainLevel() >= this.FNeedLevel)
         {
            this.FMC_NeedLevel.visible = false;
            this.FBtn_Exchange.Enabled = true;
         }
         else
         {
            this.FMC_NeedLevel.visible = true;
            this.FBtn_Exchange.Enabled = false;
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
      
      protected function ClickOnExchange(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,this.FMall.Identifier,1,this.FItemType,this.FNeedIntegration);
         }
      }
      
      protected function SlotOnOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param1,param2);
         }
      }
      
      protected function SlotOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param1,param2);
         }
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
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
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpData(param1:TMall) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.FMall = param1;
         this.UpdataUI();
      }
      
      public function UpDateSlot() : void
      {
         if(this.FIsInitSlot)
         {
            this.FSlot.Update();
         }
      }
      
      public function Reset() : void
      {
         this.FSlot.Context = null;
         this.FInventories.Clear();
      }
   }
}

