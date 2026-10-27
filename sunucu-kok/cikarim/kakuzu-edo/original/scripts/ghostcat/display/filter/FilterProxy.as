package ghostcat.display.filter
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.filters.BitmapFilter;
   import flash.geom.Point;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import ghostcat.util.Util;
   import ghostcat.util.core.UniqueCall;
   
   use namespace flash_proxy;
   
   public dynamic class FilterProxy extends Proxy
   {
      
      public var filter:BitmapFilter;
      
      public var autoUpdateIndex:Boolean = false;
      
      public var callLater:Boolean;
      
      public var owner:DisplayObject;
      
      private var _index:int = -1;
      
      private var caller:UniqueCall;
      
      public function FilterProxy(param1:BitmapFilter = null, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.filter = param1;
         this.autoUpdateIndex = param2;
         this.callLater = param3;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function updateIndex() : int
      {
         var _loc1_:int = 0;
         if(this._index != -1 && Boolean(this.owner))
         {
            if(Util.equal(this.owner.filters[this._index],this.filter))
            {
               return this._index;
            }
            _loc1_ = 0;
            while(_loc1_ < this.owner.filters.length)
            {
               if(_loc1_ != this._index && Util.equal(this.owner.filters[_loc1_],this.filter))
               {
                  this._index = _loc1_;
                  return this._index;
               }
               _loc1_++;
            }
         }
         this._index = -1;
         return this._index;
      }
      
      public function applyFilter(param1:*) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Array = null;
         if(!this.filter)
         {
            return;
         }
         if(param1 is BitmapData)
         {
            _loc2_ = param1 as BitmapData;
            _loc2_.applyFilter(_loc2_,_loc2_.rect,new Point(),this.filter);
         }
         else if(param1 is DisplayObject)
         {
            this.owner = param1 as DisplayObject;
            _loc3_ = this.owner.filters;
            if(_loc3_.length > 0)
            {
               _loc3_.push(this.filter);
               this.owner.filters = _loc3_;
               this._index = _loc3_.length - 1;
            }
            else
            {
               this.owner.filters = [this.filter];
               this._index = 0;
            }
         }
         if(this.callLater)
         {
            this.caller = new UniqueCall(this.updateFilter);
         }
      }
      
      public function changeFilter(param1:BitmapFilter) : void
      {
         this.updateIndex();
         this.filter = param1;
         this.updateFilter();
      }
      
      public function removeFilter() : void
      {
         var _loc1_:Array = null;
         this.updateIndex();
         if(this.index != -1)
         {
            _loc1_ = this.owner.filters;
            _loc1_.splice(this.index,1);
            this.owner.filters = _loc1_;
         }
         this.owner = null;
      }
      
      public function updateFilter() : void
      {
         var _loc1_:Array = null;
         if(Boolean(this.owner) && this.index != -1)
         {
            _loc1_ = this.owner.filters;
            if(!_loc1_[this.index])
            {
               this.updateIndex();
            }
            if(_loc1_[this.index])
            {
               _loc1_[this.index] = this.filter;
            }
            this.owner.filters = _loc1_;
         }
      }
      
      public function destory() : void
      {
         this.owner = null;
         if(this.caller)
         {
            this.caller.destory();
         }
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.filter ? this.filter[param1] : null;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         if(this.autoUpdateIndex)
         {
            this.updateIndex();
         }
         if(this.filter)
         {
            this.filter[param1] = param2;
         }
         if(this.callLater)
         {
            this.caller.invalidate();
         }
         else
         {
            this.updateFilter();
         }
      }
   }
}

