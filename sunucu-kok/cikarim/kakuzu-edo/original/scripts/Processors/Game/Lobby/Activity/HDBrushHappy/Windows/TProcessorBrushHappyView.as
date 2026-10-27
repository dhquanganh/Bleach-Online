package Processors.Game.Lobby.Activity.HDBrushHappy.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDBrushHappy.TBrushHappyArticle;
   import Logics.HDBrushHappy.TBrushHappyData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDBrushHappy.Com.TBrushHappyItemUI;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorBrushHappyView extends TProcessorHDSingleWindowBase
   {
      
      protected var FData:TBrushHappyData;
      
      protected var FInvs:Vector.<TUISlot>;
      
      protected var FItems:Vector.<TBrushHappyItemUI>;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FBuyBtn:TUIButton;
      
      protected var FRefreshBtn:TUIButton;
      
      protected var FCurItemID:uint;
      
      protected var FRemain:uint;
      
      public function TProcessorBrushHappyView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FData = param1 as TBrushHappyData;
         this.UpdateWinUI();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         var _loc2_:TBrushHappyItemUI = null;
         super.LogicsPerform();
         if(Visible && this.FInvs != null)
         {
            this.ComTime();
            for each(_loc1_ in this.FInvs)
            {
               _loc1_.Update();
            }
            for each(_loc2_ in this.FItems)
            {
               _loc2_.LogicsPerform();
            }
         }
      }
      
      protected function UpdateWinUI() : void
      {
         var _loc1_:TUISlot = null;
         var _loc2_:TBrushHappyItemUI = null;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         _loc3_ = 0;
         while(_loc3_ < TBrushHappyData.InvsCount)
         {
            _loc1_ = this.FInvs[_loc3_];
            _loc1_.Context = this.FData.Invs.GetInventoryByIndex(_loc3_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < TBrushHappyData.ItemCount)
         {
            _loc2_ = this.FItems[_loc3_];
            _loc2_.Data = this.FData.Articles[_loc3_];
            _loc2_.Update();
            _loc3_++;
         }
         _loc5_ = this.FData.Config.Gift[this.FData.Day];
         _loc4_ = FScene["MC_Hero"];
         FScene["TF_Desc"].text = TUtilityString.Format(this.FData.Config.GiftDesc,_loc5_.level);
         this.FShowAwardUI.SetData(_loc5_.showType,_loc5_.awardId,_loc5_.showID,TOverlayerGiftBox.TYPE_ALL);
         if(this.FData.SpecialItemBuyed)
         {
            this.FBuyBtn.Enabled = false;
            _loc4_.MC_AlreadyGet.visible = true;
         }
         else
         {
            if(SLogicsCore.Character.VipLevel >= _loc5_.level)
            {
               this.FBuyBtn.Enabled = true;
            }
            else
            {
               this.FBuyBtn.Enabled = false;
            }
            _loc4_.MC_AlreadyGet.visible = false;
         }
         _loc4_.TF_OpenCondition.text = _loc5_.gold.toString();
         this.ComTime();
      }
      
      protected function ComTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FData == null)
         {
            return;
         }
         _loc1_ = int(this.FData.Config.Reset.time);
         _loc3_ = int(this.FData.Time);
         _loc2_ = STimingCore.ServerTick - _loc3_;
         this.FRemain = Math.max(_loc1_ - _loc2_,0);
         FScene["MC_Items"].TF_RefreshTime.text = TUtilityTiming.fomatTime(this.FRemain);
      }
      
      protected function ItemBuyCall(param1:uint) : void
      {
         this.FCurItemID = param1;
         GoldBuy(this.FData.Articles[param1].CurPrice,this.ItemBuyOK);
      }
      
      protected function ItemRefreshCall(param1:uint) : void
      {
         this.FCurItemID = param1;
         GoldBuy(this.FData.Articles[param1].DiscountGold,this.ItemRefreshOK);
      }
      
      protected function RefreshBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FRemain == 0)
         {
            this.RefreshOK(null);
         }
         else
         {
            GoldBuy(this.FData.Config.Reset.gold,this.RefreshOK);
         }
      }
      
      protected function BuyBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Gift[this.FData.Day].gold,this.BuyOK);
      }
      
      protected function ItemBuyOK(param1:Object) : void
      {
         var _loc2_:TBrushHappyArticle = null;
         _loc2_ = this.FData.Articles[this.FCurItemID];
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ItemIndexs[this.FCurItemID],0,Vector.<int>([_loc2_.AwardID,_loc2_.CurDiscount]));
      }
      
      protected function ItemRefreshOK(param1:Object) : void
      {
         var _loc2_:TBrushHappyArticle = null;
         _loc2_ = this.FData.Articles[this.FCurItemID];
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Refresh[this.FCurItemID],0,Vector.<int>([_loc2_.AwardID,_loc2_.CurDiscount]));
      }
      
      protected function RefreshOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Reset.index);
         FScene["MC_Items"]["MC_PageEffect"].gotoAndPlay(2);
      }
      
      protected function BuyOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.GiftIndex);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:TBrushHappyItemUI = null;
         super.InitWindow(param1);
         _loc2_ = FScene["MC_Invs"];
         this.FInvs = new Vector.<TUISlot>(TBrushHappyData.InvsCount);
         _loc4_ = 0;
         while(_loc4_ < TBrushHappyData.InvsCount)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc2_["MC_Slot_" + _loc4_];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FInvs[_loc4_] = _loc5_;
            _loc4_++;
         }
         _loc2_ = FScene["MC_Items"];
         this.FItems = new Vector.<TBrushHappyItemUI>(TBrushHappyData.ItemCount);
         _loc4_ = 0;
         while(_loc4_ < TBrushHappyData.ItemCount)
         {
            _loc6_ = new TBrushHappyItemUI(this,_loc4_);
            _loc6_.BuyCall = this.ItemBuyCall;
            _loc6_.RefreshCall = this.ItemRefreshCall;
            _loc6_.UIDispatch(_loc2_["MC_Item_" + _loc4_]);
            this.FItems[_loc4_] = _loc6_;
            _loc4_++;
         }
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = _loc2_.Btn_Refresh;
         this.FRefreshBtn.OnClick = this.RefreshBtnOnClick;
         _loc2_ = FScene["MC_Hero"];
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(_loc2_);
         this.FBuyBtn = new TUIButton();
         this.FBuyBtn.Substrate = _loc2_.Btn_OK;
         this.FBuyBtn.OnClick = this.BuyBtnOnClick;
      }
   }
}

