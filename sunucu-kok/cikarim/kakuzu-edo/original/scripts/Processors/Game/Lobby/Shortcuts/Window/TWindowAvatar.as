package Processors.Game.Lobby.Shortcuts.Window
{
   import Components.Slots.TUISlot;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.TInventories;
   import Logics.KnifeSoul.*;
   import Logics.Purchases.*;
   import Logics.Signals.*;
   import Logics.Vip.*;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlow;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TWindowAvatar extends TUIComponent
   {
      
      protected static const SIZE_Avatar_Width:int = 393;
      
      protected static const SIZE_Avatar_Height:int = 225;
      
      public static const SlotMax:int = 4;
      
      protected static const CHARACTER_BaseModeID:uint = CONST_CHARACTER.CHARACTER_BaseModeID;
      
      protected static const KEY_COUNTER_MilitaryOrdersLimit:uint = CONST_COUNTER.KEY_COUNTER_MilitaryOrdersLimit;
      
      protected static const POSITION_Avatar:uint = CONST_SHORTCUTS.POSITION_Avatar;
      
      protected static const TYPE_Avatar_Hero:uint = CONST_SHORTCUTS.TYPE_Avatar_Hero;
      
      protected static const TYPE_Avatar_KnifeSoul:uint = CONST_SHORTCUTS.TYPE_Avatar_KnifeSoul;
      
      protected var FCharacter:TCharacter;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMC_Avatar:Sprite;
      
      protected var FMC_Country:MovieClip;
      
      protected var FMC_HeadPortrait:MovieClip;
      
      protected var FMC_ProgressBarMilitaryOrder:Sprite;
      
      protected var FTF_Nickname:TextField;
      
      protected var FGoldDiamondFlag:Sprite;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_MilitaryOrders:TextField;
      
      protected var FBtn_MilitaryOrders:SimpleButton;
      
      protected var FBtn_VIP:TUIButton;
      
      protected var FTF_VIPCaption:TextField;
      
      protected var FTF_FightingPower:TextField;
      
      protected var FMC_Promote:TUIButton;
      
      protected var FBtnMonthCard:SimpleButton;
      
      protected var FMonthCardTips:Sprite;
      
      protected var FTF_PayBack:TextField;
      
      protected var FTF_PayBackDay:TextField;
      
      protected var FSlotsVec:Vector.<TUISlot>;
      
      protected var FUICredits:TUICredits;
      
      protected var FMC_Pet:Sprite;
      
      protected var FTF_PetName:TextField;
      
      protected var FTF_PetStarLevel:TextField;
      
      protected var FPetImage:Sprite;
      
      protected var FMC_EffectNinjaLevel:MovieClip;
      
      protected var FTotalFightingPower:uint;
      
      protected var FHintCharacter:THint;
      
      protected var FHintSilverCoin:THint;
      
      protected var FHintGold:THint;
      
      protected var FHintGiftCertificate:THint;
      
      protected var FHintMilitaryOrders:THint;
      
      protected var FHintBtnMilitaryOrders:THint;
      
      protected var FHintMCPet:THint;
      
      protected var FHintSuperMarket:THint;
      
      protected var FHintOfficeLady:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FOrderPerBuyValue:uint;
      
      protected var FOrderBuyGold:Vector.<uint>;
      
      protected var FVipData:TVip;
      
      protected var FCounterMilitaryOrdersLimit:uint;
      
      protected var FEffectBaseGlowVIP:TEffectBaseGlow;
      
      protected var FMC_FightingEffect:MovieClip;
      
      protected var FQueryShortcut:TQueryBoolean;
      
      protected var FBleachTime:TextField;
      
      protected var FServerDate:Date;
      
      protected var FShowTimeStore:int;
      
      protected var FBleachTimeCircle:Sprite;
      
      protected var FWidth:int;
      
      protected var FHeight:int;
      
      protected var FIsEffectNinjaLevel:Boolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FBAData:TBleachAgentData;
      
      protected var FOnQueryShortcutUnlock:Function;
      
      protected var FOnEffectGenerateText:Function;
      
      protected var FOnHead:Function;
      
      protected var FOnVIP:Function;
      
      protected var FOnOpenDailySign:Function;
      
      protected var FOnFightingPower:Function;
      
      protected var FOnKnifeSoul:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnPurchase:Function;
      
      protected var FOnBleachAgent:Function;
      
      public function TWindowAvatar(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FUICredits = new TUICredits();
         this.FHintCharacter = new THint();
         this.FHintSilverCoin = new THint();
         this.FHintGold = new THint();
         this.FHintGiftCertificate = new THint();
         this.FHintMilitaryOrders = new THint();
         this.FHintBtnMilitaryOrders = new THint();
         this.FHintMCPet = new THint();
         this.FQueryShortcut = new TQueryBoolean();
         this.FVipData = this.FCharacter.VipData;
         this.FCounterMilitaryOrdersLimit = 0;
         this.ConstructPurchase();
         this.FWidth = 0;
         this.FHeight = 0;
         this.mouseEnabled = false;
         this.FIsInitialization = false;
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:TConfigValue = null;
         var _loc6_:TUISlot = null;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FMC_Avatar = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_ClassName_Avatar) as Sprite;
         this.FMC_Avatar.mouseEnabled = false;
         addChild(this.FMC_Avatar);
         this.FMC_EffectNinjaLevel = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_ClassName_MC_EffectNinjaLevel];
         addChild(this.FMC_EffectNinjaLevel);
         this.FMC_EffectNinjaLevel.mouseEnabled = false;
         this.FMC_EffectNinjaLevel.mouseChildren = false;
         this.FMC_EffectNinjaLevel.visible = false;
         this.FMC_Country = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_Country];
         this.FMC_Country.mouseEnabled = false;
         this.FMC_Country.visible = false;
         this.FMC_HeadPortrait = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_HeadPortrait];
         this.FMC_ProgressBarMilitaryOrder = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_ProgressBarMilitaryOrder];
         this.FTF_Nickname = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_TF_Nickname];
         this.FGoldDiamondFlag = this.FMC_Avatar["MC_YellowDiamond"];
         if(this.FGoldDiamondFlag != null)
         {
            this.FGoldDiamondFlag.visible = SParametersCore.IfBaiDuGame;
         }
         this.FTF_Level = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_TF_Level];
         this.FTF_Level.mouseEnabled = false;
         this.FUICredits.Resource = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_PanelCredits];
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.OnRecharge = this.UICreditsOnRecharge;
         this.FUICredits.OnBleachAgent = this.OnBleachAgentOpen;
         this.FTF_MilitaryOrders = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_TF_MilitaryOrders];
         this.FBtn_MilitaryOrders = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_Btn_MilitaryOrders];
         this.FBtn_VIP = new TUIButton();
         this.FBtn_VIP.Substrate = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_Btn_VIP];
         this.FBtn_VIP.OnClick = this.BtnVIPOnClick;
         this.FTF_VIPCaption = this.FBtn_VIP.Substrate[CONST_SHORTCUTS.RESOURCE_Link_TF_VipCaption];
         this.FTF_VIPCaption.mouseEnabled = false;
         this.FTF_FightingPower = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_FightingCapacity][CONST_SHORTCUTS.RESOURCE_Link_TF_FightingPower];
         this.FTF_FightingPower.text = "0";
         this.FMC_Promote = new TUIButton();
         this.FMC_Promote.Substrate = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_Promote];
         this.FMC_Promote.OnClick = this.ButtonPromoteOnClick;
         this.FBtnMonthCard = this.FMC_Avatar["Btn_MonthCard"];
         if(this.FBtnMonthCard != null)
         {
            this.FBtnMonthCard.addEventListener(MouseEvent.CLICK,this.OnClickOpenDailySign);
            this.FBtnMonthCard.addEventListener(MouseEvent.MOUSE_MOVE,this.OnOverMonthCardTips);
            this.FBtnMonthCard.addEventListener(MouseEvent.ROLL_OUT,this.OnOutMonthCardTips);
         }
         this.FMonthCardTips = this.FMC_Avatar["Mc_MonthCardTips"];
         this.FSlotsVec = new Vector.<TUISlot>();
         if(this.FMonthCardTips != null)
         {
            this.FMonthCardTips.visible = false;
            this.FTF_PayBack = this.FMonthCardTips["TF_PayBack"];
            this.FTF_PayBackDay = this.FMonthCardTips["TF_PayBackDay"];
            _loc2_ = SlotMax;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc6_ = new TUISlot(this);
               _loc6_.Resource = this.FMonthCardTips["MC_Slot" + _loc1_];
               if(_loc6_.Resource != null)
               {
                  _loc6_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
                  _loc6_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
                  TJadeCommon.InitSlot(_loc6_);
                  _loc6_.Init();
                  this.FSlotsVec[_loc1_] = _loc6_;
               }
               _loc1_++;
            }
         }
         this.FMC_FightingEffect = this.FMC_Avatar[CONST_SHORTCUTS.RESOURCE_Link_MC_FightingEffect];
         this.FMC_FightingEffect.mouseEnabled = false;
         this.FMC_FightingEffect.mouseChildren = false;
         this.FMC_FightingEffect.visible = false;
         this.FHintCharacter.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_04);
         this.FHintMilitaryOrders.Caption = "";
         this.FHintMilitaryOrders.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_05);
         this.FHintMCPet.Caption = "";
         this.FHintMCPet.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_06);
         this.FMC_Pet = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_ClassName_Pet) as Sprite;
         addChild(this.FMC_Pet);
         this.FMC_Pet.visible = true;
         this.FMC_Pet.mouseChildren = false;
         this.FMC_Pet.buttonMode = true;
         this.FMC_Pet.x = 10;
         this.FMC_Pet.y = 199;
         this.FTF_PetName = this.FMC_Pet[CONST_SHORTCUTS.RESOURCE_Link_TF_PetName];
         this.FTF_PetStarLevel = this.FMC_Pet[CONST_SHORTCUTS.RESOURCE_Link_TF_PetStarLevel];
         this.FPetImage = this.FMC_Pet[CONST_SHORTCUTS.RESOURCE_Link_MC_Icon];
         if(this.FMC_Avatar["BleachTime"] != null)
         {
            this.FBleachTime = this.FMC_Avatar["BleachTime"]["TFTime"];
            this.FServerDate = new Date();
            this.FShowTimeStore = 0;
            this.FBleachTimeCircle = this.FMC_Avatar["BleachTime"]["CirclePoint"];
         }
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.ORDER_PER_BUY_VALUE) as TConfigValue;
         this.FOrderPerBuyValue = _loc5_.Value as uint;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.ORDER_BUY_GOLD) as TConfigValue;
         this.FOrderBuyGold = _loc5_.Value as Vector.<uint>;
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,POSITION_Avatar * 10000 + TYPE_Avatar_KnifeSoul,this.FMC_Pet);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,POSITION_Avatar * 10000 + TYPE_Avatar_KnifeSoul,FParent);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,POSITION_Avatar * 10000 + TYPE_Avatar_Hero,this.FMC_Pet);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,POSITION_Avatar * 10000 + TYPE_Avatar_Hero,FParent);
      }
      
      protected function Resources_UILocations() : void
      {
         this.FTF_MilitaryOrders.addEventListener(MouseEvent.MOUSE_MOVE,this.TF_MilitaryOrdersOnMove,false,0,true);
         this.FMC_HeadPortrait.buttonMode = true;
         this.FMC_HeadPortrait.addEventListener(MouseEvent.CLICK,this.HeadOnMouseClick,false,0,true);
         this.FMC_HeadPortrait.addEventListener(MouseEvent.MOUSE_MOVE,this.MC_HeadPortraitOnMove,false,0,true);
         this.FMC_HeadPortrait.addEventListener(MouseEvent.MOUSE_OUT,this.MC_HeadPortraitOnOut,false,0,true);
         this.FTF_MilitaryOrders.addEventListener(MouseEvent.MOUSE_OUT,this.TFMilitaryOrdersOnOut,false,0,true);
         this.FBtn_MilitaryOrders.addEventListener(MouseEvent.CLICK,this.BtnMilitaryOrdersOnClick,false,0,true);
         this.FBtn_MilitaryOrders.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnMilitaryOrdersOnMove,false,0,true);
         this.FBtn_MilitaryOrders.addEventListener(MouseEvent.MOUSE_OUT,this.BtnMilitaryOrdersOnOut,false,0,true);
         this.FMC_Pet.addEventListener(MouseEvent.CLICK,this.MCPetOnClick,false,0,true);
         this.FMC_Pet.addEventListener(MouseEvent.MOUSE_MOVE,this.MCPetOnMove,false,0,true);
         this.FMC_Pet.addEventListener(MouseEvent.MOUSE_OUT,this.MCPetOnOut,false,0,true);
      }
      
      protected function Reset() : void
      {
         this.FTF_Nickname.text = "";
         this.FTF_Level.text = "0";
         this.FTF_MilitaryOrders.text = "0/0";
      }
      
      protected function UpdateBtnEffectBaseGlow() : void
      {
         if(this.FEffectBaseGlowVIP != null && this.FEffectBaseGlowVIP.IsRunOver)
         {
            this.FEffectBaseGlowVIP.Run();
         }
      }
      
      protected function UpdateBleachTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.FShowTimeStore != STimingCore.ServerTime && this.FBleachTime != null)
         {
            this.FShowTimeStore = STimingCore.ServerTime;
            this.FServerDate.setTime(this.FShowTimeStore * 1000);
            this.FBleachTime.text = TUtilityDate.FormatDateBleachTime(this.FServerDate);
            this.FBleachTimeCircle.graphics.clear();
            if(this.FServerDate.minutes == 0)
            {
               _loc1_ = 360;
            }
            else
            {
               _loc1_ = 6 * this.FServerDate.minutes;
            }
            _loc1_ += this.FServerDate.seconds / 10 - 90;
            _loc1_ = _loc1_ < 0 ? int(360 + _loc1_) : _loc1_;
            this.FBleachTimeCircle.graphics.lineStyle(1,12632256);
            this.FBleachTimeCircle.graphics.moveTo(0,0);
            this.FBleachTimeCircle.graphics.lineTo(TUtilityMath.CosLookTable[_loc1_] * 8,TUtilityMath.SinLookTable[_loc1_] * 8);
            _loc4_ = this.FServerDate.hours % 12;
            if(_loc4_ == 0)
            {
               _loc1_ = 360;
            }
            else
            {
               _loc1_ = 30 * _loc4_;
            }
            _loc1_ += this.FServerDate.minutes / 10 - 90;
            _loc1_ = _loc1_ < 0 ? int(360 + _loc1_) : _loc1_;
            this.FBleachTimeCircle.graphics.lineStyle(1,12632256);
            this.FBleachTimeCircle.graphics.moveTo(0,0);
            this.FBleachTimeCircle.graphics.lineTo(TUtilityMath.CosLookTable[_loc1_] * 6,TUtilityMath.SinLookTable[_loc1_] * 6);
            if(this.FServerDate.seconds == 0)
            {
               _loc1_ = 360;
            }
            else
            {
               _loc1_ = 6 * this.FServerDate.seconds;
            }
            _loc1_ -= 90;
            _loc1_ = _loc1_ < 0 ? int(360 + _loc1_) : _loc1_;
            this.FBleachTimeCircle.graphics.lineStyle(1,65280);
            this.FBleachTimeCircle.graphics.moveTo(0,0);
            this.FBleachTimeCircle.graphics.lineTo(TUtilityMath.CosLookTable[_loc1_] * 9,TUtilityMath.SinLookTable[_loc1_] * 9);
         }
      }
      
      protected function LogicsPerform_FightingPowerEffect() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(!this.FIsInitialization)
         {
            return;
         }
         _loc2_ = int(this.FTotalFightingPower);
         _loc1_ = parseInt(this.FTF_FightingPower.text);
         if(_loc1_ == _loc2_)
         {
            if(this.FMC_FightingEffect.visible)
            {
               this.FMC_FightingEffect.visible = false;
            }
            return;
         }
         _loc3_ = Math.ceil(Math.abs(_loc2_ - _loc1_) / 4);
         if(_loc1_ < _loc2_)
         {
            _loc1_ += _loc3_;
            if(!this.FMC_FightingEffect.visible)
            {
               this.FMC_FightingEffect.visible = true;
            }
            if(!this.FMC_FightingEffect.isPlaying)
            {
               this.FMC_FightingEffect.play();
            }
         }
         else if(_loc1_ > _loc2_)
         {
            _loc1_ -= _loc3_;
         }
         this.FTF_FightingPower.text = _loc1_.toString();
      }
      
      protected function UpdateCharacterInfo() : void
      {
         var _loc1_:THero = null;
         var _loc2_:uint = 0;
         if(this.FIsInitialization)
         {
            _loc1_ = this.FCharacter.MainHero;
            _loc2_ = _loc1_.Identifier % CHARACTER_BaseModeID;
            this.FMC_HeadPortrait.gotoAndStop(_loc2_);
            this.FTF_Nickname.text = this.FCharacter.NickName;
            this.FTF_Level.text = _loc1_.RebirthLevel.toString();
            this.FTF_VIPCaption.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_07),this.FCharacter.VipLevel);
         }
      }
      
      protected function UpdateCharacterCountry() : void
      {
         var _loc1_:int = 0;
         if(this.FIsInitialization)
         {
            _loc1_ = int(this.FCharacter.Country);
            if(_loc1_ != 0)
            {
               this.FMC_Country.gotoAndStop(this.FCharacter.Country);
               this.FMC_Country.visible = true;
            }
         }
      }
      
      protected function UpdateCharacterFightingPower() : void
      {
         if(this.FIsInitialization)
         {
            this.FTotalFightingPower = this.FCharacter.GetFightingPower();
         }
      }
      
      protected function UpdateMilitaryOrders() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TConfigValue = null;
         var _loc4_:Number = NaN;
         if(this.FIsInitialization)
         {
            _loc1_ = this.FCharacter.CreditMilitaryOrders;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.ORDER_RECOVER_LIMIT) as TConfigValue;
            _loc2_ = _loc3_.Value as uint;
            _loc2_ += this.FVipData.ActionLimit;
            this.FTF_MilitaryOrders.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,_loc1_,_loc2_);
            _loc4_ = _loc1_ / _loc2_;
            if(_loc4_ > 1)
            {
               _loc4_ = 1;
            }
            this.FMC_ProgressBarMilitaryOrder.scaleX = _loc4_;
         }
      }
      
      protected function UpdatePetInfo() : void
      {
         var _loc1_:TKnifeSoulData = null;
         if(this.FIsInitialization)
         {
            _loc1_ = this.FCharacter.KnifeSoul;
            this.FTF_PetStarLevel.text = _loc1_.Level.toString();
         }
      }
      
      protected function UpdateCounterMilitaryOrdersLimit() : void
      {
         var _loc1_:TSignal = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_MilitaryOrdersLimit_Ret);
         if(_loc1_ == null)
         {
            return;
         }
         _loc2_ = _loc1_.Identifier;
         _loc3_ = uint(_loc1_.Value);
         if(_loc2_ == KEY_COUNTER_MilitaryOrdersLimit)
         {
            this.FCounterMilitaryOrdersLimit = _loc3_;
         }
      }
      
      protected function ProcessorShortcutShowEffect(param1:uint, param2:Boolean) : void
      {
         var _loc3_:Boolean = false;
         if(!this.FIsInitialization)
         {
            return;
         }
         _loc3_ = this.FMC_EffectNinjaLevel.visible;
         if(_loc3_ != param2)
         {
            if(param2)
            {
               this.FMC_EffectNinjaLevel.play();
            }
            else
            {
               this.FMC_EffectNinjaLevel.stop();
            }
            this.FMC_EffectNinjaLevel.visible = param2;
            this.FIsEffectNinjaLevel = param2;
         }
      }
      
      protected function UpdateBounds() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         if(this.FIsInitialization)
         {
            this.FWidth = SIZE_Avatar_Width;
            this.FHeight = SIZE_Avatar_Height;
            if(this.FMC_Pet.visible)
            {
               this.FHeight += this.FMC_Pet.height;
            }
         }
         else
         {
            this.FWidth = 0;
            this.FHeight = 0;
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         if(this.FOnEffectGenerateText != null)
         {
            this.FOnEffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
         }
         ++this.FCounterMilitaryOrdersLimit;
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      private function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FSlotsVec == null)
         {
            return;
         }
         _loc2_ = int(this.FSlotsVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotsVec[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ButtonPromoteOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnFightingPower != null)
         {
            this.FOnFightingPower(this);
         }
      }
      
      protected function OnClickOpenDailySign(param1:MouseEvent) : void
      {
         if(this.FOnOpenDailySign != null)
         {
            this.FOnOpenDailySign(this);
         }
      }
      
      protected function OnOverMonthCardTips(param1:MouseEvent) : void
      {
         var _loc2_:TConfigValue = null;
         var _loc3_:TInventories = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:Vector.<uint> = null;
         this.FMonthCardTips.visible = true;
         this.FMonthCardTips.x = this.mouseX - this.FMonthCardTips.width - 10;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.MonthCard_PayUnFinishReward) as TConfigValue;
         _loc7_ = _loc2_.Value as Vector.<uint>;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.MonthCard_PayFinishReward) as TConfigValue;
         _loc8_ = _loc2_.Value as Vector.<uint>;
         _loc6_ = _loc7_.concat(_loc8_);
         _loc5_ = int(_loc6_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_[_loc4_],_loc3_);
            this.FSlotsVec[_loc4_].Context = _loc3_.GetInventoryByIndex(0);
            _loc4_++;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.MonthCard_Config) as TConfigValue;
         _loc6_ = _loc2_.Value as Vector.<uint>;
         this.FTF_PayBack.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_16),_loc6_[0]);
         this.FTF_PayBackDay.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_17);
      }
      
      protected function OnOutMonthCardTips(param1:MouseEvent) : void
      {
         this.FMonthCardTips.visible = false;
      }
      
      protected function TF_MilitaryOrdersOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FHintMilitaryOrders);
         }
      }
      
      protected function TFMilitaryOrdersOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHintMilitaryOrders);
         }
      }
      
      protected function HeadOnMouseClick(param1:MouseEvent) : void
      {
         SLogicsCore.SinalPostFreshGuide(CONST_SHORTCUTS.POSITION_Avatar * 10000 + CONST_SHORTCUTS.TYPE_Avatar_Hero);
         if(this.FOnHead != null)
         {
            this.FOnHead(this,null);
         }
      }
      
      protected function MC_HeadPortraitOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FHintCharacter);
         }
      }
      
      protected function MC_HeadPortraitOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHintCharacter);
         }
      }
      
      protected function BtnMilitaryOrdersOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.FCharacter.VipLevel > 0)
         {
            this.FCharacter.MilitaryBuyCount = this.FVipData.BuyActionLimit;
         }
         if(this.FOnEffectGenerateText != null)
         {
            _loc3_ = this.FCharacter.MilitaryBuyCount - this.FCounterMilitaryOrdersLimit;
            if(_loc3_ <= 0)
            {
               this.FOnEffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_12));
               return;
            }
            if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayBuyOrderFreeCount) > 0)
            {
               this.UIWindowConfirmationOnOK(null);
               return;
            }
            _loc2_ = this.FOrderBuyGold.length - _loc3_;
            if(this.FOrderBuyGold[this.FCounterMilitaryOrdersLimit] > this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate)
            {
               this.FUIWindowRecharge.SetGoldNum(this.FOrderBuyGold[this.FCounterMilitaryOrdersLimit]);
               this.FUIWindowRecharge.visible = true;
               return;
            }
            _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_10),_loc3_,this.FOrderBuyGold[this.FCounterMilitaryOrdersLimit]);
            this.FUIWindowConfirmation.Text = _loc4_;
            this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
            this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function BtnMilitaryOrdersOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.FCharacter.VipLevel > 0)
         {
            this.FCharacter.MilitaryBuyCount = this.FVipData.BuyActionLimit;
         }
         if(this.FHintOnMove != null)
         {
            _loc3_ = this.FCharacter.MilitaryBuyCount - this.FCounterMilitaryOrdersLimit;
            if(_loc3_ <= 0)
            {
               this.FHintBtnMilitaryOrders.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_12);
            }
            else if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayBuyOrderFreeCount) > 0)
            {
               this.FHintBtnMilitaryOrders.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_05),this.FOrderPerBuyValue);
            }
            else
            {
               this.FHintBtnMilitaryOrders.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_09),_loc3_,this.FOrderBuyGold[this.FCounterMilitaryOrdersLimit],this.FOrderPerBuyValue);
            }
            this.FHintOnMove(this,this.FHintBtnMilitaryOrders);
         }
      }
      
      protected function BtnMilitaryOrdersOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHintBtnMilitaryOrders);
         }
      }
      
      protected function BtnVIPOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnVIP != null)
         {
            this.FOnVIP(this);
         }
      }
      
      protected function UICreditsOnRecharge(param1:Object) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function OnBleachAgentOpen() : void
      {
         if(this.FOnBleachAgent != null)
         {
            this.FOnBleachAgent();
         }
      }
      
      protected function MCPetOnClick(param1:MouseEvent) : void
      {
         if(this.FOnKnifeSoul != null)
         {
            this.FOnKnifeSoul(this);
         }
         SLogicsCore.SinalPostFreshGuide(POSITION_Avatar * 10000 + TYPE_Avatar_KnifeSoul);
      }
      
      protected function MCPetOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FHintMCPet);
         }
      }
      
      protected function MCPetOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHintMCPet);
         }
      }
      
      protected function UIWindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:TPurchaseRequest = null;
         _loc2_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc2_.IDTemplate = CONST_MALL.MOBILITY;
         _loc2_.Quantity = 0;
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(this,_loc2_,this.FPurchaseParameters);
         }
      }
      
      public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      public function get ShortcutHeight() : int
      {
         this.UpdateBounds();
         return this.FHeight;
      }
      
      public function get OnQueryShortcutUnlock() : Function
      {
         return this.FOnQueryShortcutUnlock;
      }
      
      public function set OnQueryShortcutUnlock(param1:Function) : void
      {
         this.FOnQueryShortcutUnlock = param1;
      }
      
      public function get OnEffectGenerateText() : Function
      {
         return this.FOnEffectGenerateText;
      }
      
      public function set OnEffectGenerateText(param1:Function) : void
      {
         this.FOnEffectGenerateText = param1;
      }
      
      public function get OnHead() : Function
      {
         return this.FOnHead;
      }
      
      public function set OnHead(param1:Function) : void
      {
         this.FOnHead = param1;
      }
      
      public function get OnKnifeSoul() : Function
      {
         return this.FOnKnifeSoul;
      }
      
      public function set OnKnifeSoul(param1:Function) : void
      {
         this.FOnKnifeSoul = param1;
      }
      
      public function get OnVIP() : Function
      {
         return this.FOnVIP;
      }
      
      public function set OnVIP(param1:Function) : void
      {
         this.FOnVIP = param1;
      }
      
      public function get OnOpenDailySign() : Function
      {
         return this.FOnOpenDailySign;
      }
      
      public function set OnOpenDailySign(param1:Function) : void
      {
         this.FOnOpenDailySign = param1;
      }
      
      public function get OnFightingPower() : Function
      {
         return this.FOnFightingPower;
      }
      
      public function set OnFightingPower(param1:Function) : void
      {
         this.FOnFightingPower = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
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
      
      public function set OnBleachAgent(param1:Function) : void
      {
         this.FOnBleachAgent = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
         this.Reset();
         this.FIsInitialization = true;
      }
      
      public function Update() : void
      {
         this.FUICredits.UpdateEffect();
         this.LogicsPerform_FightingPowerEffect();
         this.UpdateCounterMilitaryOrdersLimit();
         this.UpdateBtnEffectBaseGlow();
         this.UpdateBleachTime();
         this.UpdateSlots();
      }
      
      public function TerminationButtonEffect(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.FEffectBaseGlowVIP == null)
            {
               this.FEffectBaseGlowVIP = new TEffectBaseGlow();
               if(!this.FEffectBaseGlowVIP.IsRunOver)
               {
                  this.FEffectBaseGlowVIP.SetParameters(this.FBtn_VIP.Substrate,15911245,1);
                  this.FEffectBaseGlowVIP.Run();
               }
            }
         }
         else if(this.FEffectBaseGlowVIP != null)
         {
            this.FEffectBaseGlowVIP.Stop();
            this.FEffectBaseGlowVIP.Dispose();
            this.FEffectBaseGlowVIP = null;
         }
      }
      
      public function UserUpdateCharBaseInfo() : void
      {
         this.UpdateCharacterInfo();
         this.UpdateCharacterFightingPower();
         this.UpdatePetInfo();
         this.UpdateCharacterCountry();
         this.UpdateMilitaryOrders();
         this.FUICredits.UpdatePanel();
      }
      
      public function UserUpdateCharacterCountry() : void
      {
         this.UpdateCharacterCountry();
      }
      
      public function UserUpdateFightingPower() : void
      {
         this.UpdateCharacterFightingPower();
      }
      
      public function UserUpdatePet() : void
      {
         this.UpdatePetInfo();
      }
      
      public function ShowEffectNotification(param1:uint, param2:Boolean) : void
      {
         this.ProcessorShortcutShowEffect(param1,param2);
      }
      
      public function BuyMilitary() : void
      {
         this.BtnMilitaryOrdersOnClick(null);
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         this.ProcessorShortcutShowEffect(0,this.FIsEffectNinjaLevel);
         this.Visible = true;
      }
      
      public function HideAllShortcuts() : void
      {
         this.Visible = false;
      }
      
      public function UpdateDailySignIconState(param1:Boolean) : void
      {
         if(this.FBtnMonthCard != null)
         {
            this.FBtnMonthCard.visible = param1;
         }
      }
   }
}

