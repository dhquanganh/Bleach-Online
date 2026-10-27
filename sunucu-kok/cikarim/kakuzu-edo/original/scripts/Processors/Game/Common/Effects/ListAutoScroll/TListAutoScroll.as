package Processors.Game.Common.Effects.ListAutoScroll
{
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Timing.STimingCore;
   
   public class TListAutoScroll
   {
      
      public static const Type_Back:int = 1;
      
      public static const Type_Fore:int = -1;
      
      public static const MoveType_DirecX:int = 0;
      
      public static const MoveType_DirecY:int = 1;
      
      public static const Move_Tick:int = 2000;
      
      protected var FPauseTickCount:int;
      
      protected var FIsOver:Boolean;
      
      protected var FCoordinates:Vector.<TCoordinate>;
      
      protected var FTickStore:int;
      
      protected var FMoveVec:Vector.<TMovementLinear>;
      
      protected var FListData:Vector.<IListAutoScrollDataRender>;
      
      protected var FList:Vector.<IListAutoScrollRender>;
      
      protected var FCurIndex:int;
      
      protected var FCurDataIndex:int;
      
      protected var FCurlist:Vector.<int>;
      
      protected var FCoordinateCount:int;
      
      protected var FIsStart:Boolean;
      
      protected var FScrollDirection:int;
      
      protected var FScrollSide:int;
      
      protected var FListCount:int;
      
      protected var FMoveTick:int;
      
      protected var FListSpace:int;
      
      protected var FOffsetX:int;
      
      protected var FOffsetY:int;
      
      protected var FIsPause:Boolean;
      
      public function TListAutoScroll()
      {
         super();
         this.FMoveVec = new Vector.<TMovementLinear>();
         this.FCoordinates = new Vector.<TCoordinate>();
         this.FScrollDirection = Type_Back;
         this.FScrollSide = MoveType_DirecX;
         this.FMoveTick = Move_Tick;
         this.FOffsetX = 0;
         this.FOffsetY = 0;
         this.FCurlist = new Vector.<int>();
         this.FList = new Vector.<IListAutoScrollRender>();
         this.FListData = new Vector.<IListAutoScrollDataRender>();
      }
      
      protected function ResetMovements() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TMovementLinear = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FMoveVec.length = 0;
         if(this.FScrollDirection == Type_Back)
         {
            _loc1_ = 1;
            while(_loc1_ < this.FCoordinateCount)
            {
               _loc2_ = new TMovementLinear();
               if(this.FScrollSide == MoveType_DirecX)
               {
                  _loc2_.SetupSegmentByDuration(this.FCoordinates[_loc1_ - 1].X,this.FCoordinates[_loc1_ - 1].Y,this.FCoordinates[_loc1_].X,this.FCoordinates[_loc1_ - 1].Y,this.FMoveTick);
               }
               else
               {
                  _loc2_.SetupSegmentByDuration(this.FCoordinates[_loc1_ - 1].X,this.FCoordinates[_loc1_ - 1].Y,this.FCoordinates[_loc1_ - 1].X,this.FCoordinates[_loc1_].Y,this.FMoveTick);
               }
               this.FMoveVec.push(_loc2_);
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = int(this.FListCount - 1);
            while(_loc1_ >= 0)
            {
               _loc2_ = new TMovementLinear();
               if(this.FScrollSide == MoveType_DirecX)
               {
                  _loc2_.SetupSegmentByDuration(this.FCoordinates[_loc1_ + 1].X,this.FCoordinates[_loc1_ + 1].Y,this.FCoordinates[_loc1_].X,this.FCoordinates[_loc1_ + 1].Y,this.FMoveTick);
               }
               else
               {
                  _loc2_.SetupSegmentByDuration(this.FCoordinates[_loc1_ + 1].X,this.FCoordinates[_loc1_ + 1].Y,this.FCoordinates[_loc1_ + 1].X,this.FCoordinates[_loc1_].Y,this.FMoveTick);
               }
               this.FMoveVec.push(_loc2_);
               _loc1_--;
            }
         }
      }
      
      public function get ScrollDirection() : int
      {
         return this.FScrollDirection;
      }
      
      public function set ScrollDirection(param1:int) : void
      {
         this.FScrollDirection = param1;
      }
      
      public function get ScrollSide() : int
      {
         return this.FScrollSide;
      }
      
      public function set ScrollSide(param1:int) : void
      {
         this.FScrollSide = param1;
      }
      
      public function get ListCount() : int
      {
         return this.FListCount;
      }
      
      public function set ListCount(param1:int) : void
      {
         this.FListCount = param1;
         this.FCoordinateCount = this.FListCount + 1;
      }
      
      public function get MoveTick() : int
      {
         return this.FMoveTick;
      }
      
      public function set MoveTick(param1:int) : void
      {
         this.FMoveTick = param1;
      }
      
      public function get ListSpace() : int
      {
         return this.FListSpace;
      }
      
      public function set ListSpace(param1:int) : void
      {
         this.FListSpace = param1;
      }
      
      public function get OffsetX() : int
      {
         return this.FOffsetX;
      }
      
      public function set OffsetX(param1:int) : void
      {
         this.FOffsetX = param1;
      }
      
      public function get OffsetY() : int
      {
         return this.FOffsetY;
      }
      
      public function set OffsetY(param1:int) : void
      {
         this.FOffsetY = param1;
      }
      
      public function get IsPause() : Boolean
      {
         return this.FIsPause;
      }
      
      public function set IsPause(param1:Boolean) : void
      {
         this.FIsPause = param1;
         if(this.FIsPause)
         {
            this.FPauseTickCount = STimingCore.TickCount;
         }
         else
         {
            this.FTickStore += STimingCore.TickCount - this.FPauseTickCount;
         }
      }
      
      public function Init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TCoordinate = null;
         _loc1_ = 0;
         while(_loc1_ < this.FCoordinateCount)
         {
            _loc2_ = new TCoordinate();
            if(this.ScrollSide == MoveType_DirecX)
            {
               _loc2_.X = this.FOffsetX + this.FListSpace * _loc1_ - this.FListSpace;
               _loc2_.Y = this.FOffsetY;
               this.FCoordinates.push(_loc2_);
               if(_loc1_ != 0)
               {
                  this.FCurlist.push(_loc1_ - 1);
               }
            }
            else
            {
               _loc2_.X = this.FOffsetX;
               _loc2_.Y = this.FOffsetY + this.FListSpace * _loc1_ - this.FListSpace;
               this.FCoordinates.push(_loc2_);
               if(_loc1_ != 0)
               {
                  this.FCurlist.push(_loc1_ - 1);
               }
            }
            _loc1_++;
         }
         this.ResetMovements();
         this.FCurIndex = this.FScrollDirection == Type_Back ? 0 : int(this.FListCount - 1);
         this.FCurDataIndex = this.FListCount;
         this.FPauseTickCount = STimingCore.TickCount;
      }
      
      public function SetListData(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         this.FList.length;
         this.FListData.length = 0;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            this.FListData.push(param2[_loc3_]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.FListCount)
         {
            this.FList.push(param1[_loc3_]);
            this.FList[_loc3_].SetData(this.FListData[_loc3_]);
            _loc3_++;
         }
      }
      
      public function StartMove() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FIsOver)
         {
            this.FTickStore = STimingCore.TickCount;
            this.FIsOver = false;
            this.ResetMovements();
            _loc2_ = this.FCurlist.shift();
            this.FCurlist.push(_loc2_);
            if(this.FScrollDirection == Type_Back)
            {
               this.FList[this.FCurIndex].SetData(this.FListData[this.FCurDataIndex]);
               ++this.FCurIndex;
               if(this.FCurIndex >= this.FListCount)
               {
                  this.FCurIndex = 0;
               }
            }
            else
            {
               --this.FCurIndex;
               if(this.FCurIndex <= 0)
               {
                  this.FCurIndex = this.FListCount - 1;
               }
               this.FList[_loc2_].SetData(this.FListData[this.FCurDataIndex]);
            }
            ++this.FCurDataIndex;
            if(this.FCurDataIndex >= this.FListData.length)
            {
               this.FCurDataIndex = 0;
            }
            return;
         }
         if(!this.FIsStart)
         {
            this.FIsStart = true;
            this.FTickStore = STimingCore.TickCount;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FListCount)
         {
            this.FMoveVec[_loc1_].Move(STimingCore.TickCount - this.FTickStore);
            this.FList[this.FCurlist[_loc1_]].Substrate.x = int(this.FMoveVec[_loc1_].X);
            this.FList[this.FCurlist[_loc1_]].Substrate.y = int(this.FMoveVec[_loc1_].Y);
            _loc1_++;
         }
         if(this.FMoveVec[0].MoveOver)
         {
            this.FIsOver = true;
         }
      }
   }
}

