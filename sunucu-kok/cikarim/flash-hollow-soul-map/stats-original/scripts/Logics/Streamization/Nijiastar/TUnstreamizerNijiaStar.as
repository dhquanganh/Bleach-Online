package Logics.Streamization.Nijiastar
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TSevenHeroStarAddValue;
   import Logics.DatebaseVO.VO.TSevenHeroLittleStar;
   import Logics.DatebaseVO.VO.TSevenHeroStar;
   import Logics.NijiaStar.TNijiaStar;
   import Logics.NijiaStar.TNijiaStarAtom;
   import Logics.NijiaStar.TNijiaStars;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NIJIASTAR;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerNijiaStar extends TUnstreamizer
   {
      
      protected const ATTIBUTES:Vector.<uint> = Vector.<uint>([CONST_COMMON.BASEATTRIBUTENAME_NearAttack,CONST_COMMON.BASEATTRIBUTENAME_StrategyAttack,CONST_COMMON.BASEATTRIBUTENAME_NearDefense,CONST_COMMON.BASEATTRIBUTENAME_StrategyDefense,CONST_COMMON.BASEATTRIBUTENAME_MAXHP,CONST_COMMON.BASEATTRIBUTENAME_Speed]);
      
      public function TUnstreamizerNijiaStar()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TNijiaStar = null;
         var _loc5_:TNijiaStarAtom = null;
         var _loc6_:TNijiaStars = null;
         var _loc7_:TSevenHeroLittleStar = null;
         var _loc8_:TSevenHeroStar = null;
         var _loc9_:TSevenHeroStarAddValue = null;
         var _loc10_:TBins = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:ByteArray = null;
         var _loc17_:int = 0;
         var _loc18_:Vector.<uint> = null;
         _loc16_ = param1 as ByteArray;
         _loc6_ = param2 as TNijiaStars;
         _loc11_ = param3 as int;
         _loc17_ = _loc16_.readInt();
         _loc4_ = _loc6_.GetNijiaStarByIndex(_loc11_);
         if(_loc4_ == null)
         {
            _loc4_ = new TNijiaStar();
         }
         _loc4_.Identifier = _loc17_;
         _loc18_ = new Vector.<uint>(CONST_NIJIASTAR.CAPACITY_Attribute);
         _loc10_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroStar) as TBins;
         _loc14_ = uint(_loc10_.Count);
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc8_ = _loc10_.GetDatebaseByIndex(_loc13_) as TSevenHeroStar;
            if(_loc8_.Identifier % 10 == _loc11_ + 1)
            {
               _loc4_.Tag = _loc8_.Identifier;
               _loc4_.SevenHeroID = _loc8_.SevenHeroId;
               _loc4_.HeroName = _loc8_.HeroName;
               _loc4_.Desc = _loc8_.Desc;
               _loc4_.FinalStarName = _loc8_.FinalStarName;
               _loc15_ = _loc4_.ExtraAddValues.length;
               _loc12_ = 0;
               while(_loc12_ < _loc15_)
               {
                  _loc4_.ExtraAddValues[_loc12_] = _loc8_.AddValues[_loc12_].AddValue;
                  _loc12_++;
               }
               break;
            }
            _loc13_++;
         }
         _loc6_.SetNijiaStarByIndex(_loc11_,_loc4_);
         if(_loc17_ != 0 && _loc17_ % 100 % 6 == 0)
         {
            _loc4_.IsLastPoint = true;
         }
         else
         {
            _loc4_.IsLastPoint = false;
         }
         _loc10_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroLittleStar) as TBins;
         _loc14_ = uint(_loc10_.Count);
         _loc12_ = 0;
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc7_ = _loc10_.GetDatebaseByIndex(_loc13_) as TSevenHeroLittleStar;
            if(_loc7_.BigStar % 10 == _loc11_ + 1)
            {
               _loc5_ = _loc4_.GetNijiaStarAtomByIndex(_loc12_);
               if(_loc5_ == null)
               {
                  _loc5_ = new TNijiaStarAtom();
               }
               _loc5_.Identifier = _loc7_.Identifier;
               _loc5_.BigStar = _loc7_.BigStar;
               _loc5_.Sort = _loc7_.Sort;
               _loc5_.PreLittleStar = _loc7_.PreLittleStar;
               _loc5_.IsLast = _loc7_.IsLast;
               _loc5_.CostSoul = _loc7_.CostSoul;
               _loc5_.LittleStarName = _loc7_.LittleStarName;
               this.SetTypeValue(_loc7_.AddValues,_loc5_.AddValues);
               if(_loc5_.Identifier <= _loc4_.Identifier)
               {
                  _loc5_.IsActivate = true;
               }
               else
               {
                  _loc5_.IsActivate = false;
               }
               _loc4_.SetNijiaStarAtomByIndex(_loc12_,_loc5_);
               _loc12_++;
            }
            _loc13_++;
         }
         _loc14_ = _loc4_.Count;
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc5_ = _loc4_.GetNijiaStarAtomByIndex(_loc13_);
            _loc15_ = _loc5_.AddValues.length;
            _loc12_ = 0;
            while(_loc12_ < _loc15_)
            {
               _loc18_[_loc12_] += _loc5_.AddValues[_loc12_];
               _loc12_++;
            }
            _loc13_++;
         }
         _loc14_ = _loc18_.length;
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc4_.SetTotalVaulesByIndex(_loc13_,_loc18_[_loc13_]);
            _loc13_++;
         }
      }
      
      protected function SetTypeValue(param1:Vector.<TSevenHeroStarAddValue>, param2:Vector.<uint>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         _loc4_ = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.ATTIBUTES.indexOf(param1[_loc3_].AddType);
            if(_loc5_ != -1)
            {
               param2[_loc5_] = param1[_loc3_].AddValue;
            }
            _loc3_++;
         }
      }
      
      override public function Unstreamize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform(param1,param2,param3);
      }
   }
}

