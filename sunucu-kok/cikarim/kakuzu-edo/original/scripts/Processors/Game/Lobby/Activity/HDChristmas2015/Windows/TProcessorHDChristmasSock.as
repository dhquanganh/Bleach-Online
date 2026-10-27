package Processors.Game.Lobby.Activity.HDChristmas2015.Windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDChristmasSock;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.VO.TActivityChristmasSock;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDChristmasSock extends TProcessorHDSingleWindowBase
   {
      
      public static const TASKNUM:uint = 6;
      
      public static const SOCKSNUM:uint = 5;
      
      protected var FBlockRight:Sprite;
      
      protected var FTaskItems:Vector.<Sprite>;
      
      protected var FTaskBags:Vector.<TUIButton>;
      
      protected var FTaskBtns:Vector.<TUIButton>;
      
      protected var FTaskTexts:Vector.<TextField>;
      
      protected var FSockNum:TextField;
      
      protected var FSocksBags:Vector.<TUIButton>;
      
      protected var FSocksBagsGet:Vector.<Sprite>;
      
      protected var FEffects:Vector.<MovieClip>;
      
      protected var FPrice:Vector.<TextField>;
      
      protected var FBtnShowRank:TUIButton;
      
      protected var FData:TActivityChristmasSock;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FRankView:TProcessorSockRank;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_JackCost:TextField;
      
      protected var FBtn_GetPrize:TUIButton;
      
      protected var FBtn_Report:TUIButton;
      
      public function TProcessorHDChristmasSock(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDChristmasSock = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDChristmasSock;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         this.FJackPoint.SetData(_loc3_.JackPoint.showType,_loc3_.JackPoint.award,_loc3_.JackPoint.showID);
         this.FBtn_Report.Visible = _loc3_.JackPoint.fightReportAddr != "";
         _loc2_ = TASKNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTaskItems[_loc1_]["TF_prompt1"].text = _loc3_.TaskAwards[_loc1_].prompt1;
            this.FTaskItems[_loc1_]["TF_prompt2"].text = _loc3_.TaskAwards[_loc1_].prompt2;
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TActivityChristmasSock;
         _loc3_ = TASKNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.TaskStatus[_loc2_] == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               this.FTaskTexts[_loc2_].text = this.FData.Config.TaskAwards[_loc2_].value + "/" + this.FData.Config.TaskAwards[_loc2_].value;
               this.FTaskItems[_loc2_]["SP_AlreadyGet"].visible = true;
            }
            else
            {
               this.FTaskTexts[_loc2_].text = this.FData.TaskStatus[_loc2_] + "/" + this.FData.Config.TaskAwards[_loc2_].value;
               this.FTaskItems[_loc2_]["SP_AlreadyGet"].visible = false;
            }
            this.FTaskBags[_loc2_].Enabled = this.FData.TaskStatus[_loc2_] == this.FData.Config.TaskAwards[_loc2_].value ? true : false;
            _loc2_++;
         }
         this.FSockNum.text = this.FData.SockNum.toString();
         if(this.AllReceive())
         {
            _loc3_ = this.FData.SocksGift.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FData.SockStatus[_loc2_] = CONST_ACTIVITY_MODE.Activity_CanReceive;
               _loc2_++;
            }
         }
         _loc4_ = uint(this.FData.Config.SockAwards[SOCKSNUM - 1].value);
         _loc3_ = SOCKSNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.SockNum >= this.FData.Config.SockAwards[_loc2_].value + this.FData.Round * _loc4_)
            {
               this.FSocksBags[_loc2_].Enabled = true;
               this.FSocksBags[_loc2_].Enabled = this.FData.SockStatus[_loc2_] == CONST_ACTIVITY_MODE.Activity_AlreadyReceive ? false : true;
            }
            else
            {
               this.FSocksBags[_loc2_].Enabled = false;
            }
            this.FSocksBagsGet[_loc2_].visible = this.FData.SockStatus[_loc2_] == CONST_ACTIVITY_MODE.Activity_AlreadyReceive ? true : false;
            _loc2_++;
         }
         _loc3_ = SOCKSNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPrice[_loc2_].text = (this.FData.Config.SockAwards[_loc2_].value + this.FData.Round * _loc4_).toString();
            _loc2_++;
         }
         this.UpdateJackPoint();
      }
      
      protected function UpdateJackPoint() : void
      {
         this.FTF_JackCost.text = this.FData.Config.JackPoint.socks + "";
         if(this.FData.JackPointStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FSP_AlreadyGet.visible = true;
            this.FBtn_GetPrize.Visible = false;
         }
         else if(this.FData.SockNum >= this.FData.Config.JackPoint.socks)
         {
            this.FSP_AlreadyGet.visible = false;
            this.FBtn_GetPrize.Visible = true;
            this.FBtn_GetPrize.Enabled = true;
         }
         else
         {
            this.FSP_AlreadyGet.visible = false;
            this.FBtn_GetPrize.Visible = true;
            this.FBtn_GetPrize.Enabled = false;
         }
      }
      
      protected function AllReceive() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FData.SocksGift.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FData.SockStatus[_loc1_] != CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      protected function ProcessorTaskBagOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.TaskAwards[_loc3_].index);
      }
      
      protected function ProcessorTaskBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorTaskBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.TaskGifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorSocksBagOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.SockAwards[_loc3_].index);
      }
      
      protected function ProcessorSocksBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorSocksBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.SocksGift[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ShowRankOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FRankView.Show(FActivityAtoms,FHDActivityConfig,this.FData);
      }
      
      protected function ProcessorGetPrizeOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.JackPoint.index);
      }
      
      protected function ProcessorReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToBattleReportUrl(this.FData.Config.JackPoint.fightReportAddr);
      }
      
      protected function ProcessorTaskOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = uint((param1 as TUIButton).Tag);
         _loc3_ = uint(this.FData.Config.TaskAwards[_loc4_].goto);
         SUtilityHyperLink.ShortcutHyperlink(_loc3_);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBlockRight = FScene["MC_Items"];
         _loc2_ = TASKNUM;
         this.FTaskBags = new Vector.<TUIButton>(_loc2_);
         this.FTaskBtns = new Vector.<TUIButton>(_loc2_);
         this.FTaskTexts = new Vector.<TextField>(_loc2_);
         this.FTaskItems = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FTaskItems[_loc3_] = this.FBlockRight["MC_RandomItem_" + _loc3_];
            this.FTaskBags[_loc3_] = new TUIButton();
            this.FTaskBags[_loc3_].Substrate = this.FTaskItems[_loc3_]["Slot"];
            this.FTaskBags[_loc3_].Tag = _loc3_;
            this.FTaskBags[_loc3_].OnClick = this.ProcessorTaskBagOnClick;
            this.FTaskBags[_loc3_].OnMove = this.ProcessorTaskBagOnMove;
            this.FTaskBags[_loc3_].OnOut = this.ProcessorTaskBagOnOut;
            this.FTaskBtns[_loc3_] = new TUIButton();
            this.FTaskBtns[_loc3_].Substrate = this.FTaskItems[_loc3_]["Btn_Refresh"];
            this.FTaskBtns[_loc3_].Tag = _loc3_;
            this.FTaskBtns[_loc3_].OnClick = this.ProcessorTaskOnClick;
            this.FTaskTexts[_loc3_] = new TextField();
            this.FTaskTexts[_loc3_] = this.FTaskItems[_loc3_]["TF_Name"];
            _loc3_++;
         }
         this.FSockNum = new TextField();
         this.FSockNum = this.FBlockRight["MC_Bottom"]["TF_DiscountCoin"];
         this.FBtnShowRank = new TUIButton();
         this.FBtnShowRank.Substrate = this.FBlockRight["MC_Bottom"]["Btn_ShowRank"];
         this.FBtnShowRank.OnClick = this.ShowRankOnClick;
         _loc2_ = SOCKSNUM;
         this.FSocksBags = new Vector.<TUIButton>(_loc2_);
         this.FPrice = new Vector.<TextField>(_loc2_);
         this.FSocksBagsGet = new Vector.<Sprite>(_loc2_);
         this.FEffects = new Vector.<MovieClip>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSocksBags[_loc3_] = new TUIButton();
            this.FSocksBags[_loc3_].Substrate = this.FBlockRight["MC_Bottom"]["Sock_" + _loc3_];
            this.FSocksBags[_loc3_].Tag = _loc3_;
            this.FSocksBags[_loc3_].OnClick = this.ProcessorSocksBagOnClick;
            this.FSocksBags[_loc3_].OnMove = this.ProcessorSocksBagOnMove;
            this.FSocksBags[_loc3_].OnOut = this.ProcessorSocksBagOnOut;
            this.FPrice[_loc3_] = new TextField();
            this.FPrice[_loc3_] = this.FBlockRight["MC_Bottom"]["TF_Price_" + _loc3_];
            this.FSocksBagsGet[_loc3_] = this.FBlockRight["MC_Bottom"]["SP_AlreadyGet_" + _loc3_];
            _loc3_++;
         }
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_Hero"]);
         this.FRankView = new TProcessorSockRank(this);
         this.FRankView.InitWindow(FScene["MC_Rank"]);
         this.FRankView.OnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FRankView.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FSP_AlreadyGet = FScene["MC_Hero"]["MC_Exchangeed"];
         this.FTF_JackCost = new TextField();
         this.FTF_JackCost = FScene["MC_Hero"]["TF_Price_4"];
         this.FBtn_GetPrize = new TUIButton();
         this.FBtn_GetPrize.Substrate = FScene["MC_Hero"]["Btn_Exchange"];
         this.FBtn_GetPrize.OnClick = this.ProcessorGetPrizeOnClick;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_Hero"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReportOnClick;
      }
   }
}

