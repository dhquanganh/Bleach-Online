package Processors.Game.Lobby.TeamBattle.HonorShop
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HonorShop.*;
   import Logics.Inventories.*;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.SLogicsCore;
   import Logics.Streamization.HonorShop.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHonorShop extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_WindowHonorShop:int = 889;
      
      protected static const SIZE_HEIGHT_WindowHonorShop:int = 471;
      
      protected static const COUNT_Animation:uint = 2;
      
      protected static const COUNT_Tab:uint = 2;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const WINDOW_INDEX_Inventory:uint = 0;
      
      public static const WINDOW_INDEX_Hero:uint = 1;
      
      protected var FScene:Sprite;
      
      protected var FMC_MainInventory:Sprite;
      
      protected var FMC_MainHero:Sprite;
      
      protected var FAnimationVect:Vector.<MovieClip>;
      
      protected var FUITab:TUITab;
      
      protected var FBtnClose:TUIButton;
      
      protected var FTF_HonorCount:TextField;
      
      protected var FTF_BoughtCount:TextField;
      
      protected var FTF_Prompt:TextField;
      
      protected var FBounds:TBounds;
      
      protected var FProcessorWindowInventory:TProcessorWindowInventory;
      
      protected var FProcessorWindowHero:TProcessorWindowHero;
      
      protected var FTabPageIndex:int;
      
      protected var FMallBins:TBins;
      
      protected var FConfigValueBins:TBins;
      
      protected var FDataHonorShop:THonorShopData;
      
      protected var FUnstreamizerHonorShop:TUnstreamizerHonorShop;
      
      protected var FConfigValue:TConfigValue;
      
      protected var FOnPurchase:Function;
      
      protected var FOnReturnTeamBattleChoose:Function;
      
      public function TProcessorHonorShop(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_WIDTH_WindowHonorShop;
         this.FBounds.Height = SIZE_HEIGHT_WindowHonorShop;
         ComponentBoundsCenter(this,this.FBounds);
         this.FTabPageIndex = WINDOW_INDEX_Inventory;
         this.FDataHonorShop = new THonorShopData();
         this.FUnstreamizerHonorShop = new TUnstreamizerHonorShop();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HONORSHOP.RESOURCESID_ActivityMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitWindow();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_HonorShopRet,this.PacketPerform_SC_HonorShopRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_HonorShopNotify,this.PacketPerform_SC_HonorShopNotify);
      }
      
      protected function PacketPerform_SC_HonorShopRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ > 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerHonorShop.UnstreamizeHonorShopInit(_loc2_,this.FDataHonorShop,null);
         this.ProcessorShowWindow(WINDOW_INDEX_Inventory);
         this.UpdateUI();
      }
      
      protected function PacketPerform_SC_HonorShopNotify(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerHonorShop.UnstreamizerHonorShopNotify(_loc2_,this.FDataHonorShop,null);
         if(this.FTabPageIndex == WINDOW_INDEX_Inventory)
         {
            this.FProcessorWindowInventory.ProcessorUpdateUI(this.FDataHonorShop);
         }
         else if(this.FTabPageIndex == WINDOW_INDEX_Hero)
         {
            this.FProcessorWindowHero.ProcessorUpdateUI(this.FDataHonorShop);
         }
         this.UpdateUI();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_HONORSHOP.RESOURCE_ClassName_HonorShopWindow) as Sprite;
         addChild(this.FScene);
         this.FTF_BoughtCount = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_BoughtCount];
         this.FTF_BoughtCount.mouseEnabled = false;
         this.FTF_BoughtCount.text = "";
         this.FTF_Prompt = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_Prompt];
         this.FTF_Prompt.mouseEnabled = false;
         this.FTF_Prompt.text = "";
         this.FMC_MainInventory = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_MainInventory];
         this.FProcessorWindowInventory = new TProcessorWindowInventory(this);
         this.FProcessorWindowInventory.OnEffectText = FOnEffectText;
         this.FProcessorWindowInventory.OnExchange = this.ProcessorOnExchange;
         this.FProcessorWindowInventory.Perform_UIDispatch(this.FMC_MainInventory);
         this.FProcessorWindowInventory.Hide();
         this.FMC_MainHero = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_MainHero];
         this.FProcessorWindowHero = new TProcessorWindowHero(this);
         this.FProcessorWindowHero.OnEffectText = FOnEffectText;
         this.FProcessorWindowHero.OnExchange = this.ProcessorOnExchange;
         this.FProcessorWindowHero.Perform_UIDispatch(this.FMC_MainHero);
         this.FProcessorWindowHero.Hide();
         _loc2_ = int(COUNT_Animation);
         this.FAnimationVect = new Vector.<MovieClip>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAnimationVect[_loc1_] = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_Animation + _loc1_];
            this.FAnimationVect[_loc1_].stop();
            _loc1_++;
         }
         this.FUITab = new TUITab(this);
         _loc2_ = int(COUNT_Tab);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FScene[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabPageOnChange;
         this.FUITab.Init();
         this.FTF_HonorCount = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_HonorCount];
         this.FTF_HonorCount.mouseEnabled = false;
         this.FTF_HonorCount.text = "";
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FScene[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.ProcessorDataInit();
      }
      
      protected function ProcessorDataInit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMall = null;
         var _loc4_:Vector.<TMall> = null;
         var _loc5_:THonorShopItem = null;
         this.FMallBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Mall);
         this.FConfigValueBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = this.FMallBins.Count;
         _loc4_ = new Vector.<TMall>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMallBins.GetDatebaseByIndex(_loc1_) as TMall;
            if(_loc3_.Model == CONST_MALL.TYPE_MODEL_HONORSHOP)
            {
               _loc5_ = new THonorShopItem();
               _loc5_.BoughtCount = 0;
               _loc5_.Mall = _loc3_;
               if(_loc3_.MajorType == CONST_MALL.MAJORTYPE_MALL_Hero)
               {
                  this.FDataHonorShop.HeroItems.push(_loc5_);
               }
               else
               {
                  this.FDataHonorShop.InventoryItems.push(_loc5_);
               }
            }
            _loc1_++;
         }
         this.FConfigValue = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HonorShop_TotalCount) as TConfigValue;
      }
      
      protected function UpdateUI() : void
      {
         this.FTF_HonorCount.text = this.FDataHonorShop.HonorCount.toString();
         this.FTF_BoughtCount.text = this.FDataHonorShop.CanBuyCount.toString();
         if(this.FDataHonorShop.NextHonor != -1)
         {
            this.FTF_Prompt.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_56),this.FDataHonorShop.NextHonor);
            this.FTF_Prompt.visible = true;
         }
         else
         {
            this.FTF_Prompt.text = "";
            this.FTF_Prompt.visible = false;
         }
      }
      
      protected function ProcessorShowWindow(param1:int) : void
      {
         this.FTabPageIndex = param1;
         switch(this.FTabPageIndex)
         {
            case WINDOW_INDEX_Inventory:
               this.FProcessorWindowInventory.Show();
               this.FProcessorWindowInventory.ProcessorUpdateUI(this.FDataHonorShop);
               this.FProcessorWindowHero.Hide();
               break;
            case WINDOW_INDEX_Hero:
               this.FProcessorWindowHero.Show();
               this.FProcessorWindowHero.ProcessorUpdateUI(this.FDataHonorShop);
               this.FProcessorWindowInventory.Hide();
         }
      }
      
      protected function ProcessorPlayAnimation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FAnimationVect.length <= 0)
         {
            return;
         }
         _loc2_ = int(COUNT_Animation);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAnimationVect[_loc1_].gotoAndPlay(1);
            _loc1_++;
         }
      }
      
      protected function Perform_CS_HonorShopInitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mall_HonorShopReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FAnimationVect != null && this.FAnimationVect.length > 0)
         {
            _loc2_ = int(this.FAnimationVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAnimationVect[_loc1_].stop();
               _loc1_++;
            }
         }
         if(this.FUITab != null)
         {
            this.FUITab.SwithTagManual(0);
         }
         if(this.FProcessorWindowHero != null)
         {
            this.FProcessorWindowHero.Clear();
         }
         if(this.FProcessorWindowInventory != null)
         {
            this.FProcessorWindowInventory.Clear();
         }
      }
      
      protected function TabPageOnChange(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         if(this.FTabPageIndex == _loc2_)
         {
            return;
         }
         this.ProcessorShowWindow(_loc2_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnReturnTeamBattleChoose != null)
         {
            this.FOnReturnTeamBattleChoose(this);
         }
      }
      
      protected function ProcessorOnExchange(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function get OnReturnTeamBattleChoose() : Function
      {
         return this.FOnReturnTeamBattleChoose;
      }
      
      public function set OnReturnTeamBattleChoose(param1:Function) : void
      {
         this.FOnReturnTeamBattleChoose = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.Perform_CS_HonorShopInitReq();
         this.FDataHonorShop.HonorCount = SLogicsCore.TeamBattle.Honor;
         this.FDataHonorShop.TotalCountObj = this.FConfigValue.Value;
         this.Visible = true;
         this.ProcessorPlayAnimation();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.Reset();
      }
   }
}

