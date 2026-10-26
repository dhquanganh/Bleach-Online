package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.KnifeOfKillSoul.TKnifeLanguage;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorKnifeStrengthenBox extends TProcessorLobbyWindow
   {
      
      protected const WarnColor:uint = 16711680;
      
      protected var FMainUI:MovieClip;
      
      protected var FMask:Bitmap;
      
      protected var FData:TKnifeStrengthenAdd;
      
      protected var FIndex:uint;
      
      protected var FKnifeID:uint;
      
      protected var FStrengthenBtn:TUIButton;
      
      protected var FInventory:TInventory;
      
      protected var FHint:THint;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FDefaultColor:uint;
      
      protected var FKnifeLanguage:TKnifeLanguage;
      
      public function TProcessorKnifeStrengthenBox(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function GetQuantity() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventory = null;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc4_ = 0;
         _loc5_ = SLogicsCore.Character.Appliances;
         _loc2_ = uint(_loc5_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc5_.GetInventoryByIndex(_loc1_);
            if(_loc3_.IDTemplate == this.FInventory.IDTemplate)
            {
               _loc4_ += _loc3_.Quantity;
            }
            _loc1_++;
         }
         _loc5_ = SLogicsCore.Character.TemporaryInventories;
         _loc2_ = uint(_loc5_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc5_.GetInventoryByIndex(_loc1_);
            if(_loc3_.IDTemplate == this.FInventory.IDTemplate)
            {
               _loc4_ += _loc3_.Quantity;
            }
            _loc1_++;
         }
         return _loc4_;
      }
      
      protected function OnCloseClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnStrengthenBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(this.FData.IsMax)
         {
            SToolReward.ShowMessage(this.FKnifeLanguage.GetStr2());
            return;
         }
         if(this.FData.IsNodeLevel)
         {
            SToolReward.ShowMessage(this.FKnifeLanguage.GetStr14());
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeStrengReq);
         _loc3_.Data.writeInt(this.FKnifeID);
         _loc3_.Data.writeInt(this.FIndex);
         _loc3_.Data.writeInt(this.FData.UpExp);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.UpdateUI();
      }
      
      public function set KnifeLanguage(param1:TKnifeLanguage) : void
      {
         this.FKnifeLanguage = param1;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         this.FMainUI.MC_CurAtt.TF_Level.text = this.FKnifeLanguage.GetStr1(this.FData.Level);
         this.FMainUI.MC_CurAtt.TF_Att.text = TUtilityLobby.GetAttributeName(this.FData.Type) + "+" + this.FData.Value;
         _loc3_ = this.FData.IsMax ? this.FData.Level : uint(this.FData.Level + 1);
         this.FMainUI.MC_NextAtt.TF_Level.text = this.FKnifeLanguage.GetStr1(_loc3_);
         this.FMainUI.MC_NextAtt.TF_Att.text = TUtilityLobby.GetAttributeName(this.FData.Type) + "+" + (this.FData.BaseValue + _loc3_ * this.FData.UpAddValue);
         _loc1_ = this.FData.UpExp;
         _loc2_ = this.GetQuantity();
         this.FMainUI.TF_Need.text = this.FInventory.Name + "x" + _loc1_;
         this.FMainUI.TF_Have.text = this.FInventory.Name + "x" + _loc2_;
         this.FMainUI.TF_Have.textColor = _loc2_ >= _loc1_ ? this.FDefaultColor : this.WarnColor;
         this.FStrengthenBtn.Enabled = _loc2_ >= _loc1_;
      }
      
      public function SetData(param1:TKnifeStrengthenAdd, param2:uint, param3:uint) : void
      {
         this.FData = param1;
         this.FKnifeID = param2;
         this.FIndex = param3;
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_KnifeStrengthenBox") as MovieClip;
         this.FMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(this.FMask);
         addChild(this.FMainUI);
         this.FMainUI.x = (this.FMask.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (this.FMask.height - this.FMainUI.height) / 2;
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.Btn_Close;
         this.FCloseBtn.OnClick = this.OnCloseClick;
         this.FHint = new THint();
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongFossilID) as TConfigValue;
         _loc3_ = uint(int(_loc2_.Value));
         _loc4_ = new TInventories();
         SToolReward.GetInventoryByID(_loc3_,_loc4_);
         this.FInventory = _loc4_.GetInventoryByIndex(0);
         this.FStrengthenBtn = new TUIButton();
         this.FStrengthenBtn.Substrate = this.FMainUI.Btn_Strengthen;
         this.FStrengthenBtn.OnClick = this.OnStrengthenBtnClick;
         this.FDefaultColor = this.FDefaultColor = this.FMainUI.TF_Have.textColor;
      }
   }
}

