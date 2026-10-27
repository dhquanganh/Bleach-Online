package Logics.Streamization.Pet
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.DatebaseVO.VO.TVicePetRankUp;
   import Logics.Pet.*;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.*;
   
   public class TUnstreamizerPets extends TUnstreamizerPetUnknown
   {
      
      public function TUnstreamizerPets()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationPerform_MainPets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TMainPet = null;
         var _loc9_:TPetData = null;
         _loc9_ = param2 as TPetData;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc8_ = _loc9_.OwnMainPets.GetPetByIdentifier(_loc6_,0) as TMainPet;
            if(_loc8_ == null)
            {
               _loc8_ = FPoolPet.AcquireMainPet(_loc6_);
               _loc9_.OwnMainPets.Add(_loc8_);
            }
            _loc8_.TemplateID = _loc6_;
            _loc8_.Level = param1.readUnsignedInt();
            _loc8_.Experience = param1.readUnsignedInt();
            FUnstreamizerPet.UnstreamizeMainPet(param1,_loc8_,null);
            _loc4_++;
         }
         _loc9_.OwnMainPets.Sort();
      }
      
      protected function UnstreamizationPerform_VicePets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TVicePet = null;
         var _loc9_:TPetData = null;
         _loc9_ = param2 as TPetData;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = _loc9_.OwnVicePets.GetPetByIdentifier(_loc6_,_loc7_) as TVicePet;
            if(_loc8_ == null)
            {
               _loc8_ = FPoolPet.AcquireVicePet(_loc6_,_loc7_);
               _loc9_.OwnVicePets.Add(_loc8_);
            }
            _loc8_.TemplateID = param1.readUnsignedInt();
            _loc8_.Level = param1.readUnsignedInt();
            _loc8_.Experience = param1.readUnsignedInt();
            FUnstreamizerPet.UnstreamizeVicePet(param1,_loc8_,null);
            _loc4_++;
         }
         _loc9_.OwnVicePets.Sort();
      }
      
      protected function UnstreamizationPerform_GenerateMainPets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPetData = null;
         var _loc7_:TMainPet = null;
         var _loc8_:TBins = null;
         var _loc9_:TPetLevelUp = null;
         _loc6_ = param2 as TPetData;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PetLevelUp);
         _loc5_ = _loc8_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc8_.GetDatebaseByIndex(_loc4_) as TPetLevelUp;
            if(_loc9_.SourcePet > 0)
            {
               break;
            }
            if(_loc9_.Level == 1)
            {
               _loc7_ = FPoolPet.AcquireMainPet(_loc9_.PetId);
               _loc6_.MainPets.Add(_loc7_);
               _loc7_.TemplateID = _loc9_.PetId;
               _loc7_.Level = _loc9_.Level;
               FUnstreamizerPet.UnstreamizeMainPet(param1,_loc7_,null);
            }
            else if(_loc9_.IsMaxLevel == 1)
            {
               _loc7_ = FPoolPet.AcquireMainPet(_loc9_.PetId);
               _loc6_.MaxMainPets.Add(_loc7_);
               _loc7_.TemplateID = _loc9_.PetId;
               _loc7_.Level = _loc9_.Level;
               FUnstreamizerPet.UnstreamizeMainPet(param1,_loc7_,null);
            }
            _loc4_++;
         }
         _loc6_.MainPets.Sort();
      }
      
      protected function UnstreamizationPerform_GenerateVicePets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TVicePet = null;
         var _loc9_:TPetData = null;
         var _loc10_:TBins = null;
         var _loc11_:TPetLevelUp = null;
         var _loc12_:TVicePetRankUpInfo = null;
         _loc9_ = param2 as TPetData;
         _loc10_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PetLevelUp);
         _loc5_ = _loc10_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc10_.GetDatebaseByIndex(_loc4_) as TPetLevelUp;
            if(_loc11_.SourcePet != 0)
            {
               if(_loc11_.Level == 1)
               {
                  _loc8_ = FPoolPet.AcquireVicePet();
                  _loc9_.VicePets.Add(_loc8_);
                  _loc8_.TemplateID = _loc11_.PetId;
                  _loc8_.Level = _loc11_.Level;
                  FUnstreamizerPet.UnstreamizeVicePet(param1,_loc8_,null);
               }
               else if(_loc11_.IsMaxLevel == 1)
               {
                  _loc8_ = FPoolPet.AcquireVicePet();
                  _loc9_.MaxNomalVicePets.Add(_loc8_);
                  _loc8_.TemplateID = _loc11_.PetId;
                  _loc8_.Level = _loc11_.Level;
                  FUnstreamizerPet.UnstreamizeVicePet(param1,_loc8_,null);
                  _loc7_ = int(_loc9_.RankupInfo.length);
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     _loc12_ = _loc9_.RankupInfo[_loc6_];
                     if(_loc12_.NextInfo.PetId == _loc11_.PetId)
                     {
                        _loc8_ = FPoolPet.AcquireVicePet();
                        _loc9_.MaxVicePets.Add(_loc8_);
                        _loc8_.TemplateID = _loc11_.PetId;
                        _loc8_.Level = _loc11_.Level;
                        FUnstreamizerPet.UnstreamizeVicePet(param1,_loc8_,null);
                        break;
                     }
                     _loc6_++;
                  }
               }
            }
            _loc4_++;
         }
         _loc9_.VicePets.Sort();
         _loc9_.MaxVicePets.Sort();
      }
      
      protected function UnstreamizationPerform_InitVicePetRankUp(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TPetData = null;
         var _loc5_:int = 0;
         var _loc6_:TVicePetRankUp = null;
         var _loc7_:TVicePetRankUp = null;
         var _loc8_:TVicePetRankUpInfo = null;
         var _loc9_:TVicePetRankUpInfo = null;
         var _loc10_:TVicePetRankUpInfo = null;
         var _loc11_:TBins = null;
         _loc11_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VicePetRankUp);
         _loc4_ = param2 as TPetData;
         _loc8_ = null;
         _loc5_ = 0;
         while(_loc5_ < _loc11_.Count)
         {
            _loc10_ = new TVicePetRankUpInfo();
            if(_loc8_ != null)
            {
               _loc8_.NextInfo = _loc10_;
            }
            _loc10_.PreInfo = _loc8_;
            _loc8_ = _loc10_;
            _loc6_ = _loc11_.GetDatebaseByIndex(_loc5_) as TVicePetRankUp;
            _loc10_.VicePetRankUp = _loc6_;
            _loc10_.PetId = _loc6_.Identifier;
            _loc7_ = _loc11_.GetDatebaseByIdentifier(_loc6_.NextPetId) as TVicePetRankUp;
            if(_loc7_ == null)
            {
               _loc8_ = null;
               _loc9_ = new TVicePetRankUpInfo();
               _loc9_.PetId = _loc6_.NextPetId;
               _loc9_.PreInfo = _loc10_;
               _loc10_.NextInfo = _loc9_;
               _loc4_.RankupInfo.push(_loc10_);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeMainPets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_MainPets(param1,param2,param3);
      }
      
      public function UnstreamizeVicePets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_VicePets(param1,param2,param3);
      }
      
      public function UnstreamizeGenerateMainPets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateMainPets(param1,param2,param3);
      }
      
      public function UnstreamizeGenerateVicePets(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateVicePets(param1,param2,param3);
      }
      
      public function UnstreamizeInitVicePetRankUp(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InitVicePetRankUp(param1,param2,param3);
      }
   }
}

