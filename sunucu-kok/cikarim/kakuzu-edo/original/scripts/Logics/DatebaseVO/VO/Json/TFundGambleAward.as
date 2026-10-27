package Logics.DatebaseVO.VO.Json
{
   public class TFundGambleAward
   {
      
      protected var FGold:uint;
      
      protected var FRange:Vector.<uint>;
      
      protected var FPrompt:String;
      
      public function TFundGambleAward(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FGold = param1.gold;
         _loc2_ = param1.range as Array;
         _loc4_ = _loc2_.length;
         this.FRange = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FRange[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.FPrompt = param1.prompt;
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function get Range() : Vector.<uint>
      {
         return this.FRange;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
   }
}

