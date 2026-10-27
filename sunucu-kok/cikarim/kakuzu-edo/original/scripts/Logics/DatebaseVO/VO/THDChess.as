package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDChess.TActivityChessAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChess extends THDActivityBase
   {
      
      protected var FBoxes:Vector.<uint>;
      
      protected var FFinalAward:Vector.<uint>;
      
      protected var FAchieveAward:Vector.<TActivityChessAward>;
      
      protected var FMaxDiceNum:uint;
      
      protected var FNormalCost:uint;
      
      protected var FControlCost:uint;
      
      protected var FFinalCost:uint;
      
      protected var FCoolDown:uint;
      
      protected var FLocationIndex:uint;
      
      protected var FRefreshFinalIndex:uint;
      
      protected var FFinalBoxIndex:uint;
      
      protected var FNormalIndex:uint;
      
      protected var FControlIndex:uint;
      
      protected var FResetIndex:uint;
      
      protected var FVistaIndex:uint;
      
      protected var FPrompt0:String;
      
      protected var FPrompt1:String;
      
      protected var FPrompt2:String;
      
      public function THDChess()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:TActivityChessAward = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc2_ = _loc5_.length;
         this.FBoxes = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBoxes[_loc3_] = _loc5_[_loc3_];
            _loc3_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         _loc2_ = uint(_loc6_.award.length);
         this.FFinalAward = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FFinalAward[_loc3_] = _loc6_.award[_loc3_];
            _loc3_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc2_ = _loc5_.length;
         this.FAchieveAward = new Vector.<TActivityChessAward>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc7_ = new TActivityChessAward(_loc5_[_loc3_].index);
            _loc7_.Condition[0] = _loc5_[_loc3_].condition[0];
            _loc7_.Condition[1] = _loc5_[_loc3_].condition[1];
            _loc7_.Condition[2] = _loc5_[_loc3_].condition[2];
            _loc7_.Award = _loc5_[_loc3_].award[0];
            this.FAchieveAward[_loc3_] = _loc7_;
            _loc3_++;
         }
         this.FMaxDiceNum = param1.readUnsignedInt();
         this.FNormalCost = param1.readUnsignedInt();
         this.FControlCost = param1.readUnsignedInt();
         this.FFinalCost = param1.readUnsignedInt();
         this.FCoolDown = param1.readUnsignedInt();
         this.FLocationIndex = param1.readUnsignedInt();
         this.FRefreshFinalIndex = param1.readUnsignedInt();
         this.FNormalIndex = param1.readUnsignedInt();
         this.FControlIndex = param1.readUnsignedInt();
         this.FResetIndex = param1.readUnsignedInt();
         this.FVistaIndex = param1.readUnsignedInt();
         this.FPrompt0 = TUtilityString.FetchUTF(param1);
         this.FPrompt1 = TUtilityString.FetchUTF(param1);
         this.FPrompt2 = TUtilityString.FetchUTF(param1);
      }
      
      public function get FinalAward() : Vector.<uint>
      {
         return this.FFinalAward;
      }
      
      public function get AchieveAward() : Vector.<TActivityChessAward>
      {
         return this.FAchieveAward;
      }
      
      public function get MaxDiceNum() : uint
      {
         return this.FMaxDiceNum;
      }
      
      public function get NormalCost() : uint
      {
         return this.FNormalCost;
      }
      
      public function get ControlCost() : uint
      {
         return this.FControlCost;
      }
      
      public function get FinalBoxIndex() : uint
      {
         return this.FFinalBoxIndex;
      }
      
      public function get LocationIndex() : uint
      {
         return this.FLocationIndex;
      }
      
      public function get CoolDown() : uint
      {
         return this.FCoolDown;
      }
      
      public function get RefreshFinalIndex() : uint
      {
         return this.FRefreshFinalIndex;
      }
      
      public function get NormalIndex() : uint
      {
         return this.FNormalIndex;
      }
      
      public function get ControlIndex() : uint
      {
         return this.FControlIndex;
      }
      
      public function get ResetIndex() : uint
      {
         return this.FResetIndex;
      }
      
      public function get VistaIndex() : uint
      {
         return this.FVistaIndex;
      }
      
      public function get FinalCost() : uint
      {
         return this.FFinalCost;
      }
      
      public function get Boxes() : Vector.<uint>
      {
         return this.FBoxes;
      }
      
      public function get Prompt0() : String
      {
         return this.FPrompt0;
      }
      
      public function get Prompt1() : String
      {
         return this.FPrompt1;
      }
      
      public function get Prompt2() : String
      {
         return this.FPrompt2;
      }
   }
}

