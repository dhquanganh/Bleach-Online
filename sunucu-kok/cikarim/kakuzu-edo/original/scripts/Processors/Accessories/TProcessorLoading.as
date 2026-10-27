package Processors.Accessories
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.SWF.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.SParametersCore;
   import Processors.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorLoading extends TProcessor
   {
      
      protected static const ProgressNeedPlayEffect:Vector.<int> = Vector.<int>([30,60]);
      
      protected static const ProgressEffectSpecialFrameIndex:Vector.<int> = Vector.<int>([1,6]);
      
      protected static const STRING_ResourcesLoad:String = STRING_LOADING.STRING_ResourcesLoad;
      
      protected static const GirlBikiniTextureID:uint = CONST_LOADING.RESOURCESID_TexturesVital_GirlBikini;
      
      protected static const CAPACITY_GIRLS:int = 3;
      
      protected static const MistakeDistance:int = 10;
      
      protected static const HotAreaAlpha:Number = 0.9;
      
      protected var FMax:int;
      
      protected var FCurrent:int;
      
      protected var FMaxCurrent:int;
      
      protected var FMC_Loading:Sprite;
      
      protected var FHotAreaRect:Vector.<Sprite>;
      
      protected var FChangeAlphaRect:Vector.<Sprite>;
      
      protected var FChangeAlphaCenterX:Vector.<int>;
      
      protected var FChangeAlphaCenterY:Vector.<int>;
      
      protected var FGirlMountPoint:Vector.<Bitmap>;
      
      protected var FGirlMasks:Vector.<Sprite>;
      
      protected var FGirlDialog:Vector.<Sprite>;
      
      protected var FBackGroundMountPoint:Bitmap;
      
      protected var FBearEffect:MovieClip;
      
      protected var FCurrentPlayedProgress:int;
      
      protected var FSP_ProgressBigBar:Sprite;
      
      protected var FTF_ProgressText:TextField;
      
      protected var FTF_LoadingTips:TextField;
      
      protected var FTF_LoadingTipsExtra:TextField;
      
      protected var FIsSendLoadStartStatistical:Boolean;
      
      protected var FIsSendLoadEndStatistical:Boolean;
      
      protected var FLoadingCompleted:Boolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FOnLoadingCompleted:Function;
      
      public function TProcessorLoading(param1:TUIComponent)
      {
         super(param1);
         this.FIsSendLoadStartStatistical = false;
         this.FIsSendLoadEndStatistical = false;
         this.FLoadingCompleted = true;
         this.FIsInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfVital.LoadPrimary(CONST_LOADING.RESOURCESID_SwfVital_MainLoading);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TTexture = null;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:MovieClip = null;
         this.FMC_Loading = TUtilityReflection.CreateDisplayObjectInstance(CONST_LOADING.RESOURCE_ClassName_MC_Loading) as Sprite;
         addChild(this.FMC_Loading);
         this.FHotAreaRect = new Vector.<Sprite>(CAPACITY_GIRLS);
         this.FChangeAlphaRect = new Vector.<Sprite>(CAPACITY_GIRLS);
         this.FGirlMountPoint = new Vector.<Bitmap>(CAPACITY_GIRLS);
         this.FChangeAlphaCenterX = new Vector.<int>(CAPACITY_GIRLS);
         this.FChangeAlphaCenterY = new Vector.<int>(CAPACITY_GIRLS);
         this.FGirlMasks = new Vector.<Sprite>(CAPACITY_GIRLS);
         this.FGirlDialog = new Vector.<Sprite>(CAPACITY_GIRLS);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_GIRLS)
         {
            this.FHotAreaRect[_loc2_] = this.FMC_Loading["HotArea" + _loc2_];
            this.FGirlMasks[_loc2_] = this.FMC_Loading["Mask" + _loc2_];
            this.FGirlDialog[_loc2_] = this.FMC_Loading["Dialog" + _loc2_];
            _loc5_ = this.FMC_Loading["CountArea" + _loc2_];
            this.FChangeAlphaCenterX[_loc2_] = _loc5_.x + _loc5_.width / 2;
            this.FChangeAlphaCenterY[_loc2_] = _loc5_.y + _loc5_.height / 2;
            this.FChangeAlphaRect[_loc2_] = _loc5_;
            _loc4_ = this.FMC_Loading["PicMountPoint" + _loc2_];
            _loc3_ = new Bitmap();
            _loc4_.addChild(_loc3_);
            this.FGirlMountPoint[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FBackGroundMountPoint = new Bitmap();
         _loc5_ = this.FMC_Loading["BigPicMountPoint"];
         _loc5_.addChild(this.FBackGroundMountPoint);
         this.FBearEffect = this.FMC_Loading["Bear"];
         this.FSP_ProgressBigBar = this.FMC_Loading[CONST_LOADING.RESOURCE_Link_SP_ProgressBigBar];
         this.FTF_ProgressText = this.FMC_Loading[CONST_LOADING.RESOURCE_Link_TF_ProgressText];
         this.FTF_LoadingTips = this.FMC_Loading[CONST_LOADING.RESOURCE_Link_TF_LoadingTips];
         this.FTF_LoadingTips.text = STRING_LOADING.STRING_LoadingTips[TUtilityMath.RandomRange(0,STRING_LOADING.STRING_LoadingTips.length - 1)];
         this.FSP_ProgressBigBar.scaleX = 0;
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         if(SParametersCore.IsNewUser)
         {
            SResourcesCore.ResourceBin.LoadPrimary(CONST_DATEBASEVO.RESOURCEID_RandomName);
            SResourcesCore.TexturesSwfCreateChar.LoadPrimary(CONST_ACCOUNT.RESOURCESID_Swf_Account);
         }
         this.FIsInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_GIRLS)
         {
            _loc2_ = this.FHotAreaRect[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.HotAreaOnMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.HotAreaOnMouseOut);
            _loc2_ = this.FChangeAlphaRect[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.CheckAreaOnMouseMove);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.CheckAreaOnMouseOut);
            this.FGirlDialog[_loc1_].visible = false;
            _loc1_++;
         }
         SResourcesCore.TexturesVital.LoadAutoSecondary(GirlBikiniTextureID,this.CallBack_GirlPicArrive);
         super.ResourcesPerform_UILocations();
      }
      
      protected function CallBack_GirlPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < CAPACITY_GIRLS)
         {
            this.FGirlMountPoint[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(_loc4_).GetAnimationFrameByIndex(0).Surface;
            _loc4_++;
         }
         this.FBackGroundMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(3).GetAnimationFrameByIndex(0).Surface;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsInitialization && this.FLoadingCompleted)
         {
            this.LogicsPerform_ProgressPercentage();
         }
      }
      
      protected function LogicsPerform_ProgressPercentage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!Visible)
         {
            return;
         }
         _loc1_ = int(SResourcesCore.PrimaryCount);
         _loc3_ = int(SResourcesCore.PrimaryPercentage);
         if(_loc1_ == 0)
         {
            if(this.FMax != 0)
            {
               this.FMax = 0;
               this.FCurrent = 0;
            }
         }
         else
         {
            if(this.FCurrent == 0)
            {
            }
            if(_loc1_ > this.FMax)
            {
               this.FMax = _loc1_;
               this.FMaxCurrent = _loc1_;
            }
            this.FCurrent = _loc1_;
            if(!this.FIsSendLoadStartStatistical)
            {
               this.FIsSendLoadStartStatistical = true;
               SExternalCore.GameStatistical(CONST_ACCOUNT.STATISTICALSETP_LoadStart);
               if(SParametersCore.IsNewUser)
               {
                  SExternalCore.GameStatistical(CONST_ACCOUNT.STATISTICALSETP_LoadStartNewUser);
               }
            }
         }
         if(this.FSP_ProgressBigBar == null)
         {
            return;
         }
         if(this.FTF_ProgressText == null)
         {
            return;
         }
         if(this.FMax != 0)
         {
            if(this.FMax == 1)
            {
               _loc2_ = _loc3_;
            }
            else
            {
               _loc2_ = Math.round((this.FMax - this.FCurrent) * 100 / this.FMax);
            }
            this.FSP_ProgressBigBar.scaleX = _loc2_ / 100;
            this.FTF_ProgressText.text = TUtilityString.Format(STRING_ResourcesLoad,this.FMax - this.FCurrent + 1,this.FMax,_loc2_);
         }
         else
         {
            this.FSP_ProgressBigBar.scaleX = 1;
            this.FTF_ProgressText.text = TUtilityString.Format(STRING_ResourcesLoad,this.FMaxCurrent,this.FMaxCurrent,100);
            if(!this.FIsSendLoadEndStatistical)
            {
               this.FIsSendLoadEndStatistical = true;
               SExternalCore.GameStatistical(CONST_ACCOUNT.STATISTICALSETP_LoadEnd);
               if(SParametersCore.IsNewUser)
               {
                  SExternalCore.GameStatistical(CONST_ACCOUNT.STATISTICALSETP_LoadEndNewUser);
               }
            }
            this.ProcessorLoadingCompleted();
            this.FLoadingCompleted = false;
         }
         this.PlayBearEffect(_loc2_);
      }
      
      protected function PlayBearEffect(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.FCurrentPlayedProgress >= ProgressNeedPlayEffect.length)
         {
            return;
         }
         _loc2_ = ProgressNeedPlayEffect[this.FCurrentPlayedProgress];
         if(param1 > _loc2_)
         {
            this.FBearEffect.stop();
            this.FBearEffect.gotoAndStop(ProgressEffectSpecialFrameIndex[this.FCurrentPlayedProgress]);
            this.FBearEffect.play();
            ++this.FCurrentPlayedProgress;
         }
      }
      
      protected function ProcessorLoadingCompleted() : void
      {
         if(this.FOnLoadingCompleted != null)
         {
            this.FOnLoadingCompleted(this);
         }
      }
      
      protected function HotAreaOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHotAreaRect.indexOf(param1.currentTarget as Sprite);
         this.FGirlMountPoint[_loc2_].alpha = HotAreaAlpha;
         if(false)
         {
            this.FGirlMountPoint[_loc2_].alpha = 1;
         }
         this.FGirlMasks[_loc2_].visible = false;
         this.FGirlDialog[_loc2_].visible = true;
      }
      
      protected function HotAreaOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHotAreaRect.indexOf(param1.currentTarget as Sprite);
         this.FGirlMountPoint[_loc2_].alpha = 1;
         this.FGirlMasks[_loc2_].visible = true;
         this.FGirlDialog[_loc2_].visible = false;
      }
      
      protected function CheckAreaOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FChangeAlphaRect.indexOf(param1.currentTarget as Sprite);
         this.FGirlMountPoint[_loc2_].alpha = HotAreaAlpha;
         if(false)
         {
            this.FGirlMountPoint[_loc2_].alpha = 1;
         }
         this.FGirlMasks[_loc2_].visible = false;
         this.FGirlDialog[_loc2_].visible = true;
      }
      
      protected function CheckAreaOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         _loc2_ = this.FChangeAlphaRect.indexOf(param1.currentTarget as Sprite);
         _loc7_ = this.FChangeAlphaRect[_loc2_].width / 2;
         _loc6_ = HotAreaAlpha / (_loc7_ / 2 - MistakeDistance);
         _loc4_ = mouseX - this.FChangeAlphaCenterX[_loc2_];
         _loc5_ = mouseY - this.FChangeAlphaCenterY[_loc2_];
         _loc3_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
         _loc3_ = _loc3_ > _loc7_ ? _loc7_ : _loc3_;
         if(_loc3_ < MistakeDistance)
         {
            this.FGirlMountPoint[_loc2_].alpha = 0;
         }
         else
         {
            this.FGirlMountPoint[_loc2_].alpha = (_loc3_ - MistakeDistance) * _loc6_;
         }
         if(false)
         {
            this.FGirlMountPoint[_loc2_].alpha = 1;
         }
         this.FGirlMasks[_loc2_].visible = false;
         this.FGirlDialog[_loc2_].visible = true;
      }
      
      protected function CheckAreaOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FChangeAlphaRect.indexOf(param1.currentTarget as Sprite);
         this.FGirlMountPoint[_loc2_].alpha = 1;
         this.FGirlMasks[_loc2_].visible = true;
         this.FGirlDialog[_loc2_].visible = false;
      }
      
      public function get ResourcesLoading() : Boolean
      {
         return this.FCurrent != 0;
      }
      
      public function get OnLoadingCompleted() : Function
      {
         return this.FOnLoadingCompleted;
      }
      
      public function set OnLoadingCompleted(param1:Function) : void
      {
         this.FOnLoadingCompleted = param1;
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         SResourcesCore.TexturesVital.DeleteByIdentifier(GirlBikiniTextureID,true);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_GIRLS)
         {
            _loc2_ = this.FHotAreaRect[_loc1_];
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.HotAreaOnMouseOver);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.HotAreaOnMouseOut);
            _loc2_ = this.FChangeAlphaRect[_loc1_];
            _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.CheckAreaOnMouseMove);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.CheckAreaOnMouseOut);
            _loc3_ = this.FGirlMountPoint[_loc1_];
            _loc3_.bitmapData = null;
            if(_loc3_.parent != null)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            this.FGirlMountPoint[_loc1_] = null;
            _loc1_++;
         }
         this.FHotAreaRect.length = 0;
         this.FChangeAlphaRect.length = 0;
         this.FChangeAlphaCenterX.length = 0;
         this.FChangeAlphaCenterY.length = 0;
         this.FGirlMountPoint.length = 0;
         this.FGirlMasks.length = 0;
         this.FGirlDialog.length = 0;
         this.FHotAreaRect = null;
         this.FChangeAlphaRect = null;
         this.FChangeAlphaCenterX = null;
         this.FChangeAlphaCenterY = null;
         this.FGirlMountPoint = null;
         this.FGirlMasks = null;
         this.FGirlDialog = null;
         this.FBackGroundMountPoint.bitmapData = null;
         if(this.FBackGroundMountPoint.parent != null)
         {
            this.FBackGroundMountPoint.parent.removeChild(this.FBackGroundMountPoint);
         }
         this.FBackGroundMountPoint = null;
         this.FBearEffect.stop();
         this.FBearEffect = null;
         if(this.FMC_Loading.parent != null)
         {
            this.FMC_Loading.parent.removeChild(this.FMC_Loading);
         }
         this.FSP_ProgressBigBar = null;
         this.FTF_ProgressText = null;
         this.FTF_LoadingTips = null;
         this.FMC_Loading = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
         this.Parent = null;
      }
   }
}

