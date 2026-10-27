package Logics.Tavern
{
   import Foundation.Resources.Bins.TBins;
   import Logics.DatebaseVO.VO.TExchangeExpCard;
   import Logics.DatebaseVO.VO.TTavernWarrior;
   import flash.utils.Dictionary;
   
   public class TWarriors
   {
      
      protected var FWarriorsDict:Dictionary;
      
      protected var FExpCardDict:Dictionary;
      
      public function TWarriors()
      {
         super();
         this.FWarriorsDict = new Dictionary(true);
         this.FExpCardDict = new Dictionary(true);
      }
      
      public function SetWarriorsBins(param1:TBins, param2:TBins) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<TTavernWarrior> = null;
         var _loc5_:TTavernWarrior = null;
         var _loc6_:Vector.<TExchangeExpCard> = null;
         var _loc7_:TExchangeExpCard = null;
         var _loc8_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.Count)
         {
            _loc5_ = param1.GetDatebaseByIndex(_loc3_) as TTavernWarrior;
            _loc8_ = uint(_loc5_.Grade);
            if(this.FWarriorsDict[_loc8_] == null)
            {
               this.FWarriorsDict[_loc8_] = new Vector.<TTavernWarrior>();
            }
            _loc4_ = this.FWarriorsDict[_loc8_];
            _loc4_.push(_loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2.Count)
         {
            _loc7_ = param2.GetDatebaseByIndex(_loc3_) as TExchangeExpCard;
            _loc8_ = _loc7_.Grade;
            if(this.FExpCardDict[_loc8_] == null)
            {
               this.FExpCardDict[_loc8_] = new Vector.<TExchangeExpCard>();
            }
            _loc6_ = this.FExpCardDict[_loc8_];
            _loc6_.push(_loc7_);
            _loc3_++;
         }
      }
      
      public function GetWarriorWithPage(param1:uint) : Vector.<TTavernWarrior>
      {
         return this.FWarriorsDict[param1];
      }
      
      public function GetExpCardWithPage(param1:uint) : Vector.<TExchangeExpCard>
      {
         return this.FExpCardDict[param1];
      }
   }
}

