package Processors.Game.Common.Effects.Transition
{
   import Foundation.UI.TUIComponent;
   import Logics.Affairs.TAffair;
   import Processors.Game.Lobby.Common.TProcessorLobbyModule;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.CONST_COMMON;
   import flash.display.BlendMode;
   import ghostcat.display.transition.TransitionSimpleLayer;
   import ghostcat.operation.RepeatOper;
   import ghostcat.operation.TweenOper;
   import ghostcat.util.easing.Cubic;
   
   public class TEffectTransition extends TProcessorGame
   {
      
      public static var STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static var STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected static const AFFAIRID_EffectTransition:uint = 4293918720;
      
      protected var FTransitionSimpleLayer:TransitionSimpleLayer;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FTarget:TProcessorLobbyModule;
      
      public function TEffectTransition(param1:TUIComponent)
      {
         super(param1);
         this.ConstructTransitionSimpleLayer();
         this.ConstructTweens();
      }
      
      protected function ConstructTransitionSimpleLayer() : void
      {
         this.FTransitionSimpleLayer = new TransitionSimpleLayer(null,1250,650,4278190080,BlendMode.NORMAL,1,1000,false);
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
         this.FTweenOperIn.duration = 10;
         this.FTweenOperIn.params = {
            "alpha":0,
            "ease":Cubic.easeIn
         };
         this.FTweenOperOut.duration = 500;
         this.FTweenOperOut.params = {
            "alpha":1,
            "ease":Cubic.easeOut
         };
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_EffectTransition,this.AffairPerform_EffectTransition);
      }
      
      protected function AffairPerform_EffectTransition(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.EffectTransition();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function EffectTransition() : Boolean
      {
         this.ProcessorWindowTTransition();
         return false;
      }
      
      protected function ProcessorWindowTTransition() : void
      {
         var _loc1_:TProcessorLobbyPlate = null;
         if(this.FTarget == null)
         {
            return;
         }
         if(this.FTarget is TProcessorLobbyPlate)
         {
            _loc1_ = this.FTarget as TProcessorLobbyPlate;
            this.FTransitionSimpleLayer.destory();
            this.FTransitionSimpleLayer.createTo(_loc1_);
            this.FTransitionSimpleLayer.start();
         }
         else if(this.FTarget is TProcessorLobbyWindows)
         {
            this.FTweenOperIn.target = this.FTarget;
            this.FTweenOperOut.target = this.FTarget;
            this.FRepeatOper.execute();
         }
      }
      
      public function SetEffectByDisplayObject(param1:Object) : void
      {
         this.FTarget = param1 as TProcessorLobbyModule;
         FAffairGenerator.Generate(AFFAIRID_EffectTransition);
      }
   }
}

