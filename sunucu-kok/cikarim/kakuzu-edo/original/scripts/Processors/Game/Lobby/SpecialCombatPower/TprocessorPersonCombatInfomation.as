package Processors.Game.Lobby.SpecialCombatPower
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Utilities.TUtilityString;
   import Logics.FighterDetail.TFighterDetailData;
   import Logics.FighterDetail.TFighterDetails;
   import Logics.SLogicsCore;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_FUNCTIONSWITCH;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SPECIALCOMBATPOWER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TprocessorPersonCombatInfomation extends Sprite
   {
      
      protected const STATE_NOT_ENLIST:int = 1;
      
      protected const STATE_ENLIST:int = 2;
      
      protected const STATE_NOT_ADVANCE:int = 3;
      
      protected const STATE_ADVANCE:int = 4;
      
      protected const Star_Count:int = 7;
      
      protected var FPersonInfoUI:Sprite;
      
      protected var FPowerTxt:TextField;
      
      protected var FAgilityTxt:TextField;
      
      protected var FWitTxt:TextField;
      
      protected var FLifeTxt:TextField;
      
      protected var FFormationTxt:TextField;
      
      protected var FTalentNameTxt:TextField;
      
      protected var FTalentIntroduceTxt:TextField;
      
      protected var FSkillNameTxt:TextField;
      
      protected var FSkillIntroduceTxt:TextField;
      
      protected var FRoleLevelTxt:TextField;
      
      protected var FVIPLevelTxt:TextField;
      
      protected var FCouponTxt:TextField;
      
      protected var FMaterialTxt:TextField;
      
      protected var FAcquireBtn:TUIButton;
      
      protected var FTavernBtn:TUIButton;
      
      protected var FLeftBtn:TUIButton;
      
      protected var FCombatBtn:TUIButton;
      
      protected var FRightBtn:TUIButton;
      
      protected var FRecruitBtn:TUIButton;
      
      protected var FStarLevel:Sprite;
      
      protected var FStarList:Vector.<Sprite>;
      
      protected var FPersonState:MovieClip;
      
      protected var FRoleImageMc:MovieClip;
      
      protected var FData:TFighterDetails;
      
      protected var FAdvanceState:int;
      
      protected var FIndex:int;
      
      protected var FSelectHeroID:int;
      
      protected var FTipsHeroID:int;
      
      protected var FCloseViewFun:Function;
      
      public function TprocessorPersonCombatInfomation(param1:Sprite)
      {
         super();
         this.FPersonInfoUI = param1;
         this.FStarList = new Vector.<Sprite>();
         this.InitUI();
      }
      
      protected function InitUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.FPowerTxt = this.FPersonInfoUI["TF_Power"];
         this.FAgilityTxt = this.FPersonInfoUI["TF_Agility"];
         this.FWitTxt = this.FPersonInfoUI["TF_Wit"];
         this.FLifeTxt = this.FPersonInfoUI["TF_Life"];
         this.FFormationTxt = this.FPersonInfoUI["TF_Formation"];
         this.FTalentNameTxt = this.FPersonInfoUI["TF_Talent_Name"];
         this.FTalentIntroduceTxt = this.FPersonInfoUI["TF_Talent_Introduce"];
         this.FSkillNameTxt = this.FPersonInfoUI["TF_Skill_Name"];
         this.FSkillIntroduceTxt = this.FPersonInfoUI["TF_Skill_Introduce"];
         this.FRoleLevelTxt = this.FPersonInfoUI["TF_RoleLevel"];
         this.FVIPLevelTxt = this.FPersonInfoUI["TF_VipLevel"];
         this.FCouponTxt = this.FPersonInfoUI["TF_Coupon"];
         this.FMaterialTxt = this.FPersonInfoUI["TF_Material"];
         this.FAcquireBtn = new TUIButton();
         this.FAcquireBtn.Substrate = this.FPersonInfoUI["Btn_Acquire"];
         this.FAcquireBtn.OnClick = this.AcquireOnClick;
         this.FTavernBtn = new TUIButton();
         this.FTavernBtn.Substrate = this.FPersonInfoUI["Btn_Tavern"];
         this.FTavernBtn.OnClick = this.TavernOnClick;
         this.FLeftBtn = new TUIButton();
         this.FLeftBtn.Substrate = this.FPersonInfoUI["Btn_Left"];
         this.FLeftBtn.OnClick = this.LeftOnClick;
         this.FLeftBtn.Enabled = false;
         this.FCombatBtn = new TUIButton();
         this.FCombatBtn.Substrate = this.FPersonInfoUI["Btn_Combat"];
         this.FCombatBtn.OnClick = this.CombatOnClick;
         this.FRightBtn = new TUIButton();
         this.FRightBtn.Substrate = this.FPersonInfoUI["Btn_Right"];
         this.FRightBtn.OnClick = this.RightOnClick;
         this.FRecruitBtn = new TUIButton();
         this.FRecruitBtn.Substrate = this.FPersonInfoUI["Btn_Recruit"];
         this.FRecruitBtn.OnClick = this.RecruitOnClick;
         this.FStarLevel = this.FPersonInfoUI["StarLevel"];
         _loc2_ = this.Star_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FStarLevel["Darkstar" + _loc1_];
            _loc3_.visible = false;
            this.FStarList.push(_loc3_);
            _loc1_++;
         }
         if(this.FStarLevel != null)
         {
            this.FStarLevel.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            this.FStarLevel.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
         }
         this.FPersonState = this.FPersonInfoUI["MC_PersonState"];
         this.FPersonState.gotoAndStop(1);
         this.FRoleImageMc = this.FPersonInfoUI["MC_Image"];
      }
      
      protected function ShowHeroInfo(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TFighterDetailData = null;
         var _loc10_:TFighterDetailData = null;
         this.FPowerTxt.text = this.FData.Heros.GetHeroByIndex(param1).BaseAttributePower.toString();
         this.FWitTxt.text = this.FData.Heros.GetHeroByIndex(param1).BaseAttributeIntelligence.toString();
         this.FAgilityTxt.text = this.FData.Heros.GetHeroByIndex(param1).BaseAttributeAgile.toString();
         this.FLifeTxt.text = this.FData.Heros.GetHeroByIndex(param1).BaseAttributeLife.toString();
         this.FFormationTxt.text = this.GetPostion(this.FData.Heros.GetHeroByIndex(param1).Profession);
         this.FTalentNameTxt.text = this.FData.Heros.GetHeroByIndex(param1).TalentName;
         this.FTalentIntroduceTxt.text = this.FData.Heros.GetHeroByIndex(param1).TalentDesc;
         this.FSkillNameTxt.text = this.FData.Heros.GetHeroByIndex(param1).Skill.Name;
         this.FSkillIntroduceTxt.text = this.FData.Heros.GetHeroByIndex(param1).Skill.Description;
         this.FRoleLevelTxt.text = this.FData.GetTFighterDetail(param1).RoleLevel.toString();
         this.FVIPLevelTxt.text = this.FData.GetTFighterDetail(param1).VipLevel.toString();
         _loc7_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FData.GetTFighterDetail(param1).ItemEnlistID));
         _loc5_ = _loc7_ >= this.FData.GetTFighterDetail(param1).ItemEnlistAmount;
         _loc3_ = SLogicsCore.Character.GetMainLevel() >= this.FData.GetTFighterDetail(param1).RoleLevel;
         _loc4_ = SLogicsCore.Character.VipLevel >= this.FData.GetTFighterDetail(param1).VipLevel;
         _loc8_ = int(TUtilityLobby.GetSoulCount(this.FData.GetTFighterDetail(param1).ItemAskID));
         _loc6_ = _loc8_ >= this.FData.GetTFighterDetail(param1).ItemAskAmount;
         _loc2_ = (_loc6_) && _loc3_ && _loc5_ && _loc4_;
         this.FRecruitBtn.Enabled = this.FData.GetTFighterDetail(param1).IsCanEnlist && _loc2_;
         if(_loc5_)
         {
            this.FCouponTxt.htmlText = TUtilityString.Format("<font color=\'#00ff00\'>%0/%1</font>",this.FData.GetTFighterDetail(param1).EnlistPaper + _loc7_,this.FData.GetTFighterDetail(param1).ItemEnlistAmount);
         }
         else
         {
            this.FCouponTxt.htmlText = TUtilityString.Format("<font color=\'#00ff00\'>%0</font><font color=\'#FF0000\'>%1/%2</font>",this.FData.GetTFighterDetail(param1).EnlistPaper,_loc7_,this.FData.GetTFighterDetail(param1).ItemEnlistAmount);
         }
         if(_loc6_)
         {
            this.FMaterialTxt.htmlText = TUtilityString.Format("<font color=\'#00ff00\'>%0/%1</font>",this.FData.GetTFighterDetail(param1).AskNeed + _loc8_,this.FData.GetTFighterDetail(param1).ItemAskAmount);
         }
         else
         {
            this.FMaterialTxt.htmlText = TUtilityString.Format("<font color=\'#00ff00\'>%0</font><font color=\'#FF0000\'>%1/%2</font>",this.FData.GetTFighterDetail(param1).AskNeed,_loc8_,this.FData.GetTFighterDetail(param1).ItemAskAmount);
         }
         if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            _loc9_ = this.FData.GetTFighterDetail(param1);
            _loc10_ = this.FData.GetTFighterDetail(param1 + 1);
            this.SetStarShowState(_loc9_.StarLevel);
         }
         else if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BACK)
         {
            _loc9_ = this.FData.GetTFighterDetail(param1 - 1);
            _loc10_ = this.FData.GetTFighterDetail(param1);
            this.SetStarShowState(_loc10_.StarLevel);
         }
         this.SetRecruitBtnCaption(this.FAdvanceState);
         if(_loc9_.IsCanEnlist && !_loc10_.IsCanEnlist)
         {
            this.SetHeroState(this.STATE_NOT_ENLIST,this.STATE_NOT_ADVANCE);
         }
         else if(!_loc9_.IsCanEnlist && _loc10_.IsCanEnlist)
         {
            this.SetHeroState(this.STATE_ENLIST,this.STATE_NOT_ADVANCE);
         }
         else if(!_loc9_.IsCanEnlist && !_loc10_.IsCanEnlist)
         {
            this.SetHeroState(this.STATE_ENLIST,this.STATE_ADVANCE);
         }
         this.FRoleImageMc.gotoAndStop(param1 + 1);
      }
      
      protected function GetPostion(param1:int) : String
      {
         var _loc2_:String = "";
         if(CONST_CHARACTER.PROFESSION_Agility == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_17);
         }
         if(CONST_CHARACTER.PROFESSION_Defending == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_16);
         }
         if(CONST_CHARACTER.PROFESSION_Intellect == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_18);
         }
         if(CONST_CHARACTER.PROFESSION_Strength == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_17);
         }
         if(CONST_CHARACTER.PROFESSION_Warlock == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_18);
         }
         return _loc2_;
      }
      
      protected function SetHeroState(param1:int, param2:int) : void
      {
         if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            this.FPersonState.gotoAndStop(param1);
         }
         else
         {
            this.FPersonState.gotoAndStop(param2);
         }
      }
      
      protected function SetLeftOrRightState() : void
      {
         if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            this.FLeftBtn.Enabled = false;
            this.FRightBtn.Enabled = true;
         }
         else
         {
            this.FLeftBtn.Enabled = true;
            this.FRightBtn.Enabled = false;
         }
      }
      
      protected function SetStarShowState(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = this.Star_Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStarList[_loc2_].visible = false;
            _loc2_++;
         }
         _loc3_ = param1;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStarList[_loc2_].visible = true;
            _loc2_++;
         }
      }
      
      protected function SetRecruitBtnCaption(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            _loc2_ = int(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_04);
         }
         else
         {
            _loc2_ = int(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_05);
         }
         this.FRecruitBtn.Caption = TUtilityLobby.GetStringByIdentifier(_loc2_);
      }
      
      protected function ShowRecruitMessage(param1:int) : void
      {
         var _loc2_:String = null;
         if(param1 == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_02);
         }
         else
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_03);
         }
         SToolReward.ShowMessage(_loc2_);
      }
      
      protected function AcquireOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_VainTravel);
      }
      
      protected function TavernOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUnlock = null;
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
         _loc3_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_SpecialFighter);
         if(_loc3_.State == TUnlock.UNLOCKSTATE_Unlocked)
         {
            if(this.FCloseViewFun != null)
            {
               this.FCloseViewFun(param1,param2);
            }
         }
      }
      
      protected function LeftOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            return;
         }
         this.FAdvanceState = CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE;
         this.FTipsHeroID = this.FSelectHeroID;
         this.FRightBtn.Enabled = true;
         this.FLeftBtn.Enabled = false;
         --this.FIndex;
         this.ShowHeroInfo(this.FIndex);
      }
      
      protected function CombatOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.GetTFighterDetail(this.FIndex).FightReportAddr);
      }
      
      protected function RightOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BACK)
         {
            return;
         }
         this.FAdvanceState = CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BACK;
         this.FRightBtn.Enabled = false;
         this.FLeftBtn.Enabled = true;
         ++this.FIndex;
         this.FTipsHeroID = this.FData.GetTFighterDetail(this.FIndex).HeroID;
         this.ShowHeroInfo(this.FIndex);
      }
      
      protected function RecruitOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         this.FRecruitBtn.Enabled = false;
         this.FLeftBtn.Enabled = false;
         this.FRightBtn.Enabled = false;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroID_DataReq);
         _loc3_.Data.writeInt(this.FSelectHeroID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FTipsHeroID));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FTipsHeroID));
      }
      
      public function get AdvanceState() : int
      {
         return this.FAdvanceState;
      }
      
      public function set CloseViewFun(param1:Function) : void
      {
         this.FCloseViewFun = param1;
      }
      
      public function get CloseViewFun() : Function
      {
         return this.FCloseViewFun;
      }
      
      public function ClosePanel() : void
      {
      }
      
      public function SetHeroInfomation(param1:TFighterDetails, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TFighterDetailData = null;
         var _loc6_:TFighterDetailData = null;
         this.FSelectHeroID = param3;
         _loc4_ = 2 * param2;
         this.FData = param1;
         _loc5_ = this.FData.GetTFighterDetail(_loc4_);
         _loc6_ = this.FData.GetTFighterDetail(_loc4_ + 1);
         if(_loc5_.IsCanEnlist)
         {
            this.FAdvanceState = 0;
            this.FIndex = _loc4_;
         }
         else
         {
            this.FAdvanceState = 1;
            this.FIndex = _loc4_ + 1;
         }
         this.SetLeftOrRightState();
         this.FTipsHeroID = this.FData.GetTFighterDetail(this.FIndex).HeroID;
         this.ShowHeroInfo(this.FIndex);
      }
      
      public function ClearSetProperty() : void
      {
         if(this.FAdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            this.FLeftBtn.Enabled = false;
            this.FRightBtn.Enabled = true;
            this.FPersonState.gotoAndStop(this.STATE_ENLIST);
         }
         else
         {
            this.FLeftBtn.Enabled = true;
            this.FRightBtn.Enabled = false;
            this.FPersonState.gotoAndStop(this.STATE_ADVANCE);
         }
         this.ShowRecruitMessage(this.FAdvanceState);
         this.ShowHeroInfo(this.FIndex);
      }
   }
}

