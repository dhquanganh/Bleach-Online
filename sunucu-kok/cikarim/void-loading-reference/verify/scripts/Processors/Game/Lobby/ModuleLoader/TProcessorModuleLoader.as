package Processors.Game.Lobby.ModuleLoader
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Battle.TBattleHandle;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.*;
   import ghostcat.operation.*;
   import ghostcat.util.easing.*;
   
   public class TProcessorModuleLoader extends TProcessorLobbyModule
   {
      
      protected static const STRING_ModuleLoad:String = STRING_LOADING.STRING_ModuleLoad;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FMC_Loading:Sprite;
      
      protected var FSP_ProgressBigBar:Sprite;
      
      protected var FTF_ProgressText:TextField;
      
      protected var FMax:int;
      
      protected var FMaxTemp:int;
      
      protected var FCurrent:int;
      
      protected var FPercentage:int;
      
      protected var FIsStart:Boolean;
      
      public function TProcessorModuleLoader(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FBoundsClient.Width = CONST_COMMON.STAGE_Width;
         FBoundsClient.Height = CONST_COMMON.STAGE_Height;
         this.ConstructTweens();
         this.FIsStart = false;
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
         this.FTweenOperIn.duration = 500;
         this.FTweenOperIn.target = this;
         this.FTweenOperOut.duration = 300;
         this.FTweenOperOut.target = this;
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfVital.LoadPrimary(CONST_LOADING.RESOURCESID_SwfVital_ModuleLoading);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMC_Loading = TUtilityReflection.CreateDisplayObjectInstance(CONST_LOADING.RESOURCE_ClassName_MC_ModuleLoading) as Sprite;
         addChild(this.FMC_Loading);
         this.FSP_ProgressBigBar = this.FMC_Loading[CONST_LOADING.RESOURCE_Link_SP_ProgressBigBar];
         this.FTF_ProgressText = this.FMC_Loading[CONST_LOADING.RESOURCE_Link_TF_ProgressText];
         this.FSP_ProgressBigBar.scaleX = 0;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FMC_Loading.x = (CONST_COMMON.STAGE_Width - this.FMC_Loading.width) / 2;
         this.FMC_Loading.y = (CONST_COMMON.STAGE_Height - this.FMC_Loading.height) / 2 + 10;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsStart)
         {
            this.LogicsPerform_ProgressPercentage();
         }
      }
      
      protected function LogicsPerform_ProgressPercentage() : void
      {
         if(TBattleHandle.VoidResourceLoading)
         {
            BarrierDeactuate(this);
            this.Visible = false;
            this.FMax = 0;
            this.FCurrent = 0;
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = int(SResourcesCore.PrimaryCount);
         _loc3_ = int(SResourcesCore.PrimaryPercentage);
         if(_loc1_ == 0)
         {
            if(this.FMax != 0)
            {
               this.Hide();
               this.FMax = 0;
               this.FCurrent = 0;
            }
         }
         else
         {
            if(this.FCurrent == 0)
            {
               this.Show();
            }
            if(_loc1_ > this.FMax)
            {
               this.FMax = _loc1_;
               this.FMaxTemp = _loc1_;
            }
            this.FCurrent = _loc1_;
         }
         if(!this.Visible)
         {
            return;
         }
         if(this.FMC_Loading == null)
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
            this.UpdateProgressBar(_loc2_);
            this.FTF_ProgressText.text = TUtilityString.Format(STRING_ModuleLoad,this.FMax - this.FCurrent + 1,this.FMax,_loc2_);
         }
         else
         {
            _loc2_ = 100;
            this.UpdateProgressBar(_loc2_);
            if(this.FTF_ProgressText != null)
            {
               this.FTF_ProgressText.text = TUtilityString.Format(STRING_ModuleLoad,this.FMaxTemp,this.FMaxTemp,_loc2_);
            }
         }
      }
      
      protected function UpdateProgressBar(param1:int) : void
      {
         if(this.FPercentage != param1)
         {
            TweenUtil.to(this.FSP_ProgressBigBar,150,{"scaleX":param1 / 100});
            this.FPercentage = param1;
         }
      }
      
      protected function Show() : void
      {
         this.FPercentage = 0;
         this.FTweenOperIn.params = {
            "alpha":this.alpha,
            "ease":Cubic.easeIn,
            "onCompleteHandler":this.PerformTweenOperOnStart
         };
         this.FTweenOperOut.params = {
            "alpha":1,
            "ease":Cubic.easeOut
         };
         this.FRepeatOper.execute();
      }
      
      protected function Hide() : void
      {
         this.FTweenOperIn.params = {
            "alpha":this.alpha,
            "ease":Cubic.easeOut
         };
         this.FTweenOperOut.params = {
            "alpha":0,
            "ease":Cubic.easeIn,
            "onCompleteHandler":this.PerformTweenOperOnComplete
         };
         this.FRepeatOper.execute();
      }
      
      protected function PerformTweenOperOnStart(param1:TweenEvent) : void
      {
         if(TBattleHandle.VoidResourceLoading)
         {
            return;
         }
         if(!Visible)
         {
            BarrierActuate(this);
            if(this.FSP_ProgressBigBar != null)
            {
               this.FSP_ProgressBigBar.scaleX = 0;
            }
            this.Visible = true;
         }
      }
      
      protected function PerformTweenOperOnComplete(param1:TweenEvent) : void
      {
         if(Visible)
         {
            BarrierDeactuate(this);
            if(this.FSP_ProgressBigBar != null)
            {
               this.FSP_ProgressBigBar.scaleX = 0;
            }
            this.Visible = false;
         }
      }
      
      public function get IsStart() : Boolean
      {
         return this.FIsStart;
      }
      
      public function set IsStart(param1:Boolean) : void
      {
         this.FIsStart = param1;
      }
   }
}

