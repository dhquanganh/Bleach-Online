package Processors.Game.Lobby.WorldMapBleach.BarrierAutoBattle
{
   import Components.ScrollBar.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.SParametersCore;
   import Logics.Campaign.*;
   import Logics.Campaign.AutoBattle.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.Campaign.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Quests.QuestNew.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorBarrierAutoBattle extends TProcessorLobbyWindows
   {
      
      public static const SIZE_Window_Width:uint = 428;
      
      public static const SIZE_Window_Height:uint = 470;
      
      protected static const AutoStatus_Open:int = 1;
      
      protected static const AutoStatus_Begin:int = 2;
      
      protected static const AutoStatus_End:int = 3;
      
      protected static const AutoInitCount:int = 10;
      
      protected static const AUTO_TIME_GOLD_ID:int = 60101016;
      
      protected static const UPDATA_TIMESTAMP:int = 500;
      
      protected static const SingleAutoBattleTime:int = 60;
      
      protected static const MonstorTextFilter:GlowFilter = new GlowFilter(4397068,1,2,2,5);
      
      protected var FAutoCityId:int;
      
      protected var FAutoMissionId:int;
      
      protected var FAutoCount:int;
      
      protected var FStartTime:int;
      
      protected var FIsFast:Boolean;
      
      protected var FNodalAutoInfo:TNodalAutoMonsterInfo;
      
      protected var FStatus:int;
      
      protected var FMaxCount:int;
      
      protected var FCurCityID:int;
      
      protected var FCurMissionID:int;
      
      protected var FScene:MovieClip;
      
      protected var FAutoBattleResultCount:int;
      
      protected var FTotleTurn:int;
      
      protected var FCurTurn:int;
      
      protected var FTotleExp:int;
      
      protected var FTotleMoney:int;
      
      protected var FTotleTimer:int;
      
      protected var FMonsterScrollBar:TScrollBar;
      
      protected var FAutoScrollBar:TScrollBar;
      
      protected var FNodalAutoBattleInfo:TNodalAutoBattleInfo;
      
      protected var UnstreamizerAutoBattleInfo:TUnstreamizerAutoBattleInfo;
      
      protected var FAutoInitTimer:int;
      
      protected var FAutoUpdataUIStatus:Boolean;
      
      protected var FAutoUpdataUITimerID:uint;
      
      protected var FStartRunTimerID:uint;
      
      protected var FWindowConfirmationStop:TUIWindowConfirmation;
      
      protected var FWindowConfirmationFast:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FBlockPointBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FEnemyArmyBins:TBins;
      
      protected var FAutoTimeGold:uint;
      
      protected var FFreeMonsterTextFieldVect:Vector.<TextField>;
      
      protected var FFreeAutoTurnUIVect:Vector.<TAutoTurnUI>;
      
      protected var FIsInit:Boolean;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FContinueAutoCount:int;
      
      protected var FContinueStartTime:uint;
      
      protected var FIsContinue:Boolean;
      
      protected var FContinueStream:ByteArray;
      
      protected var FAutoByteArray:ByteArray;
      
      protected var FPoolCampaign:TPoolCampaign;
      
      protected var FBattleType:int;
      
      public function TProcessorBarrierAutoBattle(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FFreeMonsterTextFieldVect = new Vector.<TextField>();
         this.FFreeAutoTurnUIVect = new Vector.<TAutoTurnUI>();
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FAutoTimeGold = 1;
         this.FNodalAutoBattleInfo = new TNodalAutoBattleInfo();
         this.UnstreamizerAutoBattleInfo = new TUnstreamizerAutoBattleInfo();
         this.FPoolCampaign = SLogicsCore.PoolCampaign;
         this.FIsContinue = false;
         this.FIsInit = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WORLDMAP.RESOURCESID_MonsterMap);
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
         var _loc1_:TConfigValue = null;
         this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.FEnemyArmyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,AUTO_TIME_GOLD_ID) as TConfigValue;
         this.FAutoTimeGold = _loc1_.Value as uint;
         this.InitAutoNodal();
         this.OpenWindow(this.FNodalAutoInfo);
         this.Updata();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdataAutoUI() : void
      {
         var _loc1_:TTurnResult = null;
         var _loc2_:TAutoTurnUI = null;
         var _loc3_:TQuestInfor = null;
         if(this.FScene == null)
         {
            return;
         }
         if(this.FStatus == AutoStatus_Begin)
         {
            if(this.FNodalAutoBattleInfo.BattleResult.length > 0)
            {
               _loc1_ = this.FNodalAutoBattleInfo.BattleResult.shift();
               this.FScene.tf_turn.text = this.FAutoBattleResultCount + "/" + this.FAutoCount;
               if(this.FFreeAutoTurnUIVect.length > 0)
               {
                  _loc2_ = this.FFreeAutoTurnUIVect.pop();
               }
               else
               {
                  _loc2_ = new TAutoTurnUI(null);
               }
               _loc2_.SetTurnResult(_loc1_,this.FAutoBattleResultCount++);
               this.FAutoScrollBar.AddItem(_loc2_);
               this.TotleExp += _loc2_.TotleExp;
               this.TotleMoney += _loc2_.TotleMoney;
               _loc3_ = new TQuestInfor();
               _loc3_.InforID = CONST_QUEST.QUEST_INFOR_KILLMONSTER;
               _loc3_.InforArray.push(this.FCurMissionID);
               _loc3_.InforArray.push(1);
               SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_QUEST,0,0,_loc3_);
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
               if(this.FNodalAutoBattleInfo.CostTimer <= 0 && this.FAutoBattleResultCount >= this.FAutoCount)
               {
                  this.FStatus = AutoStatus_End;
                  this.Updata();
               }
            }
         }
      }
      
      protected function InitAutoNodal() : void
      {
         this.FIsInit = true;
         this.FAutoBattleResultCount = 1;
         this.FAutoUpdataUIStatus = false;
         this.FAutoInitTimer = SingleAutoBattleTime;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_WORLDMAP.RESOURCE_ClassName_AutoBattle) as MovieClip;
         addChild(this.FScene);
         this.FScene.x = (CONST_COMMON.STAGE_Width - SIZE_Window_Width) / 2;
         this.FScene.y = (CONST_COMMON.STAGE_Height - SIZE_Window_Height) / 2;
         TGameUtil.setButtonMode(this.FScene.btn_fight,true);
         this.FScene.btn_fight.addEventListener(MouseEvent.CLICK,this.OnStartFight);
         TGameUtil.setButtonMode(this.FScene.btn_stop,true);
         this.FScene.btn_stop.addEventListener(MouseEvent.CLICK,this.OnStopFight);
         TGameUtil.setButtonMode(this.FScene.btn_fast,true);
         this.FScene.btn_fast.addEventListener(MouseEvent.CLICK,this.OnFastFight);
         TGameUtil.setButtonMode(this.FScene.btn_back,true);
         this.FScene.btn_back.addEventListener(MouseEvent.CLICK,this.OnReset);
         this.FScene.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCancel);
         TGameUtil.setButtonMode(this.FScene.btn_max,true);
         this.FScene.btn_max.addEventListener(MouseEvent.CLICK,this.OnMax);
         (this.FScene.tf_countInput as TextField).restrict = "0-9";
         this.FScene.tf_countInput.addEventListener(Event.CHANGE,this.OnInput);
         this.FMonsterScrollBar = new TScrollBar(this.FScene.ta_monsterInfo,100);
         this.FAutoScrollBar = new TScrollBar(this.FScene.ta_autoInfo,194);
         this.FWindowConfirmationStop = SUtilityOverLayer.UIWindowConfirmation;
         this.FWindowConfirmationFast = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
      }
      
      protected function Updata() : void
      {
         if(!this.FIsInit)
         {
            return;
         }
         this.FScene.tf_vipConfig.visible = false;
         this.FScene.btn_fight.visible = false;
         this.FScene.btn_stop.visible = false;
         this.FScene.btn_fast.visible = false;
         this.FScene.btn_back.visible = false;
         this.FScene.tf_bg.visible = false;
         this.FScene.btn_max.visible = false;
         this.FScene.tf_countInput.mouseEnabled = false;
         if(this.FStatus == AutoStatus_Open)
         {
            this.FScene.tf_vipConfig.visible = true;
            this.FScene.btn_fight.visible = true;
            this.FScene.tf_bg.visible = true;
            this.FScene.btn_max.visible = true;
            this.FScene.tf_countInput.mouseEnabled = true;
         }
         else if(this.FStatus == AutoStatus_Begin)
         {
            this.FScene.tf_vipConfig.visible = true;
            this.FScene.btn_stop.visible = true;
            this.FScene.btn_fast.visible = true;
         }
         else if(this.FStatus == AutoStatus_End)
         {
            this.FScene.btn_back.visible = true;
         }
         if(SParametersCore.IfBaiDuGame)
         {
            this.FScene.tf_vipConfig.visible = false;
         }
      }
      
      protected function Reset() : void
      {
         var _loc1_:TBlockPoint = null;
         var _loc2_:TOrgPointInfo = null;
         this.UpdataCampaignName();
         this.visible = true;
         if(this.FAutoScrollBar != null)
         {
            this.FAutoScrollBar.Clear();
         }
         if(this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo,this.FCurMissionID) as TOrgPointInfo;
            this.FMaxCount = Math.round(Math.floor(this.FCharacter.CreditMilitaryOrders / _loc2_.ActionEexertion));
            this.FMaxCount = Math.min(this.FMaxCount,SLogicsCore.NewOrgData.GetCurrentPointRemainFight());
         }
         else
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FCurMissionID) as TBlockPoint;
            this.FMaxCount = Math.max(0,Math.min(50,Math.floor(this.FCharacter.CreditMilitaryOrders / Math.max(1,_loc1_.Spirit))));
            this.FAutoInitTimer = 0;
         }
         this.FStatus = AutoStatus_Open;
         this.AutoCount = Math.min(AutoInitCount,this.FMaxCount);
         this.TotleTurn = 0;
         this.CurTurn = 0;
         this.TotleExp = 0;
         this.TotleMoney = 0;
         this.FIsFast = false;
         this.Updata();
      }
      
      protected function UpdataCampaignName() : void
      {
         var _loc1_:TBlockPoint = null;
         var _loc2_:TOrgPointInfo = null;
         var _loc3_:String = null;
         if(this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo,this.FCurMissionID) as TOrgPointInfo;
            _loc3_ = _loc2_.Name;
         }
         else
         {
            if(this.FBlockPointBins == null)
            {
               this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
            }
            _loc1_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FCurMissionID) as TBlockPoint;
            _loc3_ = _loc1_.Name.toString();
         }
         TextField(this.FScene.tf_title).mouseEnabled = false;
         this.FScene.tf_title.text = _loc3_;
      }
      
      protected function set AutoCount(param1:int) : void
      {
         this.FAutoCount = Math.max(0,Math.min(param1,this.FMaxCount,this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle ? 32767 : 50));
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_countInput))
         {
            this.FScene.tf_countInput.text = String(this.FAutoCount);
         }
         this.TotleTimer = this.FAutoInitTimer * this.FAutoCount;
      }
      
      protected function set TotleTimer(param1:int) : void
      {
         this.FTotleTimer = param1;
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_timer))
         {
            this.FScene.tf_timer.text = TUtilityTiming.fomatTime(this.FTotleTimer);
         }
      }
      
      protected function get TotleTimer() : int
      {
         return this.FTotleTimer;
      }
      
      protected function set TotleTurn(param1:int) : void
      {
         this.FTotleTurn = param1;
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_turn))
         {
            this.FScene.tf_turn.text = String(this.FCurTurn) + "/" + String(this.FTotleTurn);
         }
      }
      
      protected function set CurTurn(param1:int) : void
      {
         this.FCurTurn = param1;
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_turn))
         {
            this.FScene.tf_turn.text = String(this.FCurTurn) + "/" + String(this.FTotleTurn);
         }
      }
      
      protected function set TotleExp(param1:int) : void
      {
         this.FTotleExp = param1;
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_totleExp))
         {
            if(this.FTotleExp == 0)
            {
               this.FScene.tf_totleExp.text = String(this.FTotleExp);
            }
            else
            {
               this.FScene.tf_totleExp.text = String("+" + this.FTotleExp);
            }
         }
      }
      
      protected function get TotleExp() : int
      {
         return this.FTotleExp;
      }
      
      protected function set TotleMoney(param1:int) : void
      {
         this.FTotleMoney = param1;
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_totleMoney))
         {
            if(this.FTotleMoney == 0)
            {
               this.FScene.tf_totleMoney.text = String(this.FTotleMoney);
            }
            else
            {
               this.FScene.tf_totleMoney.text = String("+" + this.FTotleMoney);
            }
         }
      }
      
      protected function get TotleMoney() : int
      {
         return this.FTotleMoney;
      }
      
      protected function UpdataRunTimer() : void
      {
         --this.TotleTimer;
         if(this.TotleTimer <= 0)
         {
            clearInterval(this.FStartRunTimerID);
         }
      }
      
      protected function OnSureFastFight(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_GoldFastAutoBattle);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(CONST_BATTLE.BattleType_Nodal);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FIsFast = true;
      }
      
      protected function OnSureStop(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_StopAutoBattle);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(CONST_BATTLE.BattleType_Nodal);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         clearTimeout(this.FAutoUpdataUITimerID);
         this.FAutoUpdataUIStatus = false;
         this.FStatus = AutoStatus_End;
         this.Updata();
         this.TotleTimer = 0;
         clearInterval(this.FStartRunTimerID);
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_WORLDMAP;
      }
      
      protected function GetNodalAutoMonsterInfo(param1:uint, param2:int = 0) : TNodalAutoMonsterInfo
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TEnemyArmy = null;
         var _loc7_:TEnemy = null;
         var _loc8_:TBlockPoint = null;
         var _loc9_:TOrgPointInfo = null;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:Array = null;
         var _loc12_:Dictionary = null;
         var _loc13_:Dictionary = null;
         var _loc14_:uint = 0;
         var _loc15_:TMonster = null;
         var _loc16_:TConfigValue = null;
         var _loc17_:TNodalAutoMonsterInfo = null;
         var _loc18_:uint = 0;
         var _loc19_:String = null;
         if(this.FBlockPointBins == null)
         {
            this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         }
         if(this.FEnemyArmyBins == null)
         {
            this.FEnemyArmyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         }
         if(this.FEnemyBins == null)
         {
            this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         }
         if(this.FNodalAutoInfo != null && this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle)
         {
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo,this.FCurMissionID) as TOrgPointInfo;
            _loc11_ = _loc9_.Army.army;
            _loc18_ = _loc11_.length;
         }
         else
         {
            _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(param1) as TBlockPoint;
            _loc10_ = _loc8_.Armys;
            _loc18_ = _loc10_.length;
         }
         _loc17_ = new TNodalAutoMonsterInfo();
         _loc17_.HootMonster.length = 0;
         _loc17_.CurAutoMissionId = param1;
         _loc17_.CurAutoCityId = param2;
         _loc17_.CostTime = SingleAutoBattleTime;
         _loc12_ = new Dictionary(true);
         _loc13_ = new Dictionary(true);
         _loc3_ = 0;
         while(_loc3_ < _loc18_)
         {
            if(this.FNodalAutoInfo != null && this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle)
            {
               _loc5_ = uint(_loc11_[_loc3_]);
            }
            else
            {
               _loc5_ = _loc10_[_loc3_];
            }
            _loc6_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc5_) as TEnemyArmy;
            _loc4_ = 0;
            while(_loc4_ < _loc6_.EnemyIdVect.length)
            {
               _loc14_ = _loc6_.EnemyIdVect[_loc4_];
               _loc7_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc14_) as TEnemy;
               if(_loc12_[_loc14_] == null)
               {
                  _loc12_[_loc14_] = 1;
                  _loc13_[_loc14_] = _loc7_.Level;
               }
               else
               {
                  _loc12_[_loc14_] += 1;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         for(_loc19_ in _loc12_)
         {
            _loc15_ = this.FPoolCampaign.AcquireMonster(int(_loc19_));
            _loc15_.MonsterLevel = _loc13_[_loc19_];
            _loc15_.MonsterCount = _loc12_[_loc19_];
            _loc17_.HootMonster.push(_loc15_);
         }
         if(this.FNodalAutoInfo != null)
         {
            _loc17_.BattleType = this.FNodalAutoInfo.BattleType;
         }
         return _loc17_;
      }
      
      public function SetAutoBattleMonsterInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         var _loc4_:TMonster = null;
         var _loc5_:TEnemy = null;
         var _loc6_:uint = 0;
         var _loc3_:String = "";
         if(this.FMonsterScrollBar != null)
         {
            _loc6_ = uint(this.FMonsterScrollBar.Count);
            _loc1_ = 0;
            while(_loc1_ < _loc6_)
            {
               this.FFreeMonsterTextFieldVect.push(this.FMonsterScrollBar.Items[_loc1_]);
               _loc1_++;
            }
            this.FMonsterScrollBar.Clear();
            _loc1_ = 0;
            while(_loc1_ < this.FNodalAutoInfo.HootMonster.length)
            {
               _loc4_ = this.FNodalAutoInfo.HootMonster[_loc1_];
               if(this.FFreeMonsterTextFieldVect.length > 0)
               {
                  _loc2_ = this.FFreeMonsterTextFieldVect.pop();
               }
               else
               {
                  _loc2_ = new TextField();
                  _loc2_.mouseEnabled = false;
               }
               _loc5_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc4_.Identifier) as TEnemy;
               _loc3_ = _loc5_.Name;
               _loc2_.textColor = 16180909;
               _loc2_.filters = [MonstorTextFilter];
               if(false)
               {
                  _loc3_ += "\t\tLv." + _loc4_.MonsterLevel;
                  _loc3_ += "   x" + _loc4_.MonsterCount;
               }
               else
               {
                  _loc3_ += "    \tLv." + _loc4_.MonsterLevel;
                  _loc3_ += "    \tx" + _loc4_.MonsterCount;
               }
               _loc2_.text = _loc3_;
               _loc2_.width = _loc2_.textWidth + 10;
               _loc2_.height = _loc2_.textHeight + 3;
               this.FMonsterScrollBar.AddItem(_loc2_);
               _loc1_++;
            }
         }
         this.FScene.tf_totleExp.text = "0";
         this.FScene.tf_totleMoney.text = "0";
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_BATTLESENCE_AUTO;
      }
      
      protected function OnStartFight(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:TBlockPoint = null;
         var _loc6_:TOrgPointInfo = null;
         if(this.FStatus == AutoStatus_Begin)
         {
            return;
         }
         if(this.FAutoCount <= 0)
         {
            return;
         }
         if(this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo,this.FCurMissionID) as TOrgPointInfo;
            if(_loc6_ == null)
            {
               return;
            }
            _loc4_ = this.FAutoCount * _loc6_.ActionEexertion;
         }
         else
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FCurMissionID) as TBlockPoint;
            if(_loc5_ == null)
            {
               return;
            }
            _loc4_ = this.FAutoCount * _loc5_.Spirit;
         }
         if(this.FCharacter.CreditMilitaryOrders < _loc4_)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_01));
            }
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_AutoBattle);
         _loc3_ = _loc2_.Data;
         _loc3_.writeInt(this.FCurCityID);
         _loc3_.writeInt(this.FCurMissionID);
         _loc3_.writeShort(this.FAutoCount);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FAutoBattleResultCount = 1;
         this.FStartRunTimerID = setInterval(this.UpdataRunTimer,1000);
         this.FScene.tf_turn.text = "0/" + this.FAutoCount;
         this.FStatus = AutoStatus_Begin;
         this.Updata();
      }
      
      protected function OnStopFight(param1:MouseEvent) : void
      {
         if(this.FStatus != AutoStatus_Begin)
         {
            return;
         }
         if(this.FIsFast || this.FVipData.BlockTime)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_08));
            return;
         }
         this.FWindowConfirmationStop.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_06);
         this.FWindowConfirmationStop.OnOK = this.OnSureStop;
         this.FWindowConfirmationStop.Visible = true;
      }
      
      protected function OnFastFight(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.FIsFast || this.FVipData.BlockTime)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_08));
            return;
         }
         if(this.FNodalAutoBattleInfo.BattleResult.length > 0)
         {
            return;
         }
         _loc2_ = int((this.FTotleTimer - 1) / 60 + 1) * this.FAutoTimeGold;
         if(_loc2_ > this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.visible = true;
            return;
         }
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_07);
         this.FWindowConfirmationFast.Text = _loc3_.split("%count%").join(_loc2_);
         this.FWindowConfirmationFast.OnOK = this.OnSureFastFight;
         this.FWindowConfirmationFast.Visible = true;
      }
      
      protected function OnCancel(param1:MouseEvent) : void
      {
         if(this.FStatus == AutoStatus_Begin)
         {
            if(this.FIsFast || this.FVipData.BlockTime)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_08));
               return;
            }
            this.FWindowConfirmationStop.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_06);
            this.FWindowConfirmationStop.OnOK = this.OnSureStop;
            this.FWindowConfirmationStop.Visible = true;
         }
         else
         {
            this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_WORLDMAP;
            ProcessorClose();
         }
      }
      
      protected function OnReset(param1:MouseEvent) : void
      {
         this.Reset();
      }
      
      protected function OnMax(param1:MouseEvent) : void
      {
         this.AutoCount = this.FMaxCount;
      }
      
      protected function OnInput(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(this.FScene.tf_countInput.text);
         if(_loc2_ > this.FMaxCount)
         {
            this.AutoCount = this.FMaxCount;
         }
         else
         {
            this.AutoCount = Math.max(_loc2_,0);
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         if(param1 != null)
         {
            this.FContinueStream = param1;
         }
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FScene.visible = true;
         this.OpenWindow(this.FNodalAutoInfo);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FScene)
         {
            this.FScene.visible = false;
         }
         this.FIsContinue = false;
      }
      
      public function OpenWindow(param1:TNodalAutoMonsterInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc5_:TMonster = null;
         var _loc6_:TEnemy = null;
         var _loc7_:uint = 0;
         var _loc8_:TBlockPoint = null;
         var _loc9_:TOrgPointInfo = null;
         var _loc4_:String = "";
         if(param1 == null)
         {
            return;
         }
         this.FNodalAutoInfo = param1;
         this.FCurCityID = param1.CurAutoCityId;
         this.FCurMissionID = param1.CurAutoMissionId;
         if(this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle)
         {
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo,this.FCurMissionID) as TOrgPointInfo;
            this.FMaxCount = Math.round(Math.floor(this.FCharacter.CreditMilitaryOrders / _loc9_.ActionEexertion));
            this.FMaxCount = Math.min(this.FMaxCount,SLogicsCore.NewOrgData.GetCurrentPointRemainFight());
         }
         else
         {
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FCurMissionID) as TBlockPoint;
            this.FMaxCount = Math.max(0,Math.min(50,Math.floor(this.FCharacter.CreditMilitaryOrders / Math.max(1,_loc8_.Spirit))));
         }
         this.FAutoInitTimer = this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle ? this.FNodalAutoInfo.CostTime : 0;
         this.FIsFast = false;
         this.Reset();
         if(this.FAutoScrollBar != null)
         {
            _loc7_ = uint(this.FAutoScrollBar.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc7_)
            {
               this.FFreeAutoTurnUIVect.push(this.FAutoScrollBar.Items[_loc2_]);
               _loc2_++;
            }
            this.FAutoScrollBar.Clear();
         }
         if(this.FMonsterScrollBar != null)
         {
            _loc7_ = uint(this.FMonsterScrollBar.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc7_)
            {
               this.FFreeMonsterTextFieldVect.push(this.FMonsterScrollBar.Items[_loc2_]);
               _loc2_++;
            }
            this.FMonsterScrollBar.Clear();
            _loc2_ = 0;
            while(_loc2_ < this.FNodalAutoInfo.HootMonster.length)
            {
               _loc5_ = this.FNodalAutoInfo.HootMonster[_loc2_];
               if(this.FFreeMonsterTextFieldVect.length > 0)
               {
                  _loc3_ = this.FFreeMonsterTextFieldVect.pop();
               }
               else
               {
                  _loc3_ = new TextField();
                  _loc3_.mouseEnabled = false;
               }
               _loc6_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc5_.Identifier) as TEnemy;
               _loc4_ = _loc6_.Name;
               _loc3_.textColor = 16180909;
               _loc3_.filters = [MonstorTextFilter];
               if(false)
               {
                  _loc4_ += "\t\tLv." + _loc5_.MonsterLevel;
                  _loc4_ = _loc4_ + ("   x" + _loc5_.MonsterCount);
               }
               else
               {
                  _loc4_ += "    \tLv." + _loc5_.MonsterLevel;
                  _loc4_ = _loc4_ + ("    \tx" + _loc5_.MonsterCount);
               }
               _loc3_.text = _loc4_;
               _loc3_.width = _loc3_.textWidth + 10;
               _loc3_.height = _loc3_.textHeight + 3;
               this.FMonsterScrollBar.AddItem(_loc3_);
               _loc2_++;
            }
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_BATTLESENCE_AUTO;
      }
      
      public function PacketPerform_SC_AutoBattleInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         if(_loc2_.position == 0 && _loc2_.readUnsignedInt() != 0)
         {
            clearInterval(this.FStartRunTimerID);
            clearTimeout(this.FAutoUpdataUITimerID);
            this.FAutoUpdataUIStatus = false;
            this.FNodalAutoBattleInfo.BattleResult.length = 0;
            this.FStatus = AutoStatus_Open;
            this.TotleTimer = 0;
            this.Updata();
            return;
         }
         this.FNodalAutoBattleInfo.BattleResult.length = 0;
         this.FStatus = AutoStatus_Begin;
         this.UnstreamizerAutoBattleInfo.Unstreamize(_loc2_,this.FNodalAutoBattleInfo,null);
         this.Updata();
         this.TotleTimer = Math.max(0,this.FNodalAutoBattleInfo.CostTimer);
         if(this.FNodalAutoInfo.BattleType != CONST_BATTLE.BattleType_OrgSingle && this.TotleTimer == 0)
         {
            clearInterval(this.FStartRunTimerID);
            this.FAutoCount = this.FNodalAutoBattleInfo.BattleResult.length;
            while(this.FNodalAutoBattleInfo.BattleResult.length > 0)
            {
               this.UpdataAutoUI();
            }
            this.FStatus = AutoStatus_End;
            this.Updata();
            return;
         }
         if(!this.FAutoUpdataUIStatus)
         {
            this.FAutoUpdataUITimerID = setTimeout(this.UpdataAutoUI,UPDATA_TIMESTAMP);
         }
      }
      
      public function ContinueAutoBattleCount(param1:int, param2:uint, param3:Boolean, param4:int, param5:int) : void
      {
         this.FIsContinue = true;
         this.FContinueAutoCount = param1;
         this.FContinueStartTime = param2;
         this.FCurMissionID = param4;
         this.FCurCityID = param5;
         this.FIsFast = param3;
         this.FNodalAutoInfo = this.GetNodalAutoMonsterInfo(this.FCurMissionID,this.FCurCityID);
         this.OpenWindow(this.FNodalAutoInfo);
         this.TotleTurn = this.FContinueAutoCount;
         this.AutoCount = this.FContinueAutoCount;
         this.TotleTimer -= STimingCore.ServerTick - this.FContinueStartTime;
         this.UpdataCampaignName();
         this.FStatus = AutoStatus_Begin;
         this.Updata();
         this.FStartRunTimerID = setInterval(this.UpdataRunTimer,1000);
      }
      
      public function ContinueAutoBattle(param1:ByteArray) : void
      {
         this.UnstreamizerAutoBattleInfo.Unstreamize(param1,this.FNodalAutoBattleInfo,null);
         if(!this.FAutoUpdataUIStatus)
         {
            this.FAutoUpdataUITimerID = setTimeout(this.UpdataAutoUI,UPDATA_TIMESTAMP);
         }
      }
      
      public function UpData(param1:TNodalAutoMonsterInfo) : void
      {
         this.FNodalAutoInfo = param1;
      }
   }
}

