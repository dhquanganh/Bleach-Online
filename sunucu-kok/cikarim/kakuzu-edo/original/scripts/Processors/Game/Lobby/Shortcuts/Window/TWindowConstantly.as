package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.TimeCoolDown.*;
   import Logics.Unlocks.*;
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
   
   public class TWindowConstantly extends TUIComponent
   {
      
      protected static const STATE_HIDE:int = 0;
      
      protected static const STATE_RUNNING:int = 1;
      
      protected static const STATE_ColdDown:int = 0;
      
      protected static const STATE_Colding:int = 1;
      
      protected static const MillisecondsPerSecond:int = 1000;
      
      protected static const MillisecondsPerMinute:int = 1000 * 60;
      
      protected static const MillisecondsPerHour:int = 1000 * 60 * 60;
      
      protected static const TYPE_Home_HellButterfly:uint = CONST_SHORTCUTS.TYPE_Home_HellButterfly;
      
      protected static const TYPE_Home_Slave:uint = CONST_SHORTCUTS.TYPE_Home_Slave;
      
      protected static const TYPE_Constantly_GirlGame:uint = CONST_SHORTCUTS.TYPE_Constantly_GirlGame;
      
      protected static const Index_Position:int = 0;
      
      protected static const Index_Location:int = 1;
      
      protected static const Index_Type:int = 2;
      
      protected static const ConstantlyYOffset:int = 25;
      
      protected static const CHANGEREDMINUTETIME:int = 20;
      
      protected static const TimeClearOneTime:int = 2 * 60 * 1000;
      
      protected var FUIConstantlys:Vector.<MovieClip>;
      
      protected var FUIConstantlyArrows:Vector.<SimpleButton>;
      
      protected var FTFConstantlysLable:Vector.<TextField>;
      
      protected var FTFConstantlysTime:Vector.<TextField>;
      
      protected var FConstantlysState:Vector.<int>;
      
      protected var FTimers:Vector.<TTimeCoolDown>;
      
      protected var FVisibleContorlGlobal:Vector.<Boolean>;
      
      protected var FVisibleContorlLocation:Vector.<Boolean>;
      
      protected var FRoutinesTextClick:TRegistryRoutine;
      
      protected var FRoutinesTailClick:TRegistryRoutine;
      
      protected var FPromotWindow:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FHint_ClearTime:THint;
      
      protected var FWidth:int;
      
      protected var FInitCompleted:Boolean;
      
      protected var FChangeRedMinuteTime:int;
      
      protected var FOnOpenFunctionWindow:Function;
      
      protected var FOnStrengthenClearCD:Function;
      
      protected var FOnArenaClearCD:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TWindowConstantly(param1:TUIComponent)
      {
         super(param1);
         this.RegistryRoutines();
         this.FWidth = 0;
      }
      
      public function Perform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FConstantlysState = new Vector.<int>(CONST_SHORTCUTS.CONSTANTLY_NUM);
         this.FUIConstantlys = new Vector.<MovieClip>();
         this.FTFConstantlysLable = new Vector.<TextField>();
         this.FTFConstantlysTime = new Vector.<TextField>();
         this.FUIConstantlyArrows = new Vector.<SimpleButton>();
         _loc3_ = int(CONST_SHORTCUTS.CONSTANTLY_NUM);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("mc_constantly") as MovieClip;
            _loc1_.x = 35;
            addChild(_loc1_);
            this.FUIConstantlys.push(_loc1_);
            this.FUIConstantlyArrows.push(_loc1_["Btn_Cleartime"]);
            this.FTFConstantlysLable.push(_loc1_["TF_Lable1"]);
            this.FTFConstantlysTime.push(_loc1_["TF_Lable2"]);
            _loc1_ = _loc1_["icon"];
            _loc1_.gotoAndStop(_loc2_ + 1);
            _loc2_++;
         }
         this.FPromotWindow = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,CONST_SHORTCUTS.POSITION_Constantly * 10000,this);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,CONST_SHORTCUTS.POSITION_Constantly * 10000,this);
         this.UILocation();
      }
      
      protected function UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         var _loc3_:SimpleButton = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TTimeCoolDown = null;
         var _loc6_:TConfigValue = null;
         this.FVisibleContorlGlobal = new Vector.<Boolean>(CONST_SHORTCUTS.CONSTANTLY_NUM);
         this.FVisibleContorlLocation = new Vector.<Boolean>(CONST_SHORTCUTS.CONSTANTLY_NUM);
         _loc1_ = 0;
         while(_loc1_ < CONST_SHORTCUTS.CONSTANTLY_NUM)
         {
            _loc2_ = this.FTFConstantlysLable[_loc1_];
            _loc2_.addEventListener(TextEvent.LINK,this.TextClicked);
            _loc2_ = this.FTFConstantlysTime[_loc1_];
            _loc2_.addEventListener(TextEvent.LINK,this.TextClicked);
            _loc3_ = this.FUIConstantlyArrows[_loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.ArrowClicked);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.ArrowMouseMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.ArrowMouseOut);
            this.FConstantlysState[_loc1_] = STATE_RUNNING;
            this.FUIConstantlys[_loc1_].visible = false;
            this.FVisibleContorlGlobal[_loc1_] = false;
            this.FVisibleContorlLocation[_loc1_] = false;
            _loc1_++;
         }
         this.FHint_ClearTime = new THint();
         this.FHint_ClearTime.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_14);
         this.FTimers = new Vector.<TTimeCoolDown>();
         _loc5_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Strengthen);
         this.FTimers.push(_loc5_);
         _loc5_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Arean);
         this.FTimers.push(_loc5_);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_SMITHY.CHANGEREDMINUTETIMEID) as TConfigValue;
         this.FChangeRedMinuteTime = _loc6_.Value as int;
         this.FChangeRedMinuteTime -= TimeClearOneTime / 1000;
         this.FInitCompleted = true;
      }
      
      protected function RePosition() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_SHORTCUTS.CONSTANTLY_NUM)
         {
            _loc2_ = this.FUIConstantlys[_loc1_];
            _loc3_ = this.FConstantlysState[_loc1_];
            if(this.FVisibleContorlGlobal[_loc1_] && this.FVisibleContorlLocation[_loc1_])
            {
               _loc2_.y = _loc4_ * ConstantlyYOffset;
               _loc4_++;
            }
            _loc1_++;
         }
      }
      
      protected function RegistryRoutines() : void
      {
         this.FRoutinesTextClick = new TRegistryRoutine();
         this.FRoutinesTailClick = new TRegistryRoutine();
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_Strengthen,this.TextClick_Strengthen);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_Strengthen,this.ArrowClick_Strengthen);
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_Arena,this.TextClick_Arena);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_Arena,this.ArrowClick_Arena);
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_HellButterfly,this.TextClick_HellButterfly);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_HellButterfly,this.ArrowClick_HellButterfly);
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_Slave,this.TextClick_Slave);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_Slave,this.ArrowClick_Slave);
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_GirlGame,this.TextClick_GirlGame);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_GirlGame,null);
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_CustomHero,this.TextClick_CustomHero);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_CustomHero,this.TextClick_CustomHero);
         this.FRoutinesTextClick.Register(CONST_SHORTCUTS.TYPE_Constantly_CollectSoul,this.TextClick_CollectSoul);
         this.FRoutinesTailClick.Register(CONST_SHORTCUTS.TYPE_Constantly_CollectSoul,this.TextClick_CollectSoul);
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TTimeCoolDown = null;
         if(!this.FInitCompleted)
         {
            return;
         }
         _loc2_ = int(CONST_SHORTCUTS.CONSTANTLY_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.UpdateByIndex(_loc1_);
            _loc1_++;
         }
         _loc4_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Strengthen);
         if(SLogicsCore.Character.VipData.NoClearTime)
         {
            _loc4_.TimingTime = 0;
         }
         if(_loc4_.TimingTime <= 0)
         {
            SLogicsCore.Character.IfArriveLimitTime = false;
         }
      }
      
      protected function UpdateByIndex(param1:int) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:TTimeCoolDown = null;
         var _loc7_:int = 0;
         if(this.FConstantlysState[param1] == STATE_HIDE)
         {
            return;
         }
         if(param1 >= this.FTimers.length)
         {
            _loc7_ = STATE_ColdDown;
         }
         else
         {
            _loc6_ = this.FTimers[param1];
            if(_loc6_.TimingTime <= 0)
            {
               _loc7_ = STATE_ColdDown;
            }
            else
            {
               _loc7_ = STATE_Colding;
            }
         }
         switch(_loc7_)
         {
            case STATE_ColdDown:
               _loc3_ = this.GetLeftLableByIndex(param1);
               _loc4_ = this.GetRightLableByIndex(param1);
               this.FUIConstantlyArrows[param1].visible = false;
               break;
            case STATE_Colding:
               _loc5_ = TUtilityTiming.fomatTime(_loc6_.TimingTime);
               _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[param1 * 3],"FFFFFF",param1.toString());
               _loc4_ = TUtilityString.Format(this.GetColdingFormatStringByIndex(param1),param1.toString(),_loc5_);
               this.FUIConstantlyArrows[param1].visible = true;
         }
         _loc2_ = this.FTFConstantlysLable[param1];
         _loc2_.htmlText = _loc3_;
         _loc2_ = this.FTFConstantlysTime[param1];
         _loc2_.htmlText = _loc4_;
      }
      
      protected function GetLeftLableByIndex(param1:int) : String
      {
         switch(param1)
         {
            case CONST_SHORTCUTS.TYPE_Constantly_Strengthen:
            case CONST_SHORTCUTS.TYPE_Constantly_Arena:
            case CONST_SHORTCUTS.TYPE_Constantly_HellButterfly:
            case CONST_SHORTCUTS.TYPE_Constantly_GirlGame:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[param1 * 3],"FF00",param1.toString());
            case CONST_SHORTCUTS.TYPE_Constantly_Slave:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[param1 * 3],"FF00",param1.toString(),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_40)[SLogicsCore.Mentorship.Identity]);
            case CONST_SHORTCUTS.TYPE_Constantly_CustomHero:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[14],"FF00",param1.toString());
            case CONST_SHORTCUTS.TYPE_Constantly_CollectSoul:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[16],"FF00",param1.toString());
            case CONST_SHORTCUTS.TYPE_Constantly_GirlGame:
         }
         return "";
      }
      
      protected function GetRightLableByIndex(param1:int) : String
      {
         switch(param1)
         {
            case CONST_SHORTCUTS.TYPE_Constantly_Strengthen:
            case CONST_SHORTCUTS.TYPE_Constantly_Arena:
            case CONST_SHORTCUTS.TYPE_Constantly_HellButterfly:
            case CONST_SHORTCUTS.TYPE_Constantly_GirlGame:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[param1 * 3 + 1],param1.toString());
            case CONST_SHORTCUTS.TYPE_Constantly_Slave:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[param1 * 3 + 1],param1.toString(),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_41)[SLogicsCore.Mentorship.Identity]);
            case CONST_SHORTCUTS.TYPE_Constantly_CustomHero:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[14 + 1],param1.toString());
            case CONST_SHORTCUTS.TYPE_Constantly_CollectSoul:
               return TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[16 + 1],param1.toString());
            default:
               return "";
         }
      }
      
      protected function UpdateHellBufferFly() : void
      {
      }
      
      protected function GetColdingFormatStringByIndex(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 == CONST_SHORTCUTS.TYPE_Constantly_Strengthen)
         {
            if(SLogicsCore.Character.IfArriveLimitTime)
            {
               return TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[2];
            }
            return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_39);
         }
         return TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_42)[param1 * 3 + 2];
      }
      
      protected function TextClick_Strengthen() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Strengthen);
         }
      }
      
      protected function ArrowClick_Strengthen() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TTimeCoolDown = null;
         var _loc3_:TCharacter = null;
         _loc2_ = this.FTimers[CONST_SHORTCUTS.TYPE_Constantly_Strengthen];
         _loc1_ = Math.ceil(_loc2_.TimingTime / 60);
         _loc3_ = SLogicsCore.Character;
         if(_loc1_ > _loc3_.CreditGold + _loc3_.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc1_);
            this.FUIWindowRecharge.visible = true;
            return;
         }
         this.OpenPromotWindow(_loc1_);
         this.FPromotWindow.OnOK = this.StrengthenClearTime;
      }
      
      protected function StrengthenClearTime(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SmithyStrengthClearTime);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function TextClick_Arena() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_SecondaryFunctionB,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_Arena);
         }
      }
      
      protected function ArrowClick_Arena() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TCharacter = null;
         var _loc3_:TTimeCoolDown = null;
         _loc3_ = this.FTimers[CONST_SHORTCUTS.TYPE_Constantly_Arena];
         _loc1_ = Math.ceil(_loc3_.TimingTime / 60);
         _loc2_ = SLogicsCore.Character;
         if(_loc1_ > _loc2_.CreditGold + _loc2_.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc1_);
            this.FUIWindowRecharge.visible = true;
            return;
         }
         this.OpenPromotWindow(_loc1_);
         this.FPromotWindow.OnOK = this.ArenaClearTime;
      }
      
      protected function ArenaClearTime(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_Faster_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function TextClick_HellButterfly() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_Home,CONST_SHORTCUTS.TYPE_Home_HellButterfly);
         }
      }
      
      protected function ArrowClick_HellButterfly() : void
      {
      }
      
      protected function TextClick_Slave() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_Home,CONST_SHORTCUTS.TYPE_Home_Slave);
         }
      }
      
      protected function ArrowClick_Slave() : void
      {
      }
      
      protected function TextClick_GirlGame() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_Constantly,CONST_SHORTCUTS.TYPE_Constantly_GirlGame);
         }
      }
      
      protected function ArrowClick_GirlGame() : void
      {
      }
      
      protected function OpenPromotWindow(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_13),param1);
         this.FPromotWindow.Text = _loc2_;
         this.FPromotWindow.Visible = true;
      }
      
      protected function TextClick_CustomHero() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CustomHero);
         }
      }
      
      protected function TextClick_CollectSoul() : void
      {
         if(this.FOnOpenFunctionWindow != null)
         {
            this.FOnOpenFunctionWindow(this,CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_CollectSoul);
         }
      }
      
      protected function CheckHit(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Vector.<int> = null;
         _loc5_ = CONST_SHORTCUTS.UnlockCommand;
         _loc4_ = int(_loc5_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_[_loc3_];
            if(_loc6_[Index_Position] == param1 && _loc6_[Index_Location] == param2)
            {
               return _loc6_[Index_Type];
            }
            _loc3_++;
         }
         return -1;
      }
      
      protected function UpdateBounds() : void
      {
         if(!this.FInitCompleted)
         {
            return;
         }
         if(this.FInitCompleted)
         {
            this.FWidth = this.width;
         }
         else
         {
            this.FWidth = 0;
         }
      }
      
      protected function TextClicked(param1:TextEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         _loc2_ = int(param1.text);
         _loc3_ = this.FRoutinesTextClick.GetRoutineByIndentifier(_loc2_);
         _loc3_();
      }
      
      protected function ArrowClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         var _loc4_:Function = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = this.FUIConstantlyArrows.indexOf(_loc3_);
         _loc4_ = this.FRoutinesTailClick.GetRoutineByIndentifier(_loc2_);
         _loc4_();
      }
      
      protected function ArrowMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint_ClearTime);
         }
      }
      
      protected function ArrowMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint_ClearTime);
         }
      }
      
      public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      public function set OnStrengthenClearCD(param1:Function) : void
      {
         this.FOnStrengthenClearCD = param1;
         this.FUIConstantlys[CONST_SHORTCUTS.TYPE_Constantly_Strengthen].visible = true;
      }
      
      public function set OnArenaClearCD(param1:Function) : void
      {
         this.FOnArenaClearCD = param1;
         this.FUIConstantlys[CONST_SHORTCUTS.TYPE_Constantly_Arena].visible = true;
      }
      
      public function set OnOpenFunctionWindow(param1:Function) : void
      {
         this.FOnOpenFunctionWindow = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function UnlockingNotification(param1:TUnlock) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.CheckHit(param1.Position,param1.Index);
         if(_loc2_ != -1)
         {
            this.FConstantlysState[_loc2_] = STATE_RUNNING;
            this.FVisibleContorlLocation[_loc2_] = true;
            if(this.FVisibleContorlGlobal[_loc2_])
            {
               this.FUIConstantlys[_loc2_].visible = true;
            }
         }
         this.RePosition();
      }
      
      public function UpdateShortcutsState(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUnlock = null;
         var _loc5_:TUnlocks = null;
         _loc5_ = param1 as TUnlocks;
         _loc2_ = 0;
         while(_loc2_ < CONST_SHORTCUTS.CONSTANTLY_NUM)
         {
            this.FVisibleContorlLocation[_loc2_] = false;
            this.FUIConstantlys[_loc2_].visible = false;
            _loc2_++;
         }
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetUnlockByIndex(_loc2_);
            if(_loc4_.State == TUnlock.UNLOCKSTATE_Unlocked)
            {
               this.UnlockingNotification(_loc4_);
            }
            _loc2_++;
         }
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         if(!this.FInitCompleted)
         {
            return;
         }
         _loc3_ = this.FUIConstantlys[param2];
         this.FVisibleContorlGlobal[param2] = true;
         _loc3_.visible = this.FVisibleContorlGlobal[param2] && this.FVisibleContorlLocation[param2];
         this.RePosition();
      }
      
      public function HideAllShortcuts() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(!this.FInitCompleted)
         {
            return;
         }
         _loc1_ = int(CONST_SHORTCUTS.TYPE_CONSTANTLY.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FUIConstantlys[_loc2_];
            this.FVisibleContorlGlobal[_loc2_] = false;
            _loc3_.visible = false;
            _loc2_++;
         }
         this.RePosition();
      }
   }
}

