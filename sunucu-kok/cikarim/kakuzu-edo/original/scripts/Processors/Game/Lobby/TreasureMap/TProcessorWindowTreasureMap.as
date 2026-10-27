package Processors.Game.Lobby.TreasureMap
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Logics.TreasureMap.*;
   import Logics.Vip.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   
   public class TProcessorWindowTreasureMap extends TUIComponent
   {
      
      protected static const MAX_REPORT_Count:uint = 40;
      
      protected static const MAX_COUNT_Slot:uint = 8;
      
      public static var StrFilters:GlowFilter = new GlowFilter(1971469,1,3,3,10);
      
      protected var FScene:MovieClip;
      
      protected var FMC_TreasureBaseData:Sprite;
      
      protected var FMC_ReportAll:MovieClip;
      
      protected var FMC_Control:Sprite;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FHintFastTip:THint;
      
      protected var FHint:THint;
      
      protected var FTreasureMapData:TTreasureMapData;
      
      protected var FTreasureMapHero:TTreasureMapHero;
      
      protected var FCharacter:TCharacter;
      
      protected var FVip:TVip;
      
      protected var FMaxEnterTimes:int;
      
      protected var FMaxRobberyTimes:int;
      
      protected var FGameWinLessTimes:int;
      
      protected var FFastCost:int;
      
      protected var FFastCostUnit:int;
      
      protected var FDiggingBins:TBins;
      
      protected var FStarMapBins:TBins;
      
      protected var FStarPointBins:TBins;
      
      protected var FReportScrollBar:TScrollBar;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FFreeReportTextFieldVect:Vector.<TextField>;
      
      protected var FUICredits:TUICredits;
      
      protected var FVipAddCountNeedGoldVect:Vector.<uint>;
      
      protected var FHelpTips:THint;
      
      protected var FBT_Back:TUIButton;
      
      protected var FBT_StartHunting:TUIButton;
      
      protected var FBT_ExchangeStar:TUIButton;
      
      protected var FBT_Fast:TUIButton;
      
      protected var FBT_ReportShow:TUIButton;
      
      protected var FBT_ReportHide:TUIButton;
      
      protected var FIsInitialization:Boolean;
      
      protected var FOnEnterCity:Function;
      
      protected var FOnOpenDigMap:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnEffectText:Function;
      
      protected var FOnApplianceOnOver:Function;
      
      protected var FOnApplianceOnOut:Function;
      
      protected var FTutorialNextStep:Function;
      
      protected var FOnRewardOver:Function;
      
      protected var FOnRewardOut:Function;
      
      protected var FOnOpenWindowExchange:Function;
      
      protected var FOnShowHeros:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      public function TProcessorWindowTreasureMap(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:uint = 0;
         var _loc4_:TConfigValue = null;
         var _loc5_:TEffectBaseFlicker = null;
         super(param1);
         this.FScene = param2;
         this.FMC_TreasureBaseData = this.FScene["mc_treasureBaseData"];
         this.FMC_ReportAll = this.FScene["mc_reportAll"];
         this.FMC_Control = this.FScene["MC_Control"];
         this.FCharacter = SLogicsCore.Character;
         this.FVip = this.FCharacter.VipData;
         this.FIDTemplates = new Vector.<uint>(MAX_COUNT_Slot);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_FreeQuency) as TConfigValue;
         this.FMaxEnterTimes = int(_loc4_.Value);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_Plunder) as TConfigValue;
         this.FMaxRobberyTimes = int(_loc4_.Value);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_ColdTime) as TConfigValue;
         this.FGameWinLessTimes = int(_loc4_.Value);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_CD_Gold) as TConfigValue;
         this.FFastCost = int(_loc4_.Value.value);
         this.FFastCostUnit = int(_loc4_.Value.time);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_Time_Gold) as TConfigValue;
         this.FVipAddCountNeedGoldVect = _loc4_.Value as Vector.<uint>;
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         this.FStarMapBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarMap);
         this.FStarPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarPoint);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,CONST_FRESHGUIDE.MCID_TreasureMap,this);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,CONST_FRESHGUIDE.MCID_TreasureMap,FParent);
         this.InitWindowTreasureMap();
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FIsInitialization)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.FMC_TreasureBaseData.x = _loc1_ - this.FMC_TreasureBaseData.width + 12;
         this.FMC_ReportAll.x = _loc1_ - 30;
         this.FMC_ReportAll.y = _loc2_ - 232;
         this.FMC_Control.x = _loc1_ - this.FMC_Control.width;
         this.FMC_Control.y = _loc2_ - this.FMC_Control.height;
         this.FBT_Back.Y = _loc2_ - this.FBT_Back.Height;
      }
      
      protected function InitWindowTreasureMap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         this.FBT_Back = new TUIButton();
         this.FBT_Back.Substrate = this.FScene.btn_back;
         this.FBT_Back.OnClick = this.OnClose;
         this.FScene.mc_autoPoint.Btn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver);
         this.FScene.mc_autoPoint.Btn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut);
         this.FBT_StartHunting = new TUIButton();
         this.FBT_StartHunting.Substrate = this.FScene.MC_Control.Btn_StartHunting;
         this.FBT_StartHunting.OnClick = this.OnOpenDigMap;
         this.FBT_ExchangeStar = new TUIButton();
         this.FBT_ExchangeStar.Substrate = this.FScene.MC_Control.Btn_ExchangeStar;
         this.FBT_ExchangeStar.OnClick = this.OnOpenWindowExchangeClick;
         this.FBT_Fast = new TUIButton();
         this.FBT_Fast.Substrate = this.FScene.mc_treasureBaseData.btn_fast;
         this.FBT_Fast.OnClick = this.OnFastDigMap;
         this.FBT_Fast.OnMove = this.OnFastBtnMove;
         this.FBT_Fast.OnOut = this.OnFastBtnOut;
         this.FScene.mc_treasureBaseData.btn_heroIcon.gotoAndStop(this.FCharacter.MainHero.ModelID % 10);
         this.FScene.mc_treasureBaseData.btn_heroIcon.addEventListener(MouseEvent.CLICK,this.OnHeroIconClick);
         this.FScene.mc_treasureBaseData.btn_heroIcon.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeroIconRollOver);
         this.FScene.mc_treasureBaseData.btn_heroIcon.addEventListener(MouseEvent.MOUSE_OUT,this.OnHeroIconRollOut);
         this.FScene.mc_treasureBaseData.FTF_RewardTip.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeroIconRollOver);
         this.FScene.mc_treasureBaseData.FTF_RewardTip.addEventListener(MouseEvent.MOUSE_OUT,this.OnHeroIconRollOut);
         this.FScene.mc_treasureBaseData.Btn_AddCount.addEventListener(MouseEvent.CLICK,this.OnAddCountClick);
         this.FScene.mc_treasureBaseData.Btn_AddCount.addEventListener(MouseEvent.MOUSE_MOVE,this.OnAddCountMove);
         this.FScene.mc_treasureBaseData.Btn_AddCount.addEventListener(MouseEvent.MOUSE_OUT,this.OnAddCountOut);
         this.FHintFastTip = new THint();
         this.FHint = new THint();
         this.FHelpTips = new THint();
         this.FUIWindowConfirmation = new TUIWindowConfirmation(this);
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FReportScrollBar = new TScrollBar(this.FScene.mc_reportAll.mc_report.mc_scroll,125);
         this.FFreeReportTextFieldVect = new Vector.<TextField>();
         this.FBT_ReportShow = new TUIButton();
         this.FBT_ReportShow.Substrate = this.FScene.mc_reportAll.mc_report.Btn_ShowReport;
         this.FBT_ReportShow.OnClick = this.OnShowReportClick;
         this.FBT_ReportHide = new TUIButton();
         this.FBT_ReportHide.Substrate = this.FScene.mc_reportAll.mc_report.Btn_HideReport;
         this.FBT_ReportHide.OnClick = this.OnHideReportClick;
         this.FBT_ReportHide.Visible = false;
         this.FBT_ReportShow.Visible = true;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FScene.MC_PanelCredits;
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.UpdatePanel();
         MovieClip(this.FScene.MC_Title).addEventListener(Event.ENTER_FRAME,this.McTitleEnterFrame);
         this.FIsInitialization = true;
      }
      
      protected function GetSlot() : TUISlot
      {
         var _loc1_:TUISlot = null;
         _loc1_ = new TUISlot(this);
         _loc1_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         return _loc1_;
      }
      
      protected function GetItemStr(param1:int, param2:int, param3:int) : String
      {
         return param3 + TUtilityLobby.GetItemName(param1,param2);
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TDigging = null;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         if(this.FCharacter.CreditSilverCoin.ToNumber() > 10000)
         {
            _loc4_ = Math.floor(this.FCharacter.CreditSilverCoin.ToNumber() * 0.0001) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Thousand);
         }
         else
         {
            _loc4_ = this.FCharacter.CreditSilverCoin.ToString();
         }
         this.FScene.mc_treasureBaseData.tf_robberyTimes.text = this.FMaxRobberyTimes - this.FTreasureMapData.RobberyTimes;
         this.FScene.mc_treasureBaseData.tf_canEnterTimes.text = this.FTreasureMapData.TreasureTimes.toString();
         this.FScene.MC_Control.TF_BlueStar.text = this.FTreasureMapData.BlueStar.toString();
         this.FScene.MC_Control.TF_RedStar.text = this.FTreasureMapData.RedStar.toString();
         this.ProcessorResize();
      }
      
      protected function MakeHtmlReward(param1:Vector.<Object>, param2:int) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         _loc4_ = "";
         _loc5_ = uint(param2);
         _loc4_ += _loc5_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ += ",";
            _loc5_ = uint(param1[_loc3_].amount);
            _loc4_ += _loc5_ + TUtilityLobby.GetItemName(param1[_loc3_].type,param1[_loc3_].code);
            _loc3_++;
         }
         return _loc4_;
      }
      
      protected function MakeHtmlReport(param1:TTreasureMapReport) : String
      {
         var _loc2_:String = null;
         var _loc3_:TDigging = null;
         var _loc4_:String = null;
         var _loc5_:TStarMap = null;
         var _loc6_:TStarPoint = null;
         var _loc7_:uint = 0;
         _loc3_ = this.FDiggingBins.GetDatebaseByIdentifier(param1.MapQuality) as TDigging;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_32);
         _loc2_ = _loc2_.split("%who1%").join(param1.PlayerNick);
         _loc2_ = _loc2_.split("%who2%").join(param1.RobberyPlayerNick);
         _loc2_ = _loc2_.split("%where%").join(_loc3_.Name);
         _loc2_ = _loc2_.split("%what%").join(this.MakeHtmlReward(_loc3_.RobGetReward,param1.GetMoney));
         _loc6_ = this.FStarPointBins.GetDatebaseByIdentifier(param1.PlayerGeneralStarId) as TStarPoint;
         if(_loc6_ == null)
         {
            _loc7_ = 2;
         }
         else
         {
            _loc5_ = this.FStarMapBins.GetDatebaseByIdentifier(17200000 + _loc6_.MapId) as TStarMap;
            _loc7_ = uint(_loc5_.Quality);
         }
         _loc4_ = CONST_COMMON.QUALITYCOLOR_INDEX[_loc7_].toString(16);
         _loc4_ = "#" + _loc4_;
         _loc2_ = _loc2_.split("%colorwho1%").join(_loc4_);
         _loc6_ = this.FStarPointBins.GetDatebaseByIdentifier(param1.PlayerGeneralStarId) as TStarPoint;
         if(_loc6_ == null)
         {
            _loc7_ = 2;
         }
         else
         {
            _loc5_ = this.FStarMapBins.GetDatebaseByIdentifier(17200000 + _loc6_.MapId) as TStarMap;
            _loc7_ = uint(_loc5_.Quality);
         }
         _loc4_ = CONST_COMMON.QUALITYCOLOR_INDEX[_loc7_].toString(16);
         _loc4_ = "#" + _loc4_;
         _loc2_ = _loc2_.split("%colorwho2%").join(_loc4_);
         _loc4_ = CONST_TREASUREMAP.MapQualityColor[_loc3_.Rate];
         return _loc2_.split("%colorwhere%").join(_loc4_);
      }
      
      protected function UpdataReport() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:TextField = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = uint(this.FReportScrollBar.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            this.FFreeReportTextFieldVect.push(this.FReportScrollBar.Items[_loc1_]);
            _loc1_++;
         }
         this.FReportScrollBar.Clear();
         _loc4_ = Math.max(this.FTreasureMapData.ReportList.Count - MAX_REPORT_Count,0);
         _loc5_ = Math.min(this.FTreasureMapData.ReportList.Count,MAX_REPORT_Count);
         _loc1_ = _loc4_;
         while(_loc1_ < _loc5_)
         {
            _loc2_ = this.MakeHtmlReport(this.FTreasureMapData.ReportList.GetReportByIndex(_loc1_));
            if(this.FFreeReportTextFieldVect.length > 0)
            {
               _loc3_ = this.FFreeReportTextFieldVect.pop();
            }
            else
            {
               _loc3_ = new TextField();
               _loc3_.textColor = 16773067;
               _loc3_.mouseEnabled = false;
               _loc3_.multiline = true;
               _loc3_.wordWrap = true;
               _loc3_.width = 237;
               _loc3_.filters = [StrFilters];
            }
            _loc3_.htmlText = _loc2_;
            _loc3_.height = _loc3_.textHeight + 5;
            this.FReportScrollBar.AddItem(_loc3_);
            _loc1_++;
         }
      }
      
      protected function GetSelfTreasureMapHero() : TTreasureMapHero
      {
         var _loc1_:TTreasureMapHero = null;
         return this.FTreasureMapData.FightHeroList.GetMapHeroById(this.FCharacter.Identifier0,this.FCharacter.Identifier1) as TTreasureMapHero;
      }
      
      protected function OnFastDigMapSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_FastReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OnAddCountSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_VipAddTimesReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
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
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function ApplianceOnOver(param1:Object, param2:Object) : void
      {
         if(this.FOnApplianceOnOver != null)
         {
            this.FOnApplianceOnOver(param1,param2);
         }
      }
      
      protected function ApplianceOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnApplianceOnOut != null)
         {
            this.FOnApplianceOnOut(param1,param2);
         }
      }
      
      protected function OnClose(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnEnterCity != null)
         {
            this.FOnEnterCity(this);
         }
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_TREASUREMAP);
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
      
      protected function OnOpenDigMap(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTutorialNextStep != null)
         {
            this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_EnterTreasure);
         }
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FTreasureMapData.TreasureStatus)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_30));
            }
            return;
         }
         if(this.FTreasureMapData.TreasureTimes == 0)
         {
            this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_31));
            return;
         }
         if(this.FOnOpenDigMap != null)
         {
            this.FOnOpenDigMap(this);
         }
      }
      
      protected function OnOpenWindowExchangeClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenWindowExchange != null)
         {
            this.FOnOpenWindowExchange(this);
         }
      }
      
      protected function OnOpenWindowExchangeOver(param1:MouseEvent) : void
      {
         param1.currentTarget.MC_Over.visible = true;
      }
      
      protected function OnOpenWindowExchangeOut(param1:MouseEvent) : void
      {
         param1.currentTarget.MC_Over.visible = false;
      }
      
      protected function OnFastDigMap(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TDigging = null;
         var _loc7_:String = null;
         if(this.FTreasureMapHero == null)
         {
            return;
         }
         _loc6_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality) as TDigging;
         _loc5_ = _loc6_.Digtime - (this.FTreasureMapHero.IsGameWin ? this.FGameWinLessTimes : 0);
         _loc4_ = _loc5_ + (this.FTreasureMapHero.LastTime - STimingCore.ServerTick);
         _loc3_ = this.FFastCost * (int((_loc4_ - 1) / 60) + 1) / this.FFastCostUnit;
         if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc3_)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc3_);
            this.FUIWindowRecharge.visible = true;
            return;
         }
         _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_33);
         _loc7_ = _loc7_.split("%count%").join(_loc3_);
         this.FUIWindowConfirmation.Text = _loc7_;
         this.FUIWindowConfirmation.OnOK = this.OnFastDigMapSure;
         this.FUIWindowConfirmation.visible = true;
      }
      
      protected function OnFastBtnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TDigging = null;
         var _loc7_:TTreasureMapHero = null;
         if(this.FHintOnOver != null)
         {
            if(this.FTreasureMapHero == null)
            {
               return;
            }
            _loc6_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality) as TDigging;
            _loc5_ = _loc6_.Digtime - (this.FTreasureMapHero.IsGameWin ? this.FGameWinLessTimes : 0);
            _loc4_ = _loc5_ + (this.FTreasureMapHero.LastTime - STimingCore.ServerTick);
            _loc3_ = this.FFastCost * (int((_loc4_ - 1) / 60) + 1) / this.FFastCostUnit;
            this.FHintFastTip.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_29).split("%count%").join(_loc3_);
            this.FHintOnOver(this,this.FHintFastTip);
         }
      }
      
      protected function OnFastBtnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintFastTip);
         }
      }
      
      protected function OnHeroIconClick(param1:MouseEvent) : void
      {
         if(this.FTreasureMapHero == null)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_35));
            }
            return;
         }
      }
      
      protected function OnAddCountClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc2_ = this.FVip.DayBuyCount - this.FTreasureMapData.VipBuyCount;
         if(_loc2_ > 0)
         {
            if(!this.FUIWindowConfirmation.IsSelected)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_09);
               _loc3_ = _loc3_.split("%count%").join(this.FVipAddCountNeedGoldVect[this.FTreasureMapData.VipBuyCount]);
               this.FUIWindowConfirmation.Text = _loc3_;
               this.FUIWindowConfirmation.OnOK = this.OnAddCountSure;
               this.FUIWindowConfirmation.visible = true;
            }
         }
         else
         {
            this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_41));
         }
      }
      
      protected function OnAddCountMove(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:TVipConfig = null;
         var _loc4_:TVip = null;
         var _loc5_:TVip = null;
         _loc5_ = this.FCharacter.VipData;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_18);
         _loc2_ = _loc2_.split("%count0%").join(_loc5_.DayBuyCount - this.FTreasureMapData.VipBuyCount);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VipConfig,_loc5_.VipLevel + 1) as TVipConfig;
         if(_loc3_ == null)
         {
            _loc2_ = _loc2_.split("%count1%").join(_loc5_.DayBuyCount);
         }
         else
         {
            _loc2_ = _loc2_.split("%count1%").join(_loc3_.DayBuyCount);
         }
         this.FHint.Caption = _loc2_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function OnAddCountOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnHeroIconRollOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget is MovieClip)
         {
            param1.currentTarget.buttonMode = true;
         }
         this.FTreasureMapHero = this.GetSelfTreasureMapHero();
         if(this.FTreasureMapHero == null)
         {
            return;
         }
         if(this.FOnRewardOver != null)
         {
            this.FOnRewardOver(this,this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality));
         }
      }
      
      protected function OnHeroIconRollOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget is MovieClip)
         {
            param1.currentTarget.buttonMode = false;
         }
         if(this.FOnRewardOut != null)
         {
            this.FOnRewardOut(this);
         }
      }
      
      protected function OnShowReportClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBT_ReportShow.Visible = false;
         this.FBT_ReportHide.Visible = true;
         MovieClip(this.FScene.mc_reportAll).gotoAndPlay("show");
      }
      
      protected function OnHideReportClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBT_ReportShow.Visible = true;
         this.FBT_ReportHide.Visible = false;
         MovieClip(this.FScene.mc_reportAll).gotoAndPlay("hide");
      }
      
      protected function McTitleEnterFrame(param1:Event) : void
      {
         if(param1.currentTarget != null)
         {
            if(MovieClip(param1.currentTarget).currentFrame == MovieClip(param1.currentTarget).totalFrames)
            {
               this.ShowTreasureHeros();
               MovieClip(param1.currentTarget).removeEventListener(Event.ENTER_FRAME,this.McTitleEnterFrame);
            }
         }
      }
      
      protected function ShowTreasureHeros() : void
      {
         if(this.FOnShowHeros != null)
         {
            this.FOnShowHeros(this);
         }
      }
      
      public function set OnEnterCity(param1:Function) : void
      {
         this.FOnEnterCity = param1;
      }
      
      public function get OnEnterCity() : Function
      {
         return this.FOnEnterCity;
      }
      
      public function set OpenDigMap(param1:Function) : void
      {
         this.FOnOpenDigMap = param1;
      }
      
      public function get OpenDigMap() : Function
      {
         return this.FOnOpenDigMap;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function get OnApplianceOnOver() : Function
      {
         return this.FOnApplianceOnOver;
      }
      
      public function set OnApplianceOnOver(param1:Function) : void
      {
         this.FOnApplianceOnOver = param1;
      }
      
      public function get OnApplianceOnOut() : Function
      {
         return this.FOnApplianceOnOut;
      }
      
      public function set OnApplianceOnOut(param1:Function) : void
      {
         this.FOnApplianceOnOut = param1;
      }
      
      public function set TutorialNextStep(param1:Function) : void
      {
         this.FTutorialNextStep = param1;
      }
      
      public function get OnOpenWindowExchange() : Function
      {
         return this.FOnOpenWindowExchange;
      }
      
      public function set OnOpenWindowExchange(param1:Function) : void
      {
         this.FOnOpenWindowExchange = param1;
      }
      
      public function get OnShowHeros() : Function
      {
         return this.FOnShowHeros;
      }
      
      public function set OnShowHeros(param1:Function) : void
      {
         this.FOnShowHeros = param1;
      }
      
      public function get OnRewardOver() : Function
      {
         return this.FOnRewardOver;
      }
      
      public function set OnRewardOver(param1:Function) : void
      {
         this.FOnRewardOver = param1;
      }
      
      public function get OnRewardOut() : Function
      {
         return this.FOnRewardOut;
      }
      
      public function set OnRewardOut(param1:Function) : void
      {
         this.FOnRewardOut = param1;
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
      
      public function UpdataEffect() : void
      {
         this.FUICredits.UpdateEffect();
      }
      
      public function UpdataColdDown() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TDigging = null;
         if(this.FTreasureMapHero)
         {
            _loc4_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality) as TDigging;
            _loc3_ = _loc4_.Digtime - (this.FTreasureMapHero.IsGameWin ? this.FGameWinLessTimes : 0);
            _loc2_ = _loc3_ + (this.FTreasureMapHero.LastTime - STimingCore.ServerTick);
            this.FScene.mc_treasureBaseData.tf_diggingTimes.text = TUtilityTiming.FormatTimeWithoutHours(_loc2_);
            this.FBT_Fast.Visible = Boolean(_loc2_ > 0);
         }
         else
         {
            this.FScene.mc_treasureBaseData.tf_diggingTimes.text = TUtilityTiming.fomatTime(0);
            this.FBT_Fast.Visible = false;
         }
      }
      
      public function SetTreasureMapData(param1:TTreasureMapData) : void
      {
         this.FTreasureMapData = param1;
         this.FTreasureMapHero = this.GetSelfTreasureMapHero();
         if(Boolean(this.FTreasureMapHero) && this.FTreasureMapData.TreasureStatus == false)
         {
            this.FTreasureMapHero.LastTime = 0;
         }
         this.UpdataUI();
         this.UpdataReport();
      }
      
      public function AddReport(param1:TTreasureMapData) : void
      {
         this.FTreasureMapData = param1;
         this.UpdataReport();
      }
      
      public function CheckCanDigging() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:TDigging = null;
         this.FTreasureMapHero = this.GetSelfTreasureMapHero();
         if(this.FTreasureMapHero)
         {
            _loc2_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality) as TDigging;
            _loc1_ = _loc2_.Digtime - (this.FTreasureMapHero.IsGameWin ? this.FGameWinLessTimes : 0);
            if(this.FOnEffectText != null && _loc1_ + (this.FTreasureMapHero.LastTime - STimingCore.ServerTick) > 0)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_30));
            }
            return false;
         }
         if(this.FTreasureMapData.TreasureTimes <= 0)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_31));
            }
            return false;
         }
         return true;
      }
      
      public function PlayMovie() : void
      {
         MovieClip(this.FScene.MC_Title).gotoAndPlay(1);
         if(!MovieClip(this.FScene.MC_Title).hasEventListener(Event.ENTER_FRAME))
         {
            MovieClip(this.FScene.MC_Title).addEventListener(Event.ENTER_FRAME,this.McTitleEnterFrame);
         }
         MovieClip(this.FScene.MC_Effect).play();
         MovieClip(this.FScene.MC_Bg).play();
      }
      
      public function Reset() : void
      {
         MovieClip(this.FScene.MC_Effect).stop();
         MovieClip(this.FScene.MC_Bg).stop();
      }
   }
}

