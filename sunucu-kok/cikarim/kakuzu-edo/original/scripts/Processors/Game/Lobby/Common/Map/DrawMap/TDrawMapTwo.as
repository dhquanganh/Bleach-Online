package Processors.Game.Lobby.Common.Map.DrawMap
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Map.TMapData;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TDrawMapTwo extends TUIComponent
   {
      
      public static const MapMaxWidth:int = 2500;
      
      public static const MapMaxHeight:int = 1828;
      
      protected static const STATE_MAPDATALOADING:int = 1;
      
      protected static const STATE_MICROPICLOADING:int = 2;
      
      protected static const STATE_RUNING:int = 3;
      
      protected static const BGSmallWidthToBGBigWidth:Number = 0.1;
      
      protected var FMapData:TMapData;
      
      protected var FBitMapView:Bitmap;
      
      protected var FGraphics:BitmapData;
      
      protected var FMapPixelBuffer:BitmapData;
      
      protected var FCurrentState:int;
      
      protected var FRectangleTool:Rectangle;
      
      protected var FPointTool:Point;
      
      protected var FMatrix:Matrix;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FMapRectangleRecord:Rectangle;
      
      protected var FBoundsTool:TBounds;
      
      protected var FStopDraw:Boolean;
      
      public function TDrawMapTwo(param1:TUIComponent)
      {
         super(param1);
         this.CreateComponent();
         this.FCurrentState = 0;
      }
      
      protected function CreateComponent() : void
      {
         this.FGraphics = SUtilityResource.BtmDataView;
         this.FBitMapView = new Bitmap(this.FGraphics);
         addChild(this.FBitMapView);
         this.FMapPixelBuffer = SUtilityResource.BtmDataBuffer;
         this.FRectangleTool = new Rectangle();
         this.FPointTool = new Point();
         this.FMatrix = new Matrix();
         this.FMatrix.scale(1 / BGSmallWidthToBGBigWidth,1 / BGSmallWidthToBGBigWidth);
         this.FMapRectangleRecord = new Rectangle();
         this.FBoundsTool = new TBounds();
         this.FCoordinate = new TCoordinate();
      }
      
      protected function LoadMapTilePic() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FMapData.ViewTile_NumLine)
         {
            _loc2_ = 0;
            while(_loc2_ < this.FMapData.ViewTile_NumRow)
            {
               _loc3_ = this.CounterSourceIDByCellCoordinate(_loc1_,_loc2_);
               SResourcesCore.TexturesMap.LoadAutoSecondary(_loc3_,this.TilePicArrive);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      protected function SetScreenShowArea_Perform(param1:TBounds) : void
      {
         this.FPointTool.x = 0;
         this.FPointTool.y = 0;
         this.FMapRectangleRecord.x = param1.X;
         this.FMapRectangleRecord.y = param1.Y;
         this.FMapRectangleRecord.width = param1.Width;
         this.FMapRectangleRecord.height = param1.Height;
         this.FGraphics.lock();
         this.FGraphics.copyPixels(this.FMapPixelBuffer,this.FMapRectangleRecord,this.FPointTool);
         this.FGraphics.unlock();
      }
      
      protected function CounterSourceIDByCellCoordinate(param1:int, param2:int) : uint
      {
         return this.FMapData.MapID << 16 | param2 << 8 | param1;
      }
      
      protected function CounterMapIDBySourceID(param1:uint) : uint
      {
         return param1 >> 16;
      }
      
      protected function CounterCellCoordinateBySourceID(param1:int, param2:TCoordinate) : void
      {
         param2.X = (param1 & 0xFFFF) >> 8;
         param2.Y = param1 & 0xFF;
      }
      
      protected function MicroPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         this.FMapPixelBuffer.draw(_loc4_,this.FMatrix);
         this.FCurrentState = STATE_RUNING;
         this.LoadMapTilePic();
         this.FMapData.PicLoaded = true;
         this.FBoundsTool.X = this.FMapRectangleRecord.x;
         this.FBoundsTool.Y = this.FMapRectangleRecord.y;
         this.FBoundsTool.Width = this.FMapRectangleRecord.width;
         this.FBoundsTool.Height = this.FMapRectangleRecord.height;
         this.SetScreenShowArea_Perform(this.FBoundsTool);
      }
      
      protected function TilePicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:uint = 0;
         _loc5_ = this.CounterMapIDBySourceID(param3);
         if(this.FStopDraw || _loc5_ != this.FMapData.MapID)
         {
            return;
         }
         _loc4_ = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         this.CounterCellCoordinateBySourceID(param3,this.FCoordinate);
         this.FRectangleTool.width = _loc4_.width;
         this.FRectangleTool.height = _loc4_.height;
         this.FPointTool.x = this.FCoordinate.X * this.FMapData.ViewTileWidth;
         this.FPointTool.y = this.FCoordinate.Y * this.FMapData.ViewTileHeight;
         this.FMapPixelBuffer.lock();
         this.FMapPixelBuffer.copyPixels(_loc4_,this.FRectangleTool,this.FPointTool,null,null,true);
         this.FMapPixelBuffer.unlock();
         if(this.FRectangleTool.x != -1)
         {
            this.FPointTool.x = this.FCoordinate.X * this.FMapData.ViewTileWidth - this.FMapRectangleRecord.x;
            this.FPointTool.y = this.FCoordinate.Y * this.FMapData.ViewTileHeight - this.FMapRectangleRecord.y;
            this.FGraphics.lock();
            this.FGraphics.copyPixels(_loc4_,this.FRectangleTool,this.FPointTool,null,null,true);
            this.FGraphics.unlock();
         }
      }
      
      public function ChangeMap(param1:TMapData) : void
      {
         this.FCurrentState = STATE_MICROPICLOADING;
         this.FRectangleTool.width = this.FGraphics.width;
         this.FRectangleTool.height = this.FGraphics.height;
         this.FGraphics.fillRect(this.FRectangleTool,16777215);
         this.FMapData = param1;
         SResourcesCore.TexturesPreview.LoadAutoSecondary(this.FMapData.MapID,this.MicroPicArrive);
         this.FMapRectangleRecord.x = -1;
         this.FMapRectangleRecord.y = -1;
         this.FStopDraw = false;
      }
      
      public function SetScreenShowArea(param1:TBounds) : void
      {
         if(this.FMapRectangleRecord.x == param1.X && this.FMapRectangleRecord.y == param1.Y)
         {
            return;
         }
         this.SetScreenShowArea_Perform(param1);
      }
      
      public function StopDraw() : void
      {
         this.FStopDraw = true;
      }
   }
}

