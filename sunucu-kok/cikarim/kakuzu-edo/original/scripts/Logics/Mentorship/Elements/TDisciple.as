package Logics.Mentorship.Elements
{
   public class TDisciple
   {
      
      protected var FDiscipleID0:uint;
      
      protected var FDiscipleID1:uint;
      
      protected var FDiscipleName:String;
      
      protected var FDiscipleLevel:uint;
      
      protected var FDiscipleHeroID:uint;
      
      protected var FDiscipleGuildName:String;
      
      protected var FInteractionCDTime:uint;
      
      protected var FStartWorkTime:uint;
      
      protected var FDrawTime:uint;
      
      protected var FAddUpExp:uint;
      
      public function TDisciple()
      {
         super();
      }
      
      public function get DiscipleID0() : uint
      {
         return this.FDiscipleID0;
      }
      
      public function set DiscipleID0(param1:uint) : void
      {
         this.FDiscipleID0 = param1;
      }
      
      public function get DiscipleID1() : uint
      {
         return this.FDiscipleID1;
      }
      
      public function set DiscipleID1(param1:uint) : void
      {
         this.FDiscipleID1 = param1;
      }
      
      public function get DiscipleName() : String
      {
         return this.FDiscipleName;
      }
      
      public function set DiscipleName(param1:String) : void
      {
         this.FDiscipleName = param1;
      }
      
      public function get InteractionCDTime() : uint
      {
         return this.FInteractionCDTime;
      }
      
      public function set InteractionCDTime(param1:uint) : void
      {
         this.FInteractionCDTime = param1;
      }
      
      public function get StartWorkTime() : uint
      {
         return this.FStartWorkTime;
      }
      
      public function set StartWorkTime(param1:uint) : void
      {
         this.FStartWorkTime = param1;
      }
      
      public function get DrawTime() : uint
      {
         return this.FDrawTime;
      }
      
      public function set DrawTime(param1:uint) : void
      {
         this.FDrawTime = param1;
      }
      
      public function get DiscipleLevel() : uint
      {
         return this.FDiscipleLevel;
      }
      
      public function set DiscipleLevel(param1:uint) : void
      {
         this.FDiscipleLevel = param1;
      }
      
      public function get DiscipleHeroID() : uint
      {
         return this.FDiscipleHeroID;
      }
      
      public function set DiscipleHeroID(param1:uint) : void
      {
         this.FDiscipleHeroID = param1;
      }
      
      public function get DiscipleGuildName() : String
      {
         return this.FDiscipleGuildName;
      }
      
      public function set DiscipleGuildName(param1:String) : void
      {
         this.FDiscipleGuildName = param1;
      }
      
      public function get AddUpExp() : uint
      {
         return this.FAddUpExp;
      }
      
      public function set AddUpExp(param1:uint) : void
      {
         this.FAddUpExp = param1;
      }
   }
}

