package Processors.Game.Utilities.Common
{
   import Foundation.Utilities.TUtilityReflection;
   import Resources.Constants.CONST_COMMON;
   import flash.display.BitmapData;
   
   public class TUtilityResource
   {
      
      protected static var STAGE_Width:uint = CONST_COMMON.STAGE_Width;
      
      protected static var STAGE_Height:uint = CONST_COMMON.STAGE_Height;
      
      protected static const SIZE_MapMaxWidth:int = 2500;
      
      protected static const SIZE_MapMaxHeight:int = 1828;
      
      protected var FBtmDataFullScreen:BitmapData;
      
      protected var FBtmDataTipsBG:BitmapData;
      
      protected var FBtmDataDividingLine:BitmapData;
      
      protected var FBtmDataShortcutPopupBG:BitmapData;
      
      protected var FBtmDataView:BitmapData;
      
      protected var FBtmDataBuffer:BitmapData;
      
      public function TUtilityResource()
      {
         super();
         this.FBtmDataFullScreen = new BitmapData(STAGE_Width,STAGE_Height,true,2147483648);
         this.FBtmDataTipsBG = TUtilityReflection.CreateBitmapDataByDisplayObject(CONST_COMMON.RESOURCE_ClassName_MC_HitTexture);
         this.FBtmDataShortcutPopupBG = TUtilityReflection.CreateBitmapDataByDisplayObject(CONST_COMMON.RESOURCE_ClassName_MC_ShortcutPopupTexture);
         this.FBtmDataDividingLine = TUtilityReflection.CreateBitmapDataByDisplayObject(CONST_COMMON.RESOURCE_ClassName_MC_DividingLine);
         this.FBtmDataView = new BitmapData(STAGE_Width,STAGE_Height,true,16711680);
         this.FBtmDataBuffer = new BitmapData(SIZE_MapMaxWidth,SIZE_MapMaxHeight,true,16711680);
      }
      
      public function get BtmDataFullScreen() : BitmapData
      {
         return this.FBtmDataFullScreen;
      }
      
      public function get BtmDataTipsBG() : BitmapData
      {
         return this.FBtmDataTipsBG;
      }
      
      public function get BtmDataShortcutPopupBG() : BitmapData
      {
         return this.FBtmDataShortcutPopupBG;
      }
      
      public function get BtmDataDividingLine() : BitmapData
      {
         return this.FBtmDataDividingLine;
      }
      
      public function get BtmDataView() : BitmapData
      {
         return this.FBtmDataView;
      }
      
      public function get BtmDataBuffer() : BitmapData
      {
         return this.FBtmDataBuffer;
      }
   }
}

