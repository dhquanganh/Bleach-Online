package Logics.Streamization.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TMall;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.Inventories.TInventory;
   import Logics.Inventories.TInventorySample;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MALL;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerInventorySample extends TUnstreamizerInventoryReference
   {
      
      public function TUnstreamizerInventorySample()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamizationperform_BaseInfo(param1,param2,param3);
      }
      
      protected function Unstreamizationperform_BaseInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventorySample = null;
         _loc4_ = param2 as TInventorySample;
      }
      
      protected function UnstreamizationPerform_InventorySampleByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventorySample = null;
         var _loc5_:TMall = null;
         _loc4_ = param2 as TInventorySample;
         _loc5_ = param3 as TMall;
         _loc4_.Indentifier = _loc5_.Identifier;
         _loc4_.Model = _loc5_.Model;
         _loc4_.Name = _loc5_.Name;
         _loc4_.MajorType = _loc5_.MajorType;
         _loc4_.TemplateID = _loc5_.ItemID;
         _loc4_.ConsumeType = _loc5_.Type;
         _loc4_.Integration = _loc5_.Integration;
         _loc4_.UnlockLevel = _loc5_.Level;
         _loc4_.IsVip = _loc5_.IsVip;
         _loc4_.IsDisplay = _loc5_.IsDisplay;
         _loc4_.Amount = _loc5_.Amount;
         _loc4_.CostGold = _loc5_.Gold;
         _loc4_.Discount = _loc5_.Discount;
         _loc4_.HotPrice = _loc5_.Hotprice;
         _loc4_.Page = _loc5_.Page;
         _loc4_.VipLevel = _loc5_.Vip;
         _loc4_.IsHot = _loc5_.IsHot;
         _loc4_.IsNew = _loc5_.Isnew;
         _loc4_.BuyTimes = _loc5_.Times;
         _loc4_.BuyTimesTotal = _loc5_.TotalTimes;
         _loc4_.Items = _loc5_.Items;
         this.UnstreamizationPerform_InventorySample(param1,_loc4_,0);
      }
      
      protected function UnstreamizationPerform_InventorySample(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TInventory = null;
         var _loc6_:TInventorySample = null;
         var _loc7_:TUnstreamizerInventory = null;
         var _loc8_:TBaseHero = null;
         var _loc9_:TRoleModel = null;
         var _loc10_:TArticle = null;
         _loc6_ = param2 as TInventorySample;
         _loc4_ = _loc6_.MajorType;
         if(_loc4_ == CONST_MALL.MAJORTYPE_MALL_Inventory)
         {
            _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc6_.TemplateID) as TArticle;
            _loc4_ = uint(_loc10_.MajorType);
            _loc5_ = AcquireInventory(_loc4_);
            _loc7_ = InventoryUnstreamizerByCategory(_loc4_);
            _loc5_.IDTemplate = _loc6_.TemplateID;
            _loc7_.UnstreamizeGenerateInventory(param1,_loc5_,param3);
            _loc6_.Inventory = _loc5_;
         }
         else if(_loc4_ == CONST_MALL.MAJORTYPE_MALL_Hero)
         {
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc6_.TemplateID) as TBaseHero;
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc8_.Identifier) as TRoleModel;
            _loc6_.HeroName = _loc8_.Name;
            _loc6_.HeroQuality = _loc8_.Quality;
            _loc6_.RoleModel = _loc9_.Model;
         }
         else if(_loc4_ == CONST_MALL.MAJORTYPE_MALL_HellHero)
         {
            if(_loc6_.TemplateID < 10000000)
            {
               return;
            }
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc6_.TemplateID) as TBaseHero;
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc8_.Identifier) as TRoleModel;
            _loc6_.HeroName = _loc8_.Name;
            _loc6_.HeroQuality = _loc8_.Quality;
            _loc6_.RoleModel = _loc9_.Model;
         }
      }
      
      public function UnstreamizeInventorySampleByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InventorySampleByDatabase(param1,param2,param3);
      }
   }
}

