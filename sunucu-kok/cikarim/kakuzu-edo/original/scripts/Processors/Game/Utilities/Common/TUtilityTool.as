package Processors.Game.Utilities.Common
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.HDActivityMode.THDBoxStateData;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUtilityTool
   {
      
      public static const Operate_Add:int = 1;
      
      public static const Operate_Multiply:int = 2;
      
      public function TUtilityTool()
      {
         super();
      }
      
      public static function GetPropertyDesc(param1:Vector.<Object>) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:TSkillConfig = null;
         _loc2_ = "";
         for each(_loc6_ in param1)
         {
            if(_loc6_.oper == 0)
            {
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc6_.value) as TSkillConfig;
               _loc2_ += _loc7_.Desc;
            }
            else
            {
               _loc2_ += TUtilityLobby.GetAttributeName(_loc6_.type);
               if(_loc6_.oper == Operate_Multiply)
               {
                  _loc5_ = _loc6_.value * 100;
                  _loc2_ += "+" + _loc5_.toFixed(2) + "%";
               }
               else if(_loc6_.oper == Operate_Add)
               {
                  if(_loc6_.value < 1)
                  {
                     _loc2_ += "+" + (_loc6_.value * 100).toFixed(2) + "%";
                  }
                  else
                  {
                     _loc2_ += "+" + _loc6_.value;
                  }
               }
            }
            _loc2_ += " ";
         }
         return _loc2_;
      }
      
      public static function GetDayByYearMonth(param1:uint, param2:uint) : uint
      {
         var _loc3_:Vector.<int> = Vector.<int>([0,31,28,31,30,31,30,31,31,30,31,30,31]);
         if(param1 % 400 == 0 || param1 % 100 != 0 && param1 % 4 == 0)
         {
            param2[2] += 1;
         }
         return _loc3_[param2];
      }
      
      public static function GetRandom(param1:Number, param2:Number) : Number
      {
         return Math.random() * (param1 - param2) + param2;
      }
      
      public static function VecToArr(param1:Vector.<Object>) : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         _loc2_ = param1.length;
         _loc4_ = [];
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
         return _loc4_;
      }
      
      public static function ActState(param1:Object) : int
      {
         if(param1 is THDBoxStateData)
         {
            return (param1 as THDBoxStateData).State;
         }
         return (param1 as TActAwardStatusInfo).Status;
      }
      
      public static function ActIntVec(param1:Object) : Vector.<int>
      {
         if(param1 is THDBoxStateData)
         {
            return (param1 as THDBoxStateData).Conditions;
         }
         return (param1 as TActAwardStatusInfo).Condition;
      }
      
      public static function ActStringVec(param1:Object) : Vector.<String>
      {
         if(param1 is THDBoxStateData)
         {
            return null;
         }
         return (param1 as TActAwardStatusInfo).Strs;
      }
      
      public static function GetObjByAtt(param1:Vector.<Object>, param2:String, param3:*) : Object
      {
         var _loc4_:Object = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_[param2] == param3)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function GetValueByBit(param1:uint, param2:uint) : uint
      {
         return param1 >> param2 & 1;
      }
   }
}

