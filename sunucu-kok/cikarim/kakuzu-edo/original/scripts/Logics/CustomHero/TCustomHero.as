package Logics.CustomHero
{
   public class TCustomHero
   {
      
      protected var FLevel:uint;
      
      protected var FIdentifier:uint;
      
      protected var FSkillSwitch:uint;
      
      protected var FSkillNames:Vector.<String>;
      
      protected var FHeroCongfig:TCustomHeroInfo;
      
      protected var FHeroName:String;
      
      public function TCustomHero()
      {
         super();
         this.FHeroCongfig = new TCustomHeroInfo();
         this.FSkillNames = new Vector.<String>();
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get Identifier() : uint
      {
         return this.FIdentifier;
      }
      
      public function set Identifier(param1:uint) : void
      {
         this.FIdentifier = param1;
      }
      
      public function get HeroCongfig() : TCustomHeroInfo
      {
         return this.FHeroCongfig;
      }
      
      public function set HeroCongfig(param1:TCustomHeroInfo) : void
      {
         this.FHeroCongfig = param1;
      }
      
      public function get SkillSwitch() : uint
      {
         return this.FSkillSwitch;
      }
      
      public function set SkillSwitch(param1:uint) : void
      {
         this.FSkillSwitch = param1;
      }
      
      public function get HeroName() : String
      {
         return this.FHeroName;
      }
      
      public function set HeroName(param1:String) : void
      {
         this.FHeroName = param1;
      }
      
      public function get SkillNames() : Vector.<String>
      {
         return this.FSkillNames;
      }
      
      public function set SkillNames(param1:Vector.<String>) : void
      {
         this.FSkillNames = param1;
      }
   }
}

