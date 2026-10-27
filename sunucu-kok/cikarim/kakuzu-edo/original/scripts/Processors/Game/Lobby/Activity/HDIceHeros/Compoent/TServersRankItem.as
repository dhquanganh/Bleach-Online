package Processors.Game.Lobby.Activity.HDIceHeros.Compoent
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityMode.TActivityCrossServerRank;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TServersRankItem extends TUIComponent
   {
      
      protected var FSence:Sprite;
      
      protected var FTF_Rank:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_ServerID:TextField;
      
      protected var FTF_Count:TextField;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FRankData:TActivityCrossServerRank;
      
      public function TServersRankItem(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FSence = param2;
         this.FSence.visible = false;
      }
      
      protected function RankItemInit() : void
      {
         this.FTF_Rank = this.FSence[CONST_ACTIVITY.RESOURCE_Link_TF_Rank];
         this.FTF_Name = this.FSence[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
         this.FTF_ServerID = this.FSence[CONST_ACTIVITY.RESOURCE_Link_TF_ServerID];
         this.FTF_Count = this.FSence[CONST_ACTIVITY.RESOURCE_Link_TF_Count];
         this.FMC_Bg = this.FSence[CONST_ACTIVITY.RESOURCE_Link_MC_Bg];
         if(this.FMC_Bg != null)
         {
            this.FMC_Bg.stop();
            this.FMC_Bg.visible = false;
         }
         this.FTF_Rank.selectable = false;
         this.FTF_Name.selectable = false;
         this.FTF_ServerID.selectable = false;
         this.FTF_Count.selectable = false;
      }
      
      protected function UpdateUI() : void
      {
         this.FTF_Rank.text = this.FRankData.Rank.toString();
         this.FTF_Name.text = this.FRankData.Name;
         this.FTF_ServerID.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_27),this.FRankData.ServerID.toString());
         this.FTF_Count.text = this.FRankData.Point.toString();
         if(this.FRankData.Rank <= 3)
         {
            this.FMC_Bg.gotoAndStop(this.FRankData.Rank);
            this.FMC_Bg.visible = true;
         }
         else
         {
            this.FMC_Bg.visible = false;
         }
      }
      
      public function set RankVisible(param1:Boolean) : void
      {
         if(this.FSence.visible != param1)
         {
            this.FSence.visible = param1;
         }
      }
      
      public function Init() : void
      {
         this.RankItemInit();
      }
      
      public function UpdateItem(param1:TActivityCrossServerRank) : void
      {
         this.FRankData = param1;
         this.UpdateUI();
      }
   }
}

