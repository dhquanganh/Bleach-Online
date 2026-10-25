package Processors.Game.Lobby.Components
{
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_CHARACTER;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class TUIHero extends TUIComponent
   {
      
      public static const STATUS_Stand:int = CONST_CHARACTER.STATUS_Stand;
      
      protected var FTickReference:int;
      
      protected var FSequenceContext:TAnimationSequence;
      
      protected var FBitmap:Bitmap;
      
      protected var FTexture:TTexture;
      
      protected var FContext:Object;
      
      protected var FSequenceDefaultRole:TAnimationSequence;
      
      protected var FQuerySequence:TQueryAnimationSequence;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIHero(param1:TUIComponent)
      {
         super(param1);
         this.FBitmap = new Bitmap();
         addChild(this.FBitmap);
         this.FQuerySequence = new TQueryAnimationSequence();
      }
      
      protected function RenderingPerform() : void
      {
         if(this.Context != null)
         {
            this.RenderingPerform_Context();
         }
      }
      
      protected function RenderingPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAnimationFrame = null;
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         if(this.FContext == null)
         {
            return;
         }
         if(this.FSequenceContext == null)
         {
            if(this.FOnQuerySequenceContext != null)
            {
               this.FQuerySequence.Value = null;
               this.FOnQuerySequenceContext(this,this.FContext,this.FQuerySequence);
               this.FSequenceContext = this.FQuerySequence.Value;
            }
         }
         _loc1_ = int(STimingCore.TickCount);
         if(this.FSequenceContext != null)
         {
            _loc2_ = this.FSequenceContext.GetAnimationFrameByTick(_loc1_);
         }
         if(_loc2_ == null)
         {
            if(this.FSequenceDefaultRole != null)
            {
               _loc2_ = this.FSequenceDefaultRole.GetAnimationFrameByTick(_loc1_);
            }
         }
         if(_loc2_ != null)
         {
            _loc3_ = this.FBitmap.bitmapData;
            _loc4_ = _loc2_.Surface;
            if(_loc3_ != _loc4_)
            {
               this.FBitmap.bitmapData = _loc4_;
            }
         }
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         if(param1 != this.FContext)
         {
            this.FSequenceContext = null;
            this.FBitmap.bitmapData = null;
            this.FContext = param1;
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get SequenceDefaultRole() : TAnimationSequence
      {
         return this.FSequenceDefaultRole;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FSequenceDefaultRole = param1;
         }
      }
      
      override public function Dispose() : void
      {
         this.FContext = null;
         this.FSequenceDefaultRole = null;
         this.FQuerySequence = null;
         this.FSequenceContext = null;
         this.FTexture = null;
         this.FOnQuerySequenceContext = null;
         if(this.FBitmap.bitmapData != null)
         {
            this.FBitmap.bitmapData = null;
         }
         if(this.FBitmap.parent != null)
         {
            this.FBitmap.parent.removeChild(this.FBitmap);
         }
         this.FBitmap = null;
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function Update() : void
      {
         this.RenderingPerform();
      }
   }
}

