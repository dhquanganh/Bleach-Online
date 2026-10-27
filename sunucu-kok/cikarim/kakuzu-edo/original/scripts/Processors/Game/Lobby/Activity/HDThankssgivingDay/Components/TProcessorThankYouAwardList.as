package Processors.Game.Lobby.Activity.HDThankssgivingDay.Components
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorThankYouAwardList extends TProcessorLobbyWindow
   {
      
      protected const EachCount:int = 4;
      
      protected var FMainUI:MovieClip;
      
      protected var FPage:TUIPage;
      
      protected var FShowUI:Vector.<TShowAwardUI>;
      
      protected var FReceiveBtn:Vector.<TUIButton>;
      
      protected var FPageIndex:int;
      
      protected var FCurValue:uint;
      
      protected var FKeys:int;
      
      protected var FConfig:Object;
      
      protected var FActivityID:uint;
      
      protected var FPost:Function;
      
      public function TProcessorThankYouAwardList(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function LocalToGlobalIndex(param1:uint) : uint
      {
         return this.FPageIndex * this.EachCount + param1;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TShowAwardUI = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:MovieClip = null;
         var _loc8_:TUIButton = null;
         _loc3_ = uint(this.FConfig.award.length);
         _loc1_ = 0;
         while(_loc1_ < this.EachCount)
         {
            _loc2_ = this.LocalToGlobalIndex(_loc1_);
            if(_loc2_ < _loc3_)
            {
               _loc5_ = this.FConfig.award[_loc2_];
               _loc7_ = this.FMainUI["MC_ShowUI" + _loc1_];
               _loc8_ = this.FReceiveBtn[_loc1_];
               _loc7_.visible = true;
               _loc7_.TF_Condition.text = String(_loc5_.condition);
               _loc4_ = this.FShowUI[_loc1_];
               _loc4_.SetData(_loc5_.showType,_loc5_.awardID,_loc5_.showID,TOverlayerGiftBox.TYPE_ALL);
               _loc6_ = Boolean(this.FKeys >> _loc2_ & 1);
               if(_loc6_)
               {
                  _loc7_.MC_Get.visible = true;
                  _loc8_.Enabled = false;
               }
               else
               {
                  _loc7_.MC_Get.visible = false;
                  if(this.CanReceive(_loc5_.condition,_loc3_))
                  {
                     _loc8_.Enabled = true;
                  }
                  else
                  {
                     _loc8_.Enabled = false;
                  }
               }
            }
            else
            {
               this.FMainUI["MC_ShowUI" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function CanReceive(param1:uint, param2:uint) : Boolean
      {
         return param1 <= this.FCurValue;
      }
      
      protected function OnReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = this.LocalToGlobalIndex(param1.Tag);
         this.FPost(this.FActivityID,this.FConfig.index,0,Vector.<int>([_loc3_]));
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePage();
      }
      
      public function set Post(param1:Function) : void
      {
         this.FPost = param1;
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TShowAwardUI = null;
         var _loc4_:TUIButton = null;
         var _loc5_:MovieClip = null;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.LabelPage = this.FMainUI["TF_Page"];
         this.FPage.PageSize = this.EachCount;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.FShowUI = new Vector.<TShowAwardUI>(this.EachCount);
         this.FReceiveBtn = new Vector.<TUIButton>(this.EachCount);
         _loc2_ = 0;
         while(_loc2_ < this.EachCount)
         {
            _loc3_ = new TShowAwardUI(this);
            _loc5_ = this.FMainUI["MC_ShowUI" + _loc2_];
            _loc3_.UIDispatch(_loc5_);
            this.FShowUI[_loc2_] = _loc3_;
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc5_.Btn_Receive;
            _loc4_.OnClick = this.OnReceiveBtnClick;
            _loc4_.Tag = _loc2_;
            this.FReceiveBtn[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      public function Update(param1:uint, param2:int, param3:Object, param4:uint) : void
      {
         var _loc5_:uint = 0;
         this.FCurValue = param1;
         this.FKeys = param2;
         this.FConfig = param3;
         this.FActivityID = param4;
         if(this.FPage.TotalQuantity == 0)
         {
            _loc5_ = uint(param3.award.length);
            this.FPage.SetupPage(_loc5_,0);
            this.FPageIndex = 0;
         }
         this.FMainUI.TF_CurValue.text = param1.toString();
         this.UpdatePage();
      }
   }
}

