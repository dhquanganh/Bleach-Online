package Processors.Game.Lobby.Home.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityDate;
   import Logics.InteractionLog.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TItemLog extends TUIComponent
   {
      
      protected var FTF_Time:TextField;
      
      protected var FTF_Context:TextField;
      
      protected var FBtn_Visit:TUIButton;
      
      protected var FIsInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FInteractionLog:TInteractionLog;
      
      protected var FOnClick:Function;
      
      public function TItemLog(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         this.FResource.mouseEnabled = false;
         this.FTF_Time = this.FResource[CONST_HOME.RESOURCE_Link_TF_time];
         this.FTF_Context = this.FResource[CONST_HOME.RESOURCE_Link_TF_Context];
         this.FBtn_Visit = new TUIButton();
         this.FBtn_Visit.Substrate = this.FResource[CONST_HOME.RESOURCE_Link_Btn_Visit];
         this.FBtn_Visit.OnClick = this.Btn_VisitOnClick;
         this.FIsInitialization = true;
      }
      
      protected function RenderingPerform() : void
      {
         if(this.Context != null)
         {
            this.FTF_Time.text = TUtilityDate.FormatDateChineseNewByTime(this.Context.Time * 1000);
            this.FTF_Context.htmlText = this.Context.HtmlText;
         }
         else
         {
            this.FTF_Time.text = "0";
            this.FTF_Context.text = "";
         }
      }
      
      protected function Btn_VisitOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FInteractionLog);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FIsInitialization)
         {
            this.Initialization();
         }
      }
      
      public function get Context() : TInteractionLog
      {
         return this.FInteractionLog;
      }
      
      public function set Context(param1:TInteractionLog) : void
      {
         if(param1 != this.FInteractionLog)
         {
            this.FInteractionLog = param1;
            this.RenderingPerform();
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
   }
}

