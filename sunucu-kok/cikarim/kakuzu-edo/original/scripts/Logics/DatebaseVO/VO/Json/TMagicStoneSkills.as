package Logics.DatebaseVO.VO.Json
{
   import ghostcat.util.data.Json;
   
   public class TMagicStoneSkills
   {
      
      protected var FSkill:Array;
      
      protected var FWeaponSkillid:Vector.<uint>;
      
      public function TMagicStoneSkills(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         super();
         _loc5_ = Json.decode(String(param1));
         this.FSkill = _loc5_ as Array;
         _loc3_ = int(this.FSkill.length);
         this.FWeaponSkillid = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FSkill[_loc2_];
            this.FWeaponSkillid[_loc2_] = _loc4_.weaponSkillid;
            _loc2_++;
         }
      }
      
      public function get WeaponSkillid() : Vector.<uint>
      {
         return this.FWeaponSkillid;
      }
   }
}

