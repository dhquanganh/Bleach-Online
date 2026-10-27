package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.Pet.TPets;
   import Logics.Pet.TVicePet;
   import Logics.Pet.TVicePetRankUpInfo;
   import Logics.Pet.Train.TTrainData;
   import Logics.Pet.Train.TTrainDatas;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_PET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowPetWash extends TProcessorWindowPetInheritBase
   {
      
      protected var FBtnWash:TUIButton;
      
      protected var FTF_Condition_2:TextField;
      
      protected var FPetLevelUpVO:TPetLevelUp;
      
      protected var FPetTemplateID:int;
      
      protected var FPetWashExp:int;
      
      public function TProcessorWindowPetWash(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         FResource = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Wash) as Sprite;
         addChild(FResource);
         super.ResourcesPerform_UIDispatch();
         this.FTF_Condition_2 = FResource["TF_Desc_2"];
         this.FBtnWash = new TUIButton();
         this.FBtnWash.Substrate = FResource["Btn_Wash"];
         this.FBtnWash.OnClick = this.ProcessorOnWashClick;
         FMcEffect = FResource["MC_Effect"];
         FMcEffect.stop();
         FMcEffect.visible = false;
         FMcEffect.addFrameScript(FMcEffect.totalFrames - 1,InheritEffectOnEnd);
      }
      
      override protected function UpdateUIPetInfo() : void
      {
         var _loc1_:TPetLevelUp = null;
         super.UpdateUIPetInfo();
         this.FTF_Condition_2.text = "";
         if(FVicePetSelected == null)
         {
            return;
         }
         this.FBtnWash.Enabled = true;
         _loc1_ = FPetLevelUpBins.GetDatebaseByIdentifier(GetIdentifier(FVicePetSelected.TemplateID,FVicePetSelected.Level)) as TPetLevelUp;
         if(_loc1_.Level <= 1 && FVicePetSelected.Experience <= 0)
         {
            FUIPetList.Update();
            SetIgnoreResource(_loc1_.PetResourceID);
            FVicePetSelected = null;
            FBmp_Pet.bitmapData = null;
            super.UpdateUIPetInfo();
            return;
         }
         SetIgnoreResource(0);
         this.FPetTemplateID = FVicePetSelected.TemplateID;
         this.FPetLevelUpVO = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,GetIdentifier(this.FPetTemplateID,FVicePetSelected.Level)) as TPetLevelUp;
         this.FPetWashExp = (this.FPetLevelUpVO.TotalExpp + FVicePetSelected.Experience) * FInheritRate;
         FTF_Condition_0.text = this.FPetLevelUpVO.TotalExpp + "";
         FTF_Condition_1.text = this.GetChipByPetId(this.FPetTemplateID,this.FPetLevelUpVO.IsMaxLevel) + "";
         this.FTF_Condition_2.text = this.FPetWashExp + "";
      }
      
      protected function GetChipByPetId(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TVicePetRankUpInfo = null;
         _loc3_ = 0;
         while(_loc3_ < FPetData.RankupInfo.length)
         {
            if(this.GetPrePetInfo(FPetData.RankupInfo[_loc3_],param1) == null)
            {
               if(FPetData.RankupInfo[_loc3_].NextInfo.PetId == param1)
               {
                  _loc5_ = FPetData.RankupInfo[_loc3_].NextInfo;
                  break;
               }
            }
            else
            {
               _loc5_ = this.GetPrePetInfo(FPetData.RankupInfo[_loc3_],param1);
               if(_loc5_ != null)
               {
                  break;
               }
            }
            _loc3_++;
         }
         return this.GetPreInfoChip(_loc5_);
      }
      
      protected function GetPrePetInfo(param1:TVicePetRankUpInfo, param2:int) : TVicePetRankUpInfo
      {
         if(param1 == null || param1.PetId == param2)
         {
            return param1;
         }
         return this.GetPrePetInfo(param1.PreInfo,param2);
      }
      
      protected function GetPreInfoChip(param1:TVicePetRankUpInfo) : int
      {
         var _loc2_:int = 0;
         if(param1 != null && param1.PreInfo != null)
         {
            _loc2_ += param1.PreInfo.VicePetRankUp.Condition[1];
            _loc2_ += this.GetPreInfoChip(param1.PreInfo);
         }
         return _loc2_;
      }
      
      protected function Inherit_CS_Pet_VicePetWashExpReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetWashExpReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(FVicePetSelected.Identifier0);
         _loc3_.writeUnsignedInt(FVicePetSelected.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      override protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TVicePet = null;
         var _loc8_:TTrainData = null;
         var _loc9_:TTrainDatas = null;
         _loc6_ = param2.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2.GetPetByIndex(_loc5_) as TVicePet;
            if(!(_loc7_.Level == 1 && _loc7_.Experience == 0))
            {
               if(_loc7_.Quality == param4)
               {
                  param3.Add(_loc7_);
               }
            }
            _loc5_++;
         }
         _loc9_ = FPetData.TrainDatas;
         _loc6_ = _loc9_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = _loc9_.GetTrainDataByIndex(_loc5_);
            param3.DeletePetByIdentifier(_loc8_.VicePetHighID,_loc8_.VicePetLowID);
            _loc5_++;
         }
         param3.Sort();
      }
      
      protected function ProcessorOnWashClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         if(FVicePetSelected == null)
         {
            return;
         }
         if(this.FPetWashExp > FPoolTotal - FPetData.InheritPoolExp)
         {
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_46),this.FPetWashExp,FPoolTotal);
         }
         else
         {
            _loc3_ = "";
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = _loc3_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_44);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.Inherit_CS_Pet_VicePetWashExpReq;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      override public function Reset() : void
      {
         if(!FInitialization)
         {
            return;
         }
         super.Reset();
         this.FTF_Condition_2.text = "";
         this.FBtnWash.Enabled = false;
      }
   }
}

