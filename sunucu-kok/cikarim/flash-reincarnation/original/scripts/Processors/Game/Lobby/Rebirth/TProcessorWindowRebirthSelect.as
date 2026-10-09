package Processors.Game.Lobby.Rebirth
{
   import Components.Pages.TUIPage;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowRebirthSelect extends TProcessorLobbyWindow
   {
      
      protected const HeroUINum:uint = 10;
      
      protected var FMainUI:MovieClip;
      
      protected var FPage:TUIPage;
      
      protected var FPageIndex:uint;
      
      protected var FHeroUI:Vector.<THeroSelectCom>;
      
      protected var FData:TRebirthData;
      
      protected var FHero:THero;
      
      protected var FSelectHero:Function;
      
      public function TProcessorWindowRebirthSelect(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.RebirthData;
      }
      
      protected function LocalToGlobal(param1:uint) : uint
      {
         return this.FPageIndex * this.HeroUINum + param1;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:uint = 0;
         var _loc3_:THeroSelectCom = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_RebirthSelect") as MovieClip;
         _loc1_ = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(_loc1_);
         addChild(this.FMainUI);
         this.FMainUI.x = (_loc1_.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (_loc1_.height - this.FMainUI.height) / 2;
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.LabelPage = this.FMainUI["TF_Page"];
         this.FPage.PageSize = this.HeroUINum;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.Reset();
         this.FHeroUI = new Vector.<THeroSelectCom>(this.HeroUINum);
         _loc2_ = 0;
         while(_loc2_ < this.HeroUINum)
         {
            _loc3_ = new THeroSelectCom(this);
            _loc3_.UIDispatch(this.FMainUI["MC_Hero_" + _loc2_]);
            _loc3_.Select = this.Select;
            this.FHeroUI[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FMainUI.BtnClose.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         super.ResourcesPerform_UIDispatch();
      }
      
      public function get Hero() : THero
      {
         return this.FHero;
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
      }
      
      public function set SelectHero(param1:Function) : void
      {
         this.FSelectHero = param1;
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUI();
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function Select(param1:THero) : void
      {
         this.FHero = param1;
         this.FSelectHero();
         ProcessorWindowClose();
      }
      
      public function Reset() : void
      {
         if(this.FMainUI)
         {
            this.FPageIndex = 0;
            this.FPage.SetupPage(SLogicsCore.Character.Heros.Count,this.FPageIndex = 0);
         }
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THeroSelectCom = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         _loc4_ = uint(SLogicsCore.Character.Heros.Count);
         _loc1_ = 0;
         while(_loc1_ < this.HeroUINum)
         {
            _loc2_ = this.LocalToGlobal(_loc1_);
            _loc3_ = this.FHeroUI[_loc1_];
            if(_loc2_ < _loc4_)
            {
               _loc3_.Visible = true;
               _loc5_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc2_);
               _loc3_.Hero = _loc5_;
            }
            else
            {
               _loc3_.Visible = false;
            }
            _loc1_++;
         }
      }
   }
}

