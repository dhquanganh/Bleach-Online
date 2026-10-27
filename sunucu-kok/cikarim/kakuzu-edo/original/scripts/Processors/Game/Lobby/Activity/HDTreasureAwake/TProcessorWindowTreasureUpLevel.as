package Processors.Game.Lobby.Activity.HDTreasureAwake
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Talisman.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowTreasureUpLevel extends TProcessorLobbyWindow
   {
      
      protected static const AttributeFormat:String = "%0 +%1";
      
      protected var FMainUI:Sprite;
      
      protected var FEffect:MovieClip;
      
      protected var FUITab:TUITab;
      
      protected var FScroolBar:TScrollBar;
      
      protected var FPreSlot:TUISlot;
      
      protected var FTFPreTreasureName:TextField;
      
      protected var FNextSlot:TUISlot;
      
      protected var FTFNextTreasureName:TextField;
      
      protected var FTFCurrentAttribute:TextField;
      
      protected var FTFNextAttribute:TextField;
      
      protected var FTFCurrentLevel:TextField;
      
      protected var FTFNextLevel:TextField;
      
      protected var FTFCost:TextField;
      
      protected var FTFDescription:TextField;
      
      protected var FBtnBuyPaper:TUIButton;
      
      protected var FBtnUpLevel:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FTrasureMaxLevel:int;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FCurrentSelectTreasure:TEquipment;
      
      protected var FNextTreasure:TEquipment;
      
      protected var FCurrentSelectSingleEquipe:TSingleEquip;
      
      protected var FMC_SingleEquipList:Vector.<TSingleEquip>;
      
      protected var FOnBuyPaper:Function;
      
      public function TProcessorWindowTreasureUpLevel(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.UpdateSingleEquip();
            _loc1_++;
         }
         this.FPreSlot.Update();
         this.FNextSlot.Update();
         if(this.FEffect.currentFrame == this.FEffect.totalFrames)
         {
            this.PlayEffectOver();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:String = null;
         var _loc2_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("TreasureUpLevelUI") as Sprite;
         addChild(this.FMainUI);
         this.FEffect = this.FMainUI["Effect"];
         _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_36);
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(this.FMainUI["GeneralNameGroup"]["General_0"],0);
         this.FUITab.SetTabCaptionByIndex(_loc1_,0);
         this.FScroolBar = new TScrollBar(this.FMainUI["mc_list"],343);
         this.FPreSlot = new TUISlot(this);
         this.FPreSlot.Resource = this.FMainUI["Pre_Slot"];
         TJadeCommon.InitSlot(this.FPreSlot);
         this.FPreSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FPreSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FPreSlot.Init();
         this.FTFPreTreasureName = this.FMainUI["PreTreasurename"];
         this.FNextSlot = new TUISlot(this);
         this.FNextSlot.Resource = this.FMainUI["Next_Slot"];
         TJadeCommon.InitSlot(this.FNextSlot);
         this.FNextSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FNextSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FNextSlot.Init();
         this.FTFNextTreasureName = this.FMainUI["NextTreasurename"];
         this.FTFCurrentAttribute = this.FMainUI["CurrentAttribute"]["Lable"];
         this.FTFNextAttribute = this.FMainUI["NextAttribute"]["Lable"];
         this.FTFCurrentLevel = this.FMainUI["CurrentLevel"]["Lable"];
         this.FTFNextLevel = this.FMainUI["NextLevel"]["Lable"];
         this.FTFCost = this.FMainUI["Cost"]["Lable"];
         this.FTFDescription = this.FMainUI["Des"];
         this.FBtnBuyPaper = new TUIButton();
         this.FBtnBuyPaper.Substrate = this.FMainUI["BuyPaper"];
         this.FBtnBuyPaper.OnClick = this.BtnBuyPaperOnClick;
         this.FBtnUpLevel = new TUIButton();
         this.FBtnUpLevel.Substrate = this.FMainUI["BtnLevelUp"];
         this.FBtnUpLevel.OnClick = this.BtnUpLevelOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FMC_SingleEquipList = new Vector.<TSingleEquip>();
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60100042) as TConfigValue;
         this.FTrasureMaxLevel = _loc2_.Value as int;
      }
      
      public function UILocation() : void
      {
         this.FTFDescription.text = "";
         this.Reset();
      }
      
      public function RenderBackPack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TEquipment = null;
         var _loc5_:TInventories = null;
         this.ResetBackPack();
         _loc5_ = SLogicsCore.Character.Treasures;
         _loc2_ = _loc5_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = SLogicsCore.PoolUISingleEquipment.AcquireUISingleEquipment(this);
            _loc3_.StubReferences.Reference(this);
            _loc3_.OnClick = this.EquipmentClick;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FScroolBar.AddItem(_loc3_);
            this.FMC_SingleEquipList.push(_loc3_);
            this.FScroolBar.ScrollToUp();
            _loc1_++;
         }
         this.UpdateEquipmentInfor();
      }
      
      public function RenderSelectedTreasure(param1:TEquipment, param2:TEquipment) : void
      {
         var _loc3_:TTreasureLevelup = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TreasureLevelup,this.GetApplyID(param1)) as TTreasureLevelup;
         param2.UpgradingLevel = _loc3_.UpLevel;
         if(param2.UpgradingBasisProperty.length > 0)
         {
            param2.UpgradingBasisProperty[0] = this.GetAddValueByTreasure(param2);
         }
         else
         {
            param2.UpgradingBasisProperty.push(this.GetAddValueByTreasure(param2));
         }
         this.ResetSelectedTreasureInfor();
         this.FPreSlot.Context = param1;
         this.FTFPreTreasureName.text = param1.Name;
         this.FNextSlot.Context = param2;
         this.FTFNextTreasureName.text = param2.Name;
         this.FTFCurrentAttribute.text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(param1.BasisPropertyCategory[0]),param1.BasisProperty[0] + (param1.UpgradingBasisProperty.length > 0 ? param1.UpgradingBasisProperty[0] : 0));
         this.FTFNextAttribute.text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(param1.BasisPropertyCategory[0]),param2.BasisProperty[0] + (param2.UpgradingBasisProperty.length > 0 ? param2.UpgradingBasisProperty[0] : 0));
         this.FTFCost.text = _loc3_.NeedGold.toString();
         this.FTFCurrentLevel.text = param1.UpgradingLevel.toString();
         this.FTFNextLevel.text = _loc3_.UpLevel.toString();
      }
      
      protected function GetAddValueByTreasure(param1:TEquipment) : int
      {
         var _loc2_:TBins = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTreasureUpgrade = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TreasureUpgrade);
         _loc4_ = _loc2_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc2_.GetDatebaseByIndex(_loc3_) as TTreasureUpgrade;
            if(_loc5_.Identifier == param1.IDTemplate * 100 + param1.UpgradingLevel)
            {
               return _loc5_.AddValue[0];
            }
            _loc3_++;
         }
         return 0;
      }
      
      protected function UpdateEquipmentInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:int = 0;
         var _loc5_:TSingleEquip = null;
         var _loc6_:String = null;
         var _loc7_:TInventories = null;
         _loc7_ = SLogicsCore.Character.Treasures;
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_14);
         _loc4_ = _loc7_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = _loc7_.GetInventoryByIndex(_loc1_) as TEquipment;
            _loc5_ = this.FMC_SingleEquipList[_loc1_];
            _loc5_.SetEquip(_loc3_,_loc3_.Name,_loc6_ + _loc3_.UpgradingLevel,_loc3_.Quality);
            _loc1_++;
         }
      }
      
      protected function ResetBackPack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.Release();
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         this.FMC_SingleEquipList.length = 0;
         this.FCurrentSelectTreasure = null;
         this.FScroolBar.Clear();
      }
      
      protected function ResetEffect() : void
      {
         this.FEffect.gotoAndStop(1);
         this.FEffect.visible = false;
      }
      
      protected function PlayEeffct() : void
      {
         this.FEffect.play();
         this.FEffect.visible = true;
      }
      
      protected function ResetSelectedTreasureInfor() : void
      {
         this.FPreSlot.Context = null;
         this.FTFPreTreasureName.text = "";
         this.FNextSlot.Context = null;
         this.FTFNextTreasureName.text = "";
         this.FTFCurrentAttribute.text = "";
         this.FTFNextAttribute.text = "";
         this.FTFCurrentLevel.text = "";
         this.FTFNextLevel.text = "";
         this.FTFCost.text = "";
      }
      
      protected function GetApplyID(param1:TEquipment) : int
      {
         return param1.IDTemplate + param1.UpgradingLevel * 100;
      }
      
      protected function PlayEffectOver() : void
      {
         this.UpdateEquipmentInfor();
         this.FCurrentSelectTreasure = null;
         this.FNextTreasure = null;
         this.FCurrentSelectSingleEquipe = null;
         this.FBtnUpLevel.Enabled = false;
         this.ResetSelectedTreasureInfor();
         this.ResetEffect();
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
      }
      
      protected function EquipmentClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TTreasureLevelup = null;
         var _loc4_:TSingleEquip = null;
         var _loc5_:TEquipment = null;
         if(this.FCurrentSelectSingleEquipe != null)
         {
            this.FCurrentSelectSingleEquipe.BClick = false;
         }
         this.FCurrentSelectSingleEquipe = param1 as TSingleEquip;
         _loc5_ = param2 as TEquipment;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TreasureLevelup,this.GetApplyID(_loc5_)) as TTreasureLevelup;
         if(_loc3_ == null)
         {
            if(_loc5_.RequirementLevel < 3)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_32));
            }
            else if(_loc5_.RequirementLevel >= this.FTrasureMaxLevel)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_27));
            }
            else
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_31));
            }
            return;
         }
         this.FCurrentSelectTreasure = param2 as TEquipment;
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoryByIdentified(null,this.FInventoryReference,_loc3_.UpItem);
         this.FNextTreasure = this.FInventoryReference.Inventory as TEquipment;
         this.RenderSelectedTreasure(this.FCurrentSelectTreasure,this.FNextTreasure);
         this.FBtnUpLevel.Enabled = true;
      }
      
      protected function BtnBuyPaperOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
         if(this.FOnBuyPaper != null)
         {
            this.FOnBuyPaper(this);
         }
      }
      
      protected function BtnUpLevelOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureAwake_LevelUpReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FCurrentSelectTreasure.IDTemplate);
         _loc4_.writeUnsignedInt(this.FCurrentSelectTreasure.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      public function set OnBuyPaper(param1:Function) : void
      {
         this.FOnBuyPaper = param1;
      }
      
      public function UpLevelNotify() : void
      {
         this.PlayEeffct();
      }
      
      public function Show() : void
      {
         this.RenderBackPack();
         Visible = true;
      }
      
      public function Reset() : void
      {
         this.FCurrentSelectTreasure = null;
         this.FNextTreasure = null;
         this.FCurrentSelectSingleEquipe = null;
         this.FBtnUpLevel.Enabled = false;
         this.ResetBackPack();
         this.ResetEffect();
         this.ResetSelectedTreasureInfor();
      }
   }
}

