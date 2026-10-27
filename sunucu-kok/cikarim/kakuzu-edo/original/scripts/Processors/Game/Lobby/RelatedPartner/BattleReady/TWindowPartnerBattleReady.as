package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TRelatedPartnerPoint;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TWindowPartnerBattleReady extends TProcessorLobbyWindow
   {
      
      protected static const Tab_Num:int = 2;
      
      protected var FMainUI:Sprite;
      
      protected var FMainTab:TUITab;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBitmap:Bitmap;
      
      protected var FReadyInfo:TViewPartnerReadyInfo;
      
      protected var FReadyGuide:TViewPartnerReadyGuide;
      
      protected var FViewVec:Vector.<TProcessorLobbyWindow>;
      
      protected var FTFPve:TextField;
      
      protected var FPveId:int;
      
      protected var FStarId:int;
      
      protected var FSwitchFunction:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      public function TWindowPartnerBattleReady(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Point = null;
         var _loc2_:int = 0;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_BattleReady) as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.WindowOnClose;
         _loc1_ = new Point();
         this.FBitmap = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChildAt(this.FBitmap,0);
         this.FBitmap.x = -this.FMainUI.localToGlobal(_loc1_).x;
         this.FBitmap.y = -this.FMainUI.localToGlobal(_loc1_).y;
         this.FReadyInfo = new TViewPartnerReadyInfo(this,this.FMainUI["MC_View_0"]);
         this.FReadyInfo.OnSetBattleStatus = this.ReadyOnSetBattleStatus;
         this.FReadyInfo.SwitchFunction = this.ReadyOnSwitchFunction;
         this.FReadyGuide = new TViewPartnerReadyGuide(this,this.FMainUI["MC_View_1"]);
         this.FViewVec = Vector.<TProcessorLobbyWindow>([this.FReadyInfo,this.FReadyGuide]);
         this.FMainTab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < Tab_Num)
         {
            this.FMainTab.SetTabByIndex(this.FMainUI["MC_Tab_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FMainTab.OnSwitch = this.UITabOnSwitch;
         this.FMainTab.Init();
         this.FMainTab.SetTabShowByIndex(0);
         this.FMainTab.SetTabEnabledByIndex(1,false);
         this.FTFPve = this.FMainUI["TF_Pve"];
         this.FTFPve.text = "";
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         this.Show();
      }
      
      protected function WindowOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function UITabOnSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < Tab_Num)
         {
            this.FViewVec[_loc2_].Visible = param1 == _loc2_;
            _loc2_++;
         }
      }
      
      protected function ReadyOnSetBattleStatus(param1:Object, param2:int, param3:int) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
         ProcessorWindowClose();
      }
      
      protected function ReadyOnSwitchFunction() : void
      {
         this.FSwitchFunction();
      }
      
      public function get PveId() : int
      {
         return this.FPveId;
      }
      
      public function set PveId(param1:int) : void
      {
         this.FPveId = param1;
      }
      
      public function get StarId() : int
      {
         return this.FStarId;
      }
      
      public function set StarId(param1:int) : void
      {
         this.FStarId = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get SwitchFunction() : Function
      {
         return this.FSwitchFunction;
      }
      
      public function set SwitchFunction(param1:Function) : void
      {
         this.FSwitchFunction = param1;
      }
      
      public function Show() : void
      {
         var _loc1_:TBaseHero = null;
         var _loc2_:TRelatedPartnerPoint = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerPoint,this.FPveId) as TRelatedPartnerPoint;
         this.FTFPve.text = _loc2_.Name;
         this.FReadyInfo.SetEnemy(_loc2_.Army[0]);
         this.FReadyInfo.Show(this.FPveId,this.FStarId);
         this.FReadyInfo.ProcessorChangePosition();
         this.FMainTab.SwithTagManual(0);
         this.Visible = true;
      }
      
      public function ProcessorChangePosition() : void
      {
         if(this.FReadyInfo.Visible)
         {
            this.FReadyInfo.ProcessorChangePosition();
         }
      }
   }
}

