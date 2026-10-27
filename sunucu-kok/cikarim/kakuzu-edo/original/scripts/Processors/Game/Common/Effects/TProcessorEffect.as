package Processors.Game.Common.Effects
{
   import Foundation.UI.*;
   import Processors.Game.*;
   
   public class TProcessorEffect extends TProcessorGame
   {
      
      protected var FPoolEffect:TPoolEffect;
      
      protected var FLayers:Vector.<TEffectLayer>;
      
      protected var FLayerBase:TEffectLayer;
      
      public function TProcessorEffect(param1:TUIComponent)
      {
         super(param1);
         this.ConstructEffectPool();
         this.FLayers = new Vector.<TEffectLayer>();
         this.ConstructEffectLayers();
      }
      
      protected function ConstructEffectPool() : void
      {
         this.FPoolEffect = new TPoolEffect();
      }
      
      protected function ConstructEffectLayers() : void
      {
         this.FLayerBase = this.ConstructEffectLayer();
      }
      
      protected function ConstructEffectLayer() : TEffectLayer
      {
         var _loc1_:TEffectLayer = null;
         _loc1_ = new TEffectLayer();
         this.FLayers.push(_loc1_);
         return _loc1_;
      }
      
      protected function RenderingPerform() : void
      {
         this.RenderingPerform_EffectLayers();
      }
      
      protected function RenderingPerform_EffectLayers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffectLayer = null;
         _loc1_ = int(this.FLayers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FLayers[_loc2_];
            _loc3_.Render();
            _loc2_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         LogicsPerform_Affairs();
         this.LogicsPerform_Effects();
      }
      
      protected function LogicsPerform_Effects() : void
      {
         this.FPoolEffect.Update();
         this.RenderingPerform();
      }
      
      public function get Pool() : TPoolEffect
      {
         return this.FPoolEffect;
      }
      
      public function get LayerBase() : TEffectLayer
      {
         return this.FLayerBase;
      }
   }
}

