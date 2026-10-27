package Processors.Game.Lobby.RelatedPartner.Component
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TItemTabHeros extends TUIComponent
   {
      
      protected var FMainUI:Sprite;
      
      protected var FHeroNum:int;
      
      protected var FTabHero:TUITab;
      
      protected var FCurrentTabHeroIndex:int;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FHeros:THeros;
      
      protected var FGrayHeros:THeros;
      
      protected var FFirstTabEnabled:Boolean;
      
      protected var FMCWarns:Vector.<Sprite>;
      
      protected var FHint:THint;
      
      protected var FTabOnSwitch:Function;
      
      protected var FPageOnSwitch:Function;
      
      protected var FSelectedId:int;
      
      protected var FIsShowWarn:Boolean;
      
      protected var FSelectedHero:THero;
      
      public function TItemTabHeros(param1:TUIComponent, param2:Sprite, param3:int)
      {
         super(param1);
         this.FMainUI = param2;
         this.FHeroNum = param3;
         this.InitView();
      }
      
      protected function InitView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         this.FMCWarns = new Vector.<Sprite>();
         this.FTabHero = new TUITab(FParent);
         _loc1_ = 0;
         while(_loc1_ < this.FHeroNum)
         {
            this.FTabHero.SetTabByIndex(this.FMainUI["TF_HeroName_" + _loc1_]["Btn_Hero"],_loc1_);
            _loc3_ = this.FMainUI["TF_HeroName_" + _loc1_]["MC_Warn"];
            if(_loc3_ != null)
            {
               _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.WarnOnOver);
               _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.WarnOnOut);
               this.FMCWarns.push(_loc3_);
            }
            _loc1_++;
         }
         this.FTabHero.OnSwitch = this.UITabOnSwitch;
         this.FTabHero.Init();
         _loc2_ = this.FMainUI["MC_HeroPage"];
         this.FUIPage = new TUIPage(FParent);
         this.FUIPage.ButtonPrevious.Substrate = _loc2_["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = _loc2_["MC_PageRight"];
         this.FUIPage.LabelPage = _loc2_["TF_Page"];
         this.FUIPage.PageSize = this.FHeroNum;
         this.FUIPage.OnChangePage = this.UIPageOnSwitch;
         this.FUIPage.Init();
         this.FGrayHeros = new THeros();
         this.FHeros = new THeros();
         this.FHint = new THint();
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_04);
      }
      
      protected function RenderHeroTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         _loc1_ = this.FHeros.Count + this.FGrayHeros.Count;
         this.FUIPage.SetupPage(_loc1_,this.FCurrentPageIndex);
         _loc3_ = this.FCurrentPageIndex * this.FHeroNum;
         _loc4_ = Math.min(_loc3_ + this.FHeroNum,_loc1_);
         this.FFirstTabEnabled = false;
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            if(_loc2_ < this.FHeros.Count)
            {
               _loc6_ = this.FHeros.GetHeroByIndex(_loc2_);
               if(this.FMCWarns.length > 0)
               {
                  this.FMCWarns[_loc5_].visible = false;
               }
            }
            else
            {
               _loc6_ = this.FGrayHeros.GetHeroByIndex(_loc2_ - this.FHeros.Count);
               if(this.FMCWarns.length > 0)
               {
                  this.FMCWarns[_loc5_].visible = this.FIsShowWarn;
               }
            }
            this.FTabHero.SetTabEnabledByIndex(_loc5_,true);
            this.FFirstTabEnabled = true;
            this.FTabHero.SetTabCaptionByIndex(_loc6_.Name,_loc5_,CONST_COMMON.QUALITYCOLOR_INDEX[_loc6_.Quality]);
            this.FTabHero.SetTabShowByIndex(_loc5_);
            _loc2_++;
            _loc5_++;
         }
         _loc2_ = _loc5_;
         while(_loc2_ < this.FHeroNum)
         {
            this.FTabHero.SetTabHideByIndex(_loc2_);
            if(this.FMCWarns.length > 0)
            {
               this.FMCWarns[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function WarnOnOver(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,this.FHint);
      }
      
      protected function WarnOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,this.FHint);
      }
      
      protected function UITabOnSwitch(param1:int) : void
      {
         var _loc2_:THeros = null;
         var _loc3_:int = 0;
         this.FCurrentTabHeroIndex = param1;
         _loc3_ = this.FCurrentPageIndex * this.FHeroNum + param1;
         if(this.FHeros.Count > _loc3_)
         {
            _loc2_ = this.FHeros;
         }
         else
         {
            _loc2_ = this.FGrayHeros;
            _loc3_ -= this.FHeros.Count;
         }
         if(_loc2_.Count > 0)
         {
            this.FSelectedHero = _loc2_.GetHeroByIndex(_loc3_);
            this.FSelectedId = _loc2_.GetHeroByIndex(_loc3_).Identifier;
         }
         else
         {
            this.FSelectedHero = null;
            this.FSelectedId = -1;
         }
         if(this.FTabOnSwitch != null)
         {
            this.FTabOnSwitch(param1);
         }
      }
      
      protected function UIPageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         if(this.FPageOnSwitch != null)
         {
            this.FPageOnSwitch(param1,param2);
         }
         this.RenderHeroTabs();
         if(this.FFirstTabEnabled)
         {
            this.FTabHero.SwithTagManual(0);
         }
      }
      
      public function get TabOnSwitch() : Function
      {
         return this.FTabOnSwitch;
      }
      
      public function set TabOnSwitch(param1:Function) : void
      {
         this.FTabOnSwitch = param1;
      }
      
      public function get PageOnSwitch() : Function
      {
         return this.FPageOnSwitch;
      }
      
      public function set PageOnSwitch(param1:Function) : void
      {
         this.FPageOnSwitch = param1;
      }
      
      public function get TabIndex() : int
      {
         return this.FCurrentTabHeroIndex;
      }
      
      public function get PageIndex() : int
      {
         return this.FCurrentPageIndex;
      }
      
      public function get Heros() : THeros
      {
         return this.FHeros;
      }
      
      public function set Heros(param1:THeros) : void
      {
         this.FHeros = param1;
      }
      
      public function get GrayHeros() : THeros
      {
         return this.FGrayHeros;
      }
      
      public function set GrayHeros(param1:THeros) : void
      {
         this.FGrayHeros = param1;
      }
      
      public function get SelectedId() : int
      {
         return this.FSelectedId;
      }
      
      public function get SelectedHero() : THero
      {
         return this.FSelectedHero;
      }
      
      public function get IsShowWarn() : Boolean
      {
         return this.FIsShowWarn;
      }
      
      public function set IsShowWarn(param1:Boolean) : void
      {
         this.FIsShowWarn = param1;
      }
      
      public function Render() : void
      {
         this.RenderHeroTabs();
      }
      
      public function SwithTagManual(param1:int) : void
      {
         this.FCurrentTabHeroIndex = param1;
         this.FTabHero.SwithTagManual(param1);
      }
      
      public function SwitchPage(param1:int) : void
      {
         this.FCurrentPageIndex = param1;
      }
      
      public function Clear() : void
      {
         this.FHeros.Clear();
         this.FGrayHeros.Clear();
      }
      
      public function GetSelectedStatus(param1:int) : Boolean
      {
         return this.FMCWarns[param1].visible;
      }
   }
}

