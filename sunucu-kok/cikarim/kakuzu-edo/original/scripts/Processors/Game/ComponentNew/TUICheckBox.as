package Processors.Game.ComponentNew
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUICheckBox extends TUICustomComponent
   {
      
      protected static const RENDERINGSTATE_Normal:uint = 1;
      
      protected static const RENDERINGSTATE_Hovering:uint = 2;
      
      protected static const RENDERINGSTATE_Pressed:uint = 3;
      
      protected static const RENDERINGSTATE_Disabled:uint = 4;
      
      protected var FButtonChecked:MovieClip;
      
      protected var FButtonUnchecked:MovieClip;
      
      protected var FTF_Label:TextField;
      
      protected var FCurButton:MovieClip;
      
      protected var FChecked:Boolean;
      
      protected var FMousePressed:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FOnCheckCondition:Function;
      
      protected var FOnMove:Function;
      
      public function TUICheckBox()
      {
         super();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FButtonChecked = FResource["Btn_Checked"];
         this.FButtonUnchecked = FResource["Btn_Unchecked"];
         this.FTF_Label = FResource["TF_Label"];
         this.AddAllEventListener();
         FResource.mouseChildren = false;
         FResource.buttonMode = true;
         this.Reset();
      }
      
      override protected function AddAllEventListener() : void
      {
         SetAddEventListener(FResource,MouseEvent.CLICK,this.BtnOnClick);
         SetAddEventListener(FResource,MouseEvent.ROLL_OVER,this.ButtonOnOver);
         SetAddEventListener(FResource,MouseEvent.ROLL_OUT,this.ButtonOnOut);
         SetAddEventListener(FResource,MouseEvent.MOUSE_DOWN,this.ButtonOnDown);
         SetAddEventListener(FResource,MouseEvent.MOUSE_UP,this.ButtonOnUp);
         super.AddAllEventListener();
      }
      
      override protected function RemoveAllEventListener() : void
      {
         SetRemoveEventListener(FResource,MouseEvent.ROLL_OVER,this.ButtonOnOver);
         SetRemoveEventListener(FResource,MouseEvent.ROLL_OUT,this.ButtonOnOut);
         super.RemoveAllEventListener();
      }
      
      protected function BtnOnClick(param1:MouseEvent) : void
      {
         if(this.FOnCheckCondition != null)
         {
            if(!this.FOnCheckCondition(this))
            {
               return;
            }
         }
         this.Checked = !this.Checked;
         if(this.FOnClick != null)
         {
            this.FOnClick(this.FChecked);
         }
      }
      
      protected function ButtonOnDown(param1:MouseEvent) : void
      {
         if(this.FCurButton.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         this.ChangeFrame(RENDERINGSTATE_Pressed);
         this.FMousePressed = true;
      }
      
      protected function ButtonOnUp(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         if(this.FMousePressed)
         {
            this.FMousePressed = false;
            if(FEnabled)
            {
               if(this.FCurButton.currentFrame == RENDERINGSTATE_Disabled)
               {
                  return;
               }
               if(this.FCurButton.currentFrame != RENDERINGSTATE_Hovering)
               {
                  this.ChangeFrame(RENDERINGSTATE_Hovering);
               }
               else if(this.FCurButton.currentFrame != RENDERINGSTATE_Normal)
               {
                  this.ChangeFrame(RENDERINGSTATE_Normal);
               }
            }
         }
      }
      
      protected function ButtonOnOver(param1:MouseEvent) : void
      {
         if(this.FCurButton.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         if(this.FCurButton.currentFrame != RENDERINGSTATE_Hovering)
         {
            this.ChangeFrame(RENDERINGSTATE_Hovering);
         }
      }
      
      protected function ButtonOnOut(param1:MouseEvent) : void
      {
         if(this.FCurButton.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         if(this.FCurButton.currentFrame != RENDERINGSTATE_Normal)
         {
            this.ChangeFrame(RENDERINGSTATE_Normal);
         }
         this.FMousePressed = false;
      }
      
      protected function ButtonOnMove(param1:MouseEvent) : void
      {
         if(this.FOnMove != null)
         {
            this.FOnMove(this,param1);
         }
      }
      
      protected function ChangeFrame(param1:int) : void
      {
         this.FCurButton.gotoAndStop(param1);
      }
      
      public function get Label() : String
      {
         return this.FTF_Label.text;
      }
      
      public function set Label(param1:String) : void
      {
         this.FTF_Label.text = param1;
      }
      
      public function get Checked() : Boolean
      {
         return this.FChecked;
      }
      
      public function set Checked(param1:Boolean) : void
      {
         this.FChecked = param1;
         this.FButtonChecked.visible = param1;
         this.FButtonUnchecked.visible = !param1;
         this.FCurButton = param1 ? this.FButtonChecked : this.FButtonUnchecked;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function set OnCheckCondition(param1:Function) : void
      {
         this.FOnCheckCondition = param1;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      override public function Reset() : void
      {
         this.FButtonChecked.visible = false;
         this.FButtonUnchecked.visible = true;
         this.FCurButton = this.FButtonUnchecked;
         this.FChecked = false;
         this.Visible = true;
         super.Reset();
      }
      
      override public function Dispose() : void
      {
         this.RemoveAllEventListener();
         this.FButtonChecked = null;
         this.FButtonUnchecked = null;
         this.FOnClick = null;
         super.Dispose();
      }
   }
}

