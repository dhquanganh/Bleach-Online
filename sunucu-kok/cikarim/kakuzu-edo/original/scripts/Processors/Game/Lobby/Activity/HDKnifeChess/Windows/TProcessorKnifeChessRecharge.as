package Processors.Game.Lobby.Activity.HDKnifeChess.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDKnifeChess.TKnifeChessRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorKnifeChessRecharge extends TProcessorHDSingleWindowBase
   {
      
      protected var FData:TKnifeChessRecharge;
      
      protected var FBags:Vector.<TUIButton>;
      
      protected var FBtn_Help:TUIButton;
      
      protected var FDescHint:THint;
      
      public function TProcessorKnifeChessRecharge(param1:TUIComponent)
      {
         super(param1);
         this.FDescHint = new THint();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
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
         this.FData = param1 as TKnifeChessRecharge;
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["TF_" + _loc2_].text = this.FData.Config.Recharge[_loc2_].gold + "";
            _loc2_++;
         }
         FScene["TF_HadRecharge"].text = this.FData.HadRecharge + "";
         FScene["TF_Zone"].text = this.FData.Config.CollectBag.num + "";
         FScene["TF_ZoneLast"].text = this.FData.Config.CollectBag.num - this.FData.ZoneHad >= 0 ? this.FData.Config.CollectBag.num - this.FData.ZoneHad : 0 + "";
         FScene["TF_Today"].text = this.FData.Today + "";
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["SP_AlreadyBuy_" + _loc2_].visible = this.FData.BagStatus[_loc2_] == -1;
            this.FBags[_loc2_].Enabled = !this.FData.BagStatus[_loc2_] == 0;
            _loc2_++;
         }
         if(this.FData.BagStatus[4] == -1)
         {
            FScene["SP_AlreadyBuy_4"].visible = true;
         }
         else
         {
            FScene["SP_AlreadyBuy_4"].visible = false;
            this.FBags[4].Enabled = this.FData.ZoneHad >= this.FData.Config.CollectBag.num && this.FData.Today > 0;
         }
         this.FDescHint.Caption = this.FData.Config.Desc;
      }
      
      protected function OnGiftBtnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.Bags[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnGiftBtnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function DescOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(param1,this.FDescHint);
      }
      
      protected function DescOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(param1,this.FDescHint);
      }
      
      protected function OnGiftBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(param1.Tag == 4)
         {
            FScene["MC_Effect"].play();
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag + 1);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.InitWindow(param1);
         _loc4_ = 5;
         this.FBags = new Vector.<TUIButton>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FBags[_loc3_] = new TUIButton();
            this.FBags[_loc3_].Substrate = FScene["MC_Bag_" + _loc3_];
            this.FBags[_loc3_].OnMove = this.OnGiftBtnMove;
            this.FBags[_loc3_].OnOut = this.OnGiftBtnOut;
            this.FBags[_loc3_].Tag = _loc3_;
            this.FBags[_loc3_].OnClick = this.OnGiftBtnClick;
            _loc3_++;
         }
         this.FBtn_Help = new TUIButton();
         this.FBtn_Help.Substrate = FScene["MC_HDDesc"];
         this.FBtn_Help.OnMove = this.DescOnMove;
         this.FBtn_Help.OnOut = this.DescOnOut;
      }
   }
}

