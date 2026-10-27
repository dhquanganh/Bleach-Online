package Processors.Game.Lobby.YellowVipBuyBox
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.THD_YDBuyGold;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_YELLOWDIAMON;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowYellowVipBuyGold extends TProcessorLobbyWindow
   {
      
      protected static const LevelNum:int = 6;
      
      public static const WINDOW_Width:int = 710;
      
      public static const WINDOW_Height:int = 403;
      
      public static const MaxNum:int = 999;
      
      protected var FTargetGoldNum:Vector.<TextField>;
      
      protected var FNormalPrice:Vector.<TextField>;
      
      protected var FYellowVipPrice:Vector.<TextField>;
      
      protected var FBuyBtns:Vector.<TUIButton>;
      
      protected var FDredgeYellowDiamon:TUIButton;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FBins:TBins;
      
      public function TWindowYellowVipBuyGold(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_YELLOWDIAMON.RESOURCESID_YELLOWDIAMON);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIButton = null;
         var _loc5_:TextField = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("YellowVipBuyGold") as MovieClip;
         addChild(_loc2_);
         this.FTargetGoldNum = new Vector.<TextField>();
         this.FNormalPrice = new Vector.<TextField>();
         this.FYellowVipPrice = new Vector.<TextField>();
         this.FBuyBtns = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            _loc3_ = _loc2_["Tab" + _loc1_];
            this.FTargetGoldNum.push(_loc3_["TargetGoldNum"]);
            this.FNormalPrice.push(_loc3_["NormalPrice"]);
            this.FYellowVipPrice.push(_loc3_["YellowVipPrice"]);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc3_["BuyBtn"];
            _loc4_.OnClick = this.OnBuyBtnClick;
            this.FBuyBtns.push(_loc4_);
            _loc1_++;
         }
         this.FBtnClose = _loc2_["Btn_Close"];
         this.FDredgeYellowDiamon = new TUIButton();
         this.FDredgeYellowDiamon.Substrate = _loc2_["YellowDiamon"];
         this.FDredgeYellowDiamon.OnClick = this.OpenYellowDiamon;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.Update();
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.OnBtnCloseClick);
         super.ResourcesPerform_UILocations();
      }
      
      protected function Update() : void
      {
         var _loc1_:THD_YDBuyGold = null;
         var _loc2_:int = 0;
         this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HDYDBuyGold);
         _loc2_ = 0;
         while(_loc2_ < this.FBins.Count)
         {
            _loc1_ = this.FBins.GetDatebaseByIndex(_loc2_) as THD_YDBuyGold;
            this.FTargetGoldNum[_loc2_].text = _loc1_.GoldNum.toString();
            this.FNormalPrice[_loc2_].text = _loc1_.NormalPrice.toString();
            this.FYellowVipPrice[_loc2_].text = _loc1_.YellowVipPrice.toString();
            _loc2_++;
         }
      }
      
      protected function OnBuyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FBuyBtns.indexOf(param1 as TUIButton);
         _loc4_ = this.FBins.GetDatebaseByIndex(_loc3_).Identifier;
         SExternalCore.NavigatePayBox(_loc4_);
      }
      
      protected function OnBtnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OpenYellowDiamon(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(SParametersCore.YellowVipUrl);
         SExternalCore.onOpenButton();
      }
      
      protected function TextChange(param1:Event) : void
      {
      }
      
      override public function Load() : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            super.Load();
         }
      }
   }
}

