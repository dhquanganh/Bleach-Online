package Processors.Game.Lobby.HeroCompanion.CardEmploy
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.DatebaseVO.VO.TCompanionEncounter;
   import Logics.DatebaseVO.VO.TVipConfig;
   import Logics.HeroCompanion.THeroCompanionData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionTextArea;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TCompanionEmployEncounterView extends TCompanionBaseView
   {
      
      protected static const Encounter_Num:int = 3;
      
      protected var FCardItemVec:Vector.<TCompanionCardItem>;
      
      protected var FTextArea:TCompanionTextArea;
      
      protected var FTFExtra0:TextField;
      
      protected var FTFExtra1:TextField;
      
      protected var FTFRefresh:TextField;
      
      protected var FTFVip:TextField;
      
      protected var FVipBar:Sprite;
      
      protected var FVip:TBins;
      
      protected var FIsLock:Boolean;
      
      protected var FBtnOne:TUIButton;
      
      protected var FBtnTen:TUIButton;
      
      protected var FTFCostOne:TextField;
      
      protected var FTFCostTen:TextField;
      
      protected var FCostOneSp:MovieClip;
      
      protected var FCostTenSp:MovieClip;
      
      protected var FRecharge:TUIButton;
      
      protected var FTFVipLevel:TextField;
      
      protected var FVipTipStr:String;
      
      protected var FUpdateIcon:Function;
      
      public function TCompanionEmployEncounterView(param1:TUIComponent)
      {
         super(param1);
         this.FCardItemVec = new Vector.<TCompanionCardItem>();
         this.FIsLock = true;
      }
      
      protected function SetCardData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TCompanionCard = null;
         _loc1_ = 0;
         while(_loc1_ < Encounter_Num)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,FData.EncounterCardIds[_loc1_]) as TCompanionCard;
            this.FCardItemVec[_loc1_].SetData(_loc2_);
            _loc1_++;
         }
      }
      
      protected function SetVip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVipConfig = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(FData == null)
         {
            return;
         }
         this.FVip = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         _loc1_ = int(SLogicsCore.Character.VipLevel);
         _loc2_ = int(SLogicsCore.Character.VipData.VipExp);
         _loc3_ = this.FVip.GetDatebaseByIdentifier(_loc1_ + 1) as TVipConfig;
         if(_loc3_ == null)
         {
            _loc3_ = this.FVip.GetDatebaseByIdentifier(_loc1_) as TVipConfig;
         }
         _loc5_ = _loc3_.ChargeCount;
         _loc4_ = _loc2_ / _loc5_;
         _loc4_ = _loc4_ > 0 ? _loc4_ : 0;
         this.FTFVip.text = _loc2_ + "/" + _loc5_;
         this.FVipBar.scaleX = _loc4_;
         this.FIsLock = _loc1_ < FData.EncounterVipLevel;
      }
      
      protected function OnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionCardItem = null;
         _loc3_ = param1 as TCompanionCardItem;
         if(FTipOnOver != null)
         {
            FTipOnOver(_loc3_.Data);
         }
      }
      
      protected function OnOut(param1:Object, param2:MouseEvent) : void
      {
         if(FTipOnOut != null)
         {
            FTipOnOut();
         }
      }
      
      protected function OnEncounterClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         if(this.FIsLock)
         {
            SToolReward.ShowMessage(this.FVipTipStr);
            return;
         }
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtnOne:
               _loc6_ = CONST_HEROCOMPANION.SendType_EmployOne;
               break;
            case this.FBtnTen:
               _loc6_ = CONST_HEROCOMPANION.SendType_EmployTen;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_EmployReq);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(_loc6_);
         _loc5_.writeUnsignedInt(CONST_HEROCOMPANION.SendCost_EmployEncounter);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function OnRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.Visible)
         {
            this.SetVip();
         }
      }
      
      public function get UpdateIcon() : Function
      {
         return this.FUpdateIcon;
      }
      
      public function set UpdateIcon(param1:Function) : void
      {
         this.FUpdateIcon = param1;
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TCompanionCardItem = null;
         super.UIDispatch(param1);
         _loc2_ = 0;
         while(_loc2_ < Encounter_Num)
         {
            _loc3_ = new TCompanionCardItem(FMainUI["MC_Card_" + _loc2_]);
            _loc3_.ItemOnMove = this.OnOver;
            _loc3_.ItemOnOut = this.OnOut;
            this.FCardItemVec.push(_loc3_);
            _loc2_++;
         }
         this.FTextArea = new TCompanionTextArea(this);
         this.FTextArea.Substrate = FMainUI["MC_List"];
         this.FTextArea.Init();
         this.FTextArea.HtmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_05);
         this.FTFExtra0 = FMainUI["TF_Extra_0"];
         this.FTFExtra1 = FMainUI["TF_Extra_1"];
         this.FTFRefresh = FMainUI["TF_Refresh"];
         this.FBtnOne = new TUIButton();
         this.FBtnOne.Substrate = FMainUI["Btn_Encounter_0"];
         this.FBtnOne.OnClick = this.OnEncounterClick;
         this.FBtnTen = new TUIButton();
         this.FBtnTen.Substrate = FMainUI["Btn_Encounter_1"];
         this.FBtnTen.OnClick = this.OnEncounterClick;
         this.FCostOneSp = FMainUI["PreIcon_0"];
         this.FCostOneSp.gotoAndStop(CONST_HEROCOMPANION.MoneyType_Gold);
         this.FCostTenSp = FMainUI["PreIcon_1"];
         this.FCostTenSp.gotoAndStop(CONST_HEROCOMPANION.MoneyType_Gold);
         this.FTFCostOne = FMainUI["TF_Cost_0"];
         this.FTFCostTen = FMainUI["TF_Cost_1"];
         this.FTFVip = FMainUI["TF_VipExp"];
         this.FTFVip.mouseEnabled = false;
         this.FVipBar = FMainUI["MC_Bar"];
         this.FRecharge = new TUIButton();
         this.FRecharge.Substrate = FMainUI["Btn_Recharge"];
         this.FRecharge.OnClick = this.OnRecharge;
         this.FTFVipLevel = FMainUI["TF_Vip"];
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
      
      public function SendServer() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_EncounterReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         FData.EncounterStatus = true;
         this.FUpdateIcon();
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TCompanionCard = null;
         var _loc4_:TCompanionEncounter = null;
         var _loc5_:TArticle = null;
         super.SetData(param1);
         _loc2_ = 0;
         while(_loc2_ < Encounter_Num)
         {
            this.FCardItemVec[_loc2_].SetCardData(FData.EncounterCardIds[_loc2_]);
            _loc2_++;
         }
         this.FTFVipLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_01),SLogicsCore.Character.VipLevel);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,FData.EncounterCardIds[0]) as TCompanionCard;
         this.FTFExtra0.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_04),_loc3_.Name);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionEncounter,FData.EncounterId) as TCompanionEncounter;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc4_.Award.Code) as TArticle;
         this.FTFExtra1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_06),_loc5_.Name);
         this.SetCost(FData.EncounterOneCount,FData.EncounterOneCosts,this.FTFCostOne);
         this.SetCost(FData.EncounterTenCount,FData.EncounterTenCosts,this.FTFCostTen);
         if(!FIsDataInit)
         {
            this.FVipTipStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_07),FData.EncounterVipLevel);
            FIsDataInit = true;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.FTFRefresh.text = TUtilityTiming.fomatTimeTwo(FData.EncounterTime - STimingCore.ServerTick);
         this.FTextArea.Update();
      }
   }
}

