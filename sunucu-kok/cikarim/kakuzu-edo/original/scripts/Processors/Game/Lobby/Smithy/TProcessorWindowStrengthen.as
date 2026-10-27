package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowStrengthen extends TProcessorLobbyWindow
   {
      
      public static const MillisecondsPerSecond:int = 1000;
      
      public static const MillisecondsPerMinute:int = 1000 * 60;
      
      public static const MillisecondsPerHour:int = 1000 * 60 * 60;
      
      public static const TimeClearOneTime:int = 2 * 60 * 1000;
      
      public static const STATE_READY:int = 0;
      
      public static const STATE_STRENGTHEN:int = 1;
      
      public static const STATE_WAITFORCLEAR:int = 2;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FCurrentState:int;
      
      protected var FInitialization:Boolean;
      
      protected var FEquipSlot:TUISlot;
      
      protected var FTF_StrengthenResult:TextField;
      
      protected var FTF_MainAttribute:TextField;
      
      protected var FStrengthenConsume:int;
      
      protected var FTF_StrengthenCost:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Quality:TextField;
      
      protected var FTF_GrowUp:TextField;
      
      protected var FTF_Discount:TextField;
      
      protected var FMC_Discount:MovieClip;
      
      protected var FMC_DoubleEffect:MovieClip;
      
      protected var FMC_SingleEffect:MovieClip;
      
      protected var FActivitysActiveTask:Vector.<MovieClip>;
      
      protected var FSmallIcons:Vector.<MovieClip>;
      
      protected var FTypePicTexts:Vector.<MovieClip>;
      
      protected var FTF_ActivitysCost:Vector.<TextField>;
      
      protected var FFunctions:Vector.<Function>;
      
      protected var FParameter:Vector.<int>;
      
      protected var FActivityName:MovieClip;
      
      protected var FTF_StrengthenColdTime:TextField;
      
      protected var FTextFormat:TextFormat;
      
      protected var FHint_Activitys:Vector.<THint>;
      
      protected var FMC_Activitys:Vector.<MovieClip>;
      
      protected var FTextRegistry:TRegistryInstance;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FBtn_Strengthen:MovieClip;
      
      protected var FBtn_ClearTime:MovieClip;
      
      protected var FStrengthenLevelAfterStrength:int;
      
      protected var FStrengthenLevelBeforeStrength:int;
      
      protected var FMC_CD:MovieClip;
      
      protected var FAddRate:uint;
      
      protected var FStrengthenActivitysDescribtion:Vector.<String>;
      
      protected var FChangeRedMinuteTime:int;
      
      protected var FReciveEquipment:TEquipment;
      
      protected var FHeroID:uint;
      
      protected var FStrengthenNetwork:Function;
      
      protected var FStrengthenColdTimeRequest:Function;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FStrengthenResult:uint;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnClearTime:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorWindowStrengthen(param1:TUIComponent)
      {
         super(param1);
         this.ConstructDispatchRoutines();
         this.ConstructLocationRoutines();
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Strengthen);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
      }
      
      protected function ConstructDispatchRoutines() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.StrengthenUIDispath);
         this.FUIDispatchRoutines.push(this.ActivityUIDispath);
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         this.addChild(param1);
         _loc2_ = 0;
         while(_loc2_ < this.FUIDispatchRoutines.length)
         {
            _loc3_ = this.FUIDispatchRoutines[_loc2_];
            _loc3_(param1);
            _loc2_++;
         }
      }
      
      protected function ConstructLocationRoutines() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.StrengthenLocation);
         this.FUILocationRoutines.push(this.ActivityLocation);
      }
      
      public function Perform_UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         var _loc3_:TConfigValue = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUILocationRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_SMITHY.CHANGEREDMINUTETIMEID) as TConfigValue;
         this.FChangeRedMinuteTime = _loc3_.Value as int;
         this.FChangeRedMinuteTime -= TimeClearOneTime / 1000;
         this.Reset();
         this.FInitialization = true;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            this.FEquipSlot.Update();
            this.UpdateCDTime();
            if(this.FUIWindowConfirmation.Visible)
            {
               TGameUtil.setButtonMode(this.FBtn_Strengthen,false);
               this.FBtn_Strengthen.mouseEnabled = false;
            }
         }
      }
      
      protected function StrengthenUIDispath(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         this.FEquipSlot = new TUISlot(this);
         _loc2_ = param1["Strengthen_Slot"];
         this.FEquipSlot.Resource = _loc2_;
         this.FEquipSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         this.FTF_StrengthenResult = param1["Item_0"]["TF"];
         this.FTF_MainAttribute = param1["Item_1"]["OldValue"];
         this.FTF_StrengthenCost = param1["Item_2"]["StrengthenMoney"];
         this.FTF_Level = param1["TF_Level"];
         this.FTF_Quality = param1["TF_Quality"];
         this.FTF_GrowUp = param1["TF_GrowUp"];
         this.FTF_Discount = param1["Item_3"]["NewMoney"];
         this.FMC_Discount = param1["Item_3"];
         this.FBtn_Strengthen = param1["Strengthen_OK"];
         this.FBtn_ClearTime = param1["mc_cd"]["Btn_Cleartime"];
         TGameUtil.setButtonMode(this.FBtn_ClearTime,true);
         this.FMC_DoubleEffect = param1["MC_DoubleEffect"];
         this.FMC_SingleEffect = param1["MC_SingleEffect"];
         this.FMC_CD = param1["mc_cd"];
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FStrengthenActivitysDescribtion = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_22);
      }
      
      protected function StrengthenLocation() : void
      {
         TJadeCommon.InitSlot(this.FEquipSlot);
         this.FEquipSlot.OnClick = this.OnEquipSlotClick;
         this.FEquipSlot.Init();
         this.FEquipSlot.OnOver = this.UIComponentsHintOnOver;
         this.FEquipSlot.OnOut = this.UIComponentsHintOnOut;
         this.FEquipSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Strengthen,this.OnStrengthenBtnClick);
         this.FBtn_ClearTime.addEventListener(MouseEvent.CLICK,this.HandleClearTime);
         this.FBtn_Strengthen.buttonMode = true;
         this.FMC_Discount.visible = false;
         this.FBtn_Strengthen.gotoAndStop("Disable");
         this.FBtn_Strengthen.mouseEnabled = false;
         this.FMC_DoubleEffect.gotoAndStop("End");
         this.FMC_SingleEffect.gotoAndStop("End");
      }
      
      protected function UpdateStrengthenBaseInfor() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(this.FReciveEquipment == null)
         {
            this.ResetStrengthenBaseInfor();
            return;
         }
         _loc2_ = this.GetStrengthenAttributeName();
         _loc3_ = this.GetStrengthenValue(this.FReciveEquipment.UpgradingLevel + 1);
         _loc4_ = this.GetMainTypeValue() + this.FReciveEquipment.UpgradingFlushSpiritBasisProperty;
         _loc5_ = this.GetStrengthenConsume(this.FReciveEquipment.UpgradingLevel);
         this.FStrengthenConsume = _loc5_;
         _loc1_ = _loc2_;
         _loc1_ += "+";
         _loc1_ += _loc3_ + _loc4_;
         this.FTF_StrengthenResult.text = _loc1_;
         _loc1_ = _loc2_;
         _loc1_ += "+";
         _loc1_ += _loc4_ + (this.FReciveEquipment.UpgradingBasisProperty.length > 0 ? this.FReciveEquipment.UpgradingBasisProperty[0] : 0);
         this.FTF_MainAttribute.text = _loc1_;
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_39);
         _loc1_ = _loc5_.toString();
         _loc1_ += " ";
         _loc1_ += _loc6_;
         this.FTF_StrengthenCost.text = _loc1_;
         _loc1_ = int(_loc5_ * 0.8).toString();
         _loc1_ += " ";
         _loc1_ += _loc6_;
         this.FTF_Discount.text = _loc1_;
         this.FTF_Level.text = "Lv." + this.FReciveEquipment.UpgradingLevel.toString();
         this.FTF_Quality.text = TUtilityLobby.GetColorNameByIndex(this.FReciveEquipment.Quality);
         this.FTF_Quality.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FReciveEquipment.Quality];
         this.FTF_GrowUp.text = this.FAddRate.toString();
         this.FTF_GrowUp.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FReciveEquipment.Quality];
      }
      
      protected function UpdateEquipment() : void
      {
         var _loc1_:TEquipment = null;
         this.ReciveEquipment(this.FReciveEquipment,this.FHeroID);
      }
      
      protected function ResetStrengthenBaseInfor() : void
      {
         this.FEquipSlot.Context = null;
         this.FTF_StrengthenResult.text = "";
         this.FTF_MainAttribute.text = "";
         this.FTF_StrengthenCost.text = "";
         this.FTF_Discount.text = "";
         this.FBtn_Strengthen.gotoAndStop("Disable");
         this.FBtn_Strengthen.mouseEnabled = false;
         this.FTF_Level.text = "";
         this.FTF_Quality.text = "";
         this.FTF_GrowUp.text = "";
      }
      
      protected function GetMainTypeValue() : int
      {
         var _loc1_:TBaseEquip = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,this.FReciveEquipment.IDTemplate) as TBaseEquip;
         return _loc1_.MainValue[0];
      }
      
      protected function GetStrengthenValue(param1:int) : int
      {
         var _loc2_:TArticle = null;
         var _loc3_:int = 0;
         var _loc4_:TBuildValue = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FReciveEquipment.IDTemplate) as TArticle;
         _loc3_ = _loc2_.MinorType * 10000 + _loc2_.Quality * 1000 + param1;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildValue,_loc3_) as TBuildValue;
         this.FAddRate = _loc4_.AddValue;
         return _loc4_.Value;
      }
      
      protected function GetStrengthenConsume(param1:int) : int
      {
         var _loc2_:TArticle = null;
         var _loc3_:int = 0;
         var _loc4_:TBuildConsume = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FReciveEquipment.IDTemplate) as TArticle;
         _loc3_ = _loc2_.Quality * 1000 + param1;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildConsume,_loc3_) as TBuildConsume;
         return _loc4_.Consume;
      }
      
      protected function GetStrengthenAttributeName() : String
      {
         var _loc1_:TBaseEquip = null;
         var _loc2_:int = 0;
         var _loc3_:TStarPointDesc = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,this.FReciveEquipment.IDTemplate) as TBaseEquip;
         _loc2_ = 17500000 + _loc1_.MainType[0];
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,_loc2_) as TStarPointDesc;
         return _loc3_.Desc;
      }
      
      protected function GetEquipmentByID(param1:uint) : TEquipment
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         var _loc5_:THero = null;
         var _loc6_:THeros = null;
         var _loc7_:TEquipment = null;
         _loc6_ = SLogicsCore.Character.Heros;
         _loc3_ = _loc6_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc2_);
            _loc7_ = _loc5_.EquipmentsMounted.GetInventoryByIdentifier(param1) as TEquipment;
            if(_loc7_ != null)
            {
               return _loc7_;
            }
            _loc2_++;
         }
         _loc4_ = SLogicsCore.Character.Equipments;
         return _loc4_.GetInventoryByIdentifier(param1) as TEquipment;
      }
      
      protected function PlaySingleEffect() : void
      {
         this.FMC_SingleEffect.gotoAndPlay(1);
      }
      
      protected function PlayDoubleEffect() : void
      {
         this.FMC_DoubleEffect.gotoAndPlay(1);
      }
      
      protected function ActivityUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FActivitysActiveTask = new Vector.<MovieClip>();
         this.FTF_ActivitysCost = new Vector.<TextField>();
         this.FMC_Activitys = new Vector.<MovieClip>();
         this.FSmallIcons = new Vector.<MovieClip>();
         this.FTypePicTexts = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < CONST_SMITHY.ACTIVITYNUM)
         {
            _loc3_ = param1["StrengthenItem_" + _loc2_];
            this.FMC_Activitys.push(_loc3_);
            this.FActivitysActiveTask.push(_loc3_["task"]);
            this.FTF_ActivitysCost.push(_loc3_["TFCost"]);
            this.FSmallIcons.push(_loc3_["SmallIcon"]);
            _loc3_["SmallIcon"].gotoAndStop(_loc2_ + 1);
            this.FSmallIcons.push(_loc3_["TypePicText"]);
            _loc3_["TypePicText"].gotoAndStop(_loc2_ + 1);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.ActivityOnMouseMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.ActivityOnMouseOut);
            _loc2_++;
         }
         this.FTF_StrengthenColdTime = param1["mc_cd"]["ColdDown"];
      }
      
      protected function ActivityLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:THint = null;
         _loc1_ = 0;
         while(_loc1_ < CONST_SMITHY.ACTIVITYNUM)
         {
            _loc2_ = this.FActivitysActiveTask[_loc1_];
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnActivitysActiveTaskClick);
            _loc1_++;
         }
         this.FParameter = new Vector.<int>();
         this.FTextFormat = new TextFormat();
         this.FHint_Activitys = new Vector.<THint>();
         _loc1_ = 0;
         while(_loc1_ < CONST_SMITHY.ACTIVITYNUM)
         {
            _loc3_ = new THint();
            _loc3_.Caption = this.FStrengthenActivitysDescribtion[_loc1_];
            this.FHint_Activitys.push(_loc3_);
            _loc1_++;
         }
         this.FTF_ActivitysCost[0].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_42);
         this.FTF_ActivitysCost[1].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_43);
      }
      
      protected function ResetActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FActivitysActiveTask.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivitysActiveTask[_loc1_];
            _loc3_.gotoAndStop("cancle");
            _loc1_++;
         }
         this.FParameter.length = 0;
         this.FMC_Discount.visible = false;
      }
      
      protected function UpdateCDTime() : void
      {
         var _loc1_:uint = 0;
         if(SLogicsCore.Character.IfArriveLimitTime)
         {
            _loc1_ = 16711680;
            TGameUtil.setButtonMode(this.FBtn_ClearTime,true);
            this.FBtn_ClearTime.mouseEnabled = true;
         }
         else
         {
            _loc1_ = 16777011;
            TGameUtil.setButtonMode(this.FBtn_ClearTime,true);
            this.FBtn_ClearTime.mouseEnabled = true;
         }
         if(this.FTimeCoolDown.TimingTime == 0)
         {
            TGameUtil.setButtonMode(this.FBtn_ClearTime,false);
            this.FBtn_ClearTime.mouseEnabled = false;
            SLogicsCore.Character.IfArriveLimitTime = false;
         }
         if(this.FTF_StrengthenColdTime.textColor != _loc1_)
         {
            this.FTF_StrengthenColdTime.textColor = _loc1_;
         }
         this.FTF_StrengthenColdTime.text = TUtilityTiming.fomatTime(this.FTimeCoolDown.TimingTime);
      }
      
      protected function ResetInterface() : void
      {
         this.FReciveEquipment = null;
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      protected function VerificationStrengthen() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.FStrengthenNetwork == null)
         {
            return false;
         }
         if(this.FBtn_Strengthen.currentFrameLabel == "Disable")
         {
            return false;
         }
         if(!SLogicsCore.Character.VipData.NoClearTime && this.FTF_StrengthenColdTime.textColor == 16711680)
         {
            this.HandleClearTime(null);
            return false;
         }
         if(SLogicsCore.Character.CreditSilverCoin.ToNumber() < this.FStrengthenConsume)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_5);
            return false;
         }
         if(SLogicsCore.Character.GetMainLevel() <= this.FReciveEquipment.UpgradingLevel)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_6);
            return false;
         }
         return true;
      }
      
      protected function OnStrengthenBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Boolean = false;
         var _loc5_:TCharacter = null;
         var _loc6_:uint = 0;
         var _loc7_:TConfigValue = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartStrengthen);
         _loc4_ = this.VerificationStrengthen();
         if(!_loc4_)
         {
            return;
         }
         this.FParameter.length = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FActivitysActiveTask.length)
         {
            _loc3_ = this.FActivitysActiveTask[_loc2_];
            if(_loc3_.currentFrameLabel == "ok")
            {
               this.FParameter.push(CONST_SMITHY.STRENGTHTYPEARRAY[_loc2_]);
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_SMITHY.STRENGTHTYPECONFIGS[_loc2_]) as TConfigValue;
               _loc6_ += _loc7_.Value as int;
            }
            _loc2_++;
         }
         _loc5_ = SLogicsCore.Character;
         if(_loc6_ > _loc5_.CreditGold + _loc5_.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc6_);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         this.FStrengthenNetwork(this,this.FHeroID,this.FReciveEquipment,this.FParameter);
         this.FStrengthenLevelBeforeStrength = this.FReciveEquipment.UpgradingLevel;
         this.FCurrentState = STATE_STRENGTHEN;
      }
      
      protected function OnConfirmationOk(param1:Object) : void
      {
         if(this.FOnClearTime != null)
         {
            this.FOnClearTime();
            this.FCurrentState = STATE_WAITFORCLEAR;
         }
         if(this.FReciveEquipment != null)
         {
            TGameUtil.setButtonMode(this.FBtn_Strengthen,true);
            this.FBtn_Strengthen.mouseEnabled = true;
         }
      }
      
      protected function OnConfirmationCancel(param1:Object) : void
      {
         if(this.FReciveEquipment != null)
         {
            TGameUtil.setButtonMode(this.FBtn_Strengthen,true);
            this.FBtn_Strengthen.mouseEnabled = true;
         }
      }
      
      protected function HandleClearTime(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TCharacter = null;
         if(this.FTimeCoolDown.TimingTime <= 0)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_8);
            return;
         }
         var _loc4_:TConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60106020) as TConfigValue;
         _loc2_ = Math.ceil(this.FTimeCoolDown.TimingTime / (60 * (_loc4_.Value as int)));
         _loc3_ = SLogicsCore.Character;
         if(_loc2_ > _loc3_.CreditGold + _loc3_.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc2_);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_35),_loc2_);
         this.FUIWindowConfirmation.OnOK = this.OnConfirmationOk;
         this.FUIWindowConfirmation.OnCancel = this.OnConfirmationCancel;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnActivitysActiveTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FActivitysActiveTask.indexOf(_loc2_);
         if(_loc2_.currentFrameLabel == "ok")
         {
            _loc2_.gotoAndStop("cancle");
            if(_loc3_ == 1)
            {
               this.FMC_Discount.visible = false;
            }
         }
         else
         {
            _loc2_.gotoAndStop("ok");
            if(_loc3_ == 1)
            {
               this.FMC_Discount.visible = true;
            }
         }
      }
      
      protected function OnEquipSlotClick(param1:Object, param2:Object) : void
      {
         this.Reset();
         this.UIComponentsHintOnOut(param1,param2 as TInventory);
      }
      
      protected function UIComponentsHintOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOver != null)
         {
            this.FOnSlotMouseOver(param1,param2);
         }
      }
      
      protected function UIComponentsHintOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOut != null)
         {
            this.FOnSlotMouseOut(param1,param2);
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      protected function ActivityOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FMC_Activitys.indexOf(_loc2_);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint_Activitys[_loc3_]);
         }
      }
      
      protected function ActivityOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FMC_Activitys.indexOf(_loc2_);
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint_Activitys[_loc3_]);
         }
      }
      
      public function set StrengthenNetwork(param1:Function) : void
      {
         this.FStrengthenNetwork = param1;
      }
      
      public function set StrengthenLevel(param1:int) : void
      {
         this.FStrengthenLevelAfterStrength = param1;
      }
      
      public function set StrengthenCDTime(param1:uint) : void
      {
         this.FTimeCoolDown.TimingTime = param1;
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function set StrengthenColdTimeRequest(param1:Function) : void
      {
         this.FStrengthenColdTimeRequest = param1;
      }
      
      public function set StrengthenResult(param1:uint) : void
      {
         this.FStrengthenResult = param1;
      }
      
      public function set OnClearTime(param1:Function) : void
      {
         this.FOnClearTime = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function Update() : void
      {
         var _loc1_:THero = null;
         switch(this.FCurrentState)
         {
            case STATE_READY:
               break;
            case STATE_STRENGTHEN:
               if(this.FStrengthenResult == 0)
               {
                  this.UpdateEquipment();
                  if(this.FStrengthenLevelAfterStrength == this.FStrengthenLevelBeforeStrength + 2)
                  {
                     this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_2);
                     this.PlayDoubleEffect();
                  }
                  else
                  {
                     this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_0);
                     this.PlaySingleEffect();
                  }
                  if(this.FUpdateHeroPower != null && this.FHeroID != 0)
                  {
                     this.FUpdateHeroPower(this,this.FHeroID);
                  }
               }
               else
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_4);
               }
               this.FCurrentState = STATE_READY;
               break;
            case STATE_WAITFORCLEAR:
               if(this.FStrengthenResult == 0)
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_10);
               }
               else
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_9);
               }
               this.FCurrentState = STATE_READY;
         }
         if(SLogicsCore.Character.VipData.NoClearTime)
         {
            this.FMC_CD.visible = false;
            SLogicsCore.Character.IfArriveLimitTime = false;
            this.FTimeCoolDown.TimingTime;
         }
         else
         {
            this.FMC_CD.visible = true;
         }
      }
      
      public function Reset() : void
      {
         this.FCurrentState = STATE_READY;
         this.ResetStrengthenBaseInfor();
         this.ResetActivity();
         this.ResetInterface();
      }
      
      public function ReciveEquipment(param1:TEquipment, param2:uint) : void
      {
         if(param1.UpgradingLevel == CONST_SMITHY.StrengthenMaxLevel)
         {
            return;
         }
         this.FReciveEquipment = param1;
         this.FHeroID = param2;
         this.FEquipSlot.Context = this.FReciveEquipment;
         this.UpdateStrengthenBaseInfor();
         if(this.FReciveEquipment == null)
         {
            this.FBtn_Strengthen.gotoAndStop("Disable");
            this.FBtn_Strengthen.mouseEnabled = false;
         }
         else
         {
            this.FBtn_Strengthen.gotoAndStop("Enable");
            this.FBtn_Strengthen.mouseEnabled = true;
         }
      }
   }
}

