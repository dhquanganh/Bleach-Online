package Foundation.Resources.Maps
{
   import Foundation.Resources.Common.TResource;
   
   public class TMaps extends TResource
   {
      
      protected var FName:String;
      
      protected var FMode:int;
      
      protected var FType:int;
      
      protected var FWidth:int;
      
      protected var FHeight:int;
      
      protected var FCellWidth:int;
      
      protected var FCellHeight:int;
      
      protected var FTileWidth:int;
      
      protected var FTileHeight:int;
      
      protected var FPreRows:int;
      
      protected var FPreColumns:int;
      
      protected var FRows:int;
      
      protected var FColumns:int;
      
      protected var FStartPointX:int;
      
      protected var FStartPointY:int;
      
      protected var FMapData:Array;
      
      public function TMaps(param1:uint)
      {
         super(param1);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Mode() : int
      {
         return this.FMode;
      }
      
      public function set Mode(param1:int) : void
      {
         this.FMode = param1;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get Width() : int
      {
         return this.FWidth;
      }
      
      public function set Width(param1:int) : void
      {
         this.FWidth = param1;
      }
      
      public function get Height() : int
      {
         return this.FHeight;
      }
      
      public function set Height(param1:int) : void
      {
         this.FHeight = param1;
      }
      
      public function get CellWidth() : int
      {
         return this.FCellWidth;
      }
      
      public function set CellWidth(param1:int) : void
      {
         this.FCellWidth = param1;
      }
      
      public function get CellHeight() : int
      {
         return this.FCellHeight;
      }
      
      public function set CellHeight(param1:int) : void
      {
         this.FCellHeight = param1;
      }
      
      public function get TileWidth() : int
      {
         return this.FTileWidth;
      }
      
      public function set TileWidth(param1:int) : void
      {
         this.FTileWidth = param1;
      }
      
      public function get TileHeight() : int
      {
         return this.FTileHeight;
      }
      
      public function set TileHeight(param1:int) : void
      {
         this.FTileHeight = param1;
      }
      
      public function get PreRows() : int
      {
         return this.FPreRows;
      }
      
      public function set PreRows(param1:int) : void
      {
         this.FPreRows = param1;
      }
      
      public function get PreColumns() : int
      {
         return this.FPreColumns;
      }
      
      public function set PreColumns(param1:int) : void
      {
         this.FPreColumns = param1;
      }
      
      public function get Rows() : int
      {
         return this.FRows;
      }
      
      public function set Rows(param1:int) : void
      {
         this.FRows = param1;
      }
      
      public function get Columns() : int
      {
         return this.FColumns;
      }
      
      public function set Columns(param1:int) : void
      {
         this.FColumns = param1;
      }
      
      public function get StartPointX() : int
      {
         return this.FStartPointX;
      }
      
      public function set StartPointX(param1:int) : void
      {
         this.FStartPointX = param1;
      }
      
      public function get StartPointY() : int
      {
         return this.FStartPointY;
      }
      
      public function set StartPointY(param1:int) : void
      {
         this.FStartPointY = param1;
      }
      
      public function get MapData() : Array
      {
         return this.FMapData;
      }
      
      public function set MapData(param1:Array) : void
      {
         this.FMapData = param1;
      }
   }
}

