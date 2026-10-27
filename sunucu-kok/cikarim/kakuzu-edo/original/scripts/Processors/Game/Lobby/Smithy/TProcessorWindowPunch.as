package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Components.Standard.TUIButton;
   import Foundation.Queries.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowPunch extends TProcessorLobbyWindow
   {
      
      protected static const PUNCHLEVEL_69:uint = 69;
      
      protected static const PUNCHLEVEL_89:uint = 89;
      
      protected static const PUNCHLEVEL_119:uint = 119;
      
      protected static const PUNCHLEVEL_139:uint = 139;
      
      protected static const PUNCHLEVEL_140:uint = 179;
      
      protected var FUISlot:TUISlot;
      
      protected var FTF_EquipmentLevel:TextField;
      
      protected var FTF_Available:TextField;
      
      protected var FTF_Cost:TextField;
      
      protected var FTF_needNum:TextField;
      
      protected var FTF_haveNum:TextField;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FHeroID:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FReciveEquipment:TEquipment;
      
      protected var FPunchConsume:int;
      
      protected var FPunchLevel:uint;
      
      protected var FPunchStage:int;
      
      protected var FBaseEquip:TBaseEquip;
      
      protected var FCountItem0:uint;
      
      protected var FCountItem1:uint;
      
      protected var FCountItem:uint;
      
      protected var FPunchNeedNum:uint;
      
      protected var FPunchCostItem0Name:String;
      
      protected var FPunchCostItem1Name:String;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FUpdateHeroPower:Function;
      
      protected var FPunchNetwork:Function;
      
      public function TProcessorWindowPunch(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function PunchUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         this.FUISlot = new TUISlot(this);
         _loc2_ = param1["MC_Slot"];
         this.FUISlot.Resource = _loc2_;
         this.FUISlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         this.FTF_EquipmentLevel = param1["EquipmentLevel"];
         this.FTF_Available = param1["TF_Available"];
         this.FTF_Cost = param1["TF_Cost"];
         this.FTF_needNum = param1["TF_needNum"];
         this.FTF_haveNum = param1["TF_haveNum"];
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = param1["Btn_OK"];
         this.FBtn_OK.OnClick = this.OnPunchBtnClick;
         this.FBtn_OK.Enabled = false;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function PunchLocation() : void
      {
         TJadeCommon.InitSlot(this.FUISlot);
         this.FUISlot.OnClick = this.OnEquipSlotClick;
         this.FUISlot.Init();
         this.FUISlot.OnOver = this.UIComponentsHintOnOver;
         this.FUISlot.OnOut = this.UIComponentsHintOnOut;
         this.FUISlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
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
            this.FUISlot.Update();
         }
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      protected function VerificationPunch() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.FPunchNetwork == null)
         {
            return false;
         }
         if(!this.FBtn_OK.Enabled)
         {
            return false;
         }
         if(SLogicsCore.Character.CreditSilverCoin.ToNumber() < this.FPunchConsume)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_52);
            return false;
         }
         if(this.FCountItem < this.FPunchNeedNum)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_53);
            return false;
         }
         return true;
      }
      
      protected function BuildConfirmationText() : String
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.FCountItem0 >= this.FPunchNeedNum)
         {
            return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_54),this.FPunchNeedNum,this.FPunchCostItem0Name);
         }
         if(this.FCountItem0 == 0)
         {
            return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_54),this.FPunchNeedNum,this.FPunchCostItem1Name);
         }
         if(this.FCountItem0 < this.FPunchNeedNum)
         {
            return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_55),this.FCountItem0,this.FPunchCostItem0Name,this.FPunchNeedNum - this.FCountItem0,this.FPunchCostItem1Name);
         }
         return TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_53);
      }
      
      protected function UpdatePunchBaseInfor() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TDrillHole = null;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         var _loc8_:TArticle = null;
         var _loc9_:TBaseEquip = null;
         if(this.FReciveEquipment == null)
         {
            this.ResetPunchBaseInfor();
            return;
         }
         this.FCountItem0 = 0;
         this.FCountItem1 = 0;
         this.FCountItem = 0;
         _loc1_ = SLogicsCore.Character.Materials;
         _loc3_ = uint(_loc1_.Count);
         this.FPunchStage = this.FReciveEquipment.HoleAdditionalQuantity + 1;
         this.FPunchLevel = this.SetPunchLevel(this.FReciveEquipment);
         _loc6_ = this.FPunchLevel * 1000 + this.FPunchStage;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DrillHoleCost,_loc6_) as TDrillHole;
         if(_loc5_ == null || this.FPunchLevel == -1 || this.FPunchStage == -1)
         {
            return;
         }
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.DrillCostItem[0]) as TArticle;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.DrillCostItem[1]) as TArticle;
         this.FPunchConsume = _loc5_.DrillCostMoney;
         this.FPunchNeedNum = _loc5_.CostItemNum;
         this.FPunchCostItem0Name = _loc7_.Name;
         this.FPunchCostItem1Name = _loc8_.Name;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc4_);
            if(_loc2_.IDTemplate == _loc5_.DrillCostItem[0])
            {
               this.FCountItem0 += _loc2_.Quantity;
            }
            if(_loc2_.IDTemplate == _loc5_.DrillCostItem[1])
            {
               this.FCountItem1 += _loc2_.Quantity;
            }
            _loc4_++;
         }
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,this.FReciveEquipment.IDTemplate) as TBaseEquip;
         this.FCountItem = this.FCountItem0 + this.FCountItem1;
         this.FTF_EquipmentLevel.text = "Lv." + this.FReciveEquipment.RequirementLevel.toString();
         this.FTF_Available.text = (_loc9_.DrillHoleNum - this.FReciveEquipment.HoleAdditionalQuantity).toString();
         this.FTF_Cost.text = _loc5_.DrillCostMoney.toString();
         this.FTF_needNum.text = _loc5_.CostItemNum.toString();
         this.FTF_haveNum.text = this.FCountItem.toString();
      }
      
      protected function SetPunchLevel(param1:TEquipment) : int
      {
         if(param1.RequirementLevel <= 69)
         {
            return PUNCHLEVEL_69;
         }
         if(param1.RequirementLevel <= 89)
         {
            return PUNCHLEVEL_89;
         }
         if(param1.RequirementLevel <= 119)
         {
            return PUNCHLEVEL_119;
         }
         if(param1.RequirementLevel <= 139)
         {
            return PUNCHLEVEL_139;
         }
         if(param1.RequirementLevel >= 140)
         {
            return PUNCHLEVEL_140;
         }
         return -1;
      }
      
      protected function ResetPunchBaseInfor() : void
      {
         this.FUISlot.Context = null;
         this.FTF_EquipmentLevel.text = "";
         this.FTF_Available.text = "";
         this.FTF_Cost.text = "";
         this.FTF_needNum.text = "";
         this.FTF_haveNum.text = "";
         this.FBtn_OK.Enabled = false;
         this.FCountItem0 = 0;
         this.FCountItem1 = 0;
         this.FCountItem = 0;
         this.FReciveEquipment = null;
      }
      
      protected function OnPunchBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = this.VerificationPunch();
         if(!_loc3_)
         {
            return;
         }
         this.FUIWindowConfirmation.Text = this.BuildConfirmationText();
         this.FUIWindowConfirmation.OnOK = this.OnConfirmationOk;
         this.FUIWindowConfirmation.Visible = true;
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
      
      protected function OnEquipSlotClick(param1:Object, param2:Object) : void
      {
         this.Reset();
         this.UIComponentsHintOnOut(param1,param2 as TInventory);
      }
      
      protected function OnConfirmationOk(param1:Object) : void
      {
         if(this.FPunchNetwork != null)
         {
            this.FPunchNetwork(this,this.FReciveEquipment,this.FHeroID);
         }
      }
      
      public function get OnSlotMouseOver() : Function
      {
         return this.FOnSlotMouseOver;
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function get OnSlotMouseOut() : Function
      {
         return this.FOnSlotMouseOut;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function get UpdateHeroPower() : Function
      {
         return this.FUpdateHeroPower;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function get PunchNetwork() : Function
      {
         return this.FPunchNetwork;
      }
      
      public function set PunchNetwork(param1:Function) : void
      {
         this.FPunchNetwork = param1;
      }
      
      public function get PunchStage() : int
      {
         return this.FPunchStage;
      }
      
      public function set PunchStage(param1:int) : void
      {
         this.FPunchStage = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.addChild(param1);
         this.PunchUIDispatch(param1);
      }
      
      public function ReciveEquipment(param1:TEquipment, param2:uint) : void
      {
         var _loc3_:TBaseEquip = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,param1.IDTemplate) as TBaseEquip;
         if(_loc3_.DrillHoleNum == 0)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_57);
            return;
         }
         if(_loc3_.DrillHoleNum <= param1.HoleAdditionalQuantity)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_58);
            this.ResetPunchBaseInfor();
            return;
         }
         this.FReciveEquipment = param1;
         this.FHeroID = param2;
         this.FUISlot.Context = this.FReciveEquipment;
         this.UpdatePunchBaseInfor();
         if(this.FReciveEquipment == null)
         {
            this.FBtn_OK.Enabled = false;
         }
         else
         {
            this.FBtn_OK.Enabled = true;
         }
      }
      
      public function Perform_UILocation() : void
      {
         this.PunchLocation();
         this.Reset();
         this.FInitialization = true;
      }
      
      public function Update() : void
      {
         if(this.FReciveEquipment == null)
         {
            this.Reset();
            return;
         }
         if(this.FUpdateHeroPower != null && this.FHeroID != 0)
         {
            this.FUpdateHeroPower(this,this.FHeroID);
         }
         this.ReciveEquipment(this.FReciveEquipment,this.FHeroID);
      }
      
      public function Reset() : void
      {
         this.ResetPunchBaseInfor();
      }
   }
}

