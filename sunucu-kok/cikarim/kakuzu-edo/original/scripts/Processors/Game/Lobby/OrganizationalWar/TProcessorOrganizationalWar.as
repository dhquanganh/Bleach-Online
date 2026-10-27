package Processors.Game.Lobby.OrganizationalWar
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
   import Logics.DatebaseVO.VO.*;
   import Logics.OrganizationalWar.*;
   import Logics.Streamization.OrganizationalWar.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorOrganizationalWar extends TProcessorLobbyPlate
   {
      
      protected static const RANKNUM:int = 10;
      
      protected var FGoalData:TOrganizationalWarGoalData;
      
      protected var FWindowOrganizationalWar:TProcessorWindowOrganizationalWar;
      
      protected var FWindowOrganizationalWarBattleScene:TProcessorWindowOrganizationalWarScene;
      
      protected var FUnstreamizerOrganizationalWar:TUnstreamizerOrganizationalWar;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FIfSynchronousedRank:Boolean;
      
      protected var FCommandCallBack:Function;
      
      protected var FActivityStatusCallBack:Function;
      
      protected var FWaitBack:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FGetOrganizationalName:Function;
      
      protected var FGetOrgainizatinoLevel:Function;
      
      public function TProcessorOrganizationalWar(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FGoalData = new TOrganizationalWarGoalData();
         this.FWindowOrganizationalWar = new TProcessorWindowOrganizationalWar(this,param2);
         this.FWindowOrganizationalWarBattleScene = new TProcessorWindowOrganizationalWarScene(this);
         this.FUnstreamizerOrganizationalWar = new TUnstreamizerOrganizationalWar();
         this.FWindowOrganizationalWarBattleScene.GoalData = this.FGoalData;
         this.FWindowOrganizationalWar.GoalData = this.FGoalData;
         this.FIfSynchronousedRank = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATIONALWAR.RESOURCESID_Swf_OrganizationalWar);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("OrganizationalWar") as MovieClip;
         addChild(_loc1_);
         this.FWindowOrganizationalWar.UIDispatch(_loc1_);
         this.FWindowOrganizationalWar.CommandRequet = this.CommandRequest;
         addChild(this.FWindowOrganizationalWar);
         this.FWindowOrganizationalWar.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowOrganizationalWar.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowOrganizationalWar.OnEffectText = OnEffectText;
         this.FWindowOrganizationalWar.GobackCity = this.BackToMainSceneRequest;
         this.FWindowOrganizationalWar.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowOrganizationalWar.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowOrganizationalWarBattleScene.UIDispatch(_loc1_);
         this.FWindowOrganizationalWarBattleScene.CommandRequest = this.CommandRequest;
         addChild(this.FWindowOrganizationalWarBattleScene);
         this.FWindowOrganizationalWarBattleScene.OnEffectText = OnEffectText;
         this.FWindowOrganizationalWarBattleScene.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowOrganizationalWarBattleScene.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowOrganizationalWarBattleScene.OnScoreChanged = this.ScoreChanged;
         FParameters.MountPointWindow.addChild(_loc1_["RemindTime"]);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.LoadOrganizationalWarDeplayTable();
         this.FWindowOrganizationalWar.UILocations();
         this.FWindowOrganizationalWarBattleScene.UILocations();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_CommandRet,this.PerformPacket_SC_CommandRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_AddNewRoleRet,this.PerformPacket_SC_AddNewRoleRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_RoleQuit,this.PerformPacket_SC_RoleQuit);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_RoleEnterQueue,this.PerformPacket_SC_RoleEnterQueue);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_FightDataRet,this.PerformPacket_SC_FightDataRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_RankInforRet,this.PerformPacket_SC_RankInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_BattleReportRet,this.PerformPacket_SC_BattleReportRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrganizationWar_PlayerScoreChange,this.PerformPacket_SC_ScoreChanged);
      }
      
      protected function PerformPacket_SC_CommandRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         this.FWaitBack = false;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = int(param1.Data.readUnsignedInt());
         if(_loc3_ == CONST_ORGANIZATIONALWAR.CommandID_SignUp)
         {
            if(this.FActivityStatusCallBack != null)
            {
               this.FActivityStatusCallBack(this,CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE,_loc4_);
            }
         }
         if(this.FCommandCallBack != null)
         {
            this.FCommandCallBack(_loc4_);
            this.FCommandCallBack = null;
         }
      }
      
      protected function PerformPacket_SC_AddNewRoleRet(param1:TPacket) : void
      {
         this.FWindowOrganizationalWarBattleScene.AddNewRole(param1);
         this.CreateOrganizationInfor();
         this.ScoreChanged();
      }
      
      protected function PerformPacket_SC_RoleQuit(param1:TPacket) : void
      {
         this.FWindowOrganizationalWarBattleScene.RoleQuit(param1);
      }
      
      protected function PerformPacket_SC_RoleEnterQueue(param1:TPacket) : void
      {
         this.FWindowOrganizationalWarBattleScene.RoleEnterQueue(param1);
      }
      
      protected function PerformPacket_SC_FightDataRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc6_ = int(param1.Data.readUnsignedByte());
         this.FWindowOrganizationalWarBattleScene.RoleFight(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      protected function PerformPacket_SC_RankInforRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TRankInfor = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TUIOrganizationalWarPlayer = null;
         var _loc9_:TCharacter = null;
         _loc9_ = SLogicsCore.Character;
         _loc2_ = param1.Data;
         _loc4_ = int(_loc2_.readUnsignedShort());
         this.FGoalData.PlayerRankActiveNum = _loc4_;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FGoalData.PlayerRankInfors[_loc3_];
            _loc5_.RankID = _loc3_;
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
            _loc5_.Describtion = this.GetRoleNameByID(_loc6_,_loc7_);
            _loc5_.KeyValue = _loc2_.readUnsignedInt();
            if(_loc9_.Identifier0 == _loc6_ && _loc9_.Identifier1 == _loc7_)
            {
               this.FGoalData.PlayerRank = _loc3_ + 1;
               this.FGoalData.PlayerRecord = _loc5_.KeyValue as uint;
            }
            _loc3_++;
         }
         _loc8_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc9_.Identifier0,_loc9_.Identifier1);
         _loc4_ = int(_loc2_.readUnsignedShort());
         this.FGoalData.OrganizationRankActiveNum = _loc4_;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FGoalData.OrganizationRankInfors[_loc3_];
            _loc5_.RankID = _loc3_;
            _loc6_ = _loc2_.readUnsignedInt();
            _loc5_.Describtion = this.GetOrganizationNameByID(_loc6_);
            _loc5_.KeyValue = _loc2_.readUnsignedInt();
            if(_loc8_.RoleData.OrganizationalID == _loc6_)
            {
               this.FGoalData.OrganizationRank = _loc3_ + 1;
               this.FGoalData.OrganizationRecord = _loc5_.KeyValue as uint;
            }
            _loc3_++;
         }
         this.FWindowOrganizationalWar.RankUpdate();
         this.FIfSynchronousedRank = true;
         this.FGoalData.OrganizationsInfor.length = 0;
         this.FGoalData.OrganizationRole.Clear();
      }
      
      protected function PerformPacket_SC_BattleReportRet(param1:TPacket) : void
      {
         this.FWindowOrganizationalWar.BattleReport(param1);
      }
      
      protected function PerformPacket_SC_ScoreChanged(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TUIOrganizationalWarPlayer = null;
         var _loc8_:TCharacter = null;
         var _loc9_:uint = 0;
         _loc8_ = SLogicsCore.Character;
         _loc3_ = int(param1.Data.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.Data.readUnsignedInt();
            _loc6_ = param1.Data.readUnsignedInt();
            _loc4_ = param1.Data.readUnsignedInt();
            _loc7_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc5_,_loc6_);
            if(_loc7_ != null)
            {
               _loc7_.OrganizationalInfor.Score += _loc4_ - _loc7_.RoleData.TotalScore;
               _loc7_.RoleData.TotalScore = _loc4_;
               if(_loc7_.RoleData.Identifier0 == _loc8_.Identifier0 && _loc7_.RoleData.Identifier1 == _loc8_.Identifier1)
               {
                  this.FGoalData.PlayerRecord = _loc4_;
               }
            }
            _loc2_++;
         }
         _loc7_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc8_.Identifier0,_loc8_.Identifier1);
         this.FGoalData.OrganizationRecord = _loc7_.OrganizationalInfor.Score;
         this.ScoreChanged();
      }
      
      protected function CreateOrganizationInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIOrganizationalWarPlayer = null;
         var _loc3_:TOraganizationalInfor = null;
         this.FGoalData.OrganizationsInfor.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FGoalData.OrganizationRole.Count)
         {
            _loc2_ = this.FGoalData.OrganizationRole.GetRoleByIndex(_loc1_);
            _loc3_ = this.UpdateOrgainzationalInfor(_loc2_.RoleData.OrganizationalID,_loc2_.RoleData.TotalScore);
            _loc2_.OrganizationalInfor = _loc3_;
            _loc1_++;
         }
      }
      
      protected function UpdateOrgainzationalInfor(param1:uint, param2:uint) : TOraganizationalInfor
      {
         var _loc3_:int = 0;
         var _loc4_:TOraganizationalInfor = null;
         _loc3_ = 0;
         while(_loc3_ < this.FGoalData.OrganizationsInfor.length)
         {
            _loc4_ = this.FGoalData.OrganizationsInfor[_loc3_];
            if(_loc4_.ID == param1)
            {
               _loc4_.Score += param2;
               return _loc4_;
            }
            _loc3_++;
         }
         _loc4_ = new TOraganizationalInfor();
         _loc4_.Name = this.GetOrganizationNameByID(param1);
         _loc4_.ID = param1;
         _loc4_.Score = param2;
         this.FGoalData.OrganizationsInfor.push(_loc4_);
         return _loc4_;
      }
      
      protected function EnterOrganizatinoalWarScene(param1:ByteArray) : void
      {
         var _loc2_:TTimeCoolDown = null;
         var _loc3_:Date = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:TBins = null;
         var _loc8_:TOrganizationBase = null;
         if(param1 == null)
         {
            return;
         }
         this.FGoalData.SystemColdDownTime = param1.readUnsignedInt();
         _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_SystemColdTime);
         _loc2_.TimingTime = this.FGoalData.SystemColdDownTime;
         if(this.FGetOrgainizatinoLevel != null)
         {
            _loc5_ = this.FGetOrgainizatinoLevel(CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE);
         }
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         _loc4_ = uint(_loc7_.Count);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc8_ = _loc7_.GetDatebaseByIndex(_loc6_) as TOrganizationBase;
            if(_loc8_.OrgLevel == _loc5_)
            {
               this.FGoalData.OrganizationAdded = _loc8_.MuyebattleUpgradeAddition;
               break;
            }
            _loc6_++;
         }
      }
      
      protected function GetRoleNameByID(param1:uint, param2:uint) : String
      {
         var _loc3_:String = null;
         var _loc4_:TUIOrganizationalWarPlayer = null;
         _loc3_ = "";
         _loc4_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(param1,param2);
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_.RoleData.Name;
         }
         return _loc3_;
      }
      
      protected function GetOrganizationNameByID(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc3_:TPacket = null;
         if(this.FGetOrganizationalName != null)
         {
            _loc2_ = this.FGetOrganizationalName(this,param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
            this.RequestOrganizationalName();
         }
         return "";
      }
      
      protected function RequestOrganizationalName() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_LoadGulidListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function BackToMainSceneRequest(param1:Object) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(this);
         }
         this.FWindowOrganizationalWarBattleScene.BackToTown();
      }
      
      protected function SortMethod(param1:TOraganizationalInfor, param2:TOraganizationalInfor) : int
      {
         if(param1.Score < param2.Score)
         {
            return 1;
         }
         if(param1.Score > param2.Score)
         {
            return -1;
         }
         return 0;
      }
      
      protected function ScoreChanged() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TRankInfor = null;
         var _loc3_:TUIOrganizationalWarPlayer = null;
         var _loc4_:TOraganizationalInfor = null;
         var _loc5_:int = 0;
         var _loc6_:TCharacter = null;
         _loc6_ = SLogicsCore.Character;
         if(this.FIfSynchronousedRank)
         {
            return;
         }
         this.FGoalData.OrganizationsInfor.sort(this.SortMethod);
         this.FGoalData.OrganizationRole.ScoreSort();
         _loc5_ = this.FGoalData.OrganizationRole.Count;
         _loc5_ = _loc5_ > RANKNUM ? RANKNUM : _loc5_;
         this.FGoalData.PlayerRankActiveNum = _loc5_;
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc2_ = this.FGoalData.PlayerRankInfors[_loc1_];
            _loc3_ = this.FGoalData.OrganizationRole.GetRoleByIndex(_loc1_);
            _loc2_.RankID = _loc1_;
            _loc2_.Describtion = _loc3_.RoleData.Name;
            _loc2_.KeyValue = _loc3_.RoleData.TotalScore;
            _loc1_++;
         }
         _loc1_ = this.FGoalData.OrganizationRole.IndexOfIndentifier(_loc6_.Identifier0,_loc6_.Identifier1);
         this.FGoalData.PlayerRank = _loc1_ + 1;
         _loc5_ = int(this.FGoalData.OrganizationsInfor.length);
         _loc5_ = _loc5_ > RANKNUM ? RANKNUM : _loc5_;
         this.FGoalData.OrganizationRankActiveNum = _loc5_;
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc2_ = this.FGoalData.OrganizationRankInfors[_loc1_];
            _loc4_ = this.FGoalData.OrganizationsInfor[_loc1_];
            _loc2_.RankID = _loc1_;
            _loc2_.Describtion = _loc4_.Name;
            _loc2_.KeyValue = _loc4_.Score;
            _loc1_++;
         }
         _loc3_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc6_.Identifier0,_loc6_.Identifier1);
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc4_ = this.FGoalData.OrganizationsInfor[_loc1_];
            if(_loc4_.ID == _loc3_.RoleData.OrganizationalID)
            {
               this.FGoalData.OrganizationRank = _loc1_ + 1;
            }
            _loc1_++;
         }
         this.FWindowOrganizationalWar.RankUpdate();
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function get GetOrganizationalName() : Function
      {
         return this.FGetOrganizationalName;
      }
      
      public function set GetOrganizationalName(param1:Function) : void
      {
         this.FGetOrganizationalName = param1;
      }
      
      public function set SetDailyActivityStatus(param1:Function) : void
      {
         this.FWindowOrganizationalWarBattleScene.SetDailyActivityStatus = param1;
      }
      
      public function get ActivityStatusCallBack() : Function
      {
         return this.FActivityStatusCallBack;
      }
      
      public function set ActivityStatusCallBack(param1:Function) : void
      {
         this.FActivityStatusCallBack = param1;
      }
      
      public function set GetOrgainizatinoLevel(param1:Function) : void
      {
         this.FGetOrgainizatinoLevel = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         this.EnterOrganizatinoalWarScene(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.RequestOrganizationalName();
         this.CommandRequest(CONST_ORGANIZATIONALWAR.CommandID_RequestInfor,0,null);
         this.FWaitBack = false;
         this.FGoalData.Running = true;
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_ORGANIZATIONWAR;
         this.FWindowOrganizationalWar.visible = true;
         this.FWindowOrganizationalWarBattleScene.visible = true;
         this.FWindowOrganizationalWarBattleScene.ContorlBirthPlace(true);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_OrganizationalWar,CONST_MUSIC.ID_SCENE_OrganizationalWar,false);
      }
      
      override public function Unmount() : void
      {
         this.FWindowOrganizationalWarBattleScene.ContorlBirthPlace(false);
         this.FWindowOrganizationalWar.Reset();
      }
      
      public function CommandRequest(param1:uint, param2:uint, param3:Function) : void
      {
         var _loc4_:TPacket = null;
         this.FCommandCallBack = param3;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OrganizationWar_CommandReq);
         _loc4_.Data.writeUnsignedInt(param1);
         _loc4_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      public function LoadOrganizationalWarDeplayTable() : void
      {
         this.FUnstreamizerOrganizationalWar.Unstreamize(null,this.FGoalData,null);
      }
      
      public function TurnBackTownSceneNtf() : void
      {
         this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_17);
         this.FUIWindowConfirmation.OnOK = this.BackToMainSceneRequest;
         this.FUIWindowConfirmation.Visible = true;
      }
   }
}

