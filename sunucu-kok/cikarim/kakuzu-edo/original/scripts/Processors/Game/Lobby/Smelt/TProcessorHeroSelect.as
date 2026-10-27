package Processors.Game.Lobby.Smelt
{
   import Components.Pages.TUIPage;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHeroSelect extends TProcessorLobbyWindow
   {
      
      protected const EachPageCount:uint = 7;
      
      protected var FMainUI:MovieClip;
      
      protected var FMaskSprite:Sprite;
      
      protected var FMask:Bitmap;
      
      protected var FPage:TUIPage;
      
      protected var FHeads:Vector.<Bitmap>;
      
      protected var FPageIndex:uint;
      
      protected var FHint:THint;
      
      protected var FCanClose:Boolean;
      
      protected var FHeros:THeros;
      
      private var FKnifeOfKillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FSelectHero:Function;
      
      protected var FSelectKnifeOfKillSoul:Function;
      
      public function TProcessorHeroSelect(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
      }
      
      protected function LoaclIndexToGlobalIndex(param1:uint) : uint
      {
         return this.FPageIndex * this.EachPageCount + param1;
      }
      
      protected function GlobalIndexToLocalIndex(param1:uint) : uint
      {
         return param1 % this.EachPageCount;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:Bitmap = null;
         var _loc6_:THero = null;
         var _loc7_:TKnifeOfKillSoulData = null;
         if(this.FHeros != null)
         {
            _loc4_ = uint(this.FHeros.Count);
            _loc1_ = 0;
            while(_loc1_ < this.EachPageCount)
            {
               _loc3_ = this.FMainUI["MC_Head_" + _loc1_];
               _loc2_ = this.LoaclIndexToGlobalIndex(_loc1_);
               _loc5_ = this.FHeads[_loc1_];
               _loc5_.bitmapData = null;
               if(_loc2_ < _loc4_)
               {
                  _loc6_ = this.FHeros.GetHeroByIndex(_loc2_);
                  SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.SmallID,this.TextureArrive);
               }
               _loc1_++;
            }
         }
         else if(this.FKnifeOfKillSoulDatas != null)
         {
            _loc4_ = uint(this.FKnifeOfKillSoulDatas.Count);
            _loc1_ = 0;
            while(_loc1_ < this.EachPageCount)
            {
               _loc3_ = this.FMainUI["MC_Head_" + _loc1_];
               _loc2_ = this.LoaclIndexToGlobalIndex(_loc1_);
               _loc5_ = this.FHeads[_loc1_];
               _loc5_.bitmapData = null;
               if(_loc2_ < _loc4_)
               {
                  _loc7_ = this.FKnifeOfKillSoulDatas.GetByIndex(_loc2_);
                  SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc7_.RelationID,this.TextureArrive);
               }
               _loc1_++;
            }
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePage();
         this.FCanClose = false;
      }
      
      protected function TextureArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THero = null;
         var _loc8_:TKnifeOfKillSoulData = null;
         var _loc9_:Bitmap = null;
         if(this.FHeros != null)
         {
            _loc6_ = uint(this.FHeros.Count);
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc7_ = this.FHeros.GetHeroByIndex(_loc4_);
               if(_loc7_.SmallID == param3)
               {
                  _loc5_ = this.GlobalIndexToLocalIndex(_loc4_);
                  _loc9_ = this.FHeads[_loc5_];
                  _loc9_.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
                  break;
               }
               _loc4_++;
            }
         }
         else if(this.FKnifeOfKillSoulDatas != null)
         {
            _loc6_ = uint(this.FKnifeOfKillSoulDatas.Count);
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc8_ = this.FKnifeOfKillSoulDatas.GetByIndex(_loc4_);
               if(_loc8_.RelationID == param3)
               {
                  _loc5_ = this.GlobalIndexToLocalIndex(_loc4_);
                  _loc9_ = this.FHeads[_loc5_];
                  _loc9_.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
                  break;
               }
               _loc4_++;
            }
         }
      }
      
      protected function OnSelectCall(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = uint((param1.currentTarget as MovieClip).Index);
         _loc3_ = this.LoaclIndexToGlobalIndex(_loc2_);
         if(this.FHeros != null)
         {
            this.FSelectHero(this.FHeros.GetHeroByIndex(_loc3_));
         }
         else if(this.FKnifeOfKillSoulDatas != null)
         {
            this.FSelectKnifeOfKillSoul(this.FKnifeOfKillSoulDatas.GetByIndex(_loc3_));
         }
         this.OnCloseWin();
      }
      
      protected function OnHeadMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = uint(_loc2_.Index);
         _loc4_ = int(this.LoaclIndexToGlobalIndex(_loc3_));
         if(this.FHeros != null)
         {
            this.FHint.Caption = this.FHeros.GetHeroByIndex(_loc4_).Name;
         }
         else if(this.FKnifeOfKillSoulDatas != null)
         {
            this.FHint.Caption = this.FKnifeOfKillSoulDatas.GetByIndex(_loc4_).Name;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnHeadOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnCloseWin(param1:MouseEvent = null) : void
      {
         this.FHeros = null;
         this.FKnifeOfKillSoulDatas = null;
         this.Visible = false;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.UpdateUI();
      }
      
      public function set Heros(param1:THeros) : void
      {
         this.FHeros = param1;
      }
      
      public function set KnifeOfKillSoulDatas(param1:TKnifeOfkillSoulDatas) : void
      {
         this.FKnifeOfKillSoulDatas = param1;
      }
      
      public function set SelectHero(param1:Function) : void
      {
         this.FSelectHero = param1;
      }
      
      public function get SelectKnifeOfKillSoul() : Function
      {
         return this.FSelectKnifeOfKillSoul;
      }
      
      public function set SelectKnifeOfKillSoul(param1:Function) : void
      {
         this.FSelectKnifeOfKillSoul = param1;
      }
      
      public function UpdateUI() : void
      {
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         if(this.FHeros != null)
         {
            this.FPage.SetupPage(this.FHeros.Count,0);
         }
         else if(this.FKnifeOfKillSoulDatas != null)
         {
            this.FPage.SetupPage(this.FKnifeOfKillSoulDatas.Count,0);
         }
         this.FPageIndex = 0;
         this.UpdatePage();
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Bitmap = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_SmeltHeroSelect") as MovieClip;
         this.FMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
         this.FMaskSprite = new Sprite();
         this.FMaskSprite.addChild(this.FMask);
         addChild(this.FMaskSprite);
         addChild(this.FMainUI);
         this.FMainUI.x = (this.FMaskSprite.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (this.FMaskSprite.height - this.FMainUI.height) / 2;
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI.MC_PageRight;
         this.FPage.ButtonPrevious.Substrate = this.FMainUI.MC_PageLeft;
         this.FPage.PageSize = this.EachPageCount;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.FHeads = new Vector.<Bitmap>();
         _loc1_ = 0;
         while(_loc1_ < this.EachPageCount)
         {
            _loc2_ = this.FMainUI["MC_Head_" + _loc1_].MC_MountPoint;
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnSelectCall);
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeadMove);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnHeadOut);
            _loc2_.Index = _loc1_;
            _loc3_ = new Bitmap();
            _loc2_.addChild(_loc3_);
            this.FHeads.push(_loc3_);
            _loc1_++;
         }
         this.FMaskSprite.addEventListener(MouseEvent.CLICK,this.OnCloseWin);
      }
   }
}

