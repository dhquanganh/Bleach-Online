package Processors.Game.Lobby.Common.Map.MapLoader
{
   import Foundation.Registries.TRegistryInstance;
   import Foundation.Resources.Maps.TMaps;
   import Foundation.Resources.SResourcesCore;
   import Logics.Map.TMapData;
   
   public class TMapLoaderData implements IMapLoader
   {
      
      protected var FRequestMapsID:Vector.<uint>;
      
      protected var FCallBacks:Vector.<Function>;
      
      protected var FMapList:TRegistryInstance;
      
      public function TMapLoaderData()
      {
         super();
         this.FRequestMapsID = new Vector.<uint>();
         this.FCallBacks = new Vector.<Function>();
         this.FMapList = new TRegistryInstance();
      }
      
      protected function Load_Perform(param1:int, param2:Function) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.CheckLib(param1,param2);
         if(_loc3_)
         {
            return true;
         }
         _loc4_ = this.FRequestMapsID.indexOf(param1);
         _loc5_ = this.FCallBacks.indexOf(param2);
         if(_loc4_ == _loc5_ && _loc4_ >= 0)
         {
            return false;
         }
         this.FRequestMapsID.push(param1);
         this.FCallBacks.push(param2);
         SResourcesCore.ResourceMap.LoadSecondary(param1);
         this.Update();
         return false;
      }
      
      protected function Update_PerForm() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TMaps = null;
         var _loc3_:TMapData = null;
         var _loc4_:Function = null;
         var _loc5_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FRequestMapsID.length)
         {
            _loc5_ = this.FRequestMapsID[_loc1_];
            _loc2_ = SResourcesCore.ResourceMap.GetMapsByResourceID(_loc5_);
            if(_loc2_ != null)
            {
               _loc3_ = this.CreateMapData(_loc2_,_loc5_);
               _loc4_ = this.FCallBacks[_loc1_];
               _loc4_(_loc3_);
               this.FMapList.Register(this.FRequestMapsID[_loc1_],_loc3_);
               this.FRequestMapsID.splice(_loc1_,1);
               this.FCallBacks.splice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      protected function CreateMapData(param1:TMaps, param2:uint) : TMapData
      {
         var _loc3_:TMapData = null;
         var _loc4_:int = 0;
         _loc3_ = new TMapData();
         _loc3_.ViewTileWidth = param1.CellWidth;
         _loc3_.ViewTileHeight = param1.CellHeight;
         _loc3_.MapWidth = param1.Width;
         _loc3_.MapHeight = param1.Height;
         _loc3_.PathTileWidth = param1.TileWidth;
         _loc3_.PathTileHeight = param1.TileHeight;
         _loc3_.PathTile_NumLine = param1.Columns;
         _loc3_.PathTile_NumRow = param1.Rows;
         _loc3_.BirthPlace_X = param1.StartPointX;
         _loc3_.BirthPlace_Y = param1.StartPointY;
         _loc3_.BirthPlace_X = 1118;
         _loc3_.BirthPlace_Y = 984;
         _loc3_.ViewTile_NumLine = Math.ceil(_loc3_.MapHeight / _loc3_.ViewTileHeight);
         _loc3_.ViewTile_NumRow = Math.ceil(_loc3_.MapWidth / _loc3_.ViewTileWidth);
         _loc3_.PathTileData.length = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.MapData.length)
         {
            _loc3_.PathTileData.push(parseInt(param1.MapData[_loc4_]));
            _loc4_++;
         }
         _loc3_.MapID = param2;
         return _loc3_;
      }
      
      protected function CheckLib(param1:int, param2:Function) : Boolean
      {
         var _loc3_:TMapData = null;
         _loc3_ = this.FMapList.GetInstanceByIdentifier(param1) as TMapData;
         if(_loc3_ != null)
         {
            param2(_loc3_);
            return true;
         }
         return false;
      }
      
      public function Load(param1:int, param2:Function) : Boolean
      {
         return this.Load_Perform(param1,param2);
      }
      
      public function Update() : void
      {
         this.Update_PerForm();
      }
   }
}

