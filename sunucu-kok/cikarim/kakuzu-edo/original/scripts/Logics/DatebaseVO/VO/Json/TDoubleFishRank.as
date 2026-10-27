package Logics.DatebaseVO.VO.Json
{
   public class TDoubleFishRank
   {
      
      protected var FKey:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FTitle:uint;
      
      protected var FPrompt:String;
      
      public function TDoubleFishRank(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FKey = param1.key;
         _loc2_ = param1.value as Array;
         _loc4_ = _loc2_.length;
         this.FAwards = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FAwards[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.FTitle = param1.title;
         this.FPrompt = param1.prompt;
      }
      
      public function get Key() : uint
      {
         return this.FKey;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get Title() : uint
      {
         return this.FTitle;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
   }
}

