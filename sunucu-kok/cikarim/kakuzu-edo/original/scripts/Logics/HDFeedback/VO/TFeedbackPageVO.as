package Logics.HDFeedback.VO
{
   public class TFeedbackPageVO
   {
      
      protected var FProgressDesc:String;
      
      protected var FProgress:String;
      
      protected var FLinkID:int;
      
      protected var FHavePageUI:Boolean;
      
      protected var FShowAwardList:Vector.<TFeedbackShowAwardVO>;
      
      public function TFeedbackPageVO()
      {
         super();
         this.FShowAwardList = new Vector.<TFeedbackShowAwardVO>();
      }
      
      public function get Progress() : String
      {
         return this.FProgress;
      }
      
      public function set Progress(param1:String) : void
      {
         this.FProgress = param1;
      }
      
      public function get LinkID() : int
      {
         return this.FLinkID;
      }
      
      public function set LinkID(param1:int) : void
      {
         this.FLinkID = param1;
      }
      
      public function get HavePageUI() : Boolean
      {
         return this.FHavePageUI;
      }
      
      public function set HavePageUI(param1:Boolean) : void
      {
         this.FHavePageUI = param1;
      }
      
      public function get ShowAwardList() : Vector.<TFeedbackShowAwardVO>
      {
         return this.FShowAwardList;
      }
      
      public function set ShowAwardList(param1:Vector.<TFeedbackShowAwardVO>) : void
      {
         this.FShowAwardList = param1;
      }
      
      public function get ProgressDesc() : String
      {
         return this.FProgressDesc;
      }
      
      public function set ProgressDesc(param1:String) : void
      {
         this.FProgressDesc = param1;
      }
   }
}

