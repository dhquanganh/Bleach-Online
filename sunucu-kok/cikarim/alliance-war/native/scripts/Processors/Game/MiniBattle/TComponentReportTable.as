package Processors.Game.MiniBattle
{
   import Components.Lists.*;
   import Components.Lists.Data.*;
   import Externals.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.MiniBattle.Mode.*;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TComponentReportTable extends TProcessorGame
   {
      
      public static const PositionLeft:int = 0;
      
      public static const PositionTop:int = 1;
      
      protected static const ReportListOffsetX:int = 5;
      
      protected static const ReportListOffsetY:int = 33;
      
      protected var FReportList:TUIList;
      
      protected var FBoard:Sprite;
      
      protected var FIdelList:Vector.<TListItemBattleReport>;
      
      protected var FUseList:Vector.<TListItemBattleReport>;
      
      protected var FormatStringWin:String;
      
      protected var FormatStringLose:String;
      
      protected var FBattleReportAddr:Vector.<String>;
      
      public function TComponentReportTable(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function LoadResource_Perform() : void
      {
         var _loc1_:Sprite = null;
         this.FBoard = TUtilityReflection.CreateDisplayObjectInstance("ReportTable") as Sprite;
         addChild(this.FBoard);
         this.FReportList = new TUIList(this);
         this.FReportList.OnClick = this.ReportItemOnClick;
         this.FBoard = this.FBoard["Board"];
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MiniBattleScroolPanle") as Sprite;
         this.FReportList.Resource = _loc1_;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MiniBattleScroolBar") as Sprite;
         this.FReportList.ScrollBarResource = _loc1_;
         this.FReportList.ScrollBar.Zoom9GridX = 4;
         this.FReportList.ScrollBar.Zoom9GridY = 13;
         this.FReportList.ScrollBar.Zoom9GridWidth = 2;
         this.FReportList.ScrollBar.Zoom9GridHeigh = 1;
         this.FReportList.Perform_UIDispatch();
         this.FReportList.X = this.FBoard.x + ReportListOffsetX;
         this.FBattleReportAddr = new Vector.<String>();
         this.FIdelList = new Vector.<TListItemBattleReport>();
         this.FUseList = new Vector.<TListItemBattleReport>();
         this.FormatStringWin = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_69);
         this.FormatStringLose = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_70);
      }
      
      protected function CreateReportItem(param1:String, param2:int) : TListItemBattleReport
      {
         var _loc3_:MovieClip = null;
         var _loc4_:TListItemBattleReport = null;
         if(this.FIdelList.length != 0)
         {
            _loc4_ = this.FIdelList.pop();
         }
         else
         {
            _loc4_ = new TListItemBattleReport(this);
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("mc_citiDefend_Report") as MovieClip;
            _loc4_.Resource = _loc3_;
            _loc4_.Perform_UIDispatch();
            _loc4_.OnClick = this.ReportItemOnClick;
         }
         _loc4_.UserData = param2;
         _loc4_.Text = param1;
         return _loc4_;
      }
      
      protected function ReleaseReportItem(param1:TListItemBattleReport) : void
      {
         this.FUseList.push(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FReportList != null)
         {
            this.FReportList.RenderingPerform();
         }
      }
      
      protected function ReportItemOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:TListItemBattleReport = null;
         _loc4_ = param1 as TListItemBattleReport;
         param2 = int(_loc4_.UserData);
         _loc3_ = this.FBattleReportAddr[param2];
         SExternalCore.NavigateToBattleReportUrl(_loc3_);
      }
      
      public function AppendBattleReport(param1:TOneBattle) : void
      {
         var _loc2_:TListItemBattleReport = null;
         var _loc3_:String = null;
         if(param1.BattleResult == CONST_MINIBATTLE.BattleResult_Win)
         {
            _loc3_ = TUtilityString.Format(this.FormatStringWin,param1.SoldierFriend.Name,param1.SoldierEnemy.Name);
         }
         else
         {
            _loc3_ = TUtilityString.Format(this.FormatStringLose,param1.SoldierFriend.Name,param1.SoldierEnemy.Name);
         }
         this.FBattleReportAddr.push(param1.BattleReportAddr);
         _loc2_ = this.CreateReportItem(_loc3_,this.FBattleReportAddr.length - 1);
         this.FReportList.Add(_loc2_);
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Perform();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.FReportList.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.ReleaseReportItem(this.FReportList.GetItemByIndex(_loc1_) as TListItemBattleReport);
            _loc1_++;
         }
         this.FReportList.Clear();
      }
      
      public function AdjustPosition(param1:int) : void
      {
         switch(param1)
         {
            case PositionLeft:
               this.FBoard.x = 100;
               break;
            case PositionTop:
               this.FBoard.x = (CONST_COMMON.STAGE_Width - this.FBoard.width) / 2;
         }
         this.FReportList.X = this.FBoard.x + ReportListOffsetX;
         this.FReportList.Y = this.FBoard.y + ReportListOffsetY;
         this.FReportList.EvaluateBoundScreen();
      }
   }
}

