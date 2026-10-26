package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenPhase;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TKnifeStrengthenPhaseUI
   {
      
      protected const AttCount:uint = 5;
      
      protected var FMainUI:MovieClip;
      
      protected var FHeadBtms:Vector.<Bitmap>;
      
      protected var FIconBtms:Vector.<Bitmap>;
      
      protected var FHint:THint;
      
      protected var FData:TKnifeStrengthenPhase;
      
      protected var FBaseHeroBins:TBins;
      
      public function TKnifeStrengthenPhaseUI()
      {
         super();
         this.FHeadBtms = new Vector.<Bitmap>();
         this.FIconBtms = new Vector.<Bitmap>();
         this.FHint = new THint();
      }
      
      protected function OnHeadMove(param1:MouseEvent) : void
      {
         var _loc2_:TBaseHero = null;
         var _loc3_:uint = 0;
         _loc3_ = uint(param1.currentTarget.Index);
         if(_loc3_ >= this.FData.HeroID.length)
         {
            return;
         }
         _loc2_ = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FData.HeroID[_loc3_]) as TBaseHero;
         this.FHint.Caption = _loc2_.Name;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnIconMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.Index);
         if(_loc2_ >= this.FData.IconID.length)
         {
            return;
         }
         this.FHint.Caption = TUtilityTool.GetPropertyDesc(Vector.<Object>([this.FData.Attribute[_loc2_]]));
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnItemOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function HeroIDArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = this.FData.HeroID.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3 == this.FData.HeroID[_loc4_])
            {
               this.FHeadBtms[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function IconIDArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = this.FData.HeroID.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3 == this.FData.IconID[_loc4_])
            {
               this.FIconBtms[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      public function UIDispath(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Bitmap = null;
         this.FMainUI = param1;
         _loc2_ = 0;
         while(_loc2_ < this.AttCount)
         {
            _loc3_ = this.FMainUI["MC_Att_" + _loc2_];
            _loc4_ = new Bitmap();
            _loc3_.MC_Head.MC_MountPoint.addChild(_loc4_);
            this.FHeadBtms.push(_loc4_);
            _loc3_.MC_Head.Index = _loc2_;
            _loc3_.MC_Head.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeadMove);
            _loc3_.MC_Head.addEventListener(MouseEvent.MOUSE_OUT,this.OnItemOut);
            _loc4_ = new Bitmap();
            _loc3_.MC_Icon.MC_MountPoint.addChild(_loc4_);
            this.FIconBtms.push(_loc4_);
            _loc3_.MC_Icon.Index = _loc2_;
            _loc3_.MC_Icon.addEventListener(MouseEvent.MOUSE_MOVE,this.OnIconMove);
            _loc3_.MC_Icon.addEventListener(MouseEvent.MOUSE_OUT,this.OnItemOut);
            _loc2_++;
         }
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
      }
      
      public function SetData(param1:TKnifeStrengthenPhase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:Bitmap = null;
         this.FData = param1;
         _loc4_ = this.FData.HeroID.length;
         _loc2_ = 0;
         while(_loc2_ < this.AttCount)
         {
            _loc3_ = this.FMainUI["MC_Att_" + _loc2_];
            _loc5_ = this.FHeadBtms[_loc2_];
            _loc5_.bitmapData = null;
            _loc5_ = this.FIconBtms[_loc2_];
            _loc5_.bitmapData = null;
            if(_loc2_ < _loc4_)
            {
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(param1.HeroID[_loc2_],this.HeroIDArrive);
               SResourcesCore.TexturesBuffIcon.LoadAutoSecondary(param1.IconID[_loc2_],this.IconIDArrive);
            }
            _loc2_++;
         }
      }
      
      public function GreyState() : void
      {
         this.FMainUI.filters = [TUtilityFilter.gBlackFilters];
      }
      
      public function NormalState() : void
      {
         this.FMainUI.filters = [];
      }
   }
}

