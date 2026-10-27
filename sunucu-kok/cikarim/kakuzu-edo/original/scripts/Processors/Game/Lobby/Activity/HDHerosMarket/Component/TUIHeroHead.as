package Processors.Game.Lobby.Activity.HDHerosMarket.Component
{
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TTavernWarrior;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TUIHeroHead extends TUIComponent
   {
      
      protected static const STATUS_NORMAL:uint = 1;
      
      protected static const STATUS_OVER:uint = 2;
      
      protected static const RECRUITED_NORMAL:int = -8;
      
      protected static const MILITARY_NORMAL:int = 50;
      
      protected static const HEADBOX_NORMAL:int = 0;
      
      protected static const RECRUITED_OVER:int = -13;
      
      protected static const MILITARY_OVER:int = 45;
      
      protected static const HEADBOX_OVER:int = -5;
      
      protected static const POS_Y:uint = 5;
      
      protected var FBackGround:MovieClip;
      
      protected var FMC_HeadIcon:Sprite;
      
      protected var FBitMap:Bitmap;
      
      protected var FRoldModelBins:TBins;
      
      protected var FHint:THint;
      
      protected var FMC_HeadBox:MovieClip;
      
      protected var FHeadId:uint;
      
      protected var FHeadName:String;
      
      protected var FIsSelect:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FRecruitedTagVisible:Boolean;
      
      public function TUIHeroHead(param1:TUIComponent, param2:MovieClip, param3:TBins)
      {
         super(param1);
         this.FBackGround = param2;
         this.FRoldModelBins = param3;
         this.FBitMap = new Bitmap();
         this.FHint = new THint();
         this.GeneralInit();
      }
      
      private function GeneralInit() : void
      {
         this.FMC_HeadBox = this.FBackGround["MC_Bmp_Icon"];
         this.FMC_HeadBox.addChild(this.FBitMap);
         this.FMC_HeadBox.addEventListener(MouseEvent.MOUSE_MOVE,this.HeadBoxOnOver);
         this.FMC_HeadBox.addEventListener(MouseEvent.MOUSE_OUT,this.HeadBoxOnOut);
         this.FMC_HeadBox.addEventListener(MouseEvent.CLICK,this.HeadBoxOnClick);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FHeadId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitMap.bitmapData = _loc5_;
         }
      }
      
      private function HeadBoxOnClick(param1:MouseEvent) : void
      {
      }
      
      private function HeadBoxOnOut(param1:MouseEvent) : void
      {
      }
      
      private function HeadBoxOnOver(param1:MouseEvent) : void
      {
      }
      
      public function set BackGroundVisible(param1:Boolean) : void
      {
         this.FBackGround.visible = param1;
      }
      
      public function set BackGroundGrey(param1:Boolean) : void
      {
         var _loc2_:Array = new Array();
         _loc2_.push(TUtilityFilter.GaryColorFiltersTwo);
         this.FBackGround.filters = _loc2_;
      }
      
      public function set BackGroundNormal(param1:Boolean) : void
      {
         this.FBackGround.filters = [];
      }
      
      public function UpdateBox(param1:TTavernWarrior, param2:uint) : void
      {
      }
      
      public function ResetBox() : void
      {
      }
      
      public function UpdateIcon(param1:uint, param2:uint) : void
      {
         var _loc3_:TRoleModel = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:TKnifeExpand = null;
         var _loc6_:TKnife = null;
         _loc3_ = this.FRoldModelBins.GetDatebaseByIdentifier(param1) as TRoleModel;
         this.FHeadId = _loc3_.RoleHead;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeadId,this.AutoLoadCallBack);
         if(param2 == 0)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1) as TBaseHero;
            this.FHint.Caption = _loc4_.Name;
         }
         if(param2 == 1)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,param1) as TKnife;
            this.FHint.Caption = _loc6_.Name;
         }
      }
      
      public function ResetBmp() : void
      {
         this.FBitMap.bitmapData = null;
      }
   }
}

