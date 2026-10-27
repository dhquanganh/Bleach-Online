package Processors.Game.Lobby.Activity.HDActivityEquipmentShop
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityEquipmentShop.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDEquipmentShop extends TProcessorHDSingleWindowsBase
   {
      
      protected static const SIZE_WIDTH_WINDOWEXCHANGE:uint = 769;
      
      protected static const SIZE_HEIGHT_WINDOWEXCHANGE:uint = 527;
      
      protected static const SIZE_WIDTH_WINDOWGETCHIP:uint = 559;
      
      protected static const SIZE_HEIGHT_WINDOWGETCHIP:uint = 456;
      
      protected static const SIZE_WIDTH_WINDOWEXCHANGEITEM:uint = 565;
      
      protected static const SIZE_HEIGHT_WINDOWEXCHANGEITEM:uint = 407;
      
      protected static const TYPE_EQUIPMENTSHOP_WindowExchange:uint = CONST_ACTIVITY_MODE.TYPE_EQUIPMENTSHOP_WindowExchange;
      
      protected static const TYPE_EQUIPMENTSHOP_WindowGetChip:uint = CONST_ACTIVITY_MODE.TYPE_EQUIPMENTSHOP_WindowGetChip;
      
      protected static const TYPE_EQUIPMENTSHOP_WindowExchangeItem:uint = CONST_ACTIVITY_MODE.TYPE_EQUIPMENTSHOP_WindowExchangeItem;
      
      protected var FProcessorWindowExchange:TProcessorHDWindowExchange;
      
      protected var FProcessorWindowGetChip:TProcessorHDWindowGetChip;
      
      protected var FProcessorWindowExchangeItem:TProcessorHDWindowExchangeItem;
      
      protected var FBoundsWindowExchange:TBounds;
      
      protected var FBoundsWindowGetChip:TBounds;
      
      protected var FBoundsWindowExchangeItem:TBounds;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FDataEquipmentShop:TActivitySingleEquipementShop;
      
      protected var FHDEquipmentShop:THDExchangeChip;
      
      public function TProcessorHDEquipmentShop(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_EquipmentShop;
         this.FProcessorWindowExchange = new TProcessorHDWindowExchange(this);
         this.FProcessorWindowExchange.OnBtnEnterClick = this.BtnSwitchWindow;
         this.FProcessorWindowExchange.OnBtnCloseClick = ProcessorClose;
         this.FProcessorWindowExchange.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowExchange.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowExchange.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowExchange.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowExchange.Visible = false;
         this.FProcessorWindowGetChip = new TProcessorHDWindowGetChip(this);
         this.FProcessorWindowGetChip.OnBtnCloseClick = this.BtnSwitchWindow;
         this.FProcessorWindowGetChip.OnGiftBoxMove = this.ProcessorOnGiftOver;
         this.FProcessorWindowGetChip.OnGiftBoxOut = this.ProcessorOnGiftOut;
         this.FProcessorWindowGetChip.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowGetChip.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowGetChip.Visible = false;
         this.FProcessorWindowExchangeItem = new TProcessorHDWindowExchangeItem(this);
         this.FProcessorWindowExchangeItem.OnBtnCloseClick = this.BtnSwitchWindow;
         this.FProcessorWindowExchangeItem.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowExchangeItem.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowExchangeItem.Visible = false;
         this.FBoundsWindowExchange = new TBounds();
         this.FBoundsWindowExchange.Width = SIZE_WIDTH_WINDOWEXCHANGE;
         this.FBoundsWindowExchange.Height = SIZE_HEIGHT_WINDOWEXCHANGE;
         ComponentBoundsCenter(this.FProcessorWindowExchange,this.FBoundsWindowExchange);
         this.FBoundsWindowGetChip = new TBounds();
         this.FBoundsWindowGetChip.Width = SIZE_WIDTH_WINDOWGETCHIP;
         this.FBoundsWindowGetChip.Height = SIZE_HEIGHT_WINDOWGETCHIP;
         ComponentBoundsCenter(this.FProcessorWindowGetChip,this.FBoundsWindowGetChip);
         this.FBoundsWindowExchangeItem = new TBounds();
         this.FBoundsWindowExchangeItem.Width = SIZE_WIDTH_WINDOWEXCHANGEITEM;
         this.FBoundsWindowExchangeItem.Height = SIZE_HEIGHT_WINDOWEXCHANGEITEM;
         ComponentBoundsCenter(this.FProcessorWindowExchangeItem,this.FBoundsWindowExchangeItem);
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
         this.FDataEquipmentShop = new TActivitySingleEquipementShop();
         this.FHDEquipmentShop = new THDExchangeChip();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityEquipmentShop);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDEquipmentShop = FHDActivityConfig as THDExchangeChip;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         if(FMemoryID == 0)
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_EquipmentShop);
            FCurAtoms = GetAtomsByActivityID(FActivityID);
            if(FMemoryID != FCurAtoms.Identifier)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
               FMemoryID = FCurAtoms.Identifier;
            }
         }
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateEquipmentShop(FActivityInitRetData,this.FDataEquipmentShop,this.FHDEquipmentShop);
         if(this.Visible)
         {
            this.BtnSwitchWindow(this,TYPE_EQUIPMENTSHOP_WindowExchange);
         }
         this.ProcessorCheckEffectNotification();
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc2_ = this.FDataEquipmentShop.SetStatus(param1.Index,param1.Status);
         if(_loc2_ < 0)
         {
            return;
         }
         if(this.FProcessorWindowExchange.Visible)
         {
            this.FProcessorWindowExchange.Show(FCurAtoms,this.FHDEquipmentShop,this.FDataEquipmentShop);
         }
         if(this.FProcessorWindowGetChip.Visible)
         {
            this.FProcessorWindowGetChip.Show(FCurAtoms,this.FHDEquipmentShop,this.FDataEquipmentShop);
         }
         if(this.FProcessorWindowExchangeItem.Visible)
         {
            this.FProcessorWindowExchangeItem.Show(FCurAtoms,this.FHDEquipmentShop,this.FDataEquipmentShop);
         }
         this.ProcessorCheckEffectNotification();
      }
      
      protected function ProcessorCheckEffectNotification() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FDataEquipmentShop.FreeDrawVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FDataEquipmentShop.FreeDrawVect[_loc1_].Count >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            _loc1_++;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_EquipmentShop);
         }
      }
      
      protected function BtnSwitchWindow(param1:Object, param2:uint) : void
      {
         this.FProcessorWindowExchange.Hide();
         this.FProcessorWindowExchangeItem.Hide();
         this.FProcessorWindowGetChip.Hide();
         switch(param2)
         {
            case TYPE_EQUIPMENTSHOP_WindowExchange:
               this.FProcessorWindowExchange.Show(FCurAtoms,this.FHDEquipmentShop,this.FDataEquipmentShop);
               break;
            case TYPE_EQUIPMENTSHOP_WindowGetChip:
               this.FProcessorWindowGetChip.Show(FCurAtoms,this.FHDEquipmentShop,this.FDataEquipmentShop);
               break;
            case TYPE_EQUIPMENTSHOP_WindowExchangeItem:
               this.FProcessorWindowExchangeItem.Show(FCurAtoms,this.FHDEquipmentShop,this.FDataEquipmentShop);
         }
      }
      
      protected function ProcessorOnGiftOver(param1:Object, param2:Object, param3:Object = null) : void
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
      
      protected function ProcessorOnGiftOut(param1:Object) : void
      {
         FGiftOverLayer.Hide();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowExchange.Load();
            this.FProcessorWindowGetChip.Load();
            this.FProcessorWindowExchangeItem.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_EquipmentShop);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            GetActivityConfigByActivityAtoms(FCurAtoms);
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         this.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowExchange.Hide();
         this.FProcessorWindowGetChip.Hide();
         this.FProcessorWindowExchangeItem.Hide();
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.ProcessorCheckEffectNotification();
      }
   }
}

