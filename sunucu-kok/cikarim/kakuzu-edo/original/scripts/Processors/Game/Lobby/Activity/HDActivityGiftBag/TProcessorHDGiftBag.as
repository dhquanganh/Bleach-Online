package Processors.Game.Lobby.Activity.HDActivityGiftBag
{
   import Foundation.Common.*;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorHDGiftBag extends TProcessorLobbyWindows
   {
      
      protected static const WINDOWSIZE_WIDTH_ONLINEGIFT:uint = 428;
      
      protected static const WINDOWSIZE_HEIGHT_ONLINEGIFT:uint = 368;
      
      protected static const WINDOWSIZE_WIDTH_GOLDGIFT:uint = 308;
      
      protected static const WINDOWSIZE_HEIGHT_GOLDGIFT:uint = 298;
      
      protected static const WINDOWSIZE_WIDTH_SEVENDAYGIFT:uint = 937;
      
      protected static const WINDOWSIZE_HEIGHT_SEVENDAYGIFT:uint = 529;
      
      protected static const WINDOWSIZE_WIDTH_OPENSERVERGIFT:uint = 478;
      
      protected static const WINDOWSIZE_HEIGHT_OPENSERVERGIFT:uint = 262;
      
      protected static const WINDOWSIZE_WIDTH_COLLECTGAMEGIFT:uint = 478;
      
      protected static const WINDOWSIZE_HEIGHT_COLLECTGAMEGIFT:uint = 262;
      
      protected static const WINDOWSIZE_WIDTH_LEVELGIFTBAG:uint = 659;
      
      protected static const WINDOWSIZE_HEIGHT_LEVELGIFTBAG:uint = 493;
      
      protected static const Activity_OnlineGiftBag:uint = CONST_ACTIVITY_MODE.Activity_OnlineGiftBag;
      
      protected static const Activity_GoldGiftBag:uint = CONST_ACTIVITY_MODE.Activity_GoldGiftBag;
      
      protected static const Activity_SevenDayGiftBag:uint = CONST_ACTIVITY_MODE.Activity_SevenDayGiftBag;
      
      protected static const Activity_OpenServerGiftBag:uint = CONST_ACTIVITY_MODE.Activity_OpenServerGiftBag;
      
      protected static const Activity_CollectGameGiftBag:uint = CONST_ACTIVITY_MODE.Activity_CollectGameGiftBag;
      
      protected static const Activity_OrderGiftBag:uint = CONST_ACTIVITY_MODE.Activity_OrderGiftBag;
      
      protected static const POSITION_ActiveList:uint = CONST_SHORTCUTS.POSITION_ActiveList;
      
      protected static const POSITION_ActiveListSecondary:uint = CONST_SHORTCUTS.POSITION_ActiveListSecondary;
      
      protected static const TYPE_SHORTCUTS_BaseNumber:uint = 14;
      
      protected static const TYPE_ActiveList_ReceivePacks:uint = CONST_SHORTCUTS.TYPE_ActiveList_ReceivePacks;
      
      protected var FActivityID:uint;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FActivityAtomsVect:Vector.<TActivityAtoms>;
      
      protected var FActivities:Vector.<TProcessorWindowGiftBase>;
      
      protected var FTypeActivityList:uint;
      
      protected var FCurActivityAtoms:TActivityAtoms;
      
      protected var FCurrentShowActivityWindowStore:TProcessorWindowGiftBase;
      
      protected var FStream:ByteArray;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FGiftOverLayer:TOverlayerGiftBox;
      
      protected var FBoundsOnlineWindows:TBounds;
      
      protected var FBoundsGoldWindows:TBounds;
      
      protected var FBoundsSevenDayWindows:TBounds;
      
      protected var FBoundsOpenServerWindows:TBounds;
      
      protected var FBoundsCollectGameWindows:TBounds;
      
      protected var FBoundsLevelGiftBagWindows:TBounds;
      
      protected var FGetActivityConfig:Function;
      
      protected var FEffectNotification:Function;
      
      protected var FSecondEffectNotification:Function;
      
      protected var FCheckActivityOnOffNotification:Function;
      
      public function TProcessorHDGiftBag(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FActivities = new Vector.<TProcessorWindowGiftBase>();
         this.FTypeActivityList = TYPE_ActiveList_ReceivePacks;
         this.ConstructActivity();
         this.FGiftBoxTipData = new TGiftBoxTipData();
      }
      
      protected function ConstructActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<Class> = null;
         var _loc4_:Class = null;
         _loc3_ = CONST_ACTIVITYGIFTBAGE.REFERENCE_Activity_Vector;
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            this.FActivities.push(new _loc4_(this));
            _loc1_++;
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityGB);
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityGB);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FGiftOverLayer = new TOverlayerGiftBox(this.Parent);
         this.FGiftOverLayer.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FGiftOverLayer);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function InitWindowResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FActivities.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.InitSingleActive(this.FActivities[_loc1_]);
            this.FActivities[_loc1_].Hide();
            _loc1_++;
         }
         this.FBoundsOnlineWindows = new TBounds();
         this.FBoundsOnlineWindows.Width = WINDOWSIZE_WIDTH_ONLINEGIFT;
         this.FBoundsOnlineWindows.Height = WINDOWSIZE_HEIGHT_ONLINEGIFT;
         ComponentBoundsCenter(this.FActivities[0],this.FBoundsOnlineWindows);
         this.FBoundsGoldWindows = new TBounds();
         this.FBoundsGoldWindows.Width = WINDOWSIZE_WIDTH_GOLDGIFT;
         this.FBoundsGoldWindows.Height = WINDOWSIZE_HEIGHT_GOLDGIFT;
         ComponentBoundsCenter(this.FActivities[1],this.FBoundsGoldWindows);
         this.FBoundsSevenDayWindows = new TBounds();
         this.FBoundsSevenDayWindows.Width = WINDOWSIZE_WIDTH_SEVENDAYGIFT;
         this.FBoundsSevenDayWindows.Height = WINDOWSIZE_HEIGHT_SEVENDAYGIFT;
         ComponentBoundsCenter(this.FActivities[2],this.FBoundsSevenDayWindows);
         this.FBoundsOpenServerWindows = new TBounds();
         this.FBoundsOpenServerWindows.Width = WINDOWSIZE_WIDTH_OPENSERVERGIFT;
         this.FBoundsOpenServerWindows.Height = WINDOWSIZE_HEIGHT_OPENSERVERGIFT;
         ComponentBoundsCenter(this.FActivities[3],this.FBoundsOpenServerWindows);
         this.FBoundsCollectGameWindows = new TBounds();
         this.FBoundsCollectGameWindows.Width = WINDOWSIZE_WIDTH_COLLECTGAMEGIFT;
         this.FBoundsCollectGameWindows.Height = WINDOWSIZE_HEIGHT_COLLECTGAMEGIFT;
         ComponentBoundsCenter(this.FActivities[4],this.FBoundsCollectGameWindows);
         this.FBoundsLevelGiftBagWindows = new TBounds();
         this.FBoundsLevelGiftBagWindows.Width = WINDOWSIZE_WIDTH_LEVELGIFTBAG;
         this.FBoundsLevelGiftBagWindows.Height = WINDOWSIZE_HEIGHT_LEVELGIFTBAG;
         ComponentBoundsCenter(this.FActivities[5],this.FBoundsLevelGiftBagWindows);
      }
      
      protected function InitSingleActive(param1:TProcessorWindowGiftBase) : void
      {
         param1.OnEffectText = ProcessorsOnEffectText;
         param1.OnClose = this.ProcessorWindowOnClose;
         param1.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         param1.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         param1.OnSlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
         param1.OnSlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
         param1.GetActivityConfig = this.FGetActivityConfig;
         param1.CheckOnOff = this.UpdateActivityOnOff;
         param1.OnGiftBoxOver = this.ProcessorOnGiftBoxMove;
         param1.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         param1.CheckSecondEffectNotification = this.UpdateActivityStatus;
         this.addChild(param1);
      }
      
      protected function ProcessorUpdateWindow() : void
      {
         this.FActivityAtomsVect = this.FActivityModes.GetActivityAtomsByMainType(TYPE_ActiveList_ReceivePacks);
         if(this.FCurrentShowActivityWindowStore != null)
         {
            this.FCurrentShowActivityWindowStore.Hide();
         }
         this.FCurActivityAtoms = this.GetAtomsByActivityID(this.FActivityID);
         if(this.FCurActivityAtoms != null)
         {
            this.FCurrentShowActivityWindowStore = this.GetActivityByID(this.FCurActivityAtoms.Identifier);
            this.FCurrentShowActivityWindowStore.Show(this.FCurActivityAtoms);
         }
      }
      
      protected function GetAtomsByActivityID(param1:uint) : TActivityAtoms
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TActivityAtoms = null;
         _loc3_ = this.FActivityAtomsVect.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FActivityAtomsVect[_loc2_];
            if(_loc4_.ActivityID == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function UpdateActivityStatus(param1:uint, param2:Boolean) : void
      {
         var _loc3_:TActivityAtoms = null;
         _loc3_ = this.FActivityModes.GetActivityAtomsByIdentifier(param1);
         if(this.FSecondEffectNotification != null)
         {
            this.FSecondEffectNotification(POSITION_ActiveListSecondary,_loc3_.SecondType,param2);
         }
         if(this.FEffectNotification != null)
         {
            this.FEffectNotification(this,this.FTypeActivityList);
         }
      }
      
      protected function UpdateActivityOnOff(param1:Object) : void
      {
         if(this.FCheckActivityOnOffNotification != null)
         {
            this.FCheckActivityOnOffNotification(param1);
         }
      }
      
      protected function GetActivityByID(param1:uint) : TProcessorWindowGiftBase
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TProcessorWindowGiftBase = null;
         var _loc5_:TActivityAtoms = null;
         _loc5_ = this.FActivityModes.GetActivityAtomsByIdentifier(param1);
         _loc3_ = int(this.FActivities.length);
         if(_loc5_ == null)
         {
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ < _loc3_)
               {
                  _loc4_ = this.FActivities[_loc2_];
                  if(_loc4_.MemoryID == param1)
                  {
                     break;
                  }
                  _loc2_++;
                  continue;
               }
            }
            return _loc4_;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FActivities[_loc2_];
            if(_loc4_.ActivityID == _loc5_.ActivityID)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function WindowUpdateActivityChangeState(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:TProcessorWindowGiftBase = null;
         _loc3_ = this.GetActivityByID(param1.Identifier);
         _loc3_.ChangeActivityStatus(param1,param2);
      }
      
      protected function WindowActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         var _loc3_:TProcessorWindowGiftBase = null;
         _loc3_ = this.GetActivityByID(param1.Identifier);
         _loc3_.ActivityInitRet(param2,param1);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         _loc4_ = param2 as TInventories;
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = _loc4_;
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         this.FGiftOverLayer.Context = this.FGiftBoxTipData;
         this.FGiftOverLayer.Render(FUICore.MouseCoordinate);
         this.FGiftOverLayer.Show();
      }
      
      protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         this.FGiftOverLayer.Hide();
      }
      
      public function get GetActivityConfig() : Function
      {
         return this.FGetActivityConfig;
      }
      
      public function set GetActivityConfig(param1:Function) : void
      {
         this.FGetActivityConfig = param1;
      }
      
      public function get EffectNotification() : Function
      {
         return this.FEffectNotification;
      }
      
      public function set EffectNotification(param1:Function) : void
      {
         this.FEffectNotification = param1;
      }
      
      public function get CheckActivityOnOffNotification() : Function
      {
         return this.FCheckActivityOnOffNotification;
      }
      
      public function set CheckActivityOnOffNotification(param1:Function) : void
      {
         this.FCheckActivityOnOffNotification = param1;
      }
      
      public function get SecondEffectNotification() : Function
      {
         return this.FSecondEffectNotification;
      }
      
      public function set SecondEffectNotification(param1:Function) : void
      {
         this.FSecondEffectNotification = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            if(param1 != null)
            {
               this.FStream = param1;
               this.FStream.position = 0;
               this.FActivityID = this.FStream.readUnsignedInt();
            }
            _loc3_ = int(this.FActivities.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FActivities[_loc2_].Load();
               _loc2_++;
            }
            return;
         }
         if(this.FStream == null)
         {
            this.FStream = param1;
         }
         this.FStream.position = 0;
         this.FActivityID = this.FStream.readUnsignedInt();
         this.ProcessorUpdateWindow();
         this.Visible = true;
         this.FStream = null;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FCurrentShowActivityWindowStore.Hide();
         this.Visible = false;
      }
      
      public function UpDateActivity() : void
      {
         if(this.FActivityModes.GetActivityAtomsByActivityID(Activity_OnlineGiftBag) != null)
         {
            this.FCurActivityAtoms = this.GetAtomsByActivityID(Activity_OnlineGiftBag);
            this.FCurrentShowActivityWindowStore = this.GetActivityByID(this.FCurActivityAtoms.Identifier);
         }
         if(this.FEffectNotification != null)
         {
            this.FEffectNotification(this,this.FTypeActivityList);
         }
      }
      
      public function LoadWindowResources() : void
      {
         this.InitWindowResources();
      }
      
      public function UpdateActivityChangeState(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         this.WindowUpdateActivityChangeState(param1,param2);
         if(param1 != null && param1.ActivityID == Activity_GoldGiftBag && param2.Status == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_VIP);
         }
      }
      
      public function ActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         this.WindowActivitiesInitRet(param1,param2);
      }
      
      public function ReciveOrderGiftBag() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:TActivityAtoms = null;
         if(this.FActivityAtomsVect == null)
         {
            this.FActivityAtomsVect = this.FActivityModes.GetActivityAtomsByMainType(TYPE_ActiveList_ReceivePacks);
         }
         _loc2_ = this.GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_OrderGiftBag);
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc1_.Data.writeUnsignedInt(_loc2_.Identifier);
         _loc1_.Data.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
      }
      
      public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
      }
   }
}

