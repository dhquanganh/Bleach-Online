package Logics.Pet
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Pet.Gift.TGifts;
   import Logics.Pet.Train.TTrainDatas;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TPetData
   {
      
      protected var FOwnMainPets:TPets;
      
      protected var FOwnVicePets:TPets;
      
      protected var FMainPets:TPets;
      
      protected var FMaxMainPets:TPets;
      
      protected var FVicePets:TPets;
      
      protected var FMaxVicePets:TPets;
      
      protected var FMaxNomalVicePets:TPets;
      
      protected var FFishAddCountCost:Vector.<int>;
      
      protected var FFishCount:uint;
      
      protected var FFishCD:uint;
      
      protected var FFishCDTime:uint;
      
      protected var FBuyFishCount:uint;
      
      protected var FBuyVicePetStorageSlotCount:uint;
      
      protected var FBuyVicePetTrainSlotCount:uint;
      
      protected var FMainPetItemNum:uint;
      
      protected var FPetBagMask:uint;
      
      protected var FTrainTotalCD:uint;
      
      protected var FTrainCDCount:uint;
      
      protected var FFishCountLimit:uint;
      
      protected var FBuyFishCountLimit:uint;
      
      protected var FVicePetTrainSlotCount:uint;
      
      protected var FPetStudyStoreCapacity:uint;
      
      protected var FTrainDatas:TTrainDatas;
      
      protected var FGifts:TGifts;
      
      protected var FMainPetSelected:TMainPet;
      
      protected var FInheritExtendTimes:int;
      
      protected var FInheritPoolExp:int;
      
      protected var FRankupInfo:Vector.<TVicePetRankUpInfo>;
      
      public function TPetData()
      {
         super();
         this.FOwnMainPets = new TPets();
         this.FOwnVicePets = new TPets();
         this.FMainPets = new TPets();
         this.FMaxMainPets = new TPets();
         this.FVicePets = new TPets();
         this.FMaxVicePets = new TPets();
         this.FMaxNomalVicePets = new TPets();
         this.FTrainDatas = new TTrainDatas();
         this.FGifts = new TGifts();
         this.FRankupInfo = new Vector.<TVicePetRankUpInfo>();
      }
      
      public function get OwnMainPets() : TPets
      {
         return this.FOwnMainPets;
      }
      
      public function get OwnVicePets() : TPets
      {
         return this.FOwnVicePets;
      }
      
      public function get MainPets() : TPets
      {
         return this.FMainPets;
      }
      
      public function get MaxMainPets() : TPets
      {
         return this.FMaxMainPets;
      }
      
      public function get VicePets() : TPets
      {
         return this.FVicePets;
      }
      
      public function get MaxVicePets() : TPets
      {
         return this.FMaxVicePets;
      }
      
      public function get MaxNomalVicePets() : TPets
      {
         return this.FMaxNomalVicePets;
      }
      
      public function get FishCount() : uint
      {
         return this.FFishCount;
      }
      
      public function set FishCount(param1:uint) : void
      {
         this.FFishCount = param1;
      }
      
      public function get FishCD() : uint
      {
         return this.FFishCD;
      }
      
      public function set FishCD(param1:uint) : void
      {
         this.FFishCD = param1;
      }
      
      public function get FishCDTime() : uint
      {
         return this.FFishCDTime;
      }
      
      public function set FishCDTime(param1:uint) : void
      {
         this.FFishCDTime = param1;
      }
      
      public function get BuyFishCount() : uint
      {
         return this.FBuyFishCount;
      }
      
      public function set BuyFishCount(param1:uint) : void
      {
         this.FBuyFishCount = param1;
      }
      
      public function get BuyVicePetStorageSlotCount() : uint
      {
         return this.FBuyVicePetStorageSlotCount;
      }
      
      public function set BuyVicePetStorageSlotCount(param1:uint) : void
      {
         this.FBuyVicePetStorageSlotCount = param1;
      }
      
      public function get BuyVicePetTrainSlotCount() : uint
      {
         return this.FBuyVicePetTrainSlotCount;
      }
      
      public function set BuyVicePetTrainSlotCount(param1:uint) : void
      {
         this.FBuyVicePetTrainSlotCount = param1;
      }
      
      public function get MainPetItemNum() : uint
      {
         return this.FMainPetItemNum;
      }
      
      public function set MainPetItemNum(param1:uint) : void
      {
         this.FMainPetItemNum = param1;
      }
      
      public function GetPetBagMaskByIndex(param1:uint) : uint
      {
         return this.FPetBagMask & 1 << param1;
      }
      
      public function SetPetBagMaskByIndex(param1:uint) : void
      {
         this.FPetBagMask |= 1 << param1;
      }
      
      public function get PetBagMask() : uint
      {
         return this.FPetBagMask;
      }
      
      public function set PetBagMask(param1:uint) : void
      {
         this.FPetBagMask = param1;
      }
      
      public function get TrainTotalCD() : uint
      {
         return this.FTrainTotalCD;
      }
      
      public function set TrainTotalCD(param1:uint) : void
      {
         this.FTrainTotalCD = param1;
      }
      
      public function get TrainCDCount() : uint
      {
         return this.FTrainCDCount;
      }
      
      public function set TrainCDCount(param1:uint) : void
      {
         this.FTrainCDCount = param1;
      }
      
      public function get FishCountLimit() : uint
      {
         return this.FFishCountLimit;
      }
      
      public function set FishCountLimit(param1:uint) : void
      {
         this.FFishCountLimit = param1;
      }
      
      public function get BuyFishCountLimit() : uint
      {
         return this.FBuyFishCountLimit;
      }
      
      public function set BuyFishCountLimit(param1:uint) : void
      {
         this.FBuyFishCountLimit = param1;
      }
      
      public function get CurrentBuyFishCountLimit() : uint
      {
         return this.FishCountLimit + this.BuyFishCount;
      }
      
      public function get CurrentVicePetTrainSlotCount() : uint
      {
         return this.FBuyVicePetTrainSlotCount + this.FVicePetTrainSlotCount;
      }
      
      public function get VicePetTrainSlotCount() : uint
      {
         return this.FVicePetTrainSlotCount;
      }
      
      public function set VicePetTrainSlotCount(param1:uint) : void
      {
         this.FVicePetTrainSlotCount = param1;
      }
      
      public function get PetStudyStoreCapacity() : uint
      {
         return this.FPetStudyStoreCapacity;
      }
      
      public function get CurrentPetCapacity() : uint
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:uint = 0;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Vice_Pet_Limit_Num) as TConfigValue;
         _loc4_ = uint(SLogicsCore.Character.GetMainLevel());
         _loc2_ = _loc1_.Value as Vector.<Object>;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = parseInt(_loc3_.level);
            if(_loc4_ >= _loc5_)
            {
               _loc7_ = parseInt(_loc3_.num);
            }
         }
         SLogicsCore.PetData.PetStudyStoreCapacity = _loc7_;
         return _loc7_;
      }
      
      public function set PetStudyStoreCapacity(param1:uint) : void
      {
         this.FPetStudyStoreCapacity = param1;
      }
      
      public function get TrainDatas() : TTrainDatas
      {
         return this.FTrainDatas;
      }
      
      public function get Gifts() : TGifts
      {
         return this.FGifts;
      }
      
      public function get MainPetSelected() : TMainPet
      {
         return this.FMainPetSelected;
      }
      
      public function set MainPetSelected(param1:TMainPet) : void
      {
         this.FMainPetSelected = param1;
      }
      
      public function get FishAddCountCost() : Vector.<int>
      {
         return this.FFishAddCountCost;
      }
      
      public function set FishAddCountCost(param1:Vector.<int>) : void
      {
         this.FFishAddCountCost = param1;
      }
      
      public function get InheritExtendTimes() : int
      {
         return this.FInheritExtendTimes;
      }
      
      public function set InheritExtendTimes(param1:int) : void
      {
         this.FInheritExtendTimes = param1;
      }
      
      public function get InheritPoolExp() : int
      {
         return this.FInheritPoolExp;
      }
      
      public function set InheritPoolExp(param1:int) : void
      {
         this.FInheritPoolExp = param1;
      }
      
      public function get RankupInfo() : Vector.<TVicePetRankUpInfo>
      {
         return this.FRankupInfo;
      }
      
      public function set RankupInfo(param1:Vector.<TVicePetRankUpInfo>) : void
      {
         this.FRankupInfo = param1;
      }
      
      public function GetCurrentStoreTotalCapacity() : uint
      {
         return this.FPetStudyStoreCapacity + this.FBuyVicePetStorageSlotCount;
      }
      
      public function GetCurrentStoreUsed() : uint
      {
         return this.FOwnVicePets.Count;
      }
      
      public function GetCurrentStoreUsableCapacity() : int
      {
         return this.FPetStudyStoreCapacity + this.FBuyVicePetStorageSlotCount - this.FOwnVicePets.Count;
      }
      
      public function Reset() : void
      {
         this.FTrainDatas.Clear();
         this.FGifts.Clear();
         this.FMainPetSelected = null;
      }
   }
}

