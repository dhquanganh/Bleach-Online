package Processors.Game.MiniBattle
{
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Processors.Game.MiniBattle.BattleControl.TResroucesControl;
   import Processors.Game.MiniBattle.BattleControl.TWarControl;
   import Processors.Game.MiniBattle.Decoder.TUnstreamizerBattleInfor;
   import Processors.Game.MiniBattle.Mode.TMiniBattleInfor;
   import Processors.Game.MiniBattle.Mode.TOneBattle;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MINIBATTLE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ROLE;
   
   public class TProcessorMiniBattle extends TProcessorGame
   {
      
      protected static const State_Unstreamization:int = 0;
      
      protected static const State_Loading:int = 1;
      
      protected static const State_Battleing:int = 2;
      
      protected var FCurrentState:int;
      
      protected var FUnstreamizerBattleInfor:TUnstreamizerBattleInfor;
      
      protected var FMiniBattleInfor:TMiniBattleInfor;
      
      protected var FComponentBackGround:TComponentBackGround;
      
      protected var FComponentEnemyInfor:TComponentEnemyInfor;
      
      protected var FComponentReportTable:TComponentReportTable;
      
      protected var FComponentLoading:TComponentLoading;
      
      protected var FComponentAccountsPVE:TComponentAccountsPVE;
      
      protected var FComponentAccountsPVP:TComponentAccountsPVP;
      
      protected var FWarControl:TWarControl;
      
      protected var FResourceContorl:TResroucesControl;
      
      protected var FTotalResourceNum:int;
      
      protected var FOnBattleShowChat:Function;
      
      protected var FOnMiniBattleReturn:Function;
      
      public function TProcessorMiniBattle(param1:TUIComponent)
      {
         super(param1);
         this.FComponentBackGround = new TComponentBackGround(this);
         this.FComponentBackGround.Visible = true;
         addChild(this.FComponentBackGround);
         this.FWarControl = new TWarControl(this);
         this.FWarControl.OnWarOver = this.CallBack_WarOver;
         this.FWarControl.OneBattleOver = this.CallBack_BattleEnd;
         this.FWarControl.OneBattleStart = this.CallBack_BattleStart;
         this.FResourceContorl = new TResroucesControl();
         this.FComponentEnemyInfor = new TComponentEnemyInfor(this);
         this.FComponentReportTable = new TComponentReportTable(this);
         this.FComponentReportTable.Visible = false;
         this.FComponentLoading = new TComponentLoading(this);
         this.FComponentAccountsPVE = new TComponentAccountsPVE(this);
         this.FComponentAccountsPVE.Visible = false;
         this.FComponentAccountsPVE.OnBtnBackClick = this.ProcessorWindowOnClose;
         this.FComponentAccountsPVP = new TComponentAccountsPVP(this);
         this.FComponentAccountsPVP.Visible = false;
         this.FComponentAccountsPVP.OnBtnBackClick = this.ProcessorWindowOnClose;
         this.FUnstreamizerBattleInfor = new TUnstreamizerBattleInfor();
         this.FMiniBattleInfor = new TMiniBattleInfor();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfBattle.LoadPrimary(CONST_MINIBATTLE.RESOURCESID_MiniBattle);
         SResourcesCore.TexturesSwfBattle.LoadPrimary(2164260866);
         SResourcesCore.TexturesSwfVital.LoadPrimary(CONST_MINIBATTLE.RESOURCESID_BattleLoading);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FComponentEnemyInfor.LoadResource();
         this.FComponentReportTable.LoadResource();
         this.FComponentAccountsPVE.LoadResource();
         this.FComponentAccountsPVP.LoadResource();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         if(this.FCurrentState == State_Loading)
         {
            this.StartLoading();
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FCurrentState == State_Loading && FIsResourcesLoadCompleted)
         {
            this.FComponentLoading.UpdateScheduleInfor(this.FResourceContorl.Count,this.FTotalResourceNum);
            if(this.FResourceContorl.Count == 0)
            {
               this.StartWar();
            }
         }
      }
      
      protected function StartWar() : void
      {
         this.FCurrentState = State_Battleing;
         this.FWarControl.StartWar(this.FMiniBattleInfor);
         if(this.FMiniBattleInfor.BattleType == CONST_MINIBATTLE.MiniBattleType_PVE)
         {
            this.FComponentEnemyInfor.visible = true;
            this.FComponentEnemyInfor.InitEnemy(this.FMiniBattleInfor.BattleID);
            this.FComponentReportTable.AdjustPosition(TComponentReportTable.PositionLeft);
         }
         else
         {
            this.FComponentReportTable.AdjustPosition(TComponentReportTable.PositionLeft);
         }
         if(this.FOnBattleShowChat != null)
         {
            this.FOnBattleShowChat(this);
         }
         this.FComponentReportTable.visible = true;
         this.FComponentLoading.visible = false;
      }
      
      protected function StartLoading() : void
      {
         this.FCurrentState = State_Loading;
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FTotalResourceNum = this.FResourceContorl.Count;
         this.FComponentLoading.UpdateScheduleInfor(this.FTotalResourceNum,this.FTotalResourceNum);
         this.FComponentLoading.Visible = true;
         this.FComponentBackGround.SetBackGround(this.FMiniBattleInfor.MapID);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_MiniBattleHeadInfor_Send,this.PerformPacket_SC_MiniBattleHeadInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_MiniBattleReportInfor_Send,this.PerformPacket_SC_MiniBattleReportInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_MiniBattleResultInfor_Send,this.PerformPacket_SC_MiniBattleResultInfor);
      }
      
      protected function PerformPacket_SC_MiniBattleHeadInfor(param1:TPacket) : void
      {
         this.FMiniBattleInfor.Reset();
         this.FUnstreamizerBattleInfor.UnstreamizationBattleInfor(param1.Data,this.FMiniBattleInfor,null);
      }
      
      protected function PerformPacket_SC_MiniBattleReportInfor(param1:TPacket) : void
      {
         this.FUnstreamizerBattleInfor.UnstreamizationBattleReportInfor(param1.Data,this.FMiniBattleInfor,this.FResourceContorl);
      }
      
      protected function PerformPacket_SC_MiniBattleResultInfor(param1:TPacket) : void
      {
         this.FUnstreamizerBattleInfor.UnstreamizationBattleReward(param1.Data,this.FMiniBattleInfor,null);
         this.StartLoading();
      }
      
      protected function MouduleAllResourceRequest(param1:uint) : void
      {
         this.FResourceContorl.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param1,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby),CONST_COMMON.ResourceType_Model);
         this.FResourceContorl.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param1,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_NormalAttract),CONST_COMMON.ResourceType_Model);
         this.FResourceContorl.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param1,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_SkillAttract),CONST_COMMON.ResourceType_Model);
         this.FResourceContorl.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param1,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Blow),CONST_COMMON.ResourceType_Model);
      }
      
      protected function CallBack_WarOver(param1:Object) : void
      {
         if(this.FMiniBattleInfor.BattleType == CONST_MINIBATTLE.MiniBattleType_PVE)
         {
            this.FComponentAccountsPVE.ShowRewardAccount(this.FMiniBattleInfor);
            this.FComponentAccountsPVE.Visible = true;
         }
         else if(this.FMiniBattleInfor.BattleType == CONST_MINIBATTLE.MiniBattleType_PVP)
         {
            this.FComponentAccountsPVP.ShowRewardAccount(this.FMiniBattleInfor);
            this.FComponentAccountsPVP.Visible = true;
         }
      }
      
      protected function CallBack_BattleStart(param1:Object) : void
      {
         if(this.FMiniBattleInfor.BattleType == CONST_MINIBATTLE.MiniBattleType_PVE)
         {
            this.FComponentEnemyInfor.BattleStart(param1 as TOneBattle);
         }
      }
      
      protected function CallBack_BattleEnd(param1:Object) : void
      {
         if(this.FMiniBattleInfor.BattleType == CONST_MINIBATTLE.MiniBattleType_PVE)
         {
            this.FComponentEnemyInfor.BattleEnd(param1 as TOneBattle);
         }
         this.FComponentReportTable.AppendBattleReport(param1 as TOneBattle);
         this.FComponentReportTable.Visible = true;
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         if(this.FOnMiniBattleReturn != null)
         {
            this.FOnMiniBattleReturn(this);
         }
         this.Reset();
      }
      
      public function get OnBattleShowChat() : Function
      {
         return this.FOnBattleShowChat;
      }
      
      public function set OnBattleShowChat(param1:Function) : void
      {
         this.FOnBattleShowChat = param1;
      }
      
      public function set OnMiniBattleReturn(param1:Function) : void
      {
         this.FOnMiniBattleReturn = param1;
      }
      
      public function Setup() : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            this.Load();
            this.FComponentLoading.Load();
         }
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_TEAMBATTLE;
      }
      
      public function Reset() : void
      {
         this.FComponentLoading.Visible = false;
         this.FComponentLoading.Reset();
         this.FComponentAccountsPVE.Visible = false;
         this.FComponentAccountsPVE.Reset();
         this.FComponentAccountsPVP.Visible = false;
         this.FComponentAccountsPVP.Reset();
         this.FComponentBackGround.Reset();
         this.FComponentReportTable.visible = false;
         this.FComponentReportTable.Reset();
         this.FComponentEnemyInfor.Visible = false;
         this.FComponentEnemyInfor.Reset();
         this.FMiniBattleInfor.Reset();
         this.FResourceContorl.Reset();
         this.FWarControl.Reset();
      }
   }
}

