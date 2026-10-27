package Logics.Streamization.Home
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Foundation.Timing.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Home.*;
   import Logics.Home.GirlFriend.*;
   import Logics.Inventories.*;
   import Logics.Spaces.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerHome extends TUnstreamizer
   {
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FInventoryReference:TInventoryReference;
      
      public function TUnstreamizerHome()
      {
         super();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventoryReference = new TInventoryReference();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
         this.UnstreamizationPerform_HomeByDatabase(param2);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THome = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         _loc4_ = param2 as THome;
         _loc4_.Reset();
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = param1.readUnsignedInt();
         _loc4_.Coerce(_loc5_,_loc6_);
         _loc4_.Level = param1.readUnsignedByte();
         _loc4_.MyMonsterBeBeatenCount = param1.readUnsignedByte();
         _loc4_.MyMonsterCount = param1.readUnsignedByte();
         _loc4_.FriendMonsterCount = param1.readUnsignedByte();
         _loc4_.LuckyCatCount = param1.readUnsignedByte();
         _loc7_ = int(param1.readUnsignedInt());
         _loc4_.LuckyCatCDLimit = param1.readBoolean();
         _loc4_.ChangeShapeGirlID = param1.readUnsignedInt();
         _loc4_.InteractiveScore = param1.readUnsignedInt();
         if(_loc7_ - STimingCore.ServerTick > 0)
         {
            _loc4_.LuckyCatCD = _loc7_ - STimingCore.ServerTick;
         }
         else
         {
            _loc4_.LuckyCatCD = 0;
         }
      }
      
      protected function UnstreamizationPerform_GenerateHome(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THome = null;
         _loc4_ = param2 as THome;
         _loc4_.Reset();
         _loc4_.Level = param3 as uint;
      }
      
      protected function UnstreamizationPerform_HomeByDatabase(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:THome = null;
         var _loc5_:uint = 0;
         var _loc6_:TGirlFriendInteractive = null;
         var _loc7_:THomeLevel = null;
         var _loc8_:TBins = null;
         var _loc9_:THomeGirlAward = null;
         var _loc10_:TBins = null;
         var _loc11_:THomeGirlInteract = null;
         var _loc12_:TSystemLanguage = null;
         var _loc13_:TConfigValue = null;
         var _loc14_:THomeSoulAward = null;
         var _loc15_:THomeGirlFriend = null;
         var _loc16_:TArticle = null;
         var _loc17_:TInventories = null;
         var _loc18_:Vector.<uint> = null;
         var _loc19_:TInventories = null;
         var _loc20_:Vector.<uint> = null;
         var _loc21_:int = 0;
         _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VERSION_PALYER_LEVEL) as TConfigValue;
         _loc21_ = _loc13_.Value as int;
         _loc4_ = param1 as THome;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeLevel,_loc4_.Level) as THomeLevel;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.HOME_MAKEMONEY_TIP) as TSystemLanguage;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlAward);
         _loc10_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlInteract);
         _loc15_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeGirlFriend,_loc4_.ChangeShapeGirlID) as THomeGirlFriend;
         _loc4_.ChangeShapeGirlImageID = _loc15_.ImageID;
         _loc3_ = _loc10_.Count;
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            _loc11_ = _loc10_.GetDatebaseByIndex(_loc2_) as THomeGirlInteract;
            if(_loc4_.InteractiveScore >= _loc11_.ScoreBlank)
            {
               _loc4_.InteractiveQuality = _loc11_.TitleColor;
               _loc4_.InteractiveTitle = _loc11_.NameTitle;
               break;
            }
            _loc2_--;
         }
         _loc4_.Name = _loc7_.Name;
         _loc4_.Quality = _loc7_.Quality;
         _loc4_.ViewImageID = _loc7_.ViewImgID;
         _loc4_.MainImgID = _loc7_.MainImgID;
         _loc4_.FloatingIslandPointLeftID = _loc7_.FloatingIslandPointLeftID;
         _loc4_.FloatingIslandPointRightID = _loc7_.FloatingIslandPointRightID;
         _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.HOME_SOUL_NUMBER) as TConfigValue;
         _loc4_.MaxMyMonsterBeBeatenCount = uint(_loc13_.Value);
         _loc5_ = _loc7_.UpgradeCondition.Code;
         if(_loc5_ != 0)
         {
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoryByIdentified(null,this.FInventoryReference,_loc5_);
            _loc4_.Appliance = this.FInventoryReference.Inventory as TAppliance;
            _loc4_.Appliance.Quantity = _loc7_.UpgradeCondition.Amount;
            this.FInventoryReference.Inventory = null;
         }
         _loc4_.Desc = _loc7_.AddLevelText;
         _loc4_.MaxGirlFriendLevel = _loc7_.MaxGirlFriendLevel;
         _loc4_.MaxMyMonsterCount = _loc7_.MyMonsterCount;
         _loc4_.MaxFriendMonsterCount = _loc7_.FriendMonsterCount;
         _loc4_.QualityMonster = _loc7_.QualityMonster;
         _loc4_.LuckyCat.MaxLuckyCatCount = _loc7_.LuckyCatCount;
         _loc4_.MaxGambleCount = _loc7_.GambleCount;
         _loc4_.MaxMyGirlfriendInteractive = _loc7_.MaxMyGirlfriendInteractive;
         _loc4_.MaxGirlfriendInteractiveCount = _loc7_.GirlfriendInteractiveCount;
         _loc4_.MaxGirlfriendBeInteractiveCount = _loc7_.GirlfriendBeInteractiveCount;
         _loc3_ = _loc10_.Count;
         if(_loc4_.GirlFriendInteractives.Count == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc3_ - 1)
            {
               _loc6_ = new TGirlFriendInteractive();
               _loc4_.GirlFriendInteractives.Add(_loc6_);
               _loc2_++;
            }
         }
         _loc2_ = 1;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = _loc10_.GetDatebaseByIndex(_loc2_) as THomeGirlInteract;
            _loc6_ = _loc4_.GirlFriendInteractives.GetGirlFriendInteractiveByIndex(_loc2_ - 1);
            _loc6_.InteractiveScore = _loc11_.ScoreBlank;
            _loc6_.InteractiveTitle = _loc11_.NameTitle;
            _loc6_.InteractiveQuality = _loc11_.TitleColor;
            _loc6_.InteractiveAdditional = uint(Math.round(_loc11_.Added * 100)).toString();
            _loc9_ = _loc8_.GetDatebaseByIdentifier(_loc11_.TitleColor + _loc2_) as THomeGirlAward;
            _loc16_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc9_.InteractiveAward.Code) as TArticle;
            _loc6_.InteractiveReward = _loc16_.Name;
            _loc2_++;
         }
         _loc4_.GirlFriendInteractives.Sort();
         _loc4_.LuckyCat.Desc = _loc12_.Desc;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.HOME_SOUL_TIP) as TSystemLanguage;
         if(_loc12_ != null)
         {
            _loc4_.HomeSoul.Recommend = _loc12_.Desc;
         }
         _loc4_.HomeSoul.Prompt = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SoulMonster_STRING_01);
         _loc2_ = int(_loc21_ * (_loc4_.QualityMonster - 2) + SLogicsCore.Character.GetMainRebirthLevel());
         _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeSoulAward,_loc2_) as THomeSoulAward;
         _loc19_ = new TInventories();
         _loc20_ = new Vector.<uint>();
         _loc17_ = new TInventories();
         _loc18_ = new Vector.<uint>();
         if(_loc14_ != null)
         {
            _loc4_.HomeSoul.MonsterID = _loc14_.ImgID;
            _loc3_ = int(_loc14_.FixedVect.length);
            _loc18_.length = 0;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc18_[_loc2_] = _loc14_.FixedVect[_loc2_].ID;
               _loc2_++;
            }
            _loc4_.HomeSoul.FixedIDVect = _loc18_;
            _loc17_.Clear();
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc17_,_loc18_);
            _loc3_ = _loc17_.Count;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc17_.GetInventoryByIndex(_loc2_).Quantity = uint(_loc14_.FixedVect[_loc2_].amount);
               _loc2_++;
            }
            _loc4_.HomeSoul.FixedInventories = _loc17_;
            _loc3_ = int(_loc14_.RewardsVect.length);
            _loc20_.length = 0;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc20_[_loc2_] = _loc14_.RewardsVect[_loc2_].ID;
               _loc2_++;
            }
            _loc4_.HomeSoul.AwardIDVect = _loc20_;
            _loc19_.Clear();
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc19_,_loc20_);
            _loc3_ = _loc19_.Count;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc19_.GetInventoryByIndex(_loc2_).Quantity = uint(_loc14_.RewardsVect[_loc2_].amount);
               _loc2_++;
            }
            _loc4_.HomeSoul.Inventories = _loc19_;
         }
      }
      
      public function UnstreamizeGenerateHome(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateHome(param1,param2,param3);
         this.UnstreamizationPerform_HomeByDatabase(param2);
      }
      
      public function UnstreamizeHomeByDatabase(param1:Object) : void
      {
         this.UnstreamizationPerform_HomeByDatabase(param1);
      }
   }
}

