package Processors.Game.Lobby.Pet.PetTrain.Components
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Logics.Pet.Train.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIPetTrainSlot extends TUIComponent
   {
      
      protected var FPetData:TPetData;
      
      protected var FMC_Slot:TUISlot;
      
      protected var FMC_CompleteSlot:TUISlot;
      
      protected var FTF_Type:TextField;
      
      protected var FTF_Time:TextField;
      
      protected var FTF_Exp:TextField;
      
      protected var FMC_Bar:Sprite;
      
      protected var FHint:THint;
      
      protected var FSP_Lock:Sprite;
      
      protected var FSP_Complete:Sprite;
      
      protected var FBtn_Complete:TUIButton;
      
      protected var FBtn_Open:TUIButton;
      
      protected var FBtn_Cleartime:TUIButton;
      
      protected var FBtnMax:TUIButton;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FTimeCoolDownTrain:TTimeCoolDown;
      
      protected var FInitialization:Boolean;
      
      protected var FPet:TPetBase;
      
      protected var FResource:Sprite;
      
      protected var FContext:TTrainData;
      
      protected var FOnOpen:Function;
      
      protected var FOnClose:Function;
      
      protected var FOnComplete:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnUseCard:Function;
      
      public function TUIPetTrainSlot(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
         this.FHint = new THint();
         this.FTimeCoolDownTrain = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Pet_Train);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDownTrain);
      }
      
      protected function Initialization() : void
      {
         this.FResource.mouseEnabled = false;
         this.FMC_Slot = new TUISlot(this);
         this.FMC_Slot.Resource = this.FResource["MC_Slot"];
         this.FMC_Slot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_Slot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FMC_Slot.OnQuerySubscript = this.SlotsOnQuerySubscript;
         this.FMC_Slot.OnOver = this.ProcessorOnSlotOver;
         this.FMC_Slot.OnOut = this.ProcessorOnSlotOut;
         this.FMC_Slot.Tag = this.Tag;
         this.FMC_Slot.Init();
         this.FTF_Type = this.FResource["TF_Type"];
         this.FTF_Time = this.FResource["TF_Time"];
         this.FTF_Exp = this.FResource["TF_Exp"];
         this.FMC_Bar = this.FResource["MC_Bar"];
         this.FMC_Bar.addEventListener(MouseEvent.MOUSE_OVER,this.BarOnMove);
         this.FMC_Bar.addEventListener(MouseEvent.MOUSE_OUT,this.BarOnOut);
         this.FSP_Lock = this.FResource["SP_Lock"];
         this.FSP_Lock.mouseEnabled = false;
         this.FSP_Complete = this.FResource["SP_Complete"];
         this.FSP_Complete.mouseEnabled = false;
         this.FSP_Complete.visible = false;
         this.FMC_CompleteSlot = new TUISlot(this);
         this.FMC_CompleteSlot.Resource = this.FSP_Complete["MC_Slot"];
         this.FMC_CompleteSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_CompleteSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FMC_CompleteSlot.OnQuerySubscript = this.SlotsOnQuerySubscript;
         this.FMC_CompleteSlot.OnOver = this.ProcessorOnSlotOver;
         this.FMC_CompleteSlot.OnOut = this.ProcessorOnSlotOut;
         this.FMC_CompleteSlot.Init();
         this.FBtn_Open = new TUIButton();
         this.FBtn_Open.Substrate = this.FSP_Lock["Btn_Open"];
         this.FBtn_Open.OnClick = this.BtnOpenClick;
         this.FBtn_Cleartime = new TUIButton();
         this.FBtn_Cleartime.Substrate = this.FResource["Btn_Cleartime"];
         this.FBtn_Cleartime.OnClick = this.BtnUseExpOnClick;
         this.FBtn_Cleartime.OnOver = this.BtnClearOnOver;
         this.FBtn_Cleartime.OnOut = this.BtnOnOut;
         this.FBtnMax = new TUIButton();
         this.FBtnMax.Substrate = this.FResource["Btn_Max"];
         this.FBtnMax.OnClick = this.BtnUseExpOnClick;
         this.FBtnMax.OnOver = this.BtnMaxOnOver;
         this.FBtnMax.OnOut = this.BtnOnOut;
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FResource["Btn_Close"];
         this.FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FBtn_Complete = new TUIButton();
         this.FBtn_Complete.Substrate = this.FSP_Complete["Btn_Complete"];
         this.FBtn_Complete.OnClick = this.BtnCompleteOnClick;
         this.Reset();
         this.FInitialization = true;
      }
      
      protected function UpdateConext() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         if(this.FResource == null)
         {
            return;
         }
         _loc1_ = "";
         switch(this.FContext.Status)
         {
            case TTrainData.TYPE_UNOPEN:
               if(this.FContext.Identifier >= this.FPetData.CurrentVicePetTrainSlotCount + 1)
               {
                  this.FBtn_Open.Enabled = false;
               }
               this.FSP_Lock.visible = true;
               break;
            case TTrainData.TYPE_COMPLETED:
               this.FSP_Complete.visible = true;
               this.FTimeCoolDownTrain.TimingTime = 0;
               break;
            case TTrainData.TYPE_USED:
               if(this.FContext.TrainType == 0)
               {
                  _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_37);
               }
               else if(this.FContext.TrainType == 1)
               {
                  _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_38);
               }
               else if(this.FContext.TrainType == 2)
               {
                  _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_39);
               }
               if(this.FTimeCoolDownTrain.TimingTime <= 0)
               {
                  if(this.FContext.TrainCD > STimingCore.ServerTick)
                  {
                     this.FTimeCoolDownTrain.TimingTime = this.FContext.TrainCD - (STimingCore.ServerTick - this.FContext.CurrentServerTick);
                  }
                  else
                  {
                     this.FTimeCoolDownTrain.TimingTime = 0;
                  }
               }
         }
         this.FTF_Type.text = _loc1_;
         this.FPet = this.FPetData.OwnVicePets.GetPetByIdentifier(this.FContext.VicePetHighID,this.FContext.VicePetLowID);
         this.FMC_Slot.Context = this.FPet;
         this.FMC_CompleteSlot.Context = this.FPet;
         if(this.FPet != null)
         {
            _loc2_ = this.FPet.Experience / this.FPet.NextExperience;
            if(_loc2_ > 1)
            {
               _loc2_ = 1;
            }
            else if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            this.FMC_Bar.scaleX = _loc2_;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      protected function BtnOpenClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpen != null)
         {
            this.FOnOpen(this);
         }
      }
      
      protected function BtnClearOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_56);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnMaxOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_57);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnUseExpOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtn_Cleartime:
               this.FOnUseCard(this.FPet,CONST_PET.ExpType_One);
               break;
            case this.FBtnMax:
               this.FOnUseCard(this.FPet,CONST_PET.ExpType_More);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
      }
      
      protected function BtnCompleteOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnComplete != null)
         {
            this.FOnComplete(this);
         }
      }
      
      protected function BarOnMove(param1:MouseEvent) : void
      {
         var _loc2_:TPetBase = null;
         var _loc3_:String = null;
         if(this.FContext == null)
         {
            return;
         }
         _loc2_ = this.FPetData.OwnVicePets.GetPetByIdentifier(this.FContext.VicePetHighID,this.FContext.VicePetLowID);
         _loc3_ = TUtilityString.Format(CONST_COMMON.STRING_Capacity,_loc2_.Experience,_loc2_.NextExperience);
         this.FHint.Caption = _loc3_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BarOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
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
            param3.Value = _loc4_.Name;
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
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.Initialization();
         }
      }
      
      public function get Context() : TTrainData
      {
         return this.FContext;
      }
      
      public function set Context(param1:TTrainData) : void
      {
         this.Reset();
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateConext();
         }
      }
      
      public function get OnOpen() : Function
      {
         return this.FOnOpen;
      }
      
      public function set OnOpen(param1:Function) : void
      {
         this.FOnOpen = param1;
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function get OnComplete() : Function
      {
         return this.FOnComplete;
      }
      
      public function set OnComplete(param1:Function) : void
      {
         this.FOnComplete = param1;
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
      
      public function get OnUseCard() : Function
      {
         return this.FOnUseCard;
      }
      
      public function set OnUseCard(param1:Function) : void
      {
         this.FOnUseCard = param1;
      }
      
      public function Reset() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FTF_Type.text = "";
         this.FMC_Slot.Context = null;
         this.FMC_CompleteSlot.Context = null;
         this.FTF_Time.text = "";
         this.FTF_Exp.text = "";
         this.FMC_Bar.scaleX = 0;
         this.FSP_Lock.visible = false;
         this.FSP_Complete.visible = false;
         this.FBtn_Cleartime.Visible = false;
         this.FBtnMax.Visible = false;
         this.FBtn_Close.Visible = false;
         this.FBtn_Open.Enabled = true;
      }
      
      public function LogicPerform_TrainSlotCD() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         _loc2_ = this.FTimeCoolDownTrain.TimingTime;
         if(this.FContext.Status == TTrainData.TYPE_USED)
         {
            _loc1_ = TUtilityTiming.fomatTime(_loc2_);
            this.FBtn_Cleartime.Visible = true;
            this.FBtnMax.Visible = true;
            this.FBtn_Close.Visible = true;
            if(!TUtilityString.Empty(_loc1_))
            {
               this.FTF_Time.text = _loc1_;
               this.FTF_Exp.text = Math.ceil((this.FContext.NeedTime - _loc2_) / this.FContext.NeedTime * this.FContext.Exp).toString();
            }
         }
         if(this.FContext.Status == TTrainData.TYPE_COMPLETED)
         {
            this.FSP_Complete.visible = true;
            this.FBtn_Complete.Visible = true;
         }
         this.FMC_Slot.Update();
         this.FMC_CompleteSlot.Update();
      }
      
      public function UpdataTrainCD() : void
      {
         this.FTimeCoolDownTrain.TimingTime = 0;
      }
      
      public function ResetTimingTime() : void
      {
         this.FTimeCoolDownTrain.TimingTime = this.FContext.NeedTime;
      }
   }
}

