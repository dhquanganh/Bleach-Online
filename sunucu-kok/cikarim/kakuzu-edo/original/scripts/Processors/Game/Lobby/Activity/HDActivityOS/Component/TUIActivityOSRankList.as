package Processors.Game.Lobby.Activity.HDActivityOS.Component
{
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   import Resources.Constants.CONST_ACTIVITY;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TUIActivityOSRankList extends TUIComponent
   {
      
      protected var FMC:Sprite;
      
      protected var FTF_Rank:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FRankData:THDOSRank;
      
      protected var FLookPlayerInfoNotification:Function;
      
      public function TUIActivityOSRankList(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         this.FMC = param1;
         addChild(this.FMC);
         this.FTF_Rank = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Ranking];
         this.FTF_Level = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Level];
         this.FTF_Name = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
         this.FTF_Rank.mouseEnabled = false;
         this.FTF_Level.mouseEnabled = false;
         this.FTF_Name.mouseEnabled = false;
      }
      
      protected function UpdateList() : void
      {
         this.FTF_Rank.text = this.FRankData.Rank.toString();
         this.FTF_Level.text = this.FRankData.Level.toString();
         this.FTF_Name.text = this.FRankData.Name;
      }
      
      protected function DoClear() : void
      {
         this.FTF_Rank.text = "";
         this.FTF_Level.text = "";
         this.FTF_Name.text = "";
      }
      
      public function get LookPlayerInfoNotification() : Function
      {
         return this.FLookPlayerInfoNotification;
      }
      
      public function set LookPlayerInfoNotification(param1:Function) : void
      {
         this.FLookPlayerInfoNotification = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpDateList(param1:THDOSRank) : void
      {
         this.FRankData = param1;
         this.UpdateList();
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

