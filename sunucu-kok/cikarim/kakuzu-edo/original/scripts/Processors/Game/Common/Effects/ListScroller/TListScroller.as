package Processors.Game.Common.Effects.ListScroller
{
   import Components.ScrollBar.TScrollBar;
   import flash.display.MovieClip;
   
   public class TListScroller
   {
      
      protected var FScrollBar:TScrollBar;
      
      protected var FItemList:Vector.<TListScrollerRender>;
      
      protected var FListCount:int;
      
      protected var FCurCount:int;
      
      protected var FHCount:int;
      
      protected var FHSpace:int;
      
      protected var FOffsetX:int;
      
      protected var FOffsetY:int;
      
      public function TListScroller(param1:MovieClip, param2:Number, param3:Boolean = true, param4:Number = 0, param5:Number = 0)
      {
         super();
         this.FScrollBar = new TScrollBar(param1,param2,param3,param4,param5);
         this.FItemList = new Vector.<TListScrollerRender>();
      }
      
      public function get HCount() : int
      {
         return this.FHCount;
      }
      
      public function set HCount(param1:int) : void
      {
         this.FHCount = param1;
      }
      
      public function get HSpace() : int
      {
         return this.FHSpace;
      }
      
      public function set HSpace(param1:int) : void
      {
         this.FHSpace = param1;
      }
      
      public function get OffsetX() : int
      {
         return this.FOffsetX;
      }
      
      public function set OffsetX(param1:int) : void
      {
         this.FOffsetX = param1;
      }
      
      public function get OffsetY() : int
      {
         return this.FOffsetY;
      }
      
      public function set OffsetY(param1:int) : void
      {
         this.FOffsetY = param1;
      }
      
      public function AddItem(param1:IListItemScrollerRender) : void
      {
         if(this.FCurCount == 0)
         {
            this.FItemList[this.FListCount] = new TListScrollerRender(this.FHSpace,this.FOffsetX,this.FOffsetY);
            this.FScrollBar.AddItem(this.FItemList[this.FListCount]);
         }
         this.FItemList[this.FListCount].AddItem(param1);
         ++this.FCurCount;
         if(this.FCurCount >= this.FHCount)
         {
            this.FCurCount = 0;
            ++this.FListCount;
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FCurCount = 0;
         this.FListCount = 0;
         _loc2_ = int(this.FItemList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FItemList[_loc1_].Reset();
            _loc1_++;
         }
         this.FItemList.length = 0;
         this.FScrollBar.Clear();
      }
   }
}

