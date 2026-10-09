package Processors.Game.Lobby.TreasureMap
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
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
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Logics.TreasureMap.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.TreasureMap.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowMapSelect extends TUIComponent
   {
      
      protected static const MAX_COUNT_Map:uint = 5;
      
      protected static const MAX_COUNT_Slot:uint = 8;
      
      protected var FScene:MovieClip;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FHintBtnRefresh:THint;
      
      protected var FHint:THint;
      
      protected var FCurRefreshType:uint;
      
      protected var FCurRefreshCost:uint;
      
      protected var FOpenMapId:uint;
      
      protected var FTreasureMapData:TTreasureMapData;
      
      protected var FMaxEnterTimes:int;
      
      protected var FCostMoney:Vector.<Object>;
      
      protected var FDiggingBins:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FVipAddCountNeedGoldVect:Vector.<uint>;
      
      protected var FOverlayerTreasureMap:TOverlayerTreasureMap;
      
      protected var FBT_StarDig:TUIButton;
      
      protected var FBT_Refresh:TUIButton;
      
      protected var FBT_OpenList:Vector.<TUIButton>;
      
      protected var FSelectMonster:MovieClip;
      
      protected var FBuyMoneyBin:TBins;
      
      protected var FBAData:TBleachAgentData;
      
      protected var FOnCanDig:Function;
      
      protected var FOpenGame:Function;
      
      protected var FOnApplianceOnOver:Function;
      
      protected var FOnApplianceOnOut:Function;
      
      protected var FOnHintOnOver:Function;
      
      protected var FOnHintOnOut:Function;
      
      protected var FOnEffectText:Function;
      
      protected var FTutorialNextStep:Function;
      
      protected var FOnAwardOver:Function;
      
      protected var FOnAwardOut:Function;
      
      public function TProcessorWindowMapSelect(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:TConfigValue = null;
         super(param1);
         this.FScene = param2;
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         this.FBuyMoneyBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuyMoney);
         this.FUISlots = new Vector.<TUISlot>(MAX_COUNT_Slot);
         this.FIDTemplates = new Vector.<uint>(MAX_COUNT_Slot);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FHintBtnRefresh = new THint();
         this.FHint = new THint();
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_FreeQuency) as TConfigValue;
         this.FMaxEnterTimes = int(_loc3_.Value);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_RefreshCost) as TConfigValue;
         this.FCostMoney = Vector.<Object>(_loc3_.Value);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_Time_Gold) as TConfigValue;
         this.FVipAddCountNeedGoldVect = _loc3_.Value as Vector.<uint>;
         this.FOverlayerTreasureMap = new TOverlayerTreasureMap(this.Parent);
         this.FOverlayerTreasureMap.Visible = false;
         this.FBT_OpenList = new Vector.<TUIButton>(MAX_COUNT_Map);
         this.InitWindowMapSelect();
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      protected function GetSlot() : TUISlot
      {
         var _loc1_:TUISlot = null;
         _loc1_ = new TUISlot(this);
         _loc1_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         return _loc1_;
      }
      
      protected function InitWindowMapSelect() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:TDigging = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TextFormat = new TextFormat();
         this.FScene.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnClose);
         this.FBT_StarDig = new TUIButton();
         this.FBT_StarDig.Substrate = this.FScene.btn_start;
         this.FBT_StarDig.OnClick = this.OnStartDig;
         this.FBT_Refresh = new TUIButton();
         this.FBT_Refresh.Substrate = this.FScene.btn_refresh;
         this.FBT_Refresh.OnClick = this.OnRefreshMap;
         this.FBT_Refresh.OnMove = this.OnRefreshMapMouseMove;
         this.FBT_Refresh.OnOut = this.OnRefreshMapMouseOut;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT_Map)
         {
            _loc5_ = new TUIButton();
            _loc5_.Substrate = this.FScene["mc_map_" + _loc1_].mc_open.btn_open;
            _loc5_.OnClick = this.OnOpenMap;
            this.FBT_OpenList[_loc1_] = _loc5_;
            this.FScene["mc_map_" + _loc1_].addEventListener(MouseEvent.MOUSE_MOVE,this.OnMapMove);
            this.FScene["mc_map_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.OnMapOut);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT_Slot)
         {
            _loc4_ = this.GetSlot();
            _loc4_.Resource = this.FScene["mc_slot_" + _loc1_];
            _loc4_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc4_.Init();
            _loc4_.OnOver = this.ApplianceOnOver;
            _loc4_.OnOut = this.ApplianceOnOut;
            this.FUISlots[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIWindowConfirmation = new TUIWindowConfirmation(this);
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         this.FUIWindowConfirmation.SetCheckBoxUsable(true);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         _loc6_.underline = true;
         TextField(this.FScene.TF_AddHuntingCount).addEventListener(MouseEvent.MOUSE_MOVE,this.OnAddHuntingCountOver);
         TextField(this.FScene.TF_AddHuntingCount).addEventListener(MouseEvent.MOUSE_OUT,this.OnAddHuntingCountOut);
         TextField(this.FScene.TF_AddHuntingCount).addEventListener(MouseEvent.CLICK,this.OnAddHuntingCountClick);
         TextField(this.FScene.TF_AddHuntingCount).setTextFormat(_loc6_);
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerTreasureMap);
      }
      
      protected function GetItemStr(param1:int, param2:int, param3:int) : String
      {
         return param3 + TUtilityLobby.GetItemName(param1,param2);
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TDigging = null;
         var _loc3_:TDigging = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:MovieClip = null;
         var _loc9_:TBuyMoney = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:Vector.<Object> = null;
         var _loc13_:uint = 0;
         _loc4_ = 0;
         _loc3_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapData.CurQuality) as TDigging;
         _loc10_ = this.FCharacter.GetMainRebirthLevel();
         _loc9_ = this.FBuyMoneyBin.GetDatebaseByIdentifier(_loc10_) as TBuyMoney;
         _loc11_ = "";
         if(_loc3_ != null)
         {
            _loc4_ = int(_loc3_.Rate);
         }
         if(_loc4_ != 0 && !this.FTreasureMapData.TreasureStatus)
         {
            this.FBT_StarDig.Enabled = true;
         }
         else
         {
            this.FBT_StarDig.Enabled = false;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT_Map)
         {
            this.FScene["mc_map_" + _loc1_].gotoAndStop(_loc4_ == _loc1_ + 1 ? 2 : 1);
            _loc8_ = this.FScene["mc_map_" + _loc1_].mc_name;
            _loc8_.gotoAndStop(_loc1_ + 1);
            _loc8_.MC_Monster.play();
            _loc2_ = this.FDiggingBins.GetDatebaseByIndex(_loc1_) as TDigging;
            if(_loc2_.Isgold)
            {
               this.FScene["mc_map_" + _loc1_].mc_open.visible = true;
               if(_loc2_.Rate > _loc4_)
               {
                  if(this.FVipData.Digging)
                  {
                     this.FScene["mc_map_" + _loc1_].mc_open.btn_open.visible = true;
                     this.FScene["mc_map_" + _loc1_].mc_open.tf_openTips.visible = false;
                     this.FBT_OpenList[_loc1_].Enabled = true;
                  }
                  else
                  {
                     this.FBT_OpenList[_loc1_].Visible = false;
                     this.FScene["mc_map_" + _loc1_].mc_open.tf_openTips.visible = true;
                     _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_07);
                     _loc7_ = _loc7_.split("%count%").join(_loc2_.Viplevel);
                     this.FScene["mc_map_" + _loc1_].mc_open.tf_openTips.text = _loc7_;
                  }
               }
               else if(this.FVipData.Digging)
               {
                  this.FBT_OpenList[_loc1_].Visible = true;
                  this.FScene["mc_map_" + _loc1_].mc_open.tf_openTips.visible = false;
                  this.FBT_OpenList[_loc1_].Enabled = false;
               }
               else
               {
                  this.FBT_OpenList[_loc1_].Visible = false;
                  this.FScene["mc_map_" + _loc1_].mc_open.tf_openTips.visible = true;
                  _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_07);
                  _loc7_ = _loc7_.split("%count%").join(_loc2_.Viplevel);
                  this.FScene["mc_map_" + _loc1_].mc_open.tf_openTips.text = _loc7_;
               }
            }
            else
            {
               this.FScene["mc_map_" + _loc1_].mc_open.visible = false;
            }
            _loc1_++;
         }
         if(_loc3_ != null)
         {
            this.FScene.tf_reward1.text = _loc9_.Money * _loc3_.SilverNum1 / 100 + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
            _loc12_ = _loc3_.Award1Vect;
            _loc13_ = _loc12_.length;
            _loc1_ = 0;
            while(_loc1_ < _loc13_)
            {
               _loc11_ += _loc12_[_loc1_].amount + TUtilityLobby.GetItemName(_loc12_[_loc1_].type,_loc12_[_loc1_].code);
               _loc11_ += " ";
               _loc1_++;
            }
            this.FScene.tf_reward2.text = _loc11_;
            this.FScene.tf_costTime.text = _loc3_.Digtime / 60 + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TYPE_TIME_Minute);
            this.FIDTemplates.length = 0;
            _loc1_ = 0;
            while(_loc1_ < MAX_COUNT_Slot)
            {
               if(_loc1_ < _loc3_.Award2Vect.length)
               {
                  this.FScene["mc_slot_" + _loc1_].visible = true;
                  this.FIDTemplates.push(_loc3_.Award2Vect[_loc1_].code);
               }
               else
               {
                  this.FScene["mc_slot_" + _loc1_].visible = false;
               }
               _loc1_++;
            }
            this.FInventories.Clear();
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
            _loc1_ = 0;
            while(_loc1_ < this.FInventories.Count)
            {
               this.FUISlots[_loc1_].Context = this.FInventories.GetInventoryByIndex(_loc1_);
               this.FScene["mc_slot_" + _loc1_].TF_Subscript.visible = true;
               this.FScene["mc_slot_" + _loc1_].TF_Subscript.text = _loc3_.Award2Vect[_loc1_].amount;
               _loc1_++;
            }
         }
         else
         {
            this.FScene.tf_reward1.text = "";
            this.FScene.tf_reward2.text = "";
            this.FScene.tf_costTime.text = "";
            _loc1_ = 0;
            while(_loc1_ < MAX_COUNT_Slot)
            {
               this.FScene["mc_slot_" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         _loc5_ = uint(this.FCostMoney[0].times);
         _loc6_ = uint(this.FCostMoney[1].times);
         this.FBT_Refresh.Enabled = true;
         if(this.FTreasureMapData.CurRefreshTimes < _loc5_)
         {
            this.FCurRefreshType = this.FCostMoney[0].code;
            this.FCurRefreshCost = this.FCostMoney[0].amount;
            this.FScene.TF_RefreshCount.text = this.FTreasureMapData.CurRefreshTimes + "/" + _loc5_;
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_14);
            _loc7_ = _loc7_.split("%Type%").join(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin));
            this.FScene.TF_RefreshType.text = _loc7_;
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_15);
            _loc7_ = _loc7_.split("%Count%").join(this.FCurRefreshCost);
            _loc7_ = _loc7_.split("%Type%").join(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin));
            this.FScene.TF_RefreshCost.text = _loc7_;
            this.FHintBtnRefresh.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_03).split("%count%").join(this.FCurRefreshCost);
         }
         else if(this.FTreasureMapData.CurRefreshTimes < _loc5_ + _loc6_)
         {
            this.FCurRefreshType = this.FCostMoney[1].code;
            this.FCurRefreshCost = this.FCostMoney[1].amount;
            this.FScene.TF_RefreshCount.text = this.FTreasureMapData.CurRefreshTimes - _loc5_ + "/" + _loc6_;
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_14);
            _loc7_ = _loc7_.split("%Type%").join(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Gold));
            this.FScene.TF_RefreshType.text = _loc7_;
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_15);
            _loc7_ = _loc7_.split("%Count%").join(this.FCurRefreshCost);
            _loc7_ = _loc7_.split("%Type%").join(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Gold));
            this.FScene.TF_RefreshCost.text = _loc7_;
            this.FHintBtnRefresh.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_04).split("%count%").join(this.FCurRefreshCost);
         }
         else
         {
            this.FScene.TF_RefreshCount.text = this.FTreasureMapData.CurRefreshTimes - _loc5_ + "/" + _loc6_;
            this.FBT_Refresh.Enabled = false;
            this.FHintBtnRefresh.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_16);
         }
         if(_loc4_ >= MAX_COUNT_Map)
         {
            this.FBT_Refresh.Enabled = false;
            this.FHintBtnRefresh.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_17);
         }
         this.FScene.TF_HuntingCount.text = this.FTreasureMapData.TreasureTimes.toString();
         this.FSelectMonster = this.FScene.MC_SelectMap;
         if(_loc3_ != null)
         {
            this.FSelectMonster.gotoAndStop(_loc4_);
            this.FScene.TF_Name.text = _loc3_.Name.toString();
         }
         else
         {
            this.FSelectMonster.gotoAndStop(1);
            this.FScene.TF_Name.text = "";
         }
         this.FSelectMonster.MC_Monster.play();
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
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function ApplianceOnOver(param1:Object, param2:Object) : void
      {
         if(this.FOnApplianceOnOver != null)
         {
            this.FOnApplianceOnOver(param1,param2);
         }
      }
      
      protected function ApplianceOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnApplianceOnOut != null)
         {
            this.FOnApplianceOnOut(param1,param2);
         }
      }
      
      protected function OnRefreshMapSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         if(TProcessorTreasureMap.SoulBusy)
         {
            return;
         }
         TProcessorTreasureMap.SoulBusy = true;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_RefreshReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FBT_Refresh.Enabled = false;
      }
      
      protected function OnAddCountSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_VipAddTimesReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OnOpenMapSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         if(TProcessorTreasureMap.SoulBusy)
         {
            return;
         }
         TProcessorTreasureMap.SoulBusy = true;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_OpenMapReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeInt(this.FOpenMapId);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OnClose(param1:MouseEvent = null) : void
      {
         this.Visible = false;
      }
      
      protected function OnStartDig(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(this.FTutorialNextStep != null)
         {
            this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartFindTreasureMap);
         }
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FOnCanDig != null)
         {
            if(!this.FOnCanDig())
            {
               return;
            }
         }
         if(TProcessorTreasureMap.SoulBusy)
         {
            return;
         }
         TProcessorTreasureMap.SoulBusy = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_StartReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.OnClose();
      }
      
      protected function OnRefreshMap(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         if(this.FTutorialNextStep != null)
         {
            this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickRefreshTreasureMap);
         }
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FCurRefreshType == 0)
         {
            if(this.FCharacter.CreditSilverCoin.ToNumber() < this.FCurRefreshCost)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Coin));
               return;
            }
         }
         else if(this.FCurRefreshType == 2)
         {
            if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < this.FCurRefreshCost)
            {
               this.FUIWindowRecharge.SetGoldNum(this.FCurRefreshCost);
               this.FUIWindowRecharge.Visible = true;
               return;
            }
         }
         if(this.FCurRefreshType == 2)
         {
            if(!this.FUIWindowConfirmation.IsSelected)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_10);
               _loc3_ = _loc3_.split("%count%").join(this.FCurRefreshCost);
               this.FUIWindowConfirmation.Text = _loc3_;
               this.FUIWindowConfirmation.OnOK = this.OnRefreshMapSure;
               this.FUIWindowConfirmation.visible = true;
            }
            else
            {
               this.OnRefreshMapSure(this);
            }
         }
         else
         {
            this.OnRefreshMapSure(this);
         }
      }
      
      protected function OnRefreshMapMouseMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHintOnOver != null)
         {
            this.FOnHintOnOver(this,this.FHintBtnRefresh);
         }
      }
      
      protected function OnRefreshMapMouseOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHintOnOut != null)
         {
            this.FOnHintOnOut(this,this.FHintBtnRefresh);
         }
      }
      
      protected function OnOpenMap(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:uint = 0;
         var _loc5_:TDigging = null;
         var _loc6_:String = null;
         var _loc7_:TUIButton = null;
         _loc7_ = param1 as TUIButton;
         if(Boolean(_loc7_) && !_loc7_.Enabled)
         {
            return;
         }
         _loc4_ = this.FBT_OpenList.indexOf(_loc7_);
         _loc5_ = this.FDiggingBins.GetDatebaseByIndex(_loc4_) as TDigging;
         if(!_loc5_.Isgold)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_08));
            }
            return;
         }
         if(this.FVipData.VipLevel < _loc5_.Viplevel)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Vip));
            }
            return;
         }
         if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DiggingFreeCount) > 0)
         {
            if(_loc5_ == null)
            {
               return;
            }
            this.FOpenMapId = _loc5_.Identifier;
            this.OnOpenMapSure(this);
            return;
         }
         if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc5_.OpenCost[0].amount)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc5_.OpenCost[0].amount);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         if(this.FUIWindowConfirmation.IsSelected)
         {
            if(_loc5_ == null)
            {
               return;
            }
            this.FOpenMapId = _loc5_.Identifier;
            this.OnOpenMapSure(this);
         }
         else
         {
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_11);
            _loc6_ = _loc6_.split("%count%").join(_loc5_.OpenCost[0].amount);
            _loc6_ = _loc6_.split("%name%").join(_loc5_.Name);
            _loc6_ = _loc6_.split("%itemname%").join(_loc5_.Name);
            this.FOpenMapId = _loc5_.Identifier;
            this.FUIWindowConfirmation.Text = _loc6_;
            this.FUIWindowConfirmation.OnOK = this.OnOpenMapSure;
            this.FUIWindowConfirmation.visible = true;
         }
      }
      
      protected function OnAddHuntingCountOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:TVipConfig = null;
         var _loc4_:TVip = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_18);
         _loc2_ = _loc2_.split("%count0%").join(this.FVipData.DayBuyCount - this.FTreasureMapData.VipBuyCount);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VipConfig,this.FVipData.VipLevel + 1) as TVipConfig;
         if(_loc3_ == null)
         {
            _loc2_ = _loc2_.split("%count1%").join(this.FVipData.DayBuyCount);
         }
         else
         {
            _loc2_ = _loc2_.split("%count1%").join(_loc3_.DayBuyCount);
         }
         this.FHint.Caption = _loc2_;
         if(this.FOnHintOnOver != null)
         {
            this.FOnHintOnOver(this,this.FHint);
         }
      }
      
      protected function OnAddHuntingCountOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOnOut != null)
         {
            this.FOnHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnAddHuntingCountClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc2_ = this.FVipData.DayBuyCount - this.FTreasureMapData.VipBuyCount;
         if(_loc2_ > 0)
         {
            if(!this.FUIWindowConfirmation.IsSelected)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_09);
               _loc3_ = _loc3_.split("%count%").join(this.FVipAddCountNeedGoldVect[this.FTreasureMapData.VipBuyCount]);
               this.FUIWindowConfirmation.Text = _loc3_;
               this.FUIWindowConfirmation.OnOK = this.OnAddCountSure;
               this.FUIWindowConfirmation.visible = true;
            }
            else
            {
               this.OnAddCountSure(this);
            }
         }
         else if(this.FOnEffectText != null)
         {
            this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_41));
         }
      }
      
      protected function OnMapMove(param1:MouseEvent) : void
      {
         this.FOverlayerTreasureMap.Context = null;
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = int(_loc2_.slice(-1));
         if(this.FOnAwardOver != null)
         {
            this.FOnAwardOver(this,this.FDiggingBins.GetDatebaseByIndex(_loc3_));
         }
      }
      
      protected function OnMapOut(param1:MouseEvent) : void
      {
         if(this.FOnAwardOut != null)
         {
            this.FOnAwardOut(this);
         }
      }
      
      override public function get Visible() : Boolean
      {
         if(this.FScene == null)
         {
            return false;
         }
         return this.FScene.visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FScene.visible = param1;
         if(Boolean(this.FTreasureMapData) && this.FTreasureMapData.TreasureStatus)
         {
            this.FBT_StarDig.Enabled = false;
            this.FBT_Refresh.Enabled = false;
         }
      }
      
      public function get OnCanDig() : Function
      {
         return this.FOnCanDig;
      }
      
      public function set OnCanDig(param1:Function) : void
      {
         this.FOnCanDig = param1;
      }
      
      public function get OpenGame() : Function
      {
         return this.FOpenGame;
      }
      
      public function set OpenGame(param1:Function) : void
      {
         this.FOpenGame = param1;
      }
      
      public function get OnApplianceOnOver() : Function
      {
         return this.FOnApplianceOnOver;
      }
      
      public function set OnApplianceOnOver(param1:Function) : void
      {
         this.FOnApplianceOnOver = param1;
      }
      
      public function get OnApplianceOnOut() : Function
      {
         return this.FOnApplianceOnOut;
      }
      
      public function set OnApplianceOnOut(param1:Function) : void
      {
         this.FOnApplianceOnOut = param1;
      }
      
      public function get OnHintOnOver() : Function
      {
         return this.FOnHintOnOver;
      }
      
      public function set OnHintOnOver(param1:Function) : void
      {
         this.FOnHintOnOver = param1;
      }
      
      public function get OnHintOnOut() : Function
      {
         return this.FOnHintOnOut;
      }
      
      public function set OnHintOnOut(param1:Function) : void
      {
         this.FOnHintOnOut = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function set TutorialNextStep(param1:Function) : void
      {
         this.FTutorialNextStep = param1;
      }
      
      public function get OnAwardOver() : Function
      {
         return this.FOnAwardOver;
      }
      
      public function set OnAwardOver(param1:Function) : void
      {
         this.FOnAwardOver = param1;
      }
      
      public function get OnAwardOut() : Function
      {
         return this.FOnAwardOut;
      }
      
      public function set OnAwardOut(param1:Function) : void
      {
         this.FOnAwardOut = param1;
      }
      
      public function SetTreasureMapData(param1:TTreasureMapData) : void
      {
         this.FTreasureMapData = param1;
         this.UpdataUI();
      }
      
      public function UpdataBitmp() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FUISlots.length)
         {
            this.FUISlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUISlots.length)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT_Map)
         {
            _loc2_ = this.FScene["mc_map_" + _loc1_].mc_name;
            _loc2_.gotoAndStop(_loc1_ + 1);
            _loc2_.MC_Monster.stop();
            _loc1_++;
         }
         if(this.FSelectMonster)
         {
            this.FSelectMonster.MC_Monster.stop();
         }
      }
      
      public function SetRefreshBt(param1:Boolean) : void
      {
         if(param1)
         {
            this.FBT_Refresh.Enabled = true;
         }
         else
         {
            this.FBT_Refresh.Enabled = false;
         }
      }
   }
}

