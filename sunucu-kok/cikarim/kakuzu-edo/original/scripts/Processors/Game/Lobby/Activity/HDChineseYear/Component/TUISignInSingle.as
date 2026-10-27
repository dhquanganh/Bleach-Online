package Processors.Game.Lobby.Activity.HDChineseYear.Component
{
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityChineseYear.TActivityDateSign;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUISignInSingle extends TUIComponent
   {
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_Scene:MovieClip;
      
      protected var FMC_IsAlreadyReceive:MovieClip;
      
      protected var FDataSignIn:TActivityDateSign;
      
      protected var FOnSceneOver:Function;
      
      protected var FOnSceneOut:Function;
      
      public function TUISignInSingle(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC_Scene = param1;
         this.FMC_IsAlreadyReceive = this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FMC_IsAlreadyReceive.mouseChildren = false;
         this.FMC_IsAlreadyReceive.mouseEnabled = false;
         this.FMC_IsAlreadyReceive.stop();
         this.FMC_IsAlreadyReceive.visible = false;
         this.FMC_Scene.addEventListener(MouseEvent.MOUSE_MOVE,this.SceneOnOver);
         this.FMC_Scene.addEventListener(MouseEvent.MOUSE_OUT,this.SceneOnOut);
      }
      
      protected function ProcessorUpdateUI() : void
      {
         if(this.FDataSignIn == null)
         {
            return;
         }
         if(this.FDataSignIn.Status == Activity_AlreadyReceive)
         {
            this.FMC_Scene.gotoAndStop(2);
         }
         else
         {
            this.FMC_Scene.gotoAndStop(1);
         }
         if(this.FDataSignIn.Status == Activity_AlreadyReceive)
         {
            this.FMC_IsAlreadyReceive.play();
            this.FMC_IsAlreadyReceive.visible = true;
         }
         else
         {
            this.FMC_IsAlreadyReceive.stop();
            this.FMC_IsAlreadyReceive.visible = false;
         }
      }
      
      protected function DoClear() : void
      {
         if(this.FMC_IsAlreadyReceive != null)
         {
            this.FMC_IsAlreadyReceive.stop();
            this.FMC_IsAlreadyReceive.visible = false;
         }
      }
      
      protected function SceneOnOver(param1:MouseEvent) : void
      {
         if(this.FOnSceneOver != null)
         {
            if(this.FDataSignIn != null)
            {
               this.FOnSceneOver(this.FDataSignIn.Index);
            }
         }
      }
      
      protected function SceneOnOut(param1:MouseEvent) : void
      {
         if(this.FOnSceneOut != null)
         {
            if(this.FDataSignIn != null)
            {
               this.FOnSceneOut(this.FDataSignIn.Index);
            }
         }
      }
      
      public function get OnSceneOver() : Function
      {
         return this.FOnSceneOver;
      }
      
      public function set OnSceneOver(param1:Function) : void
      {
         this.FOnSceneOver = param1;
      }
      
      public function get OnSceneOut() : Function
      {
         return this.FOnSceneOut;
      }
      
      public function set OnSceneOut(param1:Function) : void
      {
         this.FOnSceneOut = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:TActivityDateSign) : void
      {
         this.FDataSignIn = param1;
         this.ProcessorUpdateUI();
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

