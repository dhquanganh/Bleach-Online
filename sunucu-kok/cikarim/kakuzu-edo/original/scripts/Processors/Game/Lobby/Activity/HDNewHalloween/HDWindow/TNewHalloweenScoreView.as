package Processors.Game.Lobby.Activity.HDNewHalloween.HDWindow
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDNewHalloween.THDNewHalloweenRechargeData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHRISTMAS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TNewHalloweenScoreView extends TProcessorLobbyWindow
   {
      
      public static const SLOTNUM:int = 6;
      
      protected var FMainUI:Sprite;
      
      protected var FCurrentBellValueTF:TextField;
      
      protected var FMaskSp:Sprite;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBellInfoTFVec:Vector.<TextField>;
      
      protected var FBuyTButtons:Vector.<TUIButton>;
      
      protected var FItemVec:Vector.<Sprite>;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FClose:TUIButton;
      
      protected var FIsInit:Boolean;
      
      protected var FSendData:Function;
      
      protected var FData:THDNewHalloweenRechargeData;
      
      public function TNewHalloweenScoreView(param1:TUIComponent)
      {
         super(param1);
         this.Visible = false;
         this.FCurrentPageIndex = 0;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIButton = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_NewHallowShop") as Sprite;
         addChild(this.FMainUI);
         this.FCurrentBellValueTF = this.FMainUI["TF_BellValue"];
         _loc1_ = SLOTNUM;
         this.FSlots = new Vector.<TUISlot>();
         this.FBellInfoTFVec = new Vector.<TextField>();
         this.FBuyTButtons = new Vector.<TUIButton>();
         this.FItemVec = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FMainUI["Item" + _loc2_];
            this.FItemVec[_loc2_] = _loc3_;
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["Slot"];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FSlots.push(_loc4_);
            this.FBellInfoTFVec.push(_loc3_["TF_BellValue"]);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc3_["Btn_Exchange"];
            _loc5_.OnClick = this.BtnBuyOperateOnClick;
            this.FBuyTButtons.push(_loc5_);
            _loc2_++;
         }
         this.FClose = new TUIButton();
         this.FClose.Substrate = this.FMainUI["btn_close"];
         this.FClose.OnClick = this.CloseOnClick;
         this.FMainUI.x = (FUICore.StageWidth - this.FMainUI.width >> 1) - FParent.Parent.X + CONST_CHRISTMAS.TabWidth;
         this.FMainUI.y = (FUICore.StageHeight - this.FMainUI.height >> 1) - FParent.Parent.Y;
         this.FMaskSp = new Sprite();
         this.FMaskSp.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FMaskSp.x = -FParent.Parent.X;
         this.FMaskSp.y = -FParent.Parent.Y;
         this.addChildAt(this.FMaskSp,0);
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_ChangeSlotPage"]["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_ChangeSlotPage"]["MC_PageRight"];
         this.FUIPage.LabelPage = this.FMainUI["MC_ChangeSlotPage"]["TF_Page"];
         this.FUIPage.PageSize = SLOTNUM;
         this.FUIPage.OnChangePage = this.SwitchPage;
         this.FUIPage.Init();
      }
      
      protected function SendServiceData(param1:int) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      protected function RenderExchangeList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventories = null;
         _loc3_ = 0;
         _loc1_ = this.FCurrentPageIndex * SLOTNUM;
         _loc2_ = (this.FCurrentPageIndex + 1) * SLOTNUM;
         _loc4_ = _loc1_;
         while(_loc4_ < _loc2_)
         {
            if(_loc4_ < this.FData.ScoreMallVoVec.length)
            {
               _loc6_ = this.FData.ScoreMallVoVec[_loc4_].Inventories;
               this.FSlots[_loc3_].Context = null;
               if(_loc6_ != null)
               {
                  this.FSlots[_loc3_].Context = _loc6_.GetInventoryByIndex(0);
               }
               if(this.FData.ScoreMallVoVec[_loc4_].LimitValue == 1)
               {
                  this.FItemVec[_loc3_]["MC_LimitValue"].visible = true;
               }
               else
               {
                  this.FItemVec[_loc3_]["MC_LimitValue"].visible = false;
               }
               if(this.FData.ScoreMallVoVec[_loc4_].LimitValue == 0 || this.FData.ScoreMallVoVec[_loc4_].BuyCount < this.FData.ScoreMallVoVec[_loc4_].LimitValue)
               {
                  this.FBuyTButtons[_loc3_].Enabled = true;
               }
               else
               {
                  this.FBuyTButtons[_loc3_].Enabled = false;
               }
               this.FBellInfoTFVec[_loc3_].text = this.FData.ScoreMallVoVec[_loc4_].NeedFavornValue.toString();
               this.FItemVec[_loc3_].visible = true;
            }
            else
            {
               this.FBuyTButtons[_loc3_].Enabled = true;
               this.FItemVec[_loc3_].visible = false;
            }
            _loc3_++;
            _loc4_++;
         }
      }
      
      private function UpdateExtractSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function UpdataUI() : void
      {
         this.RenderExchangeList();
         this.SetupPage(this.FData.ScoreMallVoVec.length,this.FCurrentPageIndex);
         this.FCurrentBellValueTF.text = this.FData.Score.toString();
      }
      
      protected function BtnBuyOperateOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FCurrentPageIndex * SLOTNUM + this.FBuyTButtons.indexOf(param1 as TUIButton);
         if(this.FData.Score < this.FData.ScoreMallVoVec[_loc3_].NeedFavornValue)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_12));
            return;
         }
         _loc4_ = this.FData.ScoreMallVoVec[_loc3_].Index;
         this.SendServiceData(_loc4_);
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Hide();
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.SetupPage(this.FData.ScoreMallVoVec.length,this.FCurrentPageIndex);
         this.RenderExchangeList();
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
         this.FCurrentPageIndex = param2;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function get Data() : THDNewHalloweenRechargeData
      {
         return this.FData;
      }
      
      public function set Data(param1:THDNewHalloweenRechargeData) : void
      {
         this.FData = param1;
      }
      
      public function Show() : void
      {
         if(!this.FIsInit)
         {
            this.ResourcesPerform_UIDispatch();
            this.FIsInit = true;
         }
         this.Visible = true;
         this.UpdataUI();
      }
      
      public function RefreshView() : void
      {
         this.UpdataUI();
      }
      
      public function Hide() : void
      {
         this.Visible = false;
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
         if(this.visible)
         {
            this.UpdateExtractSlots();
         }
      }
   }
}

