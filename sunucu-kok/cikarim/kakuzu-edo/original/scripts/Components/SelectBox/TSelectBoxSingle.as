package Components.SelectBox
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TSelectBoxSingle extends TSelectBox
   {
      
      protected var FCurrentSelectIndex:int;
      
      public function TSelectBoxSingle()
      {
         super();
         this.FCurrentSelectIndex = -1;
      }
      
      override public function Init() : void
      {
         super.Init();
         SetSelectByIndex(0);
      }
      
      override protected function OnTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = _loc2_.currentFrame;
         if(_loc3_ == State_Select)
         {
            return;
         }
         UnselectAll();
         super.OnTaskClick(param1);
      }
   }
}

