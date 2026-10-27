package Processors.Game.Common.Effects
{
   import Foundation.Pools.TPoolAutomatic;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Common.Effects.Animations.TEffectAnimationLinear;
   import Processors.Game.Common.Effects.Animations.TEffectAnimationLinearCrossfade;
   import Processors.Game.Common.Effects.Ballistics.TEffectPuzzleBallistic;
   import Processors.Game.Common.Effects.Common.TEffect;
   import Processors.Game.Common.Effects.Texts.TEffectHtmlTextLinearCrossfade;
   import Processors.Game.Common.Effects.Texts.TEffectTextLinear;
   import Processors.Game.Common.Effects.Texts.TEffectTextLinearCrossfade;
   
   public class TPoolEffect extends TPoolAutomatic
   {
      
      protected var FIndexEffectAnimationLinear:int;
      
      protected var FIndexEffectAnimationLinearCrossfade:int;
      
      protected var FIndexEffectTextLinear:int;
      
      protected var FIndexEffectTextLinearCrossfade:int;
      
      protected var FIndexEffectHtmlTextLinearCrossfade:int;
      
      protected var FIndexEffectPuzzleBallistic:int;
      
      public function TPoolEffect()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexEffectAnimationLinear = RegisterClass(TEffectAnimationLinear,this.ReleasingPerform_Effect);
         this.FIndexEffectAnimationLinearCrossfade = RegisterClass(TEffectAnimationLinearCrossfade,this.ReleasingPerform_Effect);
         this.FIndexEffectTextLinear = RegisterClass(TEffectTextLinear,this.ReleasingPerform_Effect);
         this.FIndexEffectTextLinearCrossfade = RegisterClass(TEffectTextLinearCrossfade,this.ReleasingPerform_Effect);
         this.FIndexEffectHtmlTextLinearCrossfade = RegisterClass(TEffectHtmlTextLinearCrossfade,this.ReleasingPerform_Effect);
         this.FIndexEffectPuzzleBallistic = RegisterClass(TEffectPuzzleBallistic,this.ReleasingPerform_Effect);
      }
      
      protected function ReleasingPerform_Effect(param1:Object) : void
      {
         var _loc2_:TEffect = null;
         _loc2_ = param1 as TEffect;
         _loc2_.Reset();
      }
      
      public function AcquireAnimationLinear(param1:TUIComponent) : TEffectAnimationLinear
      {
         var _loc2_:TEffectAnimationLinear = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEffectAnimationLinear) as TEffectAnimationLinear;
         if(_loc2_ == null)
         {
            _loc2_ = new TEffectAnimationLinear(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireAnimationLinearCrossfade(param1:TUIComponent) : TEffectAnimationLinearCrossfade
      {
         var _loc2_:TEffectAnimationLinearCrossfade = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEffectAnimationLinear) as TEffectAnimationLinearCrossfade;
         if(_loc2_ == null)
         {
            _loc2_ = new TEffectAnimationLinearCrossfade(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireTextLinear(param1:TUIComponent) : TEffectTextLinear
      {
         var _loc2_:TEffectTextLinear = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEffectTextLinear) as TEffectTextLinear;
         if(_loc2_ == null)
         {
            _loc2_ = new TEffectTextLinear(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireTextLinearCrossfade(param1:TUIComponent) : TEffectTextLinearCrossfade
      {
         var _loc2_:TEffectTextLinearCrossfade = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEffectTextLinearCrossfade) as TEffectTextLinearCrossfade;
         if(_loc2_ == null)
         {
            _loc2_ = new TEffectTextLinearCrossfade(param1);
         }
         _loc2_.Visible = true;
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireHtmlTextLinearCrossfade(param1:TUIComponent) : TEffectHtmlTextLinearCrossfade
      {
         var _loc2_:TEffectHtmlTextLinearCrossfade = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEffectHtmlTextLinearCrossfade) as TEffectHtmlTextLinearCrossfade;
         if(_loc2_ == null)
         {
            _loc2_ = new TEffectHtmlTextLinearCrossfade(param1);
         }
         _loc2_.Visible = true;
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquirePuzzleBallistic(param1:TUIComponent) : TEffectPuzzleBallistic
      {
         var _loc2_:TEffectPuzzleBallistic = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexEffectPuzzleBallistic) as TEffectPuzzleBallistic;
         if(_loc2_ == null)
         {
            _loc2_ = new TEffectPuzzleBallistic(param1);
         }
         _loc2_.Visible = true;
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

