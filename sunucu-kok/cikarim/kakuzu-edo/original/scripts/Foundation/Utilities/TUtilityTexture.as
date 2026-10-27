package Foundation.Utilities
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.Map.*;
   import Resources.Constants.*;
   
   public class TUtilityTexture
   {
      
      protected static const EightDirection:Vector.<uint> = Vector.<uint>([CONST_MAP.DIRECTION_UP,CONST_MAP.DIRECTION_RIGHT_UP,CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_RIGHT_DOWN,CONST_MAP.DIRECTION_DOWN,CONST_MAP.DIRECTION_LEFT_DOWN,CONST_MAP.DIRECTION_LEFT,CONST_MAP.DIRECTION_LEFT_UP]);
      
      protected static const EightDirectionStandRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Up,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_TopRight,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Right,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_BottomRight,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Down,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_BottomRight,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Right,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_TopRight]);
      
      protected static const EightDirectionStandRoleScalex:Vector.<int> = Vector.<int>([1,1,1,1,1,-1,-1,-1]);
      
      protected static const EightDirectionRunRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_Up,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_TopRight,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_Right,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_BottomRight,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_Down,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_BottomRight,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_Right,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_TopRight]);
      
      protected static const EightDirectionRunRoleScalex:Vector.<int> = Vector.<int>([1,1,1,1,1,-1,-1,-1]);
      
      protected static const TwoDirection:Vector.<uint> = Vector.<uint>([CONST_MAP.DIRECTION_RIGHT,CONST_MAP.DIRECTION_LEFT]);
      
      protected static const TwoDirectionShowCaseRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase]);
      
      protected static const TwoDirectionShowCaseRoleScalex:Vector.<int> = Vector.<int>([1,-1]);
      
      protected static const TwoDirectionNomralRunRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_NormalRun,CONST_ROLE.ROLE_SEQUENCEINDEX_NormalRun]);
      
      protected static const TwoDirectionNomralRunRoleScalex:Vector.<int> = Vector.<int>([1,-1]);
      
      protected static const TwoDirectionBattleRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby]);
      
      protected static const TwoDirectionBattleRoleScalex:Vector.<int> = Vector.<int>([1,-1]);
      
      protected static const TwoDirectionNomalAttrackRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_NormalAttract,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_NormalAttract]);
      
      protected static const TwoDirectionNomalAttrackRoleScalex:Vector.<int> = Vector.<int>([1,-1]);
      
      protected static const TwoDirectionSkillAttrackRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_SkillAttract,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_SkillAttract]);
      
      protected static const TwoDirectionSkillAttrackRoleScalex:Vector.<int> = Vector.<int>([1,-1]);
      
      protected static const TwoDirectionBlowRoleSequnceId:Vector.<uint> = Vector.<uint>([CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Blow,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Blow]);
      
      protected static const TwoDirectionBlowRoleScalex:Vector.<int> = Vector.<int>([1,-1]);
      
      public function TUtilityTexture()
      {
         super();
         throw new Error("TUtilityTexture Class Is Static Class Only");
      }
      
      protected static function QueryByDirectionArrSequnceArrScalexArr(param1:uint, param2:uint, param3:TMoudleInfor, param4:Vector.<uint>, param5:Vector.<uint>, param6:Vector.<int>) : void
      {
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:TRoleModel = null;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param2) as TRoleModel;
         param2 = _loc9_.Model;
         _loc7_ = param4.indexOf(param1);
         _loc8_ = (param2 << 8) + param5[_loc7_];
         param3.Scalx = param6[_loc7_];
         param3.TextureID = _loc8_;
      }
      
      public static function QueryEightDirectionStandBy(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,EightDirection,EightDirectionStandRoleSequnceId,EightDirectionStandRoleScalex);
      }
      
      public static function QueryEightDirectionRun(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,EightDirection,EightDirectionRunRoleSequnceId,EightDirectionRunRoleScalex);
      }
      
      public static function QueryTwoDirectionShowCase(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,TwoDirection,TwoDirectionShowCaseRoleSequnceId,TwoDirectionShowCaseRoleScalex);
      }
      
      public static function QueryTwoDirectionRun(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,TwoDirection,TwoDirectionNomralRunRoleSequnceId,TwoDirectionNomralRunRoleScalex);
      }
      
      public static function QueryTwoDirectionBattleStandBy(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,TwoDirection,TwoDirectionBattleRoleSequnceId,TwoDirectionBattleRoleScalex);
      }
      
      public static function QueryTwoDirectionNormalAttrack(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,TwoDirection,TwoDirectionNomalAttrackRoleSequnceId,TwoDirectionNomalAttrackRoleScalex);
      }
      
      public static function QueryTwoDirectionSkillAttrack(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,TwoDirection,TwoDirectionSkillAttrackRoleSequnceId,TwoDirectionSkillAttrackRoleScalex);
      }
      
      public static function QueryTwoDirectionBlow(param1:int, param2:uint, param3:TMoudleInfor) : void
      {
         QueryByDirectionArrSequnceArrScalexArr(param1,param2,param3,TwoDirection,TwoDirectionBlowRoleSequnceId,TwoDirectionBlowRoleScalex);
      }
   }
}

