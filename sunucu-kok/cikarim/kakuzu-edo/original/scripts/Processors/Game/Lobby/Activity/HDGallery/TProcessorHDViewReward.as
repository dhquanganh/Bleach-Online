package Processors.Game.Lobby.Activity.HDGallery
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDGallery;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDGallery.THDGalleryData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDGallery.components.TGalleryGift;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDViewReward extends TProcessorHDSingleWindowBase
   {
      
      protected static const Gift_Num:int = 9;
      
      protected var FTFScore:TextField;
      
      protected var FGiftVec:Vector.<TGalleryGift>;
      
      protected var FBtn:TUIButton;
      
      protected var FConfigData:THDGallery;
      
      protected var FActivityData:THDGalleryData;
      
      protected var FFunclose:Function;
      
      public function TProcessorHDViewReward(param1:TUIComponent)
      {
         super(param1);
         this.FGiftVec = new Vector.<TGalleryGift>();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TGalleryGift = null;
         super.InitWindow(param1);
         this.FTFScore = FScene["MC_awards"]["TF_Count"];
         _loc2_ = 0;
         while(_loc2_ < Gift_Num)
         {
            _loc3_ = new TGalleryGift(this);
            _loc3_.Init(FScene["MC_awards"]["MC_Gift_" + _loc2_]);
            _loc3_.OnOver = this.GiftOnOver;
            _loc3_.OnOut = this.GiftOnOut;
            _loc3_.OnExchange = this.OnExchange;
            this.FGiftVec.push(_loc3_);
            _loc2_++;
         }
         this.FBtn = new TUIButton();
         this.FBtn.Substrate = FScene["Btn_close"];
         this.FBtn.OnClick = this.BtnOnClick;
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FFunclose != null)
         {
            this.FFunclose();
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as THDGalleryData;
         this.FTFScore.text = this.FActivityData.CurScore + "";
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         super.UpdateUIConfig();
         _loc1_ = 0;
         while(_loc1_ < Gift_Num)
         {
            this.FGiftVec[_loc1_].GiftIndex = this.FConfigData.BoxAwardIndexVec[_loc1_];
            this.FGiftVec[_loc1_].SetData(this.FConfigData.BoxAwardIdVec[_loc1_],this.FConfigData.BoxCostScoreVec[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function GiftOnOver(param1:TInventories) : void
      {
         ProcessorOnGiftBoxMove(FParent,param1);
      }
      
      protected function GiftOnOut() : void
      {
         ProcessorOnGiftBoxOut(FParent);
      }
      
      protected function OnExchange(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TGalleryGift = null;
         _loc3_ = param1 as TGalleryGift;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.GiftIndex);
      }
      
      public function get Funclose() : Function
      {
         return this.FFunclose;
      }
      
      public function set Funclose(param1:Function) : void
      {
         this.FFunclose = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FConfigData = param2 as THDGallery;
         this.FActivityData = param3 as THDGalleryData;
         super.Show(param1,param2,param3);
         UpdateUI();
      }
   }
}

