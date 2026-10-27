package Logics.HDNewHalloween
{
   import Logics.DatebaseVO.VO.THDNewHalloweenGameConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityNewHalloween.GameVo.TCandyExchangeVo;
   
   public class THDNewHalloweenGameData extends TActivityOSBase
   {
      
      private var FActivityConfig:THDNewHalloweenGameConfig;
      
      private var FCandy:int;
      
      private var FGameTimes:int;
      
      private var FCurTurn:int;
      
      private var FInventories:TInventories;
      
      private var FTitleState:int;
      
      private var FCandyVoVec:Vector.<TCandyExchangeVo>;
      
      public function THDNewHalloweenGameData()
      {
         super();
         this.FCandyVoVec = new Vector.<TCandyExchangeVo>();
      }
      
      public function set ActivityConfig(param1:THDNewHalloweenGameConfig) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get ActivityConfig() : THDNewHalloweenGameConfig
      {
         return this.FActivityConfig;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Candy(param1:int) : void
      {
         this.FCandy = param1;
      }
      
      public function get Candy() : int
      {
         return this.FCandy;
      }
      
      public function set GameTimes(param1:int) : void
      {
         this.FGameTimes = param1;
      }
      
      public function get GameTimes() : int
      {
         return this.FGameTimes;
      }
      
      public function set CurTurn(param1:int) : void
      {
         this.FCurTurn = param1;
      }
      
      public function get CurTurn() : int
      {
         return this.FCurTurn;
      }
      
      public function set TitleState(param1:int) : void
      {
         this.FTitleState = param1;
      }
      
      public function get TitleState() : int
      {
         return this.FTitleState;
      }
      
      public function set CandyVoVec(param1:Vector.<TCandyExchangeVo>) : void
      {
         this.FCandyVoVec = param1;
      }
      
      public function get CandyVoVec() : Vector.<TCandyExchangeVo>
      {
         return this.FCandyVoVec;
      }
   }
}

