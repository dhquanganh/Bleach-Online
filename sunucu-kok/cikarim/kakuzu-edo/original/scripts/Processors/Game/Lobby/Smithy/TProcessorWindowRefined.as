package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.*;
   import Logics.Smithy.*;
   import Logics.Streamization.Inventories.*;
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
   
   public class TProcessorWindowRefined extends TProcessorLobbyWindow
   {
      
      protected static const STATE_READY:int = 0;
      
      protected static const STATE_ONETIMEREFINE:int = 1;
      
      protected static const STATE_BATCHREFINED:int = 2;
      
      protected static const STATE_EXCHANGED:int = 3;
      
      protected static const UIWIDTH:int = 480;
      
      protected static const UIHEIGHT:int = 535;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FInitialization:Boolean;
      
      protected var FCurrentState:int;
      
      protected var UnstreamizerEquipmentAppendAttribute:TUnstreamizerEquipmentAppendAttribute;
      
      protected var FEquipmentSlot:TUISlot;
      
      protected var FMC_OldAttributesList:Vector.<MovieClip>;
      
      protected var FTF_OldAttributesName:Vector.<TextField>;
      
      protected var FTF_OldAttributesValue:Vector.<TextField>;
      
      protected var FMC_NewightAttributesList:Vector.<MovieClip>;
      
      protected var FTF_NewAttributesName:Vector.<TextField>;
      
      protected var FTF_NewAttributesValue:Vector.<TextField>;
      
      protected var FTextFormat:TextFormat;
      
      protected var FAppendAttribute:TEquipmentAppendAttribute;
      
      protected var FMC_Activitys:Vector.<MovieClip>;
      
      protected var FMC_ActivitysTask:Vector.<MovieClip>;
      
      protected var FTF_ActivityCostValue:Vector.<TextField>;
      
      protected var FTF_ActivityCostName:Vector.<TextField>;
      
      protected var FCurrentStrengthenActivity:uint;
      
      protected var FRefinedNeedSiliverCoin:int;
      
      protected var FActivities_Hint:Vector.<THint>;
      
      protected var FBoundsBatchRefined:TBounds;
      
      protected var FProcessorWindowBatchRefined:TProcessorWindowBatchRefined;
      
      protected var FVipLowHint:THint;
      
      protected var FFatherUI:MovieClip;
      
      protected var FBtn_SingleRefined:MovieClip;
      
      protected var FBtn_AnyTimeRefined:MovieClip;
      
      protected var FBtn_Replace:MovieClip;
      
      protected var FBtn_Ignore:MovieClip;
      
      protected var FTextRegistry:TRegistryInstance;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FRefinedActivitysDescribtion:Vector.<String>;
      
      protected var FReciveEquipment:TEquipment;
      
      protected var FHeroID:uint;
      
      protected var FCurrentSmithyAttributeUnstreamizerData:TSmithyRefinedPakcetUnstreamizerData;
      
      protected var FRefinedNetwork:Function;
      
      protected var FRefinedExchange:Function;
      
      protected var FStrengthenResult:uint;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorWindowRefined(param1:TUIComponent)
      {
         super(param1);
         this.ConstructDispatchRoutines();
         this.ConstructLocationRoutines();
         this.FProcessorWindowBatchRefined = new TProcessorWindowBatchRefined(this);
         this.FProcessorWindowBatchRefined.OnWindowClose = this.ProcessorBatchRefinedOnWindowClose;
         this.FProcessorWindowBatchRefined.x = 114;
         this.FProcessorWindowBatchRefined.y = 0;
         this.UnstreamizerEquipmentAppendAttribute = new TUnstreamizerEquipmentAppendAttribute();
      }
      
      protected function ConstructDispatchRoutines() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.EquipmentUIDispatch);
         this.FUIDispatchRoutines.push(this.AttributeUIDispatch);
         this.FUIDispatchRoutines.push(this.ActivityUIDispatch);
         this.FUIDispatchRoutines.push(this.BtnsUIDispatch);
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         this.FFatherUI = param1;
         this.addChild(param1);
         _loc2_ = 0;
         while(_loc2_ < this.FUIDispatchRoutines.length)
         {
            _loc3_ = this.FUIDispatchRoutines[_loc2_];
            _loc3_(param1);
            _loc2_++;
         }
         this.addChild(this.FProcessorWindowBatchRefined);
         this.FProcessorWindowBatchRefined.Load();
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
      }
      
      protected function ConstructLocationRoutines() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.EquipmentLocation);
         this.FUILocationRoutines.push(this.AttributeLocation);
         this.FUILocationRoutines.push(this.ActivityLocation);
         this.FUILocationRoutines.push(this.BtnsLocation);
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
         this.FCurrentState = STATE_READY;
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
      
      protected function EquipmentUIDispatch(param1:MovieClip) : void
      {
         this.FEquipmentSlot = new TUISlot(this);
         this.FEquipmentSlot.Resource = param1["Wash_Slot"];
         this.FEquipmentSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
      }
      
      protected function EquipmentLocation() : void
      {
         TJadeCommon.InitSlot(this.FEquipmentSlot);
         this.FEquipmentSlot.OnClick = this.OnEquipSlotClick;
         this.FEquipmentSlot.OnOver = this.UIComponentsHintOnOver;
         this.FEquipmentSlot.OnOut = this.UIComponentsHintOnOut;
         this.FEquipmentSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FEquipmentSlot.Init();
      }
      
      protected function UpdateEquipment() : void
      {
         var _loc1_:TEquipment = null;
         if(this.FReciveEquipment != null)
         {
            this.ReciveEquipment(this.FReciveEquipment,this.FHeroID);
         }
      }
      
      protected function ResetEquipment() : void
      {
         this.FEquipmentSlot.Context = null;
      }
      
      protected function GetEquipmentByID(param1:uint) : TEquipment
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         var _loc5_:THero = null;
         var _loc6_:THeros = null;
         var _loc7_:TEquipment = null;
         _loc6_ = SLogicsCore.Character.Heros;
         _loc3_ = _loc6_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc2_);
            _loc7_ = _loc5_.EquipmentsMounted.GetInventoryByIdentifier(param1) as TEquipment;
            if(_loc7_ != null)
            {
               return _loc7_;
            }
            _loc2_++;
         }
         _loc4_ = SLogicsCore.Character.Equipments;
         return _loc4_.GetInventoryByIdentifier(param1) as TEquipment;
      }
      
      protected function AttributeUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         this.FMC_OldAttributesList = new Vector.<MovieClip>();
         this.FTF_OldAttributesName = new Vector.<TextField>();
         this.FTF_OldAttributesValue = new Vector.<TextField>();
         this.FMC_NewightAttributesList = new Vector.<MovieClip>();
         this.FTF_NewAttributesName = new Vector.<TextField>();
         this.FTF_NewAttributesValue = new Vector.<TextField>();
         _loc3_ = CONST_SMITHY.MAX_ATTRIBUTENUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1["Old_" + _loc2_];
            this.FMC_OldAttributesList.push(_loc4_);
            this.FTF_OldAttributesName.push(_loc4_["AttributeName"]);
            this.FTF_OldAttributesValue.push(_loc4_["AttributeValue"]);
            _loc4_ = param1["New_" + _loc2_];
            this.FMC_NewightAttributesList.push(_loc4_);
            this.FTF_NewAttributesName.push(_loc4_["AttributeName"]);
            this.FTF_NewAttributesValue.push(_loc4_["AttributeValue"]);
            _loc2_++;
         }
      }
      
      protected function AttributeLocation() : void
      {
         this.FTextFormat = new TextFormat();
         this.FAppendAttribute = new TEquipmentAppendAttribute();
      }
      
      protected function UpdateAttribute() : void
      {
         this.UpdateOldAttribute();
         this.UpdateNewAttribute();
      }
      
      protected function UpdateOldAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipmentAppendAttribute = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         if(this.FReciveEquipment == null)
         {
            this.ResetAttribute();
            return;
         }
         _loc4_ = this.FReciveEquipment.AppendAttributes.Count;
         _loc2_ = CONST_SMITHY.MAX_ATTRIBUTENUM;
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
      }
      
      protected function UpdateNewAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipmentAppendAttribute = null;
         var _loc4_:TEquipmentAppendAttribute = null;
         var _loc5_:TEquipmentAppendAttributes = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         _loc6_ = this.FReciveEquipment.AppendAttributes.Count;
         _loc2_ = CONST_SMITHY.MAX_ATTRIBUTENUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FMC_NewightAttributesList[_loc1_];
            if(_loc1_ < _loc6_)
            {
               this.FTF_NewAttributesName[_loc1_].text = "";
               this.FTF_NewAttributesValue[_loc1_].text = "";
               _loc7_.visible = true;
            }
            else
            {
               _loc7_.visible = false;
            }
            _loc1_++;
         }
         if(this.FCurrentSmithyAttributeUnstreamizerData == null)
         {
            return;
         }
         _loc5_ = this.FCurrentSmithyAttributeUnstreamizerData.SmithyAttributeList.GetAttributesByIndex(0);
         _loc1_ = 0;
         while(_loc1_ < _loc6_)
         {
            _loc4_ = _loc5_.GetAttributeByIndex(_loc1_);
            _loc7_ = this.FMC_NewightAttributesList[_loc1_];
            this.SetTextByAttribute(this.FTF_NewAttributesName[_loc1_],this.FTF_NewAttributesValue[_loc1_],_loc4_);
            _loc1_++;
         }
      }
      
      protected function ResetAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = CONST_SMITHY.MAX_ATTRIBUTENUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_OldAttributesList[_loc1_];
            _loc3_.visible = false;
            _loc3_ = this.FMC_NewightAttributesList[_loc1_];
            _loc3_.visible = false;
            _loc1_++;
         }
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
      
      protected function SetTextByAttribute(param1:TextField, param2:TextField, param3:TEquipmentAppendAttribute) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Vector.<Number> = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
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
         _loc8_ = (param3.Value - param3.MinValue) / (param3.MaxValue - param3.MinValue);
         _loc10_ = CONST_SMITHY.HitPercentRate;
         _loc9_ = 0;
         while(_loc9_ < _loc10_.length)
         {
            if(_loc8_ <= _loc10_[_loc9_])
            {
               break;
            }
            _loc9_++;
         }
         _loc11_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_26);
         _loc12_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_27);
         _loc6_ = _loc11_.split("%value%").join(_loc5_) + _loc12_.split("%topValue%").join(_loc4_);
         _loc6_ = _loc6_.split("%colour%").join(CONST_SMITHY.TextColor[_loc9_]);
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
      
      protected function ActivityUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         this.FMC_Activitys = new Vector.<MovieClip>();
         this.FMC_ActivitysTask = new Vector.<MovieClip>();
         this.FTF_ActivityCostValue = new Vector.<TextField>();
         this.FTF_ActivityCostName = new Vector.<TextField>();
         _loc3_ = CONST_SMITHY.MAX_ACTIVITYNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1["Activity_" + _loc2_];
            this.FMC_Activitys.push(_loc4_);
            _loc4_["TypePicText"].gotoAndStop(_loc2_ + 3);
            this.FMC_ActivitysTask.push(_loc4_["task"]);
            this.FTF_ActivityCostValue.push(_loc4_["CostValue"]);
            _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.ActivityOnMouseMove);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.ActivityOnMouseOut);
            _loc2_++;
         }
         this.FRefinedActivitysDescribtion = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_23);
      }
      
      protected function ActivityLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:THint = null;
         _loc2_ = int(this.FMC_ActivitysTask.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_ActivitysTask[_loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.OnActivitysActiveTaskClick);
            _loc1_++;
         }
         var _loc5_:TConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60106018) as TConfigValue;
         this.FTF_ActivityCostValue[1].text = (_loc5_.Value as int) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_63);
         this.FActivities_Hint = new Vector.<THint>();
         _loc1_ = 0;
         while(_loc1_ < CONST_SMITHY.MAX_ACTIVITYNUM)
         {
            _loc4_ = new THint();
            _loc4_.Caption = this.FRefinedActivitysDescribtion[_loc1_];
            this.FActivities_Hint.push(_loc4_);
            _loc1_++;
         }
      }
      
      protected function ResetActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FMC_ActivitysTask[0].gotoAndStop("ok");
         _loc2_ = int(this.FMC_Activitys.length);
         _loc1_ = 1;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_ActivitysTask[_loc1_];
            _loc3_.gotoAndStop("cancle");
            _loc1_++;
         }
         this.FTF_ActivityCostValue[0].text = "";
      }
      
      protected function UpdateNormalRefinedCost() : void
      {
         var _loc1_:int = 0;
         if(this.FReciveEquipment == null)
         {
            this.FTF_ActivityCostValue[0].text = "";
            return;
         }
         _loc1_ = this.FReciveEquipment.SellValue * CONST_SMITHY.NORMALREFINEDCOSTTIMES;
         this.FRefinedNeedSiliverCoin = _loc1_;
         this.FTF_ActivityCostValue[0].text = _loc1_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_62);
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
      
      protected function BtnsUIDispatch(param1:MovieClip) : void
      {
         this.FBtn_SingleRefined = param1["SingleRefined"];
         this.FBtn_AnyTimeRefined = param1["AnyTimeRefined"];
         this.FFatherUI.addChild(this.FBtn_SingleRefined);
         this.FFatherUI.addChild(this.FBtn_AnyTimeRefined);
         param1.gotoAndStop(2);
         this.FBtn_Replace = param1["Replace"];
         this.FBtn_Ignore = param1["Ignore"];
         this.FFatherUI.addChild(this.FBtn_SingleRefined);
         this.FFatherUI.addChild(this.FBtn_AnyTimeRefined);
         this.FVipLowHint = new THint();
      }
      
      protected function BtnsLocation() : void
      {
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_SingleRefined,this.OnBtnSingleRefinedClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_AnyTimeRefined,this.OnBtnAnyTimeRefinedClick);
         this.FBtn_AnyTimeRefined.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMoveAnyTime);
         this.FBtn_AnyTimeRefined.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOutAnyTime);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Replace,this.OnBtnExchangeClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_Ignore,this.OnBtnIgnoreClick);
         this.FBtn_SingleRefined.buttonMode = true;
         this.FBtn_AnyTimeRefined.buttonMode = true;
         this.FBtn_Replace.buttonMode = true;
         this.FBtn_Ignore.buttonMode = true;
         this.FVipLowHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_25);
         this.FFatherUI.addChild(this.FBtn_Replace);
         this.FFatherUI.addChild(this.FBtn_Ignore);
      }
      
      protected function ShowRefinedBtns(param1:Boolean) : void
      {
         if(param1)
         {
            this.FBtn_Replace.visible = false;
            this.FBtn_Ignore.visible = false;
         }
         else
         {
            this.FBtn_Replace.visible = true;
            this.FBtn_Ignore.visible = true;
         }
      }
      
      protected function DisableBtns(param1:Boolean) : void
      {
         if(param1)
         {
            this.FBtn_SingleRefined.gotoAndStop("Disable");
            this.FBtn_AnyTimeRefined.gotoAndStop("Disable");
         }
         else
         {
            this.FBtn_SingleRefined.gotoAndStop("Enable");
            this.FBtn_AnyTimeRefined.gotoAndStop("Enable");
            if(!SLogicsCore.Character.VipData.OneTimeWash)
            {
               this.FBtn_AnyTimeRefined.gotoAndStop("Disable");
            }
         }
      }
      
      protected function ResetBtns() : void
      {
         this.ShowRefinedBtns(true);
         this.DisableBtns(true);
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      protected function VerificationStrengthen() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.FRefinedNetwork == null)
         {
            return false;
         }
         if(this.FBtn_SingleRefined.currentFrameLabel == "Disable")
         {
            return false;
         }
         if(SLogicsCore.Character.CreditSilverCoin.ToNumber() < this.FRefinedNeedSiliverCoin)
         {
            this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_17);
            return false;
         }
         return true;
      }
      
      protected function VipCheck() : void
      {
         this.FBtn_AnyTimeRefined.enabled = SLogicsCore.Character.VipData.OneTimeWash;
      }
      
      protected function OnBtnSingleRefinedClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:TCharacter = null;
         var _loc6_:TConfigValue = null;
         _loc4_ = this.VerificationStrengthen();
         if(!_loc4_)
         {
            return;
         }
         _loc2_ = this.GetSelectActiveActivityIndex();
         _loc3_ = CONST_SMITHY.REFINEDTYPEARRAY[_loc2_];
         if(_loc2_ == 1)
         {
            _loc5_ = SLogicsCore.Character;
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60106018) as TConfigValue;
            if(_loc6_.Value as int > _loc5_.CreditGold + _loc5_.CreditGiftCertificate)
            {
               this.FUIWindowRecharge.visible = true;
               return;
            }
         }
         if(this.FRefinedNetwork != null)
         {
            this.FRefinedNetwork(this,this.FHeroID,this.FReciveEquipment,_loc3_,1);
         }
         this.FCurrentState = STATE_ONETIMEREFINE;
      }
      
      protected function OnBtnAnyTimeRefinedClick(param1:MouseEvent) : void
      {
         if(this.FBtn_AnyTimeRefined.currentFrameLabel == "Disable")
         {
            return;
         }
         if(!SLogicsCore.Character.VipData.OneTimeWash)
         {
            return;
         }
         this.FProcessorWindowBatchRefined.ReciveEquipment(this.FReciveEquipment,this.FHeroID);
         this.FProcessorWindowBatchRefined.Update();
         this.FProcessorWindowBatchRefined.visible = true;
         this.FCurrentState = STATE_BATCHREFINED;
      }
      
      protected function OnMouseMoveAnyTime(param1:MouseEvent) : void
      {
         if(!SLogicsCore.Character.VipData.OneTimeWash)
         {
            if(this.FHintOnOver != null)
            {
               this.FHintOnOver(this,this.FVipLowHint);
            }
         }
      }
      
      protected function OnMouseOutAnyTime(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FVipLowHint);
         }
      }
      
      protected function OnBtnExchangeClick(param1:MouseEvent) : void
      {
         if(this.FRefinedExchange != null)
         {
            this.FRefinedExchange(this,this.FHeroID,this.FReciveEquipment,0);
         }
         this.FCurrentState = STATE_EXCHANGED;
      }
      
      protected function OnBtnIgnoreClick(param1:MouseEvent) : void
      {
         this.FCurrentSmithyAttributeUnstreamizerData = null;
         this.UpdateNewAttribute();
         this.ShowRefinedBtns(true);
      }
      
      protected function OnActivitysActiveTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         this.ActionToActivityTaskClick(_loc2_);
      }
      
      protected function OnEquipSlotClick(param1:Object, param2:Object) : void
      {
         this.Reset();
         this.UIComponentsHintOnOut(param1,param2 as TInventory);
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
      
      protected function ProcessorBatchRefinedOnWindowClose() : void
      {
         this.FCurrentState = STATE_READY;
      }
      
      protected function ActivityOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FMC_Activitys.indexOf(_loc2_);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FActivities_Hint[_loc3_]);
         }
      }
      
      protected function ActivityOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FMC_Activitys.indexOf(_loc2_);
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FActivities_Hint[_loc3_]);
         }
      }
      
      public function set RefinedNetwork(param1:Function) : void
      {
         this.FRefinedNetwork = param1;
         this.FProcessorWindowBatchRefined.RefinedNetwork = param1;
      }
      
      public function set CurrentSmithyAttributeList(param1:TSmithyRefinedPakcetUnstreamizerData) : void
      {
         if(this.FCurrentState == STATE_BATCHREFINED)
         {
            this.FProcessorWindowBatchRefined.AttributeList = param1;
         }
         else
         {
            this.FCurrentSmithyAttributeUnstreamizerData = param1;
            if(this.FCurrentSmithyAttributeUnstreamizerData.ResultCode == 0)
            {
               this.UpdateNewAttribute();
            }
         }
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function set RefinedExchange(param1:Function) : void
      {
         this.FRefinedExchange = param1;
         this.FProcessorWindowBatchRefined.RefinedExchange = param1;
      }
      
      public function set StrengthenResult(param1:uint) : void
      {
         this.FStrengthenResult = param1;
         this.FProcessorWindowBatchRefined.StrengthenResult = param1;
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         super.OnEffectText = param1;
         this.FProcessorWindowBatchRefined.OnEffectText = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function Update() : void
      {
         switch(this.FCurrentState)
         {
            case STATE_READY:
               this.VipCheck();
               break;
            case STATE_ONETIMEREFINE:
               if(this.FStrengthenResult == 0)
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_11);
               }
               else
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_18);
               }
               this.ShowRefinedBtns(false);
               this.FCurrentState = STATE_READY;
               break;
            case STATE_EXCHANGED:
               if(this.FStrengthenResult == 0)
               {
                  this.FCurrentSmithyAttributeUnstreamizerData = null;
                  this.UpdateNewAttribute();
                  this.UpdateEquipment();
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_15);
                  if(this.FUpdateHeroPower != null && this.FHeroID != 0)
                  {
                     this.FUpdateHeroPower(this,this.FHeroID);
                  }
               }
               else
               {
                  this.FlyText(CONST_SYSTEMLANGUAGE.SMITHY_STRING_16);
               }
               this.ShowRefinedBtns(true);
               this.FCurrentState = STATE_READY;
               break;
            case STATE_BATCHREFINED:
               this.UpdateEquipment();
               this.FProcessorWindowBatchRefined.Update();
         }
      }
      
      public function Reset() : void
      {
         this.ResetEquipment();
         this.ResetAttribute();
         this.ResetActivity();
         this.ResetBtns();
         this.FEquipmentSlot.Context = null;
         this.FProcessorWindowBatchRefined.Reset();
      }
      
      public function ReciveEquipment(param1:TEquipment, param2:uint) : void
      {
         this.FReciveEquipment = param1;
         this.FHeroID = param2;
         if(this.FReciveEquipment != null)
         {
            this.ShowRefinedBtns(true);
            this.FEquipmentSlot.Context = null;
            this.FEquipmentSlot.Context = param1;
            this.FCurrentSmithyAttributeUnstreamizerData = null;
            if(this.FReciveEquipment.AppendAttributes.Count != 0)
            {
               this.UpdateOldAttribute();
            }
            this.UpdateNormalRefinedCost();
            this.DisableBtns(false);
         }
      }
   }
}

