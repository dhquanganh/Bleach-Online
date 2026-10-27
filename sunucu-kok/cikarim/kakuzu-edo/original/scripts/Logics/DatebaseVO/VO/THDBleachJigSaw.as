package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDBleachJigsaw.TActivityBJBtnAward;
   import Logics.HDBleachJigsaw.TActivityBJFinalAward;
   import Logics.HDBleachJigsaw.TActivityBJItem;
   import Logics.HDBleachJigsaw.TActivityBJNeed;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDBleachJigSaw extends THDActivityBase
   {
      
      protected var FJigSawItemsVec:Vector.<TActivityBJItem>;
      
      protected var FJigSawNeedsVec:Vector.<Vector.<TActivityBJNeed>>;
      
      protected var FJigSawNeedsBVec:Vector.<TActivityBJNeed>;
      
      protected var FJigSawBtnVec:Vector.<TActivityBJBtnAward>;
      
      protected var FJigSawFinalAwardVec:Vector.<TActivityBJFinalAward>;
      
      public function THDBleachJigSaw()
      {
         super();
         this.FJigSawBtnVec = new Vector.<TActivityBJBtnAward>(3);
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:TActivityBJItem = null;
         var _loc10_:TActivityBJNeed = null;
         var _loc11_:TActivityBJBtnAward = null;
         var _loc12_:TActivityBJFinalAward = null;
         FName = TUtilityString.FetchUTF(param1);
         FTName = TUtilityString.FetchUTF(param1);
         FDesc = TUtilityString.FetchUTF(param1);
         FTip = TUtilityString.FetchUTF(param1);
         FPrice = param1.readUnsignedInt();
         FImageID = param1.readUnsignedInt();
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         _loc3_ = int(_loc7_.length);
         this.FJigSawItemsVec = new Vector.<TActivityBJItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = new TActivityBJItem(_loc7_[_loc2_].index);
            _loc9_.Cost = _loc7_[_loc2_].cost;
            _loc9_.Award = _loc7_[_loc2_].award[0];
            this.FJigSawItemsVec[_loc2_] = _loc9_;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         _loc3_ = int(_loc7_.length);
         this.FJigSawNeedsVec = new Vector.<Vector.<TActivityBJNeed>>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = int(_loc7_[_loc2_].costChip.length);
            this.FJigSawNeedsBVec = new Vector.<TActivityBJNeed>();
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc10_ = new TActivityBJNeed(_loc7_[_loc2_].costChip[_loc4_].chipIndex);
               _loc10_.NeedNum = _loc7_[_loc2_].costChip[_loc4_].amount;
               this.FJigSawNeedsBVec[_loc4_] = _loc10_;
               _loc4_++;
            }
            this.FJigSawNeedsVec[_loc2_] = this.FJigSawNeedsBVec;
            this.FJigSawNeedsVec[_loc2_][0].Award = _loc7_[_loc2_].award[0];
            this.FJigSawNeedsVec[_loc2_][0].BtnIndex = _loc7_[_loc2_].index;
            this.FJigSawNeedsVec[_loc2_][0].Prompt = _loc7_[_loc2_].prompt;
            this.FJigSawNeedsVec[_loc2_][0].Prompt2 = _loc7_[_loc2_].prompt2;
            this.FJigSawNeedsVec[_loc2_][0].Prompt3 = _loc7_[_loc2_].prompt3;
            this.FJigSawNeedsVec[_loc2_][0].Cost = this.FJigSawItemsVec[_loc2_].Cost;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc6_);
         _loc11_ = new TActivityBJBtnAward(_loc8_.index);
         _loc11_.Cost = _loc8_.cost;
         _loc11_.Prompt = TUtilityString.Format(_loc8_.prompt,_loc11_.Cost);
         _loc11_.Prompt2 = _loc8_.prompt2;
         this.FJigSawBtnVec[0] = _loc11_;
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc6_);
         _loc11_ = new TActivityBJBtnAward(_loc8_.index);
         _loc11_.Cost = _loc8_.cost;
         _loc11_.Prompt = TUtilityString.Format(_loc8_.prompt,_loc11_.Cost);
         this.FJigSawBtnVec[1] = _loc11_;
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc6_);
         _loc3_ = int(_loc8_.length);
         _loc11_ = new TActivityBJBtnAward(_loc8_.index);
         _loc11_.Cost = _loc8_.cost;
         _loc11_.Prompt = TUtilityString.Format(_loc8_.prompt,_loc11_.Cost);
         this.FJigSawBtnVec[2] = _loc11_;
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc6_);
         _loc3_ = int(_loc8_.award.length);
         this.FJigSawFinalAwardVec = new Vector.<TActivityBJFinalAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc12_ = new TActivityBJFinalAward(_loc8_.index);
            _loc12_.Award = _loc8_.award[_loc2_];
            this.FJigSawFinalAwardVec[_loc2_] = _loc12_;
            _loc2_++;
         }
         param1.readInt();
      }
      
      public function get JigSawItemsVec() : Vector.<TActivityBJItem>
      {
         return this.FJigSawItemsVec;
      }
      
      public function get JigSawNeedsVec() : Vector.<Vector.<TActivityBJNeed>>
      {
         return this.FJigSawNeedsVec;
      }
      
      public function get JigSawFinalAwardVec() : Vector.<TActivityBJFinalAward>
      {
         return this.FJigSawFinalAwardVec;
      }
      
      public function get JigSawBtnVec() : Vector.<TActivityBJBtnAward>
      {
         return this.FJigSawBtnVec;
      }
   }
}

