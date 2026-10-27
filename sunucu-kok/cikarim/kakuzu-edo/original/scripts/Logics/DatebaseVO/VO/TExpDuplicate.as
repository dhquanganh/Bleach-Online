package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TExpDuplicate extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FLvLimit:int;
      
      protected var FNeedSilver:int;
      
      protected var FDiffArg:int;
      
      protected var FRewardTxt:int;
      
      public function TExpDuplicate()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FLvLimit = param1.readInt();
         this.FNeedSilver = param1.readInt();
         this.FDiffArg = param1.readInt();
         this.FRewardTxt = param1.readInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get LvLimit() : int
      {
         return this.FLvLimit;
      }
      
      public function get NeedSilver() : int
      {
         return this.FNeedSilver;
      }
      
      public function get RewardTxt() : int
      {
         return this.FRewardTxt;
      }
      
      public function get DiffArg() : int
      {
         return this.FDiffArg;
      }
   }
}

