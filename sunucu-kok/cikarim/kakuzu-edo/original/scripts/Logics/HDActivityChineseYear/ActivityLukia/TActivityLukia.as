package Logics.HDActivityChineseYear.ActivityLukia
{
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivityLukia
   {
      
      protected var FIndex:int;
      
      protected var FLukiaID:uint;
      
      protected var FEnlistNeed:uint;
      
      protected var FIfEnlist:Boolean;
      
      protected var FStatus:int;
      
      public function TActivityLukia(param1:Object)
      {
         super();
         this.FIndex = param1.index;
         this.FLukiaID = param1.heroID;
         this.FEnlistNeed = param1.keys[0].amount;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function get LukiaID() : uint
      {
         return this.FLukiaID;
      }
      
      public function get EnlistNeed() : uint
      {
         return this.FEnlistNeed;
      }
      
      public function get IfEnlist() : Boolean
      {
         return this.FIfEnlist;
      }
      
      public function set IfEnlist(param1:Boolean) : void
      {
         this.FIfEnlist = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function UpdateState(param1:int, param2:int) : void
      {
         this.FStatus = param2;
         if(param1 == this.FIndex)
         {
            if(param2 == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               this.FIfEnlist = true;
            }
            else
            {
               this.FIfEnlist = false;
            }
         }
      }
      
      public function FlushActivityData(param1:int, param2:int) : void
      {
         if(param1 == this.FIndex)
         {
            this.FStatus = param2;
            if(param2 == 1)
            {
               this.FIfEnlist = true;
            }
            else
            {
               this.FIfEnlist = false;
            }
         }
      }
   }
}

