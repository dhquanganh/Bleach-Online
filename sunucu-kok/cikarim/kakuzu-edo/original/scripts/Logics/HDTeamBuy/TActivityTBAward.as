package Logics.HDTeamBuy
{
   public class TActivityTBAward
   {
      
      protected var FCost:uint;
      
      protected var FAward:uint;
      
      protected var FTitle:String;
      
      public function TActivityTBAward(param1:Object)
      {
         super();
         if(param1.cost != null)
         {
            this.FCost = param1.cost;
         }
         if(param1.award != null)
         {
            this.FAward = param1.award[0];
         }
         if(param1.title != null)
         {
            this.FTitle = param1.title;
         }
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
      
      public function get Title() : String
      {
         return this.FTitle;
      }
   }
}

