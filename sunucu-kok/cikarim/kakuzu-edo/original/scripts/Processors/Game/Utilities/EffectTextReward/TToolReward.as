package Processors.Game.Utilities.EffectTextReward
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TToolReward
   {
      
      protected var FOnEffectText:Function;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FIDTemplates:Vector.<uint>;
      
      public function TToolReward()
      {
         super();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FIDTemplates = new Vector.<uint>();
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function ShowReward(param1:ByteArray, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         _loc8_ = "";
         if(param2)
         {
            _loc4_ = int(param1.readUnsignedShort());
         }
         else
         {
            _loc4_ = 1;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = int(param1.readUnsignedShort());
            _loc6_ = int(param1.readUnsignedInt());
            _loc7_ = int(param1.readUnsignedInt());
            _loc8_ += TUtilityString.Format("%0 * %1\n",this.GetNameByTypeCode(_loc5_,_loc6_),_loc7_.toString());
            _loc3_++;
         }
         if(this.FOnEffectText != null)
         {
            this.FOnEffectText(this,_loc8_);
         }
      }
      
      public function ShowMessage(param1:String) : void
      {
         if(this.FOnEffectText != null)
         {
            this.FOnEffectText(this,param1);
         }
      }
      
      public function GetNameByTypeCode(param1:int, param2:int) : String
      {
         var _loc3_:TArticle = null;
         var _loc4_:uint = 0;
         _loc4_ = CONST_COMMON.RewardIDToTemplateID(param1,param2);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc4_) as TArticle;
         return _loc3_.Name;
      }
      
      public function CreateRewardInventoryByRewardInfor(param1:TRewards, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc6_ = param2.Count;
         _loc5_ = int(param1.Count);
         this.FIDTemplates.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = CONST_COMMON.RewardIDToTemplateID(param1.Type[_loc3_],param1.Code[_loc3_]);
            if(_loc4_ != 0)
            {
               this.FIDTemplates.push(_loc4_);
            }
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            param2.GetInventoryByIndex(_loc3_ + _loc6_).Quantity = param1.Amount[_loc3_];
            _loc3_++;
         }
      }
      
      public function GetInventoriesByFixedAwards(param1:Vector.<TFixedAward>, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TFixedAward = null;
         _loc6_ = param2.Count;
         _loc5_ = int(param1.length);
         this.FIDTemplates.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc7_ = param1[_loc3_];
            _loc4_ = CONST_COMMON.RewardIDToTemplateID(_loc7_.Type,_loc7_.Code);
            if(_loc4_ != 0)
            {
               this.FIDTemplates.push(_loc4_);
            }
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            param2.GetInventoryByIndex(_loc3_ + _loc6_).Quantity = param1[_loc3_].Amount;
            _loc3_++;
         }
      }
      
      public function GetAwardsByAwardID(param1:int, param2:TInventories, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAward = null;
         var _loc7_:TFixedAward = null;
         var _loc8_:int = 0;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,param1) as TAward;
         _loc8_ = param2.Count;
         this.FIDTemplates.length = 0;
         _loc5_ = int(_loc6_.FixedAwards.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc6_.FixedAwards[_loc4_];
            this.FIDTemplates.push(CONST_COMMON.RewardIDToTemplateID(_loc7_.Type,_loc7_.Code));
            _loc4_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            param2.GetInventoryByIndex(_loc4_ + _loc8_).Quantity = _loc6_.FixedAwards[_loc4_].Amount;
            _loc4_++;
         }
         if(param3)
         {
            this.FIDTemplates.length = 0;
            _loc8_ = param2.Count;
            _loc5_ = int(_loc6_.RandomAwards.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               this.FIDTemplates.push(CONST_COMMON.RewardIDToTemplateID(_loc6_.RandomAwards[_loc4_].Type,_loc6_.RandomAwards[_loc4_].Code));
               _loc4_++;
            }
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               param2.GetInventoryByIndex(_loc4_ + _loc8_).Quantity = _loc6_.RandomAwards[_loc4_].Amount;
               _loc4_++;
            }
         }
      }
      
      public function GetRandomAwardsByAwardID(param1:int, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAward = null;
         var _loc6_:int = 0;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,param1) as TAward;
         this.FIDTemplates.length = 0;
         _loc6_ = param2.Count;
         _loc4_ = int(_loc5_.RandomAwards.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FIDTemplates.push(CONST_COMMON.RewardIDToTemplateID(_loc5_.RandomAwards[_loc3_].Type,_loc5_.RandomAwards[_loc3_].Code));
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.GetInventoryByIndex(_loc3_ + _loc6_).Quantity = _loc5_.RandomAwards[_loc3_].Amount;
            _loc3_++;
         }
      }
      
      public function GetInventoryByIDAmount(param1:uint, param2:int, param3:TInventories) : void
      {
         var _loc4_:TInventory = null;
         this.FIDTemplates.length = 0;
         this.FIDTemplates.push(param1);
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param3,this.FIDTemplates);
         _loc4_ = param3.GetInventoryByIndex(param3.Count - 1);
         _loc4_.Quantity = param2;
      }
      
      public function GetInventoryByID(param1:uint, param2:TInventories) : void
      {
         this.FIDTemplates.length = 0;
         this.FIDTemplates.push(param1);
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
      }
      
      public function GetInventoriesByIDVec(param1:Vector.<int>, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FIDTemplates.length = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FIDTemplates.push(param1[_loc3_]);
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FIDTemplates);
      }
      
      public function ShowMassageByInventoy(param1:TInventory) : void
      {
         this.ShowMessage(param1.Name + "*" + param1.Quantity);
      }
   }
}

