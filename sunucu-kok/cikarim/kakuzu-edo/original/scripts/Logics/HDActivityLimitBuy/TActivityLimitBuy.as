package Logics.HDActivityLimitBuy
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityLimitBuy extends TActivityOSBase
   {
      
      protected var FBuyLimitItems:Vector.<TActivityLimitBuyItem>;
      
      protected var FFlushTime:Vector.<uint>;
      
      protected var FPrompts:Vector.<String>;
      
      public function TActivityLimitBuy()
      {
         super();
         this.FBuyLimitItems = new Vector.<TActivityLimitBuyItem>();
         this.FFlushTime = new Vector.<uint>();
         this.FPrompts = new Vector.<String>();
      }
      
      public function get FlushTimeStr() : String
      {
         var _loc1_:String = null;
         return this.FFlushTime[0] + ":" + this.FFlushTime[1];
      }
      
      public function set FlushTime(param1:Vector.<uint>) : void
      {
         this.FFlushTime = param1;
      }
      
      public function get Prompts() : Vector.<String>
      {
         return this.FPrompts;
      }
      
      public function set Prompts(param1:Vector.<String>) : void
      {
         this.FPrompts = param1;
      }
      
      public function AddLimitBuyItem(param1:TActivityLimitBuyItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc4_ = false;
         _loc3_ = int(this.FBuyLimitItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.Index == this.FBuyLimitItems[_loc2_].Index)
            {
               _loc4_ = true;
               break;
            }
            _loc2_++;
         }
         if(!_loc4_)
         {
            this.FBuyLimitItems.push(param1);
         }
      }
      
      public function GetLimitBuyItemByIndex(param1:int) : TActivityLimitBuyItem
      {
         if(this.FBuyLimitItems.length <= 0)
         {
            return null;
         }
         return this.FBuyLimitItems[param1];
      }
      
      public function GetItemByUniqueIndex(param1:uint) : TActivityLimitBuyItem
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FBuyLimitItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FBuyLimitItems[_loc2_].Index == param1)
            {
               return this.FBuyLimitItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

