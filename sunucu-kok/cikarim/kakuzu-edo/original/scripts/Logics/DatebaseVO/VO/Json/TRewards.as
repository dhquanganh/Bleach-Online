package Logics.DatebaseVO.VO.Json
{
   import Processors.Game.Utilities.Common.TUtilityTool;
   import ghostcat.util.data.Json;
   
   public class TRewards
   {
      
      protected var FReward:Array;
      
      protected var FType:Vector.<uint>;
      
      protected var FCode:Vector.<uint>;
      
      protected var FAmount:Vector.<uint>;
      
      public function TRewards(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         super();
         if(param1 is String)
         {
            _loc5_ = Json.decode(String(param1));
         }
         else if(param1 is Array)
         {
            _loc5_ = param1;
         }
         else if(param1 is Vector.<Object>)
         {
            _loc5_ = TUtilityTool.VecToArr(param1 as Vector.<Object>);
         }
         this.FReward = _loc5_ as Array;
         _loc3_ = int(this.FReward.length);
         this.FType = new Vector.<uint>(_loc3_);
         this.FCode = new Vector.<uint>(_loc3_);
         this.FAmount = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FReward[_loc2_];
            this.FType[_loc2_] = _loc4_.type;
            this.FCode[_loc2_] = _loc4_.code;
            this.FAmount[_loc2_] = _loc4_.amount;
            _loc2_++;
         }
      }
      
      public function get Count() : uint
      {
         return this.FReward.length;
      }
      
      public function get Type() : Vector.<uint>
      {
         return this.FType;
      }
      
      public function get Code() : Vector.<uint>
      {
         return this.FCode;
      }
      
      public function get Amount() : Vector.<uint>
      {
         return this.FAmount;
      }
   }
}

