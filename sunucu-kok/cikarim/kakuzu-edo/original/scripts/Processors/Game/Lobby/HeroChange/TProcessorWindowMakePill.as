package Processors.Game.Lobby.HeroChange
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowMakePill extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FSlotNormalPill:TUISlot;
      
      protected var FTFNormalPillName:TextField;
      
      protected var FTFNormalPillNum:TextField;
      
      protected var FSlotGradePill:TUISlot;
      
      protected var FTFGradePillName:TextField;
      
      protected var FTFGradePillNum:TextField;
      
      protected var FBtnSiliverMake:TUIButton;
      
      protected var FBtnSiliverOneKeyMake:TUIButton;
      
      protected var FBtnGoldMake:TUIButton;
      
      protected var FBtnGoldOneKeyMake:TUIButton;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FSiliverMakeCost:int;
      
      protected var FSiliverOneKeyMakeCost:int;
      
      protected var FGoldMakeCost:int;
      
      protected var FGoldOneKeyMakeCost:int;
      
      protected var FOneKeyTime:int;
      
      protected var FIfPormot:Boolean;
      
      protected var FHint:THint;
      
      protected var FOnExchagne:Function;
      
      protected var FHeroChangeData:THeroChangeData;
      
      public function TProcessorWindowMakePill(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSoulPill();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MakePillView") as Sprite;
         addChild(this.FMainUI);
         _loc1_ = this.FMainUI["NormalPill"];
         this.FSlotNormalPill = new TUISlot(this);
         this.FSlotNormalPill.Resource = _loc1_["mc_slot"];
         TJadeCommon.InitSlot(this.FSlotNormalPill);
         this.FSlotNormalPill.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotNormalPill.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotNormalPill.Init();
         this.FTFNormalPillName = _loc1_["Name"];
         this.FTFNormalPillNum = _loc1_["Num"];
         _loc1_ = this.FMainUI["GradelPill"];
         this.FSlotGradePill = new TUISlot(this);
         this.FSlotGradePill.Resource = _loc1_["mc_slot"];
         TJadeCommon.InitSlot(this.FSlotGradePill);
         this.FSlotGradePill.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotGradePill.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotGradePill.Init();
         this.FTFGradePillName = _loc1_["Name"];
         this.FTFGradePillNum = _loc1_["Num"];
         this.FBtnSiliverMake = new TUIButton();
         this.FBtnSiliverMake.Substrate = this.FMainUI["SiliverMake"];
         this.FBtnSiliverMake.OnClick = this.BtnSiliverMakeOnClick;
         this.FBtnSiliverMake.OnMove = this.BtnSiliverMakeOnOver;
         this.FBtnSiliverMake.OnOut = this.BtnOnOut;
         this.FBtnSiliverOneKeyMake = new TUIButton();
         this.FBtnSiliverOneKeyMake.Substrate = this.FMainUI["SiliverOneKeyMake"];
         this.FBtnSiliverOneKeyMake.OnClick = this.BtnSiliverOneKeyMakeOnClick;
         this.FBtnSiliverOneKeyMake.OnMove = this.BtnSiliverOneKeyMakeOnOver;
         this.FBtnSiliverOneKeyMake.OnOut = this.BtnOnOut;
         this.FBtnGoldMake = new TUIButton();
         this.FBtnGoldMake.Substrate = this.FMainUI["GoldMake"];
         this.FBtnGoldMake.OnClick = this.BtnGoldMakeOnClick;
         this.FBtnGoldMake.OnMove = this.BtnGoldMakeOnOver;
         this.FBtnGoldMake.OnOut = this.BtnOnOut;
         this.FBtnGoldOneKeyMake = new TUIButton();
         this.FBtnGoldOneKeyMake.Substrate = this.FMainUI["GoldOneKeyMake"];
         this.FBtnGoldOneKeyMake.OnClick = this.BtnGoldOneKeyMakeOnClick;
         this.FBtnGoldOneKeyMake.OnMove = this.BtnGoldOneKeyMakeOnOver;
         this.FBtnGoldOneKeyMake.OnOut = this.BtnOnOut;
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = this.FMainUI["Btn_Exchange"];
         this.FBtnExchange.OnClick = this.BtnExchangeOnclick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FHint = new THint();
      }
      
      public function UILocation() : void
      {
         var _loc1_:TConfigValue = null;
         this.FOneKeyTime = 50;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SilverMakePill) as TConfigValue;
         this.FSiliverMakeCost = _loc1_.Value[0];
         this.FSiliverOneKeyMakeCost = this.FSiliverMakeCost * this.FOneKeyTime;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GoldMakePill) as TConfigValue;
         this.FGoldMakeCost = _loc1_.Value[0];
         this.FGoldOneKeyMakeCost = this.FGoldMakeCost * this.FOneKeyTime;
         this.FIfPormot = true;
      }
      
      protected function RenderUI() : void
      {
         this.FSlotNormalPill.Context = this.FHeroChangeData.NormalSoulPillInventory;
         this.FTFNormalPillName.text = this.FHeroChangeData.NormalSoulPillInventory.Name;
         this.FTFNormalPillName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FHeroChangeData.NormalSoulPillInventory.Quality];
         this.FTFNormalPillNum.text = this.FHeroChangeData.NormalSoulPillNum.toString();
         this.FSlotGradePill.Context = this.FHeroChangeData.GradeSoulPillInventory;
         this.FTFGradePillName.text = this.FHeroChangeData.GradeSoulPillInventory.Name;
         this.FTFGradePillName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FHeroChangeData.GradeSoulPillInventory.Quality];
         this.FTFGradePillNum.text = this.FHeroChangeData.GradeSoulPillNum.toString();
      }
      
      protected function RequestMakePill(param1:int) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(param1)
         {
            case CONST_HEROCHANGE.MAKEPILLTYPE_Siliver:
               _loc3_ = CONST_HEROCHANGE.MAKEPILLCOST_Siliver;
               _loc4_ = 1;
               break;
            case CONST_HEROCHANGE.MAKEPILLTYPE_SiliverOneKey:
               _loc3_ = CONST_HEROCHANGE.MAKEPILLCOST_Siliver;
               _loc4_ = this.FOneKeyTime;
               break;
            case CONST_HEROCHANGE.MAKEPILLTYPE_Gold:
               _loc3_ = CONST_HEROCHANGE.MAKEPILLCOST_GOLD;
               _loc4_ = 1;
               break;
            case CONST_HEROCHANGE.MAKEPILLTYPE_GoldOneKey:
               _loc3_ = CONST_HEROCHANGE.MAKEPILLCOST_GOLD;
               _loc4_ = this.FOneKeyTime;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_MakePillReq);
         _loc2_.Data.writeInt(_loc3_);
         _loc2_.Data.writeInt(_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function UpdateSoulPill() : void
      {
         this.FSlotNormalPill.Update();
         this.FSlotGradePill.Update();
      }
      
      protected function WindowConfirmationChooseOK(param1:Object) : void
      {
         this.RequestMakePill(SUtilityOverLayer.UIWindowConfirmation.Tag);
         this.FIfPormot = !SUtilityOverLayer.UIWindowConfirmation.IsSelected;
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnSiliverMakeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.RequestMakePill(CONST_HEROCHANGE.MAKEPILLTYPE_Siliver);
      }
      
      protected function BtnSiliverMakeOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_14),this.FSiliverMakeCost,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin),1);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnSiliverOneKeyMakeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.RequestMakePill(CONST_HEROCHANGE.MAKEPILLTYPE_SiliverOneKey);
      }
      
      protected function BtnSiliverOneKeyMakeOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_14),this.FSiliverOneKeyMakeCost,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin),this.FOneKeyTime);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnGoldMakeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGoldMakeCost > SLogicsCore.Character.CreditGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FIfPormot)
         {
            SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(true);
            SUtilityOverLayer.UIWindowConfirmation.SetSelected(false);
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_13),this.FGoldMakeCost,1);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowConfirmationChooseOK;
            SUtilityOverLayer.UIWindowConfirmation.Tag = CONST_HEROCHANGE.MAKEPILLTYPE_Gold;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            return;
         }
         this.RequestMakePill(CONST_HEROCHANGE.MAKEPILLTYPE_Gold);
      }
      
      protected function BtnGoldMakeOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_14),this.FGoldMakeCost,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Gold),1);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnGoldOneKeyMakeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGoldOneKeyMakeCost > SLogicsCore.Character.CreditGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FIfPormot)
         {
            SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(true);
            SUtilityOverLayer.UIWindowConfirmation.SetSelected(false);
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_13),this.FGoldOneKeyMakeCost,this.FOneKeyTime);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowConfirmationChooseOK;
            SUtilityOverLayer.UIWindowConfirmation.Tag = CONST_HEROCHANGE.MAKEPILLTYPE_GoldOneKey;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            return;
         }
         this.RequestMakePill(CONST_HEROCHANGE.MAKEPILLTYPE_GoldOneKey);
      }
      
      protected function BtnGoldOneKeyMakeOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_14),this.FGoldOneKeyMakeCost,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Gold),this.FOneKeyTime);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnExchangeOnclick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         if(this.FOnExchagne != null)
         {
            this.FOnExchagne(this);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(false);
         SUtilityOverLayer.UIWindowConfirmation.SetSelected(false);
         this.FSlotNormalPill.Context = null;
         this.FSlotGradePill.Context = null;
      }
      
      public function set OnExchagne(param1:Function) : void
      {
         this.FOnExchagne = param1;
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function Show() : void
      {
         Visible = true;
         this.RenderUI();
      }
      
      public function MakePillNotify() : void
      {
         this.RenderUI();
      }
   }
}

