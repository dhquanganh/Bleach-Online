package Processors.Game.Lobby.SuperMarket
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Logics.Streamization.Inventories.*;
   import Logics.SuperMarket.*;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.ShowGirlPic.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowSuperMarket extends TProcessorLobbyWindow
   {
      
      protected static const SuitSlotNum:int = 6;
      
      protected static const ArmSlotNum:int = 3;
      
      protected static const EquipSlotNum:int = 5;
      
      protected static const GirlOffsetX:int = -260;
      
      protected static const GirlOffsetY:int = -85;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMainUI:Sprite;
      
      protected var FEquipSuitSlots:Vector.<TUISlot>;
      
      protected var FEquipSuitPrice:TextField;
      
      protected var FBtnGiftBagBuy:TUIButton;
      
      protected var FEquipSuitInventories:TInventories;
      
      protected var FEquipSuitAlreadyBuyFlag:Sprite;
      
      protected var FArmSlots:Vector.<TUISlot>;
      
      protected var FArmNames:Vector.<TextField>;
      
      protected var FArmPrice:Vector.<TextField>;
      
      protected var FFitProfession:Vector.<TextField>;
      
      protected var FArmBtns:Vector.<TUIButton>;
      
      protected var FArmAlreadyBuyFlag:Vector.<Sprite>;
      
      protected var FArmInventories:TInventories;
      
      protected var FEquipSlots:Vector.<TUISlot>;
      
      protected var FEquipNames:Vector.<TextField>;
      
      protected var FEquipPrice:Vector.<TextField>;
      
      protected var FEquipBtns:Vector.<TUIButton>;
      
      protected var FEquipAlreadyBuyFlag:Vector.<Sprite>;
      
      protected var FEquipInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FFitProfessionString:Vector.<String>;
      
      protected var FGoodsIDWaitToBuy:uint;
      
      protected var FUIPromotWindow:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FFormatBuy:String;
      
      protected var FShowGirl:TShowGirlPic;
      
      protected var FAchievements:TAchievementInfors;
      
      protected var FCurrentAchievement:TAchievementInfor;
      
      protected var FGiftBagMC:Sprite;
      
      protected var FBtnGetAchievementReward:TUIButton;
      
      protected var FTalkBubble:Sprite;
      
      protected var FTFTalkBubble:TextField;
      
      protected var FToolHint:THint;
      
      protected var FSuperMarketData:TSuperMarketData;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnPurchase:Function;
      
      protected var FOnRequestMarketState:Function;
      
      public function TProcessorWindowSuperMarket(param1:TUIComponent)
      {
         super(param1);
         this.FShowGirl = new TShowGirlPic();
         this.FShowGirl.x = GirlOffsetX;
         this.FShowGirl.y = GirlOffsetY;
         this.FShowGirl.mouseEnabled = false;
         this.FShowGirl.mouseChildren = false;
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
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TUIButton = null;
         var _loc4_:TUISlot = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("SuperMarket") as MovieClip;
         addChild(this.FMainUI);
         this.FGiftBagMC = TUtilityReflection.CreateDisplayObjectInstance("GiftBag") as Sprite;
         this.FTalkBubble = TUtilityReflection.CreateDisplayObjectInstance("TalkLeft") as Sprite;
         this.FTFTalkBubble = this.FTalkBubble["tf_dialogueText"];
         this.FTalkBubble.mouseChildren = false;
         this.FTalkBubble.mouseEnabled = false;
         this.FTalkBubble.y = -50;
         this.FGiftBagMC.x = GirlOffsetX + 30;
         this.FGiftBagMC.y = GirlOffsetY + 200;
         this.FBtnGetAchievementReward = new TUIButton();
         this.FBtnGetAchievementReward.Substrate = this.FGiftBagMC["GetReward"];
         this.FBtnGetAchievementReward.OnClick = this.BtnGetAchievementOnClick;
         this.FEquipSuitSlots = new Vector.<TUISlot>();
         this.FArmSlots = new Vector.<TUISlot>();
         this.FArmNames = new Vector.<TextField>();
         this.FArmPrice = new Vector.<TextField>();
         this.FFitProfession = new Vector.<TextField>();
         this.FArmBtns = new Vector.<TUIButton>();
         this.FArmAlreadyBuyFlag = new Vector.<Sprite>();
         this.FEquipSlots = new Vector.<TUISlot>();
         this.FEquipNames = new Vector.<TextField>();
         this.FEquipPrice = new Vector.<TextField>();
         this.FEquipBtns = new Vector.<TUIButton>();
         this.FEquipAlreadyBuyFlag = new Vector.<Sprite>();
         this.FEquipSuitInventories = new TInventories();
         this.FArmInventories = new TInventories();
         this.FEquipInventories = new TInventories();
         _loc1_ = 0;
         while(_loc1_ < SuitSlotNum)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = this.FMainUI["MC_Slot" + _loc1_];
            _loc4_.OnOver = this.SuitSlotsOnMove;
            _loc4_.OnOut = this.SlotsOnOut;
            _loc4_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc4_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FEquipSuitSlots.push(_loc4_);
            _loc1_++;
         }
         this.FEquipSuitPrice = this.FMainUI["GiftBagPrice"];
         this.FBtnGiftBagBuy = new TUIButton();
         this.FBtnGiftBagBuy.Substrate = this.FMainUI["GiftBagBuyBtn"];
         this.FEquipSuitAlreadyBuyFlag = this.FMainUI["AlreadyBuyFlag"];
         this.FBtnGiftBagBuy.OnClick = this.BtnBuyGiftBagOnClick;
         _loc1_ = 0;
         while(_loc1_ < ArmSlotNum)
         {
            _loc2_ = this.FMainUI["ArmBar" + _loc1_];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc2_["MC_Slot"];
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.OnOver = this.ArmSlotsOnMove;
            _loc4_.OnOut = this.SlotsOnOut;
            _loc4_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc4_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc4_.Init();
            this.FArmSlots.push(_loc4_);
            this.FArmNames.push(_loc2_["Name"]);
            this.FArmPrice.push(_loc2_["price"]);
            this.FFitProfession.push(_loc2_["FitProfession"]);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["BuyBtn"];
            _loc3_.OnClick = this.BtnBuyArmOnClick;
            this.FArmBtns.push(_loc3_);
            this.FArmAlreadyBuyFlag.push(_loc2_["AlreadyBuyFlag"]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < EquipSlotNum)
         {
            _loc2_ = this.FMainUI["EquipBar" + _loc1_];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc2_["MC_Slot"];
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.OnOver = this.EquipSlotsOnMove;
            _loc4_.OnOut = this.SlotsOnOut;
            _loc4_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc4_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc4_.Init();
            this.FEquipSlots.push(_loc4_);
            this.FEquipNames.push(_loc2_["Name"]);
            this.FEquipPrice.push(_loc2_["price"]);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["BuyBtn"];
            _loc3_.OnClick = this.BtnBuyEquipOnClick;
            this.FEquipBtns.push(_loc3_);
            this.FEquipAlreadyBuyFlag.push(_loc2_["AlreadyBuyFlag"]);
            _loc1_++;
         }
         this.FBtnClose = this.FMainUI["Btn_Close"];
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.ConstructInventory();
         this.FUIPromotWindow = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FFitProfessionString = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_01);
         addChild(this.FShowGirl);
         addChild(this.FGiftBagMC);
         addChild(this.FTalkBubble);
         this.FAchievements = new TAchievementInfors();
         _loc1_ = CONST_SUPERMARKET.AchievementIDMin;
         while(_loc1_ <= CONST_SUPERMARKET.AchievementIDMax)
         {
            this.FAchievements.Add(SLogicsCore.Character.AchievementData.GetAchievementByID(_loc1_));
            _loc1_++;
         }
         this.FToolHint = new THint();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FGiftBagMC.addEventListener(MouseEvent.MOUSE_MOVE,this.GiftBagOnMouseMove);
         this.FGiftBagMC.addEventListener(MouseEvent.MOUSE_OUT,this.NormalOnMouseOut);
         this.FFormatBuy = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_02);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible && FIsResourcesLoadCompleted)
         {
            this.UpdateSlots(this.FEquipSuitSlots);
            this.UpdateSlots(this.FArmSlots);
            this.UpdateSlots(this.FEquipSlots);
            this.FShowGirl.Update();
         }
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<int> = null;
         var _loc3_:TUISlot = null;
         var _loc4_:TMall = null;
         var _loc5_:int = 0;
         this.FShowGirl.LoadResource(CONST_SUPERMARKET.GirlPicID);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,CONST_SUPERMARKET.GiftBagIDMallID[_loc1_]) as TMall;
         _loc1_ = 0;
         while(_loc1_ < this.FEquipSuitInventories.Count)
         {
            _loc3_ = this.FEquipSuitSlots[_loc1_];
            _loc3_.Context = this.FEquipSuitInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         this.FEquipSuitPrice.text = _loc4_.Gold.toString();
         this.FBtnGiftBagBuy.Visible = this.FSuperMarketData.AlreadyBuySuitID == 0;
         this.FEquipSuitAlreadyBuyFlag.visible = this.FSuperMarketData.AlreadyBuySuitID != 0;
         _loc1_ = 0;
         while(_loc1_ < ArmSlotNum)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,CONST_SUPERMARKET.ArmMallID[_loc1_]) as TMall;
            this.FArmSlots[_loc1_].Context = this.FArmInventories.GetInventoryByIndex(_loc1_);
            this.FArmNames[_loc1_].text = _loc4_.Name;
            this.FArmPrice[_loc1_].text = _loc4_.Gold.toString();
            this.FFitProfession[_loc1_].text = this.FFitProfessionString[_loc1_];
            if(this.FSuperMarketData.AlreadyBuyArmID != 0)
            {
               this.FArmBtns[_loc1_].Visible = false;
               if(this.FSuperMarketData.AlreadyBuyArmID == CONST_SUPERMARKET.ArmMallID[_loc1_])
               {
                  this.FArmAlreadyBuyFlag[_loc1_].visible = true;
               }
               else
               {
                  this.FArmAlreadyBuyFlag[_loc1_].visible = false;
               }
            }
            else
            {
               this.FArmBtns[_loc1_].Visible = true;
               this.FArmAlreadyBuyFlag[_loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < EquipSlotNum)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,CONST_SUPERMARKET.EquipmentMallID[_loc1_]) as TMall;
            this.FEquipSlots[_loc1_].Context = this.FEquipInventories.GetInventoryByIndex(_loc1_);
            this.FEquipNames[_loc1_].text = _loc4_.Name;
            this.FEquipPrice[_loc1_].text = _loc4_.Gold.toString();
            _loc5_ = _loc5_ = this.FSuperMarketData.AlreadyBuyEquipID.indexOf(CONST_SUPERMARKET.EquipmentMallID[_loc1_]);
            if(_loc5_ != -1)
            {
               this.FEquipBtns[_loc1_].Visible = false;
               this.FEquipAlreadyBuyFlag[_loc1_].visible = true;
            }
            else
            {
               this.FEquipBtns[_loc1_].Visible = true;
               this.FEquipAlreadyBuyFlag[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this.UpdateAchievement();
      }
      
      protected function UpdateAchievement() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAchievementInfor = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:TUnlock = null;
         _loc5_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_Achievement);
         if(_loc5_.State == TUnlock.UNLOCKSTATE_ForcedOff)
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
         _loc3_ = false;
         if(this.FCurrentAchievement != null)
         {
            if(this.FCurrentAchievement.IfComplete)
            {
               this.FGiftBagMC.visible = true;
               _loc3_ = true;
            }
            this.FTalkBubble.visible = true;
            _loc4_ = this.FCurrentAchievement.TotalSchedule - this.FCurrentAchievement.CurrentSchedule;
            _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
            this.FTFTalkBubble.htmlText = TUtilityString.Format(this.FCurrentAchievement.RewardStringFormat,_loc4_,this.FCurrentAchievement.RewardString);
         }
         if(_loc3_ != this.FShowGirl.IFCanGetReward)
         {
            this.FShowGirl.IFCanGetReward = _loc3_;
         }
      }
      
      protected function ConstructInventory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:TInventories = null;
         var _loc5_:TMall = null;
         var _loc6_:Vector.<int> = null;
         _loc3_ = new Vector.<uint>();
         _loc6_ = CONST_SUPERMARKET.ProfessionIndex;
         _loc1_ = _loc6_.indexOf(SLogicsCore.Character.Profession);
         this.ProcessorGetInventories(CONST_SUPERMARKET.GiftBagID[_loc1_],this.FEquipSuitInventories);
         _loc3_.length = 0;
         _loc1_ = 0;
         while(_loc1_ < ArmSlotNum)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,CONST_SUPERMARKET.ArmMallID[_loc1_]) as TMall;
            _loc3_.push(_loc5_.ItemID);
            _loc1_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FArmInventories,_loc3_);
         _loc3_.length = 0;
         _loc1_ = 0;
         while(_loc1_ < EquipSlotNum)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,CONST_SUPERMARKET.EquipmentMallID[_loc1_]) as TMall;
            _loc3_.push(_loc5_.ItemID);
            _loc1_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FEquipInventories,_loc3_);
      }
      
      protected function ProcessorGetInventories(param1:int, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAward = null;
         var _loc6_:TFixedAward = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:TBins = null;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         _loc5_ = _loc8_.GetDatebaseByIdentifier(param1) as TAward;
         _loc4_ = int(_loc5_.FixedAwards.length);
         _loc7_ = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.FixedAwards[_loc3_];
            _loc7_[_loc3_] = CONST_COMMON.RewardIDToTemplateID(_loc6_.Type,_loc6_.Code);
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,_loc7_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.FixedAwards[_loc3_];
            param2.GetInventoryByIndex(_loc3_).Quantity = _loc6_.Amount;
            _loc3_++;
         }
      }
      
      protected function UpdateSlots(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_].Update();
            _loc2_++;
         }
      }
      
      public function ResetSlots(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_].Context = null;
            _loc2_++;
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         if(this.FOnRequestMarketState != null)
         {
            this.FOnRequestMarketState();
         }
         this.BuySuccessNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function SuitSlotsOnMove(param1:Object, param2:TInventory) : void
      {
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc3_ = SLogicsCore.Character.GetMainHero();
         _loc4_ = this.FEquipSuitSlots.indexOf(param1 as TUISlot);
         _loc5_ = _loc3_.EquipmentsMounted.GetInventoryByIndex(_loc4_);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FEquipSuitInventories.GetInventoryByIndex(_loc4_),_loc5_);
      }
      
      protected function ArmSlotsOnMove(param1:Object, param2:TInventory) : void
      {
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc3_ = SLogicsCore.Character.GetMainHero();
         _loc4_ = this.FArmSlots.indexOf(param1 as TUISlot);
         _loc5_ = _loc3_.EquipmentsMounted.GetInventoryByIndex(0);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FArmInventories.GetInventoryByIndex(_loc4_),_loc5_);
      }
      
      protected function EquipSlotsOnMove(param1:Object, param2:TInventory) : void
      {
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc3_ = SLogicsCore.Character.GetMainHero();
         _loc4_ = this.FEquipSlots.indexOf(param1 as TUISlot);
         _loc5_ = _loc3_.EquipmentsMounted.GetInventoryByIndex(_loc4_ + 1);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FEquipInventories.GetInventoryByIndex(_loc4_),_loc5_);
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         SUtilityOverLayer.HideTip();
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      protected function UIPromotWindowOnOk(param1:Object) : void
      {
         var _loc2_:TPurchaseRequest = null;
         _loc2_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc2_.IDTemplate = this.FGoodsIDWaitToBuy;
         _loc2_.Quantity = 1;
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(this,_loc2_,this.FPurchaseParameters);
         }
      }
      
      protected function BtnBuyGiftBagOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TMall = null;
         _loc4_ = CONST_SUPERMARKET.ProfessionIndex;
         _loc3_ = _loc4_.indexOf(SLogicsCore.Character.Profession);
         this.FGoodsIDWaitToBuy = CONST_SUPERMARKET.GiftBagIDMallID[_loc3_];
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,this.FGoodsIDWaitToBuy) as TMall;
         if(SLogicsCore.Character.CreditGold < _loc5_.Gold)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc5_.Gold);
            this.FUIWindowRecharge.visible = true;
         }
         else
         {
            this.FUIPromotWindow.Text = TUtilityString.Format(this.FFormatBuy,_loc5_.Gold);
            this.FUIPromotWindow.OnOK = this.UIPromotWindowOnOk;
            this.FUIPromotWindow.Visible = true;
         }
      }
      
      protected function BtnBuyArmOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:TMall = null;
         _loc3_ = this.FArmBtns.indexOf(param1 as TUIButton);
         this.FGoodsIDWaitToBuy = CONST_SUPERMARKET.ArmMallID[_loc3_];
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,this.FGoodsIDWaitToBuy) as TMall;
         if(SLogicsCore.Character.CreditGold < _loc5_.Gold)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc5_.Gold);
            this.FUIWindowRecharge.visible = true;
         }
         else
         {
            this.FUIPromotWindow.Text = TUtilityString.Format(this.FFormatBuy,_loc5_.Gold);
            this.FUIPromotWindow.OnOK = this.UIPromotWindowOnOk;
            this.FUIPromotWindow.Visible = true;
         }
      }
      
      protected function BtnBuyEquipOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TMall = null;
         _loc3_ = this.FEquipBtns.indexOf(param1 as TUIButton);
         this.FGoodsIDWaitToBuy = CONST_SUPERMARKET.EquipmentMallID[_loc3_];
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Mall,this.FGoodsIDWaitToBuy) as TMall;
         if(SLogicsCore.Character.CreditGold < _loc4_.Gold)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc4_.Gold);
            this.FUIWindowRecharge.visible = true;
         }
         else
         {
            this.FUIPromotWindow.Text = TUtilityString.Format(this.FFormatBuy,_loc4_.Gold);
            this.FUIPromotWindow.OnOK = this.UIPromotWindowOnOk;
            this.FUIPromotWindow.Visible = true;
         }
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnGetAchievementOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementRewardReq);
         _loc3_.Data.writeUnsignedInt(this.FCurrentAchievement.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function GiftBagOnMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null && this.FCurrentAchievement != null)
         {
            this.FToolHint.Caption = this.FCurrentAchievement.FlyText;
            this.FHintOnMove(this,this.FToolHint);
            this.FGiftBagMC.filters = [TUtilityFilter.highLightFilters];
         }
      }
      
      protected function NormalOnMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FToolHint);
         }
         this.FGiftBagMC.filters = null;
      }
      
      public function set SuperMarketData(param1:TSuperMarketData) : void
      {
         this.FSuperMarketData = param1;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function get OnRequestMarketState() : Function
      {
         return this.FOnRequestMarketState;
      }
      
      public function set OnRequestMarketState(param1:Function) : void
      {
         this.FOnRequestMarketState = param1;
      }
      
      public function Update() : void
      {
         if(FIsResourcesLoadCompleted)
         {
            this.Update_Perform();
         }
      }
      
      public function Reset() : void
      {
         if(FIsResourcesLoadCompleted)
         {
            this.ResetSlots(this.FEquipSuitSlots);
            this.ResetSlots(this.FArmSlots);
            this.ResetSlots(this.FEquipSlots);
            this.FShowGirl.Reset();
         }
      }
      
      public function BuySuccessNotify() : void
      {
         this.FShowGirl.TriggerSpecial();
      }
      
      public function AchievementInforUpdateNotify(param1:TAchievementInfor) : void
      {
         if(visible && param1.ID >= CONST_SUPERMARKET.AchievementIDMin && param1.ID <= CONST_SUPERMARKET.AchievementIDMax)
         {
            this.UpdateAchievement();
         }
      }
   }
}

