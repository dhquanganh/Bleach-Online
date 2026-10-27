package Logics.Streamization.Home
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THomeGirlFriend;
   import Logics.DatebaseVO.VO.THomeGirlInteract;
   import Logics.DatebaseVO.VO.THomeLevel;
   import Logics.Home.GirlFriend.TGirlFriend;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerGirlFriend extends TUnstreamizer
   {
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FIDTemplates:Vector.<uint>;
      
      public function TUnstreamizerGirlFriend()
      {
         super();
         this.FIDTemplates = new Vector.<uint>();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      protected function UnstreamizationPerform_GirlFriendByDatabase(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_GirlFriendBaseInforByDatabase(param1,param2);
         this.UnstreamizationPerform_GirlFriendAwardInforByDatabase(param1,param2);
      }
      
      protected function UnstreamizationPerform_GirlFriendBaseInforByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:TGirlFriend = null;
         var _loc4_:THomeGirlFriend = null;
         var _loc5_:THomeLevel = null;
         var _loc6_:TBins = null;
         var _loc7_:int = 0;
         _loc3_ = param1 as TGirlFriend;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeGirlFriend,_loc3_.ID) as THomeGirlFriend;
         _loc3_.ImageID = _loc4_.ImageID;
         _loc3_.Name = _loc4_.Name;
         _loc3_.CanMakeTofuTime = _loc4_.MackTofuNum;
         _loc3_.MakeTofuCDTime = _loc4_.MackTofuCDTime * 60;
         _loc3_.MakeTofuAwardNum = _loc4_.MakeTofuAwardNum;
         _loc3_.CanCommunicateTime = _loc4_.SpriteCommunicateNum;
         _loc3_.SpriteCommunicateCDTime = _loc4_.SpriteCommunicateCDTime * 60;
         _loc3_.GirlDescrption = _loc4_.Description;
         _loc3_.HomeLevelLimit = _loc4_.HomeLevelLimit;
         _loc3_.UpgradeInventoryNum = _loc4_.LevelUpArticalNum;
         _loc3_.UpgradeArticalID = _loc4_.LevelUpArticalID;
         _loc3_.Level = _loc4_.Level;
         _loc3_.NomalSpriteCommunicateCost = _loc4_.NomalSpriteCommunicateCost;
         _loc3_.GoldSpriteCommunicateCost = _loc4_.GoldSpriteCommunicateCost;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeLevel);
         _loc7_ = 0;
         while(_loc7_ < _loc6_.Count)
         {
            _loc5_ = _loc6_.GetDatebaseByIndex(_loc7_) as THomeLevel;
            if(_loc5_.Level == _loc3_.HomeLevelLimit)
            {
               _loc3_.HomeLevelLimitName = _loc5_.Name;
               break;
            }
            _loc7_++;
         }
         this.FIDTemplates.length = 0;
         _loc3_.UpgradeInventories.Clear();
         if(_loc4_.LevelUpArticalID != 0)
         {
            this.FIDTemplates.push(_loc4_.LevelUpArticalID);
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc3_.UpgradeInventories,this.FIDTemplates);
         if(_loc3_.CurrentChangeShapeGirlID != 0)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeGirlFriend,_loc3_.CurrentChangeShapeGirlID) as THomeGirlFriend;
            _loc3_.CurrentChangeShapeGirlImageID = _loc4_.ImageID;
         }
      }
      
      protected function UnstreamizationPerform_GirlFriendAwardInforByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:TGirlFriend = null;
         var _loc4_:THomeGirlInteract = null;
         var _loc5_:* = 0;
         var _loc6_:TBins = null;
         _loc3_ = param1 as TGirlFriend;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlInteract);
         _loc5_ = 0;
         while(_loc5_ < _loc6_.Count)
         {
            _loc4_ = _loc6_.GetDatebaseByIndex(_loc5_) as THomeGirlInteract;
            if(_loc4_.ScoreBlank > _loc3_.TeaseScore)
            {
               break;
            }
            _loc5_++;
         }
         _loc5_--;
         _loc4_ = _loc6_.GetDatebaseByIndex(_loc5_) as THomeGirlInteract;
         _loc3_.TitleName = _loc4_.NameTitle;
         _loc3_.TitleQuality = _loc4_.TitleColor;
         _loc3_.TitleAdded = _loc4_.Added;
      }
      
      public function Unstreamization_GirlFriendByDatabase(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_GirlFriendByDatabase(param1,param2);
      }
   }
}

