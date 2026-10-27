package Foundation.Container
{
   import flash.utils.Dictionary;
   
   public class THashMap
   {
      
      protected var FContent:Dictionary;
      
      protected var FLength:int;
      
      public function THashMap()
      {
         super();
         this.FLength = 0;
         this.FContent = new Dictionary();
      }
      
      public function Size() : int
      {
         return this.FLength;
      }
      
      public function IsEmpty() : Boolean
      {
         return this.FLength == 0;
      }
      
      public function Keys() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         _loc3_ = new Array(this.FLength);
         _loc1_ = 0;
         for(_loc2_ in this.FContent)
         {
            _loc3_[_loc1_] = _loc2_;
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function Values() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         _loc3_ = new Array(this.FLength);
         _loc1_ = 0;
         for each(_loc2_ in this.FContent)
         {
            _loc3_[_loc1_] = _loc2_;
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function ContainsValue(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this.FContent)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function ContainsKey(param1:*) : Boolean
      {
         if(this.FContent[param1] != undefined)
         {
            return true;
         }
         return false;
      }
      
      public function Get(param1:*) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = this.FContent[param1];
         if(_loc2_ != undefined)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function GetValue(param1:*) : *
      {
         return this.Get(param1);
      }
      
      public function Put(param1:*, param2:*) : *
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         if(param1 == null)
         {
            throw new ArgumentError("cannot put a value with undefined or null key!");
         }
         if(param2 == null)
         {
            return this.Remove(param1);
         }
         _loc3_ = this.ContainsKey(param1);
         if(!_loc3_)
         {
            ++this.FLength;
         }
         _loc4_ = this.Get(param1);
         this.FContent[param1] = param2;
         return _loc4_;
      }
      
      public function Remove(param1:*) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         _loc2_ = this.ContainsKey(param1);
         if(!_loc2_)
         {
            return null;
         }
         _loc3_ = this.FContent[param1];
         delete this.FContent[param1];
         --this.FLength;
         return _loc3_;
      }
      
      public function Clear() : void
      {
         this.FLength = 0;
         this.FContent = new Dictionary();
      }
      
      public function Clone() : THashMap
      {
         var _loc1_:* = undefined;
         var _loc2_:THashMap = null;
         _loc2_ = new THashMap();
         for(_loc1_ in this.FContent)
         {
            _loc2_.Put(_loc1_,this.FContent[_loc1_]);
         }
         return _loc2_;
      }
      
      public function ToString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         _loc2_ = this.Keys();
         _loc3_ = this.Values();
         _loc4_ = "HashMap Content:\n";
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc4_ += _loc2_[_loc1_] + " -> " + _loc3_[_loc1_] + "\n";
            _loc1_++;
         }
         return _loc4_;
      }
   }
}

