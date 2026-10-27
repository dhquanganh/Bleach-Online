package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowInherit extends TProcessorLobbyWindow
   {
      
      protected static const STATE_READY:int = 0;
      
      protected static const STATE_INHEIRIT:int = 1;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FCurrentState:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOldEquipmentSlot:TUISlot;
      
      protected var FNewEquipmentSlot:TUISlot;
      
      protected var FOldEquipment:TEquipment;
      
      protected var FNewEquipment:TEquipment;
      
      protected var FExchangeGift:Boolean;
      
      protected var FMC_InheritTask:MovieClip;
      
      protected var FTF_OldInheritBefore:TextField;
      
      protected var FTF_OldInheritAfter:TextField;
      
      protected var FTF_NewInheritBefore:TextField;
      
      protected var FTF_NewInheritAfter:TextField;
      
      protected var FTF_ReturnMonery:TextField;
      
      protected var FMC_OldExegesis:MovieClip;
      
      protected var FMC_NewExegesis:MovieClip;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FBtn_Inherit:MovieClip;
      
      protected var FTextRegistry:TRegistryInstance;
      
      protected var FUpgradeLevel:int;
      
      protected var FReciveEquipment:TEquipment;
      
      protected var FOldHeroID:uint;
      
      protected var FNewHeroID:uint;
      
      protected var FOnInheritNetwork:Function;
      
      protected var FStrengthenResult:uint;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FUpdateHerosPower:Function;
      
      public function TProcessorWindowInherit(param1:TUIComponent)
      {
         super(param1);
         this.ConstructDispatchRoutines();
         this.ConstructLocationRoutines();
      }
      
      protected function ConstructDispatchRoutines() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.EquipmentUIDispatch);
         this.FUIDispatchRoutines.push(this.ConfirmUIDispatch);
         this.FUIDispatchRoutines.push(this.BtnUIDispatch);
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         this.addChild(param1);
         _loc2_ = 0;
         while(_loc2_ < this.FUIDispatchRoutines.length)
         {
            _loc3_ = this.FUIDispatchRoutines[_loc2_];
            _loc3_(param1);
            _loc2_++;
         }
      }
      
      protected function ConstructLocationRoutines() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.EquipmentLocation);
         this.FUILocationRoutines.push(this.ConfirmLocation);
         this.FUILocationRoutines.push(this.BtnLocation);
      }
      
      public function Perform_UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUILocationRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         this.Reset();
         this.FInitialization = true;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            this.FOldEquipmentSlot.Update();
            this.FNewEquipmentSlot.Update();
         }
      }
      
      protected function EquipmentUIDispatch(param1:MovieClip) : void
      {
         this.FOldEquipmentSlot = new TUISlot(this);
         this.FOldEquipmentSlot.Resource = param1["Old_Slot"];
         this.FOldEquipmentSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         this.FNewEquipmentSlot = new TUISlot(this);
         this.FNewEquipmentSlot.Resource = param1["New_Slot"];
         this.FNewEquipmentSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         this.FMC_InheritTask = param1["Inherit_Selected"];
         this.FTF_OldInheritBefore = param1["TF_OldInheritBefore"];
         this.FTF_OldInheritAfter = param1["TF_OldInheritAfter"];
         this.FTF_NewInheritAfter = param1["TF_NewInheritAfter"];
         this.FTF_NewInheritBefore = param1["TF_NewInheritBefore"];
         this.FTF_ReturnMonery = param1["TF_ReturnMonery"];
         this.FMC_OldExegesis = param1["mc_oldExegesis"];
         this.FMC_NewExegesis = param1["mc_newExegesis"];
      }
      
      protected function EquipmentLocation() : void
      {
         TJadeCommon.InitSlot(this.FOldEquipmentSlot);
         this.FOldEquipmentSlot.OnClick = this.OnSlotClick;
         this.FOldEquipmentSlot.OnOver = this.UIComponentsHintOnOver;
         this.FOldEquipmentSlot.OnOut = this.UIComponentsHintOnOut;
         this.FOldEquipmentSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FOldEquipmentSlot.Init();
         TJadeCommon.InitSlot(this.FNewEquipmentSlot);
         this.FNewEquipmentSlot.OnClick = this.OnSlotClick;
         this.FNewEquipmentSlot.OnOver = this.UIComponentsHintOnOver;
         this.FNewEquipmentSlot.OnOut = this.UIComponentsHintOnOut;
         this.FNewEquipmentSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FNewEquipmentSlot.Init();
         this.FMC_InheritTask.addEventListener(MouseEvent.CLICK,this.OnTaskClick);
      }
      
      protected function SendEquipment(param1:TEquipment) : void
      {
         if(this.FOldEquipment == null)
         {
            this.FOldEquipment = param1;
         }
         else if(this.FNewEquipment == null)
         {
            if(this.FOldEquipment != param1)
            {
               this.FNewEquipment = param1;
            }
         }
         else
         {
            this.FOldEquipment = param1;
            this.FNewEquipment = null;
         }
         if(this.FOldEquipment != null && this.FNewEquipment != null)
         {
            this.FBtn_Inherit.gotoAndStop("Enable");
         }
         else
         {
            this.FBtn_Inherit.gotoAndStop("Disable");
         }
         this.UpdateEquipmentSlot();
      }
      
      protected function UpdateEquipmentSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_38);
         this.FOldEquipmentSlot.Context = this.FOldEquipment;
         this.FNewEquipmentSlot.Context = this.FNewEquipment;
         if(this.FOldEquipment != null)
         {
            this.FTF_OldInheritBefore.text = TUtilityString.Format(_loc2_,this.FOldEquipment.UpgradingLevel.toString());
            this.FTF_OldInheritAfter.text = TUtilityString.Format(_loc2_,"0");
            this.FMC_OldExegesis.gotoAndStop(2);
         }
         else
         {
            this.FTF_OldInheritBefore.text = "";
            this.FTF_OldInheritAfter.text = "";
            this.FMC_OldExegesis.gotoAndStop(1);
         }
         if(this.FNewEquipment != null && this.FOldEquipment != null)
         {
            _loc1_ = this.EquipmentInherit(this.FOldEquipment,this.FNewEquipment);
            this.FTF_NewInheritAfter.text = TUtilityString.Format(_loc2_,_loc1_.toString());
            this.FTF_NewInheritBefore.text = TUtilityString.Format(_loc2_,this.FNewEquipment.UpgradingLevel.toString());
            this.FMC_NewExegesis.gotoAndStop(2);
            this.GetReturnMoney(this.FOldEquipment,this.FNewEquipment,_loc1_);
         }
         else
         {
            this.FTF_NewInheritAfter.text = "";
            this.FTF_NewInheritBefore.text = "";
            this.FTF_ReturnMonery.text = "";
            this.FMC_NewExegesis.gotoAndStop(1);
            if(this.FNewEquipment != null)
            {
               this.FMC_NewExegesis.gotoAndStop(2);
            }
         }
      }
      
      protected function ResetEquipmentSlot() : void
      {
         this.FOldEquipment = null;
         this.FNewEquipment = null;
         this.UpdateEquipmentSlot();
      }
      
      protected function StopScrew() : void
      {
      }
      
      protected function StartScrew() : void
      {
      }
      
      protected function SetInheritTask(param1:Boolean) : void
      {
         this.FExchangeGift = param1;
         if(param1)
         {
            this.FMC_InheritTask.gotoAndStop("ok");
         }
         else
         {
            this.FMC_InheritTask.gotoAndStop("cancle");
         }
      }
      
      protected function ConfirmUIDispatch(param1:MovieClip) : void
      {
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function ConfirmLocation() : void
      {
         this.FUIWindowConfirmation.OnOK = this.OnClickCofirmOk;
      }
      
      protected function OnClickCofirmOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(this.FOnInheritNetwork != null)
         {
            if(this.FExchangeGift)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = 0;
            }
            this.FOnInheritNetwork(this,this.FOldHeroID,this.FOldEquipment,this.FNewHeroID,this.FNewEquipment,_loc2_);
            this.FCurrentState = STATE_INHEIRIT;
         }
      }
      
      protected function EquipmentInherit(param1:TEquipment, param2:TEquipment) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         _loc3_ = int(param1.SellingValue);
         _loc5_ = int(param2.UpgradingLevel);
         while(_loc5_ <= SLogicsCore.Character.GetMainLevel())
         {
            _loc6_ = CONST_SMITHY.GetBuildConsumeID(param2.Quality,_loc5_);
            _loc4_ = this.GetConsumeByID(_loc6_);
            if(_loc4_ == -1)
            {
               break;
            }
            if(_loc3_ < _loc4_)
            {
               break;
            }
            _loc3_ -= _loc4_;
            _loc5_++;
         }
         _loc7_ = int(SLogicsCore.Character.GetMainLevel());
         return _loc5_ > _loc7_ ? _loc7_ : int(_loc5_);
      }
      
      protected function GetReturnMoney(param1:TEquipment, param2:TEquipment, param3:int) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc6_ = int(param2.UpgradingLevel);
         _loc7_ = int(param1.SellingValue);
         while(param3 > _loc6_)
         {
            if(_loc6_ > SLogicsCore.Character.GetMainLevel())
            {
               break;
            }
            _loc4_ = CONST_SMITHY.GetBuildConsumeID(param2.Quality,_loc6_);
            _loc5_ = this.GetConsumeByID(_loc4_);
            if(_loc5_ == -1)
            {
               break;
            }
            if(_loc7_ < _loc5_)
            {
               break;
            }
            _loc7_ -= _loc5_;
            _loc6_++;
         }
         this.FTF_ReturnMonery.text = _loc7_.toString();
      }
      
      protected function GetConsumeByID(param1:uint) : int
      {
         var _loc2_:TBuildConsume = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildConsume,param1) as TBuildConsume;
         if(_loc2_ == null)
         {
            return -1;
         }
         return _loc2_.Consume;
      }
      
      protected function BtnUIDispatch(param1:MovieClip) : void
      {
         this.FBtn_Inherit = param1["Inherit_OK"];
      }
      
      protected function BtnLocation() : void
      {
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Inherit,this.OnBtnInheritClick);
         this.FBtn_Inherit.buttonMode = true;
         this.FBtn_Inherit.gotoAndStop(1);
      }
      
      protected function ResetBtn() : void
      {
         this.FBtn_Inherit.gotoAndStop("Disable");
         this.FExchangeGift = false;
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      protected function VerificationInherit() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         if(this.FBtn_Inherit.currentFrameLabel == "Disable")
         {
            return false;
         }
         if(this.FMC_InheritTask.currentFrameLabel == "ok" && this.FOldEquipment.HoleQuantity != this.FNewEquipment.HoleQuantity)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_20);
            return false;
         }
         this.FUpgradeLevel = this.EquipmentInherit(this.FOldEquipment,this.FNewEquipment);
         if(this.FUpgradeLevel == this.FNewEquipment.UpgradingLevel)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_21);
            return false;
         }
         return true;
      }
      
      protected function OnTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrameLabel == "ok")
         {
            this.SetInheritTask(false);
         }
         else
         {
            this.SetInheritTask(true);
         }
      }
      
      public function OnBtnInheritClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.VerificationInherit();
         if(!_loc2_)
         {
            return;
         }
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_37),this.FNewEquipment.UpgradingLevel,this.FUpgradeLevel);
         this.FUIWindowConfirmation.OnOK = this.OnClickCofirmOk;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnSlotClick(param1:Object = null, param2:Object = null) : void
      {
         var _loc3_:TUISlot = null;
         _loc3_ = param1 as TUISlot;
         this.UIComponentsHintOnOut(param1,param2 as TInventory);
         if(_loc3_ == this.FOldEquipmentSlot)
         {
            this.FOldEquipment = null;
         }
         else
         {
            this.FNewEquipment = null;
         }
         this.ResetBtn();
         this.UpdateEquipmentSlot();
      }
      
      protected function UIComponentsHintOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOver != null)
         {
            this.FOnSlotMouseOver(param1,param2);
         }
      }
      
      protected function UIComponentsHintOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOut != null)
         {
            this.FOnSlotMouseOut(param1,param2);
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      public function set OnInheritNetwork(param1:Function) : void
      {
         this.FOnInheritNetwork = param1;
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function set StrengthenResult(param1:uint) : void
      {
         this.FStrengthenResult = param1;
      }
      
      public function set UpdateHerosPower(param1:Function) : void
      {
         this.FUpdateHerosPower = param1;
      }
      
      public function Update() : void
      {
         switch(this.FCurrentState)
         {
            case STATE_READY:
               break;
            case STATE_INHEIRIT:
               if(this.FStrengthenResult == 0)
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_19);
                  if(this.FUpdateHerosPower != null && (this.FOldHeroID != 0 || this.FNewHeroID != 0))
                  {
                     this.FUpdateHerosPower(this);
                  }
                  this.FOldHeroID = 0;
                  this.FNewHeroID = 0;
                  this.Reset();
               }
               else
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_20);
               }
               this.FCurrentState = STATE_READY;
         }
      }
      
      public function Reset() : void
      {
         this.ResetEquipmentSlot();
         this.SetInheritTask(false);
         this.ResetBtn();
         this.FOldEquipmentSlot.Context = null;
         this.FNewEquipmentSlot.Context = null;
      }
      
      public function ReciveEquipment(param1:TEquipment, param2:uint) : void
      {
         if(this.FOldEquipment == null)
         {
            this.FOldHeroID = param2;
         }
         else if(this.FNewEquipment == null)
         {
            if(this.FOldEquipment != param1)
            {
               this.FNewHeroID = param2;
            }
         }
         else
         {
            this.FOldHeroID = param2;
            this.FNewHeroID = 0;
         }
         this.FReciveEquipment = param1;
         this.SendEquipment(param1);
      }
   }
}

