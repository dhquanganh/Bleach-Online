package Processors.Game.Lobby.CollectSoul
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TVipConfig;
   import Logics.Inventories.TInventories;
   import Logics.SoulCollection.TCollectSoul;
   import Logics.SoulCollection.TSoulCollectionBase;
   import Logics.SoulCollection.TSoulCollectionShop;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowCollectionSoul extends TProcessorLobbyWindow
   {
      
      protected static const PROGERSSMAX:uint = 500;
      
      protected static const JUNIORCOSTBASE:uint = 10000001;
      
      protected static const SENIORCOSTBASE:uint = 10000002;
      
      protected static const SUPERCOSTBASE:uint = 10000003;
      
      protected static const COSTOFF:uint = 61600001;
      
      protected static const ENERGYMAX:uint = 61600002;
      
      protected static const SILVERNUMBER:uint = 61600005;
      
      protected static const DAYNUMMAX:uint = 61600007;
      
      protected static const DAYNUMCOST:uint = 61600006;
      
      protected var FMainUI:MovieClip;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FSP_Shop:MovieClip;
      
      protected var FSP_Main:Sprite;
      
      protected var FSP_Junior:Sprite;
      
      protected var FSP_Senior:Sprite;
      
      protected var FSP_Super:Sprite;
      
      protected var FSP_Bottom:Sprite;
      
      protected var FTF_DayNum:TextField;
      
      protected var FBtn_BuyDayNum:TUIButton;
      
      protected var FBtn_Junior:Vector.<TUIButton>;
      
      protected var FBtn_Senior:Vector.<TUIButton>;
      
      protected var FBtn_Super:TUIButton;
      
      protected var FTF_JuniorCosts:Vector.<TextField>;
      
      protected var FTF_SeniorCosts:Vector.<TextField>;
      
      protected var FTF_SuperCost:TextField;
      
      protected var FTF_JuniorTimer:TextField;
      
      protected var FTF_SeniorTimer_0:TextField;
      
      protected var FTF_SeniorTimer_1:TextField;
      
      protected var FSuperSlots:Vector.<TUISlot>;
      
      protected var FBtn_ShowShop:TUIButton;
      
      protected var FTF_Progress:TextField;
      
      protected var FSP_ProgressBar:Sprite;
      
      protected var FShop:THDScoreExchangeShop;
      
      protected var FInitInventories:TInventories;
      
      protected var FShopInventories:TInventories;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FRetUI:TUIResultView;
      
      protected var FSilvernumber:uint;
      
      protected var FBtnFlag:uint;
      
      protected var FHint:THint;
      
      protected var FVipHint:Vector.<uint>;
      
      protected var FEngeryMax:uint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FFreeText:String;
      
      protected var FData:TCollectSoul;
      
      public function TProcessorWindowCollectionSoul(param1:TUIComponent)
      {
         super(param1);
         this.FInitInventories = new TInventories();
         this.FShopInventories = new TInventories();
         this.FData = new TCollectSoul();
         this.FHint = new THint();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_SoulCollection") as MovieClip;
         addChild(this.FMainUI);
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.Btn_Close;
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         this.FSP_Shop = this.FMainUI["SP_Shop"];
         this.FSP_Main = this.FMainUI["SP_Main"];
         this.FSP_Junior = this.FSP_Main["SP_junior"];
         this.FSP_Senior = this.FSP_Main["SP_senior"];
         this.FSP_Super = this.FSP_Main["SP_super"];
         this.FSP_Bottom = this.FSP_Main["SP_bottom"];
         this.FTF_DayNum = this.FSP_Main["TF_DayNum"];
         this.FBtn_BuyDayNum = new TUIButton();
         this.FBtn_BuyDayNum.Substrate = this.FSP_Main["Btn_BuyDayNum"];
         this.FBtn_BuyDayNum.OnClick = this.ProcessorBuyDayNum;
         this.FBtn_BuyDayNum.OnMove = this.ProcessorOnMove;
         this.FBtn_BuyDayNum.OnOut = this.ProcessorOnOut;
         this.FBtn_ShowShop = new TUIButton();
         this.FBtn_ShowShop.Substrate = this.FSP_Bottom["Btn_Shop"];
         this.FBtn_ShowShop.OnClick = this.ProcessorShowShop;
         this.FTF_Progress = this.FSP_Bottom["TF_Progress"];
         this.FSP_ProgressBar = this.FSP_Bottom["SP_Progress"]["SP_ProgressBar"];
         _loc2_ = 2;
         this.FBtn_Junior = new Vector.<TUIButton>(_loc2_);
         this.FBtn_Senior = new Vector.<TUIButton>(_loc2_);
         this.FTF_JuniorCosts = new Vector.<TextField>(_loc2_);
         this.FTF_SeniorCosts = new Vector.<TextField>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBtn_Junior[_loc1_] = new TUIButton();
            this.FBtn_Junior[_loc1_].Substrate = this.FSP_Junior["Btn_" + _loc1_];
            this.FBtn_Junior[_loc1_].OnClick = this.ProcessorCollect;
            this.FBtn_Senior[_loc1_] = new TUIButton();
            this.FBtn_Senior[_loc1_].Substrate = this.FSP_Senior["Btn_" + _loc1_];
            this.FBtn_Senior[_loc1_].OnClick = this.ProcessorCollect;
            this.FTF_JuniorCosts[_loc1_] = this.FSP_Junior["TF_Cost_" + _loc1_];
            this.FTF_SeniorCosts[_loc1_] = this.FSP_Senior["TF_Cost_" + _loc1_];
            _loc1_++;
         }
         this.FTF_JuniorTimer = this.FSP_Junior["TF_Timer"];
         this.FTF_SeniorTimer_0 = this.FSP_Senior["TF_Timer_0"];
         this.FTF_SeniorTimer_1 = this.FSP_Senior["TF_Timer_1"];
         this.FBtn_Super = new TUIButton();
         this.FBtn_Super.Substrate = this.FSP_Super["Btn_0"];
         this.FBtn_Super.OnClick = this.ProcessorCollect;
         this.FTF_SuperCost = this.FSP_Super["TF_Cost"];
         this.FBtn_Junior[0].Tag = 0;
         this.FBtn_Junior[1].Tag = 1;
         this.FBtn_Senior[0].Tag = 2;
         this.FBtn_Senior[1].Tag = 3;
         this.FBtn_Super.Tag = 4;
         _loc2_ = 4;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_] = new TUISlot(this);
            this.FSlots[_loc1_].Resource = this.FSP_Super["Slot" + _loc1_];
            this.FSlots[_loc1_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc1_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc1_]);
            this.FSlots[_loc1_].Init();
            _loc1_++;
         }
         this.FShop = new THDScoreExchangeShop(this);
         this.FShop.UIDispatch(this.FSP_Shop,12);
         this.FShop.ExchangeCall = this.ProcessorShopBuy;
         this.FRetUI = new TUIResultView(this);
         this.FRetUI.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_SoulCollectionRet") as MovieClip);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function ProcessorOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(param1,this.FHint);
      }
      
      protected function ProcessorOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(param1,this.FHint);
      }
      
      protected function ProcessorShowShop(param1:Object, param2:MouseEvent) : void
      {
         this.FShop.Visible = true;
         this.FShop.Update(100,this.FData.CargoStatus);
      }
      
      protected function ProcessorCollect(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnFlag = param1.Tag;
         if(this.FData.Energy >= this.FEngeryMax)
         {
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_TipTextView03);
            this.FUIWindowConfirmation.OnOK = this.ProcessorCollectConfirm;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.ProcessorCollectConfirm(param1);
         }
      }
      
      protected function ProcessorCollectConfirm(param1:Object) : void
      {
         var _loc2_:uint = 0;
         switch(this.FBtnFlag)
         {
            case 0:
               this.ProcessorGoldBuy(this.FBtnFlag);
               break;
            case 1:
               this.ProcessorGoldBuy(this.FBtnFlag);
               break;
            case 2:
               _loc2_ = uint(this.FTF_SeniorCosts[0].text);
               if(this.FTF_SeniorTimer_0.visible == false)
               {
                  this.ProcessorGoldBuy(this.FBtnFlag);
                  return;
               }
               TUtilityLobby.GoldBuy(_loc2_,this.ProcessorGoldBuy);
               break;
            case 3:
               if(this.FTF_SeniorTimer_1.visible == false)
               {
                  this.ProcessorGoldBuy(this.FBtnFlag);
                  return;
               }
               _loc2_ = uint(this.FTF_SeniorCosts[1].text);
               TUtilityLobby.GoldBuy(_loc2_,this.ProcessorGoldBuy);
               break;
            case 4:
               _loc2_ = uint(this.FTF_SuperCost.text);
               TUtilityLobby.GoldBuy(_loc2_,this.ProcessorGoldBuy);
         }
      }
      
      protected function ProcessorGoldBuy(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CollectSoul_OperatorReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FBtnFlag);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorBuyDayNum(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:TConfigValue = null;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,DAYNUMCOST) as TConfigValue;
         _loc6_ = _loc7_.Value as Vector.<uint>;
         if(this.FData.VipCount >= _loc6_.length)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_41));
            return;
         }
         _loc3_ = _loc6_[this.FData.VipCount];
         TUtilityLobby.GoldBuy(_loc3_,this.ProcessorBuyDayNumConfirm);
      }
      
      protected function ProcessorBuyDayNumConfirm(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CollectSoul_VipBuyReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorShopBuy(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:TBins = null;
         var _loc5_:uint = 0;
         var _loc6_:TConfigValue = null;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,ENERGYMAX) as TConfigValue;
         _loc5_ = _loc6_.Value as uint;
         if(this.FData.Energy < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_TipTextView07));
            return;
         }
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoulCollectionShop) as TBins;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CollectSoul_MallReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc4_.GetDatebaseByIndex(param1).Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TSoulCollectionShop = null;
         var _loc3_:TSoulCollectionBase = null;
         var _loc4_:TConfigValue = null;
         var _loc5_:TBins = null;
         var _loc6_:TVipConfig = null;
         var _loc7_:Number = NaN;
         var _loc8_:TRewards = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Vector.<uint> = null;
         var _loc12_:Vector.<Boolean> = null;
         this.FVipHint = new Vector.<uint>();
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,DAYNUMMAX) as TConfigValue;
         this.FVipHint.push(_loc4_.Value);
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         _loc9_ = uint(_loc5_.Count);
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc6_ = _loc5_.GetDatebaseByIndex(_loc10_) as TVipConfig;
            this.FVipHint.push(_loc6_.LotteryRecruitNum);
            _loc10_++;
         }
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_LvVipBuyNum),this.FVipHint[0],this.FVipHint[1],this.FVipHint[2],this.FVipHint[3],this.FVipHint[4],this.FVipHint[5],this.FVipHint[6],this.FVipHint[7],this.FVipHint[8],this.FVipHint[9],this.FVipHint[10],this.FVipHint[11]);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,COSTOFF) as TConfigValue;
         _loc7_ = _loc4_.Value as Number;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoulCollectionShop) as TBins;
         _loc9_ = uint(_loc1_.Count);
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc2_ = _loc1_.GetDatebaseByIndex(_loc10_) as TSoulCollectionShop;
            _loc8_ = new TRewards([_loc2_.ExchangeReward]);
            SToolReward.CreateRewardInventoryByRewardInfor(_loc8_,this.FShopInventories);
            _loc10_++;
         }
         _loc11_ = new Vector.<uint>(_loc9_);
         _loc12_ = new Vector.<Boolean>(_loc9_);
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc2_ = _loc1_.GetDatebaseByIndex(_loc10_) as TSoulCollectionShop;
            _loc12_[_loc10_] = _loc2_.Frequency == 0;
            _loc10_++;
         }
         this.FShop.SetupBasicInfo(this.FShopInventories,_loc11_,_loc12_);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SoulCollectionBase,JUNIORCOSTBASE) as TSoulCollectionBase;
         this.FTF_JuniorCosts[0].text = _loc3_.LotteryConsume.amount + "";
         this.FTF_JuniorCosts[1].text = _loc3_.LotteryConsume.amount * _loc7_ * 10 + "";
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SoulCollectionBase,SENIORCOSTBASE) as TSoulCollectionBase;
         this.FTF_SeniorCosts[0].text = _loc3_.LotteryConsume.amount + "";
         this.FTF_SeniorCosts[1].text = _loc3_.LotteryConsume.amount * _loc7_ * 10 + "";
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SoulCollectionBase,SUPERCOSTBASE) as TSoulCollectionBase;
         this.FTF_SuperCost.text = _loc3_.LotteryConsume.amount + "";
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,SILVERNUMBER) as TConfigValue;
         this.FSilvernumber = _loc4_.Value as uint;
         this.FFreeText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_Time);
         this.FSP_Senior["TF_Off"].text = this.FSP_Junior["TF_Off"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_Discount),_loc7_ * 10);
         this.FSP_Junior["TF_Desc"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_TipTextView01);
         this.FSP_Senior["TF_Desc"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_TipTextView06);
         this.FSP_Bottom["TF_GameDesc"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.LotteryRecruit_TipTextView02);
         super.ResourcesPerform_UIFinalize();
      }
      
      protected function UpdateData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TConfigValue = null;
         this.FTF_DayNum.text = this.FData.DayNum.toString();
         _loc1_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSlots[_loc2_].Context = this.FData.SuperInvs.GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,ENERGYMAX) as TConfigValue;
         this.FEngeryMax = _loc5_.Value as uint;
         _loc3_ = this.FData.Energy > this.FEngeryMax ? this.FEngeryMax : this.FData.Energy;
         _loc4_ = this.FEngeryMax;
         this.FTF_Progress.text = _loc3_.toString() + "/" + _loc4_.toString();
         if(_loc3_ / _loc4_ >= 1)
         {
            this.FSP_ProgressBar.width = PROGERSSMAX;
            return;
         }
         this.FSP_ProgressBar.width = PROGERSSMAX * (_loc3_ / _loc4_);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.LogicsPerform();
         if(!this.Visible || this.FData == null)
         {
            return;
         }
         _loc1_ = this.FData.JuniorTimer - STimingCore.ServerTick;
         this.FTF_JuniorTimer.text = TUtilityTiming.fomatTimeTwo(_loc1_).toString() + this.FFreeText;
         this.FTF_JuniorTimer.visible = _loc1_ <= 0 ? false : true;
         this.FSP_Junior["SP_Free"].visible = _loc1_ <= 0 ? true : false;
         _loc1_ = this.FData.SeniorTimer_0 - STimingCore.ServerTick;
         this.FTF_SeniorTimer_0.text = TUtilityTiming.fomatTimeTwo(_loc1_).toString() + this.FFreeText;
         this.FTF_SeniorTimer_0.visible = _loc1_ <= 0 ? false : true;
         this.FSP_Senior["SP_Free_0"].visible = _loc1_ <= 0 ? true : false;
         _loc1_ = this.FData.SeniorTimer_1 - STimingCore.ServerTick;
         this.FTF_SeniorTimer_1.text = TUtilityTiming.fomatTimeTwo(_loc1_).toString() + this.FFreeText;
         this.FTF_SeniorTimer_1.visible = _loc1_ <= 0 ? false : true;
         this.FSP_Senior["SP_Free_1"].visible = _loc1_ <= 0 ? true : false;
         if(this.FSilvernumber - this.FData.SilverFreeCount <= 0)
         {
            this.FSP_Junior["SP_Free"].visible = false;
            this.FTF_JuniorTimer.visible = false;
         }
         _loc3_ = 4;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FSlots[_loc4_].Update();
            _loc4_++;
         }
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function UpdateDataBase(param1:TCollectSoul) : void
      {
         this.FData = param1;
         this.UpdateData();
      }
      
      public function ShowRet(param1:TInventories) : void
      {
         this.FRetUI.show(param1);
      }
   }
}

