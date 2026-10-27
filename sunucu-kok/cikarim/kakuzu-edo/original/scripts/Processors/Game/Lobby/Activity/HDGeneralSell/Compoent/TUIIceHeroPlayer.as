package Processors.Game.Lobby.Activity.HDGeneralSell.Compoent
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.HDIceHeros.TActivityIHAward;
   import Processors.Game.Lobby.Components.TUIHero;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIIceHeroPlayer extends TUIComponent
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      public static const BuyType_Gold:uint = 0;
      
      public static const BuyType_Score:uint = 1;
      
      protected var FScene:Sprite;
      
      protected var FMC_MountPoint:MovieClip;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_Condition:TextField;
      
      protected var FTF_HeroName:TextField;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FBtnBattleReport:TUIButton;
      
      protected var FUIHero:TUIHero;
      
      protected var FData:TActivityIHAward;
      
      protected var FDataOwned:uint;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FBuyType:uint;
      
      protected var FOnBtnOKClick:Function;
      
      protected var FOnShowHeroClick:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIIceHeroPlayer(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitWindow = false;
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FBuyType = BuyType_Gold;
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:TBounds = null;
         var _loc3_:TCoordinate = null;
         this.FScene = param1;
         this.FSP_AlreadyGet = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FSP_AlreadyGet.mouseChildren = false;
         this.FSP_AlreadyGet.mouseEnabled = false;
         this.FSP_AlreadyGet.visible = false;
         this.FTF_Condition = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_OpenCondition];
         this.FTF_Condition.mouseEnabled = false;
         this.FTF_Condition.text = "";
         this.FTF_HeroName = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_HeroName];
         this.FTF_HeroName.mouseEnabled = false;
         this.FTF_HeroName.text = "";
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.ProcessorBtnOKOnClick;
         this.FBtn_OK.Enabled = false;
         this.FBtnBattleReport = new TUIButton();
         this.FBtnBattleReport.Substrate = this.FScene["Btn_BattleReport"];
         this.FBtnBattleReport.OnClick = this.ProcessorBtnBattleReportOnClick;
         this.FMC_MountPoint = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_MountPoint];
         this.FMC_MountPoint.addChild(this.FUIHero);
         this.FMC_MountPoint.addEventListener(MouseEvent.CLICK,this.ProcessorBtnShowOnClick);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorOnMountPointOver);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorOnMountPointOut);
         _loc2_ = new TBounds();
         _loc3_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc3_,_loc2_);
         this.FUIHero.X = _loc2_.X;
         this.FUIHero.Y = _loc2_.Y;
         this.FIsInitWindow = true;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function ProcessorUpdateUI() : void
      {
         var _loc1_:TBaseHero = null;
         var _loc2_:TKnifeExpand = null;
         var _loc3_:TKnife = null;
         if(this.FData.HeroType == 1)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FData.HeroID) as TBaseHero;
            this.FTF_HeroName.text = _loc1_.Name;
            this.FUIHero.Context = this.FData.HeroID;
         }
         if(this.FData.HeroType == 2)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,this.FData.HeroID) as TKnifeExpand;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc2_.RelationID) as TKnife;
            this.FTF_HeroName.text = _loc3_.Name;
            this.FUIHero.Context = _loc2_.RelationID;
         }
         this.FTF_Condition.text = this.FData.Condition.toString();
         this.FTF_HeroName.width = this.FTF_HeroName.width;
         this.FTF_HeroName.wordWrap = true;
         this.FSP_AlreadyGet.visible = false;
         this.FBtn_OK.Enabled = false;
         if(this.FData.Status == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FSP_AlreadyGet.visible = true;
         }
         else if(this.FDataOwned >= this.FData.Condition)
         {
            this.FData.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
            this.FBtn_OK.Enabled = true;
         }
         else
         {
            this.FData.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         }
      }
      
      protected function DoReset() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         if(this.FUIHero != null)
         {
            this.FUIHero.Context = null;
         }
         this.FTF_Condition.text = "";
         this.FSP_AlreadyGet.visible = false;
         this.FTF_HeroName.text = "";
      }
      
      private function WindowOk(param1:Object) : void
      {
         if(this.FOnBtnOKClick != null)
         {
            this.FOnBtnOKClick(this,this.FData.Index);
         }
      }
      
      protected function ProcessorBtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FBuyType == BuyType_Gold)
         {
            this.FUIWindowConfirmation.visible = true;
            this.FUIWindowConfirmation.OnOK = this.WindowOk;
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FData.Condition);
            return;
         }
         if(this.FOnBtnOKClick != null)
         {
            this.FOnBtnOKClick(this,this.FData.Index);
         }
      }
      
      protected function ProcessorBtnBattleReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.ReportID);
      }
      
      protected function ProcessorBtnShowOnClick(param1:MouseEvent) : void
      {
         if(this.FOnShowHeroClick != null)
         {
            this.FOnShowHeroClick(this,this.FData);
         }
      }
      
      protected function ProcessorOnMountPointOver(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = true;
         this.FMC_MountPoint.filters = Filters;
      }
      
      protected function ProcessorOnMountPointOut(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = false;
         this.FMC_MountPoint.filters = null;
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         if(this.FOnQuerySequenceContext != null)
         {
            this.FOnQuerySequenceContext(param1,param2,param3,param4);
            if(param3.Value != null)
            {
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               param3.Value.Evaluate(_loc6_,_loc5_);
               this.FUIHero.X = _loc5_.X;
               this.FUIHero.Y = _loc5_.Y;
            }
         }
      }
      
      public function get OnBtnOKClick() : Function
      {
         return this.FOnBtnOKClick;
      }
      
      public function set OnBtnOKClick(param1:Function) : void
      {
         this.FOnBtnOKClick = param1;
      }
      
      public function get OnShowHeroClick() : Function
      {
         return this.FOnShowHeroClick;
      }
      
      public function set OnShowHeroClick(param1:Function) : void
      {
         this.FOnShowHeroClick = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get SequenceDefaultRole() : TAnimationSequence
      {
         return this.FUIHero.SequenceDefaultRole;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FUIHero.SequenceDefaultRole = param1;
         }
      }
      
      override public function set X(param1:int) : void
      {
         if(this.FScene != null)
         {
            this.FScene.x = param1;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FScene != null)
         {
            this.FScene.visible = param1;
         }
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:TActivityIHAward, param2:uint, param3:uint) : void
      {
         this.FData = param1;
         this.FDataOwned = param2;
         this.FBuyType = param3;
         this.ProcessorUpdateUI();
      }
      
      public function Reset() : void
      {
         this.DoReset();
      }
      
      public function UpdateUIHero() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         if(this.FScene.visible && this.FUIHero.Context != null)
         {
            this.FUIHero.Update();
         }
      }
   }
}

