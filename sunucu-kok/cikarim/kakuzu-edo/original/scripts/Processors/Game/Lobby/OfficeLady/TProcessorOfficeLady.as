package Processors.Game.Lobby.OfficeLady
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Achievenment.TAchievementInfor;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_OFFICELADY;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorOfficeLady extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 595;
      
      protected static const WINDOW_HEIGHT:int = 467;
      
      protected var FProcessorWindowOfficeLady:TProcessorWindowOfficeLady;
      
      protected var FBounds:TBounds;
      
      protected var FOnShutDownFunction:Function;
      
      public function TProcessorOfficeLady(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowOfficeLady = new TProcessorWindowOfficeLady(this);
         this.FProcessorWindowOfficeLady.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowOfficeLady.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowOfficeLady.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowOfficeLady.OnEffectText = ProcessorsOnEffectText;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowOfficeLady,this.FBounds);
         this.FBounds = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_OFFICELADY.RESOURCESID_OFFICELDAY);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnShutDownFunction(param1:Function) : void
      {
         this.FOnShutDownFunction = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowOfficeLady.Load();
            return;
         }
         this.FProcessorWindowOfficeLady.Update();
         this.FProcessorWindowOfficeLady.visible = true;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowOfficeLady.Reset();
      }
      
      public function AchievementStateChangeNotify(param1:TAchievementInfor) : void
      {
         if(param1.ID == CONST_OFFICELADY.OfficeLadyAchievementID)
         {
            if(Visible)
            {
               this.FProcessorWindowOfficeLady.Update();
            }
            if(param1.IfGotReward && this.FOnShutDownFunction != null)
            {
               this.FOnShutDownFunction(this,CONST_SHORTCUTS.POSITION_SecondaryFunctionC,CONST_SHORTCUTS.TYPE_SecondaryFunctionC_OfficeLady);
            }
         }
      }
   }
}

