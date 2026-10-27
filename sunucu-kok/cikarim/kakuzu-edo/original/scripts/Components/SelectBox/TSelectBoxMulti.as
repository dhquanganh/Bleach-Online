package Components.SelectBox
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TSelectBoxMulti extends TSelectBox
   {
      
      protected var FTasksState:Vector.<int>;
      
      public function TSelectBoxMulti()
      {
         super();
      }
      
      override public function Init() : void
      {
         this.FTasksState = new Vector.<int>(FMC_Tasks.length);
         super.Init();
      }
      
      override protected function OnTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = FMC_Tasks.indexOf(_loc3_);
         this.FTasksState[_loc2_] = this.FTasksState[_loc2_] == State_Select ? State_Unselect : State_Select;
         super.OnTaskClick(param1);
      }
      
      public function get TasksState() : Vector.<int>
      {
         return this.FTasksState;
      }
      
      override public function SetSelectByIndex(param1:int) : void
      {
         super.SetSelectByIndex(param1);
         this.FTasksState[param1] = State_Select;
      }
      
      override public function SetUnselectByIndex(param1:int) : void
      {
         super.SetUnselectByIndex(param1);
         this.FTasksState[param1] = State_Unselect;
      }
   }
}

