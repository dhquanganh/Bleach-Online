package Logics.Streamization.Pet
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Foundation.Timing.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Logics.Pet.Gift.*;
   import Logics.Pet.Train.*;
   import Logics.Vip.TVip;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerPetData extends TUnstreamizer
   {
      
      public function TUnstreamizerPetData()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
         this.UnstreamizationPerform_PetDataByDatabase(param2);
         this.UnstreamizationPerform_GiftDataByDatabase(param2);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPetData = null;
         _loc4_ = param2 as TPetData;
         _loc4_.FishCount = param1.readUnsignedInt();
         this.UnstreamizationPerform_FishCD(param1,_loc4_,null);
         _loc4_.BuyFishCount = param1.readUnsignedInt();
         _loc4_.BuyVicePetStorageSlotCount = param1.readUnsignedInt();
         _loc4_.BuyVicePetTrainSlotCount = param1.readUnsignedInt();
         _loc4_.MainPetItemNum = param1.readUnsignedInt();
         _loc4_.PetBagMask = param1.readUnsignedInt();
         _loc4_.TrainCDCount = param1.readUnsignedInt();
         _loc4_.InheritExtendTimes = param1.readUnsignedInt();
         _loc4_.InheritPoolExp = param1.readUnsignedInt();
         this.UnstreamizationPerform_TrainPets(param1,_loc4_,null);
      }
      
      protected function UnstreamizationPerform_PetDataByDatabase(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TVip = null;
         var _loc4_:TPetData = null;
         var _loc5_:TConfigValue = null;
         _loc4_ = param1 as TPetData;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_Interact_Num) as TConfigValue;
         _loc4_.FishCountLimit = _loc5_.Value as uint;
         _loc3_ = SLogicsCore.Character.VipData;
         if(_loc3_.VipLevel != 0)
         {
            _loc2_ = _loc3_.PetInteractionCount;
         }
         else
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_BuyInteract_Num) as TConfigValue;
            _loc2_ = int(_loc5_.Value as uint);
         }
         _loc4_.BuyFishCountLimit = _loc2_;
      }
      
      protected function UnstreamizationPerform_GiftDataByDatabase(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPetData = null;
         var _loc5_:TPetFamilyBag = null;
         var _loc6_:TBins = null;
         var _loc7_:TGift = null;
         _loc4_ = param1 as TPetData;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PetFamilyBag);
         _loc3_ = _loc6_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc6_.GetDatebaseByIndex(_loc2_) as TPetFamilyBag;
            _loc7_ = new TGift(_loc5_.Identifier);
            _loc7_.Name = _loc5_.Name;
            _loc7_.UserLevel = _loc5_.UseerLevel;
            _loc7_.MainPetStage = _loc5_.MainPetStage;
            _loc7_.VicePetNum = _loc5_.VicePetNum;
            SToolReward.GetAwardsByAwardID(_loc5_.Award,_loc7_.Inventories);
            _loc4_.Gifts.Add(_loc7_);
            _loc2_++;
         }
         _loc4_.Gifts.Sort();
      }
      
      protected function UnstreamizationPerform_FishCD(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPetData = null;
         var _loc5_:int = 0;
         _loc4_ = param2 as TPetData;
         _loc5_ = int(param1.readUnsignedInt());
         _loc5_ = _loc5_ - STimingCore.ServerTick;
         if(_loc5_ > 0)
         {
            _loc4_.FishCD = _loc5_;
         }
         else
         {
            _loc4_.FishCD = 0;
         }
      }
      
      protected function UnstreamizationPerform_TrainPets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TPetData = null;
         var _loc8_:TTrainData = null;
         var _loc9_:TConfigValue = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:TVip = null;
         _loc7_ = param2 as TPetData;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_Train_Num) as TConfigValue;
         _loc12_ = int(_loc9_.Value as uint);
         _loc7_.VicePetTrainSlotCount = _loc12_;
         _loc13_ = SLogicsCore.Character.VipData;
         if(_loc13_.VipLevel != 0)
         {
            _loc12_ = _loc13_.PetTrainClearCD;
         }
         else
         {
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_CD_Num) as TConfigValue;
            _loc12_ = int(_loc9_.Value as uint);
         }
         _loc7_.TrainTotalCD = _loc12_;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_Train_Open_Grid) as TConfigValue;
         _loc5_ += (_loc9_.Value as Vector.<uint>).length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = new TTrainData(_loc4_);
            if(_loc4_ < _loc7_.CurrentVicePetTrainSlotCount)
            {
               _loc8_.Status = TTrainData.TYPE_USABLE;
            }
            else
            {
               _loc8_.Status = TTrainData.TYPE_UNOPEN;
            }
            _loc7_.TrainDatas.Add(_loc8_);
            _loc4_++;
         }
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = int(param1.readUnsignedInt());
            _loc8_ = _loc7_.TrainDatas.GetTrainDataByIdentifier(_loc6_);
            _loc8_.VicePetHighID = param1.readUnsignedInt();
            _loc8_.VicePetLowID = param1.readUnsignedInt();
            _loc8_.TrainTypeID = param1.readUnsignedInt();
            _loc8_.ConsumeGoldIndex = param1.readUnsignedInt();
            _loc12_ = int(param1.readUnsignedInt());
            if(_loc12_ - STimingCore.ServerTick > 0)
            {
               _loc8_.Status = TTrainData.TYPE_USED;
               _loc8_.TrainCD = _loc12_;
            }
            else
            {
               if(_loc8_.VicePetHighID != 0 && _loc8_.VicePetLowID != 0)
               {
                  _loc8_.Status = TTrainData.TYPE_COMPLETED;
               }
               _loc8_.TrainCD = 0;
            }
            this.UnstreamizationPerform_TrainPetByDatabase(_loc8_);
            _loc4_++;
         }
         _loc7_.TrainDatas.Sort();
      }
      
      protected function UnstreamizationPerform_TrainPet(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TTrainData = null;
         var _loc8_:TConfigValue = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         _loc7_ = param2 as TTrainData;
         _loc7_.VicePetHighID = param1.readUnsignedInt();
         _loc7_.VicePetLowID = param1.readUnsignedInt();
         _loc7_.TrainTypeID = param1.readUnsignedInt();
         _loc7_.ConsumeGoldIndex = param1.readUnsignedInt();
         _loc11_ = int(param1.readUnsignedInt());
         if(_loc11_ - STimingCore.ServerTick > 0)
         {
            _loc7_.Status = TTrainData.TYPE_USED;
            _loc7_.TrainCD = _loc11_;
         }
         else
         {
            if(_loc7_.VicePetHighID != 0 && _loc7_.VicePetLowID != 0)
            {
               _loc7_.Status = TTrainData.TYPE_COMPLETED;
            }
            _loc7_.TrainCD = 0;
         }
         this.UnstreamizationPerform_TrainPetByDatabase(_loc7_);
      }
      
      protected function UnstreamizationPerform_TrainPetByDatabase(param1:Object) : void
      {
         var _loc2_:TTrainData = null;
         var _loc3_:TVicePetTrain = null;
         var _loc4_:TBins = null;
         _loc2_ = param1 as TTrainData;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VicePetTrain);
         _loc3_ = _loc4_.GetDatebaseByIdentifier(_loc2_.TrainTypeID) as TVicePetTrain;
         _loc2_.NeedTime = _loc3_.NeedTime;
         _loc2_.Exp = _loc3_.GetExp + _loc3_.NeedExp[_loc2_.ConsumeGoldIndex];
      }
      
      public function UnstreamizationPerform_Gifts(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPetData = null;
         var _loc7_:TGift = null;
         var _loc8_:TGifts = null;
         var _loc9_:uint = 0;
         _loc6_ = param2 as TPetData;
         _loc5_ = _loc6_.Gifts.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc6_.Gifts.GetGiftByIndex(_loc4_);
            _loc9_ = _loc6_.GetPetBagMaskByIndex(_loc4_);
            this.UnstreamizationPerform_Gift(null,_loc7_,_loc9_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_Gift(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TGift = null;
         var _loc7_:uint = 0;
         var _loc8_:TPetData = null;
         var _loc9_:TMainPet = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         _loc6_ = param2 as TGift;
         _loc7_ = param3 as uint;
         _loc8_ = SLogicsCore.PetData;
         if(_loc6_.UserLevel > 0)
         {
            _loc10_ = SLogicsCore.Character.GetMainLevel() >= _loc6_.UserLevel;
         }
         else
         {
            _loc10_ = true;
         }
         if(_loc6_.MainPetStage > 0)
         {
            _loc5_ = _loc8_.OwnMainPets.Count;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_ = _loc8_.OwnMainPets.GetPetByIndex(_loc4_) as TMainPet;
               if(_loc9_.Stage >= _loc6_.MainPetStage)
               {
                  _loc11_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc11_ = true;
         }
         if(_loc6_.VicePetNum > 0)
         {
            _loc12_ = _loc8_.OwnVicePets.Count >= _loc6_.VicePetNum;
         }
         else
         {
            _loc12_ = true;
         }
         _loc6_.Status = Boolean(_loc7_);
         _loc6_.IsUserLevel = _loc10_;
         _loc6_.IsMainPetStage = _loc11_;
         _loc6_.IsVicePetNum = _loc12_;
      }
      
      public function UnstreamizeFishCD(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_FishCD(param1,param2,param3);
      }
      
      public function UnstreamizeTrainPets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_TrainPets(param1,param2,param3);
      }
      
      public function UnstreamizeTrainPet(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_TrainPet(param1,param2,param3);
      }
      
      public function UnstreamizeGifts(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Gifts(param1,param2,param3);
      }
      
      public function UnstreamizeGift(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Gift(param1,param2,param3);
      }
   }
}

