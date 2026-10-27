package Processors.Game.Lobby.RelatedPartner
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TRelatedCondition;
   import Logics.DatebaseVO.VO.TRelatedPartnerPoint;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Logics.Streamization.RelatedPartner.VO.TPartnerTrainHeroPointVO;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.RelatedPartner.Component.TRelatedPropertyTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class TProcessorWindowRelatedPartner extends TProcessorLobbyWindow
   {
      
      protected static const Tab_Num:int = 3;
      
      protected static const DetailWindow_Width:int = 585;
      
      protected static const DetailWindow_Height:int = 549;
      
      protected static const PropTip_Width:int = 321;
      
      protected static const PropTip_Height:int = 280;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FMainTab:TUITab;
      
      protected var FViewHero:TProcessorWindowPartnerHeros;
      
      protected var FViewTrain:TProcessorWindowPartnerTrain;
      
      protected var FProcessorWindowDetail:TProcessorWindowPartnerDetail;
      
      protected var FPropertyTip:TRelatedPropertyTip;
      
      protected var FCurIndex:int;
      
      protected var FIsDetailInit:Boolean;
      
      protected var FHint:THint;
      
      protected var FHeroPointInfo:TPartnerTrainHeroPointVO;
      
      protected var FOnAssistance:Function;
      
      protected var FOnAssistanceClose:Function;
      
      protected var FOnShowHeroDescription:Function;
      
      protected var FOnBattleReady:Function;
      
      public function TProcessorWindowRelatedPartner(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_RelatedPartnerWindow) as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.BtnOnClick;
         this.FMainTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < Tab_Num)
         {
            this.FMainTab.SetTabByIndex(this.FMainUI["Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FMainTab.OnSwitch = this.OnTabSwitch;
         this.FMainTab.Init();
         this.FViewHero = new TProcessorWindowPartnerHeros(this);
         this.FViewHero.InitView(this.FMainUI["MC_Main"]["MC_Hero"]);
         this.FViewHero.OnDetail = this.DetailView;
         this.FViewHero.GotoAssistance = this.OnGotoAssistance;
         this.FViewHero.GotoPosition = this.OnGotoPosition;
         this.FViewHero.GotoTrain = this.OnGotoTrain;
         this.FViewHero.GotoUpgrade = this.OnGotoUpgrade;
         this.FViewHero.GotoLink = this.OnGotoLink;
         this.FViewHero.IconOver = this.OnIconOver;
         this.FViewHero.IconOut = this.OnIconOut;
         this.FViewTrain = new TProcessorWindowPartnerTrain(this);
         this.FViewTrain.InitView(this.FMainUI["MC_Main"]["MC_Train"]);
         this.FViewTrain.OnBattleReady = this.TrainOnBattleReady;
         this.FMainTab.SwithTagManual(CONST_RELATEDPARTNER.Tab_Hero);
         this.FProcessorWindowDetail = new TProcessorWindowPartnerDetail(FParent);
         this.FProcessorWindowDetail.OnClose = this.WindowOnClose;
         this.FProcessorWindowDetail.OnShowHeroDescription = this.ProcessorOnShowHeroDescription;
         this.FProcessorWindowDetail.Visible = false;
         this.FProcessorWindowDetail.GotoAssistance = this.OnGotoAssistance;
         this.FProcessorWindowDetail.GotoPosition = this.OnGotoPosition;
         this.FProcessorWindowDetail.GotoTrain = this.OnGotoTrain;
         this.FProcessorWindowDetail.GotoUpgrade = this.OnGotoUpgrade;
         this.FProcessorWindowDetail.GotoLink = this.OnGotoLink;
         this.FProcessorWindowDetail.IconOver = this.OnIconOver;
         this.FProcessorWindowDetail.IconOut = this.OnIconOut;
         this.FProcessorWindowDetail.X = CONST_COMMON.STAGE_Width - DetailWindow_Width >> 1;
         this.FProcessorWindowDetail.Y = CONST_COMMON.STAGE_Height - DetailWindow_Height >> 1;
         this.FPropertyTip = new TRelatedPropertyTip(FParent);
         this.FPropertyTip.X = CONST_COMMON.STAGE_Width - PropTip_Width >> 1;
         this.FPropertyTip.Y = CONST_COMMON.STAGE_Height - PropTip_Height >> 1;
         this.FHint = new THint();
         TRelatedPartnerCommon.InitSkillData();
         this.FCurIndex = -1;
      }
      
      protected function SetPartnerEnabled(param1:Boolean) : void
      {
         this.mouseEnabled = param1;
         this.mouseChildren = param1;
      }
      
      protected function OnGotoAssistance() : void
      {
         this.FMainTab.SwithTagManual(CONST_RELATEDPARTNER.Tab_Assistance);
         this.FProcessorWindowDetail.Close();
      }
      
      protected function OnGotoPosition() : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
      }
      
      protected function OnGotoTrain(param1:int) : void
      {
         this.FMainTab.SwithTagManual(CONST_RELATEDPARTNER.Tab_Train);
         this.FProcessorWindowDetail.Close();
         setTimeout(this.FViewTrain.GotoSelectPoint,100,param1);
      }
      
      protected function OnGotoUpgrade(param1:TRelatedPartnerHeroSkill) : void
      {
         this.FPropertyTip.Show();
         this.FPropertyTip.Render(param1);
      }
      
      protected function OnGotoLink(param1:String) : void
      {
         if(int(param1) == CONST_COMMON.HERO_SOURCE_TAVERN)
         {
            SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
            this.FProcessorWindowDetail.Close();
            this.Close();
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_20));
         }
      }
      
      protected function OnIconOver(param1:int, param2:TRelatedPartnerHeroSkill) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:TRelatedPartnerPoint = null;
         var _loc9_:TRelatedCondition = null;
         var _loc10_:TBaseHero = null;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerPoint,param2.Partner.ConditionPoint) as TRelatedPartnerPoint;
         switch(param1)
         {
            case CONST_RELATEDPARTNER.HintType_Star:
               this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_08),_loc8_.Name,param2.Partner.ConditionStar);
               break;
            case CONST_RELATEDPARTNER.HintType_Unlock:
               _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param2.Partner.HeroId) as TBaseHero;
               _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedCondition,param2.Partner.ConditionId) as TRelatedCondition;
               this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_18),_loc10_.Name,_loc8_.Name,_loc9_.Described);
               break;
            case CONST_RELATEDPARTNER.HintType_Property:
               _loc4_ = int(param2.Skills.length);
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(param2.Skills[_loc3_].Identifier == param2.SkillId)
                  {
                     _loc5_ = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
               if(_loc5_ < _loc4_ - 1)
               {
                  _loc6_ = TRelatedPartnerCommon.GetSkillDesc(param2.Skills[_loc5_ + 1].Identifier);
                  _loc7_ = TRelatedPartnerCommon.GetSkillDesc(param2.Skills[_loc4_ - 1].Identifier);
                  this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_14),_loc6_,_loc7_);
               }
               else
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_1);
               }
               break;
            case CONST_RELATEDPARTNER.HintType_Heroname:
               _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param2.Partner.ConnectId) as TBaseHero;
               if(_loc10_.Source == CONST_COMMON.HERO_SOURCE_TAVERN)
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_22);
               }
               else
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_21);
               }
         }
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,this.FHint);
      }
      
      protected function OnIconOut() : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,this.FHint);
      }
      
      protected function TrainOnBattleReady(param1:int, param2:int) : void
      {
         this.FOnBattleReady(param1,param2);
      }
      
      protected function ProcessorOnShowHeroDescription(param1:Object, param2:uint) : void
      {
         this.FOnShowHeroDescription(param1,param2);
      }
      
      protected function WindowOnClose(param1:Object) : void
      {
         this.SetPartnerEnabled(true);
      }
      
      protected function OnTabSwitch(param1:int) : void
      {
         if(this.FCurIndex > 0 && this.FCurIndex == param1 && this.FCurIndex != CONST_RELATEDPARTNER.Tab_Assistance)
         {
            return;
         }
         this.FCurIndex = param1;
         switch(param1)
         {
            case CONST_RELATEDPARTNER.Tab_Hero:
               this.FViewHero.Visible = true;
               this.FViewTrain.Visible = false;
               this.FOnAssistanceClose();
               this.FViewHero.Render();
               break;
            case CONST_RELATEDPARTNER.Tab_Train:
               this.FViewHero.Visible = false;
               this.FViewTrain.Visible = true;
               this.FOnAssistanceClose();
               this.FViewTrain.Show();
               break;
            case CONST_RELATEDPARTNER.Tab_Assistance:
               this.FViewHero.Visible = false;
               this.FViewTrain.Visible = false;
               this.FOnAssistance(this.FMainUI["MC_Main"]);
         }
         this.FMainTab.SetTabToTopByIndex(this.FCurIndex);
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(!param1 && this.FViewHero != null)
         {
            this.FViewHero.ResetHeroIndex();
         }
      }
      
      protected function DetailView() : void
      {
         this.SetPartnerEnabled(false);
         if(!this.FIsDetailInit)
         {
            this.FProcessorWindowDetail.Load();
            this.FIsDetailInit = true;
         }
         else
         {
            this.FProcessorWindowDetail.Show();
         }
      }
      
      public function get OnAssistance() : Function
      {
         return this.FOnAssistance;
      }
      
      public function set OnAssistance(param1:Function) : void
      {
         this.FOnAssistance = param1;
      }
      
      public function get OnAssistanceClose() : Function
      {
         return this.FOnAssistanceClose;
      }
      
      public function set OnAssistanceClose(param1:Function) : void
      {
         this.FOnAssistanceClose = param1;
      }
      
      public function set TrainStarStatus(param1:int) : void
      {
         this.FViewTrain.StarRewardStatus = param1;
      }
      
      public function set OnShowHeroDescription(param1:Function) : void
      {
         this.FOnShowHeroDescription = param1;
      }
      
      public function get OnBattleReady() : Function
      {
         return this.FOnBattleReady;
      }
      
      public function set OnBattleReady(param1:Function) : void
      {
         this.FOnBattleReady = param1;
      }
      
      public function UpdateTrain(param1:TPartnerTrainHeroPointVO) : void
      {
         this.FHeroPointInfo = param1;
         if(this.FViewTrain != null)
         {
            if(this.FViewTrain.Visible)
            {
               this.FViewTrain.Render(param1);
            }
         }
      }
      
      public function UpdateHeros() : void
      {
         if(this.FViewHero != null && this.FViewHero.Visible)
         {
            this.FViewHero.UpdateHero();
         }
         if(this.FProcessorWindowDetail != null && this.FProcessorWindowDetail.Visible)
         {
            this.FProcessorWindowDetail.SetHeroData();
         }
      }
      
      public function UpdateDetailPage(param1:TRelatedPartnerHeroSkill) : void
      {
         if(this.FViewHero.Visible)
         {
            this.FViewHero.UpdateHeroInfo(param1);
         }
         if(this.FProcessorWindowDetail.Visible)
         {
            this.FProcessorWindowDetail.UpdateHeroInfo(param1);
         }
      }
      
      public function UpdatePropertyTip(param1:TRelatedPartnerHeroSkill) : void
      {
         if(this.FPropertyTip.Visible)
         {
            this.FPropertyTip.Render(param1);
         }
      }
      
      public function Show() : void
      {
         this.Visible = true;
         if(this.FMainTab != null)
         {
            if(this.FCurIndex < 0)
            {
               this.FMainTab.SwithTagManual(0);
            }
            else
            {
               this.FMainTab.SwithTagManual(this.FCurIndex);
            }
         }
      }
   }
}

