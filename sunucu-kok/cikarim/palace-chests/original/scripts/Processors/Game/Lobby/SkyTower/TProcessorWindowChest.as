package Processors.Game.Lobby.SkyTower
{
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.Inventories.TInventories;
   import Logics.SkyTower.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.SkyTower.Components.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowChest extends TProcessorLobbyWindow
   {
      
      protected static const CHEST_INTEGRALS:Vector.<uint> = Vector.<uint>([5,10,15,20,50,100,150,200,250,300,330,360]);
      
      protected var FSkyTower:TSkyTower;
      
      protected var FSP_Chest:Sprite;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FBtn_Receive:TUIButton;
      
      protected var FSP_Received:Sprite;
      
      protected var FTF_Integral:TextField;
      
      protected var FSP_Progresss:Vector.<Sprite>;
      
      protected var FUIChests:Vector.<TUIChest>;
      
      protected var FOverlayerGiftBox:TOverlayerGiftBox;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FInventories:TInventories;
      
      protected var FSelectChestID:uint;
      
      protected var FInitialization:Boolean;
      
      public function TProcessorWindowChest(param1:TUIComponent)
      {
         super(param1);
         this.FSkyTower = SLogicsCore.SkyTower;
         this.FGiftBoxTipData = new TGiftBoxTipData();
         this.FInventories = new TInventories();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SKYTOWER.RESOURCESID_Swf_SkyTower);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIChest = null;
         var _loc5_:TBins = null;
         var _loc6_:TTemplePliesNumber = null;
         this.FSP_Chest = TUtilityReflection.CreateDisplayObjectInstance(CONST_SKYTOWER.RESOURCE_ClassName_SP_Chest) as Sprite;
         addChild(this.FSP_Chest);
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FSP_Chest[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.ButtonCloseOnClick;
         this.FBtn_Receive = new TUIButton();
         this.FBtn_Receive.Substrate = this.FSP_Chest[CONST_SKYTOWER.RESOURCE_Link_Btn_Receive];
         this.FBtn_Receive.OnClick = this.Btn_ReceiveOnClick;
         this.FSP_Received = this.FSP_Chest[CONST_SKYTOWER.RESOURCE_Link_SP_Received];
         this.FTF_Integral = this.FSP_Chest[CONST_SKYTOWER.RESOURCE_Link_TF_Integral];
         _loc3_ = this.FSP_Chest[CONST_SKYTOWER.RESOURCE_Link_SP_ProgressBar];
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TemplePliesNumber);
         _loc2_ = int(CHEST_INTEGRALS.length);
         this.FSP_Progresss = new Vector.<Sprite>(_loc2_);
         this.FUIChests = new Vector.<TUIChest>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = _loc5_.GetDatebaseByIndex(_loc1_) as TTemplePliesNumber;
            this.FSP_Progresss[_loc1_] = _loc3_[CONST_SKYTOWER.RESOURCE_Link_SP_Progress + _loc1_];
            _loc4_ = new TUIChest();
            _loc4_.Resource = this.FSP_Chest[CONST_SKYTOWER.RESOURCE_Link_SP_Chests + _loc1_];
            _loc4_.Tag = _loc6_.Identifier;
            _loc4_.OnClick = this.UIChestOnClick;
            _loc4_.OnMove = this.UIChestOnMove;
            _loc4_.OnOut = this.UIChestOnOut;
            _loc4_.Perform_UIDispatch();
            this.FUIChests[_loc1_] = _loc4_;
            _loc1_++;
         }
         if(this.FOverlayerGiftBox == null)
         {
            this.FOverlayerGiftBox = new TOverlayerGiftBox(this.Parent);
            this.FOverlayerGiftBox.Visible = false;
            TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerGiftBox);
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      protected function ProcessorUpdateChest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.FSkyTower.CurIntrgral;
         this.FTF_Integral.text = _loc3_.toString();
         if(this.FSkyTower.ReceiveChestID > 0)
         {
            this.FSP_Received.visible = true;
         }
         else
         {
            this.FBtn_Receive.Visible = true;
         }
         _loc2_ = int(CHEST_INTEGRALS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc3_ >= CHEST_INTEGRALS[_loc1_])
            {
               this.FSP_Progresss[_loc1_].visible = true;
            }
            this.FUIChests[_loc1_].Context = _loc3_;
            _loc1_++;
         }
      }
      
      protected function UpdateUIChestState() : void
      {
         if(this.FSkyTower.ReceiveChestID > 0)
         {
            this.FSP_Received.visible = true;
            this.FBtn_Receive.Visible = false;
         }
         else
         {
            this.FSP_Received.visible = false;
            this.FBtn_Receive.Visible = true;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.X = (_loc1_ - this.Width) / 2 + 50;
         this.Y = (_loc2_ - this.Height) / 2;
      }
      
      protected function ButtonCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
      }
      
      protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         this.FOverlayerGiftBox.Hide();
      }
      
      protected function Btn_ReceiveOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_ReceiveChest_Req);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FSelectChestID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FBtn_Receive.Enabled = false;
      }
      
      protected function UIChestOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FSelectChestID = param2;
         _loc4_ = int(CHEST_INTEGRALS.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FUIChests[_loc3_].Selected = false;
            _loc3_++;
         }
         this.FBtn_Receive.Enabled = true;
      }
      
      protected function UIChestOnMove(param1:Object, param2:int) : void
      {
         var _loc3_:TTemplePliesNumber = null;
         if(this.FInventories.Count == 0)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TemplePliesNumber,param2) as TTemplePliesNumber;
            SToolReward.GetAwardsByAwardID(_loc3_.AwardID,this.FInventories);
            this.FGiftBoxTipData.TipReset();
            this.FGiftBoxTipData.NormalInventories = this.FInventories;
            this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
            this.FGiftBoxTipData.NeedColour = true;
            this.FOverlayerGiftBox.Context = this.FGiftBoxTipData;
         }
         this.FOverlayerGiftBox.Render(FUICore.MouseCoordinate);
         this.FOverlayerGiftBox.Show();
      }
      
      protected function UIChestOnOut(param1:Object, param2:int) : void
      {
         this.FOverlayerGiftBox.Hide();
         this.FInventories.Clear();
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.Reset();
         if(!this.FInitialization)
         {
            return;
         }
         this.FBtn_Close.Dispose();
         this.FBtn_Close = null;
         this.FBtn_Receive.Dispose();
         this.FBtn_Receive = null;
         this.FSP_Received = null;
         this.FTF_Integral = null;
         _loc2_ = int(CHEST_INTEGRALS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSP_Progresss[_loc1_] = null;
            this.FUIChests[_loc1_].Dispose();
            _loc1_++;
         }
         this.FSP_Progresss.length = 0;
         this.FUIChests.length = 0;
         if(this.FSP_Chest.parent != null)
         {
            this.FSP_Chest.parent.removeChild(this.FSP_Chest);
         }
         this.FSP_Chest = null;
         this.FInitialization = false;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FInitialization)
         {
            return;
         }
         _loc2_ = int(CHEST_INTEGRALS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSP_Progresss[_loc1_].visible = false;
            this.FUIChests[_loc1_].Context = 0;
            _loc1_++;
         }
         this.FBtn_Receive.Visible = false;
         this.FBtn_Receive.Enabled = false;
         this.FSP_Received.visible = false;
         this.FTF_Integral.text = "";
      }
      
      public function Update() : void
      {
         this.ProcessorUpdateChest();
         this.UpdateUIChestState();
         this.ProcessorResize();
      }
      
      public function UpdateChestState() : void
      {
         this.UpdateUIChestState();
      }
   }
}

