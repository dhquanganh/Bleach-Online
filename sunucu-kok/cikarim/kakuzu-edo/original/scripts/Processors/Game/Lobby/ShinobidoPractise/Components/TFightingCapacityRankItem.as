package Processors.Game.Lobby.ShinobidoPractise.Components
{
   import Foundation.UI.TUIComponent;
   import Logics.FightingCapacity.TFightingCapacityRank;
   import Processors.Game.TProcessorGame;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TFightingCapacityRankItem extends TProcessorGame
   {
      
      protected var FTF_Rank:TextField;
      
      protected var FMC_Family:MovieClip;
      
      protected var FTF_UserName:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_FightingCapacity:TextField;
      
      protected var FResource:MovieClip;
      
      public function TFightingCapacityRankItem(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initializition() : void
      {
         this.FTF_Rank = this.FResource["TF_Rank"];
         this.FMC_Family = this.FResource["MC_Family"];
         this.FTF_UserName = this.FResource["TF_UserName"];
         this.FTF_Level = this.FResource["TF_Level"];
         this.FTF_FightingCapacity = this.FResource["TF_FightingCapacity"];
         this.FResource.visible = false;
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function Init() : void
      {
         this.Initializition();
      }
      
      public function SetInfo(param1:TFightingCapacityRank) : void
      {
         this.FTF_Rank.text = param1.Rank.toString();
         if(param1.Family == 0)
         {
            this.FMC_Family.visible = false;
         }
         else
         {
            this.FMC_Family.visible = true;
            this.FMC_Family.gotoAndStop(param1.Family);
         }
         this.FTF_UserName.text = param1.Name;
         this.FTF_Level.text = param1.Level.toString();
         this.FTF_FightingCapacity.text = param1.FightingCapacity.toString();
      }
   }
}

