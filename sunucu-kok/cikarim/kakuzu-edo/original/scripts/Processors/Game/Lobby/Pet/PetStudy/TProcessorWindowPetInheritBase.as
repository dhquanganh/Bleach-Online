package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Slots.TUISlot;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.Pet.TPetBase;
   import Logics.Pet.TPetData;
   import Logics.Pet.TPets;
   import Logics.Pet.TVicePet;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Pet.Components.TUIPetList;
   import Processors.Game.Lobby.Pet.PetHouse.Components.TUIPetInfo;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_PET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowPetInheritBase extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_STUDY_COMPOSITE_PETS:int = CONST_PET.CAPACITY_STUDY_COMPOSITE_PETS;
      
      protected var FUIPetInfo:TUIPetInfo;
      
      protected var FUIPetList:TUIPetList;
      
      protected var FPetData:TPetData;
      
      protected var FResource:Sprite;
      
      protected var FMountPoint:Sprite;
      
      protected var FTF_Condition_0:TextField;
      
      protected var FTF_Condition_1:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FBtnAdd:SimpleButton;
      
      protected var FBarExpPool:Sprite;
      
      protected var FBarExpPet:Sprite;
      
      protected var FTFExpPool:TextField;
      
      protected var FTFExpPet:TextField;
      
      protected var FMcEffect:MovieClip;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FBmp_Pet:Bitmap;
      
      protected var FVicePetSelected:TVicePet;
      
      protected var FPetResourceID:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FConfigValueBins:TBins;
      
      protected var FPetLevelUpBins:TBins;
      
      protected var FInheritRate:Number;
      
      protected var FPoolTotal:int;
      
      protected var FPoolOwn:int;
      
      protected var FPoolExpandCount:int;
      
      protected var FPetCurExp:int;
      
      protected var FPetTotalExp:int;
      
      protected var FBuyExpNums:Vector.<uint>;
      
      protected var FBuyExpPrices:Vector.<uint>;
      
      protected var FInitExpNum:int;
      
      protected var FPetLevelUp:TPetLevelUp;
      
      protected var FPetLevelUpNext:TPetLevelUp;
      
      protected var FIgnoerResourceID:int;
      
      public function TProcessorWindowPetInheritBase(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetStudy);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FConfigValueBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         this.FInheritRate = (this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_Inherit_Value) as TConfigValue).Value as Number;
         this.FInitExpNum = (this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_InitMaxExp_Num) as TConfigValue).Value as int;
         this.FBuyExpNums = (this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_BuyMaxExp_Num) as TConfigValue).Value as Vector.<uint>;
         this.FBuyExpPrices = (this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_BuyMaxExp_Price) as TConfigValue).Value as Vector.<uint>;
         this.FPetLevelUpBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PetLevelUp);
         this.FMountPoint = this.FResource[CONST_PET.RESOURCE_Link_SP_MountPoint];
         this.FBmp_Pet = new Bitmap();
         this.FMountPoint.addChild(this.FBmp_Pet);
         this.FUIPetInfo = new TUIPetInfo();
         this.FUIPetInfo.Resource = this.FResource[CONST_PET.RESOURCE_Link_SP_CurrentAttribute];
         this.FUIPetList = new TUIPetList(this);
         this.FUIPetList.PageSize = CAPACITY_STUDY_COMPOSITE_PETS;
         this.FUIPetList.Resource = this.FResource["SP_PetList"];
         this.FUIPetList.OnClick = this.UIPetListOnClick;
         this.FUIPetList.OnOver = this.ProcessorOnSlotOver;
         this.FUIPetList.OnOut = this.ProcessorOnSlotOut;
         this.FUIPetList.OnPetsFilter = this.ProcessorOnPetsFilter;
         this.FTF_Name = this.FResource[CONST_PET.RESOURCE_Link_TF_Name];
         this.FTF_Level = this.FResource["TF_Level"];
         this.FTF_Condition_0 = this.FResource["TF_Desc_0"];
         this.FTF_Condition_1 = this.FResource["TF_Desc_1"];
         this.FBarExpPool = this.FResource["Bar_ExpPool"];
         this.FTFExpPool = this.FResource["TF_ExpPool"];
         this.FBarExpPet = this.FResource["Bar_ExpPet"];
         this.FTFExpPet = this.FResource["TF_ExpPet"];
         this.FBtnAdd = this.FResource["Btn_Add"];
         this.FBtnAdd.addEventListener(MouseEvent.CLICK,this.ProcessorOnAddClick);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function UpdateUIPetInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVicePet = null;
         this.FTF_Name.text = "";
         this.FTF_Level.text = "";
         this.FTF_Condition_0.text = "";
         this.FTF_Condition_1.text = "";
         this.FUIPetInfo.Reset();
         this.FUIPetList.Context = this.FPetData.OwnVicePets;
         this.FPoolOwn = this.FPetData.InheritPoolExp;
         this.FPoolExpandCount = this.FPetData.InheritExtendTimes;
         if(this.FPoolExpandCount == 0)
         {
            this.FPoolTotal = this.FInitExpNum;
         }
         else
         {
            this.FPoolTotal = this.FBuyExpNums[this.FPoolExpandCount - 1];
         }
         this.FTFExpPool.text = this.FPoolOwn + "/" + this.FPoolTotal;
         this.FBarExpPool.scaleX = this.FPoolOwn / this.FPoolTotal;
         if(this.FVicePetSelected == null)
         {
            return;
         }
         this.FTF_Name.text = this.FVicePetSelected.Name;
         this.FTF_Level.text = "Lv." + this.FVicePetSelected.Level;
         this.FUIPetInfo.RenderUI(this.FVicePetSelected.GetBaseAttributeByIndex,this.FVicePetSelected.GetPvPAttributeByIndex);
         this.FPetResourceID = this.FVicePetSelected.LargeIconID;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetResourceID,this.AutoLoadCallBack);
         this.FPetLevelUp = this.FPetLevelUpBins.GetDatebaseByIdentifier(this.GetIdentifier(this.FVicePetSelected.TemplateID,this.FVicePetSelected.Level)) as TPetLevelUp;
         if(this.FPetLevelUp.IsMaxLevel == 0)
         {
            this.FPetLevelUpNext = this.FPetLevelUpBins.GetDatebaseByIdentifier(this.GetIdentifier(this.FVicePetSelected.TemplateID,this.FVicePetSelected.Level + 1)) as TPetLevelUp;
            this.FPetTotalExp = this.FPetLevelUpNext.NeedExp;
         }
         else
         {
            this.FPetTotalExp = this.FPetLevelUp.NeedExp;
         }
         this.FPetCurExp = this.FVicePetSelected.Experience;
         this.FTFExpPet.text = this.FPetCurExp + "/" + this.FPetTotalExp;
         this.FBarExpPet.scaleX = this.FPetCurExp / this.FPetTotalExp;
      }
      
      protected function GetIdentifier(param1:int, param2:int) : int
      {
         return param1 * 1000 + param2;
      }
      
      protected function SetIgnoreResource(param1:int) : void
      {
         this.FIgnoerResourceID = param1;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         if(this.FIgnoerResourceID == param3)
         {
            return;
         }
         switch(param3)
         {
            case this.FPetResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FBmp_Pet.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
         this.FUIPetList.Update();
      }
      
      protected function Inherit_CS_Pet_ExpPoolExtendReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_ExpPoolExtendReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function InheritEffectOnEnd() : void
      {
         this.FMcEffect.stop();
         this.FMcEffect.visible = false;
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
      
      protected function ProcessorOnAddClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FPetData.InheritExtendTimes >= this.FBuyExpNums.length)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_47));
            return;
         }
         _loc2_ = this.FPetData.InheritExtendTimes;
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_43),this.FBuyExpNums.length - _loc2_,this.FBuyExpPrices[_loc2_],this.FBuyExpNums[_loc2_]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.Inherit_CS_Pet_ExpPoolExtendReq;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function UIPetListOnClick(param1:Object, param2:Object) : void
      {
         this.FVicePetSelected = param2 as TVicePet;
         this.UpdateUIPetInfo();
      }
      
      protected function ProcessorOnSetSlotFilters(param1:Object, param2:TPetBase, param3:TUISlot) : void
      {
         var _loc4_:TVicePet = null;
         _loc4_ = param2 as TVicePet;
         param3.SetDefaultFilters(!_loc4_.CompositeState);
      }
      
      protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
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
      
      public function Update() : void
      {
         this.FPetData = SLogicsCore.PetData;
         this.UpdateUIPetInfo();
      }
      
      public function Reset() : void
      {
         this.FTF_Condition_0.text = "";
         this.FTF_Condition_1.text = "";
         this.FTF_Level.text = "";
         this.FTF_Name.text = "";
         this.FPetResourceID = 0;
         this.FUIPetInfo.Reset();
         this.FVicePetSelected = null;
         this.FUIPetList.Context = null;
         this.FBmp_Pet.bitmapData = null;
         this.FMcEffect.gotoAndStop(1);
         this.FMcEffect.visible = false;
         this.FTFExpPool.text = "";
         this.FTFExpPet.text = "";
         this.FBarExpPool.scaleX = 1;
         this.FBarExpPet.scaleX = 1;
      }
      
      public function PlayInheritEffect() : void
      {
         this.FMcEffect.play();
         this.FMcEffect.visible = true;
      }
   }
}

