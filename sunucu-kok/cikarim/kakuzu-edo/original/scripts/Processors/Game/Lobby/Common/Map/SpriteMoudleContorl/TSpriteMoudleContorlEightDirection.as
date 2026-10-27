package Processors.Game.Lobby.Common.Map.SpriteMoudleContorl
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Resources.Constants.CONST_MAP;
   
   public class TSpriteMoudleContorlEightDirection implements ISpriteMoudleContorl
   {
      
      protected static const DIRECTION:Vector.<uint> = Vector.<uint>([CONST_MAP.DIRECTION_UP,CONST_MAP.DIRECTION_RIGHT_UP,CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_RIGHT_DOWN,CONST_MAP.DIRECTION_DOWN,CONST_MAP.DIRECTION_LEFT_DOWN,CONST_MAP.DIRECTION_LEFT,CONST_MAP.DIRECTION_LEFT_UP]);
      
      protected static const DIRECTION_CHANGE:Vector.<uint> = Vector.<uint>([CONST_MAP.DIRECTION_UP,CONST_MAP.DIRECTION_RIGHT_UP,CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_RIGHT_DOWN,CONST_MAP.DIRECTION_DOWN,CONST_MAP.DIRECTION_RIGHT_DOWN,CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_RIGHT_UP]);
      
      protected static const DIRECTION_SCALX:Vector.<int> = Vector.<int>([1,1,1,1,1,-1,-1,-1]);
      
      protected static const UNIT:Number = Math.PI / 8;
      
      protected static const DIRECTION_JUDGE:Vector.<int> = Vector.<int>([-1,0,0,1,1,3,3,5,5,7,7,8,-8,-7,-7,-5,-5,-3,-3,-1]);
      
      protected static const DIRECTION_MIRROR:Vector.<int> = Vector.<int>([CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_RIGHT_DOWN,CONST_MAP.DIRECTION_DOWN,CONST_MAP.DIRECTION_LEFT_DOWN,CONST_MAP.DIRECTION_LEFT,CONST_MAP.DIRECTION_LEFT,CONST_MAP.DIRECTION_LEFT_UP,CONST_MAP.DIRECTION_UP,CONST_MAP.DIRECTION_RIGHT_UP]);
      
      public function TSpriteMoudleContorlEightDirection()
      {
         super();
      }
      
      public function GetRoleMoudleInfor(param1:TSceneSpriteMoudle, param2:uint, param3:uint, param4:uint, param5:TMoudleInfor) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Vector.<uint> = null;
         _loc7_ = DIRECTION;
         _loc6_ = _loc7_.indexOf(param4);
         param4 = DIRECTION_CHANGE[_loc6_];
         param5.TextureID = (param2 << 8) + param4 + param3;
         param5.Scalx = DIRECTION_SCALX[_loc6_];
      }
      
      public function GetDirectionByStartEndDirection(param1:TCoordinate, param2:TCoordinate) : int
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<int> = null;
         _loc4_ = param2.Y - param1.Y;
         _loc3_ = param2.X - param1.X;
         _loc5_ = Math.atan2(_loc4_,_loc3_);
         _loc5_ = _loc5_ / UNIT;
         _loc8_ = DIRECTION_JUDGE;
         _loc7_ = _loc8_.length / 2;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(_loc8_[_loc6_ << 1] <= _loc5_ && _loc8_[(_loc6_ << 1) + 1] >= _loc5_)
            {
               break;
            }
            _loc6_++;
         }
         return DIRECTION_MIRROR[_loc6_];
      }
   }
}

