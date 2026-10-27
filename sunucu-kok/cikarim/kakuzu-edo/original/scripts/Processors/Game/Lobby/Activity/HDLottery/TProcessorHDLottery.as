package Processors.Game.Lobby.Activity.HDLottery
{
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDLottery.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDLottery.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDLottery extends TProcessorHDSingleWindowsBase
   {
      
      public static const SIZE_Width:uint = 803;
      
      public static const SIZE_Height:uint = 513;
      
      public static const AttributeValue:Vector.<int> = Vector.<int>([110,3050,4620,20,17497,110,3050,4620,20,17497,110,3050,4620,20,17497,110,1005,1540,20,5832,110,1005,1540,20,5832,110,2010,3080,20,11664,110,3050,3850,20,15310,110,7550,11550,20,51033]);
      
      protected var FProcessorWindowLottery:TProcessorHDWindowLottery;
      
      protected var FData_Lottery:TActivityLottery;
      
      protected var FHD_Lottery:THDLottery;
      
      protected var FUnstreamizerActivityLottery:TUnstreamizerLottery;
      
      protected var FInventories:TInventories;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorHDLottery(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_Lottery;
         this.FData_Lottery = new TActivityLottery();
         this.FUnstreamizerActivityLottery = new TUnstreamizerLottery();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityLottery);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         var _loc2_:TBounds = null;
         super.InitWindows();
         this.FProcessorWindowLottery = new TProcessorHDWindowLottery(this);
         this.FProcessorWindowLottery.Visible = false;
         this.FProcessorWindowLottery.OnBtnCloseClick = ProcessorClose;
         this.FProcessorWindowLottery.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowLottery.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowLottery.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowLottery.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowLottery.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowLottery.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowLottery.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width;
         _loc1_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowLottery,_loc1_);
         this.FInventories = new TInventories();
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:* = 0;
         super.UpdateUIConfig();
         _loc4_ = 0;
         this.FHD_Lottery = FHDActivityConfig as THDLottery;
         _loc2_ = int(this.FHD_Lottery.Show.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            SToolReward.GetInventoryByID(this.FHD_Lottery.Show[_loc1_],this.FData_Lottery.DisplayInventories);
            _loc3_ = this.FData_Lottery.DisplayInventories.GetInventoryByIndex(this.FData_Lottery.DisplayInventories.Count - 1) as TEquipment;
            _loc3_.UpgradingLevel = AttributeValue[_loc4_++];
            _loc3_.BasisProperty[0] = AttributeValue[_loc4_++];
            if(_loc3_.UpgradingBasisProperty.length > 0)
            {
               _loc3_.UpgradingBasisProperty[0] = AttributeValue[_loc4_++];
            }
            else
            {
               _loc3_.UpgradingBasisProperty.push(AttributeValue[_loc4_++]);
            }
            _loc3_.FlushSpiritLevel = AttributeValue[_loc4_++];
            _loc3_.UpgradingFlushSpiritBasisProperty = AttributeValue[_loc4_++];
            _loc1_++;
         }
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityLottery.UnstreamizeUpdateLottery(FActivityInitRetData,this.FData_Lottery,this.FHD_Lottery);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowLottery.Show(FCurAtoms,this.FHD_Lottery,this.FData_Lottery);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(param1.Index == 99)
         {
            this.FData_Lottery.CurScore = param1.Status;
         }
         else if(param1.Index < 99)
         {
            this.FData_Lottery.ListCodes.push(param1.Status);
            this.FData_Lottery.IfNewTicketCreate = true;
            this.FData_Lottery.TimeStore = STimingCore.TickCount;
         }
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowLottery.Show(FCurAtoms,this.FHD_Lottery,this.FData_Lottery);
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         this.FData_Lottery.CurPrize = param2[0];
         this.FData_Lottery.IfGoldHeadChange = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowLottery.Show(FCurAtoms,this.FHD_Lottery,this.FData_Lottery);
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
      
      public function get OnEffectAcquireInventory() : Function
      {
         return this.FOnEffectAcquireInventory;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function get OnQueryShortcutCoordinate() : Function
      {
         return this.FOnQueryShortcutCoordinate;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FOnQueryShortcutCoordinate = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowLottery.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Lottery);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_Lottery == null)
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
         this.FInventories.Clear();
         this.FProcessorWindowLottery.Hide();
      }
      
      override public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         if(!this.Visible)
         {
            return;
         }
         if(param1.length <= 0)
         {
            return;
         }
      }
   }
}

