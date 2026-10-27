package Foundation.UI
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.Spaces.UISpace;
   import Resources.Constants.CONST_CURSOR;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.Bitmap;
   import flash.display.Stage;
   
   use namespace UISpace;
   
   public class TUIRoot extends TUIComponent
   {
      
      public static const TEXTURESID_CURSOR:uint = CONST_LOBBY.RESOURCESID_Textures_CURSOR;
      
      protected var FBitmapCursor:Bitmap;
      
      protected var FQuerySequence:TQueryAnimationSequence;
      
      protected var FMountPointsRoleBounds:TBounds;
      
      protected var FMountPointsRolePivot:TCoordinate;
      
      protected var FCursor:uint;
      
      protected var FTimingReferenceTick:int;
      
      protected var FTimingReferenceTime:int;
      
      protected var FOnQuerySequenceCursor:Function;
      
      public function TUIRoot(param1:TUICore)
      {
         var _loc2_:Stage = null;
         super(null);
         FUICore = param1;
         this.FBitmapCursor = new Bitmap();
         this.FQuerySequence = new TQueryAnimationSequence();
         this.FMountPointsRoleBounds = new TBounds();
         this.FMountPointsRolePivot = new TCoordinate();
         _loc2_ = FUICore.UIStage;
         _loc2_.addChild(this);
      }
      
      UISpace function RenderingProcess() : void
      {
         this.RenderCursor();
      }
      
      protected function RenderCursor() : void
      {
         var _loc1_:TUIComponent = null;
         var _loc2_:TAnimationSequence = null;
         var _loc3_:TAnimationFrame = null;
         _loc1_ = FUICore.MouseCapturingComponent;
         if(_loc1_ == null)
         {
            this.FCursor = CONST_CURSOR.CURSORID_Default;
            if(this.FBitmapCursor.bitmapData != null)
            {
               this.FBitmapCursor.bitmapData = null;
            }
            if(this.FBitmapCursor.parent != null)
            {
               this.FBitmapCursor.parent.removeChild(this.FBitmapCursor);
               this.FTimingReferenceTick = 0;
               this.FTimingReferenceTime = 0;
            }
            return;
         }
         if(_loc1_.Cursor != this.FCursor)
         {
            this.FCursor = _loc1_.Cursor;
            this.FTimingReferenceTime = STimingCore.TickCount;
         }
         this.FQuerySequence.Value = null;
         if(this.FOnQuerySequenceCursor != null)
         {
            this.FOnQuerySequenceCursor(this,TEXTURESID_CURSOR,this.FCursor,this.FQuerySequence);
         }
         _loc2_ = this.FQuerySequence.Value;
         if(_loc2_ != null)
         {
            _loc2_.Evaluate(this.FMountPointsRolePivot,this.FMountPointsRoleBounds);
            this.FTimingReferenceTick = STimingCore.TickCount - this.FTimingReferenceTime;
            _loc3_ = _loc2_.GetAnimationFrameByTick(this.FTimingReferenceTick);
            if(_loc3_ != null)
            {
               if(this.FBitmapCursor.bitmapData != _loc3_.Surface)
               {
                  this.FBitmapCursor.bitmapData = _loc3_.Surface;
               }
               if(this.FBitmapCursor.parent == null)
               {
                  _loc1_.CursorDisplayObject.addChild(this.FBitmapCursor);
               }
            }
            this.FBitmapCursor.x = FUICore.MouseCoordinate.X + this.FMountPointsRoleBounds.X;
            this.FBitmapCursor.y = FUICore.MouseCoordinate.Y + this.FMountPointsRoleBounds.Y;
         }
      }
      
      public function get OnQuerySequenceCursor() : Function
      {
         return this.FOnQuerySequenceCursor;
      }
      
      public function set OnQuerySequenceCursor(param1:Function) : void
      {
         this.FOnQuerySequenceCursor = param1;
      }
      
      public function Render() : void
      {
         this.RenderingProcess();
      }
   }
}

