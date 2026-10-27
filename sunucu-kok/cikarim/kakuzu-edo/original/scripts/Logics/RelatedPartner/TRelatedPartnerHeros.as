package Logics.RelatedPartner
{
   public class TRelatedPartnerHeros
   {
      
      protected var FIsInit:Boolean;
      
      protected var FHeroDatas:Vector.<TRelatedPartnerHero>;
      
      public function TRelatedPartnerHeros()
      {
         super();
         this.FHeroDatas = new Vector.<TRelatedPartnerHero>();
      }
      
      public function get Count() : int
      {
         return this.FHeroDatas.length;
      }
      
      public function get IsInit() : Boolean
      {
         return this.FIsInit;
      }
      
      public function set IsInit(param1:Boolean) : void
      {
         this.FIsInit = param1;
      }
      
      public function GetHeroDataByIndex(param1:int) : TRelatedPartnerHero
      {
         return this.FHeroDatas[param1];
      }
      
      public function ClearSkill() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TRelatedPartnerHero = null;
         _loc1_ = int(this.FHeroDatas.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc5_ = this.FHeroDatas[_loc2_];
            _loc3_ = int(_loc5_.HeroSkills.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_.HeroSkills[_loc4_].SkillId = 0;
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRelatedPartnerHero = null;
         _loc1_ = int(this.FHeroDatas.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FHeroDatas[_loc2_];
            _loc2_++;
         }
         this.FHeroDatas.length = 0;
      }
      
      public function Add(param1:TRelatedPartnerHero) : void
      {
         this.FHeroDatas.push(param1);
      }
      
      public function GetHeroDataByIdentifier(param1:uint) : TRelatedPartnerHero
      {
         var _loc2_:int = 0;
         var _loc3_:TRelatedPartnerHero = null;
         var _loc4_:TRelatedPartnerHero = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FHeroDatas[_loc2_];
            if(_loc3_.HeroId == param1)
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TRelatedPartnerHero = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FHeroDatas[_loc2_];
            if(_loc3_.HeroId == param1)
            {
               this.FHeroDatas.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
   }
}

