package Processors.Game.Lobby.TraitorAttack
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
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.TraitorAttack.*;
   import Logics.TraitorAttack.*;
   import Processors.Game.Battle.TBattleHandle;
   import Processors.Game.Lobby.CityDefend.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.MainScene.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.TraitorAttack.Components.*;
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
   
   public class TProcessorTraitorAttack extends TProcessorLobbyPlate
   {
      
      protected static const UnselectedIndex:int = 1;
      
      protected static const SelectedIndex:int = 2;
      
      protected static const AutoRunTargetX:int = 1000;
      
      protected static const AutoRunTargetY:int = 450;
      
      protected static const MonsterBaseId:uint = 12500001;
      
      protected static const MonsterWaveBase:uint = 100;
      
      protected static const MAX_MONSTER_COUNT:uint = 5;
      
      protected static const SendToServerPositionMinimumSpacing:int = 300 * 300;
      
      protected var FBackGround:TLayerBackGround;
      
      protected var FCanMove:TLayerCanMove;
      
      protected var FLayerLittleScript:TLayerLittleScript;
      
      protected var FPreTargetMapX:int;
      
      protected var FPreTargetMapY:int;
      
      protected var FMonsterLayer:TUIComponent;
      
      protected var FMainRole:TUIRoleCanMovePlayerRoleMainRole;
      
      protected var FMonsters:Vector.<TTraitorAttackActive>;
      
      protected var FDeadMonsters:Vector.<TTraitorAttackActive>;
      
      protected var FCheckTouchRoleVect:Vector.<TUIRoleCanMovePlayerRole>;
      
      protected var FTraitorAttackData:TTraitorAttackData;
      
      protected var FUnstreamizerTraitorAttack:TUnstreamizerTraitorAttack;
      
      protected var FTipsScene:MovieClip;
      
      protected var FTipRole:TTraitorAttackActive;
      
      protected var FScene:MovieClip;
      
      protected var FProcessorWindowTraitorAttack:TProcessorWindowTraitorAttack;
      
      protected var FProcessorWindowCountdownStart:TProcessorWindowCountdown;
      
      protected var FProcessorWindowCountdown:TProcessorWindowCountdown;
      
      protected var FProcessorWindowCountdownEnterTown:TProcessorWindowCountdown;
      
      protected var FProcessorWindowResurrection:TProcessorWindowResurrection;
      
      protected var FWindowConfirmationTurnBack:TUIWindowConfirmation;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsArriveTarget:Boolean;
      
      protected var FIsDie:Boolean;
      
      protected var FDieTime:uint;
      
      protected var FCostVect:Vector.<uint>;
      
      protected var FAppearcd:uint;
      
      protected var FHeroTalentBins:TBins;
      
      protected var FSkillBins:TBins;
      
      protected var FMakeMonsterSign:Dictionary;
      
      protected var FIsUnLoadBattleResources:Boolean;
      
      protected var FAutoRun:Boolean;
      
      protected var FAutoBattle:Boolean;
      
      protected var FIfCanAutoRun:Boolean;
      
      protected var FIfCanAutoBattle:Boolean;
      
      protected var FSPAutoRun:Sprite;
      
      protected var FAutoRunSelectBox:MovieClip;
      
      protected var FSPAutoBattle:Sprite;
      
      protected var FAutoBattleSelectBox:MovieClip;
      
      protected var FHint:THint;
      
      protected var FBattleBack:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleBackground:Function;
      
      protected var FOnUnLoadBattleResources:Function;
      
      public function TProcessorTraitorAttack(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FBackGround = new TLayerBackGround(this);
         this.FBackGround.OnLoadCompleted = this.ProcessorResourcesOnLoadCompleted;
         this.FBackGround.IsNeedSmallPic = false;
         this.FBackGround.visible = true;
         this.FBackGround.RoleControlWidth = CONST_COMMON.STAGE_Width;
         this.FCanMove = new TLayerCanMove(this.FBackGround);
         this.FCanMove.visible = false;
         this.FMonsterLayer = new TUIComponent(this.FBackGround);
         this.FLayerLittleScript = new TLayerLittleScript(this);
         this.FLayerLittleScript.visible = true;
         this.FLayerLittleScript.MouseEventObject = this.FBackGround;
         this.FLayerLittleScript.ChangeRolePositionByMouse = this.OnMoveByMouse;
         this.FLayerLittleScript.LongClickMove = false;
         this.FTraitorAttackData = new TTraitorAttackData();
         this.FUnstreamizerTraitorAttack = new TUnstreamizerTraitorAttack();
         this.FMonsters = new Vector.<TTraitorAttackActive>();
         this.FDeadMonsters = new Vector.<TTraitorAttackActive>();
         this.FCheckTouchRoleVect = new Vector.<TUIRoleCanMovePlayerRole>();
         this.FMakeMonsterSign = new Dictionary();
         this.FBattleBack = false;
         this.FIsUnLoadBattleResources = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TRAITORATTACK.RESOURCE_TraitorAttack);
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitTraitorAttack();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!FIsResourcesLoadCompleted || this.FMainRole == null)
         {
            return;
         }
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TRAITORATTACK)
         {
            this.FBackGround.Update();
            this.FCanMove.Update();
            this.LogicsPerform_Timer();
            this.FMonsterLayer.x = -SLogicsCore.ScreenMapX;
            this.UpdataMonster();
            this.CheckRoleTouchMonster();
         }
         if(!this.FProcessorWindowCountdownEnterTown.Visible && !this.FProcessorWindowCountdownStart.Visible && !this.FProcessorWindowCountdown.Visible && !this.FProcessorWindowResurrection.Visible)
         {
            if(this.FMainRole.TargetMapX != AutoRunTargetX || this.FMainRole.TargetMapY != AutoRunTargetY)
            {
               this.TryRunToMonster();
            }
         }
      }
      
      protected function LogicsPerform_Timer() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         if(this.FScene != null)
         {
            _loc1_ = this.FTraitorAttackData.EndTime - STimingCore.ServerTick;
            _loc2_ = TUtilityTiming.fomatTime(_loc1_);
            this.FScene.tf_time.text = _loc2_;
         }
      }
      
      protected function UpdataMonster() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TTraitorAttackActive = null;
         _loc1_ = 0;
         while(_loc1_ < this.FMonsters.length)
         {
            _loc2_ = this.FMonsters[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.UpdateActive();
               if(!this.FIsDie && _loc2_.Display.hitTestObject(this.FMainRole))
               {
                  this.EnterFightReq(_loc2_.Id);
                  break;
               }
            }
            _loc1_++;
         }
         this.FMonsters.sort(this.SortPos);
         _loc1_ = 0;
         while(_loc1_ < this.FMonsters.length)
         {
            this.FMonsterLayer.setChildIndex(this.FMonsters[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      protected function SortPos(param1:TTraitorAttackActive, param2:TTraitorAttackActive) : int
      {
         if(param1.y < param2.y)
         {
            return -1;
         }
         if(param1.y > param2.y)
         {
            return 1;
         }
         return 0;
      }
      
      protected function CheckRoleTouchMonster() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TUIRoleCanMovePlayerRole = null;
         _loc1_ = 0;
         while(_loc1_ < this.FCheckTouchRoleVect.length)
         {
            _loc2_ = this.FCheckTouchRoleVect[_loc1_];
            if(this.IsRoleTouchMonster(_loc2_))
            {
               this.FCanMove.InitNewRole(_loc2_);
               this.FCheckTouchRoleVect.splice(_loc1_,1);
               _loc1_--;
               break;
            }
            _loc1_++;
         }
      }
      
      protected function IsRoleTouchMonster(param1:TUIRoleCanMovePlayerRole) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:TTraitorAttackActive = null;
         if(param1.MapX >= 1200)
         {
            return true;
         }
         _loc2_ = 0;
         while(_loc2_ < this.FMonsters.length)
         {
            _loc3_ = this.FMonsters[_loc2_];
            if(_loc3_ != null)
            {
               if(_loc3_.Display.hitTestObject(param1))
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
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
         this.FMainRole.RoleData.Quality = _loc1_.Quality;
         this.FMainRole.UpdateMainRoleNameColor();
         _loc3_ = new TUIRoleCanMovePet(this.FCanMove);
         _loc3_.FollowRole = this.FMainRole;
         this.FMainRole.Pet = _loc3_;
         _loc3_.TemplateID = SLogicsCore.Character.KnifeSoul.CurrentModuleID;
         _loc3_.Init();
         _loc3_.visible = SLogicsCore.Character.KnifeSoul.IfFight;
         this.FCanMove.InitNewRole(this.FMainRole);
         this.FCanMove.MainRole = this.FMainRole;
         this.FBackGround.ScreenRole = this.FMainRole;
         this.FLayerLittleScript.MainRole = this.FMainRole;
      }
      
      protected function InitTraitorAttack() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TRAITORATTACK.RESOURCE_ClassName_MC_TraitorAttack) as MovieClip;
         addChild(this.FScene);
         this.FProcessorWindowCountdownStart = new TProcessorWindowCountdown(this);
         this.FProcessorWindowCountdownStart.SetScene(this.FScene.mc_StartCountdown);
         this.FProcessorWindowCountdownStart.Visible = false;
         this.FProcessorWindowCountdown = new TProcessorWindowCountdown(this);
         this.FProcessorWindowCountdown.SetScene(this.FScene.mc_Countdown);
         this.FProcessorWindowCountdown.Visible = false;
         this.FProcessorWindowCountdownEnterTown = new TProcessorWindowCountdown(this);
         this.FProcessorWindowCountdownEnterTown.SetScene(this.FScene.mc_ReturnCity);
         this.FProcessorWindowCountdownEnterTown.Visible = false;
         this.FProcessorWindowResurrection = new TProcessorWindowResurrection(this);
         this.FProcessorWindowResurrection.OnEffectText = EffectGenerateText;
         this.FProcessorWindowResurrection.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowResurrection.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowResurrection.ShowBack = this.OnShowBack;
         this.FProcessorWindowResurrection.SetScene(this.FScene.mc_Resurrection,false);
         this.FProcessorWindowResurrection.Visible = false;
         this.FProcessorWindowTraitorAttack = new TProcessorWindowTraitorAttack(this);
         this.FProcessorWindowTraitorAttack.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTraitorAttack.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTraitorAttack.HelpHintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTraitorAttack.HelpHintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTraitorAttack.SetScene(this.FScene);
         this.FProcessorWindowTraitorAttack.InitUI(this.FTraitorAttackData);
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
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_NewRoleNtf,this.AddNewRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_RoleMove,this.RoleMove);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_RemoveRole,this.RemoveTownRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_UpdateRole,this.UpdateRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_ReviveRet,this.PacketPerform_SC_ReviveRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_MonsterInfo,this.PacketPerform_SC_MonsterInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_BattleRet,this.PacketPerform_SC_BattleRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_RankUpdate,this.PacketPerform_SC_RankUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_RebornNotify,this.PacketPerform_SC_RebornNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_DeathNotify,this.PacketPerform_SC_DeathNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_RoundUpdate,this.PacketPerform_SC_RoundUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_ScoreUpdate,this.PacketPerform_SC_ScoreUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TraitorAttack_PlayerCount,this.PacketPerform_SC_PlayerCount);
      }
      
      protected function PacketPerform_SC_Enter_TraitorAttack(param1:ByteArray) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:uint = 0;
         var _loc4_:TConfigValue = null;
         this.FUnstreamizerTraitorAttack.Unstreamize(param1,this.FTraitorAttackData,null);
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc4_ = _loc2_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.TraitorAttack_Mapid) as TConfigValue;
         _loc3_ = _loc4_.Value as uint;
         _loc4_ = _loc2_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.TraitorAttack_Revivecost) as TConfigValue;
         this.FCostVect = _loc4_.Value as Vector.<uint>;
         _loc4_ = _loc2_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.TraitorAttack_Deathtime) as TConfigValue;
         this.FDieTime = _loc4_.Value as int;
         _loc4_ = _loc2_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.TraitorAttack_Appearcd) as TConfigValue;
         this.FAppearcd = _loc4_.Value as int;
         this.ChangeSceneId(_loc3_);
      }
      
      protected function AddNewRole(param1:TPacket) : void
      {
         this.FCanMove.AddNewCanControlRole(param1);
      }
      
      protected function RoleMove(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedShort();
         _loc5_ = param1.Data.readUnsignedShort();
         this.FCanMove.PlayerMove(_loc2_,_loc3_,_loc4_,_loc5_);
      }
      
      protected function RemoveTownRole(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TUIRoleCanMovePlayerRole = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         this.FCanMove.PlayerRemove(_loc2_,_loc3_);
         _loc4_ = 0;
         while(_loc4_ < this.FCheckTouchRoleVect.length)
         {
            _loc5_ = this.FCheckTouchRoleVect[_loc4_];
            if(_loc5_.RoleData.Identifier0 == _loc2_ && _loc5_.RoleData.Identifier1 == _loc3_)
            {
               this.FCheckTouchRoleVect.splice(_loc4_,1);
               break;
            }
            _loc4_++;
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
         ++this.FTraitorAttackData.ResurrectionTimes;
      }
      
      protected function PacketPerform_SC_MonsterInfo(param1:TPacket) : void
      {
         var _loc2_:* = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TTraitorAttackActive = null;
         _loc3_ = param1.Data;
         this.FUnstreamizerTraitorAttack.UnstreamizeTraitorAttackMonsterInfo(_loc3_,this.FTraitorAttackData,null);
         _loc2_ = 0;
         while(_loc2_ < this.FMonsters.length)
         {
            _loc5_ = this.FMonsters[_loc2_];
            _loc4_ = uint(_loc5_.Id);
            if(this.FTraitorAttackData.MonsterList[_loc4_] <= 0)
            {
               this.FMonsters.splice(_loc2_,1);
               _loc2_--;
               this.FDeadMonsters.push(_loc5_);
               _loc5_.IsDie = true;
               if(_loc5_.parent)
               {
                  _loc5_.parent.removeChild(_loc5_);
               }
            }
            else
            {
               _loc5_.SetHp(this.FTraitorAttackData.MonsterList[_loc4_]);
            }
            _loc2_++;
         }
      }
      
      protected function PacketPerform_SC_BattleRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TUIRoleCanMovePlayerRole = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FAutoBattle)
         {
            TBattleHandle.AutoCloseBattle(true);
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_TraitorAttack,CONST_MUSIC.ID_SCENE_TraitorAttack);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
            TBattleHandle.IsInBattle = true;
         }
         _loc4_ = 0;
         while(_loc4_ < this.FCheckTouchRoleVect.length)
         {
            _loc5_ = this.FCheckTouchRoleVect[_loc4_];
            this.FCanMove.InitNewRole(_loc5_);
            _loc4_++;
         }
         this.FCheckTouchRoleVect.length = 0;
         this.FMainRole.StopMove();
      }
      
      protected function PacketPerform_SC_RankUpdate(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerTraitorAttack.UnstreamizeTraitorAttackRankUpdate(_loc2_,this.FTraitorAttackData.RankList,null);
         if(this.FProcessorWindowTraitorAttack != null)
         {
            this.FProcessorWindowTraitorAttack.UpdataRankUI();
         }
      }
      
      protected function PacketPerform_SC_RebornNotify(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIRoleCanMovePlayerRole = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = this.FCanMove.RolesUI.GetRoleByIdentifier(_loc2_,_loc3_);
         if(_loc4_ != null)
         {
            this.FCanMove.PlayerMove(_loc2_,_loc3_,1200,480);
            this.FCheckTouchRoleVect.push(_loc4_);
         }
      }
      
      protected function PacketPerform_SC_DeathNotify(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         if(this.FTraitorAttackData.ResurrectionTimes < this.FCostVect.length)
         {
            _loc2_ = this.FCostVect[this.FTraitorAttackData.ResurrectionTimes];
         }
         else
         {
            _loc2_ = this.FCostVect[this.FCostVect.length - 1];
         }
         this.FProcessorWindowResurrection.StartCountdown(STimingCore.ServerTick + this.FDieTime,_loc2_);
      }
      
      protected function PacketPerform_SC_RoundUpdate(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TUIRoleCanMovePlayerRole = null;
         var _loc6_:uint = 0;
         var _loc7_:TTraitorAttackActive = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         this.FTraitorAttackData.CurWave = _loc3_;
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FProcessorWindowTraitorAttack.UpdataWave();
         if(this.FProcessorWindowCountdownStart.GetLastTime() < this.FAppearcd)
         {
            this.FProcessorWindowCountdownStart.Stop();
            this.FProcessorWindowCountdown.StartCountdown(STimingCore.ServerTick + this.FAppearcd);
         }
         setTimeout(this.EnterNextWaveMonster,this.FAppearcd * 1000);
         _loc4_ = 0;
         while(_loc4_ < this.FCanMove.RolesUI.Count)
         {
            _loc5_ = this.FCanMove.RolesUI.GetRoleByIndex(_loc4_);
            this.FCanMove.InitNewRole(_loc5_);
            _loc4_++;
         }
         this.FCanMove.InitNewRole(this.FMainRole);
         this.FCheckTouchRoleVect.length = 0;
         _loc6_ = this.FMonsters.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_ = this.FMonsters.pop();
            _loc7_.IsDie = true;
            this.FDeadMonsters.push(_loc7_);
            if(_loc7_.parent)
            {
               _loc7_.parent.removeChild(_loc7_);
            }
            _loc4_++;
         }
         if(TBattleHandle.IsInBattle)
         {
            this.FIsUnLoadBattleResources = true;
         }
         else
         {
            this.ProcessorUnLoadBattleResources(true);
         }
      }
      
      protected function ProcessorUnLoadBattleResources(param1:Boolean = false) : void
      {
         if(this.FOnUnLoadBattleResources != null)
         {
            this.FOnUnLoadBattleResources(this,param1);
         }
      }
      
      protected function PacketPerform_SC_ScoreUpdate(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerTraitorAttack.UnstreamizeTraitorAttackScoreUpdate(_loc2_,this.FTraitorAttackData,null);
         if(this.FProcessorWindowTraitorAttack != null)
         {
            this.FProcessorWindowTraitorAttack.UpdataScoreUI();
         }
      }
      
      protected function PacketPerform_SC_PlayerCount(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FTraitorAttackData.EnterHeroCount = _loc2_.readUnsignedInt();
         if(this.FProcessorWindowTraitorAttack != null)
         {
            this.FProcessorWindowTraitorAttack.UpdataPlayerCountUI();
         }
      }
      
      protected function UpdateRole(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readByte();
         _loc5_ = param1.Data.readUnsignedInt();
         this.FCanMove.PlayerUpdate(_loc2_,_loc3_,_loc4_,_loc5_);
      }
      
      protected function OnMainRoleArriveTarget() : void
      {
         if(this.FMainRole.MapX != AutoRunTargetX || this.FMainRole.MapY != AutoRunTargetY)
         {
            this.TryRunToMonster();
         }
      }
      
      protected function UpdateRolePositionSendToServer() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         _loc1_ = this.FLayerLittleScript.TargetMapX - this.FPreTargetMapX;
         _loc2_ = this.FLayerLittleScript.TargetMapY - this.FPreTargetMapY;
         _loc3_ = _loc1_ * _loc1_ + _loc2_ * _loc2_;
         if(_loc3_ > SendToServerPositionMinimumSpacing)
         {
            this.FPreTargetMapX = this.FLayerLittleScript.TargetMapX;
            this.FPreTargetMapY = this.FLayerLittleScript.TargetMapY;
            this.PacketPerform_CS_LOBBY_Town_Move(this.FLayerLittleScript.TargetMapX,this.FLayerLittleScript.TargetMapY);
         }
      }
      
      protected function PacketPerform_CS_LOBBY_Town_Move(param1:int, param2:int) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_Town_Move);
         _loc4_ = _loc3_.Data;
         _loc4_.writeShort(param1);
         _loc4_.writeShort(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnMoveByMouse() : void
      {
         this.FIsArriveTarget = false;
         this.UpdateRolePositionSendToServer();
      }
      
      protected function EnterCityScene(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TTraitorAttackActive = null;
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
         this.FCanMove.ClearAllRole();
         _loc3_ = this.FMonsters.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FMonsters.pop();
            _loc4_.IsDie = true;
            this.FDeadMonsters.push(_loc4_);
            if(_loc4_.parent)
            {
               _loc4_.parent.removeChild(_loc4_);
            }
            _loc2_++;
         }
         this.FMakeMonsterSign = new Dictionary();
         this.FCheckTouchRoleVect.length = 0;
         this.ProcessorUnLoadBattleResources(true);
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
      
      protected function OnShowBack(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.FIsDie = true;
            this.FBackGround.filters = [TUtilityFilter.rBlackFilters];
         }
         else
         {
            this.FIsDie = false;
            this.FBackGround.filters = [];
         }
      }
      
      protected function OnResurrection(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TraitorAttack_ReviveReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function EnterTraitorAttack() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FProcessorWindowCountdownStart.StartCountdown(STimingCore.ServerTick + this.FTraitorAttackData.CDTime);
         this.FProcessorWindowCountdown.Stop();
         this.FProcessorWindowResurrection.Stop();
         _loc1_ = 0;
         while(_loc1_ < MAX_MONSTER_COUNT)
         {
            _loc2_ = MonsterBaseId + this.FTraitorAttackData.CurWave * MonsterWaveBase + _loc1_;
            if(this.FTraitorAttackData.MonsterList[_loc2_] == null)
            {
               this.FTraitorAttackData.MonsterList[_loc2_] = 10000000;
            }
            _loc1_++;
         }
         if(this.FTraitorAttackData.EndTime - STimingCore.ServerTick > 30 * 60)
         {
            setTimeout(this.EnterNextWaveMonster,this.FTraitorAttackData.CDTime * 1000);
         }
         else
         {
            setTimeout(this.EnterNextWaveMonster,1000);
         }
         this.OnShowBack(this,false);
         this.FProcessorWindowTraitorAttack.UpdataRankUI();
         this.FProcessorWindowTraitorAttack.UpdataScoreUI();
         this.FProcessorWindowTraitorAttack.UpdataWave();
         this.FProcessorWindowTraitorAttack.UpdataPlayerCountUI();
      }
      
      protected function EnterNextWaveMonster() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TTraitorAttackActive = null;
         if(this.FMakeMonsterSign[this.FTraitorAttackData.CurWave] == true)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_MONSTER_COUNT)
         {
            _loc2_ = MonsterBaseId + this.FTraitorAttackData.CurWave * MonsterWaveBase + _loc1_;
            if(this.FTraitorAttackData.MonsterList[_loc2_] > 0)
            {
               if(this.FDeadMonsters.length > 0)
               {
                  _loc3_ = this.FDeadMonsters.pop();
                  _loc3_.ResetActive(this.FMonsterLayer,_loc2_,true);
               }
               else
               {
                  _loc3_ = new TTraitorAttackActive(this.FMonsterLayer,_loc2_,true);
                  _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.ShowTips);
                  _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.HideTips);
               }
               _loc3_.InitPos(1350 - 40 * _loc1_,400 + 40 * _loc1_);
               _loc3_.RunToStage();
               this.FMonsters.push(_loc3_);
               _loc3_.SetHp(this.FTraitorAttackData.MonsterList[_loc2_]);
            }
            _loc1_++;
         }
         this.FMakeMonsterSign[this.FTraitorAttackData.CurWave] = true;
      }
      
      protected function GetSceneBitmapData() : BitmapData
      {
         var _loc1_:BitmapData = null;
         _loc1_ = new BitmapData(CONST_COMMON.STAGE_Width,CONST_COMMON.STAGE_Height);
         _loc1_.draw(this.FBackGround);
         return _loc1_;
      }
      
      protected function EnterFightReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         this.FCanMove.InitNewRole(this.FMainRole);
         this.FPreTargetMapX = 0;
         this.FPreTargetMapY = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TraitorAttack_BattleReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FCanMove.visible = false;
         this.FMonsterLayer.visible = false;
         if(this.FOnSetBattleBackground != null)
         {
            this.FOnSetBattleBackground(this,this.GetSceneBitmapData());
         }
         this.FCanMove.visible = true;
         this.FMonsterLayer.visible = true;
      }
      
      protected function GetMonsterIndexById(param1:uint) : int
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FMonsters.length)
         {
            if(this.FMonsters[_loc2_].Id == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      protected function ShowTips(param1:MouseEvent) : void
      {
         var _loc2_:TTraitorAttackActive = null;
         var _loc3_:THeroTalent = null;
         var _loc4_:uint = 0;
         var _loc5_:TSkillConfig = null;
         var _loc6_:TKnife = null;
         if(this.FHeroTalentBins == null)
         {
            this.FHeroTalentBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
         }
         if(this.FSkillBins == null)
         {
            this.FSkillBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         }
         _loc2_ = param1.currentTarget as TTraitorAttackActive;
         if(this.FTipRole != _loc2_)
         {
            if(this.FTipRole != null)
            {
               this.FTipRole.ShowHighLight = false;
            }
            this.FTipRole = _loc2_;
            if(_loc2_.direction == false)
            {
               FUICore.MouseCaptureSet(this.FTipRole);
               _loc2_.CursorHovering = true;
            }
            if(FResourcesState != RESOURCESSTATE_Ready)
            {
               return;
            }
            if(this.FTipsScene == null)
            {
               this.FTipsScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_GroupMonstonTip) as MovieClip;
               addChild(this.FTipsScene);
            }
            if(_loc2_.EnemyData != null)
            {
               this.FTipsScene.tf_name.text = _loc2_.EnemyData.Name;
               this.FTipsScene.tf_level.text = "LV." + _loc2_.EnemyData.Level;
               this.FTipsScene.tf_type.text = TUtilityLobby.GetProfessionByIndex(_loc2_.EnemyData.Profession);
               this.FTipsScene.tf_health.text = _loc2_.EnemyData.Hp;
               _loc3_ = this.FHeroTalentBins.GetDatebaseByIdentifier(_loc2_.EnemyData.TalentId) as THeroTalent;
               if(_loc3_ != null)
               {
                  this.FTipsScene.tf_talent.text = _loc3_.TalentName;
               }
               else
               {
                  this.FTipsScene.tf_talent.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
               }
               _loc5_ = this.FSkillBins.GetDatebaseByIdentifier(_loc2_.EnemyData.Skill) as TSkillConfig;
               this.FTipsScene.tf_skill.text = _loc5_.Name;
               this.FTipsScene.tf_skilldesc.text = _loc5_.Desc;
            }
         }
         if(this.FTipsScene != null)
         {
            this.FTipsScene.visible = true;
            this.FTipsScene.x = mouseX + 15;
            this.FTipsScene.y = mouseY;
            if(this.FTipsScene.x > CONST_COMMON.STAGE_Width - this.FTipsScene.width)
            {
               this.FTipsScene.x = mouseX - this.FTipsScene.width - 5;
            }
            if(this.FTipsScene.y > CONST_COMMON.STAGE_Height - this.FTipsScene.height)
            {
               this.FTipsScene.y = mouseY - this.FTipsScene.height - 5;
            }
         }
      }
      
      protected function HideTips(param1:MouseEvent) : void
      {
         FUICore.MouseCaptureRelease(this.FTipRole);
         this.FTipRole = null;
         if(this.FTipsScene != null)
         {
            this.FTipsScene.visible = false;
         }
      }
      
      protected function TryRunToMonster() : void
      {
         if(this.FMainRole != null && this.FAutoRun && this.FIfCanAutoRun)
         {
            this.FMainRole.SetupTargetPosition(AutoRunTargetX,AutoRunTargetY,CONST_MainScene.RoleMoveSpeed);
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
      
      protected function OnAutoRunClick(param1:MouseEvent) : void
      {
         if(this.FIfCanAutoRun)
         {
            this.FAutoRun = !this.FAutoRun;
            this.SetSelectBoxState(this.FAutoRunSelectBox,this.FAutoRun);
         }
      }
      
      protected function OnAutoBattleClick(param1:MouseEvent) : void
      {
         if(this.FIfCanAutoBattle)
         {
            this.FAutoBattle = !this.FAutoBattle;
            this.SetSelectBoxState(this.FAutoBattleSelectBox,this.FAutoBattle);
            TBattleHandle.AutoCloseBattle(this.FAutoBattle);
         }
      }
      
      public function get BattleBack() : Boolean
      {
         return this.FBattleBack;
      }
      
      public function set BattleBack(param1:Boolean) : void
      {
         this.FBattleBack = param1;
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
      
      public function get OnSetBattleBackground() : Function
      {
         return this.FOnSetBattleBackground;
      }
      
      public function set OnSetBattleBackground(param1:Function) : void
      {
         this.FOnSetBattleBackground = param1;
      }
      
      public function get OnUnLoadBattleResources() : Function
      {
         return this.FOnUnLoadBattleResources;
      }
      
      public function set OnUnLoadBattleResources(param1:Function) : void
      {
         this.FOnUnLoadBattleResources = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(this.FBattleBack)
         {
            if(this.FIsUnLoadBattleResources)
            {
               this.ProcessorUnLoadBattleResources(true);
               this.FIsUnLoadBattleResources = false;
            }
            this.FBattleBack = false;
            return;
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_TRAITORATTACK;
         if(param1 != null)
         {
            this.PacketPerform_SC_Enter_TraitorAttack(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FLayerLittleScript.Load();
            return;
         }
         this.CreateMainRole();
         this.EnterTraitorAttack();
         this.ShowAndHide(SLogicsCore.IsShowAllUser);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_TraitorAttack,CONST_MUSIC.ID_SCENE_TraitorAttack,false);
      }
      
      protected function testData() : void
      {
         var _loc1_:TTraitorAttackRankHero = null;
         this.FTraitorAttackData.CDTime = 2;
         this.FTraitorAttackData.CurWave = 2;
         this.FTraitorAttackData.EndTime = STimingCore.ServerTick + 20 * 60;
         this.FTraitorAttackData.EnterHeroCount = 5;
         this.FTraitorAttackData.MonsterList[12500201] = 100000;
         this.FTraitorAttackData.MonsterList[12500202] = 200100;
         this.FTraitorAttackData.MonsterList[12500203] = 300200;
         this.FTraitorAttackData.MonsterList[12500204] = 400300;
         this.FTraitorAttackData.MonsterList[12500205] = 500400;
         this.FTraitorAttackData.ScoreList[0] = 30;
         this.FTraitorAttackData.ScoreList[1] = 20;
         this.FTraitorAttackData.ScoreList[2] = 10;
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this.FTraitorAttackData.RankList.MySelfHarm.High = 0;
            this.FTraitorAttackData.RankList.MySelfHarm.Low = 10001;
            this.FTraitorAttackData.RankList.TotleHarm.High = 0;
            this.FTraitorAttackData.RankList.TotleHarm.Low = 1000000;
            _loc1_ = new TTraitorAttackRankHero();
            _loc1_.HeroName = "abc" + _loc2_;
            _loc1_.HeroHarm.Low = 1000 * _loc2_;
            this.FTraitorAttackData.RankList.Add(_loc1_);
            _loc2_++;
         }
         this.FProcessorWindowTraitorAttack.UpdataPlayerCountUI();
         this.FProcessorWindowTraitorAttack.UpdataRankUI();
         this.FProcessorWindowTraitorAttack.UpdataScoreUI();
         this.FProcessorWindowTraitorAttack.UpdataWave();
         this.FProcessorWindowTraitorAttack.UpdataPlayerCountUI();
         this.ChangeSceneId(10201);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function EnterTraitorAttackReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_TraitorAttack);
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
      
      public function TraitorAttackEnd() : void
      {
         if(this.FProcessorWindowCountdownEnterTown != null)
         {
            this.FProcessorWindowCountdownEnterTown.StartCountdown(STimingCore.ServerTick + 5);
            setTimeout(this.EnterCityScene,5000);
         }
         if(this.FProcessorWindowCountdownStart != null)
         {
            this.FProcessorWindowCountdownStart.Stop();
         }
         if(this.FProcessorWindowResurrection != null)
         {
            this.FProcessorWindowResurrection.Stop();
         }
         if(this.FProcessorWindowCountdown != null)
         {
            this.FProcessorWindowCountdown.Stop();
         }
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

