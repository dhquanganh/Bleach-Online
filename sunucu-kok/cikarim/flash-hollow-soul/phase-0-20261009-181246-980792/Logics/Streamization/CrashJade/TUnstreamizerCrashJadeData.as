package Logics.Streamization.CrashJade
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.CityDefend.*;
   import Logics.CrashJade.*;
   import Logics.DatebaseVO.VO.TCrashedJade;
   import Logics.DatebaseVO.VO.TMall;
   import Logics.Inventories.*;
   import Logics.SLogicsCore;
   import Logics.Spaces.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_CRASHJADE;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerCrashJadeData extends TUnstreamizer
   {
      
      protected const ShopItemType_Jade:uint = 0;
      
      protected const ShopItemType_Dan:uint = 1;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FIDHighVec:Vector.<uint>;
      
      protected var FIDLowVec:Vector.<uint>;
      
      protected var FAddValue:Vector.<uint>;
      
      protected var FPosition:Vector.<int>;
      
      protected var InventoriesTool:TInventories;
      
      public function TUnstreamizerCrashJadeData()
      {
         super();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FIDTemplates = new Vector.<uint>();
         this.FIDHighVec = new Vector.<uint>();
         this.FIDLowVec = new Vector.<uint>();
         this.FAddValue = new Vector.<uint>();
         this.FPosition = new Vector.<int>();
         this.InventoriesTool = new TInventories();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      public function UnstreamizationPerform_BaseInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJadeData = null;
         var _loc5_:TInventories = null;
         var _loc6_:TCrashJade = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TCrashJadeData;
         _loc5_ = param3 as TInventories;
         _loc4_.MakeJadeFlag = param1.readUnsignedByte();
         _loc4_.MakeJadeTime = param1.readInt();
         _loc4_.BuyTime = param1.readUnsignedInt();
         _loc4_.ChipNum = param1.readUnsignedInt();
         _loc4_.ExperiencePelletNum = param1.readUnsignedInt();
         _loc4_.CurrentSlotNum = param1.readUnsignedInt();
         _loc4_.HightLevelMakeJadeTime = param1.readUnsignedInt();
         this.FIDTemplates.length = 0;
         this.FIDHighVec.length = 0;
         this.FIDLowVec.length = 0;
         this.FAddValue.length = 0;
         _loc8_ = int(param1.readUnsignedShort());
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            this.FIDHighVec.push(param1.readUnsignedInt());
            this.FIDLowVec.push(param1.readUnsignedInt());
            this.FIDTemplates.push(param1.readUnsignedInt());
            this.FAddValue.push(param1.readUnsignedInt());
            _loc7_++;
         }
         _loc4_.ShopCoinCount = param1.readUnsignedInt();
         _loc9_ = _loc5_.Count;
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc5_,this.FIDTemplates);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = _loc5_.GetInventoryByIndex(_loc7_ + _loc9_) as TCrashJade;
            _loc6_.Identifier0 = this.FIDHighVec[_loc7_];
            _loc6_.Identifier1 = this.FIDLowVec[_loc7_];
            _loc6_.Exp = this.FAddValue[_loc7_];
            _loc7_++;
         }
      }
      
      public function UnstreamizationPerform_MakeJade(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJadeData = null;
         var _loc5_:TInventories = null;
         var _loc6_:TCrashJade = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc4_ = param2 as TCrashJadeData;
         _loc5_ = param3 as TInventories;
         _loc10_ = int(_loc4_.ChipNum);
         _loc11_ = int(_loc4_.ShopCoinCount);
         _loc4_.MakeJadeTime = param1.readInt();
         _loc4_.BuyTime = param1.readUnsignedInt();
         _loc4_.MakeJadeFlag = param1.readUnsignedByte();
         _loc4_.ChipNum = param1.readUnsignedInt();
         _loc4_.IfGetChip = _loc4_.ChipNum > _loc10_;
         _loc8_ = int(param1.readUnsignedShort());
         this.FIDTemplates.length = 0;
         this.FIDHighVec.length = 0;
         this.FIDLowVec.length = 0;
         this.FAddValue.length = 0;
         _loc4_.BtnPosition.length = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_.BtnPosition.push(param1.readByte());
            this.FIDHighVec.push(param1.readUnsignedInt());
            this.FIDLowVec.push(param1.readUnsignedInt());
            this.FIDTemplates.push(param1.readUnsignedInt());
            this.FAddValue.push(param1.readUnsignedInt());
            _loc7_++;
         }
         _loc4_.ShopCoinCount = param1.readUnsignedInt();
         _loc4_.IfGetShopCoin = _loc4_.ShopCoinCount > _loc11_;
         _loc9_ = _loc5_.Count;
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc5_,this.FIDTemplates);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = _loc5_.GetInventoryByIndex(_loc7_ + _loc9_) as TCrashJade;
            _loc6_.Identifier0 = this.FIDHighVec[_loc7_];
            _loc6_.Identifier1 = this.FIDLowVec[_loc7_];
            _loc6_.Exp = this.FAddValue[_loc7_];
            _loc7_++;
         }
      }
      
      public function UnstreamizationPerform_BackPack(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:TCrashJadeData = null;
         var _loc6_:TCrashJade = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc5_ = param2 as TCrashJadeData;
         _loc4_ = param3 as TInventories;
         this.FIDTemplates.length = 0;
         this.FIDHighVec.length = 0;
         this.FIDLowVec.length = 0;
         this.FAddValue.length = 0;
         _loc8_ = int(param1.readUnsignedShort());
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            this.FIDHighVec.push(param1.readUnsignedInt());
            this.FIDLowVec.push(param1.readUnsignedInt());
            this.FIDTemplates.push(param1.readUnsignedInt());
            this.FAddValue.push(param1.readUnsignedInt());
            _loc7_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc4_,this.FIDTemplates);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = _loc4_.GetInventoryByIndex(_loc7_) as TCrashJade;
            _loc6_.Identifier0 = this.FIDHighVec[_loc7_];
            _loc6_.Identifier1 = this.FIDLowVec[_loc7_];
            _loc6_.Exp = this.FAddValue[_loc7_];
            _loc7_++;
         }
         this.FIDTemplates.length = 0;
         this.InventoriesTool.Clear();
         this.FIDTemplates.push(CONST_CRASHJADE.PelletTemplateID);
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.InventoriesTool,this.FIDTemplates);
         _loc5_.CrashJadePellet = this.InventoriesTool.GetInventoryByIndex(0);
         _loc5_.BackPackInited = true;
      }
      
      public function UnstreamizationPerform_HeroJade(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:TCrashJade = null;
         _loc6_ = param2 as THero;
         this.FIDTemplates.length = 0;
         this.FIDHighVec.length = 0;
         this.FIDLowVec.length = 0;
         this.FAddValue.length = 0;
         this.FPosition.length = 0;
         this.InventoriesTool.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FPosition.push(param1.readByte());
            this.FIDHighVec.push(param1.readUnsignedInt());
            this.FIDLowVec.push(param1.readUnsignedInt());
            this.FIDTemplates.push(param1.readUnsignedInt());
            this.FAddValue.push(param1.readUnsignedInt());
            _loc4_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.InventoriesTool,this.FIDTemplates);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = this.InventoriesTool.GetInventoryByIndex(_loc4_) as TCrashJade;
            _loc7_.Identifier0 = this.FIDHighVec[_loc4_];
            _loc7_.Identifier1 = this.FIDLowVec[_loc4_];
            _loc7_.Exp = this.FAddValue[_loc4_];
            _loc7_.MountedHeroID = _loc6_.Identifier;
            _loc6_.CrashJadeMounted.SetInventoryByIndex(this.FPosition[_loc4_] - 1,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizationPerform_AdditionalData_CrashJade(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJade = null;
         var _loc5_:TCrashedJade = null;
         _loc4_ = param2 as TCrashJade;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc4_.IDTemplate) as TCrashedJade;
         _loc4_.Level = (_loc4_.IDTemplate - 1) % 100 + 1;
         _loc4_.AddAttributeType = _loc5_.AddType;
         _loc4_.AddAttributeValue = _loc5_.AddValue;
         _loc4_.LevelUpExp = _loc5_.LevelExp;
         _loc4_.SwallowExp = _loc5_.CrashedExp;
         _loc4_.NextLevelID = _loc5_.NextID;
         _loc4_.JadePower = _loc5_.JadePower;
         _loc4_.EffectID = _loc5_.EffectID;
         _loc4_.JadeTypeText = _loc5_.JadeTypeText;
         _loc4_.AddValueTxt = _loc5_.AddValueTxt;
      }
      
      public function UnstreamizationPerform_FillShop(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TCrashJadeData = null;
         var _loc7_:TBins = null;
         var _loc8_:TMall = null;
         var _loc9_:TCrashJadeShopItemVO = null;
         var _loc10_:TInventories = null;
         _loc6_ = param2 as TCrashJadeData;
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Mall);
         _loc5_ = uint(_loc7_.Count);
         _loc10_ = new TInventories();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc7_.GetDatebaseByIndex(_loc4_) as TMall;
            if(_loc8_.Model == CONST_CRASHJADE.ShopModel)
            {
               _loc9_ = new TCrashJadeShopItemVO();
               SToolReward.GetInventoryByID(_loc8_.ItemID,_loc10_);
               _loc9_.Inventory = _loc10_.GetInventoryByIndex(_loc10_.Count - 1);
               _loc9_.Mall = _loc8_;
               _loc6_.ShopItems.push(_loc9_);
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizationPerform_ShopInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJadeData = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TCrashJadeShopItemVO = null;
         _loc4_ = param2 as TCrashJadeData;
         _loc5_ = param1.readShort();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = _loc4_.GetItemVOByMallID(_loc7_);
            if(_loc9_ != null) _loc9_.BuyCont = _loc8_;
            _loc6_++;
         }
      }
      
      public function UnstreamizationPerform_ShopBuy(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJadeData = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TCrashJade = null;
         _loc4_ = param2 as TCrashJadeData;
         _loc5_ = param1.readUnsignedInt();
         _loc9_ = param1.readUnsignedInt();
         _loc6_ = param1.readUnsignedInt();
         _loc7_ = param1.readUnsignedInt();
         _loc8_ = param1.readUnsignedInt();
         if(_loc5_ == this.ShopItemType_Jade)
         {
            SToolReward.GetInventoryByID(_loc8_,SLogicsCore.Character.CrashJade);
            _loc10_ = SLogicsCore.Character.CrashJade.GetInventoryByIndex(SLogicsCore.Character.CrashJade.Count - 1) as TCrashJade;
            _loc10_.Identifier0 = _loc6_;
            _loc10_.Identifier1 = _loc7_;
            _loc10_.Exp = 0;
         }
         else if(_loc5_ == this.ShopItemType_Dan)
         {
            _loc4_.ExperiencePelletNum = _loc9_;
         }
      }
   }
}

