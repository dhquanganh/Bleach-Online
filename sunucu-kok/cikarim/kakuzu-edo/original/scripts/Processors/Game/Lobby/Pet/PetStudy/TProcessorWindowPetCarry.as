package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.Components.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowPetCarry extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_HEROS:int = CONST_PET.CAPACITY_HEROS;
      
      protected static const CAPACITY_STUDY_CARRY_PETS:int = CONST_PET.CAPACITY_STUDY_CARRY_PETS;
      
      protected static const CAPACITY_PvpAttribute:uint = CONST_PET.CAPACITY_PvpAttribute;
      
      protected static const MAPPING_BASEATTRIBUTES:Vector.<uint> = Vector.<uint>([CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalAttack,CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalDefends,CONST_COMMON.BASEATTRIBUTEINDEX_MagicAttack,CONST_COMMON.BASEATTRIBUTEINDEX_MagicDefends,CONST_COMMON.BASEATTRIBUTEINDEX_Speed,CONST_COMMON.BASEATTRIBUTEINDEX_Health]);
      
      protected var FCharacter:TCharacter;
      
      protected var FPetData:TPetData;
      
      protected var FHero:THero;
      
      protected var FUISlotPet:TUISlot;
      
      protected var FTF_Name:TextField;
      
      protected var FBtn_Dismount:TUIButton;
      
      protected var FTF_BaseAttributes:Vector.<TextField>;
      
      protected var FUITabHeros:TUITab;
      
      protected var FUIPageHeros:TUIPage;
      
      protected var FUIPetList:TUIPetList;
      
      protected var FTabHeroIndex:int;
      
      protected var FPageHeroIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowPetCarry(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FPetData = SLogicsCore.PetData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetStudy);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Carry) as Sprite;
         this.addChild(_loc2_);
         this.FBtn_Dismount = new TUIButton();
         this.FBtn_Dismount.Substrate = _loc2_["Btn_Dismount"];
         this.FBtn_Dismount.OnClick = this.Btn_DismountOnClick;
         this.FUISlotPet = new TUISlot(this);
         this.FUISlotPet.Resource = _loc2_[CONST_COMMON.RESOURCE_Link_MC_Slot];
         this.FUISlotPet.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlotPet.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FUISlotPet.OnOver = this.ProcessorOnSlotOver;
         this.FUISlotPet.OnOut = this.ProcessorOnSlotOut;
         this.FUISlotPet.Init();
         this.FTF_Name = _loc2_[CONST_PET.RESOURCE_Link_TF_Name];
         this.FTF_BaseAttributes = new Vector.<TextField>(CAPACITY_PvpAttribute);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_] = _loc2_[CONST_PET.RESOURCE_Link_TF_BaseAttribute + _loc1_];
            _loc1_++;
         }
         this.FUITabHeros = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_HEROS)
         {
            _loc3_ = _loc2_[CONST_HEROS.RESOURCE_Link_TF_HerosName + _loc1_];
            _loc3_.mouseChildren = false;
            this.FUITabHeros.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FUITabHeros.OnSwitch = this.UITabHerosOnSwitch;
         this.FUITabHeros.Init();
         _loc4_ = _loc2_[CONST_COMMON.RESOURCE_Link_SP_Page];
         this.FUIPageHeros = new TUIPage(this);
         this.FUIPageHeros.ButtonPrevious.Substrate = _loc4_[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPageHeros.ButtonNext.Substrate = _loc4_[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPageHeros.LabelPage = _loc4_[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPageHeros.LabelPage.text = "0/0";
         this.FUIPageHeros.PageSize = CAPACITY_HEROS;
         this.FUIPageHeros.Init();
         this.FUIPageHeros.OnChangePage = this.UIPageHerosOnChangePage;
         this.FUIPetList = new TUIPetList(this);
         this.FUIPetList.PageSize = CAPACITY_STUDY_CARRY_PETS;
         this.FUIPetList.Resource = _loc2_["SP_PetList"];
         this.FUIPetList.OnOver = this.ProcessorOnSlotOver;
         this.FUIPetList.OnOut = this.ProcessorOnSlotOut;
         this.FUIPetList.OnClick = this.UIPetListOnClick;
         this.FUIPetList.OnPetsFilter = this.ProcessorOnPetsFilter;
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
         this.FUISlotPet.Update();
         this.FUIPetList.Update();
      }
      
      private function UpdateUIHeroList() : void
      {
         var _loc1_:THeros = null;
         var _loc2_:THero = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc1_ = this.FCharacter.Heros;
         _loc4_ = this.FPageHeroIndex * CAPACITY_HEROS;
         _loc5_ = _loc4_ + CAPACITY_HEROS;
         _loc5_ = _loc5_ > _loc1_.Count ? _loc1_.Count : _loc5_;
         _loc6_ = 0;
         _loc7_ = _loc4_;
         while(_loc7_ < _loc5_)
         {
            this.FUITabHeros.SetTabShowByIndex(_loc6_);
            _loc2_ = _loc1_.GetHeroByIndex(_loc7_);
            _loc3_ = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Quality];
            this.FUITabHeros.SetTabCaptionByIndex(_loc2_.Name,_loc6_,_loc3_);
            _loc6_++;
            _loc7_++;
         }
         _loc7_ = _loc6_;
         while(_loc7_ < CAPACITY_HEROS)
         {
            this.FUITabHeros.SetTabHideByIndex(_loc7_);
            _loc7_++;
         }
         this.FUIPageHeros.TotalQuantity = _loc1_.Count;
         this.FUIPageHeros.PageIndex = this.FPageHeroIndex;
         this.FUIPageHeros.Update();
      }
      
      protected function UpdateUIPetList() : void
      {
         this.FUIPetList.Context = this.FPetData.OwnVicePets;
      }
      
      protected function UpdateAttributeReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:THero = null;
         _loc3_ = this.FCharacter.Heros.GetHeroByIndex(this.FTabHeroIndex + this.FPageHeroIndex * CAPACITY_HEROS);
         this.FHero = _loc3_;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Account_CharBaseAttributeReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(this.FHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function UpdateUIPetCarry() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         var _loc3_:TPetBase = null;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         this.FUISlotPet.Context = null;
         this.FTF_Name.text = "";
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_].text = "";
            _loc1_++;
         }
         if(this.FCharacter.Heros.Count <= this.FTabHeroIndex)
         {
            this.FTabHeroIndex = 0;
         }
         _loc2_ = this.FCharacter.Heros.GetHeroByIndex(this.FTabHeroIndex + this.FPageHeroIndex * CAPACITY_HEROS);
         this.FHero = _loc2_;
         _loc4_ = false;
         if(_loc2_.VicePetHighID != 0 && _loc2_.VicePetLowID != 0)
         {
            _loc3_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc2_.VicePetHighID,_loc2_.VicePetLowID);
            this.FUISlotPet.Context = _loc3_;
            this.FTF_Name.text = _loc3_.Name;
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_PvpAttribute)
            {
               _loc5_ = _loc2_.GetBaseAttributeByIndex(MAPPING_BASEATTRIBUTES[_loc1_]) - _loc3_.GetPvPAttributeByIndex(_loc1_);
               this.FTF_BaseAttributes[_loc1_].text = TUtilityString.Format(CONST_COMMON.STRING_Increase,_loc5_,_loc3_.GetPvPAttributeByIndex(_loc1_));
               _loc1_++;
            }
            _loc4_ = true;
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_PvpAttribute)
            {
               this.FTF_BaseAttributes[_loc1_].text = _loc2_.GetBaseAttributeByIndex(MAPPING_BASEATTRIBUTES[_loc1_]).toString();
               _loc1_++;
            }
         }
         this.FBtn_Dismount.Enabled = _loc4_;
      }
      
      protected function CheckPetUserStatus(param1:TPetBase) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:THeros = null;
         _loc5_ = SLogicsCore.Character.Heros;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetHeroByIndex(_loc2_);
            if(_loc4_.VicePetHighID != 0 && _loc4_.VicePetLowID != 0)
            {
               if(_loc4_.VicePetHighID == param1.Identifier0 && _loc4_.VicePetLowID == param1.Identifier1)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      private function UITabHerosOnSwitch(param1:int) : void
      {
         this.FTabHeroIndex = param1;
         this.UpdateAttributeReq();
      }
      
      private function UIPageHerosOnChangePage(param1:Object, param2:int) : void
      {
         this.FPageHeroIndex = param2;
         this.FTabHeroIndex = 0;
         this.UpdateUIHeroList();
         this.FUITabHeros.SwithTagManual(this.FTabHeroIndex);
      }
      
      protected function Btn_DismountOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetUnEquipReq);
         _loc3_.Data.writeUnsignedInt(this.FHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function UIPetListOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TVicePet = null;
         var _loc4_:TPacket = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCarryPetHead);
         _loc3_ = param2 as TVicePet;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetEquipReq);
         _loc4_.Data.writeUnsignedInt(_loc3_.Identifier0);
         _loc4_.Data.writeUnsignedInt(_loc3_.Identifier1);
         _loc4_.Data.writeUnsignedInt(this.FHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TPetBase = null;
         var _loc8_:Boolean = false;
         _loc6_ = param2.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2.GetPetByIndex(_loc5_);
            if(_loc7_.Quality == param4)
            {
               _loc8_ = this.CheckPetUserStatus(_loc7_);
               if(!_loc8_)
               {
                  param3.Add(_loc7_);
               }
            }
            _loc5_++;
         }
         param3.Sort();
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPetBase = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TPetBase;
         _loc6_ = SResourcesCore.TexturesHeadIcon;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.HeadIconID);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.HeadIconID);
         }
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
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_HEROS)
         {
            this.FUITabHeros.SetTabCaptionByIndex("",_loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_].text = "";
            _loc1_++;
         }
         this.FTF_Name.text = "";
         this.FHero = null;
         this.FUIPetList.Context = null;
      }
      
      public function Update() : void
      {
         this.UpdateUIHeroList();
         this.UpdateAttributeReq();
         this.UpdateUIPetList();
      }
      
      public function UpdatePetCarryOperator() : void
      {
         this.UpdateAttributeReq();
         this.UpdateUIPetList();
      }
   }
}

