package Processors.Game.Lobby.Activity.HDThanksGivingDay2016.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDTGD_3;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksGivingDay2016.TTGD_3;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorTGD2016_3 extends TProcessorHDSingleWindowBase
   {
      
      protected var FBag_0:TUIButton;
      
      protected var FBag_1:TUIButton;
      
      protected var FProgress:Sprite;
      
      protected var FConfig:THDTGD_3;
      
      protected var FData:TTGD_3;
      
      public function TProcessorTGD2016_3(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDTGD_3 = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDTGD_3;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["TF_phase_" + _loc1_].text = this.FConfig.PayInfo[_loc1_].pay + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TTGD_3;
         FScene["TF_Recharge"].text = this.FData.Recharge + "";
         FScene["TF_MyRecharge"].text = this.FData.MyRecharge + "";
         FScene["TF_Last_0"].text = this.FData.StatusBag_0 + "";
         FScene["TF_Last_1"].text = this.FData.StatusBag_1 + "";
         this.FBag_0.Enabled = this.FData.StatusBag_0 >= 1 ? true : false;
         this.FBag_1.Enabled = this.FData.StatusBag_1 >= 1 ? true : false;
         if(this.FData.Recharge / this.FConfig.PayInfo[this.FConfig.PayInfo.length - 1].pay >= 1)
         {
            this.FProgress.width = 593;
         }
         else
         {
            this.FProgress.width = 593 * (this.FData.Recharge / this.FConfig.PayInfo[this.FConfig.PayInfo.length - 1].pay);
         }
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         if(_loc3_ == 1)
         {
            ProcessorOnGiftBoxMove(this,this.FData.Bag_0,TOverlayerGiftBox.TYPE_ALL);
         }
         else
         {
            ProcessorOnGiftBoxMove(this,this.FData.Bag_1,TOverlayerGiftBox.TYPE_ALL);
         }
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBag_0 = new TUIButton();
         this.FBag_0.Substrate = FScene["MC_Gift_0"];
         this.FBag_0.OnClick = this.ProcessorGet;
         this.FBag_0.OnMove = this.ProcessorGiftOnMove;
         this.FBag_0.OnOut = this.ProcessorGiftOnOut;
         this.FBag_0.Tag = 1;
         this.FBag_1 = new TUIButton();
         this.FBag_1.Substrate = FScene["MC_Gift_1"];
         this.FBag_1.OnClick = this.ProcessorGet;
         this.FBag_1.OnMove = this.ProcessorGiftOnMove;
         this.FBag_1.OnOut = this.ProcessorGiftOnOut;
         this.FBag_1.Tag = 2;
         this.FProgress = FScene["MC_Bar"];
      }
   }
}

