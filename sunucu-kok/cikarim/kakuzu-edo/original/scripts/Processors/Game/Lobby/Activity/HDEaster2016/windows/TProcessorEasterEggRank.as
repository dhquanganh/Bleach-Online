package Processors.Game.Lobby.Activity.HDEaster2016.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDEaster2016_2;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_2;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDRankWindowBase;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorEasterEggRank extends TProcessorHDRankWindowBase
   {
      
      protected static const RankGift_Num:int = 6;
      
      protected var FConfigData:THDEaster2016_2;
      
      protected var FActivityData:THDEasterData2016_2;
      
      protected var FGiftBtnVec:Vector.<TUIButton>;
      
      protected var FTFRankVec:Vector.<TextField>;
      
      protected var FTFCount:TextField;
      
      public function TProcessorEasterEggRank(param1:TUIComponent)
      {
         super(param1);
         this.FGiftBtnVec = new Vector.<TUIButton>();
         this.FTFRankVec = new Vector.<TextField>();
         FRankNum = 12;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as THDEasterData2016_2;
         FRankDatas = this.FActivityData.RankVec;
         this.FTFCount.text = this.FActivityData.CurScore + "";
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
            this.FTFRankVec[_loc1_].text = this.FConfigData.RankAward[_loc1_]["prompt"];
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
         SToolReward.GetAwardsByAwardID(this.FConfigData.RankAward[_loc3_].value,_loc4_);
         ProcessorOnGiftBoxMove(param1,_loc4_);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FConfigData = param2 as THDEaster2016_2;
         this.FActivityData = param3 as THDEasterData2016_2;
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

