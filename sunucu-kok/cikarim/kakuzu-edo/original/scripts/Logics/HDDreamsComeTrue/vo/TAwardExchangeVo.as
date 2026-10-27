package Logics.HDDreamsComeTrue.vo
{
   import Logics.Inventories.TInventories;
   
   public class TAwardExchangeVo
   {
      
      private var FAwardType:int;
      
      private var FAwardName:String;
      
      private var FIndex:int;
      
      private var FInventories:TInventories;
      
      private var FFinishConditionVec:Vector.<TFinishConditionVo>;
      
      private var FHeroId:int;
      
      private var FMaxValue:int;
      
      private var FStatus:int;
      
      private var FLimit:int;
      
      public function TAwardExchangeVo()
      {
         super();
      }
      
      public function get AwardType() : int
      {
         return this.FAwardType;
      }
      
      public function set AwardType(param1:int) : void
      {
         this.FAwardType = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function get MaxValue() : int
      {
         return this.FMaxValue;
      }
      
      public function set MaxValue(param1:int) : void
      {
         this.FMaxValue = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get Limit() : int
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:int) : void
      {
         this.FLimit = param1;
      }
      
      public function get AwardName() : String
      {
         return this.FAwardName;
      }
      
      public function set AwardName(param1:String) : void
      {
         this.FAwardName = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get FinishConditionVec() : Vector.<TFinishConditionVo>
      {
         return this.FFinishConditionVec;
      }
      
      public function set FinishConditionVec(param1:Vector.<TFinishConditionVo>) : void
      {
         this.FFinishConditionVec = param1;
      }
   }
}

