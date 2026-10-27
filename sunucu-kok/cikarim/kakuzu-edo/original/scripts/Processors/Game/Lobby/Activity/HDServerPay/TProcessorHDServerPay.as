package Processors.Game.Lobby.Activity.HDServerPay
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDServerPay.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDServerPay.Window.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDServerPay extends TProcessorHDSingleWindowsBase
   {
      
      protected static const SIZE_WINDOWWIDTH_Main:uint = 713;
      
      protected static const SIZE_WINDOWHEIGHT_Main:uint = 480;
      
      protected static const SIZE_WINDOWWIDTH_Rank:uint = 381;
      
      protected static const SIZE_WINDOWHEIGHT_Rank:uint = 379;
      
      protected static const SIZE_WINDOWWIDTH_Shop:uint = 524;
      
      protected static const SIZE_WINDOWHEIGHT_Shop:uint = 476;
      
      protected var FProcessorWindowSPMain:TProcessorHDWindowSPMain;
      
      protected var FProcessorWindowSPRank:TProcessorHDWindowSPRank;
      
      protected var FProcessorWindowSPShop:TProcessorHDWindowSPExchangeShop;
      
      protected var FBoundsWindowMain:TBounds;
      
      protected var FBoundsWindowRank:TBounds;
      
      protected var FBoundsWindowShop:TBounds;
      
      protected var FIsInitData:Boolean;
      
      protected var FIsFirstEnter:Boolean;
      
      protected var FData_ServerPay:TActivityServerPay;
      
      protected var FHD_ServerPay:THDServerPay;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      public function TProcessorHDServerPay(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_ServerPay;
         this.FData_ServerPay = new TActivityServerPay();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
         this.FIsFirstEnter = true;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityServerPay);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowSPMain = new TProcessorHDWindowSPMain(this);
         this.FProcessorWindowSPMain.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         this.FProcessorWindowSPMain.OnLinkWindow = this.ProcessorOpenWindow;
         this.FProcessorWindowSPMain.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowSPMain.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowSPMain.Hide();
         this.FProcessorWindowSPRank = new TProcessorHDWindowSPRank(this);
         this.FProcessorWindowSPRank.OnWindowClose = this.ProcessorOpenWindow;
         this.FProcessorWindowSPRank.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowSPRank.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowSPRank.Hide();
         this.FProcessorWindowSPShop = new TProcessorHDWindowSPExchangeShop(this);
         this.FProcessorWindowSPShop.OnWindowClose = this.ProcessorOpenWindow;
         this.FProcessorWindowSPShop.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowSPShop.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowSPShop.Hide();
         this.FBoundsWindowMain = new TBounds();
         this.FBoundsWindowMain.Width = SIZE_WINDOWWIDTH_Main;
         this.FBoundsWindowMain.Height = SIZE_WINDOWHEIGHT_Main;
         ComponentBoundsCenter(this.FProcessorWindowSPMain,this.FBoundsWindowMain);
         this.FBoundsWindowRank = new TBounds();
         this.FBoundsWindowRank.Width = SIZE_WINDOWWIDTH_Rank;
         this.FBoundsWindowRank.Height = SIZE_WINDOWHEIGHT_Rank;
         ComponentBoundsCenter(this.FProcessorWindowSPRank,this.FBoundsWindowRank);
         this.FBoundsWindowShop = new TBounds();
         this.FBoundsWindowShop.Width = SIZE_WINDOWWIDTH_Shop;
         this.FBoundsWindowShop.Height = SIZE_WINDOWHEIGHT_Shop;
         ComponentBoundsCenter(this.FProcessorWindowSPShop,this.FBoundsWindowShop);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_ServerPay = FHDActivityConfig as THDServerPay;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_ServerPay);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_ServerPay == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateServerPay(FActivityInitRetData,this.FData_ServerPay,this.FHD_ServerPay);
         this.FIsInitData = true;
         this.SetServerPayStatus();
         if(!this.Visible)
         {
            return;
         }
         if(this.FIsFirstEnter)
         {
            this.ProcessorOpenWindow(CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Main);
         }
         else
         {
            this.ProcessorUpdateUIWindow();
         }
         this.FIsFirstEnter = false;
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(!this.FIsInitData)
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_ServerPay);
            FCurAtoms = GetAtomsByActivityID(FActivityID);
            if(FMemoryID != FCurAtoms.Identifier)
            {
               if(this.FHD_ServerPay == null)
               {
                  GetActivityConfigByActivityAtoms(FCurAtoms);
               }
               FMemoryID = FCurAtoms.Identifier;
            }
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
            return;
         }
         this.FData_ServerPay.UpdateStatus(param1.Index,param1.Status);
         this.ProcessorUpdateUIWindow();
         this.SetServerPayStatus();
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         if(!this.FIsInitData)
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_ServerPay);
            FCurAtoms = GetAtomsByActivityID(FActivityID);
            if(FMemoryID != FCurAtoms.Identifier)
            {
               if(this.FHD_ServerPay == null)
               {
                  GetActivityConfigByActivityAtoms(FCurAtoms);
               }
               FMemoryID = FCurAtoms.Identifier;
            }
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
            return;
         }
         this.FData_ServerPay.CurScore = param2[0];
         this.ProcessorUpdateUIWindow();
         this.SetServerPayStatus();
      }
      
      protected function SetServerPayStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.FIsInitData)
         {
            return;
         }
         _loc3_ = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         _loc2_ = int(this.FData_ServerPay.HerosData.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FData_ServerPay.HerosData[_loc1_].Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc3_ = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            _loc1_++;
         }
         _loc2_ = int(this.FData_ServerPay.ExchangeCount);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FData_ServerPay.GetExchangeByIndex(_loc1_).Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc3_ = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            _loc1_++;
         }
         FCurAtoms.Status = _loc3_;
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_ServerPay);
         }
      }
      
      protected function ProcessorUpdateUIWindow() : void
      {
         if(this.FProcessorWindowSPMain.Visible)
         {
            this.FProcessorWindowSPMain.Show(FCurAtoms,this.FHD_ServerPay,this.FData_ServerPay);
         }
         if(this.FProcessorWindowSPRank.Visible)
         {
            this.FProcessorWindowSPRank.Show(FCurAtoms,this.FHD_ServerPay,this.FData_ServerPay);
         }
         if(this.FProcessorWindowSPShop.Visible)
         {
            this.FProcessorWindowSPShop.Show(FCurAtoms,this.FHD_ServerPay,this.FData_ServerPay);
         }
      }
      
      protected function ProcessorsOnBtnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOpenWindow(param1:uint) : void
      {
         this.FProcessorWindowSPMain.Hide();
         this.FProcessorWindowSPRank.Hide();
         this.FProcessorWindowSPShop.Hide();
         switch(param1)
         {
            case CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Main:
               this.FProcessorWindowSPMain.Show(FCurAtoms,this.FHD_ServerPay,this.FData_ServerPay);
               break;
            case CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Rank:
               this.FProcessorWindowSPRank.Show(FCurAtoms,this.FHD_ServerPay,this.FData_ServerPay);
               break;
            case CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Shop:
               this.FProcessorWindowSPShop.Show(FCurAtoms,this.FHD_ServerPay,this.FData_ServerPay);
         }
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowSPMain.Load();
            this.FProcessorWindowSPRank.Load();
            this.FProcessorWindowSPShop.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_ServerPay);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_ServerPay == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowSPMain.Hide();
         this.FProcessorWindowSPRank.Hide();
         this.FProcessorWindowSPShop.Hide();
         this.FIsFirstEnter = true;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FProcessorWindowSPMain.OnCreateKnifeOfKillSoulData = param1;
      }
      
      public function ProcessorEffectNotify() : void
      {
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs);
         }
      }
   }
}

