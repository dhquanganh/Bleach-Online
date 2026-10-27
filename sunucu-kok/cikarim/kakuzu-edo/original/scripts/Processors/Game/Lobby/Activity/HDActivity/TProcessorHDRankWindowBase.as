package Processors.Game.Lobby.Activity.HDActivity
{
   import Components.Pages.TUIPage;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TProcessorHDRankWindowBase extends TProcessorHDSingleWindowBase
   {
      
      protected var FServerVec:Vector.<TextField>;
      
      protected var FNameVec:Vector.<TextField>;
      
      protected var FScoreVec:Vector.<TextField>;
      
      protected var FRankVec:Vector.<TextField>;
      
      protected var FContainName:String;
      
      protected var FRenderName:String;
      
      protected var FRankName:String;
      
      protected var FServerName:String;
      
      protected var FPlayerName:String;
      
      protected var FScoreName:String;
      
      protected var FRankNum:int;
      
      protected var FRankDatas:Vector.<TActivityServerRank>;
      
      public function TProcessorHDRankWindowBase(param1:TUIComponent)
      {
         super(param1);
         this.FContainName = "MC_List";
         this.FRenderName = "MC_Rank_";
         this.FRankName = "TF_Prompt_0";
         this.FServerName = "TF_Prompt_1";
         this.FPlayerName = "TF_Prompt_2";
         this.FScoreName = "TF_Prompt_3";
         this.FServerVec = new Vector.<TextField>();
         this.FNameVec = new Vector.<TextField>();
         this.FScoreVec = new Vector.<TextField>();
         this.FRankVec = new Vector.<TextField>();
         FPageIndex = 0;
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         _loc1_ = 0;
         while(_loc1_ < this.FRankNum)
         {
            if(_loc1_ < this.FRankDatas.length)
            {
               _loc2_ = FPageIndex * this.FRankNum + _loc1_;
               this.FRankVec[_loc1_].text = this.FRankDatas[_loc2_].Rank + "";
               this.FServerVec[_loc1_].text = this.FRankDatas[_loc2_].ServerID + "";
               this.FNameVec[_loc1_].text = this.FRankDatas[_loc2_].Name;
               this.FScoreVec[_loc1_].text = this.FRankDatas[_loc2_].Value + "";
            }
            else
            {
               this.FRankVec[_loc1_].text = "";
               this.FServerVec[_loc1_].text = "";
               this.FNameVec[_loc1_].text = "";
               this.FScoreVec[_loc1_].text = "";
            }
            _loc1_++;
         }
      }
      
      public function get RankNum() : int
      {
         return this.FRankNum;
      }
      
      public function set RankNum(param1:int) : void
      {
         this.FRankNum = param1;
      }
      
      public function get RankDatas() : Vector.<TActivityServerRank>
      {
         return this.FRankDatas;
      }
      
      public function set RankDatas(param1:Vector.<TActivityServerRank>) : void
      {
         this.FRankDatas = param1;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         super.InitWindow(param1);
         _loc2_ = FScene[this.FContainName];
         if(_loc2_ == null)
         {
            _loc2_ = FScene;
         }
         _loc3_ = 0;
         while(_loc3_ < this.FRankNum)
         {
            this.FRankVec.push(_loc2_[this.FRenderName + _loc3_][this.FRankName]);
            this.FServerVec.push(_loc2_[this.FRenderName + _loc3_][this.FServerName]);
            this.FNameVec.push(_loc2_[this.FRenderName + _loc3_][this.FPlayerName]);
            this.FScoreVec.push(_loc2_[this.FRenderName + _loc3_][this.FScoreName]);
            _loc3_++;
         }
         if(FScene["MC_Page"] == null)
         {
            return;
         }
         FUIPage = new TUIPage(this);
         FUIPage.ButtonPrevious.Substrate = FScene["MC_Page"]["btn_left"];
         FUIPage.ButtonNext.Substrate = FScene["MC_Page"]["btn_right"];
         FUIPage.OnChangePage = ProcessorPageOnChange;
         FUIPage.LabelPage = FScene["MC_Page"]["TF_Page"];
         FUIPage.PageSize = this.FRankNum;
         FUIPage.Init();
      }
      
      public function SetRankMcName(param1:String, param2:String, param3:String, param4:String, param5:String = null, param6:String = null) : void
      {
         this.FRankName = param1;
         this.FServerName = param2;
         this.FPlayerName = param3;
         this.FScoreName = param4;
         if(this.FContainName != null)
         {
            this.FContainName = param5;
         }
         if(this.FRenderName != null)
         {
            this.FRenderName = param6;
         }
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         FUIPage.SetupPage(this.FRankDatas.length,0);
         this.UpdateUI();
      }
   }
}

