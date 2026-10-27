package Resources.Constants
{
   public class CONST_ROLE
   {
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Up:uint = 0;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_STANDBY_TopRight:uint = 1;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Right:uint = 2;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_STANDBY_BottomRight:uint = 3;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Down:uint = 4;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_RUN_Up:uint = 5;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_RUN_TopRight:uint = 6;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_RUN_Right:uint = 7;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_RUN_BottomRight:uint = 8;
      
      public static const ROLE_SEQUENCEINDEX_NORMAL_RUN_Down:uint = 9;
      
      public static const ROLE_SEQUENCEINDEX_FIGHTING_Standby:uint = 10;
      
      public static const ROLE_SEQUENCEINDEX_FIGHTING_NormalAttract:uint = 11;
      
      public static const ROLE_SEQUENCEINDEX_FIGHTING_SkillAttract:uint = 12;
      
      public static const ROLE_SEQUENCEINDEX_FIGHTING_Blow:uint = 13;
      
      public static const ROLE_SEQUENCEINDEX_Showcase:uint = 14;
      
      public static const ROLE_SEQUENCEINDEX_NormalRun:uint = 15;
      
      public static const AttackSequence_First:uint = 1;
      
      public static const AttackSequence_Second:uint = 0;
      
      public static const MiniBattleType_PVP:uint = 0;
      
      public static const MiniBattleType_PVE:uint = 1;
      
      public function CONST_ROLE()
      {
         super();
      }
      
      public static function GetModelIDByIndex(param1:uint, param2:uint) : uint
      {
         return (param1 << 8) + param2;
      }
   }
}

