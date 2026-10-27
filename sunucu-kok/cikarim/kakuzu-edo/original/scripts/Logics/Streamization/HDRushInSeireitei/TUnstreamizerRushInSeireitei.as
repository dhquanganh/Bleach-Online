package Logics.Streamization.HDRushInSeireitei
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDRushInSeireitei;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDRushInSeireitei.THDRushInSeireiteiData;
   import Logics.Pet.TVicePet;
   import Logics.Streamization.Pet.TUnstreamizerPet;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerRushInSeireitei extends TUnstreamizer
   {
      
      protected var FUnstreamizerPet:TUnstreamizerPet;
      
      public function TUnstreamizerRushInSeireitei()
      {
         super();
         this.FUnstreamizerPet = new TUnstreamizerPet();
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:THDRushInSeireiteiData = null;
         var _loc10_:THDRushInSeireitei = null;
         var _loc11_:int = 0;
         var _loc12_:THDBoxStateData = null;
         var _loc13_:TVicePet = null;
         var _loc14_:TPetLevelUp = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc9_ = param2 as THDRushInSeireiteiData;
         _loc10_ = param3 as THDRushInSeireitei;
         if(_loc8_.AllBox.length == 0)
         {
            return;
         }
         if(_loc9_.LevelStatusVec == null)
         {
            _loc9_.LevelStatusVec = new Vector.<int>(_loc10_.GiftIndexVec.length);
         }
         if(_loc9_.ShopStatusVec == null)
         {
            _loc9_.ShopStatusVec = new Vector.<int>(_loc10_.ShopIndexVec.length);
         }
         _loc5_ = int(_loc8_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc12_ = _loc8_.AllBox[_loc4_];
            _loc7_ = int(_loc10_.GiftIndexVec.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               if(_loc12_.BoxIndex == _loc10_.GiftIndexVec[_loc6_])
               {
                  _loc11_ = _loc10_.GiftIndexVec.indexOf(_loc12_.BoxIndex);
                  _loc9_.LevelStatusVec[_loc11_] = _loc12_.State;
                  break;
               }
               _loc6_++;
            }
            _loc7_ = int(_loc10_.ShopIndexVec.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               if(_loc12_.BoxIndex == _loc10_.ShopIndexVec[_loc6_])
               {
                  _loc11_ = _loc10_.ShopIndexVec.indexOf(_loc12_.BoxIndex);
                  _loc9_.ShopStatusVec[_loc11_] = _loc12_.State;
                  break;
               }
               _loc6_++;
            }
            if(_loc12_.BoxIndex == _loc10_.RefreshIndex)
            {
               _loc9_.RefreshType = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.AttackIndex)
            {
               _loc9_.CurLevelIndex = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.ScoreIndex)
            {
               _loc9_.CurScore = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.TotalScoreIndex)
            {
               _loc9_.TotalScore = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.AttackIndexVec[0])
            {
               _loc9_.NomalCount = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.AttackIndexVec[2])
            {
               _loc9_.SpecialCount = _loc12_.State;
            }
            _loc4_++;
         }
         _loc9_.RankVec.length = 0;
         if(_loc8_.AddtionalVecs.length > 0)
         {
            _loc5_ = int(_loc8_.AddtionalVecs[0].length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_.RankVec.push(_loc8_.AddtionalVecs[0][_loc4_] as TActivityServerRank);
               _loc4_++;
            }
         }
         _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc10_.PetId) as TPetLevelUp;
         _loc13_ = new TVicePet(0,0);
         _loc13_.TemplateID = _loc14_.PetId;
         _loc13_.Level = _loc14_.Level;
         this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc13_,null);
         _loc9_.VicePet = _loc13_;
      }
      
      public function UnstreamizeUpdateActivity(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THDRushInSeireiteiData = null;
         var _loc8_:THDRushInSeireitei = null;
         var _loc9_:TActAwardStatusInfo = null;
         _loc9_ = param1 as TActAwardStatusInfo;
         _loc7_ = param2 as THDRushInSeireiteiData;
         _loc8_ = param3 as THDRushInSeireitei;
         _loc4_ = int(_loc8_.GiftIndexVec.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc9_.Index == _loc8_.GiftIndexVec[_loc5_])
            {
               _loc6_ = _loc8_.GiftIndexVec.indexOf(_loc9_.Index);
               _loc7_.LevelStatusVec[_loc6_] = _loc9_.Status;
               break;
            }
            _loc5_++;
         }
         _loc4_ = int(_loc8_.ShopIndexVec.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc9_.Index == _loc8_.ShopIndexVec[_loc5_])
            {
               _loc6_ = _loc8_.ShopIndexVec.indexOf(_loc9_.Index);
               _loc7_.ShopStatusVec[_loc6_] = _loc9_.Status;
               break;
            }
            _loc5_++;
         }
         if(_loc9_.Index == _loc8_.RefreshIndex)
         {
            _loc7_.RefreshType = _loc9_.Status;
         }
         else if(_loc9_.Index == _loc8_.AttackIndex)
         {
            _loc7_.CurLevelIndex = _loc9_.Status;
         }
         else if(_loc9_.Index == _loc8_.ScoreIndex)
         {
            _loc7_.CurScore = _loc9_.Status;
         }
         else if(_loc9_.Index == _loc8_.TotalScoreIndex)
         {
            _loc7_.TotalScore = _loc9_.Status;
         }
         else if(_loc9_.Index == _loc8_.AttackIndexVec[0])
         {
            _loc7_.NomalCount = _loc9_.Status;
         }
         else if(_loc9_.Index == _loc8_.AttackIndexVec[2])
         {
            _loc7_.SpecialCount = _loc9_.Status;
         }
      }
   }
}

