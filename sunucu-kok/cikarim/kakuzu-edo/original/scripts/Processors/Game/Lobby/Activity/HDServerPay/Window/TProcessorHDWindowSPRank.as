package Processors.Game.Lobby.Activity.HDServerPay.Window
{
   import Components.Pages.*;
   import Foundation.UI.*;
   import Logics.HDActivityOS.*;
   import Logics.HDServerPay.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorHDWindowSPRank extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_Rank:uint = 11;
      
      protected static const COUNT_TF_Rank:uint = 4;
      
      protected var FUIPage_Rank:TUIPage;
      
      protected var FPageIndex_Rank:int;
      
      protected var FMC_Ranks:Vector.<TUIActivityOSAwardList>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FData_ServerPay:TActivityServerPay;
      
      protected var FOnWindowClose:Function;
      
      public function TProcessorHDWindowSPRank(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleServerPayRank;
         this.FIsInitWindow = false;
         this.FPageIndex_Rank = 0;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TUIActivityOSAwardList = null;
         super.InitWindow(param1);
         _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List];
         _loc4_.mouseEnabled = false;
         _loc4_.mouseChildren = false;
         _loc3_ = int(COUNT_MC_Rank);
         this.FMC_Ranks = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TUIActivityOSAwardList(this);
            _loc5_.Perform_UIDispatch(_loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_Ranks + _loc2_],COUNT_TF_Rank,0,false);
            this.FMC_Ranks[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Page];
         this.FUIPage_Rank = new TUIPage(this);
         this.FUIPage_Rank.ButtonPrevious.Substrate = _loc4_[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
         this.FUIPage_Rank.ButtonNext.Substrate = _loc4_[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
         this.FUIPage_Rank.LabelPage = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_Page];
         this.FUIPage_Rank.PageSize = COUNT_MC_Rank;
         this.FUIPage_Rank.OnChangePage = this.UIPageOnChange;
         this.FUIPage_Rank.Init();
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FData_ServerPay = param1 as TActivityServerPay;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<String> = null;
         super.UpdateUI();
         _loc2_ = int(COUNT_MC_Rank);
         _loc4_ = new Vector.<String>(COUNT_TF_Rank);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc1_ + this.FPageIndex_Rank * COUNT_MC_Rank;
            if(_loc3_ < this.FData_ServerPay.Ranks.length)
            {
               _loc4_[0] = this.FData_ServerPay.Ranks[_loc3_].Rank.toString();
               _loc4_[1] = this.FData_ServerPay.Ranks[_loc3_].ServerID.toString();
               _loc4_[2] = this.FData_ServerPay.Ranks[_loc3_].Name;
               _loc4_[3] = this.FData_ServerPay.Ranks[_loc3_].Value.toString();
               this.FMC_Ranks[_loc1_].UpDateUI(_loc1_,null,_loc4_);
            }
            else
            {
               _loc4_[0] = "";
               _loc4_[1] = "";
               _loc4_[2] = "";
               _loc4_[3] = "";
               this.FMC_Ranks[_loc1_].UpDateUI(_loc1_,null,_loc4_);
            }
            _loc1_++;
         }
         this.UpdateUIPage();
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUIPage_Rank.TotalQuantity = this.FData_ServerPay.Ranks.length;
         this.FUIPage_Rank.PageIndex = this.FPageIndex_Rank;
         this.FUIPage_Rank.Update();
      }
      
      protected function UIPageOnChange(param1:Object, param2:int) : void
      {
         if(this.FPageIndex_Rank == param2)
         {
            return;
         }
         this.FPageIndex_Rank = param2;
         this.UpdateUI();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(this.FOnWindowClose != null)
         {
            this.FOnWindowClose(CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Main);
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FMC_Ranks.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Ranks[_loc1_].Clear();
            _loc1_++;
         }
         this.FPageIndex_Rank = 0;
      }
      
      public function get OnWindowClose() : Function
      {
         return this.FOnWindowClose;
      }
      
      public function set OnWindowClose(param1:Function) : void
      {
         this.FOnWindowClose = param1;
      }
   }
}

