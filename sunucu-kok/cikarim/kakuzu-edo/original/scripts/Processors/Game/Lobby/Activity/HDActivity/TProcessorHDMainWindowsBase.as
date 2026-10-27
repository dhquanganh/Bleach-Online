package Processors.Game.Lobby.Activity.HDActivity
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import flash.utils.ByteArray;
   
   public class TProcessorHDMainWindowsBase extends TProcessorHDSingleWindowsBase
   {
      
      protected var FWindowWidth:Number;
      
      protected var FWindowHeight:Number;
      
      protected var FMainWindowReference:Class;
      
      protected var FResourceID:uint;
      
      protected var FMainType:uint;
      
      protected var FHDActivityConfigs:Vector.<THDActivityBase>;
      
      protected var FMainWindow:TProcessorHDMainWindowBase;
      
      public function TProcessorHDMainWindowsBase(param1:TUIComponent, param2:TLobbyParameters)
      {
         this.SetupParams();
         super(param1,param2);
      }
      
      protected function SetupParams() : void
      {
         throw new Error("子类必须重写此方法！");
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.FResourceID);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         this.FHDActivityConfigs = new Vector.<THDActivityBase>();
         _loc1_ = new TBounds();
         _loc1_.Width = this.FWindowWidth;
         _loc1_.Height = this.FWindowHeight;
         this.FMainWindow = new this.FMainWindowReference(this) as TProcessorHDMainWindowBase;
         this.FMainWindow.OnClose = this.WindowClose;
         this.FMainWindow.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FMainWindow.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FMainWindow.Visible = true;
         ComponentBoundsCenter(this.FMainWindow,_loc1_);
         super.InitWindows();
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:int = 0;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         if(param3 != null)
         {
            _loc5_ = param3 as int;
         }
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = _loc5_;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         if(!Visible)
         {
            return;
         }
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FMainWindow.SendActivityInitData(param1,FActivityInitRetData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         if(!Visible)
         {
            return;
         }
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FMainWindow.SendActivityChangeData(param1);
      }
      
      protected function InitActivityData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FHDActivityConfigs.length = 0;
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(this.FMainType);
         _loc2_ = int(FActivityAtomsVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            GetActivityConfigByActivityAtoms(FActivityAtomsVect[_loc1_]);
            this.FHDActivityConfigs.push(FHDActivityConfig);
            Perform_CS_ActivityInitReq(FActivityAtomsVect[_loc1_].Identifier);
            _loc1_++;
         }
         this.FMainWindow.InitActivityData(this.FHDActivityConfigs,FActivityAtomsVect);
      }
      
      protected function WindowClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWindow.Load();
            return;
         }
         this.InitActivityData();
         this.FMainWindow.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FMainWindow.Hide();
      }
   }
}

