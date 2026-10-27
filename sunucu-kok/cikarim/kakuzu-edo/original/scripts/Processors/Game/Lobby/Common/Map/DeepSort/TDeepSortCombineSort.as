package Processors.Game.Lobby.Common.Map.DeepSort
{
   import Foundation.Common.TCoordinate;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMap;
   
   public class TDeepSortCombineSort implements IDeepSort
   {
      
      protected var FRolesBackA:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FRolesBackB:Vector.<TSceneSpriteMoudleInMap>;
      
      public function TDeepSortCombineSort()
      {
         super();
         this.FRolesBackA = new Vector.<TSceneSpriteMoudleInMap>();
         this.FRolesBackB = new Vector.<TSceneSpriteMoudleInMap>();
      }
      
      protected function Merge(param1:Vector.<TSceneSpriteMoudleInMap>, param2:Vector.<TSceneSpriteMoudleInMap>, param3:int, param4:int, param5:int) : void
      {
         var _loc11_:TCoordinate = null;
         var _loc12_:TCoordinate = null;
         var _loc6_:* = param3;
         var _loc7_:* = param3;
         var _loc8_:int = param4;
         var _loc9_:* = int(param4 + 1);
         var _loc10_:int = param5;
         while(_loc6_ <= param5)
         {
            if(_loc7_ > _loc8_)
            {
               var _loc13_:Number;
               param2[_loc13_ = _loc6_++] = param1[_loc9_++];
            }
            else if(_loc9_ > _loc10_)
            {
               param2[_loc13_ = _loc6_++] = param1[_loc7_++];
            }
            else
            {
               _loc11_ = param1[_loc7_].MapCoordinate;
               _loc12_ = param1[_loc9_].MapCoordinate;
               if(_loc11_.Y <= _loc12_.Y)
               {
                  param2[_loc13_ = _loc6_++] = param1[_loc7_++];
               }
               else
               {
                  param2[_loc13_ = _loc6_++] = param1[_loc9_++];
               }
            }
         }
      }
      
      protected function MergePass(param1:Vector.<TSceneSpriteMoudleInMap>, param2:Vector.<TSceneSpriteMoudleInMap>, param3:int, param4:int) : void
      {
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ <= param4 - 2 * param3)
         {
            this.Merge(param1,param2,_loc5_,_loc5_ + param3 - 1,_loc5_ + param3 * 2 - 1);
            _loc5_ += 2 * param3;
         }
         if(_loc5_ + param3 < param4)
         {
            this.Merge(param1,param2,_loc5_,_loc5_ + param3 - 1,param4 - 1);
         }
         else
         {
            _loc6_ = _loc5_;
            while(_loc6_ < param4)
            {
               param2[_loc6_] = param1[_loc6_];
               _loc6_++;
            }
         }
      }
      
      protected function DeepSort_Perform(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 1;
         this.FRolesBackB.length = param1.length;
         _loc3_ = int(param1.length);
         while(_loc2_ < _loc3_)
         {
            this.MergePass(param1,this.FRolesBackB,_loc2_,_loc3_);
            _loc2_ += _loc2_;
            this.MergePass(this.FRolesBackB,param1,_loc2_,_loc3_);
            _loc2_ += _loc2_;
         }
      }
      
      public function DeepSort(param1:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         this.DeepSort_Perform(param1);
      }
   }
}

