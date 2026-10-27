package Processors.Game.Lobby.Activity.HDHalloween.windows
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.Achievenment.TTitle;
   import Logics.DatebaseVO.VO.Json.TDoubleFishRank;
   import Logics.DatebaseVO.VO.THDHalloweenPumpkin;
   import Logics.HDActivityHalloween.TActivityHalloweenPumpkinData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.TRankAward;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.TServersRankItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TprocessorWindowHDHalloweenPumpkinRank extends TUIComponent
   {
      
      protected static const AWARD_NUM:uint = 6;
      
      protected static const RANK_NUM:uint = 10;
      
      protected var FRankAwardList:Vector.<TRankAward>;
      
      protected var FRankList:Vector.<TServersRankItem>;
      
      protected var FUIPage:TUIPage;
      
      protected var FTF_MyRank:TextField;
      
      protected var FTF_MyCount:TextField;
      
      protected var FTF_RankDesc:TextField;
      
      protected var FBT_Close:TUIButton;
      
      protected var FScene:Sprite;
      
      protected var FPageIndex:int;
      
      protected var FInvetoriesList:Vector.<TInventories>;
      
      protected var FHalloweenPumpkinBin:THDHalloweenPumpkin;
      
      protected var FData:TActivityHalloweenPumpkinData;
      
      protected var FOnRankClose:Function;
      
      protected var FOnBagOver:Function;
      
      protected var FOnBagOut:Function;
      
      protected var FLayerMask:Sprite;
      
      protected var FCurrentTitle:TTitle;
      
      public function TprocessorWindowHDHalloweenPumpkinRank(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FRankAwardList = new Vector.<TRankAward>(AWARD_NUM);
         this.FRankList = new Vector.<TServersRankItem>(RANK_NUM);
         this.FScene = param2;
         this.FPageIndex = 0;
         this.WindowInit();
      }
      
      protected function WindowInit() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextField = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TServersRankItem = null;
         var _loc6_:Sprite = null;
         var _loc7_:TRankAward = null;
         this.FTF_MyRank = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_MyRank];
         this.FTF_MyCount = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_MyCount];
         this.FTF_RankDesc = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_RankDesc];
         this.FBT_Close = new TUIButton();
         this.FBT_Close.Substrate = this.FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Close];
         this.FBT_Close.OnClick = this.CloseOnClick;
         this.FUIPage = new TUIPage(this);
         _loc1_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
         this.FUIPage.ButtonPrevious.Substrate = _loc1_;
         _loc1_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
         this.FUIPage.ButtonNext.Substrate = _loc1_;
         _loc2_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc2_;
         _loc2_.text = "0/0";
         this.FUIPage.PageSize = RANK_NUM;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         _loc4_ = RANK_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Lists + _loc3_];
            _loc5_ = new TServersRankItem(this,_loc6_);
            _loc5_.Init();
            _loc5_.Visible = false;
            this.FRankList[_loc3_] = _loc5_;
            _loc3_++;
         }
         _loc4_ = AWARD_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_RankRangess + _loc3_];
            _loc7_ = new TRankAward(this,_loc6_);
            _loc7_.OnBagOut = this.ProcessorOnBagOut;
            _loc7_.OnBagOver = this.ProcessorOnBagOver;
            _loc7_.Tag = _loc3_;
            _loc7_.Init();
            _loc7_.Visible = false;
            this.FRankAwardList[_loc3_] = _loc7_;
            _loc3_++;
         }
         _loc4_ = 3;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FScene["MC_Title_" + _loc3_];
            _loc6_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnTitleMove);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.OnTitleOut);
            _loc3_++;
         }
      }
      
      protected function OnTitleOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCurrentTitle);
      }
      
      protected function OnTitleMove(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         var _loc3_:uint = uint(_loc2_.split("_")[2]);
         var _loc4_:uint = this.FData.Config.RankList[_loc3_].Title;
         this.FCurrentTitle = TUtilityLobby.GetTitleByID(SLogicsCore.Character.AchievementTitles,_loc4_);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCurrentTitle);
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUIPage.TotalQuantity = this.FData.RankCount;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateRankList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TServersRankItem = null;
         var _loc4_:TActivityServerRank = null;
         var _loc5_:uint = 0;
         if(this.FData.RankCount == 0)
         {
            return;
         }
         _loc2_ = RANK_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FRankList[_loc1_];
            _loc5_ = this.FPageIndex * RANK_NUM + _loc1_;
            if(_loc5_ < this.FData.RankCount)
            {
               _loc4_ = this.FData.GetRankByIndex(_loc5_);
               _loc3_.UpdateItem(_loc4_);
               _loc3_.RankVisible = true;
            }
            else
            {
               _loc3_.RankVisible = false;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateAward() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TRankAward = null;
         var _loc4_:TDoubleFishRank = null;
         _loc2_ = AWARD_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FRankAwardList[_loc1_];
            _loc4_ = this.FHalloweenPumpkinBin.RankList[_loc1_];
            _loc3_.UpdateRankAwar(_loc4_.Prompt,_loc4_.Title);
            _loc1_++;
         }
      }
      
      protected function UpdateText() : void
      {
         if(this.FData.MyRank != -1)
         {
            this.FTF_MyRank.text = this.FData.MyRank.toString();
         }
         else
         {
            this.FTF_MyRank.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_26);
         }
         this.FTF_MyCount.text = this.FData.MyLightCount.toString();
         this.FTF_RankDesc.text = this.FData.Config.RankDes;
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScene.visible = false;
         this.FLayerMask.visible = false;
         if(this.FOnRankClose != null)
         {
            this.FOnRankClose(this);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUIPage();
         this.UpdateRankList();
      }
      
      protected function ProcessorOnBagOver(param1:Object, param2:uint) : void
      {
         if(this.FOnBagOver != null)
         {
            this.FOnBagOver(this,this.FInvetoriesList[param2]);
         }
      }
      
      protected function ProcessorOnBagOut(param1:Object) : void
      {
         if(this.FOnBagOut != null)
         {
            this.FOnBagOut(this);
         }
      }
      
      public function get OnBagOver() : Function
      {
         return this.FOnBagOver;
      }
      
      public function set OnBagOver(param1:Function) : void
      {
         this.FOnBagOver = param1;
      }
      
      public function get OnBagOut() : Function
      {
         return this.FOnBagOut;
      }
      
      public function set OnBagOut(param1:Function) : void
      {
         this.FOnBagOut = param1;
      }
      
      public function get OnRankClose() : Function
      {
         return this.FOnRankClose;
      }
      
      public function set OnRankClose(param1:Function) : void
      {
         this.FOnRankClose = param1;
      }
      
      public function set LayerMask(param1:Sprite) : void
      {
         this.FLayerMask = param1;
      }
      
      public function UpdateRankUI(param1:THDHalloweenPumpkin, param2:TActivityHalloweenPumpkinData, param3:Vector.<TInventories>) : void
      {
         this.FHalloweenPumpkinBin = param1;
         this.FData = param2;
         this.FPageIndex = 0;
         this.FInvetoriesList = param3;
         this.UpdateUIPage();
         this.UpdateRankList();
         this.UpdateAward();
         this.UpdateText();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TRankAward = null;
         _loc2_ = AWARD_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FRankAwardList[_loc1_];
            _loc3_.Reset();
            _loc1_++;
         }
      }
   }
}

