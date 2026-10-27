package Logics.HDActivityRecharge
{
   public class TAwardData
   {
      
      protected var FName:String;
      
      protected var FItemIdList:Vector.<uint>;
      
      protected var FState:int;
      
      protected var FBoxIndex:int;
      
      public function TAwardData()
      {
         super();
         this.FItemIdList = new Vector.<uint>();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get ItemIdList() : Vector.<uint>
      {
         return this.FItemIdList;
      }
      
      public function set ItemIdList(param1:Vector.<uint>) : void
      {
         this.FItemIdList = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get BoxIndex() : int
      {
         return this.FBoxIndex;
      }
      
      public function set BoxIndex(param1:int) : void
      {
         this.FBoxIndex = param1;
      }
   }
}

