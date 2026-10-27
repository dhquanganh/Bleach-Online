package Processors.Game.Lobby.Activity.HDLaborDay2016.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDLaborDayCultivation;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDLaborDay2016.TLaborDayCultivation;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorLaborCultivation extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Water:TUIButton;
      
      protected var FBtn_Weeding:TUIButton;
      
      protected var FBtn_WeedingOneKey:TUIButton;
      
      protected var FTF_WaterCount:TextField;
      
      protected var FTF_WeedingCount:TextField;
      
      protected var FTF_Score:TextField;
      
      protected var FTF_Costs:Vector.<TextField>;
      
      protected var FBtn_Bags:Vector.<TUIButton>;
      
      protected var FConfig:THDLaborDayCultivation;
      
      protected var FData:TLaborDayCultivation;
      
      public function TProcessorLaborCultivation(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDLaborDayCultivation = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDLaborDayCultivation;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 8;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_" + _loc1_]["TF_Cost"].text = this.FConfig.Gift.conditon[_loc1_];
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TLaborDayCultivation;
         this.FBtn_Water.Enabled = this.FConfig.Water.count - this.FData.WaterCount > 0 ? true : false;
         this.FBtn_Weeding.Enabled = this.FData.WeedingCount > 0 ? true : false;
         this.FBtn_WeedingOneKey.Enabled = this.FData.WeedingCount >= 10 ? true : false;
         _loc3_ = 8;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_" + _loc2_]["MC_Receive"].visible = this.FData.BagStatus[_loc2_] == 1 ? true : false;
            this.FBtn_Bags[_loc2_].Enabled = this.FData.Score >= this.FConfig.Gift.conditon[_loc2_];
            this.FBtn_Bags[_loc2_].Enabled = this.FData.BagStatus[_loc2_] == 0 ? this.FBtn_Bags[_loc2_].Enabled : false;
            _loc2_++;
         }
         FScene["TF_WaterCount"].text = this.FConfig.Water.count - this.FData.WaterCount + "";
         FScene["TF_WeedingCount"].text = this.FData.WeedingCount + "";
         FScene["TF_Score"].text = this.FData.Score + "";
      }
      
      protected function ProcessorWaterOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Water.index);
         FScene["MC_Effect"]["MC_Effect"].play();
      }
      
      protected function ProcessorWeedingOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = 10;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Weeding.index,0,_loc3_);
      }
      
      protected function ProcessorWeedingOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Weeding.index,0,_loc3_);
      }
      
      protected function ProcessorClickBags(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = param1.Tag;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift.index,0,_loc3_);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Gifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBtn_Water = new TUIButton();
         this.FBtn_Water.Substrate = FScene["Btn_Water"];
         this.FBtn_Water.OnClick = this.ProcessorWaterOnClick;
         this.FBtn_Weeding = new TUIButton();
         this.FBtn_Weeding.Substrate = FScene["Btn_Weeding"];
         this.FBtn_Weeding.OnClick = this.ProcessorWeedingOnClick;
         this.FBtn_WeedingOneKey = new TUIButton();
         this.FBtn_WeedingOneKey.Substrate = FScene["Btn_WeedingOneKey"];
         this.FBtn_WeedingOneKey.OnClick = this.ProcessorWeedingOneKeyOnClick;
         _loc2_ = 8;
         this.FBtn_Bags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Bags[_loc3_] = new TUIButton();
            this.FBtn_Bags[_loc3_].Substrate = FScene["MC_" + _loc3_]["Btn"];
            this.FBtn_Bags[_loc3_].OnClick = this.ProcessorClickBags;
            this.FBtn_Bags[_loc3_].Tag = _loc3_;
            this.FBtn_Bags[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FBtn_Bags[_loc3_].OnOut = this.ProcessorGiftOnOut;
            _loc3_++;
         }
      }
   }
}

