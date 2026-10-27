package Logics.DatebaseVO.VO.Json
{
   public class TConditionStyleB
   {
      
      protected var FNeedID:uint;
      
      protected var FNeedLevel:uint;
      
      protected var FCount:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FPrompt:String;
      
      protected var FPrompt1:String;
      
      protected var FIndex:uint;
      
      protected var FGold:uint;
      
      public function TConditionStyleB(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super();
         if(param1.id != null)
         {
            this.FNeedID = param1.id;
         }
         if(param1.lv != null)
         {
            this.FNeedLevel = param1.lv;
         }
         if(param1.count != null)
         {
            this.FCount = param1.count;
         }
         if(param1.award != null)
         {
            _loc3_ = int(param1.award.length);
            this.FAwards = new Vector.<uint>(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FAwards[_loc2_] = uint(param1.award[_loc2_]);
               _loc2_++;
            }
         }
         if(param1.prompt != null)
         {
            this.FPrompt = param1.prompt;
         }
         if(param1.prompt1 != null)
         {
            this.FPrompt1 = param1.prompt1;
         }
         if(param1.index != null)
         {
            this.FIndex = param1.index;
         }
         if(param1.gold != null)
         {
            this.FGold = param1.gold;
         }
      }
      
      public function get NeedID() : uint
      {
         return this.FNeedID;
      }
      
      public function get NeedLevel() : uint
      {
         return this.FNeedLevel;
      }
      
      public function get Count() : uint
      {
         return this.FCount;
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
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function get Prompt1() : String
      {
         return this.FPrompt1;
      }
   }
}

