package Processors.Game.Lobby.Activity.HDEaster2016.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDEaster2016_0;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_0;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowEaster2016_0 extends TProcessorHDSingleWindowBase
   {
      
      protected var FMC_TimeGift:Sprite;
      
      protected var FMC_RebirthGift:Sprite;
      
      protected var FBtn_TimeGet:TUIButton;
      
      protected var FBtn_Rebirth:TUIButton;
      
      protected var FGift_Rebirth:TUIButton;
      
      protected var FBtn_Gifts:Vector.<TUIButton>;
      
      protected var FBtn_Gets:Vector.<TUIButton>;
      
      protected var FTF_Nums:Vector.<TextField>;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_JackPointGet:TUIButton;
      
      protected var FBtnIndex:uint;
      
      protected var FData:THDEasterData2016_0;
      
      protected var FConfig:THDEaster2016_0;
      
      public function TProcessorHDWindowEaster2016_0(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDEaster2016_0 = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDEaster2016_0;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_Cost_0"].text = this.FConfig.Gift01.gold + "";
         FScene["TF_Cost_1"].text = this.FConfig.Gift02.gold + "";
         FScene["TF_Cost_2"].text = this.FConfig.Gift03.gold + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as THDEasterData2016_0;
         this.FMC_TimeGift["TF_Num"].text = this.FConfig.TimeAwardObj["infos"][this.FData.TimePeriod].amount + "";
         if(this.FConfig.Gift00.num - this.FData.ServerLimit <= 0)
         {
            this.FMC_RebirthGift["TF_Num"].text = "0";
         }
         else
         {
            this.FMC_RebirthGift["TF_Num"].text = this.FConfig.Gift00.num - this.FData.ServerLimit + "";
         }
         this.FBtn_Rebirth.Enabled = this.FData.ServerLimit >= this.FConfig.Gift00.num || this.FData.Rebirth == -1 ? false : true;
         FScene["TF_HaveEgg"].text = this.FData.HaveEgg + "";
         FScene["TF_HaveEgg02"].text = this.FData.HaveEgg02 + "";
         FScene["TF_HaveEgg03"].text = this.FData.HaveEgg03 + "";
         this.FBtn_Gets[0].Enabled = this.FData.LastItemlevel_1 >= this.FConfig.Gift01.num || this.FData.LastItemlevel_1 == -1 ? false : true;
         FScene["TF_Num_0"].text = this.FData.LastItemlevel_1 + "/" + this.FConfig.Gift01.num;
         if(this.FData.LastItemlevel_1 < 0)
         {
            FScene["TF_Num_0"].text = "0/" + this.FConfig.Gift01.num;
         }
         this.FBtn_Gets[1].Enabled = this.FData.LastItemlevel_2 >= this.FConfig.Gift02.num || this.FData.LastItemlevel_2 == -1 ? false : true;
         FScene["TF_Num_1"].text = this.FData.LastItemlevel_2 + "/" + this.FConfig.Gift02.num;
         if(this.FData.LastItemlevel_2 < 0)
         {
            FScene["TF_Num_1"].text = "0/" + this.FConfig.Gift01.num;
         }
         this.FBtn_Gets[2].Enabled = this.FData.LastItemlevel_3 >= this.FConfig.Gift03.num || this.FData.LastItemlevel_3 == -1 ? false : true;
         FScene["TF_Num_2"].text = this.FData.LastItemlevel_3 + "/" + this.FConfig.Gift03.num;
         if(this.FData.LastItemlevel_3 < 0)
         {
            FScene["TF_Num_2"].text = "0/" + this.FConfig.Gift01.num;
         }
         this.UpdateJackPoint();
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FConfig.BigAward.showType[this.FData.CurDay],this.FConfig.BigAward.awardId[this.FData.CurDay],this.FConfig.BigAward.showId[this.FData.CurDay]);
         this.FBtn_Report.Visible = this.FConfig.BigAward.reportId[this.FData.CurDay] != "";
         FScene["MC_JackPoint"]["MC_ShowAwardUI"]["TF_Limit"].text = this.FData.LastBigAward + "/" + this.FConfig.BigAward.nums[this.FData.CurDay];
         FScene["MC_JackPoint"]["MC_ShowAwardUI"]["TF_Cost"].text = this.FConfig.BigAward.gold[this.FData.CurDay] + "";
         if(this.FData.LastBigAward >= this.FConfig.BigAward.nums[this.FData.CurDay])
         {
            FScene["MC_JackPoint"]["MC_ShowAwardUI"]["MC_Already"].visible = true;
            this.FBtn_JackPointGet.Visible = false;
         }
         else
         {
            FScene["MC_JackPoint"]["MC_ShowAwardUI"]["MC_Already"].visible = false;
            this.FBtn_JackPointGet.Visible = true;
            this.FBtn_JackPointGet.Enabled = true;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         this.FMC_TimeGift["TF_Time"].text = TUtilityTiming.fomatTimeTwo(this.FData.LastTime - STimingCore.ServerTick);
         if(this.FData.LastTime - STimingCore.ServerTick > 0 || this.FData.LastTime == -1)
         {
            this.FBtn_TimeGet.Enabled = false;
         }
         else if(this.FBtn_TimeGet.Enabled == false)
         {
            this.FBtn_TimeGet.Enabled = true;
         }
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorRebirthGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.Gift00,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         switch(_loc3_)
         {
            case 0:
               ProcessorOnGiftBoxMove(this,this.FData.Gift01[this.FData.CurDay],TOverlayerGiftBox.TYPE_ALL);
               break;
            case 1:
               ProcessorOnGiftBoxMove(this,this.FData.Gift02[this.FData.CurDay],TOverlayerGiftBox.TYPE_ALL);
               break;
            case 2:
               ProcessorOnGiftBoxMove(this,this.FData.Gift03[this.FData.CurDay],TOverlayerGiftBox.TYPE_ALL);
         }
      }
      
      protected function ProcessorTimeGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.TimeAwardObj.index);
      }
      
      protected function ProcessorRebirthGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift00.index);
      }
      
      protected function ProcessorJackPoint(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BigAward.index);
      }
      
      protected function ProcessorGoldBuyJackPoint(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.BigAward.gold[this.FData.CurDay],this.ProcessorJackPoint);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FConfig.BigAward.reportId[this.FData.CurDay]);
      }
      
      protected function ProcessorGoldBuyGift(param1:Object, param2:MouseEvent) : void
      {
         switch(param1.Tag)
         {
            case 0:
               GoldBuy(this.FConfig.Gift01.gold,this.ProcessorBuyGift);
               this.FBtnIndex = param1.Tag;
               break;
            case 1:
               GoldBuy(this.FConfig.Gift02.gold,this.ProcessorBuyGift);
               this.FBtnIndex = param1.Tag;
               break;
            case 2:
               GoldBuy(this.FConfig.Gift03.gold,this.ProcessorBuyGift);
               this.FBtnIndex = param1.Tag;
         }
      }
      
      protected function ProcessorBuyGift(param1:Object) : void
      {
         switch(this.FBtnIndex)
         {
            case 0:
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift01.index);
               break;
            case 1:
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift02.index);
               break;
            case 2:
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift03.index);
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FMC_TimeGift = FScene["MC_TimeGift"];
         this.FBtn_TimeGet = new TUIButton();
         this.FBtn_TimeGet.Substrate = this.FMC_TimeGift["Btn_Get"];
         this.FBtn_TimeGet.OnClick = this.ProcessorTimeGet;
         this.FMC_RebirthGift = FScene["MC_RebirthGift"];
         this.FGift_Rebirth = new TUIButton();
         this.FGift_Rebirth.Substrate = this.FMC_RebirthGift["MC_Gift"];
         this.FGift_Rebirth.OnMove = this.ProcessorRebirthGiftOnMove;
         this.FGift_Rebirth.OnOut = this.ProcessorGiftOnOut;
         this.FBtn_Rebirth = new TUIButton();
         this.FBtn_Rebirth.Substrate = this.FMC_RebirthGift["Btn_Get"];
         this.FBtn_Rebirth.OnClick = this.ProcessorRebirthGet;
         _loc2_ = 3;
         this.FBtn_Gifts = new Vector.<TUIButton>(_loc2_);
         this.FBtn_Gets = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Gifts[_loc3_] = new TUIButton();
            this.FBtn_Gifts[_loc3_].Substrate = FScene["MC_Gift_" + _loc3_];
            this.FBtn_Gifts[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FBtn_Gifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FBtn_Gifts[_loc3_].Tag = _loc3_;
            this.FBtn_Gets[_loc3_] = new TUIButton();
            this.FBtn_Gets[_loc3_].Substrate = FScene["MC_Get_" + _loc3_];
            this.FBtn_Gets[_loc3_].OnClick = this.ProcessorGoldBuyGift;
            this.FBtn_Gets[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_JackPoint"]["MC_ShowAwardUI"]);
         this.FBtn_JackPointGet = new TUIButton();
         this.FBtn_JackPointGet.Substrate = FScene["MC_JackPoint"]["MC_ShowAwardUI"]["Btn_JackPiont_Get"];
         this.FBtn_JackPointGet.OnClick = this.ProcessorGoldBuyJackPoint;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_JackPoint"]["MC_ShowAwardUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
      }
   }
}

