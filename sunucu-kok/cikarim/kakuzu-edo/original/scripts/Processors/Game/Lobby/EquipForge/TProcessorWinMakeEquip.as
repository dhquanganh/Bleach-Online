package Processors.Game.Lobby.EquipForge
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.EquipForge.TConfigEquipForge;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorWinMakeEquip extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FItemSelect:TProcessorGeneralItemSelect;
      
      protected var FSlotOld:TUISlot;
      
      protected var FSlotNew:TUISlot;
      
      protected var FCurOld:TInventory;
      
      protected var FBtn_Lock:TUIButton;
      
      protected var FBtn_Unlock:TUIButton;
      
      protected var FBtn_Ok:TUIButton;
      
      public function TProcessorWinMakeEquip(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ProcessorLock(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_Lock.Visible = false;
         this.FBtn_Unlock.Visible = true;
         this.FItemSelect.Lock(true);
         this.FBtn_Ok.Enabled = true;
      }
      
      protected function ProcessorUnlock(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_Lock.Visible = true;
         this.FBtn_Unlock.Visible = false;
         this.FItemSelect.mouseEnabled = true;
         this.FItemSelect.Lock(false);
         this.FBtn_Ok.Enabled = false;
      }
      
      protected function EquipFilter(param1:TInventories) : TInventories
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TInventories = null;
         var _loc7_:TBins = null;
         _loc6_ = new TInventories();
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EquipForge);
         _loc3_ = uint(SLogicsCore.Character.Equipments.Count);
         _loc5_ = uint(_loc7_.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(SLogicsCore.Character.Equipments.GetInventoryByIndex(_loc2_).IDTemplate == _loc7_.GetDatebaseByIndex(_loc4_).Identifier)
               {
                  _loc6_.Add(SLogicsCore.Character.Equipments.GetInventoryByIndex(_loc2_));
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function OnSelectItem(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:TConfigEquipForge = null;
         var _loc5_:uint = 0;
         var _loc6_:TInventories = null;
         var _loc7_:TInventories = null;
         _loc6_ = new TInventories();
         _loc7_ = new TInventories();
         _loc7_.Add(this.EquipFilter(SLogicsCore.Character.Equipments).GetInventoryByIndex(param3));
         this.FSlotOld.Context = _loc7_.GetInventoryByIndex(0);
         this.FCurOld = _loc7_.GetInventoryByIndex(0);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EquipForge,_loc7_.GetInventoryByIndex(0).IDTemplate) as TConfigEquipForge;
         _loc5_ = _loc4_.ItemId;
         SToolReward.GetInventoryByID(_loc5_,_loc6_);
         this.FSlotNew.Context = _loc6_.GetInventoryByIndex(0);
         this.FMainUI["TF_0"].text = _loc7_.GetInventoryByIndex(0).Name;
         this.FMainUI["TF_1"].text = _loc4_.RetCount + "";
         this.FBtn_Lock.Visible = true;
      }
      
      protected function ProcessorForge(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_ForgeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FCurOld.IDTemplate);
         _loc4_.writeUnsignedInt(this.FCurOld.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FMainUI["Effect"].play();
      }
      
      public function LogicsPerform() : void
      {
         this.FItemSelect.UpdateSlots();
         if(Visible != false)
         {
            this.FSlotNew.Update();
            this.FSlotOld.Update();
         }
      }
      
      public function Update() : void
      {
         this.FItemSelect.Update(this.EquipFilter(SLogicsCore.Character.Equipments));
         this.FBtn_Ok.Enabled = false;
         this.FBtn_Lock.Visible = false;
         this.FBtn_Unlock.Visible = false;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FMainUI = param1;
         this.FItemSelect = new TProcessorGeneralItemSelect(this);
         this.FItemSelect.UIDispatch(this.FMainUI.MC_ItemSelect);
         this.FItemSelect.Select = this.OnSelectItem;
         this.FBtn_Lock = new TUIButton();
         this.FBtn_Lock.Substrate = this.FMainUI["Btn_Lock"];
         this.FBtn_Lock.OnClick = this.ProcessorLock;
         this.FBtn_Unlock = new TUIButton();
         this.FBtn_Unlock.Substrate = this.FMainUI["Btn_Unlock"];
         this.FBtn_Unlock.OnClick = this.ProcessorUnlock;
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMainUI["Btn_OK"];
         this.FBtn_Ok.OnClick = this.ProcessorForge;
         this.FSlotOld = new TUISlot(this);
         this.FSlotOld.Resource = this.FMainUI.Old_Slot;
         this.FSlotOld.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotOld.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlotOld);
         this.FSlotOld.Init();
         this.FSlotNew = new TUISlot(this);
         this.FSlotNew.Resource = this.FMainUI.New_Slot;
         this.FSlotNew.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotNew.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlotNew);
         this.FSlotNew.Init();
         this.FBtn_Ok.Enabled = false;
      }
      
      public function Reset() : void
      {
         this.FSlotNew.Context = null;
         this.FSlotOld.Context = null;
         this.Update();
         this.FMainUI["TF_0"].text = "";
         this.FMainUI["TF_1"].text = "";
         this.FBtn_Ok.Enabled = false;
         this.ProcessorUnlock(null,null);
      }
   }
}

