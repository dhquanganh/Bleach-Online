package Processors.Game.Lobby.Activity.HDFeedback.components
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDFeedback.VO.TFeedbackPageVO;
   import Logics.HDFeedback.VO.TFeedbackShowAwardVO;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TFeedbackPage1Com extends TProcessorLobbyWindow
   {
      
      protected const TotalGift:int = 5;
      
      protected var FData:TFeedbackPageVO;
      
      protected var FScene:MovieClip;
      
      protected var FGetBtns:Vector.<TUIButton>;
      
      protected var FLinkBtn:TUIButton;
      
      protected var FActivityID:int;
      
      protected var FCS:Function;
      
      protected var FProcessorOnGiftBoxMove:Function;
      
      protected var FProcessorOnGiftBoxOut:Function;
      
      public function TFeedbackPage1Com(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIButton = null;
         _loc5_ = param1 as TUIButton;
         _loc3_ = this.FData.ShowAwardList[_loc5_.Tag].CS_Index;
         _loc4_ = this.FData.ShowAwardList[_loc5_.Tag].CS_Bit;
         this.FCS(this.FActivityID,_loc3_,0,Vector.<int>([_loc4_]));
      }
      
      protected function OnLinkBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(this.FData.LinkID);
      }
      
      protected function OnGiftMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = int(_loc2_.Tag);
         this.FProcessorOnGiftBoxMove(this,this.FData.ShowAwardList[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnGiftOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop(2);
      }
      
      protected function OnGiftOut(param1:MouseEvent) : void
      {
         this.FProcessorOnGiftBoxOut(this);
         (param1.currentTarget as MovieClip).gotoAndStop(1);
      }
      
      public function set ActivityID(param1:int) : void
      {
         this.FActivityID = param1;
      }
      
      public function set CS(param1:Function) : void
      {
         this.FCS = param1;
      }
      
      public function set ProcessorOnGiftBoxOut(param1:Function) : void
      {
         this.FProcessorOnGiftBoxOut = param1;
      }
      
      public function set ProcessorOnGiftBoxMove(param1:Function) : void
      {
         this.FProcessorOnGiftBoxMove = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FScene != null)
         {
            this.FScene.visible = param1;
         }
      }
      
      public function UpdateDataBase(param1:TFeedbackPageVO) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TFeedbackShowAwardVO = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.FData = param1;
         if(Visible)
         {
            _loc2_ = 0;
            while(_loc2_ < this.TotalGift)
            {
               _loc3_ = this.FData.ShowAwardList[_loc2_];
               this.FGetBtns[_loc2_].Enabled = _loc3_.GiftState == CONST_ACTIVITY_MODE.Activity_CanReceive;
               _loc4_ = this.FScene["MC_Gift_" + _loc2_];
               _loc5_ = _loc4_.MC_Get;
               _loc5_.visible = _loc3_.GiftState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
               _loc2_++;
            }
            this.FScene.TF_Prog.text = this.FData.Progress;
         }
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.FScene = param1;
         this.FGetBtns = new Vector.<TUIButton>(this.TotalGift);
         _loc2_ = 0;
         while(_loc2_ < this.TotalGift)
         {
            _loc4_ = this.FScene["MC_Gift_" + _loc2_];
            _loc5_ = _loc4_.Btn_Get;
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc5_;
            _loc3_.OnClick = this.OnGetBtnClick;
            _loc3_.Tag = _loc2_;
            this.FGetBtns[_loc2_] = _loc3_;
            _loc5_ = _loc4_.MC_Gift;
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.OnGiftOver);
            _loc5_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnGiftMove);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.OnGiftOut);
            _loc5_.Tag = _loc2_;
            _loc2_++;
         }
         this.FLinkBtn = new TUIButton();
         this.FLinkBtn.Substrate = this.FScene.Btn_Link;
         this.FLinkBtn.OnClick = this.OnLinkBtnClick;
      }
   }
}

