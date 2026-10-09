package Processors.Game.Lobby.CityDefend
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Characters.MoveRole.*;
   import Logics.ChatOptions.*;
   import Logics.CityDefend.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.CityDefend.*;
   import Processors.Game.Battle.TBattleHandle;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.MainScene.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.TUtilityTiming;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorCityDefend extends TProcessorLobbyPlate
   {
      
      public static var FightReadyAt:uint = 0;
      public static var FightPending:Boolean = false;
      public static var StageTransition:Boolean = false;
      protected var FDeferredHp:Number = NaN;
      protected var FDeferredEnd:Boolean = false;
      protected var FQueuedStatus:TPacket = null;
      protected var FAtDoorReady:Boolean = false;
      protected static const TYPE_Defend:uint = 0;
      
      protected static const TYPE_Attack:uint = 1;
      
      protected static const Door_X:Vector.<Number> = Vector.<Number>([1176,1179]);
      
      protected static const Door_Y:Vector.<Number> = Vector.<Number>([469,469]);
      
      protected static const UnselectedIndex:int = 1;
      
      protected static const SelectedIndex:int = 2;
      
      protected var MAX_ROLECOUNT:uint;
      
      protected var FBackGround:TLayerBackGround;
      
      protected var FCanMove:TLayerCanMove;
      
      protected var FLayerLittleScript:TLayerLittleScript;
      
      protected var FMainRole:TUIRoleCanMovePlayerRoleMainRole;
      
      protected var FCityDefendData:TCityDefendData;
      
      protected var FUnstreamizerCityDefend:TUnstreamizerCityDefend;
      
      protected var FScene:MovieClip;
      
      protected var FDoor:MovieClip;
      
      protected var FProcessorWindowCityDefned:TProcessorWindowCityDefned;
      
      protected var FProcessorWindowDoorHeroList:TProcessorWindowDoorHeroList;
      
      protected var FProcessorWindowCountdown:TProcessorWindowCountdown;
      
      protected var FProcessorWindowResurrection:TProcessorWindowResurrection;
      
      protected var FWindowConfirmationTurnBack:TUIWindowConfirmation;
      
      protected var FOutCityId:uint;
      
      protected var FInCityId:uint;
      
      protected var FDieTime:uint;
      
      protected var FOverTime:Vector.<uint>;
      
      protected var FOutMonsterId:uint;
      
      protected var FInMonsterId:uint;
      
      protected var FCost:int;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsArriveTarget:Boolean;
      
      protected var FConfigValueBins:TBins;
      
      protected var FDoorPos_X:Number;
      
      protected var FDoorPos_Y:Number;
      
      protected var FBattleBack:Boolean;
      
      protected var FReviveCost:Object;
      
      protected var FAutoRun:Boolean;
      
      protected var FAutoBattle:Boolean;
      
      protected var FIfCanAutoRun:Boolean;
      
      protected var FIfCanAutoBattle:Boolean;
      
      protected var FSPAutoRun:Sprite;
      
      protected var FAutoRunSelectBox:MovieClip;
      
      protected var FSPAutoBattle:Sprite;
      
      protected var FAutoBattleSelectBox:MovieClip;
      
      protected var FHint:THint;
      
      protected var FFighting:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetDailyActivityStatus:Function;
      
      protected var FOnUnLoadBattleResources:Function;
      
      public function TProcessorCityDefend(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FBackGround = new TLayerBackGround(this);
         this.FBackGround.OnLoadCompleted = this.ProcessorResourcesOnLoadCompleted;
         this.FBackGround.IsNeedSmallPic = false;
         this.FBackGround.Visible = true;
         this.FCanMove = new TLayerCanMove(this.FBackGround);
         this.FCanMove.NeedInitPos = false;
         this.FCanMove.Visible = false;
         this.FLayerLittleScript = new TLayerLittleScript(this);
         this.FLayerLittleScript.MouseEventObject = this.FBackGround;
         this.FLayerLittleScript.ChangeRolePositionByMouse = this.OnMoveByMouse;
         this.FLayerLittleScript.LongClickMove = false;
         this.FLayerLittleScript.Visible = true;
         this.FCityDefendData = new TCityDefendData();
         this.FUnstreamizerCityDefend = new TUnstreamizerCityDefend();
         this.FBattleBack = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_CITYDEFEND.RESOURCE_CityDefend);
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
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_CITYDEFEND.RESOURCE_ClassName_MC_CityDefend) as MovieClip;
         this.FDoor = TUtilityReflection.CreateDisplayObjectInstance(CONST_CITYDEFEND.RESOURCE_ClassName_MC_Door) as MovieClip;
         addChild(this.FDoor);
         TGameUtil.setButtonMode(this.FDoor,true);
         this.FDoor.addEventListener(MouseEvent.CLICK,this.OnDoorClick);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CityDefend_Defend_Cleargold) as TConfigValue;
         this.FCost = _loc1_.Value as uint;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CityDefend_Defend_Allman) as TConfigValue;
         this.MAX_ROLECOUNT = _loc1_.Value as uint;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CityDefend_Defend_ReviveCost) as TConfigValue;
         this.FReviveCost = _loc1_.Value as Object;
         this.FProcessorWindowDoorHeroList = new TProcessorWindowDoorHeroList(this);
         this.FProcessorWindowDoorHeroList.OnEffectText = EffectGenerateText;
         this.FProcessorWindowDoorHeroList.OnSetBattleStatus = this.FOnSetBattleStatus;
         this.FProcessorWindowDoorHeroList.SetScene(this.FScene.mc_heroList);
         this.FProcessorWindowDoorHeroList.InitUI(this.FCityDefendData);
         this.FProcessorWindowDoorHeroList.Visible = false;
         this.FProcessorWindowCountdown = new TProcessorWindowCountdown(this);
         this.FProcessorWindowCountdown.OnColdDown = this.TryToMove;
         this.FProcessorWindowCountdown.SetScene(this.FScene.mc_Countdown);
         this.FProcessorWindowCountdown.Visible = false;
         this.FProcessorWindowResurrection = new TProcessorWindowResurrection(this);
         this.FProcessorWindowResurrection.OnEffectText = EffectGenerateText;
         this.FProcessorWindowResurrection.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowResurrection.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowResurrection.ShowBack = this.OnShowBack;
         this.FProcessorWindowResurrection.OnResurrection = this.OnResurrection;
         this.FProcessorWindowResurrection.SetScene(this.FScene.mc_Resurrection);
         this.FProcessorWindowResurrection.Visible = false;
         this.FProcessorWindowCityDefned = new TProcessorWindowCityDefned(this);
         this.FProcessorWindowCityDefned.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowCityDefned.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowCityDefned.HelpHintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowCityDefned.HelpHintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowCityDefned.SetScene(this.FScene);
         this.FProcessorWindowCityDefned.InitUI(this.FCityDefendData);
         this.FSPAutoRun = this.FScene["AutoRun"];
         if(this.FSPAutoRun != null)
         {
            this.FSPAutoRun.addEventListener(MouseEvent.MOUSE_MOVE,this.SPAutoRunOnMove);
            this.FSPAutoRun.addEventListener(MouseEvent.MOUSE_OUT,this.OnSPOut);
            this.FAutoRunSelectBox = this.FSPAutoRun["task"];
            this.FAutoRunSelectBox.addEventListener(MouseEvent.CLICK,this.OnAutoRunClick);
            this.FSPAutoBattle = this.FScene["AutoFight"];
            this.FSPAutoBattle.addEventListener(MouseEvent.MOUSE_MOVE,this.SPAutoBattleOnMove);
            this.FSPAutoBattle.addEventListener(MouseEvent.MOUSE_OUT,this.OnSPOut);
            this.FAutoBattleSelectBox = this.FSPAutoBattle["task"];
            this.FAutoBattleSelectBox.addEventListener(MouseEvent.CLICK,this.OnAutoBattleClick);
            this.FIfCanAutoRun = SLogicsCore.Character.VipData.CanAutoFight;
            this.FIfCanAutoBattle = SLogicsCore.Character.VipData.ArenaSkip;
            this.FAutoRun = this.FIfCanAutoRun;
            this.FAutoBattle = this.FIfCanAutoBattle;
            this.SetSelectBoxState(this.FAutoRunSelectBox,this.FAutoRun);
            this.SetSelectBoxState(this.FAutoBattleSelectBox,this.FAutoBattle);
         }
         this.FHint = new THint();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_FightRet,this.PacketPerform_SC_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_ReviveRet,this.PacketPerform_SC_ReviveRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_UpdataRank,this.PacketPerform_SC_UpdataRank);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_UpdataDoorHp,this.PacketPerform_SC_UpdataDoorHp);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_UpdataHeros,this.PacketPerform_SC_UpdataHeros);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_UpdataHeroStatus,this.PacketPerform_SC_UpdataHeroStatus);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_UpdataReport,this.PacketPerform_SC_UpdataReport);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CityDefend_BattleEnd,this.PacketPerform_SC_BattleEnd);
      }
      
      protected function PacketPerform_SC_Enter_CityDefend(param1:ByteArray) : void
      {
         var _loc2_:Date = null;
         var _loc3_:uint = 0;
         var _loc4_:TEnemy = null;
         var _loc5_:TConfigValue = null;
         this.FCityDefendData.OrganizationRank.Clear();
         this.FCityDefendData.HeroRank.Clear();
         this.FUnstreamizerCityDefend.Unstreamize(param1,this.FCityDefendData,null);
         this.FConfigValueBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc5_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.CityDefend_Defend_Outcityid) as TConfigValue;
         this.FOutCityId = _loc5_.Value as int;
         _loc5_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.CityDefend_Defend_Incityid) as TConfigValue;
         this.FInCityId = _loc5_.Value as int;
         _loc5_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.CityDefend_Defend_Deathtime) as TConfigValue;
         this.FDieTime = _loc5_.Value as int;
         _loc5_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.CityDefend_Defend_Overtime) as TConfigValue;
         this.FOverTime = _loc5_.Value as Vector.<uint>;
         _loc5_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.CityDefend_Defend_OutMonsterId) as TConfigValue;
         this.FOutMonsterId = _loc5_.Value as uint;
         _loc5_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.CityDefend_Defend_InMonsterId) as TConfigValue;
         this.FInMonsterId = _loc5_.Value as uint;
         _loc2_ = new Date(STimingCore.ServerTick * 1000);
         _loc2_.hours = this.FOverTime[0];
         _loc2_.minutes = this.FOverTime[1];
         _loc2_.seconds = 0;
         this.FCityDefendData.ActivityColdDown = STimingCore.ServerTick + 86400;
         StageTransition = false;
         FightPending = false;
         this.FDeferredHp = NaN;
         this.FDeferredEnd = false;
         this.FQueuedStatus = null;
         this.FCityDefendData.ReportList.Clear();
         this.FAtDoorReady = false;
         this.FCityDefendData.OrganizationBuffLevel = SLogicsCore.Organization.GetOrgActivityLevelByType(CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEGUARD);
         if(this.FCityDefendData.CityDoorIndex == 0)
         {
            this.FCityDefendData.DefendBuffLevel = 0;
            _loc3_ = this.FOutMonsterId + this.FCityDefendData.WorldLevel;
            this.ChangeSceneId(this.FOutCityId);
         }
         else
         {
            this.FCityDefendData.DefendBuffLevel = 1;
            _loc3_ = this.FInMonsterId + this.FCityDefendData.WorldLevel;
            this.ChangeSceneId(this.FInCityId);
         }
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,_loc3_) as TEnemy;
         this.FCityDefendData.CityDoorTotleHp = _loc4_.Hp;
      }
      
      protected function PacketPerform_SC_FightRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         FightPending = false;
         if(_loc2_.bytesAvailable >= 4) FightReadyAt = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            this.FFighting = false;
            if(STimingCore.ServerTick >= FightReadyAt)
            {
               this.FAutoRun = false;
               if(this.FAutoRunSelectBox != null) this.SetSelectBoxState(this.FAutoRunSelectBox,false);
            }
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(TBattleHandle.IsInBattle)
         {
            return;
         }
         TBattleHandle.AutoCloseBattle(this.FAutoBattle);
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_CityDefend,CONST_MUSIC.ID_SCENE_CityDefend);
         }
         if(this.FOnInitBattle != null)
         {
            try
            {
               this.FOnInitBattle(this);
               // The report reader rejects packets while IsInBattle is true.
               // TBattleHandle sets it only after accepting the CityDefend report.
               TBattleHandle.IsInBattle = false;
               FightPending = true;
            }
            catch(error:Error)
            {
               TBattleHandle.IsInBattle = false;
               this.FFighting = false;
               EffectGenerateText(error.message);
            }
         }
      }
      
      protected function PacketPerform_SC_ReviveRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowResurrection.ResurrectionOk();
         ++this.FCityDefendData.BuyCount;
         this.TryToMove(this);
      }
      
      protected function PacketPerform_SC_UpdataRank(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FCityDefendData.OrganizationRank.Clear();
         this.FCityDefendData.HeroRank.Clear();
         this.FUnstreamizerCityDefend.UnstreamizeCityDefendOrganizationRank(_loc2_,this.FCityDefendData.OrganizationRank,null);
         this.FUnstreamizerCityDefend.UnstreamizeCityDefendHeroRank(_loc2_,this.FCityDefendData.HeroRank,null);
         if(this.FProcessorWindowCityDefned)
         {
            this.FProcessorWindowCityDefned.UpdataRankUI();
         }
      }
      
      protected function PacketPerform_SC_UpdataDoorHp(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         var hp:Number = _loc2_.readFloat();
         if(TBattleHandle.IsInBattle)
         {
            this.FDeferredHp = hp;
            if(hp <= 0) StageTransition = true;
            return;
         }
         this.ApplyDoorHp(hp);
      }

      protected function ApplyDoorHp(hp:Number) : void
      {
         this.FCityDefendData.CityDoorCurHp = hp;
         if(this.FProcessorWindowCityDefned)
         {
            this.FProcessorWindowCityDefned.UpdataDoorHp();
         }
         if(this.FCityDefendData.CityDoorCurHp <= 0)
         {
            if(this.FCityDefendData.CityDoorIndex == 0)
            {
               this.FProcessorWindowCountdown.StartCountdown(STimingCore.ServerTick + 10);
               setTimeout(this.OnEnterNextCity,10000);
               this.FProcessorWindowResurrection.ResurrectionOk();
            }
         }
      }
      
      protected function PacketPerform_SC_UpdataHeros(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:TCityDefendHero = null;
         var _loc7_:TRoleCanControl = null;
         var _loc8_:TKnifeExpand = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = _loc2_.readByte();
         if(_loc5_ < 0)
         {
            this.FCityDefendData.HeroList.Dec(_loc3_,_loc4_);
            this.FCityDefendData.DoorHeroList.Dec(_loc3_,_loc4_);
            this.FCanMove.PlayerRemove(_loc3_,_loc4_);
         }
         else
         {
            _loc6_ = SLogicsCore.PoolCityDefend.AcquireCityDefendHero(_loc3_,_loc4_);
            this.FCityDefendData.HeroList.Add(_loc6_);
            _loc6_.Status = _loc5_;
            _loc6_.UserName = TUtilityString.FetchUTF(_loc2_);
            _loc6_.Quality = _loc2_.readUnsignedByte();
            _loc6_.MilitaryRank = _loc2_.readUnsignedInt();
            _loc6_.PetStatus = Boolean(_loc2_.readUnsignedByte() == 0);
            _loc6_.PetModelId = _loc2_.readUnsignedInt();
            _loc6_.RoleTemplateId = _loc2_.readUnsignedInt();
            _loc6_.UserType = _loc2_.readUnsignedByte();
            _loc6_.UserLevel = _loc2_.readUnsignedShort();
            _loc2_.readInt();
            _loc6_.UserRebirthNum = _loc2_.readUnsignedByte();
            if(_loc6_.Identifier0 == this.FCharacter.Identifier0 && _loc6_.Identifier1 == this.FCharacter.Identifier1)
            {
               return;
            }
            if(this.FCityDefendData.CityDefendType == TYPE_Attack && this.FCanMove.RoleCount >= this.MAX_ROLECOUNT)
            {
               return;
            }
            _loc7_ = SLogicsCore.PoolUIRoleCanMove.AcquireRoleCanControl(_loc3_,_loc4_);
            _loc7_.RoleName = _loc6_.UserName;
            _loc7_.MilitaryRank = _loc6_.MilitaryRank;
            _loc7_.RelexBoo = _loc6_.PetStatus;
            _loc7_.TextureID = _loc6_.PetModelId;
            _loc7_.RoleTemplateID = _loc6_.RoleTemplateId;
            _loc7_.Quality = _loc6_.Quality;
            _loc7_.RebirthNum = _loc6_.UserRebirthNum;
            if(_loc7_.TextureID != 0)
            {
               _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,_loc7_.TextureID) as TKnifeExpand;
               _loc7_.TextureID = _loc8_.RelationID;
            }
            if(_loc6_.UserType == TYPE_Defend)
            {
               _loc7_.MapX = 2150 + Math.random() * 50;
               _loc7_.MapY = 450 + Math.random() * 40;
            }
            else
            {
               _loc7_.MapX = 100 + Math.random() * 200;
               _loc7_.MapY = 400 + Math.random() * 200;
            }
            this.FCanMove.PlayerAdd(_loc7_);
         }
         if(this.FProcessorWindowDoorHeroList)
         {
            this.FProcessorWindowDoorHeroList.UpdataDoorHeroList();
         }
      }
      
      protected function PacketPerform_SC_UpdataHeroStatus(param1:TPacket) : void
      {
         if(TBattleHandle.IsInBattle)
         {
            var copy:ByteArray = new ByteArray();
            copy.writeBytes(param1.Data,param1.Data.position,param1.Data.bytesAvailable);
            copy.position = 0;
            this.FQueuedStatus = new TPacket(param1.Identifier,copy);
            return;
         }
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TCityDefendHero = null;
         var _loc8_:TCityDefendHero = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = uint(_loc2_.readByte());
         var deadUntil:uint = 0;
         if(_loc2_.bytesAvailable >= 8)
         {
            deadUntil = _loc2_.readUnsignedInt();
            FightReadyAt = _loc2_.readUnsignedInt();
         }
         if(_loc3_ == this.FCharacter.Identifier0 && this.FCharacter.Identifier1 == _loc4_)
         {
            this.FAtDoorReady = _loc5_ == 1;
            if(_loc5_ == 0)
            {
               if(this.FCityDefendData.CityDefendType == TYPE_Defend)
               {
                  this.FMainRole.MapX = 2150 + Math.random() * 50;
                  this.FMainRole.MapY = 450 + Math.random() * 40;
               }
               else
               {
                  this.FMainRole.MapX = 100 + Math.random() * 200;
                  this.FMainRole.MapY = 400 + Math.random() * 200;
               }
               this.FProcessorWindowResurrection.StartCountdown(deadUntil > STimingCore.ServerTick ? deadUntil : STimingCore.ServerTick + this.FDieTime,this.FCost * this.GetRate());
               this.FProcessorWindowDoorHeroList.Visible = false;
            }
         }
         else
         {
            _loc7_ = this.FCityDefendData.HeroList.GetHeroById(_loc3_,_loc4_);
            _loc6_ = _loc7_.Status;
            _loc7_.Status = _loc5_;
            if(_loc5_ == 0)
            {
               if(_loc7_.UserType == TYPE_Defend)
               {
                  this.FCanMove.PlayerMove(_loc3_,_loc4_,2150 + Math.random() * 50,450 + Math.random() * 40);
               }
               else
               {
                  this.FCanMove.PlayerMove(_loc3_,_loc4_,100 + Math.random() * 200,400 + Math.random() * 200);
               }
               this.FCityDefendData.DoorHeroList.Dec(_loc3_,_loc4_);
            }
            else
            {
               if(_loc6_ == 0)
               {
                  if(_loc7_.UserType == TYPE_Defend)
                  {
                     this.FCanMove.PlayerMove(_loc3_,_loc4_,this.FDoorPos_X + 600,this.FDoorPos_Y - 30 + Math.random() * 50);
                  }
                  else
                  {
                     this.FCanMove.PlayerMove(_loc3_,_loc4_,this.FDoorPos_X - 90 + Math.random() * 20,this.FDoorPos_Y - 30 + Math.random() * 50);
                  }
               }
               if(_loc6_ != 1 && _loc5_ == 1)
               {
                  _loc8_ = this.FCityDefendData.DoorHeroList.GetHeroById(_loc3_,_loc4_);
                  if(_loc8_ == null && _loc7_.UserType != this.FCityDefendData.CityDefendType)
                  {
                     _loc8_ = SLogicsCore.PoolCityDefend.AcquireCityDefendHero(_loc3_,_loc4_);
                     this.FCityDefendData.DoorHeroList.Add(_loc8_);
                     _loc8_.UserName = _loc7_.UserName;
                     _loc8_.UserLevel = _loc7_.UserLevel;
                     _loc8_.UserRebirthNum = _loc7_.UserRebirthNum;
                  }
               }
               else if(_loc5_ == 2)
               {
                  this.FCityDefendData.DoorHeroList.Dec(_loc3_,_loc4_);
               }
            }
         }
         if(this.FProcessorWindowDoorHeroList)
         {
            this.FProcessorWindowDoorHeroList.UpdataDoorHeroList();
            if(this.FAutoRun && this.FCityDefendData.CityDefendType != TYPE_Defend)
            {
               this.FProcessorWindowDoorHeroList.Visible = false;
            }
            if(this.FAutoRun && !this.FFighting && _loc5_ == 1 && !FightPending && !StageTransition && STimingCore.ServerTick >= FightReadyAt && this.FCityDefendData.CityDefendType != TYPE_Defend)
            {
               this.FProcessorWindowDoorHeroList.OnFightHeroAuto();
               this.FFighting = true;
            }
         }
      }
      
      protected function PacketPerform_SC_UpdataReport(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerCityDefend.UnstreamizeCityDefendReport(_loc2_,this.FCityDefendData.ReportList,null);
         this.FProcessorWindowCityDefned.UpdataReportUI();
      }
      
      protected function PacketPerform_SC_BattleEnd(param1:TPacket) : void
      {
         StageTransition = true;
         if(TBattleHandle.IsInBattle)
         {
            this.FDeferredEnd = true;
            return;
         }
         this.FinishRound();
      }

      protected function FinishRound() : void
      {
         this.FDeferredEnd = false;
         if(this.FProcessorWindowCountdown != null)
         {
            this.FProcessorWindowCountdown.StartCountdown(STimingCore.ServerTick + 5);
            setTimeout(this.EnterCityScene,5000);
            this.FProcessorWindowResurrection.Stop();
         }
      }

      protected function GetRate() : int
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         _loc2_ = 10000;
         for(_loc1_ in this.FReviveCost)
         {
            if(int(_loc1_) > this.FCityDefendData.BuyCount)
            {
               _loc2_ = Math.min(_loc2_,int(_loc1_));
            }
         }
         return this.FReviveCost[String(_loc2_)];
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_CITYDEFEND)
         {
            if(!TBattleHandle.IsInBattle)
            {
               if(!isNaN(this.FDeferredHp))
               {
                  var hp:Number = this.FDeferredHp;
                  this.FDeferredHp = NaN;
                  this.ApplyDoorHp(hp);
               }
               if(this.FQueuedStatus != null)
               {
                  var packet:TPacket = this.FQueuedStatus;
                  this.FQueuedStatus = null;
                  if(!StageTransition) this.PacketPerform_SC_UpdataHeroStatus(packet);
               }
               if(this.FDeferredEnd) this.FinishRound();
            }
            this.FBackGround.Update();
            this.FCanMove.Update();
            this.LogicsPerform_Timer();
            this.LogicsPerform_DoorPos();
            this.LogicsPerform_MainRoleMove();
            this.LogicsPerform_ReliveTime();
            if(this.FAutoRun && this.FAtDoorReady && !StageTransition && !FightPending && !TBattleHandle.IsInBattle && STimingCore.ServerTick >= FightReadyAt && !this.FProcessorWindowResurrection.Visible)
            {
               this.FProcessorWindowDoorHeroList.OnFightHeroAuto();
            }
         }
      }
      
      protected function LogicsPerform_Timer() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         if(this.FScene != null)
         {
            _loc1_ = this.FCityDefendData.ActivityColdDown - STimingCore.ServerTick;
            _loc2_ = TUtilityTiming.fomatTime(_loc1_);
            this.FScene.tf_time.text = "24/7";
         }
      }
      
      protected function LogicsPerform_DoorPos() : void
      {
         if(this.FDoor == null)
         {
            return;
         }
         this.FDoor.x = Door_X[this.FCityDefendData.CityDoorIndex] - SLogicsCore.ScreenMapX;
      }
      
      protected function LogicsPerform_ReliveTime() : void
      {
      }
      
      protected function LogicsPerform_MainRoleMove() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.FMainRole == null || !this.FIsArriveTarget)
         {
            return;
         }
         if(this.FCityDefendData.CityDefendType == TYPE_Defend)
         {
            if(this.FMainRole.MapX < 1700)
            {
               this.FMainRole.StopMove();
               this.OnMainRoleArriveTarget();
               this.OnDoorClick();
            }
         }
         else
         {
            _loc1_ = 0.62;
            _loc2_ = Door_X[this.FCityDefendData.CityDoorIndex] - 50;
            _loc3_ = Door_Y[this.FCityDefendData.CityDoorIndex];
            _loc4_ = _loc1_ * (this.FMainRole.MapX - _loc2_) + _loc3_;
            if(_loc4_ > this.FMainRole.MapY)
            {
               this.FMainRole.StopMove();
               this.OnMainRoleArriveTarget();
               this.OnDoorClick();
            }
         }
      }
      
      protected function ProcessorResourcesOnLoadCompleted(param1:Object) : void
      {
         this.FCanMove.visible = true;
      }
      
      protected function ChangeSceneId(param1:uint) : void
      {
         this.FCanMove.visible = true;
         this.FBackGround.SwitchScene(param1);
      }
      
      protected function CreateMainRole() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TRoleCanControl = null;
         var _loc3_:TUIRoleCanMovePet = null;
         if(this.FMainRole != null)
         {
            this.UpdatePet();
            return;
         }
         _loc2_ = SLogicsCore.PoolUIRoleCanMove.AcquireRoleCanControl(0,0);
         _loc1_ = this.FCharacter.GetMainHero();
         _loc2_.RoleName = _loc1_.Name;
         _loc2_.RoleTemplateID = _loc1_.Identifier;
         _loc2_.MilitaryRank = this.FCharacter.MilitaryRank;
         _loc2_.RebirthNum = _loc1_.RebirthNum;
         this.FMainRole = new TUIRoleCanMovePlayerRoleMainRole(this.FCanMove);
         this.FMainRole.RoleData = _loc2_;
         this.FMainRole.TemplateID = _loc2_.RoleTemplateID;
         this.FMainRole.ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         this.FMainRole.OnArriveTarget = this.OnMainRoleArriveTarget;
         this.FMainRole.Init();
         this.ChangeMainHeroQuality();
         _loc3_ = new TUIRoleCanMovePet(this.FCanMove);
         _loc3_.FollowRole = this.FMainRole;
         this.FMainRole.Pet = _loc3_;
         _loc3_.TemplateID = SLogicsCore.Character.KnifeSoul.CurrentModuleID;
         _loc3_.visible = SLogicsCore.Character.KnifeSoul.IfFight;
         _loc3_.Init();
         this.FCanMove.InitNewRole(this.FMainRole);
         this.FCanMove.MainRole = this.FMainRole;
         this.FBackGround.ScreenRole = this.FMainRole;
         this.FLayerLittleScript.MainRole = this.FMainRole;
      }
      
      protected function EnterCityDefend() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TRoleCanControl = null;
         var _loc3_:TCityDefendHero = null;
         this.FProcessorWindowCityDefned.UpdataRankUI();
         this.FProcessorWindowCityDefned.UpdataReportUI();
         this.FProcessorWindowCityDefned.UpdataDoorHp();
         this.FProcessorWindowDoorHeroList.Visible = false;
         this.FProcessorWindowDoorHeroList.UpdataDoorHeroList();
         this.FProcessorWindowCountdown.StartCountdown(this.FCityDefendData.BeferStartColdDown);
         this.FProcessorWindowResurrection.Stop();
         this.FDoor.x = Door_X[this.FCityDefendData.CityDoorIndex];
         this.FDoor.y = Door_Y[this.FCityDefendData.CityDoorIndex];
         if(this.FCityDefendData.CityDefendType == TYPE_Defend)
         {
            this.FMainRole.MapX = 2150 + Math.random() * 50;
            this.FMainRole.MapY = 450 + Math.random() * 40;
         }
         else
         {
            this.FMainRole.MapX = 100 + Math.random() * 200;
            this.FMainRole.MapY = 400 + Math.random() * 200;
         }
         this.FMainRole.Pet.MapX = this.FMainRole.MapX;
         --this.FMainRole.MapY;
         this.FDoorPos_X = Door_X[this.FCityDefendData.CityDoorIndex];
         this.FDoorPos_Y = Door_Y[this.FCityDefendData.CityDoorIndex];
         _loc1_ = 0;
         while(_loc1_ < this.FCityDefendData.HeroList.Count)
         {
            _loc3_ = this.FCityDefendData.HeroList.GetHeroByIndex(_loc1_);
            if(!(_loc3_.Identifier0 == this.FCharacter.Identifier0 && _loc3_.Identifier1 == this.FCharacter.Identifier1))
            {
               if(this.FCityDefendData.CityDefendType == TYPE_Attack && this.FCanMove.RoleCount >= this.MAX_ROLECOUNT)
               {
                  return;
               }
               _loc2_ = SLogicsCore.PoolUIRoleCanMove.AcquireRoleCanControl(_loc3_.Identifier0,_loc3_.Identifier1);
               _loc2_.RoleName = _loc3_.UserName;
               _loc2_.MilitaryRank = _loc3_.MilitaryRank;
               _loc2_.RelexBoo = _loc3_.PetStatus;
               _loc2_.TextureID = _loc3_.PetModelId;
               _loc2_.RoleTemplateID = _loc3_.RoleTemplateId;
               _loc2_.Quality = _loc3_.Quality;
               _loc2_.RebirthNum = _loc3_.UserRebirthNum;
               if(_loc3_.UserType == TYPE_Defend)
               {
                  if(_loc3_.Status == 1 || _loc3_.Status == 2)
                  {
                     _loc2_.MapX = this.FDoorPos_X + 600;
                     _loc2_.MapY = this.FDoorPos_Y - 30 + Math.random() * 50;
                  }
                  else
                  {
                     _loc2_.MapX = 2150 + Math.random() * 50;
                     _loc2_.MapY = 450 + Math.random() * 40;
                  }
               }
               else if(_loc3_.Status == 1 || _loc3_.Status == 2)
               {
                  _loc2_.MapX = this.FDoorPos_X - 90 + Math.random() * 20;
                  _loc2_.MapY = this.FDoorPos_Y - 30 + Math.random() * 50;
               }
               else
               {
                  _loc2_.MapX = 100 + Math.random() * 200;
                  _loc2_.MapY = 400 + Math.random() * 200;
               }
               this.FCanMove.PlayerAdd(_loc2_);
            }
            _loc1_++;
         }
         this.OnShowBack(this,false);
      }
      
      protected function OnResurrection(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CityDefend_ReviveReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function EnterCityScene(param1:Object = null) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
         this.FCanMove.ClearAllRole();
         if(this.FOnUnLoadBattleResources != null)
         {
            this.FOnUnLoadBattleResources(this,true);
         }
      }
      
      protected function TryToReleaseRoleMoulde() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TBaseHero = null;
         var _loc3_:TBins = null;
         var _loc4_:TKnife = null;
         var _loc5_:TBins = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = _loc3_.GetDatebaseByIndex(_loc1_) as TBaseHero;
            SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(_loc2_.Identifier,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase));
            SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(_loc2_.Identifier,CONST_ROLE.ROLE_SEQUENCEINDEX_NormalRun));
            _loc1_++;
         }
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
         _loc1_ = 0;
         while(_loc1_ < _loc5_.Count)
         {
            _loc4_ = _loc5_.GetDatebaseByIndex(_loc1_) as TKnife;
            SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(_loc4_.Identifier,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase));
            SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(_loc4_.Identifier,CONST_ROLE.ROLE_SEQUENCEINDEX_NormalRun));
            _loc1_++;
         }
      }
      
      protected function OnEnterNextCity() : void
      {
         if(SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_CITYDEFEND) return;
         StageTransition = false;
         var _loc1_:TEnemy = null;
         var _loc2_:uint = 0;
         var _loc3_:TCityDefendHero = null;
         this.FCityDefendData.DefendBuffLevel = 1;
         this.FCityDefendData.CityDoorIndex = 1;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FInMonsterId + this.FCityDefendData.WorldLevel) as TEnemy;
         this.FCityDefendData.CityDoorTotleHp = _loc1_.Hp;
         this.FCityDefendData.CityDoorCurHp = this.FCityDefendData.CityDoorTotleHp;
         this.FProcessorWindowCityDefned.UpdataDoorHp();
         this.ChangeSceneId(this.FInCityId);
         this.FCityDefendData.DoorHeroList.Clear();
         this.FProcessorWindowDoorHeroList.Visible = false;
         this.FDoor.x = Door_X[this.FCityDefendData.CityDoorIndex];
         this.FDoor.y = Door_Y[this.FCityDefendData.CityDoorIndex];
         if(this.FCityDefendData.CityDefendType == TYPE_Defend)
         {
            this.FMainRole.MapX = 2150 + Math.random() * 50;
            this.FMainRole.MapY = 450 + Math.random() * 40;
         }
         else
         {
            this.FMainRole.MapX = 100 + Math.random() * 200;
            this.FMainRole.MapY = 400 + Math.random() * 200;
         }
         this.FDoorPos_X = Door_X[this.FCityDefendData.CityDoorIndex];
         this.FDoorPos_Y = Door_Y[this.FCityDefendData.CityDoorIndex];
         _loc2_ = 0;
         while(_loc2_ < this.FCityDefendData.HeroList.Count)
         {
            _loc3_ = this.FCityDefendData.HeroList.GetHeroByIndex(_loc2_);
            _loc3_.Status = 0;
            if(_loc3_.UserType == TYPE_Defend)
            {
               this.FCanMove.PlayerMove(_loc3_.Identifier0,_loc3_.Identifier1,2150 + Math.random() * 50,450 + Math.random() * 40);
            }
            else
            {
               this.FCanMove.PlayerMove(_loc3_.Identifier0,_loc3_.Identifier1,100 + Math.random() * 200,400 + Math.random() * 200);
            }
            _loc2_++;
         }
         this.FAtDoorReady = false;
         this.FIsArriveTarget = false;
         this.TryToMove(this);
      }
      
      protected function OnMainRoleArriveTarget() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         if(StageTransition || FightPending || TBattleHandle.IsInBattle) return;
         if(!this.FIsArriveTarget)
         {
            this.TryToMove(this);
            return;
         }
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CityDefend_CityDoorReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeByte(1);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.FProcessorWindowDoorHeroList.Visible = true;
         this.FIsArriveTarget = false;
      }
      
      protected function OnMoveByMouse() : void
      {
         this.FIsArriveTarget = false;
      }
      
      protected function OnShowBack(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.FBackGround.filters = [TUtilityFilter.rBlackFilters];
         }
         else
         {
            this.FBackGround.filters = [];
            if(this.FProcessorWindowCountdown.GetLastTime() <= 0)
            {
               this.TryToMove(this);
            }
         }
      }
      
      protected function SetSelectBoxState(param1:MovieClip, param2:Boolean) : void
      {
         if(param2)
         {
            param1.gotoAndStop(SelectedIndex);
         }
         else
         {
            param1.gotoAndStop(UnselectedIndex);
         }
      }
      
      protected function OnDoorClick(param1:MouseEvent = null) : void
      {
         if(this.FMainRole == null || StageTransition || FightPending || TBattleHandle.IsInBattle) return;
         this.FIsArriveTarget = true;
         this.FAtDoorReady = false;
         if(this.FCityDefendData.CityDefendType == TYPE_Defend)
         {
            this.FMainRole.SetupTargetPosition(this.FDoorPos_X + 600,this.FDoorPos_Y - 30 + Math.random() * 50,CONST_MainScene.RoleMoveSpeed);
         }
         else
         {
            this.FMainRole.SetupTargetPosition(this.FDoorPos_X - 90 + Math.random() * 20,this.FDoorPos_Y - 30 + Math.random() * 50,CONST_MainScene.RoleMoveSpeed);
         }
      }
      
      protected function TryToMove(param1:Object) : void
      {
         if(this.FAutoRun && this.FIfCanAutoRun)
         {
            this.OnDoorClick();
         }
      }
      
      protected function OnAutoRunClick(param1:MouseEvent) : void
      {
         if(this.FIfCanAutoRun)
         {
            this.FAutoRun = !this.FAutoRun;
            this.SetSelectBoxState(this.FAutoRunSelectBox,this.FAutoRun);
         }
         if(this.FAutoRun)
         {
            this.TryToMove(this);
         }
      }
      
      protected function SPAutoRunOnMove(param1:MouseEvent) : void
      {
         if(!this.FIfCanAutoRun)
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_35),SLogicsCore.Character.VipData.VipOpenLevel_CanAutoFight);
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function SPAutoBattleOnMove(param1:MouseEvent) : void
      {
         if(!this.FIfCanAutoBattle)
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_35),SLogicsCore.Character.VipData.VipOpenLevel_ArenaSkip);
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function OnSPOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnAutoBattleClick(param1:MouseEvent) : void
      {
         if(this.FIfCanAutoBattle)
         {
            this.FAutoBattle = !this.FAutoBattle;
            this.SetSelectBoxState(this.FAutoBattleSelectBox,this.FAutoBattle);
         }
      }
      
      public function get OnEnterTown() : Function
      {
         return this.FOnEnterTown;
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      public function set BattleBack(param1:Boolean) : void
      {
         this.FBattleBack = param1;
      }
      
      public function get BattleBack() : Boolean
      {
         return this.FBattleBack;
      }
      
      public function set OnSetDailyActivityStatus(param1:Function) : void
      {
         this.FOnSetDailyActivityStatus = param1;
      }
      
      public function get OnSetDailyActivityStatus() : Function
      {
         return this.FOnSetDailyActivityStatus;
      }
      
      public function get OnUnLoadBattleResources() : Function
      {
         return this.FOnUnLoadBattleResources;
      }
      
      public function set OnUnLoadBattleResources(param1:Function) : void
      {
         this.FOnUnLoadBattleResources = param1;
      }
      
      override public function ChatOptionsSetup(param1:TChatOptions) : void
      {
         param1.ChatOptionsReset();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(this.FBattleBack)
         {
            this.FBattleBack = false;
            FightPending = false;
            this.OnMainRoleArriveTarget();
            if(this.FProcessorWindowDoorHeroList)
            {
               this.FProcessorWindowDoorHeroList.Visible = false;
            }
            return;
         }
         if(param1 != null)
         {
            this.PacketPerform_SC_Enter_CityDefend(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FLayerLittleScript.Load();
            return;
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_CITYDEFEND;
         this.CreateMainRole();
         this.EnterCityDefend();
         this.ShowAndHide(SLogicsCore.IsShowAllUser);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_CityDefend,CONST_MUSIC.ID_SCENE_CityDefend,false);
         if(this.FProcessorWindowCountdown.GetLastTime() <= 0)
         {
            this.TryToMove(this);
         }
      }
      
      override public function Unmount() : void
      {
         this.FFighting = false;
      }
      
      public function EnterCityDefendReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_CityDefend);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function TurnBackTownSceneNtf() : void
      {
         if(this.FWindowConfirmationTurnBack == null)
         {
            this.FWindowConfirmationTurnBack = SUtilityOverLayer.UIWindowConfirmation;
         }
         this.FWindowConfirmationTurnBack.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_01);
         this.FWindowConfirmationTurnBack.OnOK = this.EnterCityScene;
         this.FWindowConfirmationTurnBack.Visible = true;
      }
      
      public function UpdatePet() : void
      {
         this.FMainRole.Pet.visible = SLogicsCore.Character.KnifeSoul.IfFight;
         this.FMainRole.Pet.TemplateID = SLogicsCore.Character.KnifeSoul.CurrentModuleID;
         this.FMainRole.Pet.Init();
      }
      
      public function ChangeMainHeroQuality() : void
      {
         this.FMainRole.RoleData.Quality = SLogicsCore.Character.MainHero.Quality;
         this.FMainRole.UpdateMainRoleNameColor();
      }
      
      public function ShowAndHide(param1:Boolean) : void
      {
         if(this.FCanMove != null)
         {
            this.FCanMove.SwitchMode(param1);
         }
      }
   }
}

