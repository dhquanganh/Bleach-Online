package Processors.Game.Lobby.TeamBattle
{
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTeamBattleChoose extends TProcessorLobbyWindow
   {
      
      protected static const MODE_TEAMBATTLE_PVE:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
      
      protected static const MODE_TEAMBATTLE_PVP:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FHint:THint;
      
      protected var FBtn_Return:TUIButton;
      
      protected var FMC_TeamBattleChoose:MovieClip;
      
      protected var FBtn_EnterPVE:TUIButton;
      
      protected var FBtn_EnterPVP:TUIButton;
      
      protected var FBtn_AutoPVP:TUIButton;
      
      protected var FBtn_MallHonor:TUIButton;
      
      protected var FTF_PVE_Readme:TextField;
      
      protected var FTF_PVP_Readme:TextField;
      
      protected var FTF_RewardPVECount:TextField;
      
      protected var FTF_RewardPVPCount:TextField;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnReturnTown:Function;
      
      protected var FOnEnterHallPVE:Function;
      
      protected var FOnEnterHallPVP:Function;
      
      protected var FOnAutoPVP:Function;
      
      protected var FOnMallHonor:Function;
      
      public function TProcessorWindowTeamBattleChoose(param1:TUIComponent)
      {
         super(param1);
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FHint = new THint();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleChoose);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         this.FMC_TeamBattleChoose = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_ClassName_MC_TeamBattleChoose) as MovieClip;
         addChild(this.FMC_TeamBattleChoose);
         this.FBtn_Return = new TUIButton();
         this.FBtn_Return.Substrate = this.FMC_TeamBattleChoose[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Return];
         this.FBtn_Return.OnClick = this.Btn_ReturnOnClick;
         _loc1_ = this.FMC_TeamBattleChoose[CONST_TEAMBATTLE.RESOURCE_Link_SP_PanelPVE];
         this.FBtn_EnterPVE = new TUIButton();
         this.FBtn_EnterPVE.Substrate = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_EnterPVE];
         this.FBtn_EnterPVE.OnClick = this.Btn_EnterPVEOnClick;
         this.FTF_PVE_Readme = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_PVE_Readme];
         this.FTF_PVE_Readme.text = "";
         this.FTF_RewardPVECount = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_RewardPVECount];
         this.FTF_RewardPVECount.text = "";
         _loc1_ = this.FMC_TeamBattleChoose[CONST_TEAMBATTLE.RESOURCE_Link_SP_PanelPVP];
         this.FBtn_EnterPVP = new TUIButton();
         this.FBtn_EnterPVP.Substrate = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_EnterPVP];
         this.FBtn_EnterPVP.OnClick = this.Btn_EnterPVPOnClick;
         this.FBtn_EnterPVP.OnMove = this.Btn_EnterPVPOnMove;
         this.FBtn_EnterPVP.OnOut = this.Btn_EnterPVPOnOut;
         this.FBtn_AutoPVP = new TUIButton();
         this.FBtn_AutoPVP.Substrate = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_PVP_Auto];
         this.FBtn_AutoPVP.OnClick = this.Btn_AutoPVPOnClick;
         this.FBtn_MallHonor = new TUIButton();
         this.FBtn_MallHonor.Substrate = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_MallHonor];
         this.FBtn_MallHonor.OnClick = this.Btn_MallHonorOnClick;
         this.FTF_PVP_Readme = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_PVP_Readme];
         this.FTF_PVP_Readme.text = "";
         this.FTF_RewardPVPCount = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_RewardPVPCount];
         this.FTF_RewardPVPCount.text = "";
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_72);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               if(this.FMC_TeamBattleChoose.isPlaying)
               {
                  this.LogicsPerform_EffectStart();
               }
            }
         }
      }
      
      protected function LogicsPerform_EffectStart() : void
      {
         if(this.FMC_TeamBattleChoose.currentFrame == this.FMC_TeamBattleChoose.totalFrames)
         {
            this.FMC_TeamBattleChoose.stop();
            this.ProcessorResize();
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.X = (_loc1_ - this.FMC_TeamBattleChoose.width) / 2;
         this.Y = (_loc2_ - this.FMC_TeamBattleChoose.height) / 2;
      }
      
      protected function ProcessorUpdateUI() : void
      {
         this.FTF_PVE_Readme.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_09);
         this.FTF_PVP_Readme.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_39);
         this.FTF_RewardPVECount.text = this.FTeamBattle.PVERewardCount.toString();
         this.FTF_RewardPVPCount.text = this.FTeamBattle.PVPRewardCount.toString();
         this.FBtn_EnterPVP.Enabled = this.FTeamBattle.PvpStatus;
      }
      
      public function Btn_ReturnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnReturnTown != null)
         {
            this.FOnReturnTown(this);
         }
      }
      
      protected function Btn_EnterPVEOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnEnterHallPVE != null)
         {
            this.FOnEnterHallPVE(this);
         }
      }
      
      protected function Btn_EnterPVPOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnEnterHallPVP != null)
         {
            this.FOnEnterHallPVP(this);
         }
      }
      
      protected function Btn_EnterPVPOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FBtn_EnterPVP.Enabled)
         {
            if(this.FHintOnOver != null)
            {
               this.FHintOnOver(this,this.FHint);
            }
         }
      }
      
      protected function Btn_EnterPVPOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function Btn_AutoPVPOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAutoPVP != null)
         {
            this.FOnAutoPVP(this);
         }
      }
      
      protected function Btn_MallHonorOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnMallHonor != null)
         {
            this.FOnMallHonor(this);
         }
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnReturnTown() : Function
      {
         return this.FOnReturnTown;
      }
      
      public function set OnReturnTown(param1:Function) : void
      {
         this.FOnReturnTown = param1;
      }
      
      public function get OnEnterHallPVE() : Function
      {
         return this.FOnEnterHallPVE;
      }
      
      public function set OnEnterHallPVE(param1:Function) : void
      {
         this.FOnEnterHallPVE = param1;
      }
      
      public function get OnEnterHallPVP() : Function
      {
         return this.FOnEnterHallPVP;
      }
      
      public function set OnEnterHallPVP(param1:Function) : void
      {
         this.FOnEnterHallPVP = param1;
      }
      
      public function get OnAutoPVP() : Function
      {
         return this.FOnAutoPVP;
      }
      
      public function set OnAutoPVP(param1:Function) : void
      {
         this.FOnAutoPVP = param1;
      }
      
      public function get OnMallHonor() : Function
      {
         return this.FOnMallHonor;
      }
      
      public function set OnMallHonor(param1:Function) : void
      {
         this.FOnMallHonor = param1;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FMC_TeamBattleChoose.gotoAndStop(1);
      }
      
      public function Update() : void
      {
         if(!this.FInitialization)return;
         this.FMC_TeamBattleChoose.play();
         this.FBtn_AutoPVP.Enabled = this.FTeamBattle.PvpStatus;
         this.ProcessorUpdateUI();
      }
      
      public function SetPvpStatus(param1:Boolean) : void
      {
         if(this.FInitialization)
         {
            this.FBtn_EnterPVP.Enabled = param1;
            this.FBtn_AutoPVP.Enabled = param1;
         }
      }
      
      public function InvitedToFastTrack(param1:uint) : void
      {
         if(param1 == MODE_TEAMBATTLE_PVE)
         {
            this.Btn_EnterPVEOnClick(this,null);
         }
         else if(param1 == MODE_TEAMBATTLE_PVP)
         {
            this.Btn_EnterPVPOnClick(this,null);
         }
      }
   }
}

