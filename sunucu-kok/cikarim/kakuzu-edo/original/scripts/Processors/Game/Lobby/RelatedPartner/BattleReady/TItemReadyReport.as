package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class TItemReadyReport
   {
      
      protected var FMainUI:Sprite;
      
      protected var FTFLevel:TextField;
      
      protected var FTFName:TextField;
      
      protected var FTFRead:TextField;
      
      protected var FReportIndex:int;
      
      protected var FOnLink:Function;
      
      public function TItemReadyReport(param1:Sprite, param2:int)
      {
         super();
         this.FMainUI = param1;
         this.FReportIndex = param2;
         this.FTFLevel = this.FMainUI["TF_Level"];
         this.FTFName = this.FMainUI["TF_Name"];
         this.FTFRead = this.FMainUI["TF_Read"];
         this.FTFLevel.text = "";
         this.FTFName.text = "";
         this.FTFRead.htmlText = "<font><u><a href=\'event:" + this.FReportIndex + "\'>" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_11) + "</a></u></font>";
         this.FTFRead.addEventListener(TextEvent.LINK,this.OnTextLink);
      }
      
      private function OnTextLink(param1:TextEvent) : void
      {
         if(this.FOnLink != null)
         {
            this.FOnLink(int(param1.text));
         }
      }
      
      public function get ReportIndex() : int
      {
         return this.FReportIndex;
      }
      
      public function get OnLink() : Function
      {
         return this.FOnLink;
      }
      
      public function set OnLink(param1:Function) : void
      {
         this.FOnLink = param1;
      }
   }
}

