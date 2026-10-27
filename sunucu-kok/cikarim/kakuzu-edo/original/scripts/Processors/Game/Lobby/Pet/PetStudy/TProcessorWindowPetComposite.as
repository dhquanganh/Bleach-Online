package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.TVicePetMake;
   import Logics.Inventories.*;
   import Logics.Pet.*;
   import Logics.Streamization.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.Components.*;
   import Processors.Game.Lobby.Pet.PetHouse.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowPetComposite extends TProcessorLobbyWindow
   {
      
      private static const CAPACITY_STUDY_COMPOSITE_PETS:int = CONST_PET.CAPACITY_STUDY_COMPOSITE_PETS;
      
      protected var FUnstreamizerPets:TUnstreamizerPets;
      
      protected var FPetData:TPetData;
      
      protected var FVicePetSelected:TVicePet;
      
      protected var FBtn_Composite:TUIButton;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FBmp_Pet:Bitmap;
      
      protected var FPetResourceID:uint;
      
      protected var FTF_Condition_1:TextField;
      
      protected var FTF_Condition_2:TextField;
      
      protected var FTF_Desc:TextField;
      
      protected var FTF_Chip:TextField;
      
      protected var FSP_Own:Sprite;
      
      protected var FMC_PetEffect:MovieClip;
      
      protected var FUIPetInfo:TUIPetInfo;
      
      protected var FUIPetList:TUIPetList;
      
      protected var FInitialization:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowPetComposite(param1:TUIComponent)
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
         var _loc3_:TBounds = null;
         var _loc4_:TCoordinate = null;
         this.FUnstreamizerPets = new TUnstreamizerPets();
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Composite) as Sprite;
         addChild(_loc1_);
         this.FBtn_Composite = new TUIButton();
         this.FBtn_Composite.Substrate = _loc1_["Btn_Composite"];
         this.FBtn_Composite.OnClick = this.Btn_CompositeOnClick;
         this.FTF_Level = _loc1_[CONST_PET.RESOURCE_Link_TF_Level];
         this.FTF_Name = _loc1_[CONST_PET.RESOURCE_Link_TF_Name];
         this.FSP_Own = _loc1_["SP_Own"];
         this.FMC_PetEffect = _loc1_[CONST_PET.RESOURCE_Link_MC_PetEffect];
         this.FTF_Condition_1 = _loc1_["TF_Condition_0"];
         this.FTF_Condition_2 = _loc1_["TF_Condition_1"];
         this.FTF_Desc = _loc1_["TF_Desc"];
         this.FTF_Chip = _loc1_["TF_Chip"];
         _loc2_ = _loc1_["SP_MountPoint"];
         this.FBmp_Pet = new Bitmap();
         _loc2_.addChild(this.FBmp_Pet);
         this.FUIPetInfo = new TUIPetInfo();
         this.FUIPetInfo.Resource = _loc1_[CONST_PET.RESOURCE_Link_SP_CurrentAttribute];
         this.FUIPetList = new TUIPetList(this);
         this.FUIPetList.PageSize = CAPACITY_STUDY_COMPOSITE_PETS;
         this.FUIPetList.Resource = _loc1_["SP_PetList"];
         this.FUIPetList.OnClick = this.UIPetListOnClick;
         this.FUIPetList.OnOver = this.ProcessorOnSlotOver;
         this.FUIPetList.OnOut = this.ProcessorOnSlotOut;
         this.FUIPetList.OnPetsFilter = this.ProcessorOnPetsFilter;
         this.FUIPetList.OnSetSlotFilters = this.ProcessorOnSetSlotFilters;
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
         var _loc3_:THero = null;
         var _loc4_:THeros = null;
         var _loc5_:TVicePet = null;
         var _loc6_:TVicePetMake = null;
         var _loc7_:TBins = null;
         var _loc8_:TInventories = null;
         var _loc9_:uint = 0;
         var _loc10_:Boolean = false;
         this.FTF_Name.text = "";
         this.FTF_Level.text = "";
         this.FTF_Condition_1.text = "";
         this.FTF_Condition_2.text = "";
         this.FTF_Desc.text = "";
         this.FTF_Chip.text = "";
         this.FSP_Own.visible = false;
         this.FUIPetInfo.Reset();
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VicePetMake);
         _loc8_ = SLogicsCore.Character.Appliances;
         _loc2_ = this.FPetData.VicePets.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc10_ = false;
            _loc5_ = this.FPetData.VicePets.GetPetByIndex(_loc1_) as TVicePet;
            _loc9_ = uint(_loc8_.GetCountByTempleteID(_loc5_.ConditionCompositePropID));
            if(_loc9_ >= _loc5_.ConditionCompositePropQuantity)
            {
               _loc10_ = true;
            }
            _loc5_.CompositeState = _loc10_;
            _loc1_++;
         }
         this.FUIPetList.Context = this.FPetData.VicePets;
         if(this.FVicePetSelected == null)
         {
            return;
         }
         this.FTF_Name.text = this.FVicePetSelected.Name;
         this.FTF_Level.text = TUtilityString.Format(STRING_COMMON.FORMAT_05,this.FVicePetSelected.Level);
         this.FTF_Condition_1.text = TUtilityString.Format(CONST_COMMON.STRING_Quantity,TUtilityLobby.GetItemName(CONST_COMMON.FIRSTTYPE_ITEM_INVENTORY,this.FVicePetSelected.ConditionCompositePropID),this.FVicePetSelected.ConditionCompositePropQuantity);
         this.FTF_Condition_2.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_15),this.FVicePetSelected.ConditionCompositePrice);
         this.FTF_Chip.text = SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FVicePetSelected.ConditionCompositePropID).toString();
         _loc6_ = _loc7_.GetDatebaseByIdentifier(this.FVicePetSelected.TemplateID) as TVicePetMake;
         this.FTF_Desc.text = _loc6_.PathWay;
         _loc4_ = SLogicsCore.Character.Heros;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetHeroByIndex(_loc1_);
            if(_loc3_.VicePetHighID != 0 && _loc3_.VicePetLowID != 0)
            {
               if(_loc3_.VicePetHighID == this.FVicePetSelected.Identifier0 && _loc3_.VicePetLowID == this.FVicePetSelected.Identifier1)
               {
                  this.FSP_Own.visible = true;
                  break;
               }
            }
            _loc1_++;
         }
         this.FUIPetInfo.RenderUI(this.FVicePetSelected.GetBaseAttributeByIndex,this.FVicePetSelected.GetPvPAttributeByIndex);
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
      
      protected function Btn_CompositeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCombineBtn);
         if(this.FPetData.GetCurrentStoreUsableCapacity() <= 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_18));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetMakeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FVicePetSelected.TemplateID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function UIPetListOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TVicePet = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCombinePetHead);
         _loc3_ = param2 as TVicePet;
         if(this.FVicePetSelected != _loc3_)
         {
            this.FVicePetSelected = _loc3_;
            this.UpdateUIPetInfo();
            this.FBtn_Composite.Enabled = _loc3_.CompositeState;
         }
      }
      
      protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TPetBase = null;
         _loc6_ = param2.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2.GetPetByIndex(_loc5_);
            if(_loc7_.Quality == param4)
            {
               param3.Add(_loc7_);
            }
            _loc5_++;
         }
         param3.SortCompositeState();
      }
      
      protected function ProcessorOnSetSlotFilters(param1:Object, param2:TPetBase, param3:TUISlot) : void
      {
         var _loc4_:TVicePet = null;
         _loc4_ = param2 as TVicePet;
         param3.SetDefaultFilters(!_loc4_.CompositeState);
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
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(!this.FInitialization)
         {
            return;
         }
         this.FMC_PetEffect.gotoAndStop(1);
         this.FMC_PetEffect.visible = false;
         this.FBtn_Composite.Enabled = false;
         this.FUIPetInfo.Reset();
         this.FTF_Level.text = "";
         this.FTF_Name.text = "";
         this.FTF_Condition_1.text = "";
         this.FTF_Condition_2.text = "";
         this.FTF_Chip.text = "";
         this.FBmp_Pet.bitmapData = null;
         this.FPetResourceID = 0;
         this.FSP_Own.visible = false;
         this.FVicePetSelected = null;
         this.FUIPetList.Context = null;
      }
      
      public function Update() : void
      {
         this.UpdateUIPetInfo();
      }
      
      public function UpdatePetInfo() : void
      {
         this.UpdateUIPetInfo();
      }
      
      public function PlayActivateEffect() : void
      {
         if(this.FMC_PetEffect != null)
         {
            this.FMC_PetEffect.play();
            this.FMC_PetEffect.visible = true;
         }
      }
   }
}

