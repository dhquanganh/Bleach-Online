package Processors.Game.Lobby.Activity.HDSoulCarnival.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDSoulBuy;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDSoulCarnival.TSoulBuy;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowSoulBuy extends TProcessorHDSingleWindowBase
   {
      
      protected var FDarkExchangeShop:THDScoreExchangeShop;
      
      protected var FBtn_DarkShop:TUIButton;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_JackPointGet:TUIButton;
      
      protected var FIsinit:Boolean;
      
      protected var FCurBagIndex:uint;
      
      protected var FBags:Vector.<TUIButton>;
      
      protected var FData:TSoulBuy;
      
      public function TProcessorHDWindowSoulBuy(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDSoulBuy = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDSoulBuy;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Block_0"]["TF_Text_" + _loc1_].text = _loc3_.BuyAward[_loc1_].gold + "";
            _loc1_++;
         }
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Block_1"]["TF_Text_" + _loc1_].text = _loc3_.BuyAward[_loc1_ + 4].gold + "";
            _loc1_++;
         }
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Block_2"]["TF_Text_" + _loc1_].text = _loc3_.BuyAward[_loc1_ + 8].gold + "";
            _loc1_++;
         }
         FScene["MC_BigAward"]["TF_Price_4"].text = _loc3_.BigAward.gold + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TSoulBuy;
         if(!this.FIsinit)
         {
            this.SetupDarkShop();
            this.FIsinit = true;
         }
         FScene["TF_Count"].text = this.FData.Score + "";
         this.FDarkExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
         this.UpdateJackPoint();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible && this.FData != null)
         {
         }
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showID);
         this.FBtn_Report.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         if(this.FData.BigAwardStatus == -1)
         {
            FScene["MC_BigAward"]["MC_Exchangeed"].visible = true;
         }
         else
         {
            FScene["MC_BigAward"]["MC_Exchangeed"].visible = false;
         }
      }
      
      protected function SetupDarkShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         _loc4_ = new TInventories();
         _loc5_ = this.FData.Config.ScoreMall.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(this.FData.Config.ScoreMall[_loc6_].score);
            _loc3_.push(this.FData.Config.ScoreMall[_loc6_].limit == 0);
            SToolReward.GetAwardsByAwardID(this.FData.Config.ScoreMall[_loc6_].award,_loc4_);
            _loc6_++;
         }
         this.FDarkExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      protected function ProcessorOpenDarkShop(param1:Object, param2:MouseEvent) : void
      {
         this.FDarkExchangeShop.Visible = true;
         this.FDarkExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
      }
      
      protected function DarkExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.ScoreMall[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_63));
         }
      }
      
      protected function ProcessorGoldBuyJackPoint(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function ProcessorBuy(param1:Object, param2:MouseEvent) : void
      {
         this.FCurBagIndex = param1.Tag;
         GoldBuy(this.FData.Config.BuyAward[param1.Tag].gold,this.ProcessorBuyGold);
      }
      
      protected function ProcessorBuyGold(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BuyAward[this.FCurBagIndex].index);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      protected function BagsOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.Bags[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnListMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.parent.name.split("_")[2]);
         FScene["MC_Block_" + _loc2_]["MC_Mask"].gotoAndStop(2);
      }
      
      protected function OnListOut(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.parent.name.split("_")[2]);
         FScene["MC_Block_" + _loc2_]["MC_Mask"].gotoAndStop(1);
      }
      
      protected function OnListClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.parent.name.split("_")[2]);
         FScene["MC_Block_0"].gotoAndStop(1);
         FScene["MC_Block_0"]["MC_Mask"].visible = true;
         FScene["MC_Block_1"].gotoAndStop(1);
         FScene["MC_Block_1"]["MC_Mask"].visible = true;
         FScene["MC_Block_2"].gotoAndStop(1);
         FScene["MC_Block_2"]["MC_Mask"].visible = true;
         FScene["MC_Block_" + _loc2_]["MC_Mask"].visible = false;
         FScene["MC_Block_" + _loc2_]["Effect"].play();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FBtn_DarkShop = new TUIButton();
         this.FBtn_DarkShop.Substrate = FScene["Btn_Shop"];
         this.FBtn_DarkShop.OnClick = this.ProcessorOpenDarkShop;
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_DarkShop") as MovieClip;
         this.FDarkExchangeShop = new THDScoreExchangeShop(this);
         this.FDarkExchangeShop.ExchangeCall = this.DarkExchangeCall;
         this.FDarkExchangeShop.UIDispatch(_loc4_);
         this.FDarkExchangeShop.Visible = false;
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_BigAward"]);
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_BigAward"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
         this.FBags = new Vector.<TUIButton>(12);
         _loc2_ = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBags[_loc3_] = new TUIButton();
            this.FBags[_loc3_].Substrate = FScene["MC_Block_0"]["MC_Bag_" + _loc3_];
            this.FBags[_loc3_].OnClick = this.ProcessorBuy;
            this.FBags[_loc3_].OnMove = this.BagsOnMove;
            this.FBags[_loc3_].OnOut = this.BagsOnOut;
            this.FBags[_loc3_].Tag = _loc3_ + 0;
            _loc3_++;
         }
         _loc2_ = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBags[_loc3_ + 4] = new TUIButton();
            this.FBags[_loc3_ + 4].Substrate = FScene["MC_Block_1"]["MC_Bag_" + _loc3_];
            this.FBags[_loc3_ + 4].OnClick = this.ProcessorBuy;
            this.FBags[_loc3_ + 4].OnMove = this.BagsOnMove;
            this.FBags[_loc3_ + 4].OnOut = this.BagsOnOut;
            this.FBags[_loc3_ + 4].Tag = _loc3_ + 4;
            _loc3_++;
         }
         _loc2_ = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBags[_loc3_ + 8] = new TUIButton();
            this.FBags[_loc3_ + 8].Substrate = FScene["MC_Block_2"]["MC_Bag_" + _loc3_];
            this.FBags[_loc3_ + 8].OnClick = this.ProcessorBuy;
            this.FBags[_loc3_ + 8].OnMove = this.BagsOnMove;
            this.FBags[_loc3_ + 8].OnOut = this.BagsOnOut;
            this.FBags[_loc3_ + 8].Tag = _loc3_ + 8;
            _loc3_++;
         }
         _loc2_ = 3;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            FScene["MC_Block_" + _loc3_]["MC_Mask"].addEventListener(MouseEvent.MOUSE_MOVE,this.OnListMove);
            FScene["MC_Block_" + _loc3_]["MC_Mask"].addEventListener(MouseEvent.MOUSE_OUT,this.OnListOut);
            FScene["MC_Block_" + _loc3_]["MC_Mask"].addEventListener(MouseEvent.CLICK,this.OnListClick);
            _loc3_++;
         }
      }
   }
}

