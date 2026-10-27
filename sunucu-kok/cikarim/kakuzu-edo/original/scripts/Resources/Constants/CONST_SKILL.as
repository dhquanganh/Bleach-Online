package Resources.Constants
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TPartnerChange;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.HeroChange.THeroChange;
   import Logics.HeroChange.THeroChangeData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   
   public class CONST_SKILL
   {
      
      public static const TYPE_PASSIVE:int = 201;
      
      public static const TYPE_DEAD:int = 202;
      
      public static const TYPE_AURA:int = 203;
      
      public static const TYPE_ROUND:int = 204;
      
      public function CONST_SKILL()
      {
         super();
      }
      
      public static function SkillDesc(param1:int, param2:Array) : String
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TBins = null;
         var _loc8_:TSkillConfig = null;
         var _loc9_:String = null;
         _loc9_ = "";
         if(param2 != null)
         {
            _loc5_ = int(param2.length);
            _loc3_ = null;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(param2[_loc4_].type == param1)
               {
                  _loc3_ = param2[_loc4_];
                  break;
               }
               _loc4_++;
            }
         }
         if(_loc3_ != null)
         {
            _loc5_ = int(_loc3_.skill.length);
            _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = int(_loc3_.skill[_loc4_]);
               _loc8_ = _loc7_.GetDatebaseByIdentifier(_loc6_) as TSkillConfig;
               _loc9_ += _loc8_.Desc + "\n";
               _loc4_++;
            }
            return _loc9_;
         }
         return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_58);
      }
      
      public static function SkillDescByHero(param1:int, param2:THero) : String
      {
         var _loc3_:THeroChangeData = null;
         var _loc4_:THeroChange = null;
         var _loc5_:Vector.<TPartnerChange> = null;
         var _loc6_:TPartnerChange = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<Object> = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         _loc13_ = "";
         if(param2.IsMain)
         {
            return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_58);
         }
         _loc3_ = SLogicsCore.HeroChangeData;
         _loc4_ = _loc3_.GetHeroChangeByHeroID(param2.Identifier);
         _loc5_ = _loc4_.PartnerChanges;
         _loc8_ = _loc5_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = _loc5_[_loc7_];
            _loc9_ = _loc6_.Effect;
            _loc11_ = _loc9_.length;
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               _loc12_ = _loc9_[_loc10_];
               if(_loc12_.addType == param1)
               {
                  _loc13_ += _loc6_.Desc;
                  if(param2.ChangeSchedule <= _loc7_)
                  {
                     _loc13_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_24);
                  }
                  _loc13_ += "\n";
                  break;
               }
               _loc10_++;
            }
            _loc7_++;
         }
         if(_loc13_ == "")
         {
            return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_58);
         }
         return _loc13_;
      }
   }
}

