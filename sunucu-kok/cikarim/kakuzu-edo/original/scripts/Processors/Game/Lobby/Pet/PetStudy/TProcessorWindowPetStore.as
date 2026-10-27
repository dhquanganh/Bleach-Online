package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Logics.Pet.Train.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.PetStudy.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowPetStore extends TProcessorLobbyWindow
   {
      
      protected static const PETTRAIN_CAPACITY_TABS:uint = CONST_PET.PETTRAIN_CAPACITY_TABS;
      
      protected static const CAPACITY_PvpAttribute:uint = CONST_PET.CAPACITY_PvpAttribute;
      
      protected static const CAPACITY_STUDY_STORE_PETS:uint = CONST_PET.CAPACITY_STUDY_STORE_PETS;
      
      protected static const ALLOW_DISMISSAL_LEVEL:uint = 0;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FPetData:TPetData;
      
      protected var FFilterPets:TPets;
      
      protected var FBtn_Extend:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FUISlot:TUISlot;
      
      protected var FTF_Experience:TextField;
      
      protected var FSP_ProgressBarExp:Sprite;
      
      protected var FTF_BaseAttributes:Vector.<TextField>;
      
      protected var FUIPetSlots:Vector.<TUIPetSlot>;
      
      protected var FTF_Capacity:TextField;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowPetStore(param1:TUIComponent)
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
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:TUIPetSlot = null;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FFilterPets = new TPets();
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Store) as Sprite;
         addChild(_loc2_);
         this.FTF_Capacity = _loc2_["TF_Capacity"];
         this.FBtn_Extend = new TUIButton();
         this.FBtn_Extend.Substrate = _loc2_["Btn_Extend"];
         this.FBtn_Extend.OnClick = this.Btn_ExtendOnClick;
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < PETTRAIN_CAPACITY_TABS)
         {
            this.FUITab.SetTabByIndex(_loc2_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.UITabOnSwitch;
         this.FUITab.Init();
         _loc3_ = _loc2_[CONST_COMMON.RESOURCE_Link_SP_Page];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc3_[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = _loc3_[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPage.LabelPage = _loc3_[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPage.PageSize = CAPACITY_STUDY_STORE_PETS;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FUISlot = new TUISlot(this);
         this.FUISlot.Resource = _loc2_[CONST_COMMON.RESOURCE_Link_MC_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FUISlot.OnQuerySubscript = this.SlotsOnQuerySubscript;
         this.FUISlot.Init();
         this.FTF_Experience = _loc2_[CONST_HEROS.RESOURCE_Link_TF_Experience];
         this.FSP_ProgressBarExp = _loc2_[CONST_HEROS.RESOURCE_Link_MC_ProgressBarExp];
         this.FTF_BaseAttributes = new Vector.<TextField>(CAPACITY_PvpAttribute);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_] = _loc2_[CONST_PET.RESOURCE_Link_TF_BaseAttribute + _loc1_];
            _loc1_++;
         }
         this.FUIPetSlots = new Vector.<TUIPetSlot>(CAPACITY_STUDY_STORE_PETS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_STUDY_STORE_PETS)
         {
            _loc4_ = new TUIPetSlot(this);
            _loc4_.Resource = _loc2_["SP_Slots"][CONST_PET.RESOURCE_Link_MC_Slot + _loc1_];
            _loc4_.OnClick = this.UIPetSlotOnClick;
            _loc4_.OnDismissal = this.UIPetSlotOnDismissal;
            _loc4_.OnOver = this.ProcessorOnSlotOver;
            _loc4_.OnOut = this.ProcessorOnSlotOut;
            this.FUIPetSlots[_loc1_] = _loc4_;
            _loc1_++;
         }
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
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_STUDY_STORE_PETS)
         {
            this.FUIPetSlots[_loc1_].Update();
            _loc1_++;
         }
         this.FUISlot.Update();
      }
      
      protected function UpdateUIPetStore() : void
      {
         this.FTF_Capacity.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FPetData.GetCurrentStoreUsed(),this.FPetData.GetCurrentStoreTotalCapacity());
      }
      
      protected function UpdateUIPetInfo(param1:TVicePet) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < CAPACITY_PvpAttribute)
            {
               this.FTF_BaseAttributes[_loc2_].text = param1.GetPvPAttributeByIndex(_loc2_).toString();
               _loc2_++;
            }
            this.FTF_Experience.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,param1.Experience,param1.NextExperience);
            _loc3_ = param1.Experience / param1.NextExperience;
            if(_loc3_ > 1)
            {
               _loc3_ = 1;
            }
            this.FSP_ProgressBarExp.scaleX = _loc3_;
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < CAPACITY_PvpAttribute)
            {
               this.FTF_BaseAttributes[_loc2_].text = "";
               _loc2_++;
            }
            this.FTF_Experience.text = "";
            this.FSP_ProgressBarExp.scaleX = 0;
         }
         this.FUISlot.Context = param1;
      }
      
      protected function ProcessorFilterPetsByQuality(param1:TPets, param2:TPets) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPetBase = null;
         param2.Clear();
         _loc5_ = this.FTabIndex + 1;
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param1.GetPetByIndex(_loc3_);
            if(_loc6_.Quality == _loc5_)
            {
               param2.Add(_loc6_);
            }
            _loc3_++;
         }
         param2.Sort();
      }
      
      protected function UpdateSlotsByPets(param1:Vector.<TUIPetSlot>, param2:TPets) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUIPetSlot = null;
         var _loc8_:TVicePet = null;
         _loc6_ = this.FPageIndex;
         _loc4_ = int(CAPACITY_STUDY_STORE_PETS);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param1[_loc3_];
            _loc7_.Context = null;
            _loc7_.Visible = false;
            _loc3_++;
         }
         _loc4_ = param2.Count;
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc5_ = _loc6_ * CAPACITY_STUDY_STORE_PETS;
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_STUDY_STORE_PETS)
         {
            if(_loc3_ + _loc5_ >= _loc4_)
            {
               break;
            }
            _loc7_ = param1[_loc3_];
            _loc8_ = param2.GetPetByIndex(_loc3_ + _loc5_) as TVicePet;
            _loc7_.Context = _loc8_;
            _loc7_.Visible = true;
            _loc3_++;
         }
      }
      
      protected function Btn_ExtendOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:TConfigValue = null;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Vice_Pet_Gold_Open_Grid) as TConfigValue;
         _loc4_ = _loc5_.Value as Vector.<uint>;
         if(this.FPetData.BuyVicePetStorageSlotCount >= _loc4_.length)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_20));
            return;
         }
         _loc3_ = _loc4_[this.FPetData.BuyVicePetStorageSlotCount];
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_19),this.FPetData.BuyVicePetStorageSlotCount,_loc3_);
         this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationExtendOnOk;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function UIWindowConfirmationExtendOnOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_StoreExtendReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function UITabOnSwitch(param1:int) : void
      {
         this.FTabIndex = param1;
         this.FPageIndex = 0;
         if(this.FFilterPets != null)
         {
            this.ProcessorFilterPetsByQuality(this.FPetData.OwnVicePets,this.FFilterPets);
            this.UpdateSlotsByPets(this.FUIPetSlots,this.FFilterPets);
         }
         this.UpdateUIPetInfo(null);
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateSlotsByPets(this.FUIPetSlots,this.FFilterPets);
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
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TPetBase = null;
         if(param2 is TPetBase)
         {
            _loc4_ = param2 as TPetBase;
            param3.Value = TUtilityString.Format(STRING_COMMON.FORMAT_05,_loc4_.Level);
         }
      }
      
      protected function UIPetSlotOnClick(param1:Object, param2:Object) : void
      {
         this.UpdateUIPetInfo(param2 as TVicePet);
      }
      
      protected function UIPetSlotOnDismissal(param1:Object, param2:TVicePet) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:THeros = null;
         var _loc7_:TTrainData = null;
         var _loc8_:TTrainDatas = null;
         if(param2.Level <= ALLOW_DISMISSAL_LEVEL)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_31));
            return;
         }
         _loc6_ = SLogicsCore.Character.Heros;
         _loc4_ = _loc6_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc3_);
            if(_loc5_.VicePetHighID != 0 && _loc5_.VicePetLowID != 0)
            {
               if(_loc5_.VicePetHighID == param2.Identifier0 && _loc5_.VicePetLowID == param2.Identifier1)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_23));
                  return;
               }
            }
            _loc3_++;
         }
         _loc8_ = this.FPetData.TrainDatas;
         _loc4_ = _loc8_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc8_.GetTrainDataByIndex(_loc3_);
            if(_loc7_.VicePetHighID != 0 && _loc7_.VicePetLowID != 0)
            {
               if(_loc7_.VicePetHighID == param2.Identifier0 && _loc7_.VicePetLowID == param2.Identifier1)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_27));
                  return;
               }
            }
            _loc3_++;
         }
         this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_22);
         this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationDismissalOnOk;
         this.FUIWindowConfirmation.Context = param2;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function UIWindowConfirmationDismissalOnOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:TVicePet = null;
         _loc4_ = this.FUIWindowConfirmation.Context as TVicePet;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_VicePetDelReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc4_.Identifier0);
         _loc3_.writeUnsignedInt(_loc4_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FUIWindowConfirmation.Context = null;
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
         this.FFilterPets.Clear();
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_STUDY_STORE_PETS)
         {
            this.FUIPetSlots[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_].text = "";
            _loc1_++;
         }
         this.FUISlot.Context = null;
         this.FTabIndex = 0;
         this.FTF_Capacity.text = "";
         this.FTF_Experience.text = "";
         this.FSP_ProgressBarExp.scaleX = 0;
      }
      
      public function Update() : void
      {
         this.UpdateUIPetStore();
         this.UpdateUIPetInfo(null);
         this.FUITab.SwithTagManual(this.FTabIndex);
      }
   }
}

