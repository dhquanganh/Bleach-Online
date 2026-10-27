package Processors.Game.Lobby.Pet.PetHouse
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
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
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Pet.PetHouse.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowPetActivateLine extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_SLOT:uint = CONST_PET.CAPACITY_SLOT;
      
      protected var FCharacter:TCharacter;
      
      protected var FPetData:TPetData;
      
      protected var FMC_PetActivateLine:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FMC_Effects:Vector.<MovieClip>;
      
      protected var FSP_Preview:Sprite;
      
      protected var FTF_Description:TextField;
      
      protected var FUIItemSlots:Vector.<TUIItemSlot>;
      
      protected var FLines:Vector.<Vector.<Sprite>>;
      
      protected var FBtn_GoActivate:TUIButton;
      
      protected var FSP_MountPoint:Sprite;
      
      protected var FUIHero:TUIHero;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FInitialization:Boolean;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorWindowPetActivateLine(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
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
         var _loc5_:TUIItemSlot = null;
         var _loc6_:Vector.<Sprite> = null;
         var _loc7_:TBounds = null;
         var _loc8_:TCoordinate = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:MovieClip = null;
         this.FRolesModelID = new Vector.<int>();
         this.FMC_PetActivateLine = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_Link_MC_PetActivateLine) as Sprite;
         addChild(this.FMC_PetActivateLine);
         this.FBtn_Close = this.FMC_PetActivateLine[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FMC_PetActivateLine[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FMC_Effects = new Vector.<MovieClip>();
         _loc10_ = 5;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc11_ = this.FMC_PetActivateLine["MC_Effect_" + _loc9_];
            _loc11_.mouseEnabled = false;
            _loc11_.mouseChildren = false;
            _loc11_.stop();
            this.FMC_Effects.push(_loc11_);
            _loc9_++;
         }
         this.FBtn_GoActivate = new TUIButton();
         this.FBtn_GoActivate.Substrate = this.FMC_PetActivateLine[CONST_PET.RESOURCE_Link_Btn_GoActivate];
         this.FBtn_GoActivate.OnClick = this.Btn_GoActivateOnClick;
         this.FTF_Description = this.FMC_PetActivateLine["TF_Description"];
         this.FUIItemSlots = new Vector.<TUIItemSlot>(CAPACITY_SLOT);
         this.FLines = new Vector.<Vector.<Sprite>>(4);
         _loc4_ = 5;
         _loc3_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            if(_loc1_ > 0 && _loc1_ < _loc4_)
            {
               _loc6_ = new Vector.<Sprite>(_loc1_ * 2);
            }
            _loc2_ = 0;
            while(_loc2_ <= _loc1_)
            {
               _loc5_ = new TUIItemSlot(this);
               _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
               _loc5_.TopLine = this.FMC_PetActivateLine["SP_TopLine_" + _loc1_ + "_" + _loc2_];
               _loc5_.BottomLine = this.FMC_PetActivateLine["SP_BottomLine_" + _loc1_ + "_" + _loc2_];
               _loc5_.Resource = this.FMC_PetActivateLine["Grid_" + _loc1_ + "_" + _loc2_];
               _loc5_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
               _loc5_.OnClick = this.ProcessorUIItemSlotOnClick;
               _loc5_.OnOver = this.ProcessorUIItemSlotOnOver;
               _loc5_.OnOut = this.ProcessorUIItemSlotOnOut;
               _loc5_.OnQueryActivated = this.ProcessorOnQueryActivated;
               _loc5_.CellIndex = _loc2_;
               _loc5_.RowIndex = _loc1_;
               _loc5_.RowIndex = _loc1_;
               var _loc12_:uint;
               this.FUIItemSlots[_loc12_ = _loc3_++] = _loc5_;
               _loc2_++;
            }
            if(_loc1_ > 0 && _loc1_ < _loc4_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_ * 2)
               {
                  _loc6_[_loc2_] = this.FMC_PetActivateLine["SP_Line_" + (_loc1_ - 1) + "_" + _loc2_];
                  _loc2_++;
               }
               this.FLines[_loc1_ - 1] = _loc6_;
            }
            _loc1_++;
         }
         this.FSP_Preview = this.FMC_PetActivateLine["SP_Preview"];
         this.FSP_MountPoint = this.FSP_Preview["SP_MountPoint"];
         this.FUIHero = new TUIHero(this);
         this.FSP_MountPoint.mouseEnabled = false;
         this.FSP_MountPoint.mouseChildren = false;
         this.FSP_MountPoint.addChild(this.FUIHero);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIHero.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         _loc7_ = new TBounds();
         _loc8_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc8_,_loc7_);
         this.FUIHero.X = _loc7_.X;
         this.FUIHero.Y = _loc7_.Y;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.Btn_CloseClick,false,0,true);
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
         while(_loc1_ < CAPACITY_SLOT)
         {
            this.FUIItemSlots[_loc1_].Update();
            _loc1_++;
         }
         this.FUIHero.Update();
      }
      
      protected function ProcessorUIItemSlotOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TMainPet = null;
         var _loc6_:TMainPet = null;
         var _loc7_:String = null;
         var _loc8_:TMainPet = null;
         var _loc9_:TUIItemSlot = null;
         _loc9_ = param1 as TUIItemSlot;
         _loc5_ = param2 as TMainPet;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickNumOnePet);
         this.FUIHero.Context = _loc5_;
         _loc6_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc5_.Identifier0,_loc5_.Identifier1) as TMainPet;
         if(_loc6_ != null)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_SLOT)
         {
            this.FUIItemSlots[_loc3_].SetSelected(false);
            _loc3_++;
         }
         _loc9_.SetSelected(true);
         this.FPetData.MainPetSelected = _loc5_;
         _loc7_ = "";
         _loc4_ = int(_loc5_.PetRankUpCondition.PetIds.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = this.FPetData.MainPets.GetPetByIdentifier(this.FPetData.MainPetSelected.PetRankUpCondition.PetIds[_loc3_],0) as TMainPet;
            _loc7_ += _loc8_.Name;
            _loc7_ = _loc7_ + (TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_16) + this.FPetData.MainPetSelected.PetRankUpCondition.Levels[_loc3_] + "\n");
            _loc3_++;
         }
         this.FTF_Description.text = _loc7_;
         this.FBtn_GoActivate.Enabled = _loc9_.ActivateStatus;
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
      
      protected function UpdateUIActivateLine() : void
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
            _loc4_ = this.FPetData.MaxMainPets.GetPetByIndex(_loc1_) as TMainPet;
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
               this.FUIItemSlots[_loc1_].PlayActivateEffect();
            }
            _loc1_++;
         }
         this.SetTopIconMCState(true);
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPetBase = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:uint = 0;
         _loc5_ = param2 as TPetBase;
         _loc10_ = CONST_ROLE.GetModelIDByIndex(_loc5_.ModelID,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Right);
         _loc6_ = SResourcesCore.TexturesModel;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc10_);
         if(_loc7_ != null)
         {
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
            param3.Value.Evaluate(_loc9_,_loc8_);
            this.FUIHero.X = _loc8_.X;
            this.FUIHero.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(_loc10_);
         }
         this.SetRoleModelID(_loc10_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      protected function Btn_CloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseActiveLineWindow);
      }
      
      protected function Btn_GoActivateOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
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
            _loc18_ = _loc9_.RowIndex;
            _loc15_ = _loc9_.CellIndex;
            _loc13_ = _loc11_.PetRankUpCondition.PetIds;
            _loc5_ = int(_loc13_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc12_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc13_[_loc4_],0) as TMainPet;
               if(_loc12_ != null)
               {
                  _loc17_ = this.FPetData.MainPets.GetIndexByPetID(_loc12_.TemplateID);
                  _loc10_ = this.FUIItemSlots[_loc17_];
                  _loc10_.TopLine.visible = true;
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
                     _loc14_[_loc6_].visible = true;
                     _loc6_++;
                  }
               }
               _loc4_++;
            }
            return;
         }
      }
      
      protected function SetTopIconMCState(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = 0;
         _loc3_ = this.FMC_Effects.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1)
            {
               this.FMC_Effects[_loc2_].play();
            }
            else
            {
               this.FMC_Effects[_loc2_].stop();
            }
            _loc2_++;
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
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Vector.<Sprite> = null;
         if(!this.FInitialization)
         {
            return;
         }
         this.SetTopIconMCState(false);
         this.FTF_Description.text = "";
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_SLOT)
         {
            this.FUIItemSlots[_loc1_].Reset();
            _loc1_++;
         }
         this.FUIHero.Context = null;
         _loc2_ = int(this.FLines.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FLines[_loc1_];
            _loc4_ = int(_loc7_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc7_[_loc3_].visible = false;
               _loc3_++;
            }
            _loc1_++;
         }
         this.FBtn_GoActivate.Enabled = false;
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = uint(this.FRolesModelID[_loc1_]);
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc5_,true);
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
      }
      
      public function Update() : void
      {
         this.UpdateUIActivateLine();
      }
   }
}

