package Processors.Game.Lobby.Activity.HDTreasurehunt.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDTreasureHunt;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDTreasureHunt.TTreasureHunt;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDTreasurehunt.TUIComponent.TUIBlock;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowTreasureHunt extends TProcessorHDSingleWindowBase
   {
      
      protected var FItems:Vector.<TUIBlock>;
      
      protected var FWinChoose:Sprite;
      
      protected var FBtn_WinClose:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FUIndex:uint;
      
      protected var FItemIndex:int;
      
      protected var FData:TTreasureHunt;
      
      public function TProcessorHDWindowTreasureHunt(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDTreasureHunt = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDTreasureHunt;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TTreasureHunt;
         this.FData.ActivityID = FActivityAtoms.Identifier;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FItems[_loc2_].SetData(this.FData,-1);
            _loc2_++;
         }
         if(this.FData.CurMap != 0)
         {
            this.FItems[this.FData.CurMap - 1].SetData(this.FData,this.FData.FindItemIndexByAwardId(this.FData.CurItem));
         }
         FScene["MC_Item_0"]["MC_Mask"].visible = SLogicsCore.Character.VipLevel >= 1 ? false : true;
         FScene["MC_Item_1"]["MC_Mask"].visible = SLogicsCore.Character.VipLevel >= 6 ? false : true;
         FScene["MC_Item_2"]["MC_Mask"].visible = SLogicsCore.Character.VipLevel >= 10 ? false : true;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible && this.FData != null)
         {
            _loc2_ = 4;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Update();
               _loc1_++;
            }
            _loc2_ = 3;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FItems[_loc1_].LogicsPerform();
               _loc1_++;
            }
            if(this.FData.CurTime == 0)
            {
               _loc2_ = 3;
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FItems[_loc1_].Status("true");
                  _loc1_++;
               }
            }
            else if(this.FData.CurTime < STimingCore.ServerTick)
            {
               _loc2_ = 3;
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FItems[_loc1_].Status("false");
                  _loc1_++;
               }
               this.FItems[this.FData.CurMap - 1].Status("ready");
               FScene["TF_Time"].text = "00:00:00";
            }
            else if(this.FData.CurTime > STimingCore.ServerTick)
            {
               FScene["TF_Time"].text = TUtilityTiming.fomatTimeTwo(this.FData.CurTime - STimingCore.ServerTick).toString();
               _loc2_ = 3;
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FItems[_loc1_].Status("false");
                  _loc1_++;
               }
            }
         }
      }
      
      protected function SetItemsStatus(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = 3;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FItems[_loc3_].Status(param1);
            _loc3_++;
         }
      }
      
      protected function ProcessorOpenchooseWin(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_].Context = this.FData.Invs.GetInventoryByIndex(_loc3_ + param1 * 4);
            this.FWinChoose["MC_Item_" + _loc3_]["Text"].text = (this.FData.Invs.GetInventoryByIndex(_loc3_ + param1 * 4) as TInventory).Quantity + "";
            _loc3_++;
         }
         this.FUIndex = param1;
         this.FWinChoose.visible = true;
      }
      
      protected function ProcessorItemOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         this.FItems[this.FUIndex].SetData(this.FData,_loc2_);
         this.FWinChoose.visible = false;
      }
      
      protected function ProcessorWinClose(param1:Object, param2:MouseEvent) : void
      {
         this.FWinChoose.visible = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 3;
         this.FItems = new Vector.<TUIBlock>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FItems[_loc3_] = new TUIBlock(this);
            this.FItems[_loc3_].UIDispatch(FScene["MC_Item_" + _loc3_],_loc3_);
            this.FItems[_loc3_].OpenChooseWin = this.ProcessorOpenchooseWin;
            _loc3_++;
         }
         this.FWinChoose = FScene["MC_Choose"];
         this.FWinChoose.visible = false;
         this.FBtn_WinClose = new TUIButton();
         this.FBtn_WinClose.Substrate = this.FWinChoose["Btn_Close"];
         this.FBtn_WinClose.OnClick = this.ProcessorWinClose;
         _loc2_ = 4;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = this.FWinChoose["MC_Item_" + _loc3_]["Slot_0"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            this.FWinChoose["MC_Item_" + _loc3_].addEventListener(MouseEvent.CLICK,this.ProcessorItemOnClick);
            _loc3_++;
         }
      }
   }
}

