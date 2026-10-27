package Processors.Game.Lobby.HeroCompanion.Components
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.*;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Processors.Game.Common.Effects.ListAutoScroll.*;
   import Resources.Constants.*;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TCompanionCardItem extends TCompanionBaseItem implements IListAutoScrollRender
   {
      
      protected static const PositionTable:Vector.<int> = CONST_HEROCOMPANION.PositionTable;
      
      protected var FTFName:TextField;
      
      protected var FMountPoint:Bitmap;
      
      protected var FStar:MovieClip;
      
      protected var FPosition:MovieClip;
      
      protected var FQuality:MovieClip;
      
      protected var FCardData:TCompanionCard;
      
      protected var FPicture:int;
      
      protected var FAnimationSequence:TAnimationSequence;
      
      protected var FData:TCompanionCard;
      
      public function TCompanionCardItem(param1:Sprite)
      {
         super(param1);
         this.FTFName = FMainUI["TF_Name"];
         this.FMountPoint = new Bitmap();
         FMainUI["MC_MountPoint"].addChild(this.FMountPoint);
         this.FStar = FMainUI["MC_Star"];
         this.FPosition = FMainUI["MC_Position"];
         this.FQuality = FMainUI["MC_Quality"];
      }
      
      private function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         this.FAnimationSequence = param2.GetAnimationSequenceByIndex(0);
      }
      
      public function ClearData() : void
      {
         this.FData = null;
         this.FMountPoint.bitmapData = null;
         this.FStar.visible = false;
         this.FPosition.visible = false;
         this.FQuality.visible = false;
         this.Visible = false;
      }
      
      protected function GetLastId(param1:int) : int
      {
         var _loc2_:TCompanionCard = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,param1) as TCompanionCard;
         if(_loc2_.NextId == 0)
         {
            return param1;
         }
         return this.GetLastId(_loc2_.NextId);
      }
      
      public function get Level() : int
      {
         return this.FStar.currentFrame;
      }
      
      public function set Level(param1:int) : void
      {
         this.FStar.visible = true;
         this.FStar.gotoAndStop(param1);
      }
      
      public function get Position() : int
      {
         var _loc1_:int = 0;
         _loc1_ = this.FPosition.currentFrame;
         return PositionTable[_loc1_ - 1];
      }
      
      public function set Position(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = PositionTable.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.FPosition.visible = true;
            this.FPosition.gotoAndStop(_loc2_ + 1);
         }
      }
      
      public function get AnimationSequence() : TAnimationSequence
      {
         return this.FAnimationSequence;
      }
      
      public function get Data() : TCompanionCard
      {
         return this.FData;
      }
      
      public function get Quality() : int
      {
         return this.FQuality.currentFrame;
      }
      
      public function set Quality(param1:int) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         this.FQuality.visible = true;
         this.FQuality.gotoAndStop(param1);
      }
      
      public function SetCardData(param1:int) : void
      {
         if(param1 == 0)
         {
            this.ClearData();
            return;
         }
         this.FCardData = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,param1) as TCompanionCard;
         if(this.FTFName != null)
         {
            this.FTFName.htmlText = "<font color=\'" + CONST_HEROCOMPANION.TextColor[this.FCardData.Quality] + "\'>" + this.FCardData.Name + "</font>";
            this.FPicture = this.FCardData.BigPicture;
         }
         else
         {
            this.FPicture = this.FCardData.Picture;
         }
         this.Level = this.FCardData.Level;
         this.Position = this.FCardData.BaseProperties[0].Pos;
         this.Quality = this.FCardData.Quality;
         SResourcesCore.TexturesInventory.LoadAutoSecondary(this.FPicture,this.PicArrive);
         if(this.FData == null)
         {
            this.FData = this.FCardData;
         }
         this.Visible = true;
      }
      
      public function SetData(param1:IListAutoScrollDataRender) : void
      {
         this.FData = param1 as TCompanionCard;
         this.SetCardData(this.FData.Identifier);
      }
   }
}

