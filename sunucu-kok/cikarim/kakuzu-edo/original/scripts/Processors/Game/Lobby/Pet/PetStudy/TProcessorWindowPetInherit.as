package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.Pet.TPets;
   import Logics.Pet.TVicePet;
   import Logics.Pet.Train.TTrainData;
   import Logics.Pet.Train.TTrainDatas;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_PET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowPetInherit extends TProcessorWindowPetInheritBase
   {
      
      protected var FBtnInherit:TUIButton;
      
      public function TProcessorWindowPetInherit(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         FResource = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Inherit) as Sprite;
         addChild(FResource);
         super.ResourcesPerform_UIDispatch();
         this.FBtnInherit = new TUIButton();
         this.FBtnInherit.Substrate = FResource["Btn_Inherit"];
         this.FBtnInherit.OnClick = this.ProcessorOnInheritClick;
         FMcEffect = FResource["MC_Effect"];
         FMcEffect.stop();
         FMcEffect.visible = false;
         FMcEffect.addFrameScript(FMcEffect.totalFrames - 1,InheritEffectOnEnd);
      }
      
      override protected function UpdateUIPetInfo() : void
      {
         var _loc1_:TPetLevelUp = null;
         var _loc2_:TPetLevelUp = null;
         var _loc3_:TPetLevelUp = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         super.UpdateUIPetInfo();
         if(FVicePetSelected == null)
         {
            return;
         }
         this.FBtnInherit.Enabled = true;
         _loc1_ = FPetLevelUpBins.GetDatebaseByIdentifier(GetIdentifier(FVicePetSelected.TemplateID,FVicePetSelected.Level)) as TPetLevelUp;
         if(_loc1_.IsMaxLevel != 0)
         {
            FUIPetList.Update();
            FVicePetSelected = null;
            SetIgnoreResource(_loc1_.PetResourceID);
            FBmp_Pet.bitmapData = null;
            super.UpdateUIPetInfo();
            return;
         }
         SetIgnoreResource(0);
         _loc4_ = FPetData.InheritPoolExp;
         _loc5_ = _loc1_.TotalExpp + FVicePetSelected.Experience;
         _loc3_ = _loc1_;
         while(true)
         {
            if(_loc3_.IsMaxLevel != 0)
            {
               _loc6_ = int(_loc3_.Level);
               _loc7_ = _loc3_.TotalExpp - _loc5_;
               break;
            }
            _loc2_ = FPetLevelUpBins.GetDatebaseByIdentifier(GetIdentifier(_loc3_.PetId,_loc3_.Level + 1)) as TPetLevelUp;
            if(_loc2_.TotalExpp - _loc5_ > _loc4_)
            {
               _loc6_ = int(_loc3_.Level);
               _loc7_ = _loc4_;
               break;
            }
            _loc3_ = _loc2_;
         }
         FTF_Condition_0.text = _loc7_ + "";
         FTF_Condition_1.text = _loc6_ + "";
      }
      
      override protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TVicePet = null;
         var _loc8_:TPetLevelUp = null;
         var _loc9_:TTrainData = null;
         var _loc10_:TTrainDatas = null;
         _loc6_ = param2.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2.GetPetByIndex(_loc5_) as TVicePet;
            _loc8_ = FPetLevelUpBins.GetDatebaseByIdentifier(GetIdentifier(_loc7_.TemplateID,_loc7_.Level)) as TPetLevelUp;
            if(_loc8_.IsMaxLevel != 1)
            {
               if(_loc7_.Quality == param4)
               {
                  param3.Add(_loc7_);
               }
            }
            _loc5_++;
         }
         _loc10_ = FPetData.TrainDatas;
         _loc6_ = _loc10_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc9_ = _loc10_.GetTrainDataByIndex(_loc5_);
            param3.DeletePetByIdentifier(_loc9_.VicePetHighID,_loc9_.VicePetLowID);
            _loc5_++;
         }
         param3.Sort();
      }
      
      protected function Inherit_CS_Pet_VicePetInheritReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetInheritReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(FVicePetSelected.Identifier0);
         _loc3_.writeUnsignedInt(FVicePetSelected.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOnInheritClick(param1:Object, param2:MouseEvent) : void
      {
         if(FVicePetSelected == null)
         {
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_45);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.Inherit_CS_Pet_VicePetInheritReq;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      override public function Reset() : void
      {
         if(!FInitialization)
         {
            return;
         }
         this.FBtnInherit.Enabled = false;
         super.Reset();
      }
   }
}

