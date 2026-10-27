package Processors.Game.Lobby.HeroCompanion.CardEmploy
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TCompanionEmployMoneyView extends TCompanionBaseView
   {
      
      protected static const TabType_Silver:int = CONST_HEROCOMPANION.TabType_Silver;
      
      protected static const TabType_Gold:int = CONST_HEROCOMPANION.TabType_Gold;
      
      protected static const Free_Count:int = 1;
      
      protected static const Recommend_Num:int = 2;
      
      protected var FTFChipName:TextField;
      
      protected var FTFCostOne:TextField;
      
      protected var FTFCostTen:TextField;
      
      protected var FTFDesc:TextField;
      
      protected var FBtnEmployOne:TUIButton;
      
      protected var FBtnEmployTen:TUIButton;
      
      protected var FCardScroll:TCompanionEmployCardScroll;
      
      protected var FTabIndex:int;
      
      protected var FCostIconOne:MovieClip;
      
      protected var FCostIconTen:MovieClip;
      
      protected var FSilverRecommends:Vector.<int>;
      
      protected var FGoldRecommends:Vector.<int>;
      
      protected var FCardRecommends:Vector.<TCompanionCardItem>;
      
      public function TCompanionEmployMoneyView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UIDispatch(param1);
         this.FTFChipName = FMainUI["TF_ChipName"];
         this.FTFCostOne = FMainUI["TF_Cost_0"];
         this.FTFCostTen = FMainUI["TF_Cost_1"];
         this.FTFDesc = FMainUI["TF_Desc"];
         this.FBtnEmployOne = new TUIButton();
         this.FBtnEmployOne.OnClick = this.EmployOnClick;
         this.FBtnEmployOne.Substrate = FMainUI["Btn_Employ_0"];
         this.FBtnEmployTen = new TUIButton();
         this.FBtnEmployTen.OnClick = this.EmployOnClick;
         this.FBtnEmployTen.Substrate = FMainUI["Btn_Employ_1"];
         this.FCostIconOne = FMainUI["PreIcon_0"];
         this.FCostIconTen = FMainUI["PreIcon_1"];
         this.FCardScroll = new TCompanionEmployCardScroll(FMainUI["MC_CardScroll"]);
         this.FCardScroll.ScrollOnOver = this.CardOnOver;
         this.FCardScroll.ScrollOnOut = this.CardOnOut;
         this.FCardRecommends = new Vector.<TCompanionCardItem>();
         _loc2_ = 0;
         while(_loc2_ < Recommend_Num)
         {
            this.FCardRecommends[_loc2_] = new TCompanionCardItem(FMainUI["MC_Card_" + _loc2_]);
            this.FCardRecommends[_loc2_].ItemOnMove = this.CardOnOver;
            this.FCardRecommends[_loc2_].ItemOnOut = this.CardOnOut;
            _loc2_++;
         }
         this.SetRecommends();
      }
      
      protected function SetRecommends() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:TConfigValue = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_SilverRecommend) as TConfigValue;
         _loc3_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_GoldRecommend) as TConfigValue;
         this.FSilverRecommends = Vector.<int>(_loc2_.Value);
         this.FGoldRecommends = Vector.<int>(_loc3_.Value);
      }
      
      protected function SetCost(param1:int, param2:Vector.<int>, param3:TextField) : void
      {
         if(param1 < param2.length)
         {
            param3.text = param2[param1] + "";
         }
         else
         {
            param3.text = param2[param2.length - 1] + "";
         }
      }
      
      private function EmployOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_EmployReq);
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtnEmployOne:
               _loc6_ = CONST_HEROCOMPANION.SendType_EmployOne;
               break;
            case this.FBtnEmployTen:
               _loc6_ = CONST_HEROCOMPANION.SendType_EmployTen;
         }
         switch(this.FTabIndex)
         {
            case TabType_Silver:
               _loc7_ = TabType_Silver;
               break;
            case TabType_Gold:
               _loc7_ = TabType_Gold;
         }
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(_loc6_);
         _loc5_.writeUnsignedInt(_loc7_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function CardOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionCardItem = null;
         _loc3_ = param1 as TCompanionCardItem;
         if(FTipOnOver != null)
         {
            FTipOnOver(_loc3_.Data);
         }
      }
      
      protected function CardOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(FTipOnOut != null)
         {
            FTipOnOut();
         }
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         super.SetData(param1);
         if(!FIsDataInit)
         {
            this.FCardScroll.InitScroll(FData);
            FIsDataInit = true;
         }
      }
      
      public function ShowTab(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TCompanionCard = null;
         this.FTabIndex = param1;
         _loc2_ = uint(STimingCore.ServerTick);
         if(FData == null)
         {
            return;
         }
         switch(param1)
         {
            case TabType_Silver:
               this.FCostIconOne.gotoAndStop(CONST_HEROCOMPANION.MoneyType_Sliver);
               this.FCostIconTen.gotoAndStop(CONST_HEROCOMPANION.MoneyType_Sliver);
               this.SetCost(FData.SilverTenCount,FData.SilverTenCosts,this.FTFCostTen);
               if(_loc2_ < FData.SilverEmployTime)
               {
                  this.SetCost(FData.SilverOneCount,FData.SilverOneCosts,this.FTFCostOne);
               }
               else
               {
                  this.FTFCostOne.text = "0";
               }
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,this.FSilverRecommends[0]) as TCompanionCard;
               this.FTFChipName.text = _loc4_.Name;
               _loc3_ = 0;
               while(_loc3_ < Recommend_Num)
               {
                  this.FCardRecommends[_loc3_].SetCardData(this.FSilverRecommends[_loc3_]);
                  _loc3_++;
               }
               break;
            case TabType_Gold:
               this.FCostIconOne.gotoAndStop(CONST_HEROCOMPANION.MoneyType_Gold);
               this.FCostIconTen.gotoAndStop(CONST_HEROCOMPANION.MoneyType_Gold);
               this.SetCost(FData.GoldTenCount,FData.GoldTenCosts,this.FTFCostTen);
               if(_loc2_ < FData.GoldEmployTime)
               {
                  this.SetCost(FData.GoldOneCount,FData.GoldOneCosts,this.FTFCostOne);
               }
               else
               {
                  this.FTFCostOne.text = "0";
               }
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,this.FGoldRecommends[0]) as TCompanionCard;
               this.FTFChipName.text = _loc4_.Name;
               _loc3_ = 0;
               while(_loc3_ < Recommend_Num)
               {
                  this.FCardRecommends[_loc3_].SetCardData(this.FGoldRecommends[_loc3_]);
                  _loc3_++;
               }
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(Visible)
         {
            this.FCardScroll.StartScroll();
            _loc2_ = int(STimingCore.ServerTick);
            switch(this.FTabIndex)
            {
               case TabType_Silver:
                  if(FData.SilverEmployTime <= _loc2_)
                  {
                     this.FTFDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_29);
                     return;
                  }
                  _loc1_ = TUtilityTiming.fomatTimeTwo(FData.SilverEmployTime - _loc2_);
                  break;
               case TabType_Gold:
                  if(FData.GoldEmployTime <= _loc2_)
                  {
                     this.FTFDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_29);
                     return;
                  }
                  _loc1_ = TUtilityTiming.fomatTimeTwo(FData.GoldEmployTime - _loc2_);
            }
            this.FTFDesc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_18),_loc1_,Free_Count);
         }
      }
   }
}

