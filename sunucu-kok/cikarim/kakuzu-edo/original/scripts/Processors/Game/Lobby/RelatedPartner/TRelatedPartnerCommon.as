package Processors.Game.Lobby.RelatedPartner
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.TInventoryProperty;
   import Logics.RelatedPartner.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_RELATEDPARTNER;
   
   public class TRelatedPartnerCommon
   {
      
      protected static var FIsInit:Boolean;
      
      protected static var FIsSkillInfoReq:Boolean;
      
      protected static var FHeroDatas:TRelatedPartnerHeros;
      
      protected static var FChipId:int;
      
      public function TRelatedPartnerCommon()
      {
         super();
      }
      
      public static function SkillInfoReq() : Boolean
      {
         var _loc1_:TPacket = null;
         if(FIsSkillInfoReq)
         {
            return true;
         }
         FIsSkillInfoReq = true;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_SkillInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         return false;
      }
      
      public static function InitSkillData() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRelatedPartnerType = null;
         var _loc5_:int = 0;
         var _loc6_:TRelatedPartner = null;
         var _loc7_:TRelatedPartnerHero = null;
         var _loc8_:TRelatedPartnerHeroSkill = null;
         var _loc9_:Vector.<TRelatedPartnerHeroSkill> = null;
         var _loc10_:TConfigValue = null;
         if(FIsInit)
         {
            return;
         }
         FIsInit = true;
         FHeroDatas = new TRelatedPartnerHeros();
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RelatedPartner);
         _loc9_ = new Vector.<TRelatedPartnerHeroSkill>();
         _loc3_ = _loc1_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc1_.GetDatebaseByIndex(_loc2_) as TRelatedPartner;
            if(_loc6_.Type != 0)
            {
               _loc7_ = FHeroDatas.GetHeroDataByIdentifier(_loc6_.HeroId);
               if(_loc7_ == null)
               {
                  _loc7_ = new TRelatedPartnerHero();
                  _loc7_.HeroId = _loc6_.HeroId;
                  FHeroDatas.Add(_loc7_);
               }
               _loc8_ = new TRelatedPartnerHeroSkill();
               _loc8_.SkillId = 0;
               _loc8_.Partner = _loc6_;
               _loc9_.push(_loc8_);
               _loc7_.HeroSkills.push(_loc8_);
            }
            _loc2_++;
         }
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerType);
         _loc3_ = _loc1_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc1_.GetDatebaseByIndex(_loc2_) as TRelatedPartnerType;
            SearchType(_loc4_,_loc9_);
            _loc2_++;
         }
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_Material) as TConfigValue;
         FChipId = int(_loc10_.Value);
      }
      
      protected static function SearchType(param1:TRelatedPartnerType, param2:Vector.<TRelatedPartnerHeroSkill>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param2[_loc3_].Partner.Type == param1.Type)
            {
               param2[_loc3_].Skills.push(param1);
               if(param2[_loc3_].SkillId == 0 && param2[_loc3_].Partner.ConditionStar == 0)
               {
                  param2[_loc3_].SkillId = param1.Identifier;
               }
            }
            _loc3_++;
         }
      }
      
      public static function get HeroDatas() : TRelatedPartnerHeros
      {
         return FHeroDatas;
      }
      
      public static function get ChipId() : int
      {
         return FChipId;
      }
      
      public static function GetSkillDescCommon(param1:int, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:TRelatedPartnerType = null;
         var _loc8_:TInventoryProperty = null;
         var _loc9_:TBaseHero = null;
         var _loc10_:TSkillConfig = null;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerType,param2) as TRelatedPartnerType;
         _loc8_ = _loc7_.Properties[0];
         if(_loc8_.Identifier == CONST_RELATEDPARTNER.SkillConfig_Type)
         {
            _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc8_.Value) as TSkillConfig;
            return _loc10_.Desc;
         }
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1) as TBaseHero;
         _loc3_ = "";
         _loc5_ = int(_loc7_.Properties.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc7_.Properties[_loc4_];
            _loc3_ += TUtilityLobby.GetAttributeName(_loc8_.Identifier);
            if(_loc8_.Oper == CONST_RELATEDPARTNER.Operate_Multiply)
            {
               _loc6_ = _loc8_.Value * 100;
               _loc3_ += _loc6_.toFixed(2) + "%";
            }
            else if(_loc8_.Oper == CONST_RELATEDPARTNER.Operate_Add)
            {
               _loc3_ += "+" + _loc8_.Value;
            }
            _loc3_ += " ";
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function GetSkillDesc(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:TRelatedPartnerType = null;
         var _loc7_:TInventoryProperty = null;
         var _loc8_:TSkillConfig = null;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerType,param1) as TRelatedPartnerType;
         _loc7_ = _loc6_.Properties[0];
         if(_loc7_.Identifier == CONST_RELATEDPARTNER.SkillConfig_Type)
         {
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc7_.Value) as TSkillConfig;
            return _loc8_.Desc;
         }
         _loc2_ = "";
         _loc4_ = int(_loc6_.Properties.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc6_.Properties[_loc3_];
            _loc2_ += TUtilityLobby.GetAttributeName(_loc7_.Identifier);
            if(_loc7_.Oper == CONST_RELATEDPARTNER.Operate_Multiply)
            {
               _loc5_ = _loc7_.Value * 100;
               _loc2_ += _loc5_.toFixed(2) + "%";
            }
            else if(_loc7_.Oper == CONST_RELATEDPARTNER.Operate_Add)
            {
               _loc2_ += "+" + _loc7_.Value;
            }
            _loc2_ += " ";
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function AssistanceOperation(param1:TProcessorRelatedAssistance, param2:int, param3:Object) : void
      {
         var _loc4_:THero = null;
         switch(param2)
         {
            case CONST_RELATEDPARTNER.Type_SetInfo:
               param1.SetHeroData();
               break;
            case CONST_RELATEDPARTNER.Type_SetAssistance:
               if(param1.Visible)
               {
                  _loc4_ = param3 as THero;
                  param1.UpdateAssistanceIcon(_loc4_.Identifier,_loc4_.RelatedPartnerPos);
               }
               break;
            case CONST_RELATEDPARTNER.Type_SetDismount:
               if(param1.Visible)
               {
                  param1.UpdateAssistanceIcon(0,int(param3));
               }
         }
      }
      
      public static function GetMountedHeros(param1:Boolean = true) : THeros
      {
         var _loc2_:THero = null;
         var _loc3_:THeros = null;
         var _loc4_:THeros = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc4_ = new THeros();
         _loc6_ = _loc3_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_.GetHeroByIndex(_loc5_);
            if(!(_loc2_.IsMain && !param1))
            {
               if(_loc2_.Mounted)
               {
                  _loc4_.Add(_loc2_);
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function GetRelatedHeros() : THeros
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:THeros = null;
         var _loc5_:THeros = null;
         _loc4_ = SLogicsCore.Character.Heros;
         _loc5_ = new THeros();
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetHeroByIndex(_loc1_);
            if(!_loc3_.IsMain)
            {
               if(_loc3_.Mounted || _loc3_.RelatedPartnerPos > 0)
               {
                  _loc5_.Add(_loc3_);
               }
            }
            _loc1_++;
         }
         return _loc5_;
      }
   }
}

