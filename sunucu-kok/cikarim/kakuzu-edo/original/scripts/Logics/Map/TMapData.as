package Logics.Map
{
   public class TMapData
   {
      
      protected var FMapID:uint;
      
      protected var FPathTileData:Vector.<int>;
      
      protected var FPathTileWidth:int;
      
      protected var FPathTileHeight:int;
      
      protected var FPathTile_NumLine:int;
      
      protected var FPathTile_NumRow:int;
      
      protected var FViewTileLoadInfor:Vector.<int>;
      
      protected var FPicLoaded:Boolean;
      
      protected var FViewTileWidth:int;
      
      protected var FViewTileHeight:int;
      
      protected var FViewTile_NumLine:int;
      
      protected var FViewTile_NumRow:int;
      
      protected var FBirthPlace_X:int;
      
      protected var FBirthPlace_Y:int;
      
      protected var FMapWidth:int;
      
      protected var FMapHeight:int;
      
      public function TMapData()
      {
         super();
         this.FPathTileData = new Vector.<int>();
      }
      
      protected function CreatePathTileLoadData() : void
      {
         if(this.FPathTile_NumLine != 0 && this.FPathTile_NumRow != 0)
         {
            this.FViewTileLoadInfor = new Vector.<int>(this.FPathTile_NumLine * this.FPathTile_NumRow);
         }
      }
      
      public function get PathTileData() : Vector.<int>
      {
         return this.FPathTileData;
      }
      
      public function set PathTileData(param1:Vector.<int>) : void
      {
         this.FPathTileData = param1;
      }
      
      public function get PathTileWidth() : int
      {
         return this.FPathTileWidth;
      }
      
      public function set PathTileWidth(param1:int) : void
      {
         this.FPathTileWidth = param1;
      }
      
      public function get PathTileHeight() : int
      {
         return this.FPathTileHeight;
      }
      
      public function set PathTileHeight(param1:int) : void
      {
         this.FPathTileHeight = param1;
      }
      
      public function get PathTile_NumLine() : int
      {
         return this.FPathTile_NumLine;
      }
      
      public function set PathTile_NumLine(param1:int) : void
      {
         this.FPathTile_NumLine = param1;
         this.CreatePathTileLoadData();
      }
      
      public function get PathTile_NumRow() : int
      {
         return this.FPathTile_NumRow;
      }
      
      public function set PathTile_NumRow(param1:int) : void
      {
         this.FPathTile_NumRow = param1;
         this.CreatePathTileLoadData();
      }
      
      public function get ViewTileLoadInfor() : Vector.<int>
      {
         return this.FViewTileLoadInfor;
      }
      
      public function set ViewTileLoadInfor(param1:Vector.<int>) : void
      {
         this.FViewTileLoadInfor = param1;
      }
      
      public function get ViewTileWidth() : int
      {
         return this.FViewTileWidth;
      }
      
      public function set ViewTileWidth(param1:int) : void
      {
         this.FViewTileWidth = param1;
      }
      
      public function get ViewTileHeight() : int
      {
         return this.FViewTileHeight;
      }
      
      public function set ViewTileHeight(param1:int) : void
      {
         this.FViewTileHeight = param1;
      }
      
      public function get ViewTile_NumLine() : int
      {
         return this.FViewTile_NumLine;
      }
      
      public function set ViewTile_NumLine(param1:int) : void
      {
         this.FViewTile_NumLine = param1;
      }
      
      public function get ViewTile_NumRow() : int
      {
         return this.FViewTile_NumRow;
      }
      
      public function set ViewTile_NumRow(param1:int) : void
      {
         this.FViewTile_NumRow = param1;
      }
      
      public function get BirthPlace_X() : int
      {
         return this.FBirthPlace_X;
      }
      
      public function set BirthPlace_X(param1:int) : void
      {
         this.FBirthPlace_X = param1;
      }
      
      public function get BirthPlace_Y() : int
      {
         return this.FBirthPlace_Y;
      }
      
      public function set BirthPlace_Y(param1:int) : void
      {
         this.FBirthPlace_Y = param1;
      }
      
      public function get MapWidth() : int
      {
         return this.FMapWidth;
      }
      
      public function set MapWidth(param1:int) : void
      {
         this.FMapWidth = param1;
      }
      
      public function get MapHeight() : int
      {
         return this.FMapHeight;
      }
      
      public function set MapHeight(param1:int) : void
      {
         this.FMapHeight = param1;
      }
      
      public function get MapID() : uint
      {
         return this.FMapID;
      }
      
      public function set MapID(param1:uint) : void
      {
         this.FMapID = param1;
      }
      
      public function get PicLoaded() : Boolean
      {
         return this.FPicLoaded;
      }
      
      public function set PicLoaded(param1:Boolean) : void
      {
         this.FPicLoaded = param1;
      }
      
      protected function ClearTileLoadInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FViewTileLoadInfor[_loc1_] = 0;
            _loc1_++;
         }
      }
   }
}

