package Logics.NightmareTrial.VO
{
   import Logics.Inventories.TInventories;
   
   public class TNightmareTrialLevelVo
   {
      
      private var FId:int;
      
      private var FInventories:Vector.<TInventories>;
      
      private var FStartLevel:int;
      
      private var FIsStart:Boolean;
      
      private var FTitleName:String;
      
      private var FTxtWordDesc:String;
      
      private var FName:String;
      
      private var FCityDifficultyIdVec:Vector.<int>;
      
      private var FCityDifficlutyIconVec:Vector.<int>;
      
      private var FSelectInfoVo:TSelectInfoVo;
      
      public function TNightmareTrialLevelVo()
      {
         super();
         this.FCityDifficultyIdVec = new Vector.<int>();
         this.FCityDifficlutyIconVec = new Vector.<int>();
         this.FInventories = new Vector.<TInventories>();
      }
      
      public function set Id(param1:int) : void
      {
         this.FId = param1;
      }
      
      public function get Id() : int
      {
         return this.FId;
      }
      
      public function set IsStart(param1:Boolean) : void
      {
         this.FIsStart = param1;
      }
      
      public function get IsStart() : Boolean
      {
         return this.FIsStart;
      }
      
      public function set Inventories(param1:Vector.<TInventories>) : void
      {
         this.FInventories = param1;
      }
      
      public function get Inventories() : Vector.<TInventories>
      {
         return this.FInventories;
      }
      
      public function set CityDifficultyIdVec(param1:Vector.<int>) : void
      {
         this.FCityDifficultyIdVec = param1;
      }
      
      public function get CityDifficultyIdVec() : Vector.<int>
      {
         return this.FCityDifficultyIdVec;
      }
      
      public function set CityDifficlutyIconVec(param1:Vector.<int>) : void
      {
         this.FCityDifficlutyIconVec = param1;
      }
      
      public function get CityDifficlutyIconVec() : Vector.<int>
      {
         return this.FCityDifficlutyIconVec;
      }
      
      public function set StartLevel(param1:int) : void
      {
         this.FStartLevel = param1;
      }
      
      public function get StartLevel() : int
      {
         return this.FStartLevel;
      }
      
      public function set TitleName(param1:String) : void
      {
         this.FTitleName = param1;
      }
      
      public function get TitleName() : String
      {
         return this.FTitleName;
      }
      
      public function set TxtWordDesc(param1:String) : void
      {
         this.FTxtWordDesc = param1;
      }
      
      public function get TxtWordDesc() : String
      {
         return this.FTxtWordDesc;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set SelectInfoVo(param1:TSelectInfoVo) : void
      {
         this.FSelectInfoVo = param1;
      }
      
      public function get SelectInfoVo() : TSelectInfoVo
      {
         return this.FSelectInfoVo;
      }
   }
}

