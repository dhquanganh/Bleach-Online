package Processors.Game.Lobby.Activity.HDRushInSeireitei.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDRushInSeireitei;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDRushInSeireitei.THDRushInSeireiteiData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TViewHDShop extends TProcessorHDSingleWindowBase
   {
      
      protected static const Gift_Num:int = 9;
      
      protected static const Can_Get:int = 1;
      
      protected static const CanNot_Get:int = 0;
      
      protected static const Has_Get:int = -1;
      
      protected var FTFScore:TextField;
      
      protected var FScoreCountVec:Vector.<TextField>;
      
      protected var FIconVec:Vector.<Sprite>;
      
      protected var FBtnVec:Vector.<TUIButton>;
      
      protected var FGiftVec:Vector.<TUIButton>;
      
      protected var FConfigData:THDRushInSeireitei;
      
      protected var FActivityData:THDRushInSeireiteiData;
      
      public function TViewHDShop(param1:TUIComponent)
      {
         super(param1);
         this.FScoreCountVec = new Vector.<TextField>();
         this.FIconVec = new Vector.<Sprite>();
         this.FBtnVec = new Vector.<TUIButton>();
         this.FGiftVec = new Vector.<TUIButton>();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as THDRushInSeireiteiData;
         this.FTFScore.text = this.FActivityData.CurScore + "";
         _loc3_ = int(this.FActivityData.ShopStatusVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FIconVec[_loc2_].visible = this.FActivityData.ShopStatusVec[_loc2_] == Has_Get;
            this.FBtnVec[_loc2_].Enabled = this.FActivityData.ShopStatusVec[_loc2_] == Can_Get;
            _loc2_++;
         }
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FConfigData.ShopScoreVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FScoreCountVec[_loc1_].text = this.FConfigData.ShopScoreVec[_loc1_] + "";
            _loc1_++;
         }
      }
      
      protected function GiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         _loc3_ = this.FGiftVec.indexOf(param1 as TUIButton);
         if(_loc3_ < 0)
         {
            return;
         }
         _loc4_ = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfigData.ShopAwardIdVec[_loc3_],_loc4_);
         ProcessorOnGiftBoxMove(param1,_loc4_);
      }
      
      protected function GiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnVec.indexOf(param1 as TUIButton);
         if(_loc3_ < 0)
         {
            return;
         }
         this.SendServerData(this.FConfigData.ShopIndexVec[_loc3_]);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         super.InitWindow(param1);
         _loc2_ = FScene["MC_awards"];
         _loc3_ = 0;
         while(_loc3_ < Gift_Num)
         {
            this.FScoreCountVec.push(_loc2_["MC_Gift_" + _loc3_]["MC_Exchange"]["TF_Count"]);
            this.FIconVec.push(_loc2_["MC_Gift_" + _loc3_]["MC_Get"]);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc2_["MC_Gift_" + _loc3_]["Btn_Gift"];
            _loc4_.OnMove = this.GiftOnMove;
            _loc4_.OnOut = this.GiftOnOut;
            this.FGiftVec.push(_loc4_);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc2_["MC_Gift_" + _loc3_]["Btn_Exchange"];
            _loc4_.OnClick = this.BtnOnClick;
            this.FBtnVec.push(_loc4_);
            _loc3_++;
         }
         this.FTFScore = _loc2_["TF_Count"];
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FConfigData = param2 as THDRushInSeireitei;
         this.FActivityData = param3 as THDRushInSeireiteiData;
         super.Show(param1,param2,param3);
      }
   }
}

