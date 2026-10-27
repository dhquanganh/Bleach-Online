package Logics.Streamization.RelatedPartner
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.RelatedPartner.*;
   import Logics.Streamization.RelatedPartner.VO.*;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRelatedPartnerTrain extends TUnstreamizer
   {
      
      public function TUnstreamizerRelatedPartnerTrain()
      {
         super();
      }
      
      public function UstreamizationPerform_DailyReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPartnerTrainHeroPointVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as TPartnerTrainHeroPointVO;
         _loc6_ = int(param1.readUnsignedInt());
         if(_loc6_ == CONST_RELATEDPARTNER.PartnerTrain_Type_Free)
         {
            _loc4_.FreeCount = param1.readUnsignedInt();
         }
         else
         {
            _loc4_.GoldCount = param1.readUnsignedInt();
         }
         SToolReward.ShowReward(param1);
      }
      
      public function UnstreamizationPerform_TrainInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPartnerTrainHeroPointVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:TCity = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:TPartnerTrainHeroPointVO = null;
         var _loc15_:TConfigValue = null;
         _loc4_ = param2 as TPartnerTrainHeroPointVO;
         _loc15_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_CityId) as TConfigValue;
         _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_City,int(_loc15_.Value)) as TCity;
         _loc12_ = _loc11_.Start;
         _loc13_ = _loc11_.Last;
         _loc4_.FreeCount = param1.readUnsignedInt();
         _loc4_.GoldCount = param1.readUnsignedInt();
         _loc4_.StarRewardStatus = param1.readUnsignedInt();
         _loc6_ = _loc13_ - _loc12_ + 1;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_.PveIds[_loc5_] = _loc12_ + _loc5_;
            _loc4_.Stars[_loc5_] = 0;
            _loc5_++;
         }
         _loc6_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = int(param1.readUnsignedInt());
            _loc9_ = int(param1.readUnsignedInt());
            _loc4_.SetPointData(_loc8_,_loc9_);
            _loc5_++;
         }
      }
      
      public function UnstreamizationPerform_StarReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPartnerTrainStarRewardVO = null;
         _loc4_ = param2 as TPartnerTrainStarRewardVO;
         _loc4_.StarRewardStatus = param1.readUnsignedInt();
         SToolReward.ShowReward(param1);
      }
      
      public function UnstreamizationPerform_StarNotify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPartnerTrainHeroPointVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = param2 as TPartnerTrainHeroPointVO;
         _loc6_ = int(param1.readUnsignedInt());
         _loc7_ = int(param1.readUnsignedInt());
         _loc4_.HeroId = param1.readUnsignedInt();
         _loc4_.SkillId = param1.readUnsignedInt();
         _loc4_.SetPointData(_loc6_,_loc7_);
      }
      
      public function UnstreamizationPerform_Levelup(param1:ByteArray, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TRelatedPartnerHero = null;
         var _loc7_:TRelatedPartnerHeroSkill = null;
         _loc3_ = int(param1.readUnsignedInt());
         _loc4_ = int(param1.readUnsignedInt());
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(_loc3_);
         _loc7_ = _loc6_.ReplaceSkill(_loc4_,_loc5_);
         param2.HeroSkill = _loc7_;
      }
      
      public function UnstreamizationPerform_HeroData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TRelatedPartnerHeros = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TRelatedPartnerHero = null;
         _loc4_ = param2 as TRelatedPartnerHeros;
         _loc6_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = int(param1.readUnsignedInt());
            _loc8_ = int(param1.readUnsignedInt());
            _loc9_ = _loc4_.GetHeroDataByIdentifier(_loc7_);
            if(_loc9_ != null)
            {
               _loc9_.SetSkillActive(_loc8_);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizationPerform_HelpCancel(param1:int, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:THeros = null;
         _loc5_ = param2 as THeros;
         _loc3_ = 0;
         while(_loc3_ < _loc5_.Count)
         {
            _loc4_ = _loc5_.GetHeroByIndex(_loc3_);
            if(_loc4_.RelatedPartnerPos == param1)
            {
               _loc4_.RelatedPartnerPos = 0;
               break;
            }
            _loc3_++;
         }
      }
      
      public function UnstreamizationPerform_UpdateCount(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPartnerTrainHeroPointVO = null;
         _loc4_ = param2 as TPartnerTrainHeroPointVO;
         _loc4_.FreeCount = param1.readUnsignedInt();
         _loc4_.GoldCount = param1.readUnsignedInt();
      }
   }
}

