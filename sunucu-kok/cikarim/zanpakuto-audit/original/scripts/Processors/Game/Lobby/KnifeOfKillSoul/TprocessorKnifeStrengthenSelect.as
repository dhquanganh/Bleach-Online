package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Components.Pages.TUIPage;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_KNIFEOFKILLSOUL;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TprocessorKnifeStrengthenSelect extends TProcessorLobbyWindow
   {
      
      protected const EachPageCount:uint = 7;
      
      protected var FMainUI:MovieClip;
      
      protected var FMaskSprite:Sprite;
      
      protected var FMask:Bitmap;
      
      protected var FPage:TUIPage;
      
      protected var FHeads:Vector.<Bitmap>;
      
      protected var FKnifeDatas:Vector.<TKnifeOfKillSoulData>;
      
      protected var FPageIndex:uint;
      
      protected var FHint:THint;
      
      protected var FCanClose:Boolean;
      
      protected var FKnifeOfkillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FSelect:Function;
      
      public function TprocessorKnifeStrengthenSelect(param1:TUIComponent)
      {
         super(param1);
         this.FKnifeDatas = new Vector.<TKnifeOfKillSoulData>();
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
         var _loc6_:uint = 0;
         var _loc7_:TKnifeOfKillSoulData = null;
         _loc4_ = this.FKnifeDatas.length;
         _loc1_ = 0;
         while(_loc1_ < this.EachPageCount)
         {
            _loc3_ = this.FMainUI["MC_Head_" + _loc1_];
            _loc2_ = this.LoaclIndexToGlobalIndex(_loc1_);
            _loc5_ = this.FHeads[_loc1_];
            _loc5_.bitmapData = null;
            if(_loc2_ < _loc4_)
            {
               _loc7_ = this.FKnifeDatas[_loc2_];
               _loc6_ = uint(_loc7_.RelationID);
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_,this.TextureArrive);
               _loc3_.visible = true;
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc1_++;
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
         var _loc7_:TKnifeOfKillSoulData = null;
         var _loc8_:Bitmap = null;
         _loc6_ = this.FKnifeDatas.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_ = this.FKnifeDatas[_loc4_];
            if(_loc7_.RelationID == param3)
            {
               _loc5_ = this.GlobalIndexToLocalIndex(_loc4_);
               _loc8_ = this.FHeads[_loc5_];
               _loc8_.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               return;
            }
            _loc4_++;
         }
      }
      
      protected function OnSelectCall(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = uint((param1.currentTarget as MovieClip).Index);
         _loc3_ = this.LoaclIndexToGlobalIndex(_loc2_);
         this.FSelect(this.FKnifeDatas[_loc3_]);
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
         this.FHint.Caption = this.FKnifeDatas[_loc4_].Name;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnHeadOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnCloseWin(param1:MouseEvent = null) : void
      {
         this.Visible = false;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.UpdateUI();
      }
      
      public function set KnifeOfkillSoulDatas(param1:TKnifeOfkillSoulDatas) : void
      {
         this.FKnifeOfkillSoulDatas = param1;
      }
      
      public function set Select(param1:Function) : void
      {
         this.FSelect = param1;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:TKnifeOfKillSoulData = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         this.FKnifeDatas.length = 0;
         _loc3_ = uint(this.FKnifeOfkillSoulDatas.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FKnifeOfkillSoulDatas.GetByIndex(_loc2_);
            if(_loc1_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
            {
               this.FKnifeDatas.push(_loc1_);
            }
            _loc2_++;
         }
         this.FPage.SetupPage(this.FKnifeDatas.length,0);
         this.FPageIndex = 0;
         this.UpdatePage();
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Bitmap = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_KnifeSelect") as MovieClip;
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

