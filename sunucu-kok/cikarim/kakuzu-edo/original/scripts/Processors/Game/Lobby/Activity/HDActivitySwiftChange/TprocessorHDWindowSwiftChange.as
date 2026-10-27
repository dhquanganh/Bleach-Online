package Processors.Game.Lobby.Activity.HDActivitySwiftChange
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDSwiftChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TprocessorHDWindowSwiftChange extends TProcessorHDSingleWindowBase
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected const CREATE_HERO_COUNT:int = 3;
      
      protected const FSceneWidth:int = 705;
      
      protected const FSceneHeight:int = 705;
      
      protected var FBtn_Goto_Dojo:TUIButton;
      
      protected var FBtn_Goto_DebrisMarket:TUIButton;
      
      protected var FBins:TBins;
      
      protected var FHeroListMc:Vector.<MovieClip>;
      
      protected var FRoleMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FSps:Vector.<Sprite>;
      
      protected var FProcessorHDWindowDebrisMarket:TProcessorHDWindowDebrisMarket;
      
      protected var FLayerMask:Sprite;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FMC_Anima:MovieClip;
      
      protected var FActivitySwiftChangeData:TActivitySwiftChangData;
      
      public function TprocessorHDWindowSwiftChange(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleSwiftChange;
         FActivityID = CONST_ACTIVITY_MODE.Activity_SwiftChange;
         this.FHeroListMc = new Vector.<MovieClip>();
         this.FProcessorHDWindowDebrisMarket = new TProcessorHDWindowDebrisMarket(this);
         this.FProcessorHDWindowDebrisMarket.OnBtnBuyDebris = this.BtnBuyDebrisReq;
         this.FProcessorHDWindowDebrisMarket.OnClose = this.CloseDebrieMarketWindow;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.UIDispatch();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:TSceneSpriteMoudle = null;
         this.FBtn_Goto_Dojo = new TUIButton();
         this.FBtn_Goto_Dojo.Substrate = FScene["Btn_Goto_Dojo"];
         this.FBtn_Goto_Dojo.OnClick = this.OpenDojoViewOnClick;
         this.FBtn_Goto_DebrisMarket = new TUIButton();
         this.FBtn_Goto_DebrisMarket.Substrate = FScene["Btn_DebrisMarket"];
         this.FBtn_Goto_DebrisMarket.OnClick = this.OpenDebrisMarketOnClick;
         this.FRoleMoudles = new Vector.<TSceneSpriteMoudle>();
         this.FQueryModel = new TMoudleInfor();
         this.FSps = new Vector.<Sprite>();
         _loc2_ = this.CREATE_HERO_COUNT;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FScene["MC_HeroList_" + _loc1_];
            _loc4_ = _loc3_["MC_MountPoint"];
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.HeroOnMouseOver);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnMouseOut);
            _loc4_.addEventListener(MouseEvent.CLICK,this.HitHeroClickHandler);
            _loc3_["MC_HeroBG"].visible = false;
            this.FHeroListMc.push(_loc3_);
            this.FSps.push(_loc4_);
            _loc5_ = new TSceneSpriteMoudle();
            this.FRoleMoudles.push(_loc5_);
            _loc4_.addChild(_loc5_);
            _loc1_++;
         }
         FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.x = -x;
         this.FLayerMask.y = -y;
         this.FProcessorHDWindowDebrisMarket.UIDispatch();
         this.FProcessorHDWindowDebrisMarket.x = (this.FSceneWidth - this.FProcessorHDWindowDebrisMarket.width) / 2;
         this.FProcessorHDWindowDebrisMarket.y = (FScene.height - this.FProcessorHDWindowDebrisMarket.height) / 2;
         addChild(this.FProcessorHDWindowDebrisMarket);
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.FMC_Anima = FScene["MC_Anima"];
         this.FMC_Anima.play();
      }
      
      protected function RenderHeroModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSceneSpriteMoudle = null;
         var _loc5_:TBaseHero = null;
         _loc2_ = this.CREATE_HERO_COUNT;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivitySwiftChangeData.HeroList[_loc1_];
            _loc5_ = this.FBins.GetDatebaseByIdentifier(_loc3_) as TBaseHero;
            (this.FHeroListMc[_loc1_]["TF_HeroName"] as TextField).text = _loc5_.Name;
            (this.FHeroListMc[_loc1_]["TF_HeroName"] as TextField).textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc5_.Quality];
            this.FHeroListMc[_loc1_]["MC_AlreadyRecruit"].visible = this.JudgeIsHeroHandler(_loc3_);
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc3_,this.FQueryModel);
            this.FRoleMoudles[_loc1_].ChangeRoleMoudle(this.FQueryModel.TextureID,1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.CREATE_HERO_COUNT)
         {
            _loc1_++;
         }
      }
      
      protected function JudgeIsHeroHandler(param1:int) : Boolean
      {
         var _loc3_:THero = null;
         var _loc2_:Boolean = false;
         _loc3_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1);
         if(_loc3_ == null)
         {
            _loc2_ = false;
         }
         else
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateRoleModel();
         }
      }
      
      protected function UpdateRoleModel() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.CREATE_HERO_COUNT)
         {
            if(this.FRoleMoudles[_loc1_].TextrueID != 0)
            {
               this.FRoleMoudles[_loc1_].UpdateView();
            }
            _loc1_++;
         }
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         this.FWindowShowHero.Hide();
      }
      
      protected function OpenDojoViewOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_ChangeHero);
      }
      
      protected function OpenDebrisMarketOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FProcessorHDWindowDebrisMarket.Show();
         this.FLayerMask.visible = true;
      }
      
      protected function HeroOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSps.indexOf(param1.currentTarget);
         this.FSps[_loc2_].filters = Filters;
      }
      
      protected function HeroOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSps.indexOf(param1.currentTarget);
         this.FSps[_loc2_].filters = null;
      }
      
      protected function HitHeroClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FSps.indexOf(param1.currentTarget);
         _loc3_ = this.FActivitySwiftChangeData.HeroList[_loc2_];
         this.FWindowShowHero.HeroID = _loc3_;
         this.FWindowShowHero.Show();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.FMC_Anima.stop();
      }
      
      protected function BtnBuyDebrisReq(param1:Object, param2:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      protected function CloseDebrieMarketWindow(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      public function set ActivitySwiftChangeData(param1:TActivitySwiftChangData) : void
      {
         this.FActivitySwiftChangeData = param1;
         this.FProcessorHDWindowDebrisMarket.ActivitySwiftChangeData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.RenderHeroModel();
         this.FWindowShowHero.Hide();
         this.FMC_Anima.play();
      }
      
      public function UpdateDebrisMarketView() : void
      {
         this.FProcessorHDWindowDebrisMarket.DebrisList();
      }
   }
}

