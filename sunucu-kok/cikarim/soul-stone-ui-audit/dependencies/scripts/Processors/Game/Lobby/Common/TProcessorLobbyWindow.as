package Processors.Game.Lobby.Common
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Processors.Game.*;
   import Processors.Game.Common.Effects.Texts.TEffectCoordinateParameters;
   import Processors.Game.Common.Effects.Texts.TEffectTextParameters;
   import Resources.Constants.*;
   import flash.display.DisplayObject;
   
   public class TProcessorLobbyWindow extends TProcessorGame
   {
      
      protected static const STAGE_Width:int = CONST_COMMON.STAGE_Width;
      
      protected static const STAGE_Height:int = CONST_COMMON.STAGE_Height;
      
      protected var FNCMoving:Boolean;
      
      protected var FMovable:Boolean;
      
      protected var FOnClose:Function;
      
      protected var FOnEffectText:Function;
      
      protected var FOnEffectHtmlText:Function;
      
      public function TProcessorLobbyWindow(param1:TUIComponent)
      {
         super(param1);
         Visible = false;
      }
      
      public static function GetUIComponentsCapacity(param1:DisplayObject, param2:String) : int
      {
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         while(true)
         {
            _loc4_ = param1[param2 + _loc3_++];
            if(_loc4_ == null)
            {
               break;
            }
            _loc5_++;
         }
         return _loc5_;
      }
      
      override protected function RevokeInteraction() : void
      {
         super.RevokeInteraction();
         this.FNCMoving = false;
      }
      
      protected function ProcessorWindowClose() : void
      {
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
         Visible = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function ResourcesPerform_RequestDefault() : void
      {
      }
      
      protected function ResourcesPerform_DispatchDefault() : void
      {
      }
      
      protected function InteractionEnable() : void
      {
      }
      
      protected function InteractionDisable() : void
      {
      }
      
      protected function EffectGenerateText(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         if(this.FOnEffectText != null)
         {
            this.FOnEffectText(this,param1,param2,param3);
         }
      }
      
      protected function EffectGenerateHtmlText(param1:String) : void
      {
         if(this.FOnEffectHtmlText != null)
         {
            this.FOnEffectHtmlText(this,param1);
         }
      }
      
      protected function TutorialNextStep(param1:Object) : void
      {
         SLogicsCore.SinalPostFreshGuide(param1);
      }
      
      protected function TutorialSendComponent(param1:int, param2:Object) : void
      {
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,param1,param2);
      }
      
      protected function TutorialSendArrowParent(param1:int, param2:Object) : void
      {
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,param1,param2);
      }
      
      protected function NCButtonCloseOnClick(param1:Object) : void
      {
         this.ProcessorWindowClose();
      }
      
      public function get Movable() : Boolean
      {
         return this.FMovable;
      }
      
      public function set Movable(param1:Boolean) : void
      {
         this.FMovable = param1;
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnEffectHtmlText() : Function
      {
         return this.FOnEffectHtmlText;
      }
      
      public function set OnEffectHtmlText(param1:Function) : void
      {
         this.FOnEffectHtmlText = param1;
      }
      
      public function Close() : void
      {
         if(Visible)
         {
            this.ProcessorWindowClose();
         }
      }
      
      public function Suspend() : void
      {
         this.InteractionDisable();
      }
      
      public function Resume() : void
      {
         this.InteractionEnable();
      }
   }
}

