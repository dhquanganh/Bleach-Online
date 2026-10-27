package Logics.HDSwiftChange
{
   public class SwiftChangeVO
   {
      
      protected var FIndex:int;
      
      protected var FCost:int;
      
      protected var FAward:int;
      
      protected var FLimit:int;
      
      protected var FUseLimit:int;
      
      protected var FHeroId:int;
      
      protected var FDebrisHeroName:String;
      
      public function SwiftChangeVO()
      {
         super();
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function set Cost(param1:int) : void
      {
         this.FCost = param1;
      }
      
      public function get Award() : int
      {
         return this.FAward;
      }
      
      public function set Award(param1:int) : void
      {
         this.FAward = param1;
      }
      
      public function get Limit() : int
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:int) : void
      {
         this.FLimit = param1;
      }
      
      public function get UseLimit() : int
      {
         return this.FUseLimit;
      }
      
      public function set UseLimit(param1:int) : void
      {
         this.FUseLimit = param1;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function set DebrisHeroName(param1:String) : void
      {
         this.FDebrisHeroName = param1;
      }
      
      public function get DebrisHeroName() : String
      {
         return this.FDebrisHeroName;
      }
   }
}

