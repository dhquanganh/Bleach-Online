package Logics.Streamization.HDChristmas2015
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDSled;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.TSledData;
   import Logics.HDChristmas2015.VO.TSledVO;
   import Logics.HDChristmas2015.VO.TSledVOPool;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerSled extends TUnstreamizer
   {
      
      protected var FInitPackage:Boolean;
      
      public function TUnstreamizerSled()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TSledData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TInventories = null;
         for each(_loc2_ in param1.Config.Shop)
         {
            SToolReward.GetAwardsByAwardID(_loc2_.awardId,param1.ScoreShop);
         }
         for each(_loc2_ in param1.Config.SledInfos.infos)
         {
            _loc3_ = new TInventories();
            param1.SledGifts.push(_loc3_);
            SToolReward.GetAwardsByAwardID(_loc2_.awardId,_loc3_);
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TSledData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         switch(param1)
         {
            case param3.Config.Robbery.index:
               param3.RemainSnatch = Math.max(0,param3.Config.Robbery.cout - TUtilityTool.ActState(param2));
               return;
            case param3.Config.Transport.index:
               param3.CurFreeTransport = Math.max(0,param3.Config.Transport.cout - TUtilityTool.ActState(param2));
               return;
            case param3.Config.ChristmasCardsIndex:
               _loc4_ = TUtilityTool.ActState(param2);
               if(!this.FInitPackage)
               {
                  _loc5_ = _loc4_ - param3.CurHaveChristmasCards;
                  if(_loc5_ > 0)
                  {
                     SToolReward.ShowMessage(TUtilityString.Format(param3.Config.Language.getCards,_loc5_));
                  }
               }
               param3.CurHaveChristmasCards = _loc4_;
               return;
            case param3.Config.BeginTransport.index:
               param3.CurTransporting = Boolean(TUtilityTool.ActState(param2));
               return;
            case param3.Config.SledInfos.index:
               param3.CurTransportType = TUtilityTool.ActState(param2);
               return;
            case param3.Config.RobberyInterfaceIndex:
               this.UpdateSled(param3,param2);
               return;
            case param3.Config.ReceiveAwardIndex:
               param3.HaveTransportReward = TUtilityTool.ActState(param2) == CONST_ACTIVITY_MODE.Activity_CanReceive;
               return;
            case param3.Config.BigGift.index:
               param3.GiftState = TUtilityTool.ActState(param2);
               return;
            case param3.Config.RobberyPersonIndex:
               param3.CurWheelSnatched = TUtilityTool.ActState(param2) == CONST_ACTIVITY_MODE.Activity_CanNotReceive;
               return;
            case param3.Config.RobberyIndex.index:
               this.SnatchResult(param3,TUtilityTool.ActState(param2),TUtilityTool.ActIntVec(param2));
               return;
            default:
               this.ShopResult(param1,param2,param3);
               return;
         }
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TSledData) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.Shop.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.Shop[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.ShopStates[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      protected function SnatchResult(param1:TSledData, param2:int, param3:Vector.<int>) : void
      {
         var _loc4_:TSledVO = null;
         switch(param2)
         {
            case 0:
            case 2:
               _loc4_ = param1.GetSledByID(param3[0],param3[1]);
               _loc4_.IsRobbed = true;
         }
         SToolReward.ShowMessage(param1.Config.Language.snatchState[param2]);
      }
      
      protected function UpdateSled(param1:TSledData, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TSledVO = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:uint = 5;
         _loc4_ = param1.SledVOs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.SledVOs[_loc3_];
            TSledVOPool.RelObj(_loc5_);
            _loc3_++;
         }
         param1.SledVOs.length = 0;
         _loc6_ = TUtilityTool.ActStringVec(param2);
         _loc7_ = TUtilityTool.ActIntVec(param2);
         _loc4_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = TSledVOPool.GetObj();
            _loc5_.Name = _loc6_[_loc3_];
            _loc5_.HighID = _loc7_[_loc3_ * _loc8_ + 0];
            _loc5_.LowID = _loc7_[_loc3_ * _loc8_ + 1];
            _loc5_.StartTime = _loc7_[_loc3_ * _loc8_ + 2] - param1.Config.TransportTime;
            _loc5_.Type = _loc7_[_loc3_ * _loc8_ + 3];
            _loc5_.IsRobbed = Boolean(_loc7_[_loc3_ * _loc8_ + 4]);
            _loc5_.TypeIndex = param1.GetSledIndexByType(_loc5_.Type);
            param1.SledVOs[_loc3_] = _loc5_;
            _loc3_++;
         }
         if(_loc4_ == 0)
         {
            param1.MySledArrivals();
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TSledData = null;
         var _loc8_:THDSled = null;
         _loc7_ = param2 as TSledData;
         _loc8_ = param3 as THDSled;
         this.FInitPackage = true;
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
            this.ConfigHandle(_loc7_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TSledData = null;
         _loc4_ = param2 as TSledData;
         this.FInitPackage = false;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

