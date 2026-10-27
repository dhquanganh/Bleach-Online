package Logics.CustomHero
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TCurHero
   {
      
      protected var FLevel:uint;
      
      protected var FIdentifier:uint;
      
      protected var FHeroName:String;
      
      protected var FHeroCongfig:TCustomHeroInfo;
      
      protected var FHeroGrowths:Vector.<uint>;
      
      protected var FHeroSkills:Vector.<uint>;
      
      protected var FCurGrowth:Vector.<Number>;
      
      protected var FCurExtra:Vector.<uint>;
      
      protected var FCurSkill:uint;
      
      public function TCurHero()
      {
         super();
         this.FHeroCongfig = new TCustomHeroInfo();
         this.FCurGrowth = new Vector.<Number>();
         this.FCurExtra = new Vector.<uint>();
      }
      
      protected function ValidGrowthLv() : int
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHeroGrowths.length);
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(this.FLevel >= this.FHeroGrowths[_loc1_])
            {
               return _loc1_ + 1;
            }
            _loc1_--;
         }
         return 0;
      }
      
      protected function ValidSkillLv() : int
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHeroSkills.length);
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(this.FLevel >= this.FHeroSkills[_loc1_])
            {
               return _loc1_ + 1;
            }
            _loc1_--;
         }
         return 1;
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
      
      public function get CurGrowth() : Vector.<Number>
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = this.FHeroCongfig.Growth.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FCurGrowth[_loc2_] = this.FHeroCongfig.Growth[_loc2_] * this.ValidGrowthLv();
            _loc2_++;
         }
         return this.FCurGrowth;
      }
      
      public function get CurExtra() : Vector.<uint>
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = this.FHeroCongfig.BasisGrow.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FLevel > 0)
            {
               this.FCurExtra[_loc2_] = this.FHeroCongfig.BasisGrow[_loc2_] * this.FLevel + this.FHeroCongfig.BasicNumber[_loc2_];
            }
            else
            {
               this.FCurExtra[_loc2_] = 0;
            }
            _loc2_++;
         }
         return this.FCurExtra;
      }
      
      public function get CurSkill() : uint
      {
         if(this.FHeroCongfig.ExclusiveSkill.length > 0)
         {
            this.FCurSkill = this.FHeroCongfig.ExclusiveSkill[this.ValidSkillLv() - 1];
            return this.FCurSkill;
         }
         return 0;
      }
      
      public function get CurSkillDesc() : String
      {
         var _loc1_:String = null;
         if(this.FHeroCongfig.ExclusiveSkill.length > 0)
         {
            _loc1_ = (SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FHeroCongfig.ExclusiveSkill[this.ValidSkillLv() - 1]) as TSkillConfig).Desc;
         }
         else
         {
            _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText15);
         }
         return _loc1_;
      }
      
      public function set HeroGrowths(param1:Vector.<uint>) : void
      {
         this.FHeroGrowths = param1;
      }
      
      public function set HeroSkills(param1:Vector.<uint>) : void
      {
         this.FHeroSkills = param1;
      }
      
      public function get HeroName() : String
      {
         return this.FHeroName;
      }
      
      public function set HeroName(param1:String) : void
      {
         this.FHeroName = param1;
      }
   }
}

