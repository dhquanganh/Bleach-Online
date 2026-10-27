package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Inventories.*;
   import Logics.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.Components.*;
   import Processors.Game.Lobby.Pet.PetStudy.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowPetAdvance extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_STUDY_COMPOSITE_PETS:int = CONST_PET.CAPACITY_STUDY_COMPOSITE_PETS;
      
      protected var FPetData:TPetData;
      
      protected var FVicePetSelected:TVicePet;
      
      protected var FTF_Name:TextField;
      
      protected var FBmp_Pet:Bitmap;
      
      protected var FPetResourceID:uint;
      
      protected var FTF_Condition_0:TextField;
      
      protected var FTF_Condition_1:TextField;
      
      protected var FTF_Condition_2:TextField;
      
      protected var FBtn_Advance:TUIButton;
      
      protected var FMC_PetEffect:MovieClip;
      
      protected var FBtnMax:TUIButton;
      
      protected var FUIPetInfoCurrent:TUIVicePetInfo;
      
      protected var FUIPetInfoNext:TUIVicePetInfo;
      
      protected var FUIPetList:TUIPetList;
      
      protected var FInitialization:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowPetAdvance(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetStudy);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Advance) as Sprite;
         addChild(_loc2_);
         this.FTF_Name = _loc2_[CONST_PET.RESOURCE_Link_TF_Name];
         _loc1_ = _loc2_[CONST_PET.RESOURCE_Link_SP_MountPoint];
         this.FBmp_Pet = new Bitmap();
         _loc1_.addChild(this.FBmp_Pet);
         _loc1_ = _loc2_["SP_Condition"];
         this.FTF_Condition_0 = _loc1_["TF_Condition_0"];
         this.FTF_Condition_1 = _loc1_["TF_Condition_1"];
         this.FTF_Condition_2 = _loc1_["TF_Condition_2"];
         this.FBtnMax = new TUIButton();
         this.FBtnMax.Substrate = _loc2_["Btn_Max"];
         this.FBtnMax.OnMove = this.MaxTipOnOver;
         this.FBtnMax.OnOut = this.MaxTipOnOut;
         this.FBtn_Advance = new TUIButton();
         this.FBtn_Advance.Substrate = _loc1_["Btn_Advance"];
         this.FBtn_Advance.OnClick = this.Btn_AdvanceOnClick;
         this.FUIPetInfoCurrent = new TUIVicePetInfo();
         this.FUIPetInfoCurrent.Resource = _loc2_[CONST_PET.RESOURCE_Link_SP_CurrentAttribute];
         this.FUIPetInfoNext = new TUIVicePetInfo();
         this.FUIPetInfoNext.Resource = _loc2_[CONST_PET.RESOURCE_Link_SP_NextAttribute];
         this.FUIPetList = new TUIPetList(this);
         this.FUIPetList.PageSize = CAPACITY_STUDY_COMPOSITE_PETS;
         this.FUIPetList.Resource = _loc2_["SP_PetList"];
         this.FUIPetList.OnClick = this.UIPetListOnClick;
         this.FUIPetList.OnOver = this.ProcessorOnSlotOver;
         this.FUIPetList.OnOut = this.ProcessorOnSlotOut;
         this.FUIPetList.OnPetsFilter = this.ProcessorOnPetsFilter;
         this.FMC_PetEffect = _loc2_[CONST_PET.RESOURCE_Link_MC_PetEffect];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
         this.FUIPetList.Update();
         this.LogicsPerform_CompositeEffect();
      }
      
      protected function LogicsPerform_CompositeEffect() : void
      {
         if(this.FMC_PetEffect.currentFrame == this.FMC_PetEffect.totalFrames)
         {
            this.UpdateUIPetInfo();
            this.FMC_PetEffect.gotoAndStop(1);
            this.FMC_PetEffect.visible = false;
         }
      }
      
      protected function UpdateUIPetInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVicePet = null;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         this.FTF_Name.text = "";
         this.FTF_Condition_0.text = "";
         this.FTF_Condition_1.text = "";
         this.FTF_Condition_2.text = "";
         this.FUIPetInfoCurrent.Reset();
         this.FUIPetInfoNext.Reset();
         this.FBtn_Advance.Enabled = false;
         _loc6_ = false;
         _loc7_ = false;
         this.FUIPetList.Context = this.FPetData.OwnVicePets;
         if(this.FVicePetSelected == null)
         {
            return;
         }
         if(this.FVicePetSelected.Level >= this.FVicePetSelected.ConditionAdvancePetLevel)
         {
            _loc6_ = true;
         }
         _loc4_ = SLogicsCore.Character.Appliances;
         _loc5_ = uint(_loc4_.GetCountByTempleteID(this.FVicePetSelected.ConditionAdvancePropID));
         if(_loc5_ >= this.FVicePetSelected.ConditionAdvancePropQuantity)
         {
            _loc7_ = true;
         }
         this.FBtn_Advance.Enabled = _loc6_ && _loc7_;
         this.FVicePetSelected.AllowAdvance = _loc6_ && _loc7_;
         this.FTF_Name.text = this.FVicePetSelected.Name;
         _loc8_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FVicePetSelected.ConditionCompositePropID));
         _loc9_ = int(this.FVicePetSelected.ConditionAdvancePropQuantity);
         _loc10_ = TUtilityLobby.GetColorStringByCount(_loc8_,_loc9_,_loc8_ + "/" + _loc9_);
         this.FTF_Condition_0.htmlText = TUtilityLobby.GetItemName(CONST_COMMON.FIRSTTYPE_ITEM_INVENTORY,this.FVicePetSelected.ConditionAdvancePropID) + " " + _loc10_;
         this.FTF_Condition_1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_15),this.FVicePetSelected.ConditionAdvancePrice);
         this.FTF_Condition_2.text = TUtilityString.Format(STRING_COMMON.FORMAT_05,this.FVicePetSelected.ConditionAdvancePetLevel);
         this.FUIPetInfoCurrent.RenderUI(this.FVicePetSelected.GetBaseAttributeByIndex,this.FVicePetSelected.GetPvPAttributeByIndex);
         this.FUIPetInfoCurrent.SetLevel(this.FVicePetSelected.Level);
         if(this.FVicePetSelected.PetState == CONST_PET.PetState_NoNextLevel_CanAdvance || this.FVicePetSelected.PetState == CONST_PET.PetState_HasNextLevel)
         {
            this.FUIPetInfoNext.RenderUI(this.FVicePetSelected.GetNextBaseAttributeByIndex,this.FVicePetSelected.GetNextPvPAttributeByIndex);
            this.FUIPetInfoNext.SetLevel(this.FVicePetSelected.ConditionAdvancePetLevel);
         }
         else
         {
            this.FUIPetInfoNext.Reset();
         }
         this.FPetResourceID = this.FVicePetSelected.LargeIconID;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetResourceID,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FPetResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FBmp_Pet.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function GetPrePetInfo(param1:TVicePetRankUpInfo, param2:int) : TVicePetRankUpInfo
      {
         if(param1 == null || param1.PetId == param2)
         {
            return param1;
         }
         return this.GetPrePetInfo(param1.PreInfo,param2);
      }
      
      protected function Btn_AdvanceOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetRankUpReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FVicePetSelected.Identifier0);
         _loc4_.writeUnsignedInt(this.FVicePetSelected.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function UIPetListOnClick(param1:Object, param2:Object) : void
      {
         this.FVicePetSelected = param2 as TVicePet;
         if(!this.FVicePetSelected.AdvanceState)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_60));
            return;
         }
         this.UpdateUIPetInfo();
      }
      
      protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TVicePet = null;
         _loc6_ = param2.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2.GetPetByIndex(_loc5_) as TVicePet;
            if(_loc7_.AdvanceState)
            {
            }
            if(_loc7_.Quality == param4)
            {
               param3.Add(_loc7_);
            }
            _loc5_++;
         }
         param3.Sort();
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param1,param2);
         }
      }
      
      protected function MaxTipOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.FOnSlotOver == null || this.FVicePetSelected == null)
         {
            return;
         }
         _loc3_ = this.FPetData.VicePets.GetIndexByPetID(this.FVicePetSelected.TemplateID);
         if(_loc3_ == -1)
         {
            return;
         }
         this.FOnSlotOver(null,this.FPetData.MaxVicePets.GetPetByIndex(_loc3_));
      }
      
      protected function MaxTipOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FVicePetSelected == null)
         {
            return;
         }
         this.FOnSlotOut(param1,null);
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function Reset(param1:Boolean = true) : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FMC_PetEffect.gotoAndStop(1);
         this.FMC_PetEffect.visible = false;
         this.FTF_Name.text = "";
         this.FBmp_Pet.bitmapData = null;
         this.FPetResourceID = 0;
         this.FTF_Condition_0.text = "";
         this.FTF_Condition_1.text = "";
         this.FTF_Condition_2.text = "";
         this.FVicePetSelected = null;
         this.FUIPetInfoCurrent.Reset();
         this.FUIPetInfoNext.Reset();
         if(param1)
         {
            this.FUIPetList.Context = null;
         }
      }
      
      public function Update() : void
      {
         this.UpdateUIPetInfo();
      }
      
      public function PlayActivateEffect() : void
      {
         this.FMC_PetEffect.play();
         this.FMC_PetEffect.visible = true;
      }
   }
}

