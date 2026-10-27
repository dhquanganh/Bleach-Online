package Processors.Game.Lobby.FightPet
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
   import Logics.FightPet.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Battle.TBattleHandle;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.MainScene.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.utils.*;
   
   public class TProcessorFightPet extends TProcessorLobbyPlate
   {
      
      protected static const Monster_MapX:int = 1000;
      
      protected static const Monster_MapY:int = 470;
      
      protected static const FSendToServerPositionMinimumSpacing:int = 300 * 300;
      
      protected static const UnselectedIndex:int = 1;
      
      protected static const SelectedIndex:int = 2;
      
      protected var FBackGround:TLayerBackGround;
      
      protected var FLittleScript:TLayerLittleScript;
      
      protected var FCanMove:TLayerCanMove;
      
      protected var FLayerOver:TLayerOver;
      
      protected var FMainRole:TUIRoleCanMovePlayerRoleMainRole;
      
      protected var FMonster:TUIRoleCanMoveMonster;
      
      protected var FPet:TUIRoleCanMovePet;
      
      protected var FCheckTouchRoleVect:Vector.<TUIRoleCanMovePlayerRole>;
      
      protected var FTime:uint;
      
      protected var FTimeCD:uint;
      
      protected var FTotalHP:uint;
      
      protected var FMonsterLv:uint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FPreTargetMapX:int;
      
      protected var FPreTargetMapY:int;
      
      protected var FIsInCD:Boolean;
      
      protected var FFightPetData:TFightPet;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FBackTownTimeCoolDown:TTimeCoolDown;
      
      protected var FIsBack:Boolean;
      
      protected var FIsInBattle:Boolean;
      
      protected var FConfigValue:TBins;
      
      protected var FMapId:uint;
      
      protected var FIsStarRun:Boolean;
      
      protected var FUIRoleCanMovePlayerRoleTemp:TUIRoleCanMovePlayerRole;
      
      protected var FIsHitMonst:Boolean;
      
      protected var FAutoRun:Boolean;
      
      protected var FAutoBattle:Boolean;
      
      protected var FIfCanAutoRun:Boolean;
      
      protected var FIfCanAutoBattle:Boolean;
      
      protected var FSPAutoRun:Sprite;
      
      protected var FAutoRunSelectBox:MovieClip;
      
      protected var FSPAutoBattle:Sprite;
      
      protected var FAutoBattleSelectBox:MovieClip;
      
      protected var FHint:THint;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnUnLoadBattleResources:Function;
      
      protected var FOnSetBattleBackground:Function;
      
      public function TProcessorFightPet(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FBackGround = new TLayerBackGround(this);
         this.FBackGround.OnLoadCompleted = this.ProcessorResourcesOnLoadCompleted;
         this.FBackGround.IsNeedSmallPic = false;
         this.FBackGround.visible = true;
         this.FCanMove = new TLayerCanMove(this.FBackGround);
         this.FCanMove.visible = false;
         this.FLittleScript = new TLayerLittleScript(this);
         this.FLittleScript.visible = true;
         this.FLittleScript.MouseEventObject = this.FBackGround;
         this.FLittleScript.ChangeRolePositionByMouse = this.ChangeRolePositionByMouse;
         this.FFightPetData = new TFightPet();
         this.FLayerOver = new TLayerOver(this);
         this.FLayerOver.OnMoraleUp = this.OnMoraleUp;
         this.FLayerOver.OnResurrection = this.OnResurrection;
         this.FLayerOver.FightPetData = this.FFightPetData;
         this.FLayerOver.OnMoraleUpOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FLayerOver.OnMoraleUpOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FLayerOver.OnHelpOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FLayerOver.OnHelpOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FLayerOver.SetResurrectionStatue = this.SetResurrectionStatue;
         this.FLayerOver.StarRun = this.OnStarRun;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_FightPet_EnterCD);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
         this.FBackTownTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_FightPet_BACKTOWN);
         SLogicsCore.TimeCoolDowns.Add(this.FBackTownTimeCoolDown);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_FIGHTPET.RESOURCESID_Swf_FirstRecharge);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         this.FCheckTouchRoleVect = new Vector.<TUIRoleCanMovePlayerRole>();
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_FIGHTPET.RESOURCE_ClassName_FightPet) as Sprite;
         this.FLayerOver.UIDispatch(_loc1_);
         this.FLayerOver.UILocation();
         this.FSPAutoRun = _loc1_["AutoRun"];
         if(this.FSPAutoRun != null)
         {
            this.FSPAutoRun.addEventListener(MouseEvent.MOUSE_MOVE,this.SPAutoRunOnMove);
            this.FSPAutoRun.addEventListener(MouseEvent.MOUSE_OUT,this.OnSPOut);
            this.FAutoRunSelectBox = this.FSPAutoRun["task"];
            this.FAutoRunSelectBox.addEventListener(MouseEvent.CLICK,this.OnAutoRunClick);
            this.FSPAutoBattle = _loc1_["AutoFight"];
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
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_FIGHTPET)
         {
            this.FBackGround.Update();
            this.FCanMove.Update();
            this.LogicsMonster();
            this.LogicsHitMonster();
            this.LogicsDieCD();
            this.LogicsBackTownCD();
            this.CheckRoleTouchMonster();
            if(!this.FLayerOver.IsCoolDown)
            {
               this.TryRunToMonster();
            }
         }
      }
      
      protected function CheckRoleTouchMonster() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TUIRoleCanMovePlayerRole = null;
         if(this.FMonster == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FCheckTouchRoleVect.length)
         {
            _loc2_ = this.FCheckTouchRoleVect[_loc1_];
            if(this.FMonster.hitTestObject(_loc2_))
            {
               this.FCanMove.InitNewRole(_loc2_);
               this.FCheckTouchRoleVect.splice(_loc1_,1);
               _loc1_--;
               break;
            }
            _loc1_++;
         }
      }
      
      private function LogicsBackTownCD() : void
      {
         if(this.FFightPetData.GameOver && this.FIsBack)
         {
            if(this.FBackTownTimeCoolDown.TimingTime >= 0)
            {
               this.FLayerOver.BackTownCDUpdate(this.FBackTownTimeCoolDown.TimingTime);
            }
            if(this.FBackTownTimeCoolDown.TimingTime == 0)
            {
               this.BackTownFun();
            }
         }
      }
      
      private function LogicsDieCD() : void
      {
         if(this.FLayerOver.IsInitialization && this.FIsInCD)
         {
            if(this.FTimeCoolDown.TimingTime >= 0)
            {
               if(!this.FFightPetData.IsDie)
               {
                  this.FLayerOver.InfoCDUpdate(this.FTimeCoolDown.TimingTime);
                  this.FBackGround.filters = [];
               }
               if(this.FTimeCoolDown.TimingTime == 0)
               {
                  this.FIsInCD = false;
                  this.FFightPetData.CDTime = 0;
               }
            }
         }
      }
      
      private function LogicsHitMonster() : void
      {
         if(this.FMonster != null && this.FMainRole != null && !this.FIsInCD && this.FIsBack && !this.FIsInBattle)
         {
            if(this.FMainRole.MapX >= this.FMonster.MapX - this.FMainRole.width && this.FMainRole.MapX <= this.FMonster.MapX + 200 && this.FMainRole.MapY >= this.FMonster.MapY - this.FMainRole.height && this.FMainRole.MapY <= this.FMonster.MapY + this.FMainRole.height)
            {
               this.FIsHitMonst = true;
               this.EnterFightReq();
            }
         }
      }
      
      private function LogicsMonster() : void
      {
         if(this.FMonster != null)
         {
            if(this.FMonster.CheckIfInScreen(this.FMonster))
            {
               this.FMonster.UpdateData();
               this.FMonster.UpdateView();
               this.FMonster.visible = true;
            }
            else
            {
               this.FMonster.visible = false;
            }
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_FightRet,this.PerformPacket_SC_FightPet_FightingMonsterRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_InspireRet,this.PerformPacket_SC_FightPet_InspireRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_IsDie,this.PerformPacket_SC_FightPet_OnIsDie);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_MonsterInfo,this.PerformPacket_SC_FightPet_MonsterInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_PlayerCount,this.PerformPacket_SC_FightPet_PlayerCount);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_RankUpdate,this.PerformPacket_SC_FightPet_RankRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_ResurrectionRet,this.PerformPacket_SC_ResurrectionRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_GameOver,this.PerformPacket_SC_GameOver);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightPet_RebornNotify,this.PerformPacket_SC_RebornNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_NewRoleNtf,this.PacketPerform_SC_TOWN_NewRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_RoleMove,this.PacketPerform_SC_TOWN_RoleMove);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_RemoveRole,this.PacketPerform_SC_RemoveTownRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_UpdateRole,this.PacketPerform_UpdateTownRole);
      }
      
      private function PerformPacket_SC_RebornNotify(param1:TPacket) : void
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
      
      private function PerformPacket_SC_GameOver(param1:TPacket) : void
      {
         this.FFightPetData.GameOver = true;
         if(this.FMonster != null)
         {
            this.FMonster.TextFieldName("",0);
            this.FMonster.Release();
            this.FMonster = null;
         }
         this.FBackTownTimeCoolDown.TimingTime = 5;
      }
      
      private function PerformPacket_SC_ResurrectionRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FFightPetData.IsDie = false;
         this.FIsInCD = false;
         this.FLayerOver.Resurrection();
         this.FBackGround.filters = [];
         ++this.FFightPetData.ReviveTimes;
      }
      
      private function PerformPacket_SC_FightPet_RankRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TFightPetRank = null;
         this.FFightPetData.MainPlayerDamage.High = param1.Data.readUnsignedInt();
         this.FFightPetData.MainPlayerDamage.Low = param1.Data.readUnsignedInt();
         this.FFightPetData.ClearRankList();
         _loc2_ = param1.Data.readUnsignedShort();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TFightPetRank();
            _loc4_.Name = TUtilityString.FetchUTF(param1.Data);
            _loc4_.Damage.High = param1.Data.readUnsignedInt();
            _loc4_.Damage.Low = param1.Data.readUnsignedInt();
            this.FFightPetData.TopTenRank[_loc3_] = _loc4_;
            _loc3_++;
         }
         if(this.FLayerOver.IsInitialization)
         {
            this.FLayerOver.RankUpdate(this.FFightPetData);
         }
      }
      
      private function PerformPacket_SC_FightPet_PlayerCount(param1:TPacket) : void
      {
         this.FFightPetData.AllplayerCount = param1.Data.readUnsignedInt();
         if(this.FLayerOver.IsInitialization)
         {
            this.FLayerOver.UpdatePlayerNum(this.FFightPetData.AllplayerCount);
         }
      }
      
      private function PerformPacket_SC_FightPet_MonsterInfo(param1:TPacket) : void
      {
         var _loc2_:TEnemy = null;
         this.FFightPetData.MonsterID = param1.Data.readUnsignedInt();
         this.FFightPetData.MonsterHP = param1.Data.readUnsignedInt();
         this.FFightPetData.MonsterName = TUtilityString.FetchUTF(param1.Data);
         if(this.FMonster == null)
         {
            this.CreateMonster(this.FFightPetData);
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FFightPetData.MonsterID) as TEnemy;
            this.FFightPetData.MonsterTotaleHP = _loc2_.Hp;
            this.FFightPetData.MonsterLV = _loc2_.Level;
         }
         if(this.FLayerOver.IsInitialization)
         {
            this.FLayerOver.UpdateMonster(this.FFightPetData);
         }
      }
      
      private function PerformPacket_SC_FightPet_OnIsDie(param1:TPacket) : void
      {
         var _loc2_:TConfigValue = null;
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_DIECD) as TConfigValue;
         this.FTimeCoolDown.TimingTime = _loc2_.Value as uint;
         this.FFightPetData.IsDie = true;
         this.FIsInCD = true;
         this.FLayerOver.DieCDUpdate(this.FTimeCoolDown.TimingTime);
      }
      
      private function PerformPacket_SC_FightPet_InspireRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FFightPetData.InspireCount = param1.Data.readByte();
         this.FLayerOver.UpdateInspire();
         this.InspireEffectGenerateText();
      }
      
      private function InspireEffectGenerateText() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:String = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = "";
         _loc5_ = 0;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALEUP_PROPERTY) as TConfigValue;
         _loc3_ = _loc1_.Value as Vector.<Object>;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALEUP_POINT) as TConfigValue;
         _loc4_ = _loc1_.Value as Vector.<Object>;
         _loc7_ = _loc3_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(this.FFightPetData.InspireCount == 0)
            {
               _loc5_ = 0;
            }
            else
            {
               _loc5_ = uint(_loc4_[this.FFightPetData.InspireCount - 1][_loc6_]);
            }
            _loc2_ += _loc3_[_loc6_] + "+" + _loc5_.toString() + "%\n";
            _loc6_++;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_09) + _loc2_);
      }
      
      private function PerformPacket_SC_FightPet_FightingMonsterRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIRoleCanMovePlayerRole = null;
         this.FIsInBattle = false;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         TBattleHandle.AutoCloseBattle(this.FAutoBattle);
         this.FIsBack = false;
         this.OnSetStatusType(this,CONST_BATTLE.BattleType_FightPet,CONST_MUSIC.ID_SCENE_FightPet);
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
         _loc3_ = 0;
         while(_loc3_ < this.FCheckTouchRoleVect.length)
         {
            _loc4_ = this.FCheckTouchRoleVect[_loc3_];
            this.FCanMove.InitNewRole(_loc4_);
            _loc3_++;
         }
         this.FCheckTouchRoleVect.length = 0;
      }
      
      protected function OnSetStatusType(param1:Object, param2:int, param3:int) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      private function CreateMainRole() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TRoleCanControl = null;
         var _loc3_:TBaseHero = null;
         _loc1_ = SLogicsCore.Character.Heros.GetHeroByIndex(0);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc1_.Identifier) as TBaseHero;
         _loc2_ = SLogicsCore.PoolUIRoleCanMove.AcquireRoleCanControl(0,0);
         _loc2_.RoleName = _loc1_.Name;
         _loc2_.RoleTemplateID = _loc1_.Identifier;
         _loc2_.MilitaryRank = SLogicsCore.Character.MilitaryRank;
         _loc2_.RebirthNum = _loc1_.RebirthNum;
         this.FMainRole = new TUIRoleCanMovePlayerRoleMainRole(this.FCanMove);
         this.FMainRole.RoleData = _loc2_;
         this.FMainRole.TemplateID = _loc2_.RoleTemplateID;
         this.FMainRole.ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         this.FMainRole.Init();
         this.ChangeMainHeroQuality();
         this.FPet = new TUIRoleCanMovePet(this.FCanMove);
         this.FPet.FollowRole = this.FMainRole;
         this.FMainRole.Pet = this.FPet;
         this.FPet.TemplateID = SLogicsCore.Character.KnifeSoul.CurrentModuleID;
         this.FPet.visible = SLogicsCore.Character.KnifeSoul.IfFight;
         this.FPet.Init();
         this.FCanMove.InitNewRole(this.FMainRole);
         this.FCanMove.MainRole = this.FMainRole;
         this.FBackGround.ScreenRole = this.FMainRole;
         this.FLittleScript.MainRole = this.FMainRole;
      }
      
      protected function UpdateRolePositionSendToServer() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.FIsHitMonst)
         {
            return;
         }
         if(this.FFightPetData.GameOver)
         {
            return;
         }
         if(this.FMonster == null)
         {
            return;
         }
         if(this.FMonster.Direction == -1)
         {
            if(this.FLittleScript.TargetMapX > this.FMonster.MapX + 200)
            {
               return;
            }
         }
         else if(this.FMonster.Direction == 1)
         {
            if(this.FLittleScript.TargetMapX > this.FMonster.MapX)
            {
               return;
            }
         }
         _loc1_ = this.FLittleScript.TargetMapX - this.FPreTargetMapX;
         _loc2_ = this.FLittleScript.TargetMapY - this.FPreTargetMapY;
         _loc3_ = _loc1_ * _loc1_ + _loc2_ * _loc2_;
         if(_loc3_ > FSendToServerPositionMinimumSpacing)
         {
            this.FPreTargetMapX = this.FLittleScript.TargetMapX;
            this.FPreTargetMapY = this.FLittleScript.TargetMapY;
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
      
      private function CreateMonster(param1:TFightPet) : void
      {
         var _loc2_:TEnemy = null;
         var _loc3_:TRoleModel = null;
         var _loc4_:String = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,param1.MonsterID) as TEnemy;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc2_.Identifier) as TRoleModel;
         this.FFightPetData.MonsterModleID = _loc3_.Model;
         this.FMonster = new TUIRoleCanMoveMonster(this.FCanMove);
         this.FCanMove.addChild(this.FMonster);
         this.FMonster.TemplateID = this.FFightPetData.MonsterModleID;
         this.FMonster.ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby);
         this.FMonster.OnArriveTarget = this.MonsterStop;
         this.FMonster.StopToBattleIdle();
         this.FMonster.MapX = Monster_MapX;
         this.FMonster.MapY = Monster_MapY;
         _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_03),param1.MonsterName);
         this.FMonster.TextFieldName(_loc4_,4294967295);
         this.FMonster.ChangeDirection(CONST_MainScene.DIRECTION_Left);
      }
      
      private function MonsterStop() : void
      {
         this.FMonster.StopToBattleIdle();
      }
      
      private function MonsterMove() : void
      {
         this.FMonster.SetupTargetPosition(Math.random() * (1300 - 950) + 950,Math.random() * (600 - 415) + 415,CONST_MainScene.RoleMoveSpeed);
         this.FTime = STimingCore.TickCount;
      }
      
      private function EnterFightReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         this.FIsInBattle = true;
         this.FCanMove.InitNewRole(this.FMainRole);
         this.FPreTargetMapX = 0;
         this.FPreTargetMapY = 0;
         this.FIsHitMonst = false;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FightPet_FightReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.FCanMove.visible = false;
         if(this.FOnSetBattleBackground != null)
         {
            this.FOnSetBattleBackground(this,this.GetSceneBitmapData());
         }
         this.FCanMove.visible = true;
      }
      
      private function ProcessorResourcesOnLoadCompleted(param1:Object) : void
      {
         this.FCanMove.visible = true;
      }
      
      private function SetResurrectionStatue() : void
      {
         this.FFightPetData.IsDie = false;
         this.FBackGround.filters = [];
      }
      
      private function ChangeRolePositionByMouse() : void
      {
         this.UpdateRolePositionSendToServer();
      }
      
      private function OnStarRun() : void
      {
         this.FIsStarRun = true;
      }
      
      private function OnResurrection() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FightPet_ResurrectionReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      private function OnMoraleUp() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FightPet_InspireReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function TryRunToMonster() : void
      {
         if(this.FMainRole != null && this.FAutoRun && this.FIfCanAutoRun)
         {
            this.FMainRole.SetupTargetPosition(Monster_MapX,Monster_MapY,CONST_MainScene.RoleMoveSpeed);
         }
      }
      
      private function WindowInformationOnOK(param1:Object) : void
      {
         this.BackTownFun();
      }
      
      private function BackTownFun() : void
      {
         this.FCanMove.ClearAllRole();
         if(this.FMonster != null)
         {
            this.FMonster.TextFieldName("",0);
            this.FMonster.Release();
            this.FMonster = null;
         }
         if(this.FMainRole != null)
         {
            this.FCanMove.removeChild(this.FMainRole);
            this.FMainRole.RoleData.StubReferences.Dereference(this);
            this.FMainRole = null;
         }
         if(this.FPet != null)
         {
            this.FCanMove.removeChild(this.FPet);
            this.FPet = null;
         }
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(this);
         }
         if(this.FOnUnLoadBattleResources != null)
         {
            this.FOnUnLoadBattleResources(this,true);
         }
         this.FFightPetData.GameOver = false;
         this.FFightPetData.IsDie = false;
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
         if(this.FMonster != null)
         {
            SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(this.FMonster.TemplateID,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby));
            SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(this.FMonster.TemplateID,CONST_ROLE.ROLE_SEQUENCEINDEX_NormalRun));
         }
      }
      
      private function PacketPerform_SC_TOWN_NewRole(param1:TPacket) : void
      {
         this.FCanMove.AddNewCanControlRole(param1);
      }
      
      private function PacketPerform_SC_TOWN_RoleMove(param1:TPacket) : void
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
      
      private function PacketPerform_SC_RemoveTownRole(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         this.FCanMove.PlayerRemove(_loc2_,_loc3_);
      }
      
      private function PacketPerform_UpdateTownRole(param1:TPacket) : void
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
      
      private function DataInit(param1:ByteArray) : void
      {
         var _loc2_:TConfigValue = null;
         this.FFightPetData.InspireCount = param1.readShort();
         this.FFightPetData.CDTime = param1.readUnsignedInt();
         this.FFightPetData.TotalCD = param1.readUnsignedInt();
         this.FFightPetData.ReviveTimes = param1.readUnsignedInt();
         this.FLayerOver.FightPetCoolDown = this.FFightPetData.TotalCD;
         this.FTimeCoolDown.TimingTime = this.FFightPetData.CDTime;
         if(this.FTimeCoolDown.TimingTime > 0)
         {
            this.FIsInCD = true;
         }
         if(this.FConfigValue == null)
         {
            this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         }
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MAPID) as TConfigValue;
         this.FMapId = _loc2_.Value as uint;
         this.FBackGround.SwitchScene(this.FMapId);
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
      
      public function get OnEnterTown() : Function
      {
         return this.FOnEnterTown;
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
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
         if(param1 != null)
         {
            this.DataInit(param1);
         }
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_FIGHTPET;
         if(!FIsResourcesLoadCompleted)
         {
            this.FLittleScript.Load();
            this.FLayerOver.Load();
            return;
         }
         if(this.FMainRole == null)
         {
            this.CreateMainRole();
         }
         this.FIsBack = true;
         this.FIsStarRun = false;
         this.FTime = STimingCore.TickCount;
         this.FLayerOver.Init(this.FFightPetData);
         this.FLayerOver.Visible = true;
         this.ShowAndHide(SLogicsCore.IsShowAllUser);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_FightPet,CONST_MUSIC.ID_SCENE_FightPet,false);
         TBattleHandle.AutoCloseBattle(this.FAutoBattle);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FCheckTouchRoleVect.length = 0;
      }
      
      public function BattleEnd() : void
      {
         this.FLayerOver.BattleBackUpdate();
         this.FIsBack = true;
         this.FMainRole.MapX = Math.random() * (250 - 100) + 100;
         this.FMainRole.MapY = Math.random() * (600 - 415) + 415;
         this.FPet.MapX = this.FMainRole.MapX - 10;
         this.FPet.MapY = this.FMainRole.MapY + 2;
         this.FPet.ChangeDirection(CONST_MainScene.DIRECTION_RIGHT);
         this.FCanMove.ResetRolePosition();
         if(this.FFightPetData.GameOver)
         {
            this.FBackTownTimeCoolDown.TimingTime = 5;
            if(this.FMonster != null)
            {
               this.FMonster.TextFieldName("",0);
               this.FMonster.Release();
               this.FMonster = null;
            }
         }
         else
         {
            this.FBackGround.filters = [TUtilityFilter.rBlackFilters];
            if(!this.FFightPetData.IsDie)
            {
               this.FBackGround.filters = [];
            }
         }
      }
      
      public function TurnBackTownSceneNtf() : void
      {
         if(this.FUIWindowConfirmation == null)
         {
            this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         }
         if(this.FFightPetData.IsDie)
         {
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_08);
            this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.FUIWindowConfirmation.Visible = false;
            this.BackTownFun();
         }
         if(this.FFightPetData.GameOver)
         {
            this.FUIWindowConfirmation.Visible = false;
            this.BackTownFun();
         }
      }
      
      public function EnterFightPetReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_FightPet);
         _loc2_.Data.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function GetSceneBitmapData() : BitmapData
      {
         var _loc1_:BitmapData = null;
         _loc1_ = new BitmapData(CONST_COMMON.STAGE_Width,CONST_COMMON.STAGE_Height);
         _loc1_.draw(this.FBackGround);
         return _loc1_;
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

