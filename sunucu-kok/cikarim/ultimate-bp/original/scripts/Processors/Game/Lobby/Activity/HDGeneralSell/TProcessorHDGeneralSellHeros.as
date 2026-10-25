package Processors.Game.Lobby.Activity.HDGeneralSell
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDIceHeros.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDGeneralSellHeros extends TProcessorHDSingleWindowsBase
   {
      
      protected static var SIZE_WIDTH_WINDOWICEHEROS:uint = 638;
      
      protected static var SIZE_HEIGHT_WINDOWICEHEROS:uint = 448;
      
      protected static const SIZE_WIDTH_WINDOWICEHEROSRANK:uint = 604;
      
      protected static const SIZE_HEIGHT_WINDOWICEHEROSRANK:uint = 436;
      
      protected var FDataIceHeros:TActivityIceHeros;
      
      protected var FHDIceHeros:THDIceHeros;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FRankInventories:Vector.<TInventories>;
      
      protected var FProcessorWindowGeneralSellHeros:TProcessorHDWindowGeneralSellHeros;
      
      protected var FProcessorWindowGeneralSellHerosRank:TProcessorHDWindowGeneralSellHerosRank;
      
      protected var FBoundsIceHeros:TBounds;
      
      protected var FBoundsIceHerosRank:TBounds;
      
      public function TProcessorHDGeneralSellHeros(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_IceHeros;
         this.FDataIceHeros = new TActivityIceHeros();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityGeneralSell);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         if(false)
         {
            SIZE_WIDTH_WINDOWICEHEROS = 756;
            SIZE_HEIGHT_WINDOWICEHEROS = 559;
         }
         this.FProcessorWindowGeneralSellHeros = new TProcessorHDWindowGeneralSellHeros(this);
         this.FProcessorWindowGeneralSellHeros.OnEffectText = EffectGenerateText;
         this.FProcessorWindowGeneralSellHeros.OnAwardsOver = this.ProcessorOnAwardsBoxMove;
         this.FProcessorWindowGeneralSellHeros.OnAwardsOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowGeneralSellHeros.OnGiftOver = this.ProcessorOnGiftMove;
         this.FProcessorWindowGeneralSellHeros.OnGiftOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowGeneralSellHeros.OnBtnCloseClick = this.WindowGeneralSellHerosOnClose;
         this.FProcessorWindowGeneralSellHeros.OnShowRankClick = this.ProcessorOnShowWindowRank;
         this.FProcessorWindowGeneralSellHeros.UpdateStatus = this.UpdateEffectNotify;
         this.FProcessorWindowGeneralSellHeros.SetRankInventories = this.ProcessorSetRankInventories;
         this.FProcessorWindowGeneralSellHeros.Visible = false;
         this.FBoundsIceHeros = new TBounds();
         this.FBoundsIceHeros.Width = SIZE_WIDTH_WINDOWICEHEROS;
         this.FBoundsIceHeros.Height = SIZE_HEIGHT_WINDOWICEHEROS;
         ComponentBoundsCenter(this.FProcessorWindowGeneralSellHeros,this.FBoundsIceHeros);
         this.FProcessorWindowGeneralSellHerosRank = new TProcessorHDWindowGeneralSellHerosRank(this);
         this.FProcessorWindowGeneralSellHerosRank.OnEffectText = EffectGenerateText;
         this.FProcessorWindowGeneralSellHerosRank.OnBagOver = this.ProcessorOnAwardsBoxMove;
         this.FProcessorWindowGeneralSellHerosRank.OnBagOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowGeneralSellHerosRank.OnRankClose = this.WindowGeneralSellHeroRankOnClose;
         this.FProcessorWindowGeneralSellHerosRank.Visible = false;
         this.FBoundsIceHerosRank = new TBounds();
         this.FBoundsIceHerosRank.Width = SIZE_WIDTH_WINDOWICEHEROSRANK;
         this.FBoundsIceHerosRank.Height = SIZE_HEIGHT_WINDOWICEHEROSRANK;
         ComponentBoundsCenter(this.FProcessorWindowGeneralSellHerosRank,this.FBoundsIceHerosRank);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDIceHeros = FHDActivityConfig as THDIceHeros;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         if(this.FDataIceHeros.AwardsCount <= 0)
         {
            this.ProcessorInitData();
         }
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateIceHeros(FActivityInitRetData,this.FDataIceHeros,this.FHDIceHeros);
         this.UpdateEffectNotify(this);
         if(!Visible)
         {
            return;
         }
         if(this.FProcessorWindowGeneralSellHeros.Visible)
         {
            this.FProcessorWindowGeneralSellHeros.Show(FCurAtoms,this.FHDIceHeros,this.FDataIceHeros);
         }
         if(this.FProcessorWindowGeneralSellHerosRank.Visible)
         {
            this.FProcessorWindowGeneralSellHerosRank.UpdateRankUI(this.FHDIceHeros,this.FDataIceHeros,this.FRankInventories);
         }
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityIHAward = null;
         var _loc5_:TActivityIHChipBox = null;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc2_ = uint(param1.Index);
         _loc3_ = param1.Status;
         if(this.FDataIceHeros.AwardsCount <= 0)
         {
            return;
         }
         _loc4_ = this.FDataIceHeros.GetAwardByUniqueIndex(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.Status = _loc3_;
         }
         _loc5_ = this.FDataIceHeros.GetChipBoxByUniqueIndex(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.Status = _loc3_;
         }
         this.UpdateEffectNotify(this);
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowGeneralSellHeros.Visible)
         {
            this.FProcessorWindowGeneralSellHeros.Show(FCurAtoms,this.FHDIceHeros,this.FDataIceHeros);
         }
      }
      
      protected function ProcessorInitData() : void
      {
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_IceHeros);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         GetActivityConfigByActivityAtoms(FCurAtoms);
      }
      
      protected function UpdateEffectNotify(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         if(this.FDataIceHeros.AwardsCount <= 0)
         {
            return;
         }
         _loc3_ = int(this.FDataIceHeros.AwardsCount);
         _loc4_ = uint(CONST_ACTIVITY_MODE.Activity_CanNotReceive);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataIceHeros.GetAwardByIndex(_loc2_).Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc4_ = uint(CONST_ACTIVITY_MODE.Activity_CanReceive);
               break;
            }
            _loc2_++;
         }
         _loc3_ = int(this.FDataIceHeros.ChipBoxCount);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataIceHeros.GetChipBoxByIndex(_loc2_).Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc4_ = uint(CONST_ACTIVITY_MODE.Activity_CanReceive);
               break;
            }
            _loc2_++;
         }
         FCurAtoms.Status = _loc4_;
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_IceHeros);
         }
      }
      
      protected function ProcessorSetRankInventories(param1:Object, param2:Vector.<TInventories>) : void
      {
         this.FRankInventories = param2;
      }
      
      protected function ProcessorOnAwardsBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      protected function ProcessorOnGiftMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:Vector.<String> = null;
         _loc4_ = param2 as TInventories;
         if(param3 != null)
         {
            _loc5_ = param3 as Vector.<String>;
         }
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ONEOFALL_ADDITION;
         FGiftBoxTipData.AdditionItemVec = _loc5_;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      protected function WindowGeneralSellHerosOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function WindowGeneralSellHeroRankOnClose(param1:Object) : void
      {
         this.FProcessorWindowGeneralSellHeros.Show(FCurAtoms,this.FHDIceHeros,this.FDataIceHeros);
         this.FProcessorWindowGeneralSellHerosRank.Visible = false;
      }
      
      protected function ProcessorOnShowWindowRank(param1:Object) : void
      {
         this.FProcessorWindowGeneralSellHeros.Hide();
         this.FProcessorWindowGeneralSellHerosRank.UpdateRankUI(this.FHDIceHeros,this.FDataIceHeros,this.FRankInventories);
         this.FProcessorWindowGeneralSellHerosRank.Visible = true;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FProcessorWindowGeneralSellHeros.OnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowGeneralSellHeros.Load();
            this.FProcessorWindowGeneralSellHerosRank.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_IceHeros);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDIceHeros == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         this.FProcessorWindowGeneralSellHeros.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FProcessorWindowGeneralSellHeros != null)
         {
            this.FProcessorWindowGeneralSellHeros.Hide();
         }
         if(this.FProcessorWindowGeneralSellHerosRank != null)
         {
            this.FProcessorWindowGeneralSellHerosRank.Reset();
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.ValuesChange(param1,param2);
         if(!this.Visible)
         {
            return;
         }
         this.FDataIceHeros.CurOwned = param2[0];
         this.FDataIceHeros.CurStage = param2[1];
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.UpdateEffectNotify(this);
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_IceHeros);
         }
      }
   }
}

