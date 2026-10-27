package Processors.Game.Lobby.Common.Map.SearchWay
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMapData;
   import Resources.Constants.CONST_MAP;
   import flash.utils.*;
   
   public class TSearchWayAStar
   {
      
      protected static const MAXSIZE:int = 1024 * 1024 * 2;
      
      protected static const COST_Straight:int = 10;
      
      protected static const COST_Diagonal:int = 14;
      
      protected static const IndexState:int = 0;
      
      protected static const IndexID:int = 1;
      
      protected static const Mode_Adjust:int = 0;
      
      protected static const Mode_Search:int = 1;
      
      protected static const MaxNeighboorNum:int = 8;
      
      protected static const Extend_Direction:Vector.<int> = Vector.<int>([-1,0,-1,1,0,1,1,1,1,0,1,-1,0,-1,-1,-1]);
      
      protected var FMapTileInfor:Vector.<int>;
      
      protected var FState_OpenList:int;
      
      protected var FState_CloseList:int;
      
      protected var FFatherRecord:Vector.<int>;
      
      protected var FData_G:Vector.<int>;
      
      protected var FData_F:Vector.<int>;
      
      protected var FCell_Line:Vector.<int>;
      
      protected var FCell_Row:Vector.<int>;
      
      protected var FIndexInOpenList:Vector.<int>;
      
      protected var FOpenList:Vector.<int>;
      
      protected var FOpenListLength:int;
      
      protected var FCurrentID:int;
      
      protected var FMapPathData:TMapData;
      
      protected var FNeighbors:Vector.<Vector.<int>>;
      
      protected var FNeighborsFlag:Vector.<Boolean>;
      
      protected var FAdjustVec:Vector.<int>;
      
      protected var FTargetCoordinate:TCoordinate;
      
      protected var FResourceCoordinate:TCoordinate;
      
      protected var FLineCheck:TLineCheck;
      
      public function TSearchWayAStar()
      {
         var _loc1_:int = 0;
         super();
         this.FMapTileInfor = new Vector.<int>(MAXSIZE);
         this.FOpenList = new Vector.<int>();
         this.FOpenListLength = 0;
         this.FNeighborsFlag = new Vector.<Boolean>(8);
         this.FNeighbors = new Vector.<Vector.<int>>(8);
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            this.FNeighbors[_loc1_] = new Vector.<int>(2);
            _loc1_++;
         }
         this.FAdjustVec = new Vector.<int>();
         this.FFatherRecord = new Vector.<int>();
         this.FData_G = new Vector.<int>();
         this.FData_F = new Vector.<int>();
         this.FCell_Line = new Vector.<int>();
         this.FCell_Row = new Vector.<int>();
         this.FIndexInOpenList = new Vector.<int>();
         this.FTargetCoordinate = new TCoordinate();
         this.FResourceCoordinate = new TCoordinate();
         this.FLineCheck = new TLineCheck();
      }
      
      protected function HeapSortByIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(param1 != 0)
         {
            _loc2_ = param1 - 1 >> 1;
            if(this.FData_F[this.FOpenList[_loc2_]] <= this.FData_F[this.FOpenList[param1]])
            {
               break;
            }
            _loc3_ = this.FOpenList[_loc2_];
            this.FOpenList[_loc2_] = this.FOpenList[param1];
            this.FOpenList[param1] = _loc3_;
            this.FIndexInOpenList[this.FOpenList[param1]] = param1;
            this.FIndexInOpenList[this.FOpenList[_loc2_]] = _loc2_;
            param1 = _loc2_;
         }
      }
      
      protected function HeapSortByPopHead() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.FOpenListLength == 0)
         {
            return;
         }
         this.FOpenList[0] = this.FOpenList[this.FOpenListLength - 1];
         --this.FOpenListLength;
         _loc1_ = 0;
         while(true)
         {
            _loc3_ = _loc1_;
            _loc4_ = (_loc1_ << 1) + 1;
            _loc5_ = (_loc1_ << 1) + 2;
            if(_loc4_ < this.FOpenListLength)
            {
               if(this.FData_F[this.FOpenList[_loc4_]] < this.FData_F[this.FOpenList[_loc3_]])
               {
                  _loc3_ = _loc4_;
               }
            }
            if(_loc5_ < this.FOpenListLength)
            {
               if(this.FData_F[this.FOpenList[_loc5_]] < this.FData_F[this.FOpenList[_loc3_]])
               {
                  _loc3_ = _loc5_;
               }
            }
            if(_loc3_ == _loc1_)
            {
               break;
            }
            _loc2_ = this.FOpenList[_loc3_];
            this.FOpenList[_loc3_] = this.FOpenList[_loc1_];
            this.FOpenList[_loc1_] = _loc2_;
            this.FIndexInOpenList[this.FOpenList[_loc3_]] = _loc3_;
            this.FIndexInOpenList[this.FOpenList[_loc1_]] = _loc1_;
            _loc1_ = _loc3_;
         }
      }
      
      public function AddInOpenList(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.FOpenList[this.FOpenListLength] = this.FCurrentID;
         this.FCell_Line[this.FCurrentID] = param1;
         this.FCell_Row[this.FCurrentID] = param2;
         this.FData_G[this.FCurrentID] = param3;
         this.FData_F[this.FCurrentID] = param4;
         this.FFatherRecord[this.FCurrentID] = param5;
         this.FIndexInOpenList[this.FCurrentID] = this.FOpenListLength;
         this.HeapSortByIndex(this.FOpenListLength);
         ++this.FOpenListLength;
         ++this.FCurrentID;
      }
      
      public function GetHeapTop() : int
      {
         var _loc1_:int = 0;
         _loc1_ = this.FOpenList[0];
         this.HeapSortByPopHead();
         return _loc1_;
      }
      
      protected function Travese(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
      }
      
      protected function Init() : void
      {
         var _loc1_:int = 0;
         this.FState_CloseList += 2;
         this.FState_OpenList = this.FState_CloseList + 1;
         this.FOpenListLength = 0;
         this.FCurrentID = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FNeighborsFlag.length)
         {
            this.FNeighborsFlag[_loc1_] = false;
            _loc1_++;
         }
      }
      
      protected function Search(param1:int, param2:int, param3:int, param4:int, param5:Vector.<int>) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this.Init();
         this.AddInOpenList(param1,param2,0,0,-1);
         while(this.FOpenListLength != 0)
         {
            _loc8_ = this.GetHeapTop();
            this.SetTileInfor(this.FCell_Line[_loc8_],this.FCell_Row[_loc8_],this.FState_CloseList,_loc8_);
            if(this.FCell_Line[_loc8_] == param3 && this.FCell_Row[_loc8_] == param4)
            {
               this.GetPath(_loc8_,param5);
               return;
            }
            this.GetNeighbour(this.FCell_Line[_loc8_],this.FCell_Row[_loc8_],Mode_Search);
            _loc6_ = 0;
            while(_loc6_ < 8)
            {
               if(this.FNeighborsFlag[_loc6_])
               {
                  if(this.FNeighbors[_loc6_][0] == this.FCell_Line[_loc8_] || this.FNeighbors[_loc6_][1] == this.FCell_Row[_loc8_])
                  {
                     _loc9_ = COST_Straight + this.FData_G[_loc8_];
                  }
                  else
                  {
                     _loc9_ = COST_Diagonal + this.FData_G[_loc8_];
                  }
                  _loc10_ = _loc9_ + (Math.abs(param3 - this.FNeighbors[_loc6_][0]) + Math.abs(param4 - this.FNeighbors[_loc6_][1])) * COST_Straight;
                  _loc7_ = (this.FNeighbors[_loc6_][0] << 11) + (this.FNeighbors[_loc6_][1] << 1);
                  _loc11_ = this.FMapTileInfor[_loc7_ + IndexState];
                  if(_loc11_ == this.FState_OpenList)
                  {
                     _loc7_ = this.FMapTileInfor[_loc7_ + IndexID];
                     if(this.FData_G[_loc7_] > _loc9_)
                     {
                        this.FData_F[_loc7_] = _loc10_;
                        this.FData_G[_loc7_] = _loc9_;
                        this.FFatherRecord[_loc7_] = _loc8_;
                        this.HeapSortByIndex(this.FIndexInOpenList[_loc7_]);
                     }
                  }
                  else
                  {
                     this.SetTileInfor(this.FNeighbors[_loc6_][0],this.FNeighbors[_loc6_][1],this.FState_OpenList,this.FCurrentID);
                     this.AddInOpenList(this.FNeighbors[_loc6_][0],this.FNeighbors[_loc6_][1],_loc9_,_loc10_,_loc8_);
                  }
               }
               _loc6_++;
            }
         }
      }
      
      protected function GetNeighbour(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         _loc4_ = this.FMapPathData.PathTile_NumLine - 1;
         _loc5_ = this.FMapPathData.PathTile_NumRow - 1;
         _loc11_ = Extend_Direction.length / 2;
         _loc8_ = 0;
         while(_loc8_ < _loc11_)
         {
            _loc6_ = param1 + Extend_Direction[_loc8_ << 1];
            _loc7_ = param2 + Extend_Direction[(_loc8_ << 1) + 1];
            if(_loc6_ > _loc4_ || _loc6_ < 0 || _loc7_ > _loc5_ || _loc7_ < 0)
            {
               this.FNeighborsFlag[_loc8_] = false;
            }
            else
            {
               this.FNeighborsFlag[_loc8_] = true;
               this.FNeighbors[_loc8_][0] = _loc6_;
               this.FNeighbors[_loc8_][1] = _loc7_;
            }
            _loc8_++;
         }
         if(param3 == Mode_Search)
         {
            _loc8_ = 0;
            while(_loc8_ < 4)
            {
               _loc9_ = _loc8_ * 2 + 1;
               if(this.FNeighborsFlag[_loc9_])
               {
                  _loc6_ = this.FNeighbors[_loc9_ - 1][0];
                  _loc7_ = this.FNeighbors[_loc9_ - 1][1];
                  _loc10_ = _loc6_ * this.FMapPathData.PathTile_NumRow + _loc7_;
                  if(this.FMapPathData.PathTileData[_loc10_] == CONST_MAP.FLAG_PATHTILE_WALL)
                  {
                     this.FNeighborsFlag[_loc9_] = false;
                  }
                  else
                  {
                     _loc6_ = this.FNeighbors[(_loc9_ + 1) % _loc11_][0];
                     _loc7_ = this.FNeighbors[(_loc9_ + 1) % _loc11_][1];
                     _loc10_ = _loc6_ * this.FMapPathData.PathTile_NumRow + _loc7_;
                     if(this.FMapPathData.PathTileData[_loc10_] == CONST_MAP.FLAG_PATHTILE_WALL)
                     {
                        this.FNeighborsFlag[_loc9_] = false;
                     }
                  }
               }
               _loc8_++;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc11_)
            {
               if(this.FNeighborsFlag[_loc8_])
               {
                  _loc6_ = this.FNeighbors[_loc8_][0];
                  _loc7_ = this.FNeighbors[_loc8_][1];
                  _loc10_ = _loc6_ * this.FMapPathData.PathTile_NumRow + _loc7_;
                  if(this.FMapPathData.PathTileData[_loc10_] == CONST_MAP.FLAG_PATHTILE_WALL)
                  {
                     this.FNeighborsFlag[_loc8_] = false;
                  }
                  else
                  {
                     _loc10_ = (_loc6_ << 11) + (_loc7_ << 1) + IndexState;
                     if(this.FMapTileInfor[_loc10_] == this.FState_CloseList)
                     {
                        this.FNeighborsFlag[_loc8_] = false;
                     }
                  }
               }
               _loc8_++;
            }
         }
      }
      
      public function AdjustTarget(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         _loc5_ = param3 * this.FMapPathData.PathTile_NumRow + param4;
         _loc9_ = param3;
         _loc10_ = param4;
         _loc11_ = false;
         while(this.FMapPathData.PathTileData[_loc5_] == CONST_MAP.FLAG_PATHTILE_WALL)
         {
            this.GetNeighbour(_loc9_,_loc10_,Mode_Adjust);
            _loc8_ = -1;
            _loc6_ = 0;
            while(_loc6_ < MaxNeighboorNum)
            {
               if(this.FNeighborsFlag[_loc6_])
               {
                  _loc7_ = Math.abs(param1 - this.FNeighbors[_loc6_][0]) + Math.abs(param2 - this.FNeighbors[_loc6_][1]);
                  if(_loc8_ == -1 || _loc8_ > _loc7_)
                  {
                     _loc8_ = _loc7_;
                     _loc9_ = this.FNeighbors[_loc6_][0];
                     _loc10_ = this.FNeighbors[_loc6_][1];
                  }
               }
               _loc6_++;
            }
            _loc5_ = _loc9_ * this.FMapPathData.PathTile_NumRow + _loc10_;
            _loc11_ = true;
         }
         this.FAdjustVec[0] = _loc9_;
         this.FAdjustVec[1] = _loc10_;
         if(_loc11_)
         {
            this.FTargetCoordinate.X = _loc10_ * this.FMapPathData.PathTileWidth + this.FMapPathData.PathTileWidth / 2;
            this.FTargetCoordinate.Y = _loc9_ * this.FMapPathData.PathTileHeight + this.FMapPathData.PathTileHeight / 2;
            if(_loc9_ == param1 && _loc10_ == param2)
            {
               this.FTargetCoordinate.Assign(this.FResourceCoordinate);
            }
         }
      }
      
      protected function SetTileInfor(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         _loc5_ = (param1 << 11) + (param2 << 1);
         this.FMapTileInfor[_loc5_ + IndexState] = param3;
         this.FMapTileInfor[_loc5_ + IndexID] = param4;
      }
      
      protected function GetPath(param1:int, param2:Vector.<int>) : void
      {
         param2.push(this.FTargetCoordinate.X,this.FTargetCoordinate.Y);
         param1 = this.FFatherRecord[param1];
         while(param1 != -1)
         {
            param2.splice(0,0,this.FCell_Row[param1] * this.FMapPathData.PathTileWidth + this.FMapPathData.PathTileWidth / 2,this.FCell_Line[param1] * this.FMapPathData.PathTileHeight + this.FMapPathData.PathTileHeight / 2);
            param1 = this.FFatherRecord[param1];
         }
         param2.splice(0,2);
      }
      
      public function set MapPathData(param1:TMapData) : void
      {
         this.FMapPathData = param1;
         this.FLineCheck.MapData = param1;
      }
      
      public function SearchWay(param1:int, param2:int, param3:int, param4:int, param5:Vector.<int>) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         if(param3 < 0 || param3 >= this.FMapPathData.MapWidth || param4 < 0 || param4 >= this.FMapPathData.MapHeight)
         {
            return;
         }
         this.FResourceCoordinate.X = param1;
         this.FResourceCoordinate.Y = param2;
         this.FTargetCoordinate.X = param3;
         this.FTargetCoordinate.Y = param4;
         _loc6_ = param2 / this.FMapPathData.PathTileHeight;
         _loc7_ = param1 / this.FMapPathData.PathTileWidth;
         _loc8_ = param4 / this.FMapPathData.PathTileHeight;
         _loc9_ = param3 / this.FMapPathData.PathTileWidth;
         this.AdjustTarget(_loc6_,_loc7_,_loc8_,_loc9_);
         _loc8_ = this.FAdjustVec[0];
         _loc9_ = this.FAdjustVec[1];
         _loc10_ = this.FLineCheck.CheckLineIfUnblocked(this.FResourceCoordinate,this.FTargetCoordinate);
         if(_loc10_)
         {
            if(this.FResourceCoordinate.X == this.FTargetCoordinate.X && this.FResourceCoordinate.Y == this.FTargetCoordinate.Y)
            {
               return;
            }
            param5.push(this.FTargetCoordinate.X,this.FTargetCoordinate.Y);
            return;
         }
         this.Search(_loc6_,_loc7_,_loc8_,_loc9_,param5);
      }
   }
}

