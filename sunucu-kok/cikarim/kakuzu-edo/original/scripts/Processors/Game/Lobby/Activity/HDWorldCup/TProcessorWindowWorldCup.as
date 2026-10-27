package Processors.Game.Lobby.Activity.HDWorldCup
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDIceHeros.*;
   import Logics.HDWorldCup.*;
   import Logics.Inventories.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.TUIIceHeroPlayer;
   import Processors.Game.Lobby.Activity.HDWorldCup.Component.TUITeamSelector;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowWorldCup extends TProcessorHDSingleWindowBase
   {
      
      protected var FIsInitWindow:Boolean;
      
      protected var FSelectors:Vector.<TUITeamSelector>;
      
      protected var FCurSelector:uint;
      
      protected var FCurTeam:int;
      
      protected var FTF_HadMoney:TextField;
      
      protected var FBtn_Goto:TUIButton;
      
      protected var FMC_Effect_Left:MovieClip;
      
      protected var FMC_Effect_Right:MovieClip;
      
      protected var FMC_ReturnLv:Vector.<Sprite>;
      
      protected var FMC_Time:Sprite;
      
      protected var FTF_Time:TextField;
      
      protected var FGlowTwos:Vector.<TEffectBaseGlowTwo>;
      
      protected var FGlowTwoLv:TEffectBaseGlowTwo;
      
      protected var UIIceHeroPlayer:TUIIceHeroPlayer;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      protected var FHeroData:TActivityIHAward;
      
      protected var FHD_WorldCup:THDWorldCup;
      
      protected var FData_WorldCup:TActivityWorldCup;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FTeamsSelector:Function;
      
      public function TProcessorWindowWorldCup(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_WorldCup";
         FActivityID = CONST_ACTIVITY_MODE.Activity_WorldCup;
         this.FRoleModelIDs = new Vector.<uint>();
         this.FCurTeam = -1;
         FHint = new THint();
         this.FIsInitWindow = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.UIIceHeroPlayer = new TUIIceHeroPlayer(this);
         this.UIIceHeroPlayer.OnBtnOKClick = this.ProcessorHeroBtnOKOnClick;
         this.UIIceHeroPlayer.OnShowHeroClick = this.ProcessorShowHeroOnClick;
         this.UIIceHeroPlayer.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         this.UIIceHeroPlayer.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.UIIceHeroPlayer.Perform_UIDispatch(FScene["MC_Hero"]);
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.FTF_HadMoney = FScene["TF_HadMoney"];
         this.FBtn_Goto = new TUIButton();
         this.FBtn_Goto.Substrate = FScene["Btn_Goto"];
         this.FBtn_Goto.OnClick = this.BtnGotoLinkOnClcik;
         this.FMC_Effect_Left = FScene["MC_Effect_0"];
         this.FMC_Effect_Left.play();
         this.FMC_Effect_Right = FScene["MC_Effect_1"];
         this.FMC_Effect_Right.play();
         _loc3_ = 5;
         this.FMC_ReturnLv = new Vector.<Sprite>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_ReturnLv[_loc2_] = FScene["MC_Level_" + _loc2_];
            _loc2_++;
         }
         this.FMC_Time = FScene["MC_Time"];
         this.FTF_Time = this.FMC_Time["TF_Time"];
         this.FIsInitWindow = true;
      }
      
      protected function ProcessorHeroBtnOKOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,35);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FHD_WorldCup = FHDActivityConfig as THDWorldCup;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         this.ProcessorFormatTimeCountDown(FActivityAtoms.StartTime + 432000);
         this.FHeroData = new TActivityIHAward(0);
         this.FHeroData.Condition = this.FHD_WorldCup.FinalCost;
         this.FHeroData.HeroType = 1;
         this.FHeroData.HeroID = this.FHD_WorldCup.FinalHero;
         _loc1_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FMC_ReturnLv[_loc2_]["TF_Level"].text = this.FHD_WorldCup.ReturnLevel[_loc2_].toString();
            this.FMC_ReturnLv[_loc2_]["TF_Rate"].text = this.FHD_WorldCup.ReturnRate[_loc2_].toString() + "%";
            _loc2_++;
         }
         if(this.FSelectors == null)
         {
            _loc1_ = 2;
            this.FSelectors = new Vector.<TUITeamSelector>(_loc1_);
            this.FGlowTwos = new Vector.<TEffectBaseGlowTwo>(_loc1_);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.FSelectors[_loc2_] = new TUITeamSelector(this);
               this.FSelectors[_loc2_].Perform_UIDispatch(FScene["MC_Selector_" + _loc2_]);
               this.FSelectors[_loc2_].OnBtnSelectClick = this.ProcessorOnBtnSelectClick;
               this.FSelectors[_loc2_].OnBtnOkClick = this.ProcessorOnBtnOkClick;
               this.FSelectors[_loc2_].OnBtnOkMove = this.ProcessorBtnOnMove;
               this.FSelectors[_loc2_].OnBtnOkOut = this.ProcessorBtnOnOut;
               this.FSelectors[_loc2_].OnBtnOpenClick = this.ProcessorBtnOnOpen;
               this.FGlowTwos[_loc2_] = new TEffectBaseGlowTwo();
               this.FGlowTwos[_loc2_].SetParameters(FScene["MC_Selector_" + _loc2_]["MC_CanPay"]["Btn_OK"],16776960,20,2);
               _loc2_++;
            }
         }
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(this.FHD_WorldCup.OptsAward);
      }
      
      protected function ProcessorBtnOnOpen(param1:Vector.<int>) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,34,0,param1);
      }
      
      protected function ProcessorBtnOnOut() : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      protected function ProcessorBtnOnMove(param1:Object, param2:MouseEvent, param3:int) : void
      {
         if(param2.currentTarget.name == "Btn_Open")
         {
            this.ProcessorOnMove(this,0);
            return;
         }
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FAwardInventories[param3]);
         }
      }
      
      protected function ProcessorOnMove(param1:Object, param2:uint) : void
      {
         FHint.Caption = this.FHD_WorldCup.Selector2Tips;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function ProcessorOnOut(param1:Object, param2:uint) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.UpdateDataBase(param1);
         this.FData_WorldCup = param1 as TActivityWorldCup;
         _loc4_ = 0;
         this.FTF_HadMoney.text = this.FData_WorldCup.Score.toString();
         this.FHeroData.Status = this.FData_WorldCup.FinalStatus;
         _loc2_ = this.FSelectors.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSelectors[_loc3_].UpdateUI(_loc3_,this.FData_WorldCup,this.FHD_WorldCup);
            _loc3_++;
         }
         this.UIIceHeroPlayer.UpdateUI(this.FHeroData,this.FData_WorldCup.Score,TUIIceHeroPlayer.BuyType_Score);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ += this.FData_WorldCup.HadMoney[_loc3_];
            _loc3_++;
         }
         if(this.FGlowTwoLv != null)
         {
            this.FGlowTwoLv.Stop();
            this.FGlowTwoLv = null;
         }
         if(_loc4_ > 0 && this.FGlowTwoLv == null)
         {
         }
         _loc2_ = this.FHD_WorldCup.ReturnLevel.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            FScene["MC_Level_" + (4 - _loc3_)].filters = [];
            if(_loc4_ >= this.FHD_WorldCup.ReturnKey[4 - _loc3_])
            {
               if(this.FGlowTwoLv != null)
               {
                  this.FGlowTwoLv.SetParameters(FScene["MC_Level_" + (4 - _loc3_)],16776960,20,2);
               }
            }
            _loc3_++;
         }
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FWindowShowHero.Hide();
      }
      
      protected function ProcessorShowHeroOnClick(param1:Object, param2:TActivityIHAward) : void
      {
         FScene.mouseChildren = false;
         FScene.mouseEnabled = false;
         this.FWindowShowHero.HeroID = param2.HeroID;
         this.FWindowShowHero.Show();
      }
      
      protected function ProcessorOnBtnOkClick(param1:Object, param2:MouseEvent, param3:int) : void
      {
         var _loc4_:Vector.<int> = null;
         _loc4_ = new Vector.<int>(2);
         this.FCurSelector = param2.currentTarget.parent.parent.name.split("_")[2];
         if(this.FData_WorldCup.Flags[this.FCurSelector] <= 0)
         {
            this.FData_WorldCup.Flags[this.FCurSelector] = this.FCurTeam + 1;
         }
         _loc4_[0] = this.FData_WorldCup.Flags[this.FCurSelector];
         _loc4_[1] = 100 + param3;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,33 + this.FCurSelector,0,_loc4_);
      }
      
      protected function ProcessorOnBtnSelectClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurSelector = param2.currentTarget.parent.parent.name.split("_")[2];
         if(this.FTeamsSelector != null)
         {
            this.FTeamsSelector();
         }
      }
      
      override protected function UpdateUI() : void
      {
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.UIIceHeroPlayer.UpdateUIHero();
         if(this.FGlowTwos != null && this.FGlowTwos.length > 0 && this.FGlowTwos[0] != null)
         {
            this.FGlowTwos[0].Run();
         }
         if(this.FGlowTwos != null && this.FGlowTwos.length > 0 && this.FGlowTwos[1] != null)
         {
            this.FGlowTwos[1].Run();
         }
         if(this.FGlowTwoLv != null)
         {
            this.FGlowTwoLv.Run();
         }
         if(FActivityAtoms != null && STimingCore.ServerTime > FActivityAtoms.StartTime + 432000)
         {
            _loc2_ = 2;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSelectors[_loc1_].UpdateBtnOver();
               _loc1_++;
            }
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         if(_loc8_ == null)
         {
            return;
         }
         _loc9_ = (_loc8_.Model << 8) + CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleModelIDs.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRoleModelIDs.push(param1);
         }
      }
      
      protected function ProcessorFormatTimeCountDown(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.FTF_Time == null)
         {
            return;
         }
         FIsInitCoolingTime = true;
         FEndTime = param1;
         _loc2_ = uint(STimingCore.ServerTime);
         if(param1 - _loc2_ <= 0)
         {
            this.FTF_Time.text = "0";
         }
         else
         {
            this.FTF_Time.text = this.MyFormatTime(param1 - _loc2_);
         }
      }
      
      protected function MyFormatTime(param1:uint) : String
      {
         var _loc2_:int = 0;
         _loc2_ = param1 / TUtilityTiming.CONST_DAY;
         if(_loc2_ > 0)
         {
            return _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TYPE_TIME_Day);
         }
         return TUtilityTiming.fomatTime(param1);
      }
      
      override protected function Reset() : void
      {
         this.FTF_HadMoney.text = "0";
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      public function get TeamsSelector() : Function
      {
         return this.FTeamsSelector;
      }
      
      public function set TeamsSelector(param1:Function) : void
      {
         this.FTeamsSelector = param1;
      }
      
      public function get CurTeam() : int
      {
         return this.FCurTeam;
      }
      
      public function set CurTeam(param1:int) : void
      {
         this.FCurTeam = param1;
      }
      
      public function QueryMonsterCoordinate(param1:TQueryCoordinate) : void
      {
         var _loc2_:TCoordinate = null;
         var _loc3_:Sprite = null;
         _loc3_ = FScene;
         if(_loc3_ != null)
         {
            _loc2_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc3_);
            _loc2_.X = 600;
            _loc2_.Y = 300;
            param1.Value.Assign(_loc2_);
         }
      }
      
      public function UpdateTempFlag() : void
      {
         this.FSelectors[this.FCurSelector].UpdateTempFlag(this.FCurSelector,this.FCurTeam);
      }
   }
}

