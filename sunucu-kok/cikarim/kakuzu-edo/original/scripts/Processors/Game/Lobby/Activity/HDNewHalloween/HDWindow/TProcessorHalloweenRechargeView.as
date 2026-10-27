package Processors.Game.Lobby.Activity.HDNewHalloween.HDWindow
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewHalloween.THDNewHalloweenRechargeData;
   import Logics.Streamization.HDActivityNewHalloween.RechargeVo.TRechargeGiftVo;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_NewHalloween;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHalloweenRechargeView extends TProcessorHDSingleWindowBase
   {
      
      public static const AwardMax:int = 5;
      
      protected var FData:THDNewHalloweenRechargeData;
      
      protected var FScoreBtn:TUIButton;
      
      protected var FRechargeGoldTF:TextField;
      
      protected var FBackScoreTF:TextField;
      
      protected var FMyScoreTF:TextField;
      
      protected var FTotalGoldTF:TextField;
      
      protected var FEveryDayAwardSignVec:Vector.<Sprite>;
      
      protected var FEveryDayAwardEffectVec:Vector.<Sprite>;
      
      protected var FEveryDayAwardBtnVec:Vector.<TUIButton>;
      
      protected var FEveryDayAwardConTFVec:Vector.<TextField>;
      
      protected var FTotalGoldAwardSignVec:Vector.<Sprite>;
      
      protected var FTotalGoldAwardEffectVec:Vector.<Sprite>;
      
      protected var FTotalGoldAwardBtnVec:Vector.<TUIButton>;
      
      protected var FTotalGoldAwardConTFVec:Vector.<TextField>;
      
      protected var FNewHalloweenShop:TNewHalloweenScoreView;
      
      public function TProcessorHalloweenRechargeView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
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
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRechargeGiftVo = null;
         this.FData = param1 as THDNewHalloweenRechargeData;
         _loc3_ = int(this.FData.EveryDayAwardVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FData.EveryDayAwardVec[_loc2_];
            this.FEveryDayAwardBtnVec[_loc2_].Enabled = _loc4_.State == CONST_NewHalloween.ScanGetState;
            this.FEveryDayAwardConTFVec[_loc2_].text = _loc4_.Condition.toString();
            this.FEveryDayAwardEffectVec[_loc2_].visible = _loc4_.State == CONST_NewHalloween.ScanGetState;
            this.FEveryDayAwardSignVec[_loc2_].visible = _loc4_.State == CONST_NewHalloween.Finish;
            _loc2_++;
         }
         _loc3_ = int(this.FData.GoldAwardVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FData.GoldAwardVec[_loc2_];
            this.FTotalGoldAwardBtnVec[_loc2_].Enabled = _loc4_.State == CONST_NewHalloween.ScanGetState;
            this.FTotalGoldAwardConTFVec[_loc2_].text = _loc4_.Condition.toString();
            this.FTotalGoldAwardSignVec[_loc2_].visible = _loc4_.State == CONST_NewHalloween.Finish;
            this.FTotalGoldAwardEffectVec[_loc2_].visible = _loc4_.State == CONST_NewHalloween.ScanGetState;
            _loc2_++;
         }
         this.FMyScoreTF.text = this.FData.Score.toString();
         this.FTotalGoldTF.text = this.FData.TotalGold.toString();
         if(this.FNewHalloweenShop != null && this.FNewHalloweenShop.Visible)
         {
            this.FNewHalloweenShop.Data = this.FData;
            this.FNewHalloweenShop.RefreshView();
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FNewHalloweenShop != null)
         {
            this.FNewHalloweenShop.LogicsPerform_EnterFrame();
         }
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function OpenShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FNewHalloweenShop.Data = this.FData;
         this.FNewHalloweenShop.Show();
      }
      
      protected function GetDayAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FEveryDayAwardBtnVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.EveryDayAwardVec[_loc3_].Index);
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FEveryDayAwardBtnVec.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FData.EveryDayAwardVec[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function GetTotalGoldAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FTotalGoldAwardBtnVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.GoldAwardVec[_loc3_].Index);
      }
      
      protected function GiftTotalGoldBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FTotalGoldAwardBtnVec.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FData.GoldAwardVec[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc6_:TUIButton = null;
         var _loc7_:TextField = null;
         super.InitWindow(param1);
         this.FMyScoreTF = FScene["TF_MyScore"];
         this.FScoreBtn = new TUIButton();
         this.FScoreBtn.Substrate = FScene["Btn_ScoreShop"];
         this.FScoreBtn.OnClick = this.OpenShopOnClick;
         this.FTotalGoldTF = FScene["TF_TotalGold"];
         _loc3_ = AwardMax;
         this.FEveryDayAwardSignVec = new Vector.<Sprite>();
         this.FEveryDayAwardEffectVec = new Vector.<Sprite>();
         this.FEveryDayAwardBtnVec = new Vector.<TUIButton>();
         this.FEveryDayAwardConTFVec = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FScene["Item" + _loc2_];
            _loc5_ = _loc4_["MC_Sign"];
            this.FEveryDayAwardSignVec[_loc2_] = _loc5_;
            _loc5_ = _loc4_["MC_Effect"];
            this.FEveryDayAwardEffectVec[_loc2_] = _loc5_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_["MC_Pumpkin"];
            _loc6_.OnClick = this.GetDayAwardOnClick;
            _loc6_.OnMove = this.GiftBagOnMove;
            _loc6_.OnOut = this.GiftBagOnOut;
            this.FEveryDayAwardBtnVec[_loc2_] = _loc6_;
            _loc7_ = _loc4_["TF_Condition"];
            _loc7_.mouseEnabled = false;
            this.FEveryDayAwardConTFVec[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FTotalGoldAwardSignVec = new Vector.<Sprite>();
         this.FTotalGoldAwardBtnVec = new Vector.<TUIButton>();
         this.FTotalGoldAwardConTFVec = new Vector.<TextField>();
         this.FTotalGoldAwardEffectVec = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FScene["Pumpkin" + _loc2_];
            _loc5_ = _loc4_["MC_Sign"];
            this.FTotalGoldAwardSignVec[_loc2_] = _loc5_;
            _loc5_ = _loc4_["MC_Effect"];
            this.FTotalGoldAwardEffectVec[_loc2_] = _loc5_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_["BtnPumpkin"];
            _loc6_.OnClick = this.GetTotalGoldAwardOnClick;
            _loc6_.OnMove = this.GiftTotalGoldBagOnMove;
            _loc6_.OnOut = this.GiftBagOnOut;
            this.FTotalGoldAwardBtnVec[_loc2_] = _loc6_;
            _loc7_ = _loc4_["TF_Condition"];
            _loc7_.mouseEnabled = false;
            this.FTotalGoldAwardConTFVec[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FNewHalloweenShop = new TNewHalloweenScoreView(this);
         this.FNewHalloweenShop.SendData = this.SendServerData;
         FParent.addChild(this.FNewHalloweenShop);
      }
   }
}

