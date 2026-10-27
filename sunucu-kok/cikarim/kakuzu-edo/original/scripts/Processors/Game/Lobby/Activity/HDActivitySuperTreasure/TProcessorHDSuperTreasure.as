package Processors.Game.Lobby.Activity.HDActivitySuperTreasure
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TConditionStyleB;
   import Logics.DatebaseVO.VO.Json.TConditionStyleC;
   import Logics.DatebaseVO.VO.THDSuperTreasure;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivitySingle.TActivitySingleSuperTreasure;
   import Logics.Streamization.HDActivitySingle.TUnstreamizerActivitySingle;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows.TProcessorHDWindowPageA;
   import Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows.TProcessorHDWindowPageB;
   import Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows.TProcessorHDWindowPageC;
   import Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Windows.TProcessorHDWindowPageEnter;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDSuperTreasure extends TProcessorHDSingleWindowsBase
   {
      
      protected static const TYPE_SuperTreasure_PageEnter:int = CONST_ACTIVITY_MODE.TYPE_SuperTreasure_PageEnter;
      
      protected static const TYPE_SuperTreasure_PageA:int = CONST_ACTIVITY_MODE.TYPE_SuperTreasure_PageA;
      
      protected static const TYPE_SuperTreasure_PageB:int = CONST_ACTIVITY_MODE.TYPE_SuperTreasure_PageB;
      
      protected static const TYPE_SuperTreasure_PageC:int = CONST_ACTIVITY_MODE.TYPE_SuperTreasure_PageC;
      
      protected static const TYPE_SuperTreasure_WindowClose:int = CONST_ACTIVITY_MODE.TYPE_SuperTreasure_WindowClose;
      
      protected static const SIZE_WIDTH_WindowPageEnter:uint = 575;
      
      protected static const SIZE_HEIGHT_WindowPageEnter:uint = 362;
      
      protected static const SIZE_WIDTH_WindowPageTypeA:uint = 616;
      
      protected static const SIZE_HEIGHT_WindowPageTypeA:uint = 416;
      
      protected static const SIZE_WIDTH_WindowPageTypeB:uint = 616;
      
      protected static const SIZE_HEIGHT_WindowPageTypeB:uint = 416;
      
      protected var FProcessorWindowPageEnter:TProcessorHDWindowPageEnter;
      
      protected var FProcessorWindowPageA:TProcessorHDWindowPageA;
      
      protected var FProcessorWindowPageB:TProcessorHDWindowPageB;
      
      protected var FProcessorWindowPageC:TProcessorHDWindowPageC;
      
      protected var FBoundsPageEnter:TBounds;
      
      protected var FBoundsPageA:TBounds;
      
      protected var FBoundsPageB:TBounds;
      
      protected var FBoundsPageC:TBounds;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FDataSuperTreasure:TActivitySingleSuperTreasure;
      
      protected var FHDSuperTreasure:THDSuperTreasure;
      
      public function TProcessorHDSuperTreasure(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_SuperTreasure;
         this.FDataSuperTreasure = new TActivitySingleSuperTreasure();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivitySuperTreasure);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowPageEnter = new TProcessorHDWindowPageEnter(this);
         this.FProcessorWindowPageEnter.OnBtnCloseClick = this.ProcessorOnWindowOpen;
         this.FProcessorWindowPageEnter.OnBtnOkClick = this.ProcessorOnWindowOpen;
         this.FProcessorWindowPageEnter.Hide();
         this.FProcessorWindowPageA = new TProcessorHDWindowPageA(this);
         this.FProcessorWindowPageA.OnBtnCloseClick = this.ProcessorOnWindowOpen;
         this.FProcessorWindowPageA.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowPageA.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowPageA.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowPageA.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowPageA.Hide();
         this.FProcessorWindowPageB = new TProcessorHDWindowPageB(this);
         this.FProcessorWindowPageB.OnBtnCloseClick = this.ProcessorOnWindowOpen;
         this.FProcessorWindowPageB.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowPageB.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowPageB.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowPageB.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowPageB.Hide();
         this.FProcessorWindowPageC = new TProcessorHDWindowPageC(this);
         this.FProcessorWindowPageC.OnBtnCloseClick = this.ProcessorOnWindowOpen;
         this.FProcessorWindowPageC.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowPageC.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowPageC.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowPageC.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowPageC.Hide();
         this.FBoundsPageEnter = new TBounds();
         this.FBoundsPageEnter.Width = SIZE_WIDTH_WindowPageEnter;
         this.FBoundsPageEnter.Height = SIZE_HEIGHT_WindowPageEnter;
         ComponentBoundsCenter(this.FProcessorWindowPageEnter,this.FBoundsPageEnter);
         this.FBoundsPageA = new TBounds();
         this.FBoundsPageA.Width = SIZE_WIDTH_WindowPageTypeA;
         this.FBoundsPageA.Height = SIZE_HEIGHT_WindowPageTypeA;
         ComponentBoundsCenter(this.FProcessorWindowPageA,this.FBoundsPageA);
         this.FBoundsPageB = new TBounds();
         this.FBoundsPageB.Width = SIZE_WIDTH_WindowPageTypeA;
         this.FBoundsPageB.Height = SIZE_HEIGHT_WindowPageTypeA;
         ComponentBoundsCenter(this.FProcessorWindowPageB,this.FBoundsPageA);
         this.FBoundsPageC = new TBounds();
         this.FBoundsPageC.Width = SIZE_WIDTH_WindowPageTypeB;
         this.FBoundsPageC.Height = SIZE_HEIGHT_WindowPageTypeB;
         ComponentBoundsCenter(this.FProcessorWindowPageC,this.FBoundsPageC);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDSuperTreasure = FHDActivityConfig as THDSuperTreasure;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateSuperTreasure(this.FDataSuperTreasure,FActivityInitRetData);
         this.ProcessorOnWindowOpen(this,TYPE_SuperTreasure_PageEnter);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FDataSuperTreasure.StatusInfos.GetStatusInfoByLimitID(param1.Index).Count = param1.Status;
         if(this.FProcessorWindowPageA.Visible)
         {
            this.FProcessorWindowPageA.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
         }
         if(this.FProcessorWindowPageB.Visible)
         {
            this.FProcessorWindowPageB.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
         }
         if(this.FProcessorWindowPageC.Visible)
         {
            this.FProcessorWindowPageC.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
         }
      }
      
      protected function ProcessorGetPageIndexByLimit(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TConditionStyleC = null;
         var _loc7_:TConditionStyleB = null;
         var _loc8_:int = 0;
         _loc8_ = 0;
         _loc2_ = int(this.FHDSuperTreasure.Page3.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = this.FHDSuperTreasure.Page3[_loc3_];
            _loc5_ = int(_loc6_.Value.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc7_ = _loc6_.Value[_loc4_];
               if(_loc7_.Index == param1)
               {
                  _loc8_ = _loc3_;
                  break;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc8_;
      }
      
      protected function ProcessorBtnOnOk(param1:Object) : void
      {
      }
      
      override protected function ProcessorOnWindowOpen(param1:Object, param2:uint) : void
      {
         super.ProcessorOnWindowOpen(param1,param2);
         this.FProcessorWindowPageEnter.Hide();
         this.FProcessorWindowPageA.Hide();
         this.FProcessorWindowPageB.Hide();
         this.FProcessorWindowPageC.Hide();
         switch(param2)
         {
            case TYPE_SuperTreasure_PageEnter:
               this.FProcessorWindowPageEnter.Show(FCurAtoms,this.FHDSuperTreasure,null);
               break;
            case TYPE_SuperTreasure_PageA:
               this.FProcessorWindowPageA.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
               break;
            case TYPE_SuperTreasure_PageB:
               this.FProcessorWindowPageB.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
               break;
            case TYPE_SuperTreasure_PageC:
               this.FProcessorWindowPageC.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
               break;
            case TYPE_SuperTreasure_WindowClose:
               ProcessorClose();
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPageEnter.Load();
            this.FProcessorWindowPageA.Load();
            this.FProcessorWindowPageB.Load();
            this.FProcessorWindowPageC.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SuperTreasure);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDSuperTreasure == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         this.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowPageEnter.Hide();
         this.FProcessorWindowPageA.Hide();
         this.FProcessorWindowPageB.Hide();
         this.FProcessorWindowPageC.Hide();
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.ValuesChange(param1,param2);
         _loc4_ = param2.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FDataSuperTreasure.Page3BuyedCount[this.ProcessorGetPageIndexByLimit(_loc3_)] = param2[_loc3_];
            _loc3_++;
         }
         if(this.FProcessorWindowPageA.Visible)
         {
            this.FProcessorWindowPageA.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
         }
         if(this.FProcessorWindowPageB.Visible)
         {
            this.FProcessorWindowPageB.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
         }
         if(this.FProcessorWindowPageC.Visible)
         {
            this.FProcessorWindowPageC.Show(FCurAtoms,this.FHDSuperTreasure,this.FDataSuperTreasure);
         }
      }
   }
}

