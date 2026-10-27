package Logics.DatebaseVO.VO.Json
{
   public class TDoubleFishAward
   {
      
      protected var FKey:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FPrompt:String;
      
      protected var FIndex:uint;
      
      protected var FGetType:uint;
      
      public function TDoubleFishAward(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FKey = param1.key;
         this.FIndex = param1.index;
         this.FGetType = param1.getType;
         _loc2_ = param1.award as Array;
         _loc4_ = _loc2_.length;
         this.FAwards = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FAwards[_loc3_] = _loc5_;
            _loc3_++;
         }
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
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
   }
}

