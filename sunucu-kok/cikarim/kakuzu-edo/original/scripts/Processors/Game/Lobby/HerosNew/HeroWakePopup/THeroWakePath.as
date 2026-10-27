package Processors.Game.Lobby.HerosNew.HeroWakePopup
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TWakeUpEquip;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventoryWake;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class THeroWakePath extends THeroWakeBase
   {
      
      protected const Wake_Path_Num:int = 4;
      
      protected const Color_Green:uint = 65280;
      
      protected const Color_Red:uint = 16711680;
      
      protected const Path_Split_Str:String = "> ";
      
      protected var FBtnCompose:TUIButton;
      
      protected var FTxtPath:TextField;
      
      protected var FTxtCost:TextField;
      
      protected var FUIPath0:Sprite;
      
      protected var FSideLine:Sprite;
      
      protected var FMidLine:Sprite;
      
      protected var FSlotPaths:Vector.<TUISlot>;
      
      protected var FTxtNums:Vector.<TextField>;
      
      protected var FInventoriesGroup:Vector.<TInventories>;
      
      protected var FSlotOnClick:Function;
      
      protected var FItemCount:int;
      
      protected var FWakeUpEquip:TWakeUpEquip;
      
      protected var FSlotIndexs:Vector.<int>;
      
      public function THeroWakePath(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:TextField = null;
         super.ResourcesPerform_UIDispatch();
         FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroWakePan_1") as Sprite;
         addChild(FMainUI);
         this.FUIPath0 = FMainUI["MC_Path_0"];
         FBtnClose = new TUIButton();
         FBtnClose.Substrate = FMainUI["Btn_Close"];
         FBtnClose.OnClick = BtnCloseOnClick;
         this.FBtnCompose = new TUIButton();
         this.FBtnCompose.Substrate = FMainUI["Btn_Compose"];
         this.FBtnCompose.OnClick = this.BtnComposeOnClick;
         this.FSlotPaths = new Vector.<TUISlot>(this.Wake_Path_Num);
         this.FTxtNums = new Vector.<TextField>(this.Wake_Path_Num);
         this.FInventoriesGroup = new Vector.<TInventories>(this.Wake_Path_Num);
         this.FSideLine = this.FUIPath0["MC_Line"];
         this.FMidLine = this.FUIPath0["MC_MidLine"];
         this.FTxtPath = FMainUI["Txt_Path"];
         this.FTxtCost = FMainUI["Txt_Cost"];
         _loc1_ = 0;
         while(_loc1_ < this.Wake_Path_Num)
         {
            _loc2_ = new TUISlot(this);
            _loc2_.Resource = this.FUIPath0["MC_Slot_" + _loc1_];
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.OnQuerySubscript = null;
            _loc2_.Init();
            this.FSlotPaths[_loc1_] = _loc2_;
            this.FInventoriesGroup[_loc1_] = new TInventories();
            if(_loc1_ != 0)
            {
               _loc2_.OnClick = this.ProcessorSlotOnClick;
               this.FTxtNums[_loc1_] = this.FUIPath0["Txt_Num_" + _loc1_];
            }
            _loc1_++;
         }
      }
      
      protected function BtnComposeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_WakeUp_ComposeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(FWakeIdentifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorSlotOnClick(param1:Object, param2:Object) : void
      {
         if(this.FSlotOnClick != null)
         {
            this.FSlotOnClick(this,param2 as TInventoryWake);
         }
      }
      
      protected function SetSlotsVisible(... rest) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 1;
         while(_loc2_ <= rest.length)
         {
            this.FSlotPaths[_loc2_].Visible = rest[_loc2_ - 1];
            this.FTxtNums[_loc2_].visible = rest[_loc2_ - 1];
            _loc2_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         _loc2_ = int(this.FSlotPaths.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotPaths[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function get SlotOnClick() : Function
      {
         return this.FSlotOnClick;
      }
      
      public function set SlotOnClick(param1:Function) : void
      {
         this.FSlotOnClick = param1;
      }
      
      public function SetWakePath() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:TInventoryWake = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         _loc2_ = FParentNames ? int(FParentNames.length) : 0;
         _loc3_ = "";
         _loc4_ = "";
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ += _loc4_ + this.Path_Split_Str + FParentNames[_loc1_] + "\n";
            _loc4_ += "   ";
            _loc1_++;
         }
         this.FWakeUpEquip = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,FWakeIdentifier) as TWakeUpEquip;
         SToolReward.GetInventoryByID(FWakeIdentifier,this.FInventoriesGroup[0]);
         _loc5_ = this.FInventoriesGroup[0].GetInventoryByTempletID(FWakeIdentifier) as TInventoryWake;
         FPathName = _loc5_.Name;
         _loc3_ += _loc4_ + this.Path_Split_Str + FPathName;
         this.FTxtPath.text = _loc3_;
         this.FTxtCost.text = this.FWakeUpEquip.CostPrice + "";
         this.FSlotPaths[0].Context = _loc5_;
         this.FItemCount = this.FWakeUpEquip.ComposeItemsCount;
         switch(this.FItemCount)
         {
            case 1:
               this.SetSlotsVisible(false,true,false);
               this.FSlotIndexs = Vector.<int>([2]);
               this.FSideLine.visible = false;
               this.FMidLine.visible = true;
               break;
            case 2:
               this.SetSlotsVisible(true,false,true);
               this.FSlotIndexs = Vector.<int>([1,3]);
               this.FSideLine.visible = true;
               this.FMidLine.visible = false;
               break;
            case 3:
               this.SetSlotsVisible(true,true,true);
               this.FSlotIndexs = Vector.<int>([1,2,3]);
               this.FSideLine.visible = true;
               this.FMidLine.visible = true;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FItemCount)
         {
            _loc7_ = this.FSlotIndexs[_loc1_];
            _loc6_ = this.FWakeUpEquip.GetComposeByIndex(_loc1_).Code;
            _loc8_ = int(SLogicsCore.Character.WakeEquip.GetCountByTempleteID(_loc6_));
            _loc9_ = this.FWakeUpEquip.GetComposeByIndex(_loc1_).Amount;
            SToolReward.GetInventoryByID(_loc6_,this.FInventoriesGroup[_loc7_]);
            this.FSlotPaths[_loc7_].Context = this.FInventoriesGroup[_loc7_].GetInventoryByTempletID(_loc6_);
            this.FTxtNums[_loc7_].text = _loc8_ + "/" + _loc9_;
            this.FTxtNums[_loc7_].textColor = _loc8_ >= _loc9_ ? this.Color_Green : this.Color_Red;
            if(_loc8_ < _loc9_)
            {
               _loc10_ = true;
            }
            _loc1_++;
         }
         this.FBtnCompose.Enabled = !_loc10_;
         this.Visible = true;
      }
      
      override public function SetData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         super.SetData();
         _loc1_ = 0;
         while(_loc1_ < this.FItemCount)
         {
            _loc2_ = this.FSlotIndexs[_loc1_];
            _loc5_ = this.FWakeUpEquip.GetComposeByIndex(_loc1_).Code;
            _loc3_ = int(SLogicsCore.Character.WakeEquip.GetCountByTempleteID(_loc5_));
            _loc4_ = this.FWakeUpEquip.GetComposeByIndex(_loc1_).Amount;
            this.FTxtNums[_loc2_].text = _loc3_ + "/" + _loc4_;
            this.FTxtNums[_loc2_].textColor = _loc3_ >= _loc4_ ? this.Color_Green : this.Color_Red;
            if(_loc3_ < _loc4_)
            {
               _loc6_ = true;
            }
            _loc1_++;
         }
         this.FBtnCompose.Enabled = !_loc6_;
      }
   }
}

