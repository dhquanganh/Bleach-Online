package Processors.Game.Lobby.Mall
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Logics.Unlocks.TUnlock;
   import Logics.VipShop.TVipShopData;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.ShowGirlPic.*;
   import Processors.Game.Lobby.Mall.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowMall extends TProcessorLobbyWindow
   {
      
      protected static const TYPE_MODEL_MALL:uint = CONST_MALL.TYPE_MODEL_MALL;
      
      protected static const GirlOffsetX:int = 725;
      
      protected static const GirlOffsetY:int = -63;
      
      protected const Capacity_MallItems:uint = 15;
      
      protected const Tab_HotOrNew:uint = 0;
      
      protected const Tab_Material:uint = 5;
      
      protected const Tab_VipShop:uint = 6;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMC_Tab:TUITab;
      
      protected var FMC_VIPDiscount:Sprite;
      
      protected var FMC_RedTip:Sprite;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FTF_Gold:TextField;
      
      protected var FTF_Coupon:TextField;
      
      protected var FUIPage:TUIPage;
      
      protected var FBtn_Recharge:TUIButton;
      
      protected var FUIMallItems:Vector.<TUIMallItem>;
      
      protected var FInventorySamples:TInventorySamples;
      
      protected var FCurrentInventorySamples:TInventorySamples;
      
      protected var FTabIndex:uint;
      
      protected var FPageIndex:uint;
      
      protected var FIsInitialization:Boolean;
      
      protected var FShowGirl:TShowGirlPic;
      
      protected var FAchievements:TAchievementInfors;
      
      protected var FCurrentAchievement:TAchievementInfor;
      
      protected var FGiftBagMC:Sprite;
      
      protected var FBtnGetAchievementReward:TUIButton;
      
      protected var FTalkBubble:Sprite;
      
      protected var FTFTalkBubble:TextField;
      
      protected var FToolHint:THint;
      
      protected var FHelpTips:THint;
      
      protected var FMC_VipShop:Sprite;
      
      protected var FTF_OldPrices:Vector.<TextField>;
      
      protected var FTF_NewPrices:Vector.<TextField>;
      
      protected var Btn_Oks:Vector.<TUIButton>;
      
      protected var FData_VipShop:TVipShopData;
      
      protected var FDredgeYellowDiamon:TUIButton;
      
      protected var FDredgeYearYellowDiamon:TUIButton;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FOnPurchase:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowMall(param1:TUIComponent)
      {
         super(param1);
         this.FInventorySamples = SLogicsCore.Character.InventorySamples;
         this.FCurrentInventorySamples = new TInventorySamples();
         this.FIsInitialization = false;
         this.FTabIndex = 0;
         this.FShowGirl = new TShowGirlPic();
         this.FShowGirl.mouseEnabled = false;
         this.FShowGirl.mouseChildren = false;
         this.FHelpTips = new THint();
         this.FToolHint = new THint();
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MALL.RESOURCESID_SWF_MALL);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TextField = null;
         var _loc8_:TUIMallItem = null;
         var _loc9_:MovieClip = null;
         var _loc10_:TUIButton = null;
         var _loc11_:TextField = null;
         var _loc12_:TextField = null;
         if(SParametersCore.IfBaiDuGame)
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Mall_Baidu") as Sprite;
         }
         else
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_MALL.RESOURCE_ClassName_Mall) as Sprite;
         }
         addChild(_loc3_);
         this.FGiftBagMC = TUtilityReflection.CreateDisplayObjectInstance("GiftBag") as MovieClip;
         if(false)
         {
            this.FTalkBubble = TUtilityReflection.CreateDisplayObjectInstance("TalkRight") as Sprite;
         }
         else
         {
            this.FTalkBubble = TUtilityReflection.CreateDisplayObjectInstance("TalkLeft") as Sprite;
         }
         this.FTFTalkBubble = this.FTalkBubble["tf_dialogueText"];
         this.FTalkBubble.mouseChildren = false;
         this.FTalkBubble.mouseEnabled = false;
         this.FTalkBubble.y = -70;
         this.FTalkBubble.x = GirlOffsetX + 280;
         this.FGiftBagMC.x = GirlOffsetX + 30;
         this.FGiftBagMC.y = GirlOffsetY + 280;
         if(false)
         {
            this.FTalkBubble.x = GirlOffsetX;
            this.FTalkBubble.y = -110;
         }
         this.FBtnGetAchievementReward = new TUIButton();
         this.FBtnGetAchievementReward.Substrate = this.FGiftBagMC["GetReward"];
         this.FBtnGetAchievementReward.OnClick = this.OnBtnGetAchievementClick;
         this.FAchievements = new TAchievementInfors();
         _loc1_ = CONST_MALL.AchievementIDMin;
         while(_loc1_ <= CONST_MALL.AchievementIDMax)
         {
            this.FAchievements.Add(SLogicsCore.Character.AchievementData.GetAchievementByID(_loc1_));
            _loc1_++;
         }
         this.FMC_Tab = new TUITab(this);
         _loc2_ = CONST_MALL.Capacity_Tabs;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FMC_Tab.SetTabByIndex(_loc4_,_loc1_);
            _loc1_++;
         }
         this.FMC_Tab.OnSwitch = this.TabOnSwitch;
         this.FMC_Tab.Init();
         _loc5_ = _loc3_[CONST_MALL.RESOURCE_Link_MC_Page];
         _loc6_ = _loc5_[CONST_MALL.RESOURCE_Link_MC_PageLeft];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc6_;
         _loc6_ = _loc5_[CONST_MALL.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc6_;
         _loc7_ = _loc5_[CONST_MALL.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc7_;
         _loc7_.text = "0/0";
         this.FUIPage.PageSize = this.Capacity_MallItems;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.UIPageOnChange;
         this.FMC_VIPDiscount = _loc3_[CONST_MALL.RESOURCE_Link_MC_VIPDiscount];
         this.FMC_RedTip = _loc3_[CONST_MALL.RESOURCE_Link_MC_RedTip];
         this.FTF_Gold = _loc3_[CONST_MALL.RESOURCE_Link_TF_Gold];
         this.FTF_Coupon = _loc3_[CONST_MALL.RESOURCE_Link_TF_Coupon];
         this.FUIMallItems = new Vector.<TUIMallItem>(this.Capacity_MallItems);
         _loc2_ = this.Capacity_MallItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc9_ = _loc3_[CONST_MALL.RESOURCE_Link_MC_MallItem + _loc1_];
            _loc8_ = new TUIMallItem(this);
            _loc8_.Tag = _loc1_;
            _loc8_.Substrate = _loc9_;
            _loc8_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc8_.SlotOnOut = this.UIComponentsHintOnOut;
            _loc8_.SlotOnOver = this.UIComponentsHintOnOver;
            _loc8_.ItemOnClick = this.ProcessorItemOnClick;
            _loc8_.Perform_UIDispatch();
            this.FUIMallItems[_loc1_] = _loc8_;
            _loc1_++;
         }
         this.FMC_VipShop = _loc3_["MC_VipShop"];
         _loc2_ = 11;
         this.FTF_OldPrices = new Vector.<TextField>(_loc2_);
         this.FTF_NewPrices = new Vector.<TextField>(_loc2_);
         this.Btn_Oks = new Vector.<TUIButton>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc11_ = this.FMC_VipShop["MC_OldPrice_" + _loc1_]["TF_Price"];
            this.FTF_OldPrices[_loc1_] = _loc11_;
            _loc12_ = this.FMC_VipShop["MC_NewPrice_" + _loc1_]["TF_Price"];
            this.FTF_NewPrices[_loc1_] = _loc12_;
            _loc10_ = new TUIButton();
            _loc10_.Substrate = this.FMC_VipShop["Btn_Ok_" + _loc1_];
            _loc10_.OnClick = this.BtnOKonClick;
            _loc10_.OnMove = this.BtnOkOnMove;
            _loc10_.OnOut = this.BtnOkOnOut;
            this.Btn_Oks[_loc1_] = _loc10_;
            _loc1_++;
         }
         this.FBtn_Close = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Recharge = new TUIButton();
         this.FBtn_Recharge.Substrate = _loc3_[CONST_MALL.RESOURCE_Link_BTN_Recharge];
         this.FBtn_Recharge.OnClick = this.RechargeOnClick;
         this.FShowGirl.x = GirlOffsetX;
         this.FShowGirl.y = GirlOffsetY;
         addChild(this.FShowGirl);
         addChild(this.FGiftBagMC);
         addChild(this.FTalkBubble);
         this.FDredgeYellowDiamon = new TUIButton();
         this.FDredgeYellowDiamon.Substrate = _loc3_["DredgeYellowDiamon"];
         this.FDredgeYellowDiamon.OnClick = this.OpenYellowDiamon;
         this.FDredgeYearYellowDiamon = new TUIButton();
         this.FDredgeYearYellowDiamon.Substrate = _loc3_["DredgeYearYellowDiamon"];
         this.FDredgeYearYellowDiamon.OnClick = this.OpenYearYellowDiamon;
         this.FIsInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function BtnOkOnOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param2.currentTarget.name.split("_")[2]);
         this.UIComponentsHintOnOut(this,this.FCurrentInventorySamples.GetInventorySampleByIndex(_loc3_).Inventory);
      }
      
      protected function BtnOkOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param2.currentTarget.name.split("_")[2]);
         this.UIComponentsHintOnOver(this,this.FCurrentInventorySamples.GetInventorySampleByIndex(_loc3_).Inventory);
      }
      
      protected function BtnOKonClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param2.currentTarget.name.split("_")[2]);
         this.ProcessorItemOnClick(this,this.FCurrentInventorySamples.GetInventorySampleByIndex(_loc3_));
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.CloseOnClick,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FGiftBagMC.addEventListener(MouseEvent.MOUSE_MOVE,this.OnGiftBagMouseMove);
         this.FGiftBagMC.addEventListener(MouseEvent.MOUSE_OUT,this.OnNormalMouseOut);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIMallItem = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.FShowGirl.Update();
         if(this.FIsInitialization)
         {
            _loc2_ = this.Capacity_MallItems;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FUIMallItems[_loc1_];
               _loc3_.UpdateSlot();
               _loc1_++;
            }
         }
      }
      
      protected function InventorySamplesUpdateItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUIMallItem = null;
         var _loc8_:TInventorySample = null;
         _loc6_ = int(this.FPageIndex);
         _loc2_ = this.Capacity_MallItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FUIMallItems[_loc1_];
            _loc7_.Context = null;
            _loc7_.Substrate.visible = false;
            _loc1_++;
         }
         _loc2_ = uint(this.FCurrentInventorySamples.Count);
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc5_ = _loc6_ * this.Capacity_MallItems;
         _loc1_ = 0;
         while(_loc1_ < this.Capacity_MallItems)
         {
            if(_loc1_ + _loc5_ >= _loc2_)
            {
               break;
            }
            _loc7_ = this.FUIMallItems[_loc1_];
            _loc8_ = this.FCurrentInventorySamples.GetInventorySampleByIndex(_loc1_ + _loc5_);
            _loc7_.Context = _loc8_;
            _loc7_.Substrate.visible = true;
            _loc1_++;
         }
      }
      
      protected function FilterTabMallItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventorySample = null;
         this.FCurrentInventorySamples.Clear();
         _loc2_ = uint(this.FInventorySamples.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FInventorySamples.GetInventorySampleByIndex(_loc1_);
            if(_loc3_.IsDisplay && _loc3_.Model == TYPE_MODEL_MALL)
            {
               if(this.FTabIndex == this.Tab_HotOrNew && (_loc3_.IsHot || _loc3_.IsNew))
               {
                  this.FCurrentInventorySamples.Add(_loc3_);
               }
               else if(this.FTabIndex == this.Tab_Material)
               {
                  this.FCurrentInventorySamples.Add(_loc3_);
               }
               else if(_loc3_.Page == this.FTabIndex + 1)
               {
                  this.FCurrentInventorySamples.Add(_loc3_);
               }
            }
            if(_loc3_.IsDisplay && _loc3_.Model == 14)
            {
               if(this.FTabIndex == this.Tab_VipShop && _loc3_.Page == 1)
               {
                  this.FCurrentInventorySamples.Add(_loc3_);
               }
            }
            _loc1_++;
         }
         if(!SParametersCore.IfBaiDuGame)
         {
            this.FMC_VIPDiscount.visible = this.FTabIndex != this.Tab_HotOrNew;
            this.FMC_RedTip.visible = true;
         }
         if(this.FTabIndex == this.Tab_VipShop)
         {
            this.FMC_RedTip.visible = false;
            this.FMC_VIPDiscount.visible = false;
         }
      }
      
      protected function UpdateCharacterMoney() : void
      {
         this.FTF_Gold.text = SLogicsCore.Character.CreditGold.toString();
         this.FTF_Coupon.text = SLogicsCore.Character.CreditGiftCertificate.toString();
      }
      
      protected function UpdatePageInfo() : void
      {
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = this.FCurrentInventorySamples.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateVipShop() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.FTabIndex == 6)
         {
            this.FMC_VipShop.visible = true;
            if(false)
            {
               this.FMC_VipShop.visible = false;
            }
            _loc2_ = uint(this.FCurrentInventorySamples.Count);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTF_OldPrices[_loc1_].text = this.FCurrentInventorySamples.GetInventorySampleByIndex(_loc1_).CostGold.toString();
               this.FTF_NewPrices[_loc1_].text = this.FCurrentInventorySamples.GetInventorySampleByIndex(_loc1_).Discount.toString();
               _loc1_++;
            }
            if(this.FData_VipShop == null)
            {
               return;
            }
            _loc2_ = this.FData_VipShop.InventoryItems.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FData_VipShop.InventoryItems[_loc1_].BoughtCount == 1)
               {
                  this.Btn_Oks[_loc1_].Enabled = false;
               }
               _loc1_++;
            }
            return;
         }
         this.FMC_VipShop.visible = false;
      }
      
      private function UpdateTabs() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TInventorySample = null;
         _loc2_ = CONST_MALL.Capacity_Tabs;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Tab.GetTabByIndex(_loc1_);
            _loc3_.visible = false;
            _loc1_++;
         }
         _loc2_ = uint(this.FInventorySamples.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FInventorySamples.GetInventorySampleByIndex(_loc1_);
            if(_loc4_.IsDisplay && _loc4_.Model == TYPE_MODEL_MALL)
            {
               _loc3_ = this.FMC_Tab.GetTabByIndex(_loc4_.Page - 1);
               if(!_loc3_.visible)
               {
                  _loc3_.visible = true;
               }
            }
            _loc1_++;
         }
         this.FMC_Tab.GetTabByIndex(6).visible = true;
      }
      
      protected function UpdateAchievement() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAchievementInfor = null;
         var _loc3_:int = 0;
         var _loc4_:TUnlock = null;
         _loc4_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_Achievement);
         if(_loc4_.State == TUnlock.UNLOCKSTATE_ForcedOff)
         {
            this.FTalkBubble.visible = false;
            this.FGiftBagMC.visible = false;
            return;
         }
         this.FCurrentAchievement = null;
         _loc1_ = 0;
         while(_loc1_ < this.FAchievements.Count)
         {
            _loc2_ = this.FAchievements.GetAchievementByIndex(_loc1_);
            if(!_loc2_.IfGotReward)
            {
               this.FCurrentAchievement = _loc2_;
               break;
            }
            _loc1_++;
         }
         this.FGiftBagMC.visible = false;
         this.FTalkBubble.visible = false;
         this.FShowGirl.IFCanGetReward = false;
         if(this.FCurrentAchievement != null)
         {
            if(this.FCurrentAchievement.IfComplete)
            {
               this.FGiftBagMC.visible = true;
               this.FShowGirl.IFCanGetReward = true;
            }
            this.FTalkBubble.visible = true;
            _loc3_ = this.FCurrentAchievement.TotalSchedule - this.FCurrentAchievement.CurrentSchedule;
            _loc3_ = _loc3_ < 0 ? 0 : _loc3_;
            this.FTFTalkBubble.htmlText = TUtilityString.Format(this.FCurrentAchievement.RewardStringFormat,_loc3_,this.FCurrentAchievement.RewardString);
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         this.UpdatePanelCredits();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function CloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Mall);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function RechargeOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as uint;
         this.FPageIndex = 0;
         this.UpdatePageInfo();
         this.FilterTabMallItem();
         this.UpdateVipShop();
         this.InventorySamplesUpdateItems();
      }
      
      protected function UIPageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.InventorySamplesUpdateItems();
      }
      
      protected function ProcessorItemOnClick(param1:Object, param2:TInventorySample) : void
      {
         var _loc3_:TPurchaseRequest = null;
         _loc3_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(this,_loc3_,this.FPurchaseParameters,param2);
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
      
      protected function UIComponentsHintOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FSlotOnOver != null)
         {
            this.FSlotOnOver(param1,param2);
         }
      }
      
      protected function UIComponentsHintOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FSlotOnOut != null)
         {
            this.FSlotOnOut(param1,param2);
         }
      }
      
      protected function OnBtnGetAchievementClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementRewardReq);
         _loc3_.Data.writeUnsignedInt(this.FCurrentAchievement.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnGiftBagMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null && this.FCurrentAchievement != null)
         {
            this.FToolHint.Caption = this.FCurrentAchievement.FlyText;
            this.FHintOnMove(this,this.FToolHint);
            this.FGiftBagMC.filters = [TUtilityFilter.highLightFilters];
         }
      }
      
      protected function OnNormalMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FToolHint);
         }
         this.FToolHint.Caption = "";
         this.FGiftBagMC.filters = null;
      }
      
      protected function OpenYellowDiamon(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(SParametersCore.YellowVipUrl);
         SExternalCore.onOpenButton();
      }
      
      protected function OpenYearYellowDiamon(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(SParametersCore.YearYellowVipUrl);
         SExternalCore.onOpenButton();
      }
      
      public function get SlotOnOver() : Function
      {
         return this.FSlotOnOver;
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function get SlotOnOut() : Function
      {
         return this.FSlotOnOut;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function Update() : void
      {
         this.UpdatePageInfo();
         this.UpdateTabs();
         this.FilterTabMallItem();
         this.UpdateVipShop();
         this.InventorySamplesUpdateItems();
         this.UpdateCharacterMoney();
         this.UpdateAchievement();
         this.FShowGirl.LoadResource(CONST_MALL.GirlID);
      }
      
      public function UpdatePanelCredits() : void
      {
         this.UpdateCharacterMoney();
         this.UpdateAchievement();
         this.FShowGirl.TriggerSpecial();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIMallItem = null;
         this.FTF_Gold.text = "";
         this.FTF_Coupon.text = "";
         _loc2_ = this.Capacity_MallItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUIMallItems[_loc1_];
            _loc3_.Context = null;
            _loc3_.Substrate.visible = false;
            _loc1_++;
         }
         this.FShowGirl.Reset();
      }
      
      public function AchievementInforUpdateNotify(param1:TAchievementInfor) : void
      {
         if(visible && param1.ID >= CONST_MALL.AchievementIDMin && param1.ID <= CONST_MALL.AchievementIDMax)
         {
            this.UpdateAchievement();
         }
      }
      
      public function UpdateDataBase(param1:TVipShopData) : void
      {
         this.FData_VipShop = param1;
         this.Update();
      }
   }
}

