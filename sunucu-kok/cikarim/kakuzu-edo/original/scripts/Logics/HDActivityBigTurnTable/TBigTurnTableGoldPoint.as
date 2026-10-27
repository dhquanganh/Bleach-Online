package Logics.HDActivityBigTurnTable
{
   public class TBigTurnTableGoldPoint
   {
      
      protected var FIndex:int;
      
      protected var FValue:int;
      
      protected var FName:String;
      
      public function TBigTurnTableGoldPoint(param1:Object)
      {
         super();
         this.FIndex = param1.index;
         this.FName = param1.des;
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function set Value(param1:int) : void
      {
         this.FValue = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
         this.FValue = param2;
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
         this.FValue = param2;
      }
   }
}

