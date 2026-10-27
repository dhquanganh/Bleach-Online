package Processors.Game.Lobby.Common.Map.SearchWay
{
   import Foundation.Common.*;
   import Logics.Map.*;
   import Resources.Constants.*;
   
   public class TLineCheck
   {
      
      protected static const HORIZONTAL_MODE:int = 0;
      
      protected static const VERTICAL_MODE:int = 1;
      
      protected var FMapData:TMapData;
      
      protected var FValueK:Number;
      
      protected var FIntercept:Number;
      
      protected var FCurrentMode:int;
      
      protected var FCoordinateA:TCoordinate;
      
      protected var FCoordinateB:TCoordinate;
      
      protected var FResult:Vector.<int>;
      
      public function TLineCheck()
      {
         super();
         this.FResult = new Vector.<int>();
         this.FCoordinateA = new TCoordinate();
         this.FCoordinateB = new TCoordinate();
      }
      
      protected function CounterEquationValue(param1:int) : int
      {
         return this.FValueK * param1 + this.FIntercept;
      }
      
      protected function CounterLineParameter(param1:TCoordinate, param2:TCoordinate) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = Math.abs(param1.X - param2.X);
         _loc4_ = Math.abs(param1.Y - param2.Y);
         if(_loc3_ > _loc4_)
         {
            this.FValueK = (param1.Y - param2.Y) / (param1.X - param2.X);
            this.FIntercept = param1.Y - param1.X * this.FValueK;
            this.FCurrentMode = HORIZONTAL_MODE;
         }
         else
         {
            this.FValueK = (param1.X - param2.X) / (param1.Y - param2.Y);
            this.FIntercept = param1.X - param1.Y * this.FValueK;
            this.FCurrentMode = VERTICAL_MODE;
         }
      }
      
      protected function CheckIfBarrier(param1:TCoordinate) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = param1.Y / this.FMapData.PathTileHeight;
         _loc3_ = param1.X / this.FMapData.PathTileWidth;
         _loc4_ = param1.Y % this.FMapData.PathTileHeight;
         _loc5_ = param1.X % this.FMapData.PathTileWidth;
         this.FResult.length = 0;
         if(_loc5_ == 0 && _loc4_ == 0)
         {
            this.FResult[0] = (_loc2_ - 1) * this.FMapData.PathTile_NumRow + _loc3_ - 1;
            this.FResult[1] = (_loc2_ - 1) * this.FMapData.PathTile_NumRow + _loc3_;
            this.FResult[2] = _loc2_ * this.FMapData.PathTile_NumRow + _loc3_ - 1;
            this.FResult[3] = _loc2_ * this.FMapData.PathTile_NumRow + _loc3_;
         }
         else if(_loc5_ == 0)
         {
            this.FResult[0] = _loc2_ * this.FMapData.PathTile_NumRow + _loc3_ + 1;
            this.FResult[1] = _loc2_ * this.FMapData.PathTile_NumRow + _loc3_;
         }
         else if(_loc4_ == 0)
         {
            this.FResult[0] = (_loc2_ - 1) * this.FMapData.PathTile_NumRow + _loc3_;
            this.FResult[1] = _loc2_ * this.FMapData.PathTile_NumRow + _loc3_;
         }
         else
         {
            this.FResult[0] = _loc2_ * this.FMapData.PathTile_NumRow + _loc3_;
         }
         _loc6_ = 0;
         while(_loc6_ < this.FResult.length)
         {
            if(this.FMapData.PathTileData[this.FResult[_loc6_]] == CONST_MAP.FLAG_PATHTILE_WALL)
            {
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      protected function CheckIfInInterregional(param1:int, param2:int, param3:int) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         _loc4_ = param3 > param1 && param3 > param2;
         _loc5_ = param3 < param1 && param3 < param2;
         return !(_loc4_ || _loc5_);
      }
      
      protected function CheckLineIfUnblocked_Perform(param1:TCoordinate, param2:TCoordinate) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this.CounterLineParameter(param1,param2);
         _loc7_ = param2.Y / this.FMapData.PathTileHeight;
         _loc8_ = param2.X / this.FMapData.PathTileWidth;
         if(this.FCurrentMode == HORIZONTAL_MODE)
         {
            if(param1.X < param2.X)
            {
               _loc5_ = this.FMapData.PathTileWidth;
               _loc3_ = Math.ceil(param1.X / this.FMapData.PathTileWidth);
            }
            else
            {
               _loc5_ = -this.FMapData.PathTileWidth;
               _loc3_ = param1.X / this.FMapData.PathTileWidth;
            }
            _loc3_ *= this.FMapData.PathTileWidth;
            while(_loc6_ = this.CheckIfInInterregional(param1.X,param2.X,_loc3_))
            {
               this.FCoordinateA.X = _loc3_;
               this.FCoordinateA.Y = this.CounterEquationValue(_loc3_);
               _loc6_ = this.CheckIfBarrier(this.FCoordinateA);
               if(_loc6_)
               {
                  return false;
               }
               _loc3_ += _loc5_;
            }
            return true;
         }
         this.FCurrentMode == VERTICAL_MODE;
         if(param1.Y < param2.Y)
         {
            _loc5_ = this.FMapData.PathTileHeight;
            _loc3_ = Math.ceil(param1.Y / this.FMapData.PathTileHeight);
         }
         else
         {
            _loc5_ = -this.FMapData.PathTileHeight;
            _loc3_ = param1.Y / this.FMapData.PathTileHeight;
         }
         _loc3_ *= this.FMapData.PathTileHeight;
         while(_loc6_ = this.CheckIfInInterregional(param1.Y,param2.Y,_loc3_))
         {
            this.FCoordinateA.Y = _loc3_;
            this.FCoordinateA.X = this.CounterEquationValue(_loc3_);
            _loc6_ = this.CheckIfBarrier(this.FCoordinateA);
            if(_loc6_)
            {
               return false;
            }
            _loc3_ += _loc5_;
         }
         return true;
      }
      
      public function set MapData(param1:TMapData) : void
      {
         this.FMapData = param1;
      }
      
      public function CheckLineIfUnblocked(param1:TCoordinate, param2:TCoordinate) : Boolean
      {
         return this.CheckLineIfUnblocked_Perform(param1,param2);
      }
   }
}

