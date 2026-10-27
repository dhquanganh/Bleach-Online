package Processors.Game.Common.Effects
{
   import Foundation.Common.*;
   import Processors.Game.Common.Effects.Common.*;
   
   public class TEffectLayer
   {
      
      protected var FEffects:Vector.<TEffect>;
      
      public function TEffectLayer()
      {
         super();
         this.FEffects = new Vector.<TEffect>();
      }
      
      protected function RenderingPerform() : void
      {
         this.RenderingPerform_Effects();
      }
      
      protected function RenderingPerform_Effects() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffect = null;
         _loc1_ = int(this.FEffects.length);
         _loc2_ = 0;
         while(_loc1_ != 0)
         {
            _loc3_ = this.FEffects[_loc2_];
            if(_loc3_.Render())
            {
               _loc2_++;
            }
            else
            {
               _loc3_.StubReferences.Dereference(this);
               this.FEffects.splice(_loc2_,1);
            }
            _loc1_--;
         }
      }
      
      public function get Count() : int
      {
         return this.FEffects.length;
      }
      
      public function GetEffectByIndex(param1:int) : TEffect
      {
         return this.FEffects[param1];
      }
      
      public function Render() : void
      {
         this.RenderingPerform();
      }
      
      public function Add(param1:TEffect) : void
      {
         param1.StubReferences.Reference(this);
         this.FEffects.push(param1);
      }
      
      public function Delete(param1:int) : void
      {
         var _loc2_:TEffect = null;
         _loc2_ = this.FEffects[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FEffects.splice(param1,1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffect = null;
         _loc1_ = int(this.FEffects.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FEffects[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FEffects.length = 0;
      }
   }
}

