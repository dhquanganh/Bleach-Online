package Processors.Game.Lobby.Activity.HDActivityLimitBuy
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityLimitBuy.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDLimitBuy extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_SIZE_WIDTH:uint = 649;
      
      protected static const WINDOW_SIZE_HEIGHT:uint = 510;
      
      protected static const COUNT_AWARDS_List:uint = 8;
      
      protected var FDataLimitBuy:TActivityLimitBuy;
      
      protected var FHDLimitBuy:THDActivityLimitBuy;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FProcessorWindowLimitBuy:TProcessorHDWindowLimitBuy;
      
      protected var FBounds:TBounds;
      
      public function TProcessorHDLimitBuy(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_LimitBuy;
         this.FDataLimitBuy = new TActivityLimitBuy();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityLimitBuy);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowLimitBuy = new TProcessorHDWindowLimitBuy(this);
         this.FProcessorWindowLimitBuy.OnEffectText = EffectGenerateText;
         this.FProcessorWindowLimitBuy.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowLimitBuy.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowLimitBuy.OnBtnCloseClick = this.BtnOnCloseClick;
         this.FProcessorWindowLimitBuy.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_SIZE_WIDTH;
         this.FBounds.Height = WINDOW_SIZE_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowLimitBuy,this.FBounds);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDLimitBuy = FHDActivityConfig as THDActivityLimitBuy;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         if(this.FHDLimitBuy == null || this.FHDLimitBuy.BuyLimitItems.length <= 0)
         {
            this.ProcessorInitData();
         }
         this.UpdateEffectNotify(this);
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateLimitBuy(FActivityInitRetData,this.FDataLimitBuy,this.FHDLimitBuy);
         this.FProcessorWindowLimitBuy.Show(FCurAtoms,this.FHDLimitBuy,this.FDataLimitBuy);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TActivityLimitBuyItem = null;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc2_ = uint(param1.Index);
         _loc3_ = param1.Status;
         _loc4_ = param1.Condition;
         if(this.FDataLimitBuy == null)
         {
            return;
         }
         _loc5_ = this.FDataLimitBuy.GetItemByUniqueIndex(_loc2_);
         if(_loc5_ != null)
         {
            if(_loc3_ != -1)
            {
               _loc5_.BuyCount = _loc3_;
            }
            _loc5_.ServerCount = _loc4_[0];
         }
         this.UpdateEffectNotify(this);
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowLimitBuy.Visible)
         {
            this.FProcessorWindowLimitBuy.Show(FCurAtoms,this.FHDLimitBuy,this.FDataLimitBuy);
         }
      }
      
      protected function ProcessorInitData() : void
      {
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_LimitBuy);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         GetActivityConfigByActivityAtoms(FCurAtoms);
      }
      
      protected function UpdateEffectNotify(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityLimitBuyItem = null;
         if(this.FDataLimitBuy == null || this.FDataLimitBuy.GetLimitBuyItemByIndex(0) == null)
         {
            return;
         }
         _loc3_ = int(COUNT_AWARDS_List);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FDataLimitBuy.GetLimitBuyItemByIndex(_loc2_);
            if(_loc4_.BuyCount > 0 && _loc4_.IsReachCondition)
            {
               if(_loc4_.ServerCount > 0)
               {
                  FCurAtoms.Status == CONST_ACTIVITY_MODE.Activity_CanReceive;
                  break;
               }
               FCurAtoms.Status == CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            else
            {
               FCurAtoms.Status == CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            _loc2_++;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_LimitBuy);
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
      
      protected function BtnOnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowLimitBuy.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_LimitBuy);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDLimitBuy == null)
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
         if(this.FProcessorWindowLimitBuy != null)
         {
            this.FProcessorWindowLimitBuy.Hide();
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivityLimitBuyItem = null;
         super.ValuesChange(param1,param2);
         if(this.FDataLimitBuy == null || this.FDataLimitBuy.GetLimitBuyItemByIndex(0) == null)
         {
            return;
         }
         _loc4_ = int(COUNT_AWARDS_List);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FDataLimitBuy.GetLimitBuyItemByIndex(_loc3_);
            _loc5_.Value = param2[0];
            _loc3_++;
         }
         if(this.FProcessorWindowLimitBuy.Visible)
         {
            this.FProcessorWindowLimitBuy.Show(FCurAtoms,this.FHDLimitBuy,this.FDataLimitBuy);
         }
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.UpdateEffectNotify(this);
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_LimitBuy);
         }
      }
   }
}

