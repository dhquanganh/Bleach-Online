package Logics.Skills
{
   public class TSkills
   {
      
      protected var FSkills:Vector.<TSkill>;
      
      public function TSkills()
      {
         super();
         this.FSkills = new Vector.<TSkill>();
      }
      
      public function get Count() : int
      {
         return this.FSkills.length;
      }
      
      public function GetSkillByIndex(param1:int) : TSkill
      {
         return this.FSkills[param1];
      }
      
      protected function SortMount(param1:TSkill, param2:TSkill) : int
      {
         if(param1.Sort < param2.Sort)
         {
            return -1;
         }
         return 1;
      }
      
      protected function HeroSortMount(param1:TSkill, param2:TSkill) : int
      {
         if(param1.Mounted || param2.Mounted)
         {
            if(param1.Mounted)
            {
               return -1;
            }
            return 1;
         }
         if(param1.Sort < param2.Sort)
         {
            return -1;
         }
         return 1;
      }
      
      public function GetSkillByIdentifier(param1:uint) : TSkill
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSkill = null;
         _loc2_ = int(this.FSkills.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FSkills[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSkill = null;
         _loc1_ = int(this.FSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FSkills[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FSkills.length = 0;
      }
      
      public function Add(param1:TSkill) : void
      {
         param1.StubReferences.Reference(this);
         this.FSkills.push(param1);
      }
      
      public function Sort() : void
      {
         this.FSkills.sort(this.SortMount);
      }
      
      public function HeroSort() : void
      {
         this.FSkills.sort(this.HeroSortMount);
      }
      
      public function GetMountSkillId() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSkill = null;
         _loc1_ = int(this.FSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FSkills[_loc2_];
            if(_loc3_.Mounted)
            {
               return _loc3_.Identifier;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function ChangeMountSkill(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSkill = null;
         _loc2_ = int(this.FSkills.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FSkills[_loc3_];
            if(_loc4_.Mounted)
            {
               _loc4_.Mounted = false;
            }
            if(_loc4_.Identifier == param1)
            {
               _loc4_.Mounted = true;
            }
            _loc3_++;
         }
      }
   }
}

