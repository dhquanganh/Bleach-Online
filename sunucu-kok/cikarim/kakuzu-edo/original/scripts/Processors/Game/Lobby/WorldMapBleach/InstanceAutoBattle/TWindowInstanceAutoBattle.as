package Processors.Game.Lobby.WorldMapBleach.InstanceAutoBattle
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Campaign.AutoBattle.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.Campaign.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TWindowInstanceAutoBattle extends TProcessorLobbyWindow
   {
      
      public static const SIZE_Window_Width:uint = 495;
      
      public static const SIZE_Window_Height:uint = 435;
      
      protected static const AutoStatus_Open:int = 1;
      
      protected static const AutoStatus_Begin:int = 2;
      
      protected static const AutoStatus_End:int = 3;
      
      protected static const AUTO_TIME_GOLD_ID:int = 60101016;
      
      protected static const UPDATA_TIMESTAMP:int = 500;
      
      protected static const AUTO_TIME_COSTTIME:uint = 60;
      
      protected var FScene:MovieClip;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Start:TUIButton;
      
      protected var FBtn_Stop:TUIButton;
      
      protected var FBtn_Back:TUIButton;
      
      protected var FBtn_SpeedUp:TUIButton;
      
      protected var FTF_Difficulty:TextField;
      
      protected var FTF_MonsterCount:TextField;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_Timer:TextField;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FBackground:Sprite;
      
      protected var FConfigValue:TConfigValue;
      
      protected var FCityBins:TBins;
      
      protected var FSingleBins:TBins;
      
      protected var FSinglePointBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FEnemyArmyBins:TBins;
      
      protected var FNodalModel:TNodal;
      
      protected var FNodalAutoBattleInfo:TNodalAutoBattleInfo;
      
      protected var UnstreamizerAutoBattleInfo:TUnstreamizerAutoBattleInfo;
      
      protected var FNodalAutoInfo:TNodalAutoMonsterInfo;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FTotleTurn:int;
      
      protected var FCurTurn:int;
      
      protected var FTotleExp:int;
      
      protected var FTotleMoney:int;
      
      protected var FTotleTimer:int;
      
      protected var FStatus:int;
      
      protected var FAutoCount:int;
      
      protected var FMaxCount:int;
      
      protected var FCurCityID:int;
      
      protected var FCurSingleID:int;
      
      protected var FAutoBattleResultCount:uint;
      
      protected var FAutoInitTimer:uint;
      
      protected var FAutoUpdataUITimerID:uint;
      
      protected var FStartRunTimerID:uint;
      
      protected var FFreeAutoTurnUIVect:Vector.<TInstanceAutoTurnUI>;
      
      protected var FDifficulty:int;
      
      protected var FInitLayerIndex:int;
      
      protected var FIsContinue:Boolean;
      
      protected var FAutoUpdataUIStatus:Boolean;
      
      protected var FIsFast:Boolean;
      
      protected var FIsInit:Boolean;
      
      protected var FIsShowPassWindow:Boolean;
      
      protected var FIsHadRewardResult:Boolean;
      
      protected var FAutoTimeGold:uint;
      
      protected var FWindowConfirmationStop:TUIWindowConfirmation;
      
      protected var FWindowConfirmationFast:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FContinueAutoCount:int;
      
      protected var FContinueStartTime:uint;
      
      protected var FOnTurnBackWorldMap:Function;
      
      protected var FOnPassInstance:Function;
      
      public function TWindowInstanceAutoBattle(param1:TUIComponent)
      {
         super(param1);
         this.FBackground = new Sprite();
         this.FBackground.alpha = 0.1;
         this.FBackground.graphics.beginFill(0);
         this.FBackground.graphics.drawRect(0,0,CONST_COMMON.STAGE_Width,CONST_COMMON.STAGE_Height);
         this.FBackground.graphics.endFill();
         addChild(this.FBackground);
         this.FBackground.x = 0;
         this.FBackground.y = 0;
         this.FBackground.x = 0 - (CONST_COMMON.STAGE_Width - SIZE_Window_Width) / 2;
         this.FBackground.y = 0 - (CONST_COMMON.STAGE_Height - SIZE_Window_Height) / 2;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FNodalAutoBattleInfo = new TNodalAutoBattleInfo();
         this.UnstreamizerAutoBattleInfo = new TUnstreamizerAutoBattleInfo();
         this.FFreeAutoTurnUIVect = new Vector.<TInstanceAutoTurnUI>();
         this.FIsContinue = false;
         this.FIsInit = false;
         this.FIsShowPassWindow = false;
         this.FIsHadRewardResult = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WORLDMAP.RESOURCESID_Campaign);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         this.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,AUTO_TIME_GOLD_ID) as TConfigValue;
         this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         this.FSinglePointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
         this.FAutoTimeGold = this.FConfigValue.Value as uint;
         this.InitInstanceAuto();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCancel,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      protected function InitInstanceAuto() : void
      {
         this.FIsInit = true;
         this.FAutoBattleResultCount = 1;
         this.FAutoUpdataUIStatus = false;
         this.FAutoInitTimer = AUTO_TIME_COSTTIME;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_WORLDMAP.RESOURCE_ClassName_InstanceAutoBattle) as MovieClip;
         addChildAt(this.FScene,1);
         this.FTF_Title = this.FScene["TF_Title"];
         this.FTF_Title.mouseEnabled = false;
         this.FTF_Timer = this.FScene["TF_Timer"];
         this.FTF_Timer.mouseEnabled = false;
         this.FTF_Difficulty = this.FScene["TF_Difficulty"];
         this.FTF_MonsterCount = this.FScene["TF_MonsterCount"];
         this.FBtn_Close = this.FScene[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FScene[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Start = new TUIButton();
         this.FBtn_Start.Substrate = this.FScene["Btn_Start"];
         this.FBtn_Start.OnClick = this.OnStartFight;
         this.FBtn_Stop = new TUIButton();
         this.FBtn_Stop.Substrate = this.FScene["Btn_Stop"];
         this.FBtn_Stop.OnClick = this.OnStopFight;
         this.FBtn_SpeedUp = new TUIButton();
         this.FBtn_SpeedUp.Substrate = this.FScene["Btn_SpeedUp"];
         this.FBtn_SpeedUp.OnClick = this.OnFastFight;
         this.FBtn_Back = new TUIButton();
         this.FBtn_Back.Substrate = this.FScene["Btn_Back"];
         this.FBtn_Back.OnClick = this.OnReset;
         this.FScrollBar = new TScrollBar(this.FScene.MC_AutoScrollBar,255);
         this.FWindowConfirmationStop = SUtilityOverLayer.UIWindowConfirmation;
         this.FWindowConfirmationFast = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
      }
      
      protected function Updata() : void
      {
         var _loc1_:TSingle = null;
         var _loc2_:int = 0;
         var _loc3_:TCampaign = null;
         if(!this.FIsInit)
         {
            return;
         }
         this.FBtn_Stop.Visible = false;
         this.FBtn_Start.Visible = false;
         this.FBtn_Back.Visible = false;
         this.FBtn_SpeedUp.Visible = false;
         if(this.FStatus == AutoStatus_Open)
         {
            this.FBtn_Start.Visible = true;
         }
         else if(this.FStatus == AutoStatus_Begin)
         {
            this.FBtn_Stop.Visible = true;
            this.FBtn_SpeedUp.Visible = true;
         }
         else if(this.FStatus == AutoStatus_End)
         {
            this.FBtn_Back.Visible = true;
         }
      }
      
      protected function UpdataAutoUI() : void
      {
         var _loc1_:TTurnResult = null;
         var _loc2_:TInstanceAutoTurnUI = null;
         var _loc3_:TSinglePointPath = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.FScene == null)
         {
            return;
         }
         if(this.FNodalModel.GetCampaignById(this.FCurCityID) == null)
         {
            _loc6_ = 0;
         }
         else
         {
            _loc6_ = this.FNodalModel.GetCampaignById(this.FCurCityID).Diffculty;
         }
         this.FMaxCount = this.FNodalModel.GetCampMaxPassLayerIndex(this.FCurSingleID) > this.FNodalModel.GetCampaignById(this.FCurCityID).GetMaxEnemyCount(_loc6_) ? this.FNodalModel.GetCampaignById(this.FCurCityID).GetMaxEnemyCount(_loc6_) : this.FNodalModel.GetCampMaxPassLayerIndex(this.FCurSingleID);
         this.TotleTurn = this.FMaxCount;
         this.CurTurn = this.FNodalModel.GetCampaignById(this.FCurCityID).LayerIndex + 1;
         this.CurDifficulty = this.FCurSingleID;
         this.TotleTimer = this.FAutoInitTimer * (this.FTotleTurn - this.FCurTurn);
         if(this.FStatus == AutoStatus_Begin)
         {
            if(this.FNodalAutoBattleInfo.BattleResult.length > 0)
            {
               _loc1_ = this.FNodalAutoBattleInfo.BattleResult.shift();
               this.FTF_MonsterCount.text = this.FAutoBattleResultCount + "/" + this.FAutoCount;
               if(this.FFreeAutoTurnUIVect.length > 0)
               {
                  _loc2_ = this.FFreeAutoTurnUIVect.pop();
               }
               else
               {
                  _loc2_ = new TInstanceAutoTurnUI(null);
               }
               _loc2_.SetTurnResult(_loc1_,this.FAutoBattleResultCount++);
               this.FScrollBar.AddItem(_loc2_);
            }
            if(this.FNodalAutoBattleInfo.BattleResult.length > 0)
            {
               this.FAutoUpdataUIStatus = true;
               clearTimeout(this.FAutoUpdataUITimerID);
               this.FAutoUpdataUITimerID = setTimeout(this.UpdataAutoUI,UPDATA_TIMESTAMP);
            }
            else
            {
               clearTimeout(this.FAutoUpdataUITimerID);
               this.FAutoUpdataUIStatus = false;
               if(this.FNodalAutoBattleInfo.CostTimer <= 0 && this.FCurTurn >= this.FTotleTurn)
               {
                  this.FStatus = AutoStatus_End;
                  this.Updata();
               }
            }
         }
         if(this.FAutoBattleResultCount > this.FNodalModel.GetCampaignById(this.FCurCityID).GetMaxEnemyCount(this.FDifficulty))
         {
            if(this.FOnPassInstance != null && this.FIsShowPassWindow == false)
            {
               this.FOnPassInstance(this,this.FCurSingleID,5);
               this.FIsShowPassWindow = true;
            }
         }
      }
      
      protected function UpdataTitle() : void
      {
         var _loc1_:String = null;
         var _loc2_:TSingle = null;
         if(this.FSingleBins == null)
         {
            return;
         }
         _loc2_ = this.FSingleBins.GetDatebaseByIdentifier(this.FCurSingleID) as TSingle;
         if(_loc2_ == null)
         {
            _loc1_ = "";
         }
         else
         {
            _loc1_ = _loc2_.Name;
         }
         this.FTF_Title.text = _loc1_;
      }
      
      protected function UpdataRunTimer() : void
      {
         --this.TotleTimer;
         if(this.TotleTimer <= 0)
         {
            clearInterval(this.FStartRunTimerID);
         }
      }
      
      protected function Reset() : void
      {
         this.UpdataTitle();
         if(this.FScrollBar != null)
         {
            this.FScrollBar.Clear();
         }
         this.FStatus = AutoStatus_Open;
         this.FIsFast = false;
         this.Updata();
      }
      
      protected function OnStartFight(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(this.FStatus == AutoStatus_Begin)
         {
            return;
         }
         if(this.FAutoCount <= 0)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_AutoBattle);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(this.FCurCityID);
         _loc4_.writeInt(this.FCurSingleID);
         _loc4_.writeShort(this.FAutoCount);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FAutoBattleResultCount = this.FCurTurn + 1;
         this.FStartRunTimerID = setInterval(this.UpdataRunTimer,1000);
         this.FStatus = AutoStatus_Begin;
         this.Updata();
         this.FIsContinue = false;
         this.FIsShowPassWindow = false;
      }
      
      protected function OnStopFight(param1:Object, param2:MouseEvent) : void
      {
         if(this.FStatus != AutoStatus_Begin)
         {
            return;
         }
         if(this.FIsFast || this.FVipData.BlockTime)
         {
            FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_08));
            return;
         }
         this.FWindowConfirmationStop.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_06);
         this.FWindowConfirmationStop.OnOK = this.OnSureStop;
         this.FWindowConfirmationStop.Visible = true;
      }
      
      protected function OnFastFight(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.FIsFast || this.FVipData.BlockTime)
         {
            FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_08));
            return;
         }
         if(this.FNodalAutoBattleInfo.BattleResult.length > 0)
         {
            return;
         }
         _loc3_ = int((this.FTotleTimer - 1) / 60 + 1) * this.FAutoTimeGold;
         if(_loc3_ > this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.visible = true;
            return;
         }
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_07);
         this.FWindowConfirmationFast.Text = _loc4_.split("%count%").join(_loc3_);
         this.FWindowConfirmationFast.OnOK = this.OnSureFastFight;
         this.FWindowConfirmationFast.Visible = true;
      }
      
      protected function OnCancel(param1:MouseEvent = null) : void
      {
         if(this.FStatus == AutoStatus_Begin)
         {
            if(this.FIsFast || this.FVipData.BlockTime)
            {
               FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_08));
               return;
            }
            this.FWindowConfirmationStop.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_06);
            this.FWindowConfirmationStop.OnOK = this.OnSureStop;
            this.FWindowConfirmationStop.Visible = true;
         }
         else
         {
            this.visible = false;
            if(this.FOnTurnBackWorldMap != null)
            {
               this.FOnTurnBackWorldMap(this,false);
            }
            this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_WORLDMAP;
         }
      }
      
      protected function OnReset(param1:Object, param2:MouseEvent) : void
      {
         this.OnCancel();
      }
      
      protected function OnSureStop(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_StopAutoBattle);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(CONST_BATTLE.BattleType_Camp);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         clearTimeout(this.FAutoUpdataUITimerID);
         this.FAutoUpdataUIStatus = false;
         this.FStatus = AutoStatus_End;
         this.Updata();
         clearInterval(this.FStartRunTimerID);
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_WORLDMAP;
      }
      
      protected function OnSureFastFight(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_GoldFastAutoBattle);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(CONST_BATTLE.BattleType_Camp);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FIsFast = true;
      }
      
      protected function set CurDifficulty(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSingle = null;
         _loc2_ = param1;
         if(Boolean(this.FScene) && Boolean(this.FTF_Difficulty))
         {
            if(this.FSingleBins != null)
            {
               _loc3_ = this.FSingleBins.GetDatebaseByIdentifier(_loc2_) as TSingle;
               this.FTF_Difficulty.text = _loc3_.Hard.toString();
            }
         }
      }
      
      protected function set TotleTurn(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FNodalModel != null && this.FCurSingleID > 0)
         {
            _loc2_ = this.FNodalModel.GetCampMaxLayerIndex(this.FCurSingleID);
            _loc3_ = this.FNodalModel.GetCampaignById(this.FCurCityID).GetMaxEnemyCount(this.FDifficulty);
         }
         if(_loc2_ >= _loc3_)
         {
            _loc2_ = _loc3_;
         }
         this.FTotleTurn = _loc2_;
         if(Boolean(this.FScene) && Boolean(this.FTF_MonsterCount))
         {
            this.FTF_MonsterCount.text = String(this.FCurTurn) + "/" + String(this.FTotleTurn);
         }
         this.FAutoCount = _loc2_;
      }
      
      protected function set CurTurn(param1:int) : void
      {
         if(this.FNodalModel != null && this.FCurCityID > 0)
         {
            this.FCurTurn = this.FNodalModel.GetCampaignById(this.FCurCityID).LayerIndex;
         }
         else
         {
            this.FCurTurn = 0;
         }
         if(Boolean(this.FScene) && Boolean(this.FTF_MonsterCount))
         {
            this.FTF_MonsterCount.text = String(this.FCurTurn) + "/" + String(this.FTotleTurn);
         }
      }
      
      protected function set TotleTimer(param1:int) : void
      {
         this.FTotleTimer = param1;
         if(Boolean(this.FScene) && Boolean(this.FTF_Timer))
         {
            this.FTF_Timer.text = TUtilityTiming.fomatTime(this.FTotleTimer);
         }
      }
      
      protected function get TotleTimer() : int
      {
         return this.FTotleTimer;
      }
      
      public function get OnTurnBackWorldMap() : Function
      {
         return this.FOnTurnBackWorldMap;
      }
      
      public function set OnTurnBackWorldMap(param1:Function) : void
      {
         this.FOnTurnBackWorldMap = param1;
      }
      
      public function get OnPassInstance() : Function
      {
         return this.FOnPassInstance;
      }
      
      public function set OnPassInstance(param1:Function) : void
      {
         this.FOnPassInstance = param1;
      }
      
      public function OpenWindow(param1:TNodalAutoMonsterInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this.FNodalAutoInfo = param1;
         this.FNodalAutoInfo = param1;
         this.FCurCityID = param1.CurAutoCityId;
         this.FCurSingleID = param1.CurAutoMissionId;
         this.FAutoInitTimer = AUTO_TIME_COSTTIME;
         this.FIsFast = false;
         this.Reset();
         if(this.FScrollBar != null)
         {
            _loc3_ = this.FScrollBar.Count;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FFreeAutoTurnUIVect.push(this.FScrollBar.Items[_loc2_]);
               _loc2_++;
            }
            this.FScrollBar.Clear();
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_BATTLESENCE_AUTO;
         this.FAutoBattleResultCount = 1;
         this.UpdataAutoUI();
         this.FAutoCount = this.FTotleTurn - this.FCurTurn;
         this.FInitLayerIndex = this.FCurTurn;
         this.Visible = true;
      }
      
      public function PacketPerform_SC_AutoBattleInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FStatus = AutoStatus_Begin;
         this.UnstreamizerAutoBattleInfo.Unstreamize(_loc2_,this.FNodalAutoBattleInfo,null);
         this.TotleTimer = this.FNodalAutoBattleInfo.CostTimer;
         if(this.FNodalModel != null)
         {
            this.Updata();
            if(!this.FAutoUpdataUIStatus)
            {
               this.FAutoUpdataUITimerID = setTimeout(this.UpdataAutoUI,UPDATA_TIMESTAMP);
            }
         }
         else
         {
            this.FIsHadRewardResult = true;
         }
      }
      
      public function ContinueAutoBattleCount(param1:int, param2:uint, param3:Boolean) : void
      {
         this.FIsContinue = true;
         this.FContinueAutoCount = this.FAutoCount = param1;
         this.FContinueStartTime = param2;
         this.FIsFast = param3;
         this.FStatus = AutoStatus_Begin;
         this.UpdataTitle();
         this.Updata();
         this.TotleTurn = this.FContinueAutoCount;
         this.TotleTimer -= STimingCore.ServerTick - this.FContinueStartTime;
         this.CurDifficulty = this.FCurSingleID;
         this.FStartRunTimerID = setInterval(this.UpdataRunTimer,1000);
         if(this.Visible == true && this.FIsHadRewardResult)
         {
            this.Updata();
            if(!this.FAutoUpdataUIStatus)
            {
               this.FAutoUpdataUITimerID = setTimeout(this.UpdataAutoUI,UPDATA_TIMESTAMP);
            }
            this.FIsHadRewardResult = false;
         }
      }
      
      public function UpDataNodalModel(param1:TNodal) : void
      {
         this.FNodalModel = param1;
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
      }
   }
}

