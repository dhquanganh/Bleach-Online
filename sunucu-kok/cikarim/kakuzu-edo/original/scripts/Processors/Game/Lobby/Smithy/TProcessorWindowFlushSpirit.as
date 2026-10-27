package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowFlushSpirit extends TProcessorLobbyWindow
   {
      
      public static var FlushSpiritMapIDVec:Vector.<uint>;
      
      protected var FMainScene:MovieClip;
      
      protected var FSlotEquipment:TUISlot;
      
      protected var FTFEquipmentLevel:TextField;
      
      protected var FTFCurrentAttribute:TextField;
      
      protected var FTFNextAttribute:TextField;
      
      protected var FTFNeedStoneNum:TextField;
      
      protected var FTFSuccessRate:TextField;
      
      protected var FSlotProtectedStone:TUISlot;
      
      protected var FTFProtectedStoneName:TextField;
      
      protected var FBtnBuyProtectedStone:TUIButton;
      
      protected var FProetectedStoneInventories:TInventories;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FEffect:MovieClip;
      
      protected var FFlushSpiritStonePrice:Vector.<uint>;
      
      protected var FMCStone:MovieClip;
      
      protected var FMCSmallPowerStone:MovieClip;
      
      protected var FMCBigPowerStone:MovieClip;
      
      protected var FTFStoneNum:TextField;
      
      protected var FTFSmallPowerStone:TextField;
      
      protected var FTFBigPowerStone:TextField;
      
      protected var FStoneInventories:TInventories;
      
      protected var FBtnFlushSpirit:TUIButton;
      
      protected var FEquipment:TEquipment;
      
      protected var FHeroID:uint;
      
      protected var FAdditionalAddParamter:Number;
      
      protected var FTempleValueVO:TTempleValue;
      
      protected var FNextLevelTempleValueVO:TTempleValue;
      
      protected var FTempleValueID:uint;
      
      protected var FLevelMapIDIndex:int;
      
      protected var FProtecedStoneFlag:uint;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorWindowFlushSpirit(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.FSlotProtectedStone.Update();
            this.FSlotEquipment.Update();
         }
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.FMainScene = param1;
         addChild(this.FMainScene);
         this.EquipmentInforUIDispatch();
         this.ProtectedStoneUIDispatch();
         this.FlushStoneUIDispatch();
         this.FlushUIDispatch();
      }
      
      protected function EquipmentInforUIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FSlotEquipment = new TUISlot(this);
         this.FSlotEquipment.Resource = this.FMainScene["equipmentSlot"];
         TJadeCommon.InitSlot(this.FSlotEquipment);
         this.FSlotEquipment.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotEquipment.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotEquipment.Init();
         this.FTFEquipmentLevel = this.FMainScene["EquipmentLevel"];
         this.FTFCurrentAttribute = this.FMainScene["value0"]["TF"];
         this.FTFNextAttribute = this.FMainScene["value1"]["TF"];
         this.FTFNeedStoneNum = this.FMainScene["value2"]["TF"];
         this.FTFSuccessRate = this.FMainScene["value3"]["TF"];
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_AddtionAddParamterID) as TConfigValue;
         this.FAdditionalAddParamter = _loc1_.Value as Number;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_FlushSpiritMapID) as TConfigValue;
         FlushSpiritMapIDVec = _loc1_.Value as Vector.<uint>;
      }
      
      protected function ProtectedStoneUIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FSlotProtectedStone = new TUISlot(this);
         this.FSlotProtectedStone.Resource = this.FMainScene["ProtectedSlot"];
         TJadeCommon.InitSlot(this.FSlotProtectedStone);
         this.FSlotProtectedStone.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotProtectedStone.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotProtectedStone.Init();
         this.FTFProtectedStoneName = this.FMainScene["Name"];
         this.FBtnBuyProtectedStone = new TUIButton();
         this.FBtnBuyProtectedStone.Substrate = this.FMainScene["BtnProtected"];
         this.FBtnBuyProtectedStone.OnClick = this.BtnBuyProtectedStoneOnClick;
         this.FEffect = this.FMainScene["Effect"];
         this.FProetectedStoneInventories = new TInventories();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_FlushSpiritStonePrice) as TConfigValue;
         this.FFlushSpiritStonePrice = _loc1_.Value as Vector.<uint>;
      }
      
      protected function FlushStoneUIDispatch() : void
      {
         this.FMCStone = this.FMainScene["MCStone"];
         this.FTFStoneNum = this.FMainScene["MCStoneValue"];
         this.FMCSmallPowerStone = this.FMainScene["SmallPowerStone"];
         this.FTFSmallPowerStone = this.FMainScene["SmallPowerStoneValue"];
         this.FTFBigPowerStone = this.FMainScene["BigPowerStoneValue"];
         this.FMCBigPowerStone = this.FMainScene["BigPowerStone"];
         this.FMCStone.addEventListener(MouseEvent.MOUSE_MOVE,this.StoneOnOver);
         this.FMCStone.addEventListener(MouseEvent.MOUSE_OUT,this.StoneOnOut);
         this.FMCSmallPowerStone.addEventListener(MouseEvent.MOUSE_MOVE,this.StoneOnOver);
         this.FMCSmallPowerStone.addEventListener(MouseEvent.MOUSE_OUT,this.StoneOnOut);
         this.FMCBigPowerStone.addEventListener(MouseEvent.MOUSE_MOVE,this.StoneOnOver);
         this.FMCBigPowerStone.addEventListener(MouseEvent.MOUSE_OUT,this.StoneOnOut);
         this.FStoneInventories = new TInventories();
      }
      
      protected function FlushUIDispatch() : void
      {
         this.FBtnFlushSpirit = new TUIButton();
         this.FBtnFlushSpirit.Substrate = this.FMainScene["FlushSpirit"];
         this.FBtnFlushSpirit.OnClick = this.BtnFlushSpiritOnClick;
      }
      
      protected function RenderByEquipment() : void
      {
         this.RenderEquipmentInfor();
         this.RenderProtectedStone();
         this.RenderFlushStone();
      }
      
      protected function RenderEquipmentInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FSlotEquipment.Context = this.FEquipment;
         this.FTFEquipmentLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_65),this.FEquipment.FlushSpiritLevel);
         _loc2_ = this.GetMainTypeValue(this.FEquipment) + TProcessorSmithy.GetStrengthValue(this.FEquipment,0);
         _loc3_ = _loc2_;
         if(this.FTempleValueVO != null)
         {
            _loc3_ = _loc2_ + this.CountFlushSpiritAttributeValue(this.FEquipment,this.FTempleValueVO);
         }
         this.FTFCurrentAttribute.text = _loc3_.toString();
         _loc3_ = _loc2_ + this.CountFlushSpiritAttributeValue(this.FEquipment,this.FNextLevelTempleValueVO);
         this.FTFNextAttribute.text = _loc3_.toString();
         this.FTFNeedStoneNum.text = this.FNextLevelTempleValueVO.FlushSpiritConsume.toString();
         if(this.IfHaveProtectedStone())
         {
            this.FTFSuccessRate.text = "100%";
         }
         else
         {
            this.FTFSuccessRate.text = this.FNextLevelTempleValueVO.FlushSpiritSuccessrate / 10 + "%";
         }
      }
      
      protected function RenderProtectedStone() : void
      {
         var _loc1_:TInventory = null;
         if(this.IfHaveProtectedStone())
         {
            _loc1_ = this.GetInventoyByID(this.FNextLevelTempleValueVO.ProtectedStone);
            this.FSlotProtectedStone.Context = _loc1_;
            this.FTFProtectedStoneName.text = _loc1_.Name;
            this.FBtnBuyProtectedStone.Visible = false;
            this.FEffect.visible = true;
            this.FEffect.play();
         }
         else
         {
            this.FSlotProtectedStone.Context = null;
            this.FTFProtectedStoneName.text = "";
            this.FBtnBuyProtectedStone.Visible = true;
            this.FEffect.visible = false;
            this.FEffect.stop();
         }
      }
      
      protected function RenderFlushStone() : void
      {
         this.FMCStone.visible = true;
         this.FMCSmallPowerStone.visible = true;
         this.FMCBigPowerStone.visible = true;
         this.FBtnFlushSpirit.Visible = true;
         this.FMCStone.gotoAndStop(this.FLevelMapIDIndex + 1);
         this.FTFStoneNum.text = SLogicsCore.Character.Materials.GetCountByTempleteID(this.FNextLevelTempleValueVO.FlushSpiritStone[0]).toString();
         this.FMCSmallPowerStone.gotoAndStop(this.FLevelMapIDIndex + 1);
         this.FTFSmallPowerStone.text = SLogicsCore.Character.Materials.GetCountByTempleteID(this.FNextLevelTempleValueVO.FlushSpiritStone[1]).toString();
         this.FTFBigPowerStone.text = SLogicsCore.Character.Materials.GetCountByTempleteID(this.FNextLevelTempleValueVO.FlushSpiritStone[2]).toString();
      }
      
      protected function GetMainTypeValue(param1:TEquipment) : int
      {
         var _loc2_:TBaseEquip = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,param1.IDTemplate) as TBaseEquip;
         return _loc2_.MainValue[0];
      }
      
      protected function GetTempleValue(param1:TEquipment, param2:int) : TTempleValue
      {
         var _loc3_:uint = 0;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         _loc5_ = int(FlushSpiritMapIDVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1.RequirementLevel < FlushSpiritMapIDVec[_loc4_])
            {
               break;
            }
            _loc4_++;
         }
         _loc4_--;
         _loc3_ = FlushSpiritMapIDVec[_loc4_];
         this.FLevelMapIDIndex = _loc4_;
         this.FTempleValueID = _loc3_ * 1000 + param1.CategorySecond * 100 + param1.FlushSpiritLevel + param2;
         return SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TempleValue,this.FTempleValueID) as TTempleValue;
      }
      
      protected function IfHaveProtectedStone() : Boolean
      {
         var _loc1_:uint = 0;
         _loc1_ = uint(1 << this.FLevelMapIDIndex);
         return (_loc1_ & this.FProtecedStoneFlag) != 0;
      }
      
      protected function CountFlushSpiritAttributeValue(param1:TEquipment, param2:TTempleValue) : int
      {
         return param2.LevelCoefficient * param1.FlushSpiritCoefficient * param2.TypeCoefficient * (param1.UpgradingLevel + this.FAdditionalAddParamter);
      }
      
      protected function GetStoneByID(param1:uint) : TInventory
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc4_ = this.FStoneInventories.GetInventoryByTempletID(param1);
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         SToolReward.GetInventoryByID(param1,this.FStoneInventories);
         return this.FStoneInventories.GetInventoryByTempletID(param1);
      }
      
      protected function GetInventoyByID(param1:uint) : TInventory
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc4_ = this.FProetectedStoneInventories.GetInventoryByTempletID(param1);
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         SToolReward.GetInventoryByID(param1,this.FProetectedStoneInventories);
         return this.FProetectedStoneInventories.GetInventoryByTempletID(param1);
      }
      
      protected function BuyProtectedStone(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FlushSpiritBuyStone_Req);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FTempleValueID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function StoneOnOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TInventory = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_ == this.FMCStone)
         {
            _loc3_ = this.GetStoneByID(this.FNextLevelTempleValueVO.FlushSpiritStone[0]);
         }
         else if(_loc2_ == this.FMCSmallPowerStone)
         {
            _loc3_ = this.GetStoneByID(this.FNextLevelTempleValueVO.FlushSpiritStone[1]);
         }
         else
         {
            _loc3_ = this.GetStoneByID(this.FNextLevelTempleValueVO.FlushSpiritStone[2]);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,_loc3_);
      }
      
      protected function StoneOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TInventory = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_ == this.FMCStone)
         {
            _loc3_ = this.GetStoneByID(this.FNextLevelTempleValueVO.FlushSpiritStone[0]);
         }
         else if(_loc2_ == this.FMCSmallPowerStone)
         {
            _loc3_ = this.GetStoneByID(this.FNextLevelTempleValueVO.FlushSpiritStone[1]);
         }
         else
         {
            _loc3_ = this.GetStoneByID(this.FNextLevelTempleValueVO.FlushSpiritStone[2]);
         }
         SUtilityOverLayer.UIComponentsHintOnOut(this,_loc3_);
      }
      
      protected function BtnBuyProtectedStoneOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_66),this.FFlushSpiritStonePrice[this.FLevelMapIDIndex],this.GetInventoyByID(this.FNextLevelTempleValueVO.ProtectedStone).Name);
         this.FUIWindowConfirmation.OnOK = this.BuyProtectedStone;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function BtnFlushSpiritOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FlushSpiritFlush_Req);
         _loc5_ = _loc4_.Data;
         _loc3_ = this.FHeroID == 0 ? this.FEquipment.Identifier : this.FEquipment.CategorySecond;
         _loc5_.writeUnsignedInt(this.FHeroID);
         _loc5_.writeUnsignedInt(_loc3_);
         _loc5_.writeUnsignedInt(this.FEquipment.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      public function set ProtecedStoneFlag(param1:uint) : void
      {
         this.FProtecedStoneFlag = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function ReciveEquipment(param1:TEquipment, param2:uint) : void
      {
         this.FEquipment = param1;
         this.FHeroID = param2;
         if(this.FEquipment.FlushSpiritCoefficient == 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_68));
            return;
         }
         this.FTempleValueVO = this.GetTempleValue(param1,0);
         this.FNextLevelTempleValueVO = this.GetTempleValue(param1,1);
         if(this.FNextLevelTempleValueVO == null)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_67));
            this.Reset();
            return;
         }
         this.RenderByEquipment();
      }
      
      public function Update() : void
      {
         if(this.FEquipment == null)
         {
            this.Reset();
            return;
         }
         if(this.FUpdateHeroPower != null && this.FHeroID != 0)
         {
            this.FUpdateHeroPower(this,this.FHeroID);
         }
         this.ReciveEquipment(this.FEquipment,this.FHeroID);
      }
      
      public function BuyStoneRet() : void
      {
         this.ReciveEquipment(this.FEquipment,this.FHeroID);
      }
      
      public function Reset() : void
      {
         this.FSlotEquipment.Context = null;
         this.FTFEquipmentLevel.text = "";
         this.FTFCurrentAttribute.text = "";
         this.FTFNextAttribute.text = "";
         this.FTFNeedStoneNum.text = "";
         this.FTFSuccessRate.text = "";
         this.FSlotProtectedStone.Context = null;
         this.FTFProtectedStoneName.text = "";
         this.FBtnBuyProtectedStone.Visible = false;
         this.FProetectedStoneInventories.Clear();
         this.FEffect.visible = false;
         this.FEffect.stop();
         this.FMCStone.visible = false;
         this.FMCSmallPowerStone.visible = false;
         this.FMCBigPowerStone.visible = false;
         this.FTFStoneNum.text = "";
         this.FTFSmallPowerStone.text = "";
         this.FTFBigPowerStone.text = "";
         this.FStoneInventories.Clear();
         this.FBtnFlushSpirit.Visible = false;
         this.FEquipment = null;
         this.FHeroID = 0;
         this.FTempleValueVO = null;
         this.FNextLevelTempleValueVO = null;
         this.FTempleValueID = 0;
         this.FLevelMapIDIndex = 0;
      }
   }
}

