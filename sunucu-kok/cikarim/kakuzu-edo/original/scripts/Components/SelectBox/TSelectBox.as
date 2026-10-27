package Components.SelectBox
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TSelectBox
   {
      
      public static const State_Select:int = 1;
      
      public static const State_Unselect:int = 2;
      
      protected var FMC_Tasks:Vector.<MovieClip>;
      
      protected var FCallBackOnSelect:Function;
      
      protected var FCallBackOnUnselect:Function;
      
      public function TSelectBox()
      {
         super();
         this.FMC_Tasks = new Vector.<MovieClip>();
      }
      
      public function Init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < this.FMC_Tasks.length)
         {
            _loc2_ = this.FMC_Tasks[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.buttonMode = true;
               _loc2_.addEventListener(MouseEvent.CLICK,this.OnTaskClick);
            }
            _loc1_++;
         }
         this.UnselectAll();
      }
      
      protected function OnTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_Tasks.indexOf(_loc3_);
         if(_loc3_.currentFrame == State_Unselect)
         {
            _loc3_.gotoAndStop(State_Select);
         }
         else
         {
            _loc3_.gotoAndStop(State_Unselect);
         }
         if(this.FCallBackOnSelect != null && _loc3_.currentFrame == State_Select)
         {
            this.FCallBackOnSelect(_loc3_.currentFrame,_loc2_);
         }
         else if(this.FCallBackOnUnselect != null && _loc3_.currentFrame == State_Unselect)
         {
            this.FCallBackOnUnselect(_loc3_.currentFrame,_loc2_);
         }
      }
      
      public function SetTaskByIndex(param1:int, param2:MovieClip) : void
      {
         this.FMC_Tasks[param1] = param2;
      }
      
      public function set CallBackOnSelect(param1:Function) : void
      {
         this.FCallBackOnSelect = param1;
      }
      
      public function set CallBackOnUnselect(param1:Function) : void
      {
         this.FCallBackOnUnselect = param1;
      }
      
      public function SetSelectByIndex(param1:int) : void
      {
         this.FMC_Tasks[param1].gotoAndStop(State_Select);
      }
      
      public function SetUnselectByIndex(param1:int) : void
      {
         this.FMC_Tasks[param1].gotoAndStop(State_Unselect);
      }
      
      public function SelectAll() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FMC_Tasks.length)
         {
            this.SetSelectByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      public function UnselectAll() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FMC_Tasks.length)
         {
            this.SetUnselectByIndex(_loc1_);
            _loc1_++;
         }
      }
   }
}

