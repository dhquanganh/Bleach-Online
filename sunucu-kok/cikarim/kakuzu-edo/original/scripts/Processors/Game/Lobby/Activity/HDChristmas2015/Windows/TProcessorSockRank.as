package Processors.Game.Lobby.Activity.HDChristmas2015.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChristmasSock;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.VO.TActivityChristmasSock;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDRankWindowBase;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorSockRank extends TProcessorHDRankWindowBase
   {
      
      protected static const RankGift_Num:int = 6;
      
      protected var FConfigData:THDChristmasSock;
      
      protected var FActivityData:TActivityChristmasSock;
      
      protected var FGiftBtnVec:Vector.<TUIButton>;
      
      protected var FTFRankVec:Vector.<TextField>;
      
      protected var FTFCount:TextField;
      
      public function TProcessorSockRank(param1:TUIComponent)
      {
         super(param1);
         this.FGiftBtnVec = new Vector.<TUIButton>();
         this.FTFRankVec = new Vector.<TextField>();
         FRankNum = 12;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as TActivityChristmasSock;
         FRankDatas = this.FActivityData.RankVec;
         this.FTFCount.text = this.FActivityData.SockNum + "";
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         super.UpdateUI();
         _loc1_ = 0;
         while(_loc1_ < RankGift_Num)
         {
            this.FTFRankVec[_loc1_].text = this.FConfigData.RankAwards[_loc1_].prompt;
            _loc1_++;
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         _loc3_ = this.FGiftBtnVec.indexOf(param1 as TUIButton);
         if(_loc3_ < 0)
         {
            return;
         }
         _loc4_ = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfigData.RankAwards[_loc3_].value,_loc4_);
         ProcessorOnGiftBoxMove(param1,_loc4_);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FConfigData = param2 as THDChristmasSock;
         this.FActivityData = param3 as TActivityChristmasSock;
         super.Show(param1,param2,param3);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         super.InitWindow(param1);
         _loc2_ = 0;
         while(_loc2_ < RankGift_Num)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = FScene["MC_List"]["MC_Gift_" + _loc2_]["Btn_Gift"];
            _loc3_.OnMove = this.BtnOnMove;
            _loc3_.OnOut = this.BtnOnOut;
            this.FGiftBtnVec.push(_loc3_);
            this.FTFRankVec.push(FScene["MC_List"]["MC_Gift_" + _loc2_]["TF_Rank"]);
            _loc2_++;
         }
         this.FTFCount = FScene["MC_List"]["TF_Score"];
      }
   }
}

