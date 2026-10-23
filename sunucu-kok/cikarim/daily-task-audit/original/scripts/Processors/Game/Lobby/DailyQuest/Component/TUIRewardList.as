package Processors.Game.Lobby.DailyQuest.Component
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DAILY_QUEST;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIRewardList extends TUIComponent
   {
      
      public static const RENDERINGSTATE_Normal:int = 1;
      
      public static const RENDERINGSTATE_Selected:int = 2;
      
      public static const RENDERINGSTATE_Disabled:int = 3;
      
      protected static const DOUBLE_FRAME:uint = 13;
      
      protected var FMC_List:MovieClip;
      
      protected var FTF_RewardContent:TextField;
      
      protected var FMC_Double:MovieClip;
      
      protected var FIsInitialization:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FContext:Object;
      
      protected var FIsDouble:Boolean;
      
      public function TUIRewardList(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC_List = param1;
         this.FTF_RewardContent = this.FMC_List["mc_RewardContent"][CONST_DAILY_QUEST.RESOURCE_Link_TF_RewardContent];
         this.FMC_Double = this.FMC_List[CONST_DAILY_QUEST.RESOURCE_Link_MC_Double];
         this.FMC_List.addEventListener(MouseEvent.MOUSE_MOVE,this.ListOnMove);
         this.FMC_List.addEventListener(MouseEvent.MOUSE_OUT,this.ListOnOut);
         this.FMC_List.gotoAndStop(RENDERINGSTATE_Disabled);
      }
      
      private function ListOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this);
         }
      }
      
      private function ListOnMove(param1:MouseEvent) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(this,this.FContext);
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FContext = param1;
      }
      
      public function get IsDouble() : Boolean
      {
         return this.FIsDouble;
      }
      
      public function set IsDouble(param1:Boolean) : void
      {
         this.FIsDouble = param1;
      }
      
      public function get MC_List() : MovieClip
      {
         return this.FMC_List;
      }
      
      public function set MC_List(param1:MovieClip) : void
      {
         this.FMC_List = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function Update() : void
      {
         if(this.FContext == null)
         {
            return;
         }
         this.FTF_RewardContent.text = this.FContext.Name + "*" + this.FContext.Quantity.toString();
         this.FTF_RewardContent.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FContext.Quality];
      }
      
      public function SetStatus(param1:uint, param2:Boolean) : void
      {
         if(this.IsDouble)
         {
            if(param2)
            {
               this.FMC_Double.gotoAndPlay(1);
            }
            else
            {
               this.FMC_Double.gotoAndStop(DOUBLE_FRAME);
            }
            this.FMC_Double.visible = true;
         }
         else
         {
            this.FMC_Double.gotoAndStop(1);
            this.FMC_Double.visible = false;
         }
         this.FMC_List.gotoAndStop(param1);
         if(param1 == RENDERINGSTATE_Disabled)
         {
            this.FMC_List.mouseEnabled = false;
            this.FTF_RewardContent.textColor = 10066329;
         }
         else if(param1 == RENDERINGSTATE_Normal)
         {
            this.FMC_List.mouseEnabled = true;
         }
      }
   }
}

