package Processors.Game.Lobby.Pet.PetHouse
{
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
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.PetHouse.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowPetActivateWashPoint extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_SLOT:uint = CONST_PET.CAPACITY_SLOT;
      
      protected var FPetData:TPetData;
      
      protected var FMC_PetActivateWashPoint:Sprite;
      
      protected var FTF_Description:TextField;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FMC_Effects:Vector.<MovieClip>;
      
      protected var FUIItemSlots:Vector.<TUIItemSlot>;
      
      protected var FLines:Vector.<Vector.<Sprite>>;
      
      protected var FBtnSilverWashPoint:TUIButton;
      
      protected var FBtnGoldWashPoint:TUIButton;
      
      protected var FInitialization:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FBackSilver:TConfigValue;
      
      protected var FResetSilver:TConfigValue;
      
      protected var FBackGold:TConfigValue;
      
      protected var FResetGold:TConfigValue;
      
      protected var FBackSilverNum:Number;
      
      protected var FBackGoldNum:Number;
      
      protected var FWashPets:Vector.<TMainPet>;
      
      public function TProcessorWindowPetActivateWashPoint(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetHouse);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:TUIItemSlot = null;
         var _loc9_:Vector.<Sprite> = null;
         this.FMC_PetActivateWashPoint = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_Link_MC_PetActivateWashPoint) as Sprite;
         addChild(this.FMC_PetActivateWashPoint);
         this.FBtn_Close = this.FMC_PetActivateWashPoint["Btn_Close"];
         this.FBtn_Help = this.FMC_PetActivateWashPoint["Btn_Help"];
         this.FMC_Effects = new Vector.<MovieClip>();
         _loc6_ = 5;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_ = this.FMC_PetActivateWashPoint["MC_Effect_" + _loc4_];
            _loc7_.mouseEnabled = false;
            _loc7_.mouseChildren = false;
            _loc7_.stop();
            this.FMC_Effects.push(_loc7_);
            _loc4_++;
         }
         this.FBtnSilverWashPoint = new TUIButton();
         this.FBtnSilverWashPoint.Substrate = this.FMC_PetActivateWashPoint[CONST_PET.RESOURCE_Link_BtnSilverWashPoint];
         this.FBtnSilverWashPoint.OnClick = this.BtnSilverWashPointOnClick;
         this.FBtnGoldWashPoint = new TUIButton();
         this.FBtnGoldWashPoint.Substrate = this.FMC_PetActivateWashPoint[CONST_PET.RESOURCE_Link_BtnGoldWashPoint];
         this.FBtnGoldWashPoint.OnClick = this.BtnGoldWashPointOnClick;
         this.FUIItemSlots = new Vector.<TUIItemSlot>(CAPACITY_SLOT);
         this.FLines = new Vector.<Vector.<Sprite>>(4);
         _loc5_ = 5;
         _loc3_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            if(_loc1_ > 0 && _loc1_ < _loc5_)
            {
               _loc9_ = new Vector.<Sprite>(_loc1_ * 2);
            }
            _loc2_ = 0;
            while(_loc2_ <= _loc1_)
            {
               _loc8_ = new TUIItemSlot(this);
               _loc8_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
               _loc8_.TopLine = this.FMC_PetActivateWashPoint["SP_TopLine_" + _loc1_ + "_" + _loc2_];
               _loc8_.BottomLine = this.FMC_PetActivateWashPoint["SP_BottomLine_" + _loc1_ + "_" + _loc2_];
               _loc8_.Resource = this.FMC_PetActivateWashPoint["Grid_" + _loc1_ + "_" + _loc2_];
               _loc8_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
               _loc8_.OnClick = this.ProcessorUIItemSlotOnClick;
               _loc8_.OnOver = this.ProcessorUIItemSlotOnOver;
               _loc8_.OnOut = this.ProcessorUIItemSlotOnOut;
               _loc8_.OnQueryActivated = this.ProcessorOnQueryActivated;
               _loc8_.CellIndex = _loc2_;
               _loc8_.RowIndex = _loc1_;
               var _loc10_:uint;
               this.FUIItemSlots[_loc10_ = _loc3_++] = _loc8_;
               _loc2_++;
            }
            if(_loc1_ > 0 && _loc1_ < _loc5_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_ * 2)
               {
                  _loc9_[_loc2_] = this.FMC_PetActivateWashPoint["SP_Line_" + (_loc1_ - 1) + "_" + _loc2_];
                  _loc2_++;
               }
               this.FLines[_loc1_ - 1] = _loc9_;
            }
            _loc1_++;
         }
         this.FTF_Description = this.FMC_PetActivateWashPoint["TF_Description"];
         this.FTF_Description.text = "";
         this.FWashPets = new Vector.<TMainPet>();
         this.FBackGold = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Main_Pet_Back_Point_Gold) as TConfigValue;
         this.FBackSilver = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Main_Pet_Back_Point_Silver) as TConfigValue;
         this.FResetGold = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Reset_Skills_Gold) as TConfigValue;
         this.FResetSilver = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Reset_Skills_Silver) as TConfigValue;
         this.FBackSilverNum = this.FBackSilver.Value as Number;
         this.FBackGoldNum = this.FBackGold.Value as Number;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick,false,0,true);
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
         _loc2_ = this.FMC_Effects.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Effects[_loc1_].play();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_SLOT)
         {
            this.FUIItemSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorUIItemSlotOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TMainPet = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         _loc5_ = param2 as TMainPet;
         _loc3_ = this.FWashPets.indexOf(_loc5_);
         _loc10_ = _loc3_ != -1;
         if(!_loc10_)
         {
            return;
         }
         _loc8_ = this.FBackSilverNum * (_loc5_.Experience + _loc5_.TotalExperience);
         _loc6_ = this.FBackGoldNum * (_loc5_.Experience + _loc5_.TotalExperience);
         _loc7_ = int(this.FResetGold.Value);
         _loc9_ = int(this.FResetSilver.Value);
         this.FTF_Description.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_36),_loc6_,_loc7_,_loc8_,_loc9_);
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_SLOT)
         {
            this.FUIItemSlots[_loc3_].SetSelected(false);
            _loc3_++;
         }
         (param1 as TUIItemSlot).SetSelected(true);
         this.FPetData.MainPetSelected = _loc5_;
      }
      
      protected function ProcessorUIItemSlotOnOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param1,param2);
         }
      }
      
      protected function ProcessorUIItemSlotOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param1,param2);
         }
      }
      
      protected function UpdateUIActivateWashPoint() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMainPet = null;
         var _loc4_:TMainPet = null;
         var _loc5_:TMainPet = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TMainPet = null;
         var _loc11_:Boolean = false;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_SLOT)
         {
            _loc4_ = this.FPetData.MainPets.GetPetByIndex(_loc1_) as TMainPet;
            _loc5_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc4_.Identifier0,_loc4_.Identifier1) as TMainPet;
            if(_loc5_ != null)
            {
               _loc3_ = _loc5_;
            }
            else if(_loc4_ != null)
            {
               _loc3_ = _loc4_;
            }
            this.FUIItemSlots[_loc1_].Context = _loc3_;
            this.FUIItemSlots[_loc1_].UpdateState();
            if(this.FWashPets.length != 0 && _loc3_.TemplateID == this.FWashPets[0].TemplateID)
            {
               this.ProcessorUIItemSlotOnClick(this.FUIItemSlots[_loc1_],_loc3_);
            }
            _loc11_ = true;
            _loc6_ = 0;
            while(_loc6_ < _loc3_.PetRankUpCondition.PetIds.length)
            {
               _loc8_ = uint(_loc3_.PetRankUpCondition.PetIds[_loc6_]);
               _loc9_ = uint(_loc3_.PetRankUpCondition.Levels[_loc6_]);
               _loc10_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc8_,0) as TMainPet;
               if(_loc10_ == null || _loc10_.Level < _loc9_)
               {
                  _loc11_ = false;
                  break;
               }
               _loc6_++;
            }
            this.FUIItemSlots[_loc1_].ActivateStatus = _loc11_;
            if(_loc11_)
            {
               this.FUIItemSlots[_loc1_].UpdateWashPointEffect();
            }
            _loc1_++;
         }
      }
      
      protected function UpdatePetsCanWashPoint() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMainPet = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         _loc5_ = new Vector.<int>();
         this.FWashPets.length = 0;
         _loc2_ = this.FPetData.OwnMainPets.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPetData.OwnMainPets.GetPetByIndex(_loc1_) as TMainPet;
            this.VectorCombine(_loc3_.PetRankUpCondition.PetIds,_loc5_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPetData.OwnMainPets.GetPetByIndex(_loc1_) as TMainPet;
            _loc4_ = _loc5_.indexOf(_loc3_.TemplateID);
            if(_loc4_ == -1)
            {
               this.FWashPets.push(_loc3_);
            }
            _loc1_++;
         }
      }
      
      protected function VectorCombine(param1:Vector.<int>, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param2.indexOf(param1[_loc3_]);
            if(_loc5_ == -1)
            {
               param2.push(param1[_loc3_]);
            }
            _loc3_++;
         }
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
      
      protected function ProcessorOnQueryActivated(param1:Object, param2:Object, param3:TQueryBoolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TUIItemSlot = null;
         var _loc10_:TUIItemSlot = null;
         var _loc11_:TMainPet = null;
         var _loc12_:TMainPet = null;
         var _loc13_:Vector.<int> = null;
         var _loc14_:Vector.<Sprite> = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         _loc9_ = param1 as TUIItemSlot;
         _loc11_ = param2 as TMainPet;
         _loc18_ = _loc9_.RowIndex;
         if(_loc18_ == 0)
         {
            return;
         }
         _loc12_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc11_.Identifier0,_loc11_.Identifier1) as TMainPet;
         if(_loc12_ != null)
         {
            param3.Value = true;
            _loc15_ = _loc9_.CellIndex;
            _loc13_ = _loc11_.PetRankUpCondition.PetIds;
            _loc5_ = int(_loc13_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc12_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc13_[_loc4_],0) as TMainPet;
               if(_loc12_ != null)
               {
                  _loc17_ = this.FPetData.OwnMainPets.GetIndexByPetID(_loc12_.TemplateID);
                  _loc10_ = this.FUIItemSlots[_loc17_];
                  if(_loc10_.TopLine != null)
                  {
                     _loc10_.TopLine.visible = true;
                  }
                  _loc16_ = _loc10_.CellIndex;
                  if(_loc15_ - _loc16_ > 0)
                  {
                     _loc8_ = _loc15_ * 2 - 1;
                     _loc7_ = (_loc15_ - 1) * 2 + 1 + 1;
                  }
                  else
                  {
                     _loc8_ = _loc15_ * 2;
                     _loc7_ = (_loc16_ + 1) * 2 - 1;
                  }
                  _loc14_ = this.FLines[_loc18_ - 1];
                  _loc6_ = _loc8_;
                  while(_loc6_ < _loc7_)
                  {
                     if(_loc14_.length > _loc6_)
                     {
                        _loc14_[_loc6_].visible = true;
                     }
                     _loc6_++;
                  }
               }
               _loc4_++;
            }
            return;
         }
      }
      
      public function BtnCloseOnClick(param1:MouseEvent) : void
      {
         this.FPetData.MainPetSelected = null;
         ProcessorWindowClose();
      }
      
      public function BtnSilverWashPointOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.onPetWashPointTransmit(1);
      }
      
      public function BtnGoldWashPointOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.onPetWashPointTransmit(2);
      }
      
      protected function onPetWashPointTransmit(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         if(this.FPetData.MainPetSelected == null)
         {
            return;
         }
         if(this.FPetData.MainPetSelected.Identifier0 == SLogicsCore.Character.GetMainHero().MainPetID)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_40);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_MainPetDelReq);
         _loc2_.Data.writeUnsignedInt(this.FPetData.MainPetSelected.Identifier0);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
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
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<Sprite> = null;
         if(!this.FInitialization)
         {
            return;
         }
         _loc5_ = this.FMC_Effects.length;
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            this.FMC_Effects[_loc1_].stop();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_SLOT)
         {
            this.FUIItemSlots[_loc1_].Reset();
            _loc1_++;
         }
         _loc2_ = int(this.FLines.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FLines[_loc1_];
            _loc4_ = int(_loc6_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_[_loc3_].visible = false;
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      public function Update() : void
      {
         this.UpdatePetsCanWashPoint();
         this.UpdateUIActivateWashPoint();
      }
   }
}

