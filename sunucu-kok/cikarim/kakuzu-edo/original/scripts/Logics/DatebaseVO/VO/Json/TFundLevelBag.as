package Logics.DatebaseVO.VO.Json
{
   public class TFundLevelBag
   {
      
      protected var FLevel:uint;
      
      protected var FGold:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FPrompt:String;
      
      protected var FInventoriesId:Vector.<uint>;
      
      public function TFundLevelBag(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super();
         this.FLevel = param1.lv;
         this.FGold = param1.gold;
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
         this.FPrompt = param1.prompt;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function get InventoriesId() : Vector.<uint>
      {
         return this.FInventoriesId;
      }
      
      public function SetInventoriesId(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.id as Array;
         _loc4_ = _loc2_.length;
         this.FInventoriesId = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = uint(_loc2_[_loc3_]);
            this.FInventoriesId[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
   }
}

