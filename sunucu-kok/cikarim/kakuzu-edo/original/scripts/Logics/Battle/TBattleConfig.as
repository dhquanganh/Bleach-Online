package Logics.Battle
{
   public class TBattleConfig
   {
      
      private static var FORMATION_X1:Array = [[470,315,205],[510,355,245],[430,275,165],[540,385,275],[400,245,135]];
      
      public static var FORMATION_X2:Array = [[780,935,1045],[740,895,1005],[820,975,1085],[710,865,975],[850,1005,1115]];
      
      private static const FORMATION_Y:Array = [520,455,585,420,620];
      
      protected var FORMATION_POS_0_1:Vector.<int>;
      
      protected var FORMATION_POS_0_2:Vector.<int>;
      
      protected var FORMATION_POS_0_3:Vector.<int>;
      
      protected var FORMATION_POS_0_4:Vector.<int>;
      
      protected var FORMATION_POS_0_5:Vector.<int>;
      
      protected var FORMATION_POS_0_6:Vector.<int>;
      
      protected var FORMATION_POS_0_7:Vector.<int>;
      
      protected var FORMATION_POS_0_8:Vector.<int>;
      
      protected var FORMATION_POS_0_9:Vector.<int>;
      
      protected var FORMATION_POS_0_10:Vector.<int>;
      
      protected var FORMATION_POS_0_11:Vector.<int>;
      
      protected var FORMATION_POS_0_12:Vector.<int>;
      
      protected var FORMATION_POS_0_13:Vector.<int>;
      
      protected var FORMATION_POS_0_14:Vector.<int>;
      
      protected var FORMATION_POS_0_15:Vector.<int>;
      
      protected var FORMATION_POS_1_1:Vector.<int>;
      
      protected var FORMATION_POS_1_2:Vector.<int>;
      
      protected var FORMATION_POS_1_3:Vector.<int>;
      
      protected var FORMATION_POS_1_4:Vector.<int>;
      
      protected var FORMATION_POS_1_5:Vector.<int>;
      
      protected var FORMATION_POS_1_6:Vector.<int>;
      
      protected var FORMATION_POS_1_7:Vector.<int>;
      
      protected var FORMATION_POS_1_8:Vector.<int>;
      
      protected var FORMATION_POS_1_9:Vector.<int>;
      
      protected var FORMATION_POS_1_10:Vector.<int>;
      
      protected var FORMATION_POS_1_11:Vector.<int>;
      
      protected var FORMATION_POS_1_12:Vector.<int>;
      
      protected var FORMATION_POS_1_13:Vector.<int>;
      
      protected var FORMATION_POS_1_14:Vector.<int>;
      
      protected var FORMATION_POS_1_15:Vector.<int>;
      
      public const SHOWIDX:Vector.<int> = Vector.<int>([4,9,14,2,7,12,1,6,11,3,8,13,5,10,15]);
      
      public const Type_PostionX:int = 0;
      
      public const Type_PostionY:int = 1;
      
      public function TBattleConfig()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super();
         if(false)
         {
            _loc1_ = 100;
            _loc2_ = 150;
         }
         FORMATION_X1 = [[470 - _loc1_,315 - _loc1_,205 - _loc1_],[510 - _loc1_,355 - _loc1_,245 - _loc1_],[430 - _loc1_,275 - _loc1_,165 - _loc1_],[540 - _loc1_,385 - _loc1_,275 - _loc1_],[400 - _loc1_,245 - _loc1_,135 - _loc1_]];
         FORMATION_X2 = [[780 - _loc2_,935 - _loc2_,1045 - _loc2_],[740 - _loc2_,895 - _loc2_,1005 - _loc2_],[820 - _loc2_,975 - _loc2_,1085 - _loc2_],[710 - _loc2_,865 - _loc2_,975 - _loc2_],[850 - _loc2_,1005 - _loc2_,1115 - _loc2_]];
         this.FORMATION_POS_0_1 = Vector.<int>([FORMATION_X1[0][0],FORMATION_Y[0]]);
         this.FORMATION_POS_0_2 = Vector.<int>([FORMATION_X1[1][0],FORMATION_Y[1]]);
         this.FORMATION_POS_0_3 = Vector.<int>([FORMATION_X1[2][0],FORMATION_Y[2]]);
         this.FORMATION_POS_0_4 = Vector.<int>([FORMATION_X1[3][0],FORMATION_Y[3]]);
         this.FORMATION_POS_0_5 = Vector.<int>([FORMATION_X1[4][0],FORMATION_Y[4]]);
         this.FORMATION_POS_0_6 = Vector.<int>([FORMATION_X1[0][1],FORMATION_Y[0]]);
         this.FORMATION_POS_0_7 = Vector.<int>([FORMATION_X1[1][1],FORMATION_Y[1]]);
         this.FORMATION_POS_0_8 = Vector.<int>([FORMATION_X1[2][1],FORMATION_Y[2]]);
         this.FORMATION_POS_0_9 = Vector.<int>([FORMATION_X1[3][1],FORMATION_Y[3]]);
         this.FORMATION_POS_0_10 = Vector.<int>([FORMATION_X1[4][1],FORMATION_Y[4]]);
         this.FORMATION_POS_0_11 = Vector.<int>([FORMATION_X1[0][2],FORMATION_Y[0]]);
         this.FORMATION_POS_0_12 = Vector.<int>([FORMATION_X1[1][2],FORMATION_Y[1]]);
         this.FORMATION_POS_0_13 = Vector.<int>([FORMATION_X1[2][2],FORMATION_Y[2]]);
         this.FORMATION_POS_0_14 = Vector.<int>([FORMATION_X1[3][2],FORMATION_Y[3]]);
         this.FORMATION_POS_0_15 = Vector.<int>([FORMATION_X1[4][2],FORMATION_Y[4]]);
         this.FORMATION_POS_1_1 = Vector.<int>([FORMATION_X2[0][0],FORMATION_Y[0]]);
         this.FORMATION_POS_1_2 = Vector.<int>([FORMATION_X2[1][0],FORMATION_Y[1]]);
         this.FORMATION_POS_1_3 = Vector.<int>([FORMATION_X2[2][0],FORMATION_Y[2]]);
         this.FORMATION_POS_1_4 = Vector.<int>([FORMATION_X2[3][0],FORMATION_Y[3]]);
         this.FORMATION_POS_1_5 = Vector.<int>([FORMATION_X2[4][0],FORMATION_Y[4]]);
         this.FORMATION_POS_1_6 = Vector.<int>([FORMATION_X2[0][1],FORMATION_Y[0]]);
         this.FORMATION_POS_1_7 = Vector.<int>([FORMATION_X2[1][1],FORMATION_Y[1]]);
         this.FORMATION_POS_1_8 = Vector.<int>([FORMATION_X2[2][1],FORMATION_Y[2]]);
         this.FORMATION_POS_1_9 = Vector.<int>([FORMATION_X2[3][1],FORMATION_Y[3]]);
         this.FORMATION_POS_1_10 = Vector.<int>([FORMATION_X2[4][1],FORMATION_Y[4]]);
         this.FORMATION_POS_1_11 = Vector.<int>([FORMATION_X2[0][2],FORMATION_Y[0]]);
         this.FORMATION_POS_1_12 = Vector.<int>([FORMATION_X2[1][2],FORMATION_Y[1]]);
         this.FORMATION_POS_1_13 = Vector.<int>([FORMATION_X2[2][2],FORMATION_Y[2]]);
         this.FORMATION_POS_1_14 = Vector.<int>([FORMATION_X2[3][2],FORMATION_Y[3]]);
         this.FORMATION_POS_1_15 = Vector.<int>([FORMATION_X2[4][2],FORMATION_Y[4]]);
      }
      
      public function GetPostionByCamyPos(param1:int, param2:int, param3:int) : Number
      {
         if(param1 != 0 && param1 != 1)
         {
            return 0;
         }
         if(param2 < 1 && param2 > 15)
         {
            return 0;
         }
         if(param3 != 0 && param3 != 1)
         {
            return 0;
         }
         return this["FORMATION_POS_" + param1 + "_" + param2][param3];
      }
   }
}

