package Processors.Game.Battle
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.SWF.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Affairs.TAffair;
   import Processors.*;
   import Processors.Game.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.easing.TweenUtil;
   
   public class TProcessorBattleLoading extends TProcessorGame
   {
      
      protected static const AFFAIRID_TimingWaitCloseLoad:uint = 1;
      
      protected static const TIME_Period:int = 200;
      
      protected static const FRMAE_INDEX_START:int = 1;
      
      protected static const FRMAE_INDEX_EFFECT:int = 47;
      
      protected static const FRMAE_INDEX_ShowBattle:int = 80;
      
      protected static const FRMAE_INDEX_END:int = 91;
      
      protected var FMax:int;
      
      protected var FCurrent:int;
      
      protected var FMC_Loading:MovieClip;
      
      protected var FSP_BackGround:Sprite;
      
      protected var FSP_LoadBar:Sprite;
      
      protected var FSP_ProgressBar:Sprite;
      
      protected var FTF_ProgressBar:TextField;
      
      protected var FStatusLoading:Boolean;
      
      protected var FTickCloseLoad:int;
      
      protected var FOnLoadingCompleted:Function;
      
      protected var FOnShowBattle:Function;
      
      protected var FOnCloseLoad:Function;
      
      public function TProcessorBattleLoading(param1:TUIComponent)
      {
         super(param1);
         this.FStatusLoading = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfVital.LoadPrimary(CONST_LOADING.RESOURCESID_SwfVital_BattleLoading);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.Loading)
         {
            return;
         }
         super.ResourcesPerform_UIWait();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMC_Loading = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_MC_BattleLoad) as MovieClip;
         addChild(this.FMC_Loading);
         this.FMC_Loading.gotoAndStop(FRMAE_INDEX_EFFECT);
         this.FSP_BackGround = this.FMC_Loading[CONST_BATTLE.RESOURCE_Link_SP_BackGround];
         this.FSP_LoadBar = this.FMC_Loading[CONST_BATTLE.RESOURCE_Link_SP_LoadBar];
         this.FSP_ProgressBar = this.FSP_LoadBar[CONST_BATTLE.RESOURCE_Link_SP_ProgressBar];
         this.FTF_ProgressBar = this.FSP_LoadBar[CONST_BATTLE.RESOURCE_Link_TF_ProgressBar];
         this.FTF_ProgressBar.text = "0%";
         this.FSP_ProgressBar.width = 0;
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitCloseLoad,this.AffairPerform_TimingWaitCloseLoad);
      }
      
      protected function AffairPerform_TimingWaitCloseLoad(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitLoaded();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitLoaded() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickCloseLoad > TIME_Period)
         {
            this.FMC_Loading.play();
            return false;
         }
         return true;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.LogicsPerform_ProgressPercentage();
         if(this.FMC_Loading != null)
         {
            this.LogicsPerform_LoadingShowBattle();
            this.LogicsPerform_LoadingCompletedEffect();
         }
      }
      
      protected function LogicsPerform_ProgressPercentage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.FStatusLoading)
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
            }
            this.FCurrent = _loc1_;
         }
         if(this.FTF_ProgressBar == null)
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
               _loc2_ = (this.FMax - this.FCurrent) * 100 / this.FMax;
            }
            this.FTF_ProgressBar.text = _loc2_.toString() + "%";
            TweenUtil.removeTween(this.FSP_ProgressBar,false);
            TweenUtil.to(this.FSP_ProgressBar,1000,{"scaleX":_loc2_ / 100});
         }
         else
         {
            this.FTF_ProgressBar.text = "90%";
            TweenUtil.removeTween(this.FSP_ProgressBar,false);
            TweenUtil.to(this.FSP_ProgressBar,800,{"scaleX":1});
            if(this.FOnLoadingCompleted != null)
            {
               this.FOnLoadingCompleted(this);
            }
            this.FTickCloseLoad = STimingCore.TickCount;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitCloseLoad);
         }
      }
      
      protected function LogicsPerform_LoadingShowBattle() : void
      {
         if(this.FMC_Loading.currentFrame == FRMAE_INDEX_ShowBattle - 1)
         {
            this.FMC_Loading.stop();
            this.FSP_BackGround.visible = false;
            this.FSP_LoadBar.visible = false;
            if(this.FOnShowBattle != null)
            {
               this.FOnShowBattle(this);
            }
         }
      }
      
      protected function LogicsPerform_LoadingCompletedEffect() : void
      {
         if(this.FMC_Loading.currentFrame == FRMAE_INDEX_END - 1)
         {
            this.FMC_Loading.stop();
            if(this.FOnCloseLoad != null)
            {
               this.FOnCloseLoad(this);
            }
         }
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
      
      public function get OnShowBattle() : Function
      {
         return this.FOnShowBattle;
      }
      
      public function set OnShowBattle(param1:Function) : void
      {
         this.FOnShowBattle = param1;
      }
      
      public function get OnCloseLoad() : Function
      {
         return this.FOnCloseLoad;
      }
      
      public function set OnCloseLoad(param1:Function) : void
      {
         this.FOnCloseLoad = param1;
      }
      
      public function get StatusLoading() : Boolean
      {
         return this.FStatusLoading;
      }
      
      public function Reset() : void
      {
         this.FMC_Loading.gotoAndStop(FRMAE_INDEX_EFFECT);
         this.FMC_Loading.stop();
         this.FTF_ProgressBar.text = "0%";
         this.FSP_ProgressBar.scaleX = 0;
         this.FStatusLoading = false;
         this.FSP_BackGround.visible = true;
         this.FSP_LoadBar.visible = true;
         TweenUtil.removeTween(this.FSP_ProgressBar,false);
      }
      
      public function PlayLoadedEffect() : void
      {
         this.FMC_Loading.play();
      }
      
      public function StartPlayerLoad() : void
      {
         this.FStatusLoading = true;
      }
      
      public function EndPlayerLoad() : void
      {
         this.FTickCloseLoad = 0;
         this.FTF_ProgressBar.text = "100%";
         this.FStatusLoading = false;
      }
   }
}

