package Logics.Streamization.HDGallery
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDGallery;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDGallery.THDGalleryData;
   
   public class TUnstreamizerGallery extends TUnstreamizer
   {
      
      public function TUnstreamizerGallery()
      {
         super();
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:THDGalleryData = null;
         var _loc10_:THDGallery = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:THDBoxStateData = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc9_ = param2 as THDGalleryData;
         _loc10_ = param3 as THDGallery;
         if(_loc8_.AllBox.length == 0)
         {
            return;
         }
         _loc9_.CurDay = _loc8_.ParameterVec[0];
         _loc9_.CurIndex = 0;
         _loc5_ = int(_loc8_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc13_ = _loc8_.AllBox[_loc4_];
            _loc7_ = int(_loc10_.AwardIndexVec.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               if(_loc13_.BoxIndex == _loc10_.AwardIndexVec[_loc6_])
               {
                  _loc11_ = _loc10_.AwardIndexVec.indexOf(_loc13_.BoxIndex);
                  _loc9_.CurInventories[_loc11_] = Vector.<int>(_loc13_.Conditions);
                  break;
               }
               _loc6_++;
            }
            if(_loc13_.BoxIndex == _loc10_.LoginIndex)
            {
               _loc9_.LoginCanGet = _loc13_.State == 1;
            }
            else if(_loc13_.BoxIndex == _loc10_.FreeTimeIndex)
            {
               _loc12_ = _loc10_.FreeTime - _loc13_.State;
               _loc12_ = _loc12_ > 0 ? _loc12_ : 0;
               _loc9_.FreeCount = _loc12_;
            }
            else if(_loc13_.BoxIndex == _loc10_.ScoreIndex)
            {
               _loc9_.CurScore = _loc13_.State;
            }
            else if(_loc13_.BoxIndex == _loc10_.RemoveIndex)
            {
               _loc9_.RemoveStatus = _loc13_.State;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THDGalleryData = null;
         var _loc10_:THDGallery = null;
         var _loc11_:TActAwardStatusInfo = null;
         _loc11_ = param1 as TActAwardStatusInfo;
         _loc9_ = param2 as THDGalleryData;
         _loc10_ = param3 as THDGallery;
         _loc4_ = int(_loc10_.AwardIndexVec.length);
         _loc9_.CurIndex = _loc11_.Index;
         if(_loc11_.Index == _loc10_.AwardIndexVec[0])
         {
            _loc9_.IsInit = _loc11_.Status;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc11_.Index == _loc10_.AwardIndexVec[_loc5_])
            {
               _loc7_ = _loc10_.AwardIndexVec.indexOf(_loc11_.Index);
               _loc9_.CurInventories[_loc7_] = Vector.<int>(_loc11_.Condition);
               break;
            }
            _loc5_++;
         }
         if(_loc11_.Index == _loc10_.LoginIndex)
         {
            _loc9_.LoginCanGet = _loc11_.Status == 1;
         }
         else if(_loc11_.Index == _loc10_.FreeTimeIndex)
         {
            _loc8_ = _loc10_.FreeTime - _loc11_.Status;
            _loc8_ = _loc8_ > 0 ? _loc8_ : 0;
            _loc9_.FreeCount = _loc8_;
         }
         else if(_loc11_.Index == _loc10_.ScoreIndex)
         {
            _loc9_.CurScore = _loc11_.Status;
         }
         else if(_loc11_.Index == _loc10_.RemoveIndex)
         {
            _loc9_.RemoveStatus = _loc11_.Status;
         }
         else if(_loc11_.Index == _loc10_.ExtractOneIndex)
         {
            _loc9_.Results = Vector.<int>(_loc11_.Condition);
         }
      }
   }
}

