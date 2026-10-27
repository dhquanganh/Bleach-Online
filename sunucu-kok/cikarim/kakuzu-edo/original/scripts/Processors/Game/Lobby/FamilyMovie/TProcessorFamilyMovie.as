package Processors.Game.Lobby.FamilyMovie
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_FAMILYMOVIE;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   
   public class TProcessorFamilyMovie extends TProcessorLobbyWindows
   {
      
      protected static const MOVIEFRAME_STEP_Start:uint = 1;
      
      protected static const MOVIEFRAME_STEP_One:uint = 65;
      
      protected static const MOVIEFRAME_STEP_Two:uint = 174;
      
      protected static const MOVIEFRAME_STEP_End:uint = 230;
      
      public static const PLOT_TYPE_Movie:int = 3;
      
      protected static const PLOT_POS_Befor:int = 1;
      
      protected static const PLOT_POS_End:int = 2;
      
      protected static const ID_Plot_One:uint = CONST_FAMILYMOVIE.ID_Plot_One;
      
      protected static const ID_Plot_Two:uint = CONST_FAMILYMOVIE.ID_Plot_Two;
      
      protected var FMC:MovieClip;
      
      protected var FIsPlay:Boolean;
      
      protected var FOnCheckPlot:Function;
      
      public function TProcessorFamilyMovie(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_FAMILYMOVIE.RESOURCESID_Swf_FamilyMovie);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.InitWindow();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsPlay)
         {
            if(this.FMC.currentFrame == MOVIEFRAME_STEP_One)
            {
               this.FIsPlay = false;
               this.FMC.stop();
               if(this.FOnCheckPlot != null)
               {
                  this.FOnCheckPlot(this,PLOT_TYPE_Movie,PLOT_POS_Befor,ID_Plot_One,this.ProcessorPlotEnd);
               }
            }
            else if(this.FMC.currentFrame == MOVIEFRAME_STEP_Two)
            {
               this.FIsPlay = false;
               this.FMC.stop();
               if(this.FOnCheckPlot != null)
               {
                  this.FOnCheckPlot(this,PLOT_TYPE_Movie,PLOT_POS_End,ID_Plot_Two,this.ProcessorPlotEnd);
               }
            }
            else if(this.FMC.currentFrame == MOVIEFRAME_STEP_End)
            {
               this.WindowOnClose();
            }
         }
      }
      
      protected function InitWindow() : void
      {
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_FAMILYMOVIE.RESOURCE_ClassName_MC_Main) as MovieClip;
         addChild(this.FMC);
         this.FMC.stop();
      }
      
      protected function ShowWindow() : void
      {
         this.FIsPlay = true;
         this.FMC.gotoAndPlay(MOVIEFRAME_STEP_Start);
         this.Visible = true;
      }
      
      protected function ProcessorPlotEnd(param1:Object) : void
      {
         this.FIsPlay = true;
         this.FMC.play();
      }
      
      protected function WindowOnClose() : void
      {
         this.FIsPlay = false;
         this.FMC.stop();
         this.FMC = null;
         SResourcesCore.TexturesSwfLobby.DeleteByIdentifier(CONST_FAMILYMOVIE.RESOURCESID_Swf_FamilyMovie);
         ProcessorClose();
      }
      
      public function get OnCheckPlot() : Function
      {
         return this.FOnCheckPlot;
      }
      
      public function set OnCheckPlot(param1:Function) : void
      {
         this.FOnCheckPlot = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.ShowWindow();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

