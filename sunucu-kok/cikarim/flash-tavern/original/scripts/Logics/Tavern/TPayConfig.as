package Logics.Tavern
{
   public class TPayConfig
   {
      
      protected var FID:int;
      
      protected var FKey:String;
      
      protected var FTypes:uint;
      
      protected var FValue:String;
      
      protected var FDesc:String;
      
      protected var FTitle:String;
      
      protected var FContext:String;
      
      protected var FOpenLevel:String;
      
      public function TPayConfig()
      {
         super();
      }
      
      public function get Key() : String
      {
         return this.FKey;
      }
      
      public function set Key(param1:String) : void
      {
         this.FKey = param1;
      }
      
      public function get Value() : String
      {
         return this.FValue;
      }
      
      public function set Value(param1:String) : void
      {
         this.FValue = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
      
      public function get ID() : int
      {
         return this.FID;
      }
      
      public function set ID(param1:int) : void
      {
         this.FID = param1;
      }
      
      public function get Types() : uint
      {
         return this.FTypes;
      }
      
      public function set Types(param1:uint) : void
      {
         this.FTypes = param1;
      }
      
      public function get Title() : String
      {
         return this.FTitle;
      }
      
      public function set Title(param1:String) : void
      {
         this.FTitle = param1;
      }
      
      public function get Context() : String
      {
         return this.FContext;
      }
      
      public function set Context(param1:String) : void
      {
         this.FContext = param1;
      }
      
      public function get OpenLevel() : String
      {
         return this.FOpenLevel;
      }
      
      public function set OpenLevel(param1:String) : void
      {
         this.FOpenLevel = param1;
      }
   }
}

