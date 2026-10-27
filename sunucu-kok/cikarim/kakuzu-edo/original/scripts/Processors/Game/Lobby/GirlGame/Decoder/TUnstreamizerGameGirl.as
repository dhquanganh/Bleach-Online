package Processors.Game.Lobby.GirlGame.Decoder
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.*;
   import Foundation.Timing.*;
   import Foundation.Utilities.*;
   import Logics.Arena.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GirlGame.TGirlClothes;
   import Logics.GirlGame.TGirlGameInfor;
   import Logics.GirlGame.TGirlInfor;
   import Logics.SLogicsCore;
   import Logics.Spaces.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerGameGirl extends TUnstreamizer
   {
      
      protected var FDescriptionPrefix:Vector.<String>;
      
      protected var FSiliverModulus:Number;
      
      protected var FPrestigeModulus:Number;
      
      protected var FSoulModulus:Number;
      
      protected var FSuperModulus:Number;
      
      protected var FRewardFunction:Vector.<Function>;
      
      public function TUnstreamizerGameGirl()
      {
         super();
         this.FRewardFunction = new Vector.<Function>();
         this.FRewardFunction.push(this.CounterSiliverCoin);
         this.FRewardFunction.push(this.CounterActionPoint);
         this.FRewardFunction.push(this.CounterPrestige);
         this.FRewardFunction.push(this.CounterSoul);
         this.FRewardFunction.push(this.CounterSiliverCoinSuper);
      }
      
      protected function GetRewardDescriptionPrefix() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         if(this.FDescriptionPrefix != null)
         {
            return;
         }
         this.FDescriptionPrefix = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_01);
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(60320006) as TConfigValue;
         this.FSiliverModulus = _loc2_.Value as Number;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(60320007) as TConfigValue;
         this.FPrestigeModulus = _loc2_.Value as Number;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(60320008) as TConfigValue;
         this.FSoulModulus = _loc2_.Value as Number;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(60320009) as TConfigValue;
         this.FSuperModulus = _loc2_.Value as Number;
      }
      
      protected function GetGirlByID(param1:int, param2:Vector.<TGirlInfor>) : TGirlInfor
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param2[_loc3_].ID == param1)
            {
               return param2[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function CreateGirlRewardString(param1:TGirlInfor) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = int(param1.Clothes.length);
         _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_02),_loc3_ - 1);
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 1)
         {
            _loc4_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_03),_loc3_ - _loc2_,param1.Clothes[_loc2_].RewardString);
            _loc2_--;
         }
         param1.RewardString = _loc4_.substr(0,_loc4_.length - 1);
      }
      
      protected function CreateClothesRewardString(param1:TGirlInfor, param2:int) : void
      {
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Function = null;
         param1.Clothes[0].RewardString = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_04);
         _loc4_ = int(param1.Clothes.length);
         if(param2 != 4)
         {
            _loc3_ = int(_loc4_ - 1);
            while(_loc3_ >= 1)
            {
               _loc5_ = _loc4_ - 1 - _loc3_;
               _loc6_ = this.FRewardFunction[param2];
               param1.Clothes[_loc3_].RewardString = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_05),_loc6_(_loc5_ + 1),param1.RewardName[0]);
               _loc3_--;
            }
         }
         else
         {
            _loc3_ = int(_loc4_ - 1);
            while(_loc3_ >= 1)
            {
               _loc5_ = _loc4_ - 1 - _loc3_;
               param1.Clothes[_loc3_].RewardString = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GameGirl_01),this.CounterSiliverCoinSuper(_loc5_ + 1),param1.RewardName[0],this.CounterActionPoint(_loc5_ + 1),param1.RewardName[1]);
               _loc3_--;
            }
         }
      }
      
      protected function GetRewardName(param1:Vector.<int>, param2:Vector.<int>, param3:Vector.<String>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc5_ = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.GetNameByTypeCode(param1[_loc4_],param2[_loc4_]);
            param3.push(_loc6_);
            _loc4_++;
         }
      }
      
      protected function GetNameByTypeCode(param1:int, param2:int) : String
      {
         var _loc3_:TArticle = null;
         if(param1 == 1)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param2) as TArticle;
            return _loc3_.Name;
         }
         return TUtilityLobby.GetItemName(param1,param2);
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGirlGameInfor = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:TGirlInfor = null;
         var _loc9_:uint = 0;
         _loc4_ = param2 as TGirlGameInfor;
         _loc4_.SingedTime = param1.readUnsignedInt();
         _loc4_.UndressTime = param1.readUnsignedInt();
         _loc4_.AddUndressTime = param1.readUnsignedInt();
         _loc6_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = this.GetGirlByID(_loc7_,_loc4_.GameGirls);
            _loc9_ = param1.readUnsignedInt();
            _loc8_.ScheduleHistory = _loc8_.Clothes.length - _loc9_;
            _loc5_++;
         }
         _loc6_ = int(_loc4_.GameGirls.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_.GameGirls[_loc5_].IfOpen = _loc4_.GameGirls[_loc5_].OpenCondition <= _loc4_.SingedTime;
            _loc5_++;
         }
      }
      
      protected function LoadOneGirlClothesInfor(param1:TGirlInfor, param2:Vector.<int>, param3:TBins) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBeautifulClothes = null;
         var _loc7_:int = 0;
         var _loc8_:TGirlClothes = null;
         _loc5_ = int(param2.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = param2[_loc4_];
            _loc8_ = new TGirlClothes();
            _loc8_.ID = _loc7_;
            _loc6_ = param3.GetDatebaseByIdentifier(_loc7_) as TBeautifulClothes;
            _loc8_.GameBarScore = _loc6_.Scores;
            _loc8_.QuestionTitle = _loc6_.Question;
            _loc8_.QuestionAnswers = _loc6_.Answers;
            _loc8_.TotalSchedule = _loc6_.Scores.length;
            param1.Clothes.push(_loc8_);
            _loc4_++;
         }
      }
      
      public function CounterSiliverCoin(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = uint(SLogicsCore.Character.GetMainRebirthLevel());
         _loc3_ = 1000 * param1 / 3 + 80 * param1 * _loc2_ * this.FSiliverModulus * this.FSiliverModulus;
         _loc4_ = _loc3_ % 1000;
         _loc4_ = _loc4_ == 0 ? 0 : 1;
         return (int(_loc3_ / 1000) + _loc4_) * 1000;
      }
      
      public function CounterActionPoint(param1:uint) : uint
      {
         return param1;
      }
      
      public function CounterPrestige(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(SLogicsCore.Character.GetMainRebirthLevel());
         return 10 * param1 + _loc2_ * this.FPrestigeModulus + 10 + 0.5;
      }
      
      public function CounterSoul(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(SLogicsCore.Character.GetMainRebirthLevel());
         return Math.ceil(100 * param1 / 2 + _loc2_ * this.FSoulModulus * this.FSoulModulus / 2);
      }
      
      public function CounterSiliverCoinSuper(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(SLogicsCore.Character.GetMainRebirthLevel());
         return 1000 * param1 / 3 + 80 * param1 * _loc2_ * this.FSiliverModulus * this.FSiliverModulus * this.FSuperModulus;
      }
      
      public function UnstreamizationByDataBase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGirlGameInfor = null;
         var _loc5_:Vector.<TGirlInfor> = null;
         var _loc6_:TBins = null;
         var _loc7_:TBins = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TGirlInfor = null;
         var _loc11_:TBeauty = null;
         this.GetRewardDescriptionPrefix();
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Beauty);
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BeautifulClothes);
         _loc4_ = param2 as TGirlGameInfor;
         _loc5_ = _loc4_.GameGirls;
         _loc9_ = _loc6_.Count;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = new TGirlInfor();
            _loc11_ = _loc6_.GetDatebaseByIndex(_loc8_) as TBeauty;
            _loc10_.ID = _loc11_.Identifier;
            _loc10_.Name = _loc11_.Name;
            _loc10_.OpenCondition = _loc11_.Day;
            _loc10_.SuccessText = _loc11_.SuccessText;
            _loc10_.FailText = _loc11_.FailText;
            this.GetRewardName(_loc11_.RewardType,_loc11_.RewardCode,_loc10_.RewardName);
            this.LoadOneGirlClothesInfor(_loc10_,_loc11_.ClothesID,_loc7_);
            this.CreateClothesRewardString(_loc10_,_loc8_);
            this.CreateGirlRewardString(_loc10_);
            _loc10_.CurrentSchedule = _loc10_.Clothes.length - 1;
            _loc10_.ScheduleHistory = _loc10_.Clothes.length;
            _loc5_.push(_loc10_);
            _loc8_++;
         }
      }
   }
}

