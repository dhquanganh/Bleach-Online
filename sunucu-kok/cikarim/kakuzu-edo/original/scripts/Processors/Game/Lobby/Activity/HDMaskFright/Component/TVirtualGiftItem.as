package Processors.Game.Lobby.Activity.HDMaskFright.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TVirtualGiftItem extends TUIComponent
   {
      
      protected static const FRAME_ALREADY:uint = 3;
      
      protected static const FRAME_CAN:uint = 2;
      
      protected static const FRAME_CANNOT:uint = 1;
      
      protected static const FRAME_BOXOVER:uint = 2;
      
      protected static const FRAME_BOXOUT:uint = 1;
      
      protected var FScene:MovieClip;
      
      protected var FMC_Box:MovieClip;
      
      protected var FTF_Need:TextField;
      
      protected var FBtn_Get:TUIButton;
      
      protected var FMC_BigEffect:MovieClip;
      
      protected var FMC_GroundEffect:MovieClip;
      
      protected var FOnBoxMove:Function;
      
      protected var FOnBoxOut:Function;
      
      protected var FOnBoxGet:Function;
      
      public function TVirtualGiftItem(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FScene = param2;
      }
      
      protected function GiftItemInit() : void
      {
         var _loc1_:MovieClip = null;
         this.FMC_Box = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Box];
         this.FMC_Box.stop();
         this.FMC_BigEffect = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_BigEffect];
         if(this.FMC_BigEffect != null)
         {
            this.FMC_BigEffect.stop();
         }
         _loc1_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_Get];
         this.FBtn_Get = new TUIButton();
         this.FBtn_Get.Substrate = _loc1_;
         this.FBtn_Get.OnClick = this.GetOnClick;
         this.FMC_Box.addEventListener(MouseEvent.MOUSE_MOVE,this.BoxOnMove);
         this.FMC_Box.addEventListener(MouseEvent.MOUSE_OUT,this.BoxOnOut);
      }
      
      protected function UpdateGiftItem(param1:int, param2:String) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         switch(param1)
         {
            case CONST_ACTIVITY_MODE.Activity_AlreadyReceive:
               this.FScene.gotoAndStop(FRAME_ALREADY);
               break;
            case CONST_ACTIVITY_MODE.Activity_CanNotReceive:
               this.FScene.gotoAndStop(FRAME_CANNOT);
               this.FBtn_Get.Enabled = false;
               break;
            case CONST_ACTIVITY_MODE.Activity_CanReceive:
               this.FScene.gotoAndStop(FRAME_CAN);
               this.FBtn_Get.Enabled = true;
               _loc3_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_MC_GroundEffect];
               _loc3_.play();
         }
         _loc4_ = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Need];
         _loc4_.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_21),param2);
         if(this.FMC_BigEffect != null)
         {
            this.FMC_BigEffect.play();
         }
      }
      
      protected function BoxOnMove(param1:MouseEvent) : void
      {
         this.FMC_Box.gotoAndStop(FRAME_BOXOVER);
         if(this.FOnBoxMove != null)
         {
            this.FOnBoxMove(this,Tag);
         }
      }
      
      protected function BoxOnOut(param1:MouseEvent) : void
      {
         this.FMC_Box.gotoAndStop(FRAME_BOXOUT);
         if(this.FOnBoxOut != null)
         {
            this.FOnBoxOut(this);
         }
      }
      
      protected function GetOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBoxGet != null)
         {
            this.FOnBoxGet(this,Tag);
         }
      }
      
      public function get OnBoxMove() : Function
      {
         return this.FOnBoxMove;
      }
      
      public function set OnBoxMove(param1:Function) : void
      {
         this.FOnBoxMove = param1;
      }
      
      public function get OnBoxOut() : Function
      {
         return this.FOnBoxOut;
      }
      
      public function set OnBoxOut(param1:Function) : void
      {
         this.FOnBoxOut = param1;
      }
      
      public function get OnBoxGet() : Function
      {
         return this.FOnBoxGet;
      }
      
      public function set OnBoxGet(param1:Function) : void
      {
         this.FOnBoxGet = param1;
      }
      
      public function Init() : void
      {
         this.GiftItemInit();
      }
      
      public function UpdateState(param1:int, param2:String) : void
      {
         this.UpdateGiftItem(param1,param2);
      }
   }
}

