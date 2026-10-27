package Processors.Game.Lobby.Activity.HDNewYear2017.windows
{
   import Components.Standard.TUIButton;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNewYear2017Task;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2017.TNewYear2017Task;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowNewYear2017Task extends TProcessorHDSingleWindowBase
   {
      
      protected var FTasks:Vector.<Sprite>;
      
      protected var FBag_0:TUIButton;
      
      protected var FBag_1:TUIButton;
      
      protected var FIsDone:Boolean;
      
      protected var FData:TNewYear2017Task;
      
      protected var FConfig:THDNewYear2017Task;
      
      public function TProcessorHDWindowNewYear2017Task(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2017Task;
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
         this.FData = param1 as TNewYear2017Task;
         FScene["TF_Score"].text = this.FData.Score + "";
         _loc3_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTasks[_loc2_]["TF_Text"].text = this.FConfig.Tasks[_loc2_].value + "";
            this.FTasks[_loc2_]["MC_Already"].visible = this.FData.TasksProgress[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         FScene["TF_Price_0"].text = this.FConfig.ThreeNum + "";
         this.FBag_0.Enabled = this.FData.Score >= this.FConfig.ThreeNum && this.FData.BagStatus[0] != -1 ? true : false;
         FScene["TF_Price_1"].text = this.FConfig.SixNum + "";
         this.FBag_1.Enabled = this.FData.Score >= this.FConfig.SixNum && this.FData.BagStatus[1] != -1 ? true : false;
      }
      
      protected function Bag0OnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.Bags[0],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function Bag1OnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.Bags[1],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorBag0Get(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ThreeIndex);
      }
      
      protected function ProcessorBag1Get(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.SixIndex);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible || this.FData == null)
         {
            return;
         }
         if(this.FData.TasksProgress[0] - STimingCore.ServerTick < 0)
         {
            if(!this.FIsDone && this.FData.TasksProgress[0] != -1)
            {
               this.FIsDone = true;
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Tasks[0].index);
            }
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 6;
         this.FTasks = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FTasks[_loc3_] = FScene["Task_" + _loc3_];
            _loc3_++;
         }
         this.FBag_0 = new TUIButton();
         this.FBag_0.Substrate = FScene["MC_Bag_0"];
         this.FBag_0.OnClick = this.ProcessorBag0Get;
         this.FBag_0.OnMove = this.Bag0OnMove;
         this.FBag_0.OnOut = this.BagsOnOut;
         this.FBag_1 = new TUIButton();
         this.FBag_1.Substrate = FScene["MC_Bag_1"];
         this.FBag_1.OnClick = this.ProcessorBag1Get;
         this.FBag_1.OnMove = this.Bag1OnMove;
         this.FBag_1.OnOut = this.BagsOnOut;
      }
   }
}

