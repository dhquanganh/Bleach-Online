package Logics.HDAstrology.vo
{
   public class TSCStarPicture
   {
      
      private var FStarPicPosition:int;
      
      private var FStarPicIndex:int;
      
      private var FExtractState:int;
      
      private var FStarType:int;
      
      private var FDesc:String;
      
      public function TSCStarPicture()
      {
         super();
      }
      
      public function get StarPicPosition() : int
      {
         return this.FStarPicPosition;
      }
      
      public function set StarPicPosition(param1:int) : void
      {
         this.FStarPicPosition = param1;
      }
      
      public function get StarPicIndex() : int
      {
         return this.FStarPicIndex;
      }
      
      public function set StarPicIndex(param1:int) : void
      {
         this.FStarPicIndex = param1;
      }
      
      public function get ExtractState() : int
      {
         return this.FExtractState;
      }
      
      public function set ExtractState(param1:int) : void
      {
         this.FExtractState = param1;
      }
      
      public function get StarType() : int
      {
         return this.FStarType;
      }
      
      public function set StarType(param1:int) : void
      {
         this.FStarType = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
   }
}

