package Processors.Game.Lobby.Arena
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Arena.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowArenaList extends TProcessorLobbyWindow
   {
      
      protected var HEROLIST_Count:uint = 10;
      
      protected var FResource:MovieClip;
      
      protected var FArenaHeros:TArenaHeros;
      
      protected var FCurPage:int;
      
      protected var FTotlePage:int;
      
      protected var FMilitaryBins:TBins;
      
      protected var FBT_Left:TUIButton;
      
      protected var FBT_Right:TUIButton;
      
      protected var FOnShowOtherHeroInfor:Function;
      
      public function TProcessorWindowArenaList(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ARENA.RESOURCE_ARENA);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         this.FResource = TUtilityReflection.CreateDisplayObjectInstance(CONST_ARENA.RESOURCE_ClassName_heroPanel_movie) as MovieClip;
         this.addChild(this.FResource);
         this.FBT_Left = new TUIButton();
         this.FBT_Left.Substrate = this.FResource.btn_left;
         this.FBT_Left.OnClick = this.OnLeft;
         this.FBT_Right = new TUIButton();
         this.FBT_Right.Substrate = this.FResource.btn_right;
         this.FBT_Right.OnClick = this.OnRight;
         _loc1_ = 0;
         while(_loc1_ < this.HEROLIST_Count)
         {
            this.FResource["mc_hero_" + _loc1_].buttonMode = true;
            this.FResource["mc_hero_" + _loc1_].mouseChildren = false;
            this.FResource["mc_hero_" + _loc1_].addEventListener(MouseEvent.CLICK,this.OnLookHero);
            this.FResource["mc_hero_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.OnOver);
            this.FResource["mc_hero_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.OnOut);
            _loc1_++;
         }
         this.FResource.bt_close.addEventListener(MouseEvent.CLICK,this.OnCloseList);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function SetHeroData(param1:TArenaHero, param2:MovieClip) : void
      {
         var _loc3_:TMilitary = null;
         if(param2 == null || param1 == null)
         {
            return;
         }
         param2.tf_ranking.text = param1.Ranking.toString();
         param2.tf_name.text = param1.PlayerNick;
         param2.tf_level.text = param1.PlayerLevel.toString();
         _loc3_ = this.FMilitaryBins.GetDatebaseByIdentifier(param1.Military) as TMilitary;
         param2.tf_militaryRank.text = _loc3_.Name;
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.HEROLIST_Count)
         {
            if(_loc1_ + (this.FCurPage - 1) * this.HEROLIST_Count < this.FArenaHeros.Count)
            {
               this.SetHeroData(this.FArenaHeros.GetHeroByIndex(_loc1_ + (this.FCurPage - 1) * this.HEROLIST_Count),this.FResource["mc_hero_" + _loc1_]);
               this.FResource["mc_hero_" + _loc1_].visible = true;
            }
            else
            {
               this.FResource["mc_hero_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function CheckBtn() : void
      {
         this.FBT_Left.Enabled = this.FCurPage > 1;
         this.FBT_Right.Enabled = this.FCurPage < this.FTotlePage;
         this.FResource.tf_page.text = this.FCurPage + "/" + this.FTotlePage;
      }
      
      protected function OnLeft(param1:Object, param2:MouseEvent) : void
      {
         if(!param2.currentTarget.buttonMode)
         {
            return;
         }
         --this.FCurPage;
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         this.UpdataUI();
         this.CheckBtn();
      }
      
      protected function OnRight(param1:Object, param2:MouseEvent) : void
      {
         if(!param2.currentTarget.buttonMode)
         {
            return;
         }
         ++this.FCurPage;
         if(this.FCurPage > this.FTotlePage)
         {
            this.FCurPage = this.FTotlePage;
         }
         this.UpdataUI();
         this.CheckBtn();
      }
      
      protected function OnLookHero(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TArenaHero = null;
         _loc2_ = uint(int(String(param1.currentTarget.name).slice(8)));
         _loc3_ = this.FArenaHeros.GetHeroByIndex(_loc2_ + (this.FCurPage - 1) * this.HEROLIST_Count);
         if(this.FOnShowOtherHeroInfor != null)
         {
            this.FOnShowOtherHeroInfor(this,_loc3_.Identifier0,_loc3_.Identifier1);
         }
      }
      
      private function OnCloseList(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      private function OnOut(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      private function OnOver(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(2);
      }
      
      public function set OnShowOtherHeroInfor(param1:Function) : void
      {
         this.FOnShowOtherHeroInfor = param1;
      }
      
      public function get OnShowOtherHeroInfor() : Function
      {
         return this.FOnShowOtherHeroInfor;
      }
      
      public function SetArenaHeroPanel(param1:TArenaHeros) : void
      {
         this.FArenaHeros = param1;
         this.FCurPage = 1;
         this.FTotlePage = Math.max(int(this.FArenaHeros.Count - 1) / this.HEROLIST_Count + 1,1);
         if(this.FMilitaryBins == null)
         {
            this.FMilitaryBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Military);
         }
         this.UpdataUI();
         this.CheckBtn();
      }
      
      public function Reset() : void
      {
         this.FArenaHeros = null;
      }
   }
}

