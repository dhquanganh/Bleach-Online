package Processors.Game.Battle.Components
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TStatisticsItem
   {
      
      protected var FMainUI:Sprite;
      
      protected var FMountPoint:Bitmap;
      
      protected var FTFHpRate:TextField;
      
      protected var FTFHurtRate:TextField;
      
      protected var FTFHurt:TextField;
      
      protected var FBarHpRate:Sprite;
      
      protected var FBarHurtRate:Sprite;
      
      protected var FBarHurt:Sprite;
      
      public function TStatisticsItem()
      {
         super();
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function GetRate(param1:Number) : String
      {
         if(isNaN(param1) || param1 <= 0)
         {
            return 0 + "";
         }
         return Number(param1 * 100).toFixed(2) + "%";
      }
      
      public function Init(param1:Sprite) : void
      {
         this.FMainUI = param1;
         this.FMountPoint = new Bitmap();
         this.FMainUI["MountPoint"].addChild(this.FMountPoint);
         this.FTFHpRate = this.FMainUI["TF_HpRate"];
         this.FTFHurtRate = this.FMainUI["TF_HurtRate"];
         this.FTFHurt = this.FMainUI["TF_Hurt"];
         this.FBarHpRate = this.FMainUI["Bar_HpRate"];
         this.FBarHurtRate = this.FMainUI["Bar_HurtRate"];
         this.FBarHurt = this.FMainUI["Bar_Hurt"];
      }
      
      public function SetHpRate(param1:Number) : void
      {
         this.FTFHpRate.text = this.GetRate(param1);
         this.FBarHpRate.scaleX = param1 > 0 ? (param1 > 1 ? 1 : param1) : 0;
      }
      
      public function SetHurt(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc4_ = param1 / param2;
         this.FTFHurtRate.text = this.GetRate(_loc4_);
         this.FBarHurtRate.scaleX = _loc4_ > 0 ? (_loc4_ > 1 ? 1 : _loc4_) : 0;
         _loc5_ = _loc4_;
         this.FTFHurt.text = param1 + "";
         this.FBarHurt.scaleX = _loc5_ > 0 ? (_loc5_ > 1 ? 1 : _loc5_) : 0;
      }
      
      public function SetHead(param1:int) : void
      {
         var _loc2_:TRoleModel = null;
         var _loc3_:TKnifeExpand = null;
         var _loc4_:int = 0;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1) as TRoleModel;
         if(_loc2_ == null)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1) as TKnifeExpand;
            _loc4_ = int(_loc3_.RelationID);
         }
         else
         {
            _loc4_ = int(_loc2_.RoleHead);
         }
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc4_,this.PicArrive);
      }
      
      public function Clear() : void
      {
         this.FMountPoint.bitmapData = null;
         this.FTFHpRate.text = "";
         this.FTFHurtRate.text = "";
         this.FTFHurt.text = "";
         this.FBarHpRate.scaleX = 1;
         this.FBarHurtRate.scaleX = 1;
         this.FBarHurt.scaleX = 1;
      }
   }
}

