package Foundation.LoaderQueue
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class TLoaderProgress extends EventDispatcher
   {
      
      protected var FItems:Vector.<ILoaderAdapter>;
      
      protected var FIsStarted:Boolean = false;
      
      protected var FUpdateInterval:int;
      
      protected var FTotalProgress:Number;
      
      protected var FBytesTotal:Number;
      
      protected var FBytesLoaded:Number;
      
      public function TLoaderProgress()
      {
         super();
         this.FItems = new Vector.<ILoaderAdapter>();
      }
      
      protected function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ILoaderAdapter = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc2_ = int(this.FItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FItems[_loc1_];
            if(!isNaN(_loc3_.BytesLoaded / _loc3_.BytesTotal))
            {
               _loc6_ += _loc3_.BytesLoaded / _loc3_.BytesTotal;
               _loc5_ += _loc3_.BytesLoaded;
               _loc4_ += _loc3_.BytesTotal;
            }
            _loc1_++;
         }
         this.FTotalProgress = _loc6_ / _loc2_;
         this.FBytesLoaded = _loc5_;
         this.FBytesTotal = _loc4_;
         dispatchEvent(new Event(Event.CHANGE));
         if(this.FTotalProgress == 1 || _loc2_ == 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            this.Stop();
         }
      }
      
      public function get Items() : Vector.<ILoaderAdapter>
      {
         return this.FItems;
      }
      
      public function get TotalProgress() : Number
      {
         return this.FTotalProgress;
      }
      
      public function get IsStarted() : Boolean
      {
         return this.FIsStarted;
      }
      
      public function get BytesTotal() : Number
      {
         return this.FBytesTotal;
      }
      
      public function get BytesLoaded() : Number
      {
         return this.FBytesLoaded;
      }
      
      public function AddItem(param1:ILoaderAdapter) : void
      {
         if(this.FItems.indexOf(param1) == -1)
         {
            this.FItems.push(param1);
            if(this.FIsStarted)
            {
               this.Update();
            }
         }
      }
      
      public function RemoveItem(param1:ILoaderAdapter) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FItems.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.FItems.splice(_loc2_,1);
            if(this.FIsStarted)
            {
               this.Update();
            }
         }
      }
      
      public function Start() : void
      {
         this.FUpdateInterval = setInterval(this.Update,500);
         this.FIsStarted = true;
      }
      
      public function Stop() : void
      {
         clearInterval(this.FUpdateInterval);
         this.FIsStarted = false;
      }
      
      public function Clear() : void
      {
         this.Stop();
         if(this.FItems != null)
         {
            this.FItems.length = 0;
         }
      }
      
      public function Dispose() : void
      {
         this.Stop();
         this.FItems = null;
      }
   }
}

