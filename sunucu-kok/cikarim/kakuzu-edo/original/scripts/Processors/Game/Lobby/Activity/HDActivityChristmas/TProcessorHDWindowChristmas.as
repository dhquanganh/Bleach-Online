package Processors.Game.Lobby.Activity.HDActivityChristmas
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChristmasGift;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas.TActivityChristmasWishData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityChristmas.windows.TProcessorChristmasGiftView;
   import Processors.Game.Lobby.Activity.HDActivityChristmas.windows.TProcessorChristmasWishView;
   import Processors.Game.Lobby.Activity.HDActivityChristmas.windows.TProcessorWindowHDChristmasCarnival;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_CHRISTMAS;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowChristmas extends TProcessorHDSingleWindowBase
   {
      
      protected const FTabNum:int = 3;
      
      protected var FChristmasWishPanel:Sprite;
      
      protected var FChristmasGiftPanel:Sprite;
      
      protected var FChristmasCarnivalPanel:Sprite;
      
      protected var FChristmasWishView:TProcessorChristmasWishView;
      
      protected var FChristmasGiftView:TProcessorChristmasGiftView;
      
      protected var FChristmasCarnivalView:TProcessorWindowHDChristmasCarnival;
      
      protected var FUITab:TUITab;
      
      protected var FIsSelectOpenWishView:Boolean;
      
      protected var FActivityOverMcList:Vector.<Sprite>;
      
      protected var FOnSelectHDType:Function;
      
      public function TProcessorHDWindowChristmas(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_ChristmasMain";
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         super.InitWindow(param1);
         this.FUITab = new TUITab(this);
         _loc3_ = this.FTabNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Tabs + _loc2_];
            if(_loc4_.MC_Status != null)
            {
               MovieClip(_loc4_.MC_Status).gotoAndStop(1);
               MovieClip(_loc4_.MC_Status).visible = false;
            }
            this.FUITab.SetTabByIndex(_loc4_,_loc2_);
            this.FUITab.SetTabCaptionByIndex("",_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.UIDispatch();
         FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FIsSelectOpenWishView = false;
         this.FActivityOverMcList = new Vector.<Sprite>();
         _loc3_ = this.FTabNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = FScene["MC_Activity" + _loc2_];
            _loc5_.visible = false;
            this.FActivityOverMcList[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function ResetActivityPrompt(param1:Sprite) : void
      {
         FTF_OpenTime = param1[CONST_ACTIVITY.RESOURCE_Link_TF_OpenTime];
         FTF_CoolingTime = param1[CONST_ACTIVITY.RESOURCE_Link_TF_CoolingTime];
         FTF_Desc = param1[CONST_ACTIVITY.RESOURCE_Link_TF_Desc];
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
      
      protected function UIDispatch() : void
      {
         this.FChristmasWishPanel = FScene["MC_Wish"];
         this.FChristmasGiftPanel = FScene["MC_Gift"];
         FScene["MC_Cheers"].visible = false;
         this.FChristmasWishPanel.visible = false;
         this.FChristmasWishPanel = FScene["MC_Wish"];
         this.FChristmasCarnivalPanel = FScene["MC_Cheers"];
         this.FChristmasWishView = new TProcessorChristmasWishView(this,this.FChristmasWishPanel);
         this.FChristmasWishView.GiftMoveFun = this.ActivityGiftOnMove;
         this.FChristmasWishView.GiftOutFun = this.ActivityGiftOnOut;
         this.FChristmasWishView.SendData = this.SendRequestData;
         this.FChristmasWishView.AddMaskLayer = this.SetMaskLayerShow;
         this.FChristmasGiftView = new TProcessorChristmasGiftView(this,this.FChristmasGiftPanel);
         this.FChristmasGiftView.GiftMoveFun = this.ActivityGiftOnMove;
         this.FChristmasGiftView.GiftOutFun = this.ActivityGiftOnOut;
         this.FChristmasGiftView.SendData = this.SendRequestData;
         this.FChristmasCarnivalView = new TProcessorWindowHDChristmasCarnival(this,this.FChristmasCarnivalPanel);
         this.FChristmasCarnivalView.SendData = this.SendRequestData;
         this.FChristmasCarnivalView.GetCard = this.SwitchView;
         this.FChristmasCarnivalView.GiftMoveFun = this.ActivityGiftOnMove;
         this.FChristmasCarnivalView.GiftOutFun = this.ActivityGiftOnOut;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FChristmasWishView.LogicsPerform();
         }
      }
      
      protected function SendRequestData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function ActivityGiftOnMove(param1:Object) : void
      {
         ProcessorOnGiftBoxMove(this,param1,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ActivityGiftOnOut() : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function SetCurrentShowView(param1:int) : void
      {
         switch(param1)
         {
            case CONST_CHRISTMAS.CHRISTMAS_TAB_0:
               this.FChristmasGiftPanel.visible = true;
               this.FChristmasWishPanel.visible = false;
               this.FChristmasCarnivalPanel.visible = false;
               break;
            case CONST_CHRISTMAS.CHRISTMAS_TAB_1:
               this.FChristmasWishPanel.visible = true;
               this.FChristmasGiftPanel.visible = false;
               this.FChristmasCarnivalPanel.visible = false;
               break;
            case CONST_CHRISTMAS.CHRISTMAS_TAB_2:
               this.FChristmasWishPanel.visible = false;
               this.FChristmasCarnivalPanel.visible = true;
               this.FChristmasGiftPanel.visible = false;
         }
         if(param1 != CONST_CHRISTMAS.CHRISTMAS_TAB_2)
         {
            this.FChristmasCarnivalView.CloseCall();
         }
      }
      
      protected function SetMaskLayerShow(param1:Boolean) : void
      {
         this.FUITab.GetTabByIndex(CONST_CHRISTMAS.CHRISTMAS_TAB_0).mouseEnabled = param1;
         this.FUITab.GetTabByIndex(CONST_CHRISTMAS.CHRISTMAS_TAB_2).mouseEnabled = param1;
      }
      
      protected function SwitchView() : void
      {
         this.FIsSelectOpenWishView = true;
         this.FUITab.SwithTagManual(CONST_CHRISTMAS.CHRISTMAS_TAB_1);
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         if(this.FOnSelectHDType != null)
         {
            this.FOnSelectHDType(_loc2_);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function get OnSelectHDType() : Function
      {
         return this.FOnSelectHDType;
      }
      
      public function set OnSelectHDType(param1:Function) : void
      {
         this.FOnSelectHDType = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_ChristmasGift)
         {
            this.FChristmasGiftView.Data = param2 as THDChristmasGift;
            this.FChristmasGiftView.ShowView(param3);
            this.ResetActivityPrompt(this.FChristmasGiftPanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_CHRISTMAS.CHRISTMAS_TAB_0);
         }
         else if(param1.ActivityID == CONST_ACTIVITY_MODE.Activity_ChristmasWish)
         {
            this.FChristmasWishView.Data = param3 as TActivityChristmasWishData;
            this.FChristmasWishView.ShowView(this.FIsSelectOpenWishView);
            this.FIsSelectOpenWishView = false;
            this.ResetActivityPrompt(this.FChristmasWishPanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_CHRISTMAS.CHRISTMAS_TAB_1);
         }
         else
         {
            this.FChristmasCarnivalView.ShowView(param1,param2,param3);
            this.ResetActivityPrompt(this.FChristmasCarnivalPanel["MC_Prompt"]);
            this.SetCurrentShowView(CONST_CHRISTMAS.CHRISTMAS_TAB_2);
         }
         this.UpdateUIConfig();
      }
      
      public function SetHDTabState(param1:Vector.<Boolean>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ == 0)
            {
               this.FActivityOverMcList[_loc2_].visible = !param1[_loc2_];
            }
            if(!param1[_loc2_])
            {
               this.FUITab.SetTabEnabledByIndex(_loc2_,param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function SetupTabCurrentShowIndex(param1:int) : void
      {
         this.FUITab.SwithTagManual(param1);
      }
      
      public function UpdataData(param1:int, param2:int) : void
      {
         if(param1 == CONST_CHRISTMAS.CHRISTMAS_TAB_1)
         {
            this.FChristmasWishView.StopAnima(param2);
         }
      }
   }
}

