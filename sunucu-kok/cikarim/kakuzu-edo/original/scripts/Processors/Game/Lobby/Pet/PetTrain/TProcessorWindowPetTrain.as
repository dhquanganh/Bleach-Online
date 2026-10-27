package Processors.Game.Lobby.Pet.PetTrain
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Logics.Pet.Train.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.Components.*;
   import Processors.Game.Lobby.Pet.PetTrain.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowPetTrain extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_Train_Items:uint = CONST_PET.CAPACITY_Train_Items;
      
      private static const CAPACITY_STUDY_CARRY_PETS:int = CONST_PET.CAPACITY_STUDY_CARRY_PETS;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FPetData:TPetData;
      
      protected var MC_PetTrain:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_PetHelp:SimpleButton;
      
      protected var FSP_PetList:Sprite;
      
      protected var FUIPageTrain:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FUITrainSlots:Vector.<TUIPetTrainSlot>;
      
      protected var FUIPetList:TUIPetList;
      
      protected var FUIImage:TUIImage;
      
      protected var FCurrentTabIndex:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FPetExpCardName:String;
      
      protected var FCardExp:int;
      
      protected var FMoreCardCount:int;
      
      protected var FOwnCardCount:int;
      
      protected var FUseOneIsSelect:Boolean;
      
      protected var FUseMoreIsSelect:Boolean;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnOpenTrainModel:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowPetTrain(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetTrain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIPetTrainSlot = null;
         this.MC_PetTrain = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_PetTrain) as MovieClip;
         addChild(this.MC_PetTrain);
         this.FBtn_Close = this.MC_PetTrain[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_PetHelp = this.MC_PetTrain[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FSP_PetList = this.MC_PetTrain["SP_PetList"];
         this.FUIPageTrain = new TUIPage(this);
         _loc3_ = this.MC_PetTrain["MC_PageLeft"];
         this.FUIPageTrain.ButtonPrevious.Substrate = _loc3_;
         _loc3_ = this.MC_PetTrain["MC_PageRight"];
         this.FUIPageTrain.ButtonNext.Substrate = _loc3_;
         this.FUIPageTrain.PageSize = CAPACITY_Train_Items;
         this.FUIPageTrain.Init();
         this.FUIPageTrain.OnChangePage = this.PageOnChange;
         this.FUIPetList = new TUIPetList(this);
         this.FUIPetList.DraggingEnabled = true;
         this.FUIPetList.PageSize = CAPACITY_STUDY_CARRY_PETS;
         this.FUIPetList.Resource = this.MC_PetTrain["SP_PetList"];
         this.FUIPetList.OnClick = this.UIPetListOnClick;
         this.FUIPetList.OnOver = this.ProcessorOnSlotOver;
         this.FUIPetList.OnOut = this.ProcessorOnSlotOut;
         this.FUIPetList.OnDragBegin = this.SlotsOnDragBegin;
         this.FUIPetList.OnDragQuery = this.SlotsOnDragQuery;
         this.FUIPetList.OnDragDrop = this.SlotsOnDragDrop;
         this.FUIPetList.OnDragEnd = this.SlotsOnDragEnd;
         this.FUIPetList.OnPetsFilter = this.ProcessorOnPetsFilter;
         this.FUITrainSlots = new Vector.<TUIPetTrainSlot>(CAPACITY_Train_Items);
         _loc2_ = CAPACITY_Train_Items;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUIPetTrainSlot(this);
            _loc4_.Tag = _loc1_;
            _loc4_.Resource = this.MC_PetTrain["Slot_" + _loc1_];
            _loc4_.Context = null;
            _loc4_.OnOpen = this.onTrainSlotOpen;
            _loc4_.OnUseCard = this.OnUseCard;
            _loc4_.OnClose = this.onTrainSlotClose;
            _loc4_.OnComplete = this.onTrainSlotComplete;
            _loc4_.OnSlotOver = this.ProcessorOnSlotOver;
            _loc4_.OnSlotOut = this.ProcessorOnSlotOut;
            this.FUITrainSlots[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIImage = new TUIImage(this);
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.mouseChildren = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:TArticle = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:TBins = null;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseClick);
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,CONST_PET.ArticleID_PetExpCard) as TArticle;
         this.FPetExpCardName = _loc1_.Name;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc3_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_ExpCard_Number) as TConfigValue;
         this.FCardExp = int(_loc2_.Value);
         _loc2_ = _loc3_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_More_Items) as TConfigValue;
         this.FMoreCardCount = int(_loc2_.Value);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
         this.FUIPetList.Update();
         this.UpdataTrainSlotCD();
      }
      
      protected function CheckPetUserStatus(param1:TPetBase) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTrainData = null;
         var _loc5_:TTrainDatas = null;
         _loc5_ = this.FPetData.TrainDatas;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetTrainDataByIndex(_loc2_);
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
      
      protected function UpdateUIPetList() : void
      {
         this.FUIPetList.Context = this.FPetData.OwnVicePets;
      }
      
      protected function UseExpCard(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:TPetBase = null;
         var _loc5_:int = 0;
         _loc4_ = param1.Context.pet as TPetBase;
         _loc5_ = int(param1.Context.type);
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TrainExpCardReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc5_);
         _loc3_.writeUnsignedInt(_loc4_.Identifier0);
         _loc3_.writeUnsignedInt(_loc4_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         if(_loc5_ == CONST_PET.ExpType_One)
         {
            this.FUseOneIsSelect = this.FUIWindowConfirmation.IsSelected;
         }
         else
         {
            this.FUseMoreIsSelect = this.FUIWindowConfirmation.IsSelected;
         }
         this.CancelCheckBos(param1);
      }
      
      protected function BtnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnUseCard(param1:TPetBase, param2:int) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:TPetBase = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Boolean = false;
         _loc7_ = this.FPetData.MaxNomalVicePets.GetIndexByPetID(param1.TemplateID);
         _loc8_ = this.FPetData.MaxNomalVicePets.GetPetByIndex(_loc7_);
         _loc4_ = _loc8_.TotalExperience - param1.TotalExperience + param1.NextExperience - param1.Experience;
         _loc10_ = {
            "pet":param1,
            "type":param2
         };
         switch(param2)
         {
            case CONST_PET.ExpType_One:
               _loc5_ = 1;
               _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_51),this.FPetExpCardName);
               _loc11_ = this.FUseOneIsSelect;
               break;
            case CONST_PET.ExpType_More:
               _loc5_ = this.FMoreCardCount;
               _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_53),this.FPetExpCardName,this.FMoreCardCount);
               _loc11_ = this.FUseMoreIsSelect;
         }
         if(this.FOwnCardCount < _loc5_)
         {
            _loc9_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_58),this.FPetExpCardName);
            SToolReward.ShowMessage(_loc9_);
            return;
         }
         if(_loc4_ < _loc5_ * this.FCardExp)
         {
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_52);
            this.FUIWindowConfirmation.SetCheckBoxUsable(false);
         }
         else
         {
            this.FUIWindowConfirmation.SetCheckBoxUsable(true);
            if(_loc11_)
            {
               this.UseExpCard({"Context":_loc10_});
               return;
            }
         }
         this.FUIWindowConfirmation.Text = _loc6_;
         this.FUIWindowConfirmation.OnOK = this.UseExpCard;
         this.FUIWindowConfirmation.OnCancel = this.CancelCheckBos;
         this.FUIWindowConfirmation.Context = _loc10_;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function CancelCheckBos(param1:Object) : void
      {
         this.FUIWindowConfirmation.SetCheckBoxUsable(false);
      }
      
      protected function onTrainSlotOpen(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TConfigValue = null;
         var _loc4_:uint = 0;
         var _loc5_:TTrainData = null;
         _loc5_ = (param1 as TUIPetTrainSlot).Context;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_Train_Open_Grid) as TConfigValue;
         _loc4_ = uint((_loc3_.Value as Vector.<uint>)[this.FPetData.BuyVicePetTrainSlotCount]);
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_25),_loc4_);
         this.FUIWindowConfirmation.OnOK = this.WindowConfirmationSlotOpenOnOK;
         this.FUIWindowConfirmation.Context = _loc5_;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function WindowConfirmationSlotOpenOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TrainSlotOpenReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function WindowConfirmationSlotClearOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TTrainData = null;
         _loc3_ = this.FUIWindowConfirmation.Context as TTrainData;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VicePetTrainClearCDReq);
         _loc2_.Data.writeUnsignedInt(_loc3_.VicePetHighID);
         _loc2_.Data.writeUnsignedInt(_loc3_.VicePetLowID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function onTrainSlotClose(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TTrainData = null;
         _loc3_ = (param1 as TUIPetTrainSlot).Context;
         this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_26);
         this.FUIWindowConfirmation.OnOK = this.WindowConfirmationSlotCloseOnOK;
         this.FUIWindowConfirmation.Context = _loc3_;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function WindowConfirmationSlotCloseOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TTrainData = null;
         _loc3_ = this.FUIWindowConfirmation.Context as TTrainData;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VicePetTrainCancelReq);
         _loc2_.Data.writeUnsignedInt(_loc3_.VicePetHighID);
         _loc2_.Data.writeUnsignedInt(_loc3_.VicePetLowID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function onTrainSlotComplete(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TTrainData = null;
         _loc3_ = (param1 as TUIPetTrainSlot).Context;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VicePetTrainGetReq);
         _loc2_.Data.writeUnsignedInt(_loc3_.VicePetHighID);
         _loc2_.Data.writeUnsignedInt(_loc3_.VicePetLowID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePanelTrain();
      }
      
      protected function UpdateExpCardCount() : void
      {
         this.FOwnCardCount = SLogicsCore.Character.Appliances.GetCountByTempleteID(CONST_PET.ArticleID_PetExpCard);
      }
      
      protected function UpdateTrainUIPage() : void
      {
         this.FUIPageTrain.TotalQuantity = this.FPetData.TrainDatas.Count;
         this.FUIPageTrain.PageIndex = this.FPageIndex;
         this.FUIPageTrain.Update();
      }
      
      protected function UpdatePanelTrain() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIPetTrainSlot = null;
         _loc4_ = this.FPageIndex;
         _loc2_ = CAPACITY_Train_Items;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FUITrainSlots[_loc1_];
            _loc5_.Context = null;
            _loc5_.Visible = false;
            _loc1_++;
         }
         _loc2_ = uint(this.FPetData.TrainDatas.Count);
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc3_ = _loc4_ * CAPACITY_Train_Items;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Train_Items)
         {
            if(_loc1_ + _loc3_ >= _loc2_)
            {
               break;
            }
            _loc5_ = this.FUITrainSlots[_loc1_];
            _loc5_.Context = this.FPetData.TrainDatas.GetTrainDataByIndex(_loc1_ + _loc3_);
            _loc5_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function UIPetListOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TVicePet = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc5_ = param2 as TVicePet;
         _loc6_ = -1;
         _loc4_ = this.FPetData.TrainDatas.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = int(this.FPetData.TrainDatas.GetTrainDataByIndex(_loc3_).Status);
            if(_loc7_ == TTrainData.TYPE_USABLE)
            {
               _loc6_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc6_ == -1)
         {
            return;
         }
         if(this.FOnOpenTrainModel != null)
         {
            this.FOnOpenTrainModel(this,_loc5_,_loc6_);
         }
      }
      
      protected function ProcessorOnPetsFilter(param1:Object, param2:TPets, param3:TPets, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TVicePet = null;
         var _loc8_:Boolean = false;
         _loc6_ = param2.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2.GetPetByIndex(_loc5_) as TVicePet;
            if(!(_loc7_.Level >= _loc7_.ConditionAdvancePetLevel && _loc7_.ConditionAdvancePetLevel > 0))
            {
               if(_loc7_.Quality == param4)
               {
                  _loc8_ = this.CheckPetUserStatus(_loc7_);
                  if(!_loc8_)
                  {
                     param3.Add(_loc7_);
                  }
               }
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
      
      protected function SlotsOnDragBegin(param1:Object) : void
      {
         var _loc2_:TUISlot = null;
         _loc2_ = param1 as TUISlot;
         this.FUIImage.Sequence = _loc2_.SequenceContext;
         FUICore.MouseStartDrag(this.FUIImage,true);
      }
      
      protected function SlotsOnDragQuery(param1:Object, param2:TUIComponent, param3:Object, param4:TQueryBoolean) : void
      {
         param4.Value = true;
      }
      
      protected function SlotsOnDragDrop(param1:Object, param2:TUIComponent, param3:Object) : void
      {
         var _loc4_:TUISlot = null;
         var _loc5_:TUISlot = null;
         var _loc6_:TPetBase = null;
         var _loc7_:TPetBase = null;
         var _loc8_:int = 0;
         var _loc9_:TPetLevelUp = null;
         _loc4_ = param1 as TUISlot;
         if(_loc4_.Parent is TUIPetTrainSlot && (_loc4_.Parent as TUIPetTrainSlot).Context.Status != TTrainData.TYPE_USABLE)
         {
            return;
         }
         _loc5_ = param2 as TUISlot;
         _loc7_ = _loc5_.Context as TPetBase;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc7_.GetTemplateIDByLevel(_loc7_.Level)) as TPetLevelUp;
         if(_loc4_.Context == null)
         {
            if(_loc9_.IsMaxLevel == 0)
            {
               _loc8_ = _loc4_.Tag + this.FPageIndex * CAPACITY_Train_Items;
               if(this.FOnOpenTrainModel != null)
               {
                  this.FOnOpenTrainModel(this,_loc7_,_loc8_);
               }
               this.UpdateUIPetList();
            }
            else
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_32));
            }
         }
      }
      
      protected function SlotsOnDragEnd(param1:Object) : void
      {
         FUICore.MouseStopDrag(this.FUIImage);
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnOpenTrainModel() : Function
      {
         return this.FOnOpenTrainModel;
      }
      
      public function set OnOpenTrainModel(param1:Function) : void
      {
         this.FOnOpenTrainModel = param1;
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
         if(!this.FInitialization)
         {
            return;
         }
         this.FUIPetList.Context = null;
         this.FUIImage.Sequence = null;
      }
      
      public function UpdataTrainSlotCD() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = this.FPageIndex;
         _loc2_ = uint(this.FPetData.TrainDatas.Count);
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc3_ = _loc4_ * CAPACITY_Train_Items;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Train_Items)
         {
            if(_loc1_ + _loc3_ >= _loc2_)
            {
               break;
            }
            this.FUITrainSlots[_loc1_].LogicPerform_TrainSlotCD();
            _loc1_++;
         }
      }
      
      public function Update() : void
      {
         this.UpdateUIPetList();
         this.UpdatePanelTrain();
         this.UpdateTrainUIPage();
         this.UpdateExpCardCount();
      }
      
      public function ResetTimingTime(param1:TTrainData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUIPetTrainSlot = null;
         _loc5_ = this.FPageIndex;
         _loc3_ = uint(this.FPetData.TrainDatas.Count);
         if(_loc3_ <= 0)
         {
            return;
         }
         _loc4_ = _loc5_ * CAPACITY_Train_Items;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_Train_Items)
         {
            if(_loc2_ + _loc4_ >= _loc3_)
            {
               break;
            }
            _loc6_ = this.FUITrainSlots[_loc2_];
            if(_loc6_.Context != null && param1 == _loc6_.Context)
            {
               _loc6_.ResetTimingTime();
            }
            _loc2_++;
         }
      }
   }
}

