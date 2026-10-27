package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.*;
   import Logics.Smithy.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowBatchRefined extends TProcessorLobbyWindow
   {
      
      public static const STATE_READY:int = 0;
      
      public static const STATE_BATCHREFINED:int = 1;
      
      public static const STATE_EXCHANGE:int = 2;
      
      public static const ACTIVITYNAME_NOMALREFIND_INDEX:int = 3;
      
      public static const ACTIVITYNAME_DIRECTION_INDEX:int = 4;
      
      protected var FMainUI:MovieClip;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FCurrentState:int;
      
      protected var FInitialization:Boolean;
      
      protected var FBatchRefinedUIHead:MovieClip;
      
      protected var FEquipmentSlot:TUISlot;
      
      protected var FMC_OldAttributesList:Vector.<MovieClip>;
      
      protected var FTF_OldAttributesName:Vector.<TextField>;
      
      protected var FTF_OldAttributesValue:Vector.<TextField>;
      
      protected var FTextFormat:TextFormat;
      
      protected var FBatchRefinedUIConfirm:MovieClip;
      
      protected var FMC_ActivitysTask:Vector.<MovieClip>;
      
      protected var FTF_ActivityCostValue:Vector.<TextField>;
      
      protected var FTF_ActivityCostName:Vector.<TextField>;
      
      protected var FBtn_BatchRefined:MovieClip;
      
      protected var FCurrentClickedTask:MovieClip;
      
      protected var FBtn_Close0:MovieClip;
      
      protected var FBatchRefinedUISelect:MovieClip;
      
      protected var FBtn_Select:Vector.<MovieClip>;
      
      protected var FMC_AttributeList:Vector.<MovieClip>;
      
      protected var FBtn_Exchange:MovieClip;
      
      protected var FBtn_ReBatchRefined:MovieClip;
      
      protected var FAppendAttribute:TEquipmentAppendAttribute;
      
      protected var FBtn_Close1:MovieClip;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FHeroID:uint;
      
      protected var FOldAttributes:TEquipmentAttributes;
      
      protected var FCurrentSmithyAttributeUnstreamizerData:TSmithyRefinedPakcetUnstreamizerData;
      
      protected var FReciveEquipment:TEquipment;
      
      protected var FCurrentSmithyAttributeList:TSmithyAttributeList;
      
      protected var FRefinedNetwork:Function;
      
      protected var FRefinedExchange:Function;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FOnWindowClose:Function;
      
      protected var FStrengthenResult:uint;
      
      public function TProcessorWindowBatchRefined(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SMITHY.RESOURCESID_SMITHY);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_SMITHY.RESOURCESID_ClassName_BatchRefined) as MovieClip;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FMainUI.gotoAndStop(1);
         this.FBatchRefinedUIHead = this.FMainUI["BatchWash_Top"];
         this.FBatchRefinedUIConfirm = this.FMainUI["BatchWash_Bottom"];
         this.OldAttributeUIDispatch(this.FBatchRefinedUIHead);
         this.RefinedConfirmUIDispatch(this.FBatchRefinedUIConfirm);
         addChild(this.FBatchRefinedUIHead);
         addChild(this.FBatchRefinedUIConfirm);
         this.FMainUI.gotoAndStop(2);
         this.FBatchRefinedUISelect = this.FMainUI["BatchResult_Bottom"];
         this.AttributesSelectUIDispatch(this.FBatchRefinedUISelect);
         addChild(this.FBatchRefinedUISelect);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.OldAttributeLocation();
         this.RefinedConfirmLocation();
         this.AttributesSelectLocation();
         this.Reset();
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
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
            this.FEquipmentSlot.Update();
         }
      }
      
      protected function OldAttributeUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FEquipmentSlot = new TUISlot(this);
         this.FEquipmentSlot.Resource = param1["Wash_Slot"];
         this.FMC_OldAttributesList = new Vector.<MovieClip>();
         this.FTF_OldAttributesName = new Vector.<TextField>();
         this.FTF_OldAttributesValue = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < CONST_SMITHY.MAX_BATCHREFINED_ATTRIBUTENUM)
         {
            _loc3_ = param1["Old_" + _loc2_];
            this.FMC_OldAttributesList.push(_loc3_);
            this.FTF_OldAttributesName.push(_loc3_["AttributeName"]);
            this.FTF_OldAttributesValue.push(_loc3_["NewValue"]);
            _loc2_++;
         }
      }
      
      protected function OldAttributeLocation() : void
      {
         TJadeCommon.InitSlot(this.FEquipmentSlot);
         this.FEquipmentSlot.Init();
         this.FBtn_Close0.addEventListener(MouseEvent.CLICK,this.OnBtnClose);
         this.FTextFormat = new TextFormat();
      }
      
      protected function UpdateOldAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipmentAppendAttribute = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         _loc4_ = this.FReciveEquipment.AppendAttributes.Count;
         _loc2_ = CONST_SMITHY.MAX_BATCHREFINED_ATTRIBUTENUM;
         _loc1_ = _loc4_;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FMC_OldAttributesList[_loc1_];
            _loc5_.visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = this.FReciveEquipment.AppendAttributes.GetAttributeByIndex(_loc1_);
            _loc5_ = this.FMC_OldAttributesList[_loc1_];
            this.SetTextByAttribute(this.FTF_OldAttributesName[_loc1_],this.FTF_OldAttributesValue[_loc1_],_loc3_);
            _loc5_.visible = true;
            _loc1_++;
         }
         this.FEquipmentSlot.Context = null;
         this.FEquipmentSlot.Context = this.FReciveEquipment;
      }
      
      protected function ResetAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = CONST_SMITHY.MAX_BATCHREFINED_ATTRIBUTENUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_OldAttributesList[_loc1_];
            _loc3_.visible = false;
            _loc1_++;
         }
         this.FEquipmentSlot.Context = null;
      }
      
      protected function SetTextByAttribute(param1:TextField, param2:TextField, param3:TEquipmentAppendAttribute) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Vector.<Number> = null;
         param1.text = param3.Name;
         if(param3.Percentage == 1)
         {
            _loc4_ = this.ChangeToRateString(param3.MaxValue,param3.Divisor);
            _loc5_ = this.ChangeToRateString(param3.Value,param3.Divisor);
         }
         else
         {
            _loc4_ = param3.MaxValue.toString();
            _loc5_ = param3.Value.toString();
         }
         _loc10_ = (param3.Value - param3.MinValue) / (param3.MaxValue - param3.MinValue);
         _loc12_ = CONST_SMITHY.HitPercentRate;
         _loc11_ = 0;
         while(_loc11_ < _loc12_.length)
         {
            if(_loc10_ <= _loc12_[_loc11_])
            {
               break;
            }
            _loc11_++;
         }
         _loc8_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_26);
         _loc9_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_27);
         _loc6_ = _loc8_.split("%value%").join(_loc5_) + _loc9_.split("%topValue%").join(_loc4_);
         _loc6_ = _loc6_.split("%colour%").join(CONST_SMITHY.TextColor[_loc11_]);
         param2.htmlText = _loc6_;
      }
      
      protected function ChangeToRateString(param1:uint, param2:uint) : String
      {
         if(param2 == 1000)
         {
            return param1 / 10 + "%";
         }
         return param1 + "%";
      }
      
      protected function SetTextColor(param1:TextField, param2:TEquipmentAppendAttribute) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Number> = null;
         _loc3_ = (param2.Value - param2.MinValue) / (param2.MaxValue - param2.MinValue);
         _loc5_ = CONST_SMITHY.HitPercentRate;
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            if(_loc3_ <= _loc5_[_loc4_])
            {
               break;
            }
            _loc4_++;
         }
         this.FTextFormat.color = CONST_SMITHY.TextColor[_loc4_];
         param1.setTextFormat(this.FTextFormat);
      }
      
      protected function RefinedConfirmUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         this.FMC_ActivitysTask = new Vector.<MovieClip>();
         this.FTF_ActivityCostValue = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < CONST_SMITHY.MAX_BATCHREFINED_ACTIVITYNUM)
         {
            this.FMC_ActivitysTask.push(param1["task_" + _loc2_]);
            this.FTF_ActivityCostValue.push(param1["CostValue_" + _loc2_]);
            _loc2_++;
         }
         this.FBtn_BatchRefined = param1["BatchWash_Btn"];
         this.FBtn_Close0 = param1["StrengthenClose"];
         param1["ActivityName1"].gotoAndStop(ACTIVITYNAME_NOMALREFIND_INDEX);
         param1["ActivityName2"].gotoAndStop(ACTIVITYNAME_DIRECTION_INDEX);
      }
      
      protected function RefinedConfirmLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FMC_ActivitysTask.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_ActivitysTask[_loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.OnActivitysActiveTaskClick);
            _loc1_++;
         }
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_BatchRefined,this.OnBatchRefinedClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Close0,this.OnBtnClose);
         this.FTF_ActivityCostValue[1].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_41);
      }
      
      protected function UpdateEquipmentRefinedCostValue() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FReciveEquipment.SellValue * CONST_SMITHY.NORMALREFINEDCOSTTIMES * 10;
         this.FTF_ActivityCostValue[0].text = _loc1_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_39);
      }
      
      protected function ResetActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = CONST_SMITHY.MAX_BATCHREFINED_ACTIVITYNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_ActivitysTask[_loc1_].gotoAndStop("cancle");
            _loc1_++;
         }
         this.FMC_ActivitysTask[0].gotoAndStop("ok");
      }
      
      protected function ActionToActivityTaskClick(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         _loc3_ = int(this.FMC_ActivitysTask.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FMC_ActivitysTask[_loc2_];
            _loc4_.gotoAndStop("cancle");
            _loc2_++;
         }
         _loc2_ = this.FMC_ActivitysTask.indexOf(param1);
         this.FMC_ActivitysTask[_loc2_].gotoAndStop("ok");
      }
      
      protected function SetConfirmViewVisible(param1:Boolean) : void
      {
         if(param1)
         {
            this.FBatchRefinedUIConfirm.visible = true;
            this.FBatchRefinedUISelect.visible = false;
         }
         else
         {
            this.FBatchRefinedUIConfirm.visible = false;
            this.FBatchRefinedUISelect.visible = true;
         }
      }
      
      protected function GetSelectActiveActivityIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FMC_ActivitysTask.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_ActivitysTask[_loc1_];
            if(_loc3_.currentFrameLabel == "ok")
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      protected function AttributesSelectUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         this.FBtn_Select = new Vector.<MovieClip>();
         this.FMC_AttributeList = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < CONST_SMITHY.MAX_BATCHREFINED_NEWATTRIBUTENUM)
         {
            this.FBtn_Select.push(param1["Task_" + _loc2_]);
            this.FMC_AttributeList.push(param1["MC_Attribute_" + _loc2_]);
            _loc2_++;
         }
         this.FBtn_Exchange = param1["BtnExchange"];
         this.FBtn_ReBatchRefined = param1["ReBatchRefined"];
         this.FBtn_Close1 = param1["StrengthenClose1"];
      }
      
      protected function AttributesSelectLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FBtn_Select.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBtn_Select[_loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.OnAttributeLeftTaskClick);
            _loc1_++;
         }
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Exchange,this.OnExchangeClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_ReBatchRefined,this.OnReBatchRefinedClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Close1,this.OnBtnClose);
         this.FCurrentClickedTask = null;
      }
      
      protected function UpdateNewSingleAttribute(param1:TEquipmentAppendAttributes, param2:MovieClip) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:TEquipmentAppendAttribute = null;
         _loc4_ = CONST_SMITHY.MAX_BATCHREFINED_ATTRIBUTENUM;
         _loc5_ = this.FReciveEquipment.AppendAttributes.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param2["Attribute_" + _loc3_];
            if(_loc3_ < _loc5_)
            {
               _loc7_ = param1.GetAttributeByIndex(_loc3_);
               this.SetTextByAttribute(_loc6_["AttributeName"],_loc6_["NewValue"],_loc7_);
               _loc6_.visible = true;
            }
            else
            {
               _loc6_.visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function UpdateNewAttributes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         _loc2_ = CONST_SMITHY.MAX_BATCHREFINED_NEWATTRIBUTENUM;
         _loc4_ = this.FCurrentSmithyAttributeUnstreamizerData.SmithyAttributeList.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < _loc4_)
            {
               this.UpdateNewSingleAttribute(this.FCurrentSmithyAttributeUnstreamizerData.SmithyAttributeList.GetAttributesByIndex(_loc1_),this.FMC_AttributeList[_loc1_]);
               _loc3_ = this.FBtn_Select[_loc1_];
               _loc3_.gotoAndStop("cancle");
            }
            _loc1_++;
         }
      }
      
      protected function ResetNewAttribute() : void
      {
         this.FCurrentClickedTask = null;
      }
      
      protected function GetSelectAttributeIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = this.FCurrentSmithyAttributeUnstreamizerData.SmithyAttributeList.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBtn_Select[_loc1_];
            if(_loc3_.currentFrameLabel == "ok")
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      protected function OnActivitysActiveTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         this.ActionToActivityTaskClick(_loc2_);
      }
      
      protected function OnAttributeLeftTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(this.FCurrentClickedTask == _loc2_)
         {
            if(_loc2_.currentFrameLabel == "ok")
            {
               _loc2_.gotoAndStop("cancle");
            }
            else
            {
               _loc2_.gotoAndStop("ok");
            }
         }
         else
         {
            if(this.FCurrentClickedTask != null)
            {
               this.FCurrentClickedTask.gotoAndStop("cancle");
            }
            _loc2_.gotoAndStop("ok");
         }
         this.FCurrentClickedTask = _loc2_;
      }
      
      protected function OnBatchRefinedClick(param1:MouseEvent) : void
      {
         this.OnReBatchRefinedClick(param1);
      }
      
      protected function OnBtnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnExchangeClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FRefinedExchange != null)
         {
            _loc2_ = this.GetSelectAttributeIndex();
            if(_loc2_ != -1)
            {
               this.FRefinedExchange(this,this.FHeroID,this.FReciveEquipment,_loc2_);
            }
         }
         this.FCurrentState = STATE_EXCHANGE;
      }
      
      protected function OnReBatchRefinedClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TCharacter = null;
         var _loc4_:TConfigValue = null;
         _loc2_ = this.GetSelectActiveActivityIndex();
         if(_loc2_ == 1)
         {
            _loc3_ = SLogicsCore.Character;
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60106018) as TConfigValue;
            if(_loc4_.Value as int > _loc3_.CreditGold + _loc3_.CreditGiftCertificate)
            {
               this.FUIWindowRecharge.visible = true;
               return;
            }
         }
         if(this.FRefinedNetwork != null)
         {
            this.FRefinedNetwork(this,this.FHeroID,this.FReciveEquipment,_loc2_,10);
         }
         this.FCurrentState = STATE_BATCHREFINED;
      }
      
      protected function OnBtnClose(param1:MouseEvent = null) : void
      {
         this.Reset();
         this.visible = false;
         if(this.FOnWindowClose != null)
         {
            this.FOnWindowClose();
         }
      }
      
      public function set AttributeList(param1:TSmithyRefinedPakcetUnstreamizerData) : void
      {
         this.FCurrentSmithyAttributeUnstreamizerData = param1;
         if(this.FCurrentSmithyAttributeUnstreamizerData.ResultCode == 0)
         {
            this.SetConfirmViewVisible(false);
            this.UpdateNewAttributes();
         }
      }
      
      public function set RefinedNetwork(param1:Function) : void
      {
         this.FRefinedNetwork = param1;
      }
      
      public function set RefinedExchange(param1:Function) : void
      {
         this.FRefinedExchange = param1;
      }
      
      public function set OnWindowClose(param1:Function) : void
      {
         this.FOnWindowClose = param1;
      }
      
      public function set StrengthenResult(param1:uint) : void
      {
         this.FStrengthenResult = param1;
      }
      
      public function Reset() : void
      {
         if(this.FInitialization)
         {
            this.SetConfirmViewVisible(true);
            this.ResetAttribute();
            this.ResetActivity();
            this.ResetNewAttribute();
            this.FEquipmentSlot.Context = null;
         }
      }
      
      public function ReciveEquipment(param1:TEquipment, param2:uint) : void
      {
         this.FReciveEquipment = param1;
         this.FHeroID = param2;
         this.FCurrentSmithyAttributeList = null;
         this.UpdateOldAttribute();
         this.UpdateEquipmentRefinedCostValue();
      }
      
      public function Update() : void
      {
         switch(this.FCurrentState)
         {
            case STATE_READY:
               break;
            case STATE_BATCHREFINED:
               if(this.FStrengthenResult != 0)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_40));
               }
               else
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_11));
               }
               this.FCurrentState = STATE_READY;
               break;
            case STATE_EXCHANGE:
               if(this.FStrengthenResult != 0)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_16));
               }
               else
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_15));
               }
               this.OnBtnClose(null);
               this.Reset();
               this.FCurrentState = STATE_READY;
         }
      }
   }
}

