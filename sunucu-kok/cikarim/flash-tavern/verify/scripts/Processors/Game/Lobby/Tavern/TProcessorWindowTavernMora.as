package Processors.Game.Lobby.Tavern
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Tavern.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   
   public class TProcessorWindowTavernMora extends TUIComponent
   {
      
      protected static const ONEKEYTen_COUNT:uint = 10;
      
      protected static const ONEKEYWin_COUNT:uint = 30;
      
      protected static const MoraType_Count:uint = 3;
      
      protected static const CONST_HEROLIST_MAX:uint = 3;
      
      protected static const CONST_MORACHOOSE_MAX:uint = 3;
      
      protected static const BUTTON_NUMBER:uint = 4;
      
      protected static const BTN_QUALITY_BULE:uint = 3;
      
      protected static const BTN_QUALITY_PURPLE:uint = 4;
      
      protected static const BTN_QUALITY_GOLD:uint = 5;
      
      protected static const BTN_QUALITY_ORANGE:uint = 6;
      
      protected static const COLOR_QUALITY_BULE:uint = 6094297;
      
      protected static const COLOR_QUALITY_PURPLE:uint = 14245117;
      
      protected static const COLOR_QUALITY_GOLD:uint = 16763904;
      
      protected static const COLOR_QUALITY_ORANGE:uint = 16724736;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const CONST_PlanishRate:uint = 20;
      
      protected static const Event_PlayTalk:String = "playTalk";
      
      protected static const Event_EndMovie:String = "endMovie";
      
      protected static const MoraBtnType_Noraml:uint = 0;
      
      protected static const MoraBtnType_Advanced:uint = 1;
      
      protected static const MoraBtnType_OneKeyTen:uint = 2;
      
      protected static const MoraBtnType_OneKeyWin:uint = 3;
      
      protected static const darkFilters:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-80,0,1,0,0,-80,0,0,1,0,-80,0,0,0,1,0]);
      
      protected static const TAMP_HEROLIST_WIDTH:uint = 128;
      
      protected static const TAMP_HEROLIST_HEIGHT:uint = 70;
      
      protected var FScene:MovieClip;
      
      protected var FBtns:Vector.<TUIButton>;
      
      protected var FHeadIcons:Vector.<Bitmap>;
      
      protected var FMyRecouse:Bitmap;
      
      protected var FNpcRecouse:Bitmap;
      
      protected var FMyRecouseId:uint;
      
      protected var FNpcRecouseId:uint;
      
      protected var FMyRecouseName:String;
      
      protected var FNpcRecouseName:String;
      
      protected var FSelected:Boolean;
      
      protected var FSelectIndex:int;
      
      protected var FTavernWarriorVect:Vector.<TTavernWarrior>;
      
      protected var FSmallIconIds:Vector.<uint>;
      
      protected var FRoleModelBins:TBins;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FTaverWarriorBins:TBins;
      
      protected var FTavernPayConfig:TBins;
      
      protected var FSystemLanguageBins:TBins;
      
      protected var FMoraTimes:uint;
      
      protected var FTalkIndex:uint;
      
      protected var FPayWinCost:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FIsWin:Boolean;
      
      protected var FIsPlanish:Boolean;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FCurGrade:TTavernGrade;
      
      protected var FNormalPayConfig:TTavernPayConfig;
      
      protected var FAdvancedPayConfig:TTavernPayConfig;
      
      protected var FMoraBtnHint:TPayConfig;
      
      protected var FWindowConfirmationSure:TUIWindowConfirmation;
      
      protected var FMoraBtnIndex:int;
      
      protected var FIsInMora:Boolean;
      
      protected var FIsFinish:Boolean;
      
      protected var FTurnBackHeroList:Function;
      
      protected var FEffectGenerateText:Function;
      
      protected var FTutorialNextStep:Function;
      
      protected var FEnableWindowTavern:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnPlayScene:Function;
      
      protected var FIsLookOnly:Boolean;
      
      protected var FSetWineBT:Function;
      
      public function TProcessorWindowTavernMora(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:uint = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TConfigValue = null;
         super(param1);
         this.FScene = param2;
         this.FSelected = false;
         this.FMoraTimes = 0;
         this.FMoraBtnIndex = -1;
         this.FMoraBtnHint = new TPayConfig();
         this.FScene.mouseEnabled = false;
         this.FMyRecouse = new Bitmap();
         this.FScene["mc_heroIcons"]["mc_heroIcon_0"]["mc_heroIconInner"]["mc_myRecouse"].addChild(this.FMyRecouse);
         this.FNpcRecouse = new Bitmap();
         this.FScene["mc_heroIcons"]["mc_heroIcon_1"]["mc_heroIconInner"]["mc_myRecouse"].addChild(this.FNpcRecouse);
         this.FScene["mc_heroIcons"].visible = false;
         this.FHeadIcons = new Vector.<Bitmap>(CONST_HEROLIST_MAX);
         _loc3_ = 0;
         while(_loc3_ < CONST_HEROLIST_MAX)
         {
            _loc4_ = new Bitmap();
            this.FScene["mc_opponent"]["mc_opponentIcon_" + _loc3_].addChild(_loc4_);
            this.FScene["mc_opponent"]["mc_lost_" + _loc3_].visible = false;
            this.FHeadIcons[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FBtns = new Vector.<TUIButton>(4);
         _loc3_ = 0;
         while(_loc3_ < CONST_MORACHOOSE_MAX)
         {
            _loc5_ = new TUIButton();
            _loc5_.Substrate = this.FScene["mc_moraBTs"]["mc_mora_" + _loc3_];
            _loc5_.OnClick = this.OnMoraClick;
            _loc5_.OnMove = this.OnMoraMove;
            _loc5_.OnOut = this.OnMoraOut;
            this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc3_].visible = false;
            this.FBtns[_loc3_] = _loc5_;
            _loc3_++;
         }
         _loc5_ = new TUIButton();
         _loc5_.Substrate = this.FScene["mc_moraBTs"]["mc_mora_Win"];
         _loc5_.OnClick = this.OnMoraWinClick;
         _loc5_.OnMove = this.OnMoraMove;
         _loc5_.OnOut = this.OnMoraOut;
         this.FScene["mc_moraBTs"]["mc_moraBG_Win"].visible = false;
         this.FBtns[3] = _loc5_;
         this.FTavernWarriorVect = new Vector.<TTavernWarrior>(CONST_HEROLIST_MAX);
         this.FSmallIconIds = new Vector.<uint>(CONST_HEROLIST_MAX);
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FTaverWarriorBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Tavern_Warrior);
         this.FTavernPayConfig = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Tavern_PayConfig);
         this.FSystemLanguageBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TAVERN_Match_Cheat) as TConfigValue;
         this.FPayWinCost = _loc6_.Value.value;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FMyRecouseId = this.FCharacter.MainHero.LargeID;
         this.FMyRecouseName = this.FCharacter.MainHero.Name;
         this.FScene["mc_heroNames"]["tf_myName"].text = this.FMyRecouseName;
         this.FScene.mc_dialogue.visible = false;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.SetPartsVisible(false);
      }
      
      protected function GetNpcName(param1:uint) : String
      {
         var _loc2_:TBaseHero = null;
         _loc2_ = this.FBaseHeroBins.GetDatebaseByIdentifier(param1) as TBaseHero;
         return _loc2_.Name;
      }
      
      protected function GetStandPositionWithProfession(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case CONST_CHARACTER.PROFESSION_Agility:
            case CONST_CHARACTER.PROFESSION_Strength:
               _loc2_ = uint(INDEX_Station_Middle);
               break;
            case CONST_CHARACTER.PROFESSION_Defending:
               _loc2_ = uint(INDEX_Station_Front);
               break;
            case CONST_CHARACTER.PROFESSION_Intellect:
               _loc2_ = uint(INDEX_Station_After);
         }
         return _loc2_;
      }
      
      protected function GetColorWithQuality(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case BTN_QUALITY_BULE:
               _loc2_ = COLOR_QUALITY_BULE;
               break;
            case BTN_QUALITY_PURPLE:
               _loc2_ = COLOR_QUALITY_PURPLE;
               break;
            case BTN_QUALITY_GOLD:
               _loc2_ = COLOR_QUALITY_GOLD;
               break;
            case BTN_QUALITY_ORANGE:
               _loc2_ = COLOR_QUALITY_ORANGE;
               break;
            default:
               _loc2_ = COLOR_QUALITY_BULE;
         }
         return _loc2_;
      }
      
      protected function SetPartsVisible(param1:Boolean) : void
      {
         this.FScene["mc_dialogue"].visible = param1;
         this.FScene["mc_heroIcons"].visible = param1;
         this.FScene["mc_opponent"].visible = param1;
         this.FScene["mc_rounds"].visible = param1;
         this.FScene["mc_moraResult"].visible = param1;
         this.FScene["mc_leftHand"].visible = param1;
         this.FScene["mc_rightHand"].visible = param1;
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TTavernWarrior = null;
         var _loc3_:TBaseHero = null;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_HEROLIST_MAX)
         {
            _loc2_ = this.FTavernWarriorVect[_loc1_];
            _loc6_ = this.GetColorWithQuality(_loc2_.Awardsouls.Type);
            this.FScene["mc_opponent"]["mc_getSoul_" + _loc1_].gotoAndStop(_loc2_.Awardsouls.Type);
            this.FScene["mc_opponent"]["tf_getSoul_" + _loc1_].text = String(_loc2_.Awardsouls.Value);
            this.FScene["mc_opponent"]["tf_getSoul_" + _loc1_].textColor = _loc6_;
            this.FScene["mc_opponent"]["mc_lost_" + _loc1_].visible = _loc1_ < this.FMoraTimes;
            _loc1_++;
         }
      }
      
      private function ResetRounds() : void
      {
         this.FScene.mc_rightHand.visible = false;
         this.FScene.mc_leftHand.visible = false;
         this.FScene.mc_moraResult.visible = false;
         this.OnPlayTalk();
      }
      
      protected function OnOutMora() : void
      {
         this.FScene.gotoAndStop(1);
         this.SetPartsVisible(false);
         this.FIsInMora = false;
         this.FScene.mouseEnabled = false;
         this.FScene.mouseChildren = false;
         if(this.FTurnBackHeroList != null)
         {
            this.FTurnBackHeroList();
         }
      }
      
      protected function EnableBtn(param1:Boolean) : void
      {
         this.FScene.mouseEnabled = param1;
         this.FScene.mouseChildren = param1;
      }
      
      private function ResetMoraBG() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_MORACHOOSE_MAX)
         {
            this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc1_].visible = false;
            _loc1_++;
         }
         this.FScene["mc_moraBTs"]["mc_moraBG_Win"].visible = false;
      }
      
      private function SetMoraTip(param1:String) : void
      {
         this.FScene.tf_moraLog.text = this.FCurGrade.Tips;
         this.FScene.tf_moraLog.visible = true;
      }
      
      protected function MakePayConfig(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TSystemLanguage = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Vector.<String> = null;
         this.FNormalPayConfig = this.FTavernPayConfig.GetDatebaseByIdentifier(this.FCurGrade.PayConfigsVect.NORMAL) as TTavernPayConfig;
         this.FAdvancedPayConfig = this.FTavernPayConfig.GetDatebaseByIdentifier(this.FCurGrade.PayConfigsVect.ADVANCED) as TTavernPayConfig;
         _loc8_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_25);
         switch(param1)
         {
            case MoraBtnType_Noraml:
               _loc2_ = uint(this.FCurGrade.WineLvs[0]);
               this.FMoraBtnHint.Title = _loc8_[_loc2_];
               this.FMoraBtnHint.Value = this.FNormalPayConfig.Value + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_01);
               _loc5_ = "";
               break;
            case MoraBtnType_Advanced:
               _loc2_ = uint(this.FCurGrade.WineLvs[1]);
               this.FMoraBtnHint.Title = _loc8_[_loc2_];
               this.FMoraBtnHint.Value = this.FAdvancedPayConfig.Value + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_02);
               _loc5_ = "";
               break;
            case MoraBtnType_OneKeyTen:
               _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_22);
               this.FMoraBtnHint.Title = _loc6_;
               this.FMoraBtnHint.Value = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_03);
               _loc5_ = this.FVipData.OneWine ? "" : this.FVipData.VipOpenLevel_OneWine.toString();
               break;
            case MoraBtnType_OneKeyWin:
               _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_23);
               this.FMoraBtnHint.Title = _loc7_;
               this.FMoraBtnHint.Value = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + "," + this.FPayWinCost * ONEKEYWin_COUNT + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Gold);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_04);
               _loc5_ = this.FVipData.OneWinWine ? "" : this.FVipData.VipOpenLevel_OneWinWine.toString();
         }
         _loc3_ = this.FSystemLanguageBins.GetDatebaseByIdentifier(_loc4_) as TSystemLanguage;
         this.FMoraBtnHint.ID = param1;
         this.FMoraBtnHint.Context = _loc3_.Desc;
         this.FMoraBtnHint.OpenLevel = _loc5_;
      }
      
      protected function CheckEnoughCredit(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         switch(param1)
         {
            case MoraBtnType_Noraml:
               _loc2_ = uint(this.FNormalPayConfig.Value);
               _loc3_ = 0;
               break;
            case MoraBtnType_Advanced:
               _loc2_ = uint(this.FAdvancedPayConfig.Value);
               _loc3_ = 0;
               break;
            case MoraBtnType_OneKeyTen:
               _loc2_ = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT;
               _loc3_ = 0;
               break;
            case MoraBtnType_OneKeyWin:
               _loc2_ = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT;
               _loc3_ = this.FPayWinCost * ONEKEYWin_COUNT;
         }
         if(this.FCharacter.CreditSilverCoin.ToNumber() < _loc2_)
         {
            if(this.FEffectGenerateText != null)
            {
               this.FEffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Coin));
            }
            return false;
         }
         if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc3_)
         {
            this.FUIWindowRecharge.Visible = true;
            return false;
         }
         return true;
      }
      
      protected function OnMoraBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(Boolean(param1.currentTarget) && !param1.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FNormalPayConfig == null || this.FAdvancedPayConfig == null)
         {
            return;
         }
         _loc2_ = uint(int(String(param1.currentTarget.name).slice(11)));
         if(!this.CheckEnoughCredit(_loc2_))
         {
            return;
         }
         if(this.FEnableWindowTavern != null)
         {
            this.FEnableWindowTavern(false);
         }
         if(_loc2_ == MoraBtnType_OneKeyWin)
         {
            if(this.FWindowConfirmationSure == null)
            {
               this.FWindowConfirmationSure = SUtilityOverLayer.UIWindowConfirmation;
            }
            this.FAdvancedPayConfig = this.FTavernPayConfig.GetDatebaseByIdentifier(this.FCurGrade.PayConfigsVect.ADVANCED) as TTavernPayConfig;
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_21);
            _loc5_ = TUtilityString.Format(_loc6_,this.FPayWinCost * ONEKEYWin_COUNT,this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT);
            this.FWindowConfirmationSure.Text = _loc5_;
            this.FWindowConfirmationSure.OnOK = this.SureOneKeyWinMora;
            this.FWindowConfirmationSure.OnCancel = this.CancelOneKeyWinMora;
            this.FWindowConfirmationSure.Visible = true;
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernMoraReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(_loc2_);
         _loc4_.writeInt(this.FCurGrade.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FScene.mouseEnabled = false;
         this.FScene.mouseChildren = false;
      }
      
      protected function SureOneKeyWinMora(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernMoraReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(MoraBtnType_OneKeyWin);
         _loc3_.writeInt(this.FCurGrade.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function CancelOneKeyWinMora(param1:Object) : void
      {
         if(this.FEnableWindowTavern != null)
         {
            this.FEnableWindowTavern(true);
         }
      }
      
      protected function OnMoraBtnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(int(String(param1.currentTarget.name).slice(11)));
         if(_loc2_ != this.FMoraBtnIndex)
         {
            this.MakePayConfig(_loc2_);
            this.FMoraBtnIndex = _loc2_;
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FMoraBtnHint);
         }
      }
      
      protected function OnMoraBtnMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FMoraBtnIndex = -1;
            this.FHintOnOut(param1);
         }
      }
      
      protected function OnMoraClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         if(this.FSelected)
         {
            return;
         }
         _loc5_ = uint(int(String(param2.currentTarget.name).slice(8)));
         this.FSelectIndex = _loc5_ + 1;
         if(Math.random() * 100 < CONST_PlanishRate)
         {
            this.EnableBtn(false);
            this.SetPlanish();
            return;
         }
         this.FSelected = true;
         this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc5_].visible = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernNormalMoraReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.EnableBtn(false);
      }
      
      private function OnMoraMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = param2.currentTarget.name;
         this.ResetMoraBG();
         _loc3_ = _loc4_.slice(8,_loc4_.length);
         this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc3_].visible = true;
      }
      
      private function OnMoraOut(param1:Object, param2:MouseEvent) : void
      {
         this.ResetMoraBG();
      }
      
      protected function OnMoraWinClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         if(this.FSelected)
         {
            return;
         }
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_11),this.FPayWinCost);
         if(this.FPayWinCost > this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.visible = true;
            return;
         }
         this.FUIWindowConfirmation.Text = _loc3_;
         this.FUIWindowConfirmation.OnOK = this.OnMoraWinSure;
         this.FUIWindowConfirmation.OnCancel = this.OnMoraWinSureClose;
         this.FUIWindowConfirmation.Visible = true;
         this.EnableBtn(false);
      }
      
      protected function OnMoraWinSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < this.FPayWinCost)
         {
            if(this.FEffectGenerateText != null)
            {
               this.FEffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            }
            return;
         }
         this.FSelected = true;
         this.FSelectIndex = Math.random() * MoraType_Count + 1;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernNormalMoraReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.EnableBtn(false);
      }
      
      protected function OnMoraWinSureClose(param1:Object) : void
      {
         this.EnableBtn(true);
      }
      
      protected function OnPlayTalk() : void
      {
         var _loc1_:TTavernWarrior = null;
         if(!this.FIsPlanish)
         {
            this.FScene.mc_dialogue.visible = true;
            _loc1_ = this.FTavernWarriorVect[this.FTalkIndex];
            if(!this.FIsWin)
            {
               this.FScene.mc_dialogue.mc_dialogueInner.tf_dialogueText.text = _loc1_.WinDialogue;
            }
            else
            {
               this.FScene.mc_dialogue.mc_dialogueInner.tf_dialogueText.text = _loc1_.LoseDialogue;
            }
            this.FScene.mc_dialogue.gotoAndPlay(1);
            var _loc2_:TProcessorWindowTavernMora = this;
            var _loc3_:Number = _loc2_.FTalkIndex + 1;
            _loc2_.FTalkIndex = _loc3_;
         }
         this.FScene.mc_heroIcons.filters = [];
         setTimeout(this.OnEndMovie,1000);
      }
      
      protected function OnEndMovie() : void
      {
         var _loc1_:TTavernWarrior = null;
         var _loc2_:TRoleModel = null;
         this.FScene.mc_moraResult.visible = false;
         _loc1_ = this.FTavernWarriorVect[this.FMoraTimes];
         _loc2_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc1_.AwardId) as TRoleModel;
         this.FNpcRecouseId = _loc2_.RoleStyle;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FNpcRecouseId,this.AutoLoadCallBack);
         this.FScene["mc_heroNames"]["tf_npcName"].text = this.GetNpcName(_loc1_.AwardId);
         this.FScene.mc_dialogue.visible = false;
         this.FScene.mc_rounds.visible = true;
         this.FScene.mc_rounds.gotoAndStop(this.FMoraTimes + 1);
         this.EnableBtn(true);
         if(this.FIsFinish)
         {
            this.FScene.mc_rounds.visible = false;
            this.EnableBtn(false);
         }
      }
      
      protected function AutoLoadSmall(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
         switch(param3)
         {
            case this.FSmallIconIds[0]:
               this.FHeadIcons[0].bitmapData = _loc5_;
               break;
            case this.FSmallIconIds[1]:
               this.FHeadIcons[1].bitmapData = _loc5_;
               break;
            case this.FSmallIconIds[2]:
               this.FHeadIcons[2].bitmapData = _loc5_;
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
         switch(param3)
         {
            case this.FMyRecouseId:
               this.FMyRecouse.bitmapData = _loc5_;
               break;
            case this.FNpcRecouseId:
               this.FNpcRecouse.bitmapData = _loc5_;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FScene.visible = param1;
      }
      
      override public function get Visible() : Boolean
      {
         if(this.FScene == null)
         {
            return false;
         }
         return this.FScene.visible;
      }
      
      public function set TurnBackHeroList(param1:Function) : void
      {
         this.FTurnBackHeroList = param1;
      }
      
      public function get TurnBackHeroList() : Function
      {
         return this.FTurnBackHeroList;
      }
      
      public function set EffectGenerateText(param1:Function) : void
      {
         this.FEffectGenerateText = param1;
      }
      
      public function get EffectGenerateText() : Function
      {
         return this.FEffectGenerateText;
      }
      
      public function set CurGrade(param1:TTavernGrade) : void
      {
         this.FCurGrade = param1;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set TutorialNextStep(param1:Function) : void
      {
         this.FTutorialNextStep = param1;
      }
      
      public function get EnableWindowTavern() : Function
      {
         return this.FEnableWindowTavern;
      }
      
      public function set EnableWindowTavern(param1:Function) : void
      {
         this.FEnableWindowTavern = param1;
      }
      
      public function get OnPlayScene() : Function
      {
         return this.FOnPlayScene;
      }
      
      public function set OnPlayScene(param1:Function) : void
      {
         this.FOnPlayScene = param1;
      }
      
      public function get SetWineBT() : Function
      {
         return this.FSetWineBT;
      }
      
      public function set SetWineBT(param1:Function) : void
      {
         this.FSetWineBT = param1;
      }
      
      public function get IsLookOnly() : Boolean
      {
         return this.FIsLookOnly;
      }
      
      public function SetMoraData(param1:TMoras) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TTavernWarrior = null;
         var _loc4_:TMora = null;
         var _loc5_:TRoleModel = null;
         this.FMoraTimes = 0;
         this.FTalkIndex = 0;
         this.FIsFinish = false;
         this.FTavernWarriorVect.length = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.Count)
         {
            _loc4_ = param1.GetMoraByIndex(_loc2_);
            _loc3_ = this.FTaverWarriorBins.GetDatebaseByIdentifier(_loc4_.TavernHeroId) as TTavernWarrior;
            this.FTavernWarriorVect.push(_loc3_);
            if(_loc4_.IsMoraWin)
            {
               var _loc6_:TProcessorWindowTavernMora = this;
               var _loc7_:Number = _loc6_.FMoraTimes + 1;
               _loc6_.FMoraTimes = _loc7_;
               _loc6_ = this;
               _loc7_ = _loc6_.FTalkIndex + 1;
               _loc6_.FTalkIndex = _loc7_;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < CONST_HEROLIST_MAX)
         {
            this.FHeadIcons[_loc2_].bitmapData = null;
            _loc2_++;
         }
         _loc3_ = this.FTavernWarriorVect[this.FMoraTimes];
         _loc5_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc3_.AwardId) as TRoleModel;
         this.FNpcRecouseId = _loc5_.RoleStyle;
         this.FScene["mc_heroNames"]["tf_npcName"].text = this.GetNpcName(_loc3_.AwardId);
         this.EnableBtn(true);
         this.UpdataUI();
         this.FScene.mc_rounds.visible = true;
         this.FScene.mc_rounds.gotoAndStop(this.FMoraTimes + 1);
         this.FScene["mc_opponent"].visible = true;
         this.FScene["mc_heroIcons"].visible = true;
         this.FIsInMora = true;
         if(this.FOnPlayScene != null)
         {
            this.FOnPlayScene();
         }
         this.FScene.gotoAndPlay(1);
         this.FScene.mouseEnabled = true;
         this.FScene.mouseChildren = true;
         _loc2_ = 0;
         while(_loc2_ < CONST_HEROLIST_MAX)
         {
            _loc3_ = this.FTavernWarriorVect[_loc2_];
            _loc5_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc3_.AwardId) as TRoleModel;
            this.FSmallIconIds[_loc2_] = _loc5_.RoleHead;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.RoleHead,this.AutoLoadSmall);
            _loc2_++;
         }
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FNpcRecouseId,this.AutoLoadCallBack);
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FMyRecouseId,this.AutoLoadCallBack);
      }
      
      public function SetMoraResult(param1:uint, param2:Boolean) : void
      {
         this.FIsWin = param2;
         this.FIsPlanish = false;
         this.FScene.mc_heroIcons.filters = [darkFilters];
         this.FScene.mc_rounds.visible = false;
         this.FScene.mc_rightHand.visible = true;
         this.FScene.mc_leftHand.visible = true;
         this.FScene.mc_heroIcons.visible = true;
         if(param2)
         {
            this.FScene.mc_leftHand.mc_handInner.gotoAndStop(this.FSelectIndex);
            this.FScene.mc_rightHand.mc_handInner.gotoAndStop(1 + this.FSelectIndex % MoraType_Count);
            this.FScene.mc_moraResult.mc_resultInner.gotoAndStop("Win");
         }
         else
         {
            this.FScene.mc_leftHand.mc_handInner.gotoAndStop(this.FSelectIndex);
            this.FScene.mc_rightHand.mc_handInner.gotoAndStop(1 + (this.FSelectIndex + 1) % MoraType_Count);
            this.FScene.mc_moraResult.mc_resultInner.gotoAndStop("Lose");
            this.FMoraTimes = CONST_HEROLIST_MAX;
         }
         this.FScene.mc_leftHand.gotoAndPlay(1);
         this.FScene.mc_rightHand.gotoAndPlay(1);
         setTimeout(this.PlayResult,1000);
         var _loc3_:TProcessorWindowTavernMora = this;
         var _loc4_:Number = _loc3_.FMoraTimes + 1;
         _loc3_.FMoraTimes = _loc4_;
         if(this.FMoraTimes >= CONST_HEROLIST_MAX)
         {
            this.FMoraTimes = 0;
            this.FIsFinish = true;
            setTimeout(this.OnOutMora,4000);
         }
         else
         {
            this.FIsFinish = false;
            this.FScene.mc_rounds.gotoAndStop(this.FMoraTimes);
         }
         this.UpdataUI();
         this.FSelected = false;
      }
      
      private function PlayResult() : void
      {
         this.FScene.mc_moraResult.visible = true;
         this.FScene.mc_moraResult.play();
         setTimeout(this.ResetRounds,1500);
      }
      
      public function SetPlanish() : void
      {
         this.FIsPlanish = true;
         this.FScene.mc_rounds.visible = false;
         this.FScene.mc_rightHand.visible = true;
         this.FScene.mc_leftHand.visible = true;
         this.FScene.mc_heroIcons.visible = true;
         this.FScene.mc_heroIcons.filters = [darkFilters];
         this.FScene.mc_leftHand.mc_handInner.gotoAndStop(this.FSelectIndex);
         this.FScene.mc_rightHand.mc_handInner.gotoAndStop(this.FSelectIndex);
         this.FScene.mc_moraResult.mc_resultInner.gotoAndStop("Planish");
         this.FScene.mc_leftHand.gotoAndPlay(1);
         this.FScene.mc_rightHand.gotoAndPlay(1);
         setTimeout(this.PlayResult,800);
      }
      
      public function SetButtonAndLevel() : void
      {
         if(this.FCurGrade.Tips != null && this.FCurGrade.Tips.length > 0 && this.FCharacter.GetMainLevel() < this.FCurGrade.Level)
         {
            this.SetMoraTip(this.FCurGrade.Tips);
            this.FIsLookOnly = true;
         }
         else
         {
            this.FScene.tf_moraLog.visible = false;
            this.FIsLookOnly = false;
            if(this.FIsInMora)
            {
               this.FScene.gotoAndStop(this.FScene.totalFrames);
            }
         }
         if(this.FSetWineBT != null)
         {
            this.FSetWineBT(!this.FIsLookOnly);
         }
      }
      
      public function GetCoordinateByResult() : TCoordinate
      {
         var _loc1_:TCoordinate = null;
         _loc1_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FScene.mc_moraResult);
         _loc1_.X += TAMP_HEROLIST_WIDTH;
         _loc1_.Y += TAMP_HEROLIST_HEIGHT;
         return _loc1_;
      }
      
      public function SetMouseEnable(param1:Boolean) : void
      {
         this.FScene.mouseEnabled = param1;
         this.FScene.mouseChildren = param1;
      }
      
      public function RetryMora() : void
      {
         this.FSelected = false;
         this.EnableBtn(true);
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FMyRecouse.bitmapData = null;
         this.FNpcRecouse.bitmapData = null;
         _loc2_ = CONST_HEROLIST_MAX;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeadIcons[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
   }
}

