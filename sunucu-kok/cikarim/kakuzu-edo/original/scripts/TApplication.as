package
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Network.TTransceiver;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.System.TGarbageCollector;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUICore;
   import Foundation.UI.TUIRoot;
   import Foundation.Utilities.TUtilityMath;
   import Logics.Agent.SParametersCore;
   import Logics.Agent.Spaces.ParametersSpace;
   import Logics.SLogicsCore;
   import Processors.Accessories.Logger.TProcessorLogger;
   import Processors.Accessories.Performance.TProcessorPerformance;
   import Processors.Accessories.ResourceManagement.TProcessorResourceManagement;
   import Processors.Accessories.RightMenu.TRightMenu;
   import Processors.Accessories.TProcessorLoading;
   import Processors.Accessories.TProcessorResourcesVital;
   import Processors.Game.Lobby.ADBox.TProcessorADBox;
   import Processors.Game.TProcessorGameRoot;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.system.Security;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   use namespace ParametersSpace;
   
   [SWF(width="1250", height="650", backgroundColor="#000000", frameRate="30")]
   public class TApplication extends MovieClip
   {
      
      protected var FApplicationInitialized:Boolean;
      
      protected var FParametersInitialized:Boolean;
      
      protected var FGameInitLoadComplete:Boolean;
      
      protected var FUICore:TUICore;
      
      protected var FUIRoot:TUIRoot;
      
      protected var FProcessorResourcesVital:TProcessorResourcesVital;
      
      protected var FProcessorLoading:TProcessorLoading;
      
      protected var FProcessorGameRoot:TProcessorGameRoot;
      
      protected var FProcessorLogger:TProcessorLogger;
      
      protected var FProcessorPerformance:TProcessorPerformance;
      
      protected var FProcessorResourceManagement:TProcessorResourceManagement;
      
      protected var FMaskSubstrate:Sprite;
      
      protected var FRightMenu:TRightMenu;
      
      protected var FResourcesTimer:Timer;
      
      protected var FGarbageCollector:TGarbageCollector;
      
      protected var FTimeID:uint;
      
      public function TApplication()
      {
         super();
         if(stage != null)
         {
            this.Hack();
         }
         addEventListener(Event.ADDED,this.ApplicationOnAdded);
         addEventListener(Event.ENTER_FRAME,this.StageOnEnterFrame);
      }
      
      protected function Hack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         _loc1_ = this.numChildren;
         _loc2_ = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            this.removeChildAt(_loc2_);
            _loc2_--;
         }
      }
      
      protected function Initialize() : void
      {
         this.Initialize_Resize();
         this.Initialize_Parameters(root.loaderInfo.parameters);
         this.Initialize_Display();
         this.Initialize_Cores();
         this.Initialize_UISystem();
         this.Initialize_Processors();
         this.Initialize_Mask();
         this.Initialize_ResourcesTimer();
         this.Initialize_GarbageCollector();
         this.Initialize_ResourceManagement();
         TUtilityMath.InitLookTable();
         this.FApplicationInitialized = true;
      }
      
      protected function Initialize_Resize() : void
      {
         CONST_COMMON.STAGE_Width = this.stage.stageWidth;
         CONST_COMMON.STAGE_Height = this.stage.stageHeight;
         stage.addEventListener(Event.RESIZE,this.StageOnResize);
      }
      
      protected function Initialize_Parameters(param1:Object) : void
      {
         if(!this.FParametersInitialized)
         {
            Security.allowDomain("*");
            if(!SParametersCore.IsInitialization)
            {
               SParametersCore.CoerceProperties(param1);
            }
            this.FParametersInitialized = true;
         }
      }
      
      protected function Initialize_Display() : void
      {
         var _loc1_:Sprite = null;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.quality = StageQuality.HIGH;
         stage.frameRate = CONST_COMMON.STAGE_FrameRate;
         this.FRightMenu = new TRightMenu();
         this.FRightMenu.OnCopyDebugInfo = this.ProcessorOnCopyDebugInfo;
         _loc1_ = this.stage.getChildAt(0) as Sprite;
         _loc1_.contextMenu = this.FRightMenu.MyContextMenu;
         stage.showDefaultContextMenu = false;
      }
      
      protected function Initialize_Cores() : void
      {
         this.FUICore = new TUICore(stage);
      }
      
      protected function Initialize_UISystem() : void
      {
         this.FUIRoot = new TUIRoot(this.FUICore);
         this.FUIRoot.OnQuerySequenceCursor = this.UIRootOnQuerySequenceCursor;
      }
      
      protected function Initialize_Processors() : void
      {
         this.FProcessorResourcesVital = new TProcessorResourcesVital(this.FUIRoot);
         this.FProcessorLoading = new TProcessorLoading(this.FUIRoot);
         this.FProcessorLoading.OnLoadingCompleted = this.ProcessorOnLoadingCompleted;
         TProcessorADBox.LoadCompleteCall = this.InitLoadCompleteCall;
         TProcessorADBox.LoadRes();
         this.FProcessorGameRoot = new TProcessorGameRoot(this.FUIRoot);
         this.FProcessorGameRoot.Load();
         this.FProcessorPerformance = new TProcessorPerformance(this.FUIRoot);
         this.FProcessorPerformance.Visible = false;
         this.FProcessorLogger = new TProcessorLogger(this.FUIRoot);
         this.FProcessorLogger.Visible = false;
         this.FProcessorLogger.IsEnabled = SParametersCore.IsDebug;
      }
      
      protected function Initialize_Mask() : void
      {
         this.FMaskSubstrate = new Sprite();
         this.FMaskSubstrate.graphics.lineStyle(0,0,0);
         this.FMaskSubstrate.graphics.beginFill(0,0);
         this.FMaskSubstrate.graphics.drawRect(0,0,CONST_COMMON.STAGE_Width,CONST_COMMON.STAGE_Height);
         this.FMaskSubstrate.graphics.endFill();
         this.FUIRoot.addChild(this.FMaskSubstrate);
         this.FUIRoot.mask = this.FMaskSubstrate;
         this.FMaskSubstrate.mouseEnabled = false;
      }
      
      protected function Initialize_GarbageCollector() : void
      {
         this.FGarbageCollector = new TGarbageCollector();
         this.FGarbageCollector.Interval = 120002;
      }
      
      protected function Initialize_ResourceManagement() : void
      {
         this.FProcessorResourceManagement = new TProcessorResourceManagement();
         this.FProcessorResourceManagement.Interval = 120000;
      }
      
      protected function Initialize_ResourcesTimer() : void
      {
         this.FResourcesTimer = new Timer(0);
         this.FResourcesTimer.addEventListener(TimerEvent.TIMER,this.ResourcesTimerOnTimer);
         this.FResourcesTimer.start();
      }
      
      protected function Update() : void
      {
         this.Update_Cores();
      }
      
      protected function Update_Cores() : void
      {
         STimingCore.Update();
         SResourcesCore.Update();
         SNetworkCore.Update();
         SLogicsCore.Update();
         this.FUICore.Update();
      }
      
      protected function Process() : void
      {
         this.Process_Resources();
         this.Process_Network();
         this.Process_Logics();
         this.Process_Rendering();
         this.FGarbageCollector.Process();
         this.FProcessorResourceManagement.Process();
      }
      
      protected function Process_Resources() : void
      {
         this.FProcessorResourcesVital.ResourcesProcess();
         if(!this.FProcessorResourcesVital.ResourcesReady)
         {
            return;
         }
         if(this.FProcessorLoading != null)
         {
            this.FProcessorLoading.ResourcesProcess();
         }
         this.FProcessorGameRoot.ResourcesProcess();
      }
      
      protected function Process_Network() : void
      {
         var _loc1_:TTransceiver = null;
         var _loc2_:TPacket = null;
         _loc1_ = SNetworkCore.Transceiver;
         while(_loc1_.ReceivedPacketCount > 0)
         {
            _loc2_ = _loc1_.PacketReceive();
            this.FProcessorGameRoot.PacketProcess(_loc2_);
         }
      }
      
      protected function Process_Logics() : void
      {
         if(this.FProcessorLoading != null)
         {
            this.FProcessorLoading.LogicsProcess();
         }
         this.FProcessorGameRoot.LogicsProcess();
         this.FProcessorPerformance.LogicsProcess();
         this.FProcessorLogger.LogicsProcess();
      }
      
      protected function Process_Rendering() : void
      {
         this.FUIRoot.Render();
      }
      
      protected function ProcessorLoadingDispose() : void
      {
         clearTimeout(this.FTimeID);
         if(this.FProcessorLoading != null)
         {
            this.FProcessorLoading.Visible = false;
            this.FProcessorLoading.Dispose();
            this.FProcessorLoading.OnLoadingCompleted = null;
            this.FProcessorLoading = null;
         }
         this.FProcessorGameRoot.LoadingCompletedNtf();
      }
      
      protected function ApplicationOnAdded(param1:Event) : void
      {
         this.Hack();
      }
      
      protected function StageOnResize(param1:Event) : void
      {
         if(this.FUICore != null)
         {
            this.FUICore.UpdateStageSize();
         }
         if(this.FProcessorPerformance != null)
         {
            this.FProcessorPerformance.ProcessorsResize();
         }
         if(this.FProcessorGameRoot != null)
         {
            this.FProcessorGameRoot.ProcessorsResize();
         }
      }
      
      protected function ResourcesTimerOnTimer(param1:TimerEvent) : void
      {
         SResourcesCore.Update();
      }
      
      protected function StageOnEnterFrame(param1:Event) : void
      {
         if(stage == null)
         {
            return;
         }
         if(!this.FApplicationInitialized)
         {
            this.Initialize();
         }
         this.Update();
         this.Process();
      }
      
      protected function ProcessorOnLoadingCompleted(param1:Object) : void
      {
         this.FGameInitLoadComplete = true;
         this.InitLoadCompleteCall();
      }
      
      public function ProcessorOnCopyDebugInfo(param1:Object) : void
      {
         this.FProcessorLogger.CopyDebugInfo();
      }
      
      protected function UIRootOnQuerySequenceCursor(param1:Object, param2:uint, param3:uint, param4:TQueryAnimationSequence) : void
      {
         var _loc5_:TResourceRepositoryTexture = null;
         _loc5_ = SResourcesCore.TexturesLobby;
         param4.Value = _loc5_.GetAnimationSequenceByIdentifiers(param2,param3);
      }
      
      protected function InitLoadCompleteCall() : void
      {
         if(!TProcessorADBox.LoadComplete || !this.FGameInitLoadComplete)
         {
            return;
         }
         if(this.FTimeID == 0)
         {
            this.FTimeID = setTimeout(this.ProcessorLoadingDispose,1000);
            this.StageOnResize(null);
         }
      }
   }
}

