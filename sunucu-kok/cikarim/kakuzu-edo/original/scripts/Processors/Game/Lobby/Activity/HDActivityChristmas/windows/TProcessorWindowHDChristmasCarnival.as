package Processors.Game.Lobby.Activity.HDActivityChristmas.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas.THDChristmasCarnivalData;
   import Logics.HDChristmas.VO.TCarnivalHeroVO;
   import Logics.HDChristmas.VO.TCarnivalRandomItemVO;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlow;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Processors.Game.Windows.Information.TUIWindowRecharge;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MAP;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowHDChristmasCarnival extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FRareItems:Vector.<TUISlot>;
      
      protected var FRandomItems:Vector.<MovieClip>;
      
      protected var FRandomItemRefreshBtns:Vector.<TUIButton>;
      
      protected var FRandomItemBuyBtns:Vector.<TUIButton>;
      
      protected var FMC_RandomItems:Vector.<MovieClip>;
      
      protected var FRefreshAllItemsBtn:TUIButton;
      
      protected var FRefreshHeroBtn:TUIButton;
      
      protected var FExchangeHeroBtn:TUIButton;
      
      protected var FData:THDChristmasCarnivalData;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FLastTick:Number;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FNeedDiscountCoin:uint;
      
      protected var FCurrentBtnIndex:uint;
      
      protected var FEffectGlow:TEffectBaseGlow;
      
      protected var FGetCardBtn:TUIButton;
      
      protected var FSendData:Function;
      
      protected var FGetCard:Function;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      public function TProcessorWindowHDChristmasCarnival(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         this.InitWindow();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         if(!this.FMainUI.visible)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < THDChristmasCarnivalData.RareItem_Count)
         {
            _loc2_ = this.FRareItems[_loc1_];
            _loc2_.Update();
            _loc1_++;
         }
         if(this.FRoleMoudle.TextrueID != 0)
         {
            this.FRoleMoudle.UpdateView();
         }
         if(this.FData.RemainFreeRefreshTime == 0)
         {
            this.FEffectGlow.Run();
         }
         this.CountDown();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TUIButton = null;
         var _loc8_:MovieClip = null;
         _loc3_ = this.FMainUI["MC_Items"];
         _loc4_ = this.FMainUI["MC_Hero"];
         _loc5_ = _loc3_["MC_RareItems"];
         this.FRareItems = new Vector.<TUISlot>(THDChristmasCarnivalData.RareItem_Count);
         _loc1_ = 0;
         while(_loc1_ < THDChristmasCarnivalData.RareItem_Count)
         {
            _loc2_ = new TUISlot(this);
            _loc2_.Resource = _loc5_["Slot_" + _loc1_]["Slot"];
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.Init();
            this.FRareItems[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.FRandomItems = new Vector.<MovieClip>(THDChristmasCarnivalData.RandomItem_Count);
         this.FRandomItemRefreshBtns = new Vector.<TUIButton>(THDChristmasCarnivalData.RandomItem_Count);
         this.FRandomItemBuyBtns = new Vector.<TUIButton>(THDChristmasCarnivalData.RandomItem_Count);
         this.FMC_RandomItems = new Vector.<MovieClip>(THDChristmasCarnivalData.RandomItem_Count);
         _loc1_ = 0;
         while(_loc1_ < THDChristmasCarnivalData.RandomItem_Count)
         {
            _loc6_ = _loc3_["MC_RandomItem_" + _loc1_];
            this.FMC_RandomItems[_loc1_] = _loc6_;
            _loc8_ = _loc6_["Slot"];
            _loc8_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMCSlotMove);
            _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.OnMCSlotOut);
            _loc8_.CustomIndex = _loc1_;
            this.FRandomItems[_loc1_] = _loc8_;
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc6_["Btn_Refresh"];
            _loc7_.Tag = _loc1_;
            _loc7_.OnClick = this.OnOneRandomItemRefresh;
            this.FRandomItemRefreshBtns[_loc1_] = _loc7_;
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc6_["Btn_Buy"];
            _loc7_.Tag = _loc1_;
            _loc7_.OnClick = this.OnOneRandomItemBuy;
            this.FRandomItemBuyBtns[_loc1_] = _loc7_;
            _loc1_++;
         }
         this.FRefreshAllItemsBtn = new TUIButton();
         this.FRefreshHeroBtn = new TUIButton();
         this.FExchangeHeroBtn = new TUIButton();
         this.FRefreshAllItemsBtn.Substrate = _loc3_["Btn_Refresh"];
         this.FRefreshAllItemsBtn.OnClick = this.OnAllRandomItemRefresh;
         this.FRefreshHeroBtn.Substrate = _loc4_["Btn_Refresh"];
         this.FRefreshHeroBtn.OnClick = this.OnRefreshHero;
         this.FExchangeHeroBtn.Substrate = _loc4_["Btn_Exchange"];
         this.FExchangeHeroBtn.OnClick = this.OnExchangeHero;
         _loc4_.MC_MountPoint.buttonMode = true;
         _loc4_.MC_MountPoint.addEventListener(MouseEvent.CLICK,this.OnHeroInfo);
         this.FQueryModel = new TMoudleInfor();
         this.FRoleMoudle = new TSceneSpriteMoudle();
         _loc4_.MC_MountPoint.addChild(this.FRoleMoudle);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.Visible = false;
         this.FEffectGlow = new TEffectBaseGlow();
         this.FEffectGlow.SetParameters(_loc3_["Btn_Refresh"],16711680,1);
         this.FGetCardBtn = new TUIButton();
         this.FGetCardBtn.Substrate = _loc3_["Btn_GetCard"];
         this.FGetCardBtn.OnClick = this.OnGetCard;
      }
      
      protected function UpdateRareItems() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:TInventories = null;
         var _loc4_:TInventory = null;
         var _loc5_:TTypeCodeAmount = null;
         _loc1_ = 0;
         while(_loc1_ < THDChristmasCarnivalData.RareItem_Count)
         {
            _loc3_ = new TInventories();
            _loc5_ = this.FData.RareItems[_loc1_];
            SToolReward.GetInventoryByIDAmount(CONST_COMMON.RewardIDToTemplateID(_loc5_.Type,_loc5_.Code),_loc5_.Amount,_loc3_);
            _loc4_ = _loc3_.GetInventoryByIndex(0);
            _loc2_ = this.FRareItems[_loc1_];
            _loc2_.Context = _loc4_;
            _loc1_++;
         }
      }
      
      protected function UpdateRandomItems() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TInventories = null;
         var _loc5_:TInventory = null;
         var _loc6_:TCarnivalRandomItemVO = null;
         var _loc7_:TUIButton = null;
         var _loc8_:TUIButton = null;
         _loc1_ = 0;
         while(_loc1_ < THDChristmasCarnivalData.RandomItem_Count)
         {
            _loc2_ = this.FMC_RandomItems[_loc1_];
            _loc6_ = this.FData.RandomItems[_loc1_];
            _loc3_ = this.FRandomItems[_loc1_];
            _loc3_.gotoAndStop(_loc6_.Frame);
            _loc2_.TF_Name.text = _loc6_.Name;
            _loc2_.TF_CurrentCost.text = _loc6_.DiscountCost.toString();
            _loc2_.TF_CostOriginal.text = _loc6_.Cost.toString();
            _loc2_.TF_Discount.text = this.FData.Language.GetStr0(_loc6_.Discount);
            _loc8_ = this.FRandomItemRefreshBtns[_loc1_];
            _loc7_ = this.FRandomItemBuyBtns[_loc1_];
            _loc7_.Enabled = !_loc6_.Buyed;
            _loc2_.MC_Buyed.visible = _loc6_.Buyed;
            _loc8_.Enabled = !_loc6_.IsMinDiscount && !_loc6_.Buyed;
            _loc2_.MC_MinDiscount.visible = _loc6_.IsMinDiscount;
            _loc1_++;
         }
      }
      
      protected function UpdateHero() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TCarnivalHeroVO = null;
         _loc2_ = this.FData.Hero;
         _loc1_ = this.FMainUI["MC_Hero"];
         _loc1_.TF_HeroName.text = _loc2_.Hero.Name;
         _loc1_.TF_HeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Hero.Quality];
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc2_.Hero.Identifier,this.FQueryModel);
         this.FRoleMoudle.ChangeRoleMoudle(this.FQueryModel.TextureID,1);
         _loc1_.TF_CurrentCost.text = _loc2_.DiscountCost.toString();
         _loc1_.TF_CostOriginal.text = _loc2_.Cost.toString();
         _loc1_.TF_Discount.text = this.FData.Language.GetStr0(_loc2_.Discount);
         this.FExchangeHeroBtn.Enabled = !_loc2_.Exchangeed;
         _loc1_.MC_Exchangeed.visible = _loc2_.Exchangeed;
         this.FRefreshHeroBtn.Enabled = !_loc2_.IsMinDiscount && !_loc2_.Exchangeed;
         _loc1_.MC_MinDiscount.visible = _loc2_.IsMinDiscount;
      }
      
      protected function UpdateOtherUI() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = this.FMainUI["MC_Items"];
         _loc1_.TF_DiscountCoin.text = this.FData.DiscountCoin.toString();
         if(this.FData.RemainFreeRefreshTime > 0)
         {
            this.FEffectGlow.Stop();
         }
      }
      
      protected function CountDown() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         _loc2_ = STimingCore.TickCount / 1000 - this.FLastTick;
         this.FLastTick += _loc2_;
         this.FData.UpdateFreeRefreshTime(_loc2_);
         _loc1_ = this.FMainUI["MC_Items"];
         _loc1_.TF_NextRefreshTime.text = TUtilityTiming.fomatTime(this.FData.RemainFreeRefreshTime);
      }
      
      protected function ShowMsg() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FData.Msg.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            SToolReward.ShowMessage(this.FData.Msg[_loc1_]);
            _loc1_++;
         }
         this.FData.Msg.length = 0;
      }
      
      protected function OnMCSlotMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TCarnivalRandomItemVO = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = uint(_loc2_.CustomIndex);
         _loc4_ = this.FData.RandomItems[_loc3_];
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(_loc4_.Inventories);
         }
      }
      
      protected function OnMCSlotOut(param1:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      protected function OnGetCard(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGetCard != null)
         {
            this.FGetCard();
         }
      }
      
      protected function OnOneRandomItemRefresh(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCarnivalRandomItemVO = null;
         this.FCurrentBtnIndex = (param1 as TUIButton).Tag;
         _loc3_ = this.FData.RandomItems[this.FCurrentBtnIndex];
         this.FNeedDiscountCoin = this.FData.GetNeedDiscountCoinByCount(_loc3_.RefreshCount);
         this.FUIWindowConfirmation.Text = this.FData.Language.GetStr1(this.FNeedDiscountCoin);
         this.FUIWindowConfirmation.OnOK = this.OnOneRandomItemRefreshOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnOneRandomItemBuy(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCarnivalRandomItemVO = null;
         var _loc4_:uint = 0;
         this.FCurrentBtnIndex = (param1 as TUIButton).Tag;
         _loc3_ = this.FData.RandomItems[this.FCurrentBtnIndex];
         _loc4_ = _loc3_.DiscountCost;
         if(_loc4_ > SLogicsCore.Character.CreditGold)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc4_);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         this.FUIWindowConfirmation.Text = this.FData.Language.GetStr6(_loc4_);
         this.FUIWindowConfirmation.OnOK = this.OnOneRandomItemBuyOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnAllRandomItemRefresh(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.RemainFreeRefreshTime == 0)
         {
            this.FSendData(this.FData.Config.RefreshIndex);
         }
         else
         {
            if(this.FData.AllRefreshGold > SLogicsCore.Character.CreditGold)
            {
               this.FUIWindowRecharge.SetGoldNum(this.FData.AllRefreshGold);
               this.FUIWindowRecharge.Visible = true;
               return;
            }
            this.FUIWindowConfirmation.Text = this.FData.Language.GetStr3(this.FData.AllRefreshGold);
            this.FUIWindowConfirmation.OnOK = this.OnAllRandomItemRefreshOK;
            this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function OnRefreshHero(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TCarnivalHeroVO = null;
         _loc4_ = this.FData.Hero;
         this.FNeedDiscountCoin = this.FData.GetNeedDiscountCoinByCount(_loc4_.RefreshCount);
         this.FUIWindowConfirmation.Text = this.FData.Language.GetStr1(this.FNeedDiscountCoin);
         this.FUIWindowConfirmation.OnOK = this.OnRefreshHeroOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnExchangeHero(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TCarnivalHeroVO = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _loc4_ = this.FData.Hero;
         _loc5_ = _loc4_.DiscountCost;
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_.Hero.Identifier) != null)
         {
            _loc6_ = this.FData.Language.GetStr5();
            SToolReward.ShowMessage(_loc6_);
            return;
         }
         if(_loc5_ > SLogicsCore.Character.CreditGold)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc5_);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         this.FUIWindowConfirmation.Text = this.FData.Language.GetStr6(_loc5_);
         this.FUIWindowConfirmation.OnOK = this.OnExchangeHeroOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnHeroInfo(param1:MouseEvent) : void
      {
         var _loc2_:TCarnivalHeroVO = null;
         var _loc3_:TCoordinate = null;
         if(!this.FWindowShowHero.Visible)
         {
            _loc2_ = this.FData.Hero;
            this.FWindowShowHero.HeroID = _loc2_.Hero.Identifier;
            this.FWindowShowHero.Show();
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(FParent);
            this.FWindowShowHero.X = -_loc3_.X;
            this.FWindowShowHero.Y = -_loc3_.Y;
         }
      }
      
      protected function OnOneRandomItemBuyOK(param1:Object) : void
      {
         this.FSendData(this.FData.Config.ItemBuyIndexs[this.FCurrentBtnIndex]);
      }
      
      protected function OnExchangeHeroOK(param1:Object) : void
      {
         this.FSendData(this.FData.Config.Hero.index);
      }
      
      protected function OnOneRandomItemRefreshOK(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this.FNeedDiscountCoin > this.FData.DiscountCoin)
         {
            _loc2_ = this.FData.Language.GetStr2();
            SToolReward.ShowMessage(_loc2_);
            return;
         }
         this.FSendData(this.FData.Config.ItemRefreshIndexs[this.FCurrentBtnIndex]);
      }
      
      protected function OnAllRandomItemRefreshOK(param1:Object) : void
      {
         this.FSendData(this.FData.Config.RefreshIndex);
      }
      
      protected function OnRefreshHeroOK(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this.FNeedDiscountCoin > this.FData.DiscountCoin)
         {
            _loc2_ = this.FData.Language.GetStr2();
            SToolReward.ShowMessage(_loc2_);
            return;
         }
         this.FSendData(this.FData.Config.RefreshHeroIndex);
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set GetCard(param1:Function) : void
      {
         this.FGetCard = param1;
      }
      
      public function set GiftMoveFun(param1:Function) : void
      {
         this.FGiftMoveFun = param1;
      }
      
      public function set GiftOutFun(param1:Function) : void
      {
         this.FGiftOutFun = param1;
      }
      
      public function ShowView(param1:TActivityAtoms, param2:THDActivityBase, param3:TActivityOSBase) : void
      {
         this.FLastTick = STimingCore.TickCount / 1000;
         this.FData = param3 as THDChristmasCarnivalData;
         this.UpdateRareItems();
         this.UpdateRandomItems();
         this.UpdateHero();
         this.UpdateOtherUI();
         this.ShowMsg();
      }
      
      public function CloseCall() : void
      {
         if(this.FWindowShowHero != null)
         {
            this.FWindowShowHero.Hide();
         }
      }
   }
}

