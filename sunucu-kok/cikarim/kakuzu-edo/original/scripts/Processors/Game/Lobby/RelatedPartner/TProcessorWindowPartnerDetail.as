package Processors.Game.Lobby.RelatedPartner
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Map.TMoudleInfor;
   import Logics.RelatedPartner.TRelatedPartnerHero;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Logics.RelatedPartner.TRelatedPartnerHeros;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.RelatedPartner.Component.TItemTabHeros;
   import Processors.Game.Lobby.RelatedPartner.Component.TRenderHeroSkill;
   import Resources.Constants.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowPartnerDetail extends TProcessorWindowPartnerBase
   {
      
      protected static const HeroTab_Num:int = CONST_RELATEDPARTNER.RelatedHeroTab_Num;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FCurTabIndex:int;
      
      protected var FCurPageIndex:int;
      
      protected var FPartnerBins:TBins;
      
      protected var FTabHeros:TItemTabHeros;
      
      protected var FHeros:THeros;
      
      protected var FMCHero:Sprite;
      
      protected var FMCPos:Sprite;
      
      protected var FTFName:TextField;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FHeroDatas:TRelatedPartnerHeros;
      
      protected var FChipCount:int;
      
      protected var FBitmap:Bitmap;
      
      protected var FLinkOnTrain:Function;
      
      protected var FOnShowHeroDescription:Function;
      
      public function TProcessorWindowPartnerDetail(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_PartnerDetail) as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.BtnOnClose;
         this.FTabHeros = new TItemTabHeros(this,this.FMainUI["MC_TabHeros"],HeroTab_Num);
         this.FTabHeros.TabOnSwitch = this.TabHeroOnSwitch;
         this.FTabHeros.PageOnSwitch = this.PageHeroOnSwitch;
         this.FTabHeros.IsShowWarn = false;
         this.FMCHero = this.FMainUI["MC_Hero"];
         this.FMCPos = this.FMCHero["MC_Pos"];
         this.FTFName = this.FMCHero["TF_Name"];
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FBitmap = new Bitmap();
         this.FMCPos.addChild(this.FBitmap);
         FMCAlert = this.FMainUI["MC_Alert"];
         FMCAlert.visible = false;
         FScrollBar = new TScrollBar(this.FMainUI["List_Partner"],220,false,9,30);
         TRelatedPartnerCommon.InitSkillData();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         this.FPartnerBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RelatedPartner);
         this.Show();
      }
      
      protected function RenderUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TConfigValue = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_Material) as TConfigValue;
         this.FChipCount = SLogicsCore.Character.Appliances.GetCountByTempleteID(int(_loc3_.Value));
         if(this.FTabHeros.SelectedHero.IsMain)
         {
            this.FTFName.text = "";
         }
         else
         {
            this.FTFName.text = this.FTabHeros.SelectedHero.Name;
         }
         this.RenderHeroMoudle();
         this.RenderScrollInfo();
      }
      
      protected function RenderHeroMoudle() : void
      {
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FTabHeros.SelectedId,this.FQureyMoudleInfor);
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FTabHeros.SelectedId,this.AutoLoadCallBack);
      }
      
      protected function RenderScrollInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRelatedPartnerHero = null;
         var _loc4_:TRenderHeroSkill = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THero = null;
         var _loc8_:THero = null;
         var _loc9_:THeros = null;
         _loc3_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(this.FTabHeros.SelectedId);
         FScrollBar.Clear();
         if(_loc3_ == null)
         {
            FMCAlert.visible = true;
            return;
         }
         FMCAlert.visible = false;
         _loc7_ = SLogicsCore.Character.MainHero;
         _loc9_ = TRelatedPartnerCommon.GetMountedHeros(false);
         _loc2_ = int(_loc3_.HeroSkills.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TRenderHeroSkill();
            _loc4_.GotoAssistance = OnGotoAssistance;
            _loc4_.GotoPosition = OnGotoPosition;
            _loc4_.GotoTrain = OnGotoTrain;
            _loc4_.GotoUpgrade = OnGotoUpgrade;
            _loc4_.GotoLink = OnGotoLink;
            _loc4_.HintOver = OnHintOver;
            _loc4_.HintOut = OnHintOut;
            _loc4_.BgType = BG_Detail;
            _loc4_.Init();
            if(this.FTabHeros.SelectedId == _loc7_.Identifier)
            {
               _loc8_ = _loc9_.GetHeroByIdentifier(_loc3_.HeroSkills[_loc1_].Partner.ConnectId);
               _loc4_.RenderMainHero(_loc3_.HeroSkills[_loc1_],_loc8_);
            }
            else
            {
               _loc4_.Render(_loc3_.HeroSkills[_loc1_]);
            }
            FScrollBar.AddItem(_loc4_);
            _loc1_++;
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FTabHeros.SelectedId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitmap.bitmapData = _loc5_;
         }
      }
      
      protected function ProcessorShowHero(param1:Object, param2:uint) : void
      {
         if(this.FOnShowHeroDescription != null)
         {
            this.FOnShowHeroDescription(param1,param2);
         }
      }
      
      protected function SortOppQuality(param1:THero, param2:THero) : int
      {
         if(param1.IsMain)
         {
            return -1;
         }
         if(param2.IsMain)
         {
            return 1;
         }
         if(param1.Quality > param2.Quality)
         {
            return -1;
         }
         if(param1.Quality < param2.Quality)
         {
            return 1;
         }
         if(param1.Identifier > param2.Identifier)
         {
            return -1;
         }
         if(param1.Identifier < param2.Identifier)
         {
            return 1;
         }
         return 0;
      }
      
      protected function ConstructHeroData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBaseHero = null;
         var _loc4_:TRelatedPartner = null;
         var _loc5_:THero = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:Vector.<int> = null;
         var _loc9_:int = 0;
         this.FHeros = SLogicsCore.Character.Heros;
         this.FTabHeros.Clear();
         this.FTabHeros.Heros.Add(this.FHeros.GetHeroByIndex(0));
         _loc8_ = new Vector.<int>();
         _loc2_ = this.FHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FHeros.GetHeroByIndex(_loc1_);
            _loc8_.push(_loc5_.Identifier);
            if(_loc5_.Identifier != SLogicsCore.Character.MainHero.Identifier)
            {
               this.FTabHeros.Heros.Add(_loc5_);
            }
            _loc1_++;
         }
         _loc6_ = new Vector.<int>();
         _loc2_ = this.FPartnerBins.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FPartnerBins.GetDatebaseByIndex(_loc1_) as TRelatedPartner;
            if(_loc4_.ConditionStar != 0)
            {
               _loc7_ = _loc6_.indexOf(_loc4_.HeroId);
               if(_loc7_ < 0)
               {
                  _loc6_.push(_loc4_.HeroId);
                  _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc4_.HeroId) as TBaseHero;
                  _loc9_ = _loc8_.indexOf(_loc3_.Identifier);
                  if(_loc9_ == -1)
                  {
                     _loc5_ = new THero(_loc3_.Identifier);
                     _loc5_.Name = _loc3_.Name;
                     _loc5_.Quality = _loc3_.Quality;
                     this.FTabHeros.GrayHeros.Add(_loc5_);
                  }
               }
            }
            _loc1_++;
         }
         this.FTabHeros.GrayHeros.SortHeros(this.SortOppQuality);
         this.FTabHeros.Heros.SortHeros(this.SortOppQuality);
         this.FTabHeros.Render();
      }
      
      protected function BtnOnGetChip(param1:Object, param2:MouseEvent) : void
      {
         if(this.FLinkOnTrain != null)
         {
            this.FLinkOnTrain(this.FCurTabIndex,this.FCurPageIndex);
            ProcessorWindowClose();
         }
      }
      
      protected function TabHeroOnSwitch(param1:int) : void
      {
         this.FCurTabIndex = param1;
         this.RenderUI();
      }
      
      protected function PageHeroOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurPageIndex = param2;
         this.RenderUI();
      }
      
      protected function BtnOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function get OnTrainLink() : Function
      {
         return this.FLinkOnTrain;
      }
      
      public function set OnTrainLink(param1:Function) : void
      {
         this.FLinkOnTrain = param1;
      }
      
      public function set OnShowHeroDescription(param1:Function) : void
      {
         this.FOnShowHeroDescription = param1;
      }
      
      public function Show() : void
      {
         this.ConstructHeroData();
         TRelatedPartnerCommon.SkillInfoReq();
         this.Visible = true;
         this.SetHeroData();
      }
      
      public function SetHeroData() : void
      {
         if(TRelatedPartnerCommon.HeroDatas == null)
         {
            return;
         }
         this.FHeroDatas = TRelatedPartnerCommon.HeroDatas;
         if(!this.FHeroDatas.IsInit)
         {
            return;
         }
         this.FTabHeros.SwithTagManual(this.FCurTabIndex);
      }
      
      public function UpdatePage() : void
      {
         this.RenderUI();
      }
      
      public function UpdateHeroInfo(param1:TRelatedPartnerHeroSkill) : void
      {
         UpdateHeroRender(param1);
      }
   }
}

