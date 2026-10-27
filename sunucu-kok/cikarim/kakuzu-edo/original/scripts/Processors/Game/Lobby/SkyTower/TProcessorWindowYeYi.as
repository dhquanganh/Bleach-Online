package Processors.Game.Lobby.SkyTower
{
   import Components.Drops.*;
   import Components.Lists.*;
   import Components.Lists.Data.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.SkyTower.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowYeYi extends TProcessorLobbyWindow
   {
      
      protected var FSkyTower:TSkyTower;
      
      protected var FSP_YeYi:Sprite;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FUIDropList:TUIDropList;
      
      protected var FUIList:TUIList;
      
      protected var FTF_Price:TextField;
      
      protected var FTF_Reward:TextField;
      
      protected var FBtn_AKeyPve:TUIButton;
      
      protected var FInitialization:Boolean;
      
      public function TProcessorWindowYeYi(param1:TUIComponent)
      {
         super(param1);
         this.FSkyTower = SLogicsCore.SkyTower;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SKYTOWER.RESOURCESID_Swf_SkyTower);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         this.FSP_YeYi = TUtilityReflection.CreateDisplayObjectInstance(CONST_SKYTOWER.RESOURCE_ClassName_SP_AKeyPve) as Sprite;
         addChild(this.FSP_YeYi);
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FSP_YeYi[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.ButtonCloseOnClick;
         this.FTF_Price = this.FSP_YeYi[CONST_SKYTOWER.RESOURCE_Link_TF_Price];
         this.FTF_Reward = this.FSP_YeYi[CONST_SKYTOWER.RESOURCE_Link_TF_Reward];
         this.FBtn_AKeyPve = new TUIButton();
         this.FBtn_AKeyPve.Substrate = this.FSP_YeYi[CONST_SKYTOWER.RESOURCE_Link_Btn_AKeyPve];
         this.FBtn_AKeyPve.OnClick = this.Btn_AKeyPveOnClick;
         this.FUIDropList = new TUIDropList(this);
         this.FUIDropList.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_SP_Drop + CONST_SKYTOWER.RESOURCE_Link_DropList_Suffix) as Sprite;
         this.FUIDropList.OnClick = this.UIDropListOnClick;
         _loc1_ = this.FSP_YeYi[CONST_COMMON.RESOURCE_Link_SP_DropList];
         _loc1_.addChild(this.FUIDropList);
         this.FUIList = this.FUIDropList.UIList;
         this.FUIList.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_SP_ListPanel + CONST_SKYTOWER.RESOURCE_Link_DropList_Suffix) as Sprite;
         this.FUIList.ScrollBarResource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_SP_ScrollBar + CONST_SKYTOWER.RESOURCE_Link_DropList_Suffix) as Sprite;
         this.FUIList.ScrollBar.Zoom9GridX = 3;
         this.FUIList.ScrollBar.Zoom9GridY = 6;
         this.FUIList.ScrollBar.Zoom9GridWidth = 2;
         this.FUIList.ScrollBar.Zoom9GridHeigh = 1;
         this.FUIDropList.Perform_UIDispatch();
         this.FUIList.EvaluateBoundScreen();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               this.FUIDropList.UIList.RenderingPerform();
            }
         }
      }
      
      protected function ProcessorUpdateReward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTower = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc2_ = this.FSkyTower.Towers.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FSkyTower.Towers.GetTowerByIndex(_loc1_);
            if(_loc3_.Identifier == this.FSkyTower.SelectTowerID)
            {
               break;
            }
            _loc1_++;
         }
         _loc4_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_07)[_loc1_];
         _loc5_ = _loc4_.split("#");
         _loc4_ = "";
         _loc2_ = int(_loc5_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ != 0)
            {
               _loc4_ += "\n";
            }
            _loc4_ += String(_loc5_[_loc1_]);
            _loc1_++;
         }
         this.FTF_Reward.text = _loc4_;
      }
      
      protected function ProcessorUpdateLayerList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TListItemText = null;
         var _loc4_:TTower = null;
         var _loc5_:TLayer = null;
         _loc4_ = this.FSkyTower.Towers.GetTowerByIdentifier(this.FSkyTower.SelectTowerID);
         _loc2_ = _loc4_.Layers.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.Layers.GetLayerByIndex(_loc1_);
            if(!_loc5_.IsClear)
            {
               break;
            }
            _loc3_ = new TListItemText(null);
            _loc3_.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_MC_ListItem + CONST_SKYTOWER.RESOURCE_Link_DropList_Suffix) as MovieClip;
            _loc3_.Perform_UIDispatch();
            _loc3_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_24),_loc1_ + 1);
            _loc3_.Tag = _loc1_;
            this.FUIList.Add(_loc3_);
            _loc1_++;
         }
         if(this.FUIList.Count > 0)
         {
            this.FUIDropList.ItemIndex = this.FUIList.Count - 1;
            this.UIDropListOnClick(this,this.FUIList.Count - 1);
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
      
      protected function Btn_AKeyPveOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = 0;
         var _loc6_:TTower = null;
         var _loc7_:TLayer = null;
         if(this.FUIList.Count == 0)
         {
            return;
         }
         _loc6_ = this.FSkyTower.Towers.GetTowerByIdentifier(this.FSkyTower.SelectTowerID);
         _loc7_ = _loc6_.Layers.GetLayerByIndex(_loc6_.Layers.Count - 1);
         if(this.FUIDropList.ItemIndex == _loc6_.Layers.Count - 1 && _loc7_.IsClear)
         {
            _loc5_ = int(CONST_SKYTOWER.MAX_Layer);
         }
         else
         {
            _loc5_ = this.FUIDropList.ItemIndex;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_AKeyPve_Req);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(_loc5_);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FBtn_AKeyPve.Enabled = false;
      }
      
      protected function UIDropListOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TTower = null;
         var _loc5_:TLayer = null;
         _loc3_ = this.FUIList.GetItemByIndex(param2).Tag;
         _loc4_ = this.FSkyTower.Towers.GetTowerByIdentifier(this.FSkyTower.SelectTowerID);
         _loc5_ = _loc4_.Layers.GetLayerByIndex(_loc3_);
         this.FTF_Price.text = _loc5_.AkeyPrice.toString();
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         this.Reset();
         if(!this.FInitialization)
         {
            return;
         }
         this.FBtn_Close.Dispose();
         this.FBtn_Close = null;
         this.FTF_Price = null;
         this.FTF_Reward = null;
         this.FBtn_AKeyPve.Dispose();
         this.FBtn_AKeyPve = null;
         this.FUIList = null;
         this.FUIDropList.Dispose();
         this.FUIDropList = null;
         if(this.FSP_YeYi.parent != null)
         {
            this.FSP_YeYi.parent.removeChild(this.FSP_YeYi);
         }
         this.FSP_YeYi = null;
         this.FInitialization = false;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FUIList.Clear();
         this.FTF_Price.text = "";
         this.FTF_Reward.text = "";
      }
      
      public function Update() : void
      {
         this.ProcessorUpdateLayerList();
         this.ProcessorUpdateReward();
         this.FBtn_AKeyPve.Enabled = this.FSkyTower.IsAKeyPve;
         this.ProcessorResize();
      }
   }
}

