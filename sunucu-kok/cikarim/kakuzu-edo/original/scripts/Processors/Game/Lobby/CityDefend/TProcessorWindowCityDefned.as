package Processors.Game.Lobby.CityDefend
{
   import Components.ScrollBar.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.CityDefend.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.*;
   import Processors.Game.Battle.TBattleHandle;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   
   public class TProcessorWindowCityDefned extends TProcessorGame
   {
      
      protected static const MAX_COUNT_RANK:uint = 10;
      
      protected static const RankBtn_Organization:uint = 0;
      
      protected static const RankBtn_Hero:uint = 1;
      
      public static var ReportFilters:GlowFilter = new GlowFilter(2818048,1,3,3,10);
      
      protected var FScene:MovieClip;
      
      protected var FUICredits:TUICredits;
      
      protected var FCharacter:TCharacter;
      
      protected var FRankBtnIndex:uint;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FCityDefendData:TCityDefendData;
      
      protected var FHelpTips:THint;
      
      protected var FIconTips:THint;
      
      protected var FReportMcVect:Vector.<MovieClip>;
      
      protected var FDefenderBuff:Vector.<uint>;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FHelpHintOnOver:Function;
      
      protected var FHelpHintOnOut:Function;
      
      public function TProcessorWindowCityDefned(param1:TUIComponent)
      {
         var _loc2_:TConfigValue = null;
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FHelpTips = new THint();
         this.FIconTips = new THint();
         this.FReportMcVect = new Vector.<MovieClip>();
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CityDefend_Defend_Defenderbuff) as TConfigValue;
         this.FDefenderBuff = _loc2_.Value as Vector.<uint>;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FCharacter.RoleSencePosition == CONST_COMMON.SCENEPOSITION_CITYDEFEND)
         {
            this.FUICredits.UpdateEffect();
         }
      }
      
      protected function MakeReportHtmlText(param1:TCityDefendReport) : String
      {
         var _loc2_:String = null;
         _loc2_ = "";
         if(param1.IsInitiative)
         {
            if(param1.IsWin)
            {
               _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_03);
            }
            else
            {
               _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_04);
            }
         }
         else if(param1.IsWin)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_05);
         }
         else
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_06);
         }
         _loc2_ = _loc2_.split("%who%").join(param1.UserName);
         return _loc2_.split("%count%").join(int(param1.LastHp * 100));
      }
      
      protected function OnOrganizationRankClick(param1:MouseEvent) : void
      {
         if(Boolean(param1.currentTarget) && !param1.currentTarget.buttonMode)
         {
            return;
         }
         this.RankBtnIndex = RankBtn_Organization;
         this.UpdataRankUI();
      }
      
      protected function OnHeroRankClick(param1:MouseEvent) : void
      {
         if(Boolean(param1.currentTarget) && !param1.currentTarget.buttonMode)
         {
            return;
         }
         this.RankBtnIndex = RankBtn_Hero;
         this.UpdataRankUI();
      }
      
      protected function OnHintMove(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:TOrganizationBase = null;
         if(param1.currentTarget.name == "mc_attackBuff")
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_10);
            _loc3_ = this.FCityDefendData.BoomLevel;
            _loc2_ = _loc2_.split("%count%").join(_loc3_);
            this.FIconTips.Caption = _loc2_;
         }
         else if(param1.currentTarget.name == "mc_defendBuff")
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_11);
            _loc3_ = this.FCityDefendData.CityDoorIndex == 0 ? this.FDefenderBuff[0] : this.FDefenderBuff[1];
            _loc2_ = _loc2_.split("%count%").join(_loc3_);
            this.FIconTips.Caption = _loc2_;
         }
         else if(param1.currentTarget.name == "mc_myBuff")
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_12);
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_OrganizationBase,91000000 + this.FCityDefendData.OrganizationBuffLevel) as TOrganizationBase;
            _loc3_ = _loc4_.MuyeguardUpgradeAddition;
            _loc2_ = _loc2_.split("%count%").join((_loc3_ / 10).toFixed(1));
            this.FIconTips.Caption = _loc2_;
         }
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FIconTips);
         }
      }
      
      protected function OnHintOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FIconTips);
         }
      }
      
      protected function OnHintActivityDescMove(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_CITYDEFEND);
         }
         if(this.FHelpHintOnOver != null)
         {
            this.FHelpHintOnOver(this,this.FHelpTips);
         }
      }
      
      protected function OnHintActivityDescOut(param1:MouseEvent) : void
      {
         if(this.FHelpHintOnOut != null)
         {
            this.FHelpHintOnOut(this,this.FHelpTips);
         }
      }
      
      protected function OnReportClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TCityDefendReport = null;
         _loc2_ = uint(param1.currentTarget.parent["Index"]);
         _loc3_ = this.FCityDefendData.ReportList.GetReportByIndex(_loc2_);
         if(_loc3_ == null || TProcessorCityDefend.FightPending || TBattleHandle.IsInBattle || TProcessorCityDefend.StageTransition)
         {
            return;
         }
         var packet:TPacket = SNetworkCore.PacketAcquire(25240701);
         packet.Data.writeUTF(_loc3_.ReportId);
         TProcessorCityDefend.FightPending = true;
         SNetworkCore.Transceiver.PacketTransmit(packet);
      }
      
      protected function GetTextColor(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = CONST_COMMON.QUALITYCOLOR_INDEX[6];
               break;
            case 1:
               _loc2_ = CONST_COMMON.QUALITYCOLOR_INDEX[4];
               break;
            case 2:
               _loc2_ = CONST_COMMON.QUALITYCOLOR_INDEX[3];
         }
         return _loc2_;
      }
      
      protected function set RankBtnIndex(param1:uint) : void
      {
         this.FRankBtnIndex = param1;
         TGameUtil.setButtonMode(this.FScene.btn_OrganizationRank,this.FRankBtnIndex != RankBtn_Organization);
         TGameUtil.setButtonMode(this.FScene.btn_HeroRank,this.FRankBtnIndex != RankBtn_Hero);
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HelpHintOnOver() : Function
      {
         return this.FHelpHintOnOver;
      }
      
      public function set HelpHintOnOver(param1:Function) : void
      {
         this.FHelpHintOnOver = param1;
      }
      
      public function get HelpHintOnOut() : Function
      {
         return this.FHelpHintOnOut;
      }
      
      public function set HelpHintOnOut(param1:Function) : void
      {
         this.FHelpHintOnOut = param1;
      }
      
      public function SetScene(param1:MovieClip) : void
      {
         this.FScene = param1;
         addChild(this.FScene);
      }
      
      public function InitUI(param1:TCityDefendData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         this.FCityDefendData = param1;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FScene.MC_PanelCredits;
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.UpdatePanel();
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = this.FScene["mc_Rank_" + _loc4_];
            _loc2_ = this.GetTextColor(_loc4_);
            _loc5_.tf_name.textColor = _loc2_;
            _loc5_.tf_harm.textColor = _loc2_;
            _loc4_++;
         }
         this.FScene.btn_OrganizationRank.tf_btnInfo.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_01);
         this.FScene.btn_OrganizationRank.tf_btnInfo.mouseEnabled = false;
         this.FScene.btn_OrganizationRank.addEventListener(MouseEvent.CLICK,this.OnOrganizationRankClick);
         this.FScene.btn_HeroRank.tf_btnInfo.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_02);
         this.FScene.btn_HeroRank.tf_btnInfo.mouseEnabled = false;
         this.FScene.btn_HeroRank.addEventListener(MouseEvent.CLICK,this.OnHeroRankClick);
         this.RankBtnIndex = RankBtn_Organization;
         this.FScrollBar = new TScrollBar(this.FScene.mc_reportList,84,true,1,20);
         this.FScene.mc_activity.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintActivityDescMove);
         this.FScene.mc_activity.addEventListener(MouseEvent.ROLL_OUT,this.OnHintActivityDescOut);
         this.FScene.mc_attackBuff.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintMove);
         this.FScene.mc_attackBuff.addEventListener(MouseEvent.ROLL_OUT,this.OnHintOut);
         this.FScene.mc_defendBuff.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintMove);
         this.FScene.mc_defendBuff.addEventListener(MouseEvent.ROLL_OUT,this.OnHintOut);
         this.FScene.mc_myBuff.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintMove);
         this.FScene.mc_myBuff.addEventListener(MouseEvent.ROLL_OUT,this.OnHintOut);
      }
      
      public function UpdataRankUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TCityDefendRank = null;
         var _loc3_:TCityDefendRanks = null;
         var _loc4_:MovieClip = null;
         if(this.FRankBtnIndex == RankBtn_Organization)
         {
            _loc3_ = this.FCityDefendData.OrganizationRank;
         }
         else
         {
            _loc3_ = this.FCityDefendData.HeroRank;
         }
         _loc3_.Sort();
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT_RANK)
         {
            _loc4_ = this.FScene["mc_Rank_" + _loc1_];
            _loc4_.mouseEnabled = false;
            if(_loc1_ < _loc3_.Count)
            {
               _loc4_.visible = true;
               _loc2_ = _loc3_.GetRankByIndex(_loc1_);
               _loc4_.tf_name.text = _loc1_ + 1 + ". " + _loc2_.RankName;
               _loc4_.tf_harm.text = _loc2_.RankHarm;
            }
            else
            {
               _loc4_.visible = false;
            }
            _loc1_++;
         }
      }
      
      public function UpdataReportUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TCityDefendReport = null;
         var _loc4_:MovieClip = null;
         _loc2_ = uint(this.FScrollBar.Count);
         _loc1_ = _loc2_;
         while(_loc1_ < this.FCityDefendData.ReportList.Count)
         {
            _loc3_ = this.FCityDefendData.ReportList.GetReportByIndex(_loc1_);
            if(this.FReportMcVect.length > 0)
            {
               _loc4_ = this.FReportMcVect.pop();
            }
            else
            {
               _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CITYDEFEND.RESOURCE_ClassName_MC_Report) as MovieClip;
               _loc4_.btn_look.addEventListener(MouseEvent.MOUSE_UP,this.OnReportClick);
               _loc4_.tf_info.textColor = 16777062;
               _loc4_.tf_info.filters = [ReportFilters];
               _loc4_.tf_info.width = 197;
               _loc4_.tf_info.height = 19;
               _loc4_.tf_info.selectable = false;
            }
            _loc4_["Index"] = _loc1_;
            _loc4_.tf_info.htmlText = this.MakeReportHtmlText(_loc3_);
            this.FScrollBar.AddItem(_loc4_);
            _loc1_++;
         }
      }
      
      public function DeleteReports() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = uint(this.FScrollBar.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FScrollBar.DelItem(_loc1_) as MovieClip;
            this.FReportMcVect.push(_loc3_);
            _loc1_++;
         }
      }
      
      public function UpdataDoorHp() : void
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         var _loc3_:String = null;
         var _loc4_:String = null;
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_14);
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_15);
         this.FScene.mc_doorInfo.tf_name.text = "Lv." + this.FCityDefendData.WorldLevel + "  " + (this.FCityDefendData.CityDoorIndex == 0 ? _loc3_ : _loc4_) + "\t" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CITYDEFEND_16) + this.FCityDefendData.DefendOrganizationName;
         this.FScene.mc_doorInfo.tf_blood.text = Math.floor(Math.max(this.FCityDefendData.CityDoorCurHp,0)).toFixed(0) + "/" + this.FCityDefendData.CityDoorTotleHp.toFixed(0);
         _loc1_ = this.FCityDefendData.CityDoorCurHp / this.FCityDefendData.CityDoorTotleHp;
         _loc1_ = Math.min(Math.max(0,_loc1_),1);
         this.FScene.mc_doorInfo.mc_blood.scaleX = _loc1_;
         this.FScene.mc_doorInfo.mc_bloodHead.x = this.FScene.mc_doorInfo.mc_blood.x + this.FScene.mc_doorInfo.mc_blood.width;
         _loc2_ = int((1 - _loc1_) / 0.2) + 1;
         this.FScene.mc_doorInfo.mc_blood.gotoAndStop(_loc2_);
      }
   }
}

