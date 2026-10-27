package Logics.ReveredBook.Decoder
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TGirlsQuestion;
   import Logics.DatebaseVO.VO.TGirlsRecommend;
   import Logics.DatebaseVO.VO.TGirlsStrategy;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.Items.*;
   import Logics.ReveredBook.TRecommandHeroInfor;
   import Logics.ReveredBook.TRecommandInfor;
   import Logics.ReveredBook.TReveredBookQuestion;
   import Logics.ReveredBook.TReveredBookQuestions;
   import Logics.ReveredBook.TReveredBookStrategy;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.*;
   
   public class TUnstreamizerReveredBook extends TUnstreamizer
   {
      
      public function TUnstreamizerReveredBook()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function ClassifyRecommendInfor(param1:TRecommandInfor, param2:Vector.<TRecommandHeroInfor>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<TRecommandHeroInfor> = null;
         var _loc7_:TRecommandHeroInfor = null;
         _loc5_ = -1;
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param2[_loc3_];
            if(_loc7_.Level != _loc5_)
            {
               _loc6_ = new Vector.<TRecommandHeroInfor>();
               param1.RecommandInfor.push(_loc6_);
               param1.TabName.push(_loc7_.Lable);
               _loc5_ = _loc7_.Level;
            }
            _loc6_.push(_loc7_);
            _loc3_++;
         }
      }
      
      protected function FlushData(param1:Vector.<int>, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            param1.push(_loc3_);
            _loc3_++;
         }
      }
      
      protected function CreateRewardTextByRewards(param1:TRewards) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = int(param1.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ += SToolReward.GetNameByTypeCode(param1.Type[_loc2_],param1.Code[_loc2_]) + "*" + param1.Amount[_loc2_] + "\n";
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function CreateRewardText(param1:Vector.<TRewards>, param2:Vector.<String>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.CreateRewardTextByRewards(param1[_loc3_]);
            param2.push(_loc5_);
            _loc3_++;
         }
      }
      
      public function UnstreamizationRecommandInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBins = null;
         var _loc7_:TGirlsRecommend = null;
         var _loc8_:TRecommandInfor = null;
         var _loc9_:Vector.<TRecommandHeroInfor> = null;
         var _loc10_:TRecommandHeroInfor = null;
         var _loc11_:TRoleModel = null;
         _loc8_ = param2 as TRecommandInfor;
         _loc9_ = new Vector.<TRecommandHeroInfor>();
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GirlsRecommend);
         _loc5_ = _loc6_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = new TRecommandHeroInfor();
            _loc7_ = _loc6_.GetDatebaseByIndex(_loc4_) as TGirlsRecommend;
            _loc10_.HeroID = _loc7_.HeroID;
            _loc10_.Description = _loc7_.Description;
            _loc10_.Level = _loc7_.Level;
            _loc10_.Lable = _loc7_.Lable;
            _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc10_.HeroID) as TRoleModel;
            _loc10_.SmallIconID = _loc11_.RoleHead;
            _loc9_.push(_loc10_);
            _loc4_++;
         }
         this.ClassifyRecommendInfor(_loc8_,_loc9_);
         _loc9_.length = 0;
      }
      
      public function UnstreamizationQuestion(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBins = null;
         var _loc5_:TReveredBookQuestions = null;
         var _loc6_:TReveredBookQuestion = null;
         var _loc7_:TGirlsQuestion = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc5_ = param2 as TReveredBookQuestions;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GirlQuestion);
         _loc9_ = _loc4_.Count;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = new TReveredBookQuestion();
            _loc7_ = _loc4_.GetDatebaseByIndex(_loc8_) as TGirlsQuestion;
            _loc6_.ID = _loc7_.Identifier;
            _loc6_.Level = _loc7_.Level;
            _loc6_.Responded = _loc7_.Responds;
            _loc6_.Question = _loc7_.Question;
            _loc6_.Answers = _loc7_.Answers;
            this.FlushData(_loc6_.InitialIndex,_loc6_.Answers.length);
            this.CreateRewardText(_loc7_.Rewards,_loc6_.Rewards);
            _loc5_.Questions.push(_loc6_);
            _loc8_++;
         }
      }
      
      public function UnstreamizationStrategy(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBins = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TReveredBookStrategy = null;
         var _loc8_:TGirlsStrategy = null;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GirlStrategy);
         _loc7_ = param2 as TReveredBookStrategy;
         _loc6_ = _loc4_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = _loc4_.GetDatebaseByIndex(_loc5_) as TGirlsStrategy;
            _loc7_.TabNames.push(_loc8_.TabName);
            _loc7_.Contents.push(_loc8_.Content);
            _loc5_++;
         }
      }
   }
}

