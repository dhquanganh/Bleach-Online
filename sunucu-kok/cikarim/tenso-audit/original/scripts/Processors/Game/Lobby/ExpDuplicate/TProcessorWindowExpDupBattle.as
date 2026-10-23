package Processors.Game.Lobby.ExpDuplicate
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.ExpDuplicate.TExpDuplicateData;
   import Logics.ExpDuplicate.VO.TDuplicateVO;
   import Logics.SLogicsCore;
   import Logics.Streamization.ExpDuplicate.TUnstreamizerExpDuplicate;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.TacticalDeployment.TProcessorTacticalDeployment;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.TPeocessorBattleHeadsCom;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowExpDupBattle extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TExpDuplicateData;
      
      protected var FItemVO:TDuplicateVO;
      
      protected var FExpDupItem:TProcessorExpDupItemCom;
      
      protected var FBattleBtn:TUIButton;
      
      protected var FFormationBtn:TUIButton;
      
      protected var FRefreshBtn:TUIButton;
      
      protected var FBattleHeadsCom:TPeocessorBattleHeadsCom;
      
      protected var FUnstreamizer:TUnstreamizerExpDuplicate;
      
      protected var FOnSetBattleStatus:Function;
      
      public function TProcessorWindowExpDupBattle(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.ExpDuplicateData;
         this.FUnstreamizer = new TUnstreamizerExpDuplicate(this.FData);
      }
      
      override protected function LogicsPerform() : void
      {
         if(this.FMainUI != null)
         {
            this.FExpDupItem.LogicsPerform();
            this.FBattleHeadsCom.LogicsPerform();
         }
      }
      
      protected function OnBattleBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_ExpDuplicate,0);
         this.FUnstreamizer.BattleReq(this.FItemVO);
      }
      
      protected function OnFormationBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
         TUtilityLobby.SetReturnWindows(TProcessorTacticalDeployment,TUtilityHyperLink.HyperLink_ExpDuplicate);
      }
      
      protected function OnRefreshBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = this.FData.ConfigValueVO.RefreshPrice.length;
         _loc4_ = Math.min(this.FItemVO.RefreshCount,_loc5_ - 1);
         _loc3_ = uint(this.FData.ConfigValueVO.RefreshPrice[_loc4_]);
         TUtilityLobby.GoldBuy(_loc3_,this.RefreshOK);
      }
      
      protected function GetState() : String
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:TSkillConfig = null;
         _loc1_ = "";
         _loc3_ = this.FItemVO.SkillBuff.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FItemVO.SkillBuff[_loc2_];
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc4_) as TSkillConfig;
            _loc5_ = _loc6_.Desc;
            _loc1_ += _loc5_ + "\n";
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function RefreshOK(param1:Object) : void
      {
         this.FUnstreamizer.RefreshReq(this.FItemVO);
      }
      
      protected function OnWinClose(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_ExpDuplicateBattle") as MovieClip;
         addChild(this.FMainUI);
         this.FExpDupItem = new TProcessorExpDupItemCom(this);
         this.FExpDupItem.UIDispatch(this.FMainUI.MC_Mon);
         this.FBattleBtn = new TUIButton();
         this.FBattleBtn.Substrate = this.FMainUI.Btn_Battle;
         this.FBattleBtn.OnClick = this.OnBattleBtnClick;
         this.FFormationBtn = new TUIButton();
         this.FFormationBtn.Substrate = this.FMainUI.Btn_Formation;
         this.FFormationBtn.OnClick = this.OnFormationBtnClick;
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = this.FMainUI.Btn_Refresh;
         this.FRefreshBtn.OnClick = this.OnRefreshBtnClick;
         this.FBattleHeadsCom = new TPeocessorBattleHeadsCom(this);
         this.FBattleHeadsCom.UIDispatch(this.FMainUI.MC_Heads);
         this.FMainUI.BtnClose.addEventListener(MouseEvent.CLICK,this.OnWinClose);
      }
      
      public function SetData(param1:TDuplicateVO) : void
      {
         this.FItemVO = param1;
         this.Update();
      }
      
      public function Update() : void
      {
         if(this.FItemVO != null)
         {
            this.FExpDupItem.SetData(this.FItemVO);
            this.FMainUI.TF_NeedSilver.text = this.FItemVO.Config.NeedSilver.toString();
            this.FMainUI.TF_State.text = this.GetState();
            this.FBattleHeadsCom.UpdateArmyHead(this.FItemVO.EnemyArmyID);
         }
         if(this.FData.RemainBattle <= 0)
         {
            this.FBattleBtn.Enabled = false;
         }
         else
         {
            this.FBattleBtn.Enabled = true;
         }
         this.FMainUI.TF_RemainBattle.text = this.FData.RemainBattle.toString();
      }
   }
}

