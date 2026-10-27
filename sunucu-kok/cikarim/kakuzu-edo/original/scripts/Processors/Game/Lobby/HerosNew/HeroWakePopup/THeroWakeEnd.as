package Processors.Game.Lobby.HerosNew.HeroWakePopup
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TCity;
   import Logics.DatebaseVO.VO.TOrgPointInfo;
   import Logics.DatebaseVO.VO.TWakeUpEquip;
   import Logics.HeroNew.TWakeSource;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventoryWake;
   import Logics.Organization.VO.TOrgCopyVO;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ORGANIZATION;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class THeroWakeEnd extends THeroWakeBase
   {
      
      protected const Path_Split_Str:String = "> ";
      
      protected const Color_Gray:String = "#CCCCCC";
      
      protected const Color_Green:String = "#00FF00";
      
      protected var FBtnBack:TUIButton;
      
      protected var FSlotEnd:TUISlot;
      
      protected var FTxtPath:TextField;
      
      protected var FTxtSource:TextField;
      
      protected var FCityBins:TBins;
      
      protected var FOrgPointInfoBins:TBins;
      
      protected var FOnHyperlink:Function;
      
      protected var FOrgSingles:Vector.<TOrgCopyVO>;
      
      protected var FOrgGroups:Vector.<TOrgCopyVO>;
      
      public function THeroWakeEnd(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroWakePan_2") as Sprite;
         addChild(FMainUI);
         FBtnClose = new TUIButton();
         FBtnClose.Substrate = FMainUI["Btn_Close"];
         FBtnClose.OnClick = BtnCloseOnClick;
         this.FBtnBack = new TUIButton();
         this.FBtnBack.Substrate = FMainUI["Btn_Back"];
         this.FBtnBack.OnClick = BtnCloseOnClick;
         this.FSlotEnd = new TUISlot(this);
         this.FSlotEnd.Resource = FMainUI["MC_Slot"];
         this.FSlotEnd.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotEnd.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlotEnd);
         this.FSlotEnd.OnQuerySubscript = null;
         this.FSlotEnd.Init();
         this.FTxtPath = FMainUI["Txt_Path"];
         this.FTxtSource = FMainUI["Txt_Path_Source"];
         this.FTxtSource.addEventListener(TextEvent.LINK,this.SourceOnLink);
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FOrgPointInfoBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo);
      }
      
      protected function SourceOnLink(param1:TextEvent) : void
      {
         var _loc2_:Array = null;
         _loc2_ = param1.text.split("_");
         if(_loc2_[1] == "1")
         {
            if(this.FOnHyperlink != null)
            {
               this.FOnHyperlink(this);
            }
            SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Organization,CONST_ORGANIZATION.ORGANIZATION_PAGE_CITY,int(_loc2_[0]));
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_59);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.FSlotEnd.Update();
      }
      
      protected function GetPointStatus(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FOrgSingles.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FOrgSingles[_loc2_].City.Identifier == param1)
            {
               return this.FOrgSingles[_loc2_].Open;
            }
            _loc2_++;
         }
         _loc3_ = int(this.FOrgGroups.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FOrgGroups[_loc2_].City.Identifier == param1)
            {
               return this.FOrgGroups[_loc2_].Open;
            }
            _loc2_++;
         }
         return false;
      }
      
      protected function SendSever(param1:Boolean = true) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:uint = 0;
         if(param1)
         {
            _loc3_ = CONST_NETWORK.PACKETID_CS_Organization_SingleInitReq;
         }
         else
         {
            _loc3_ = CONST_NETWORK.PACKETID_CS_Organization_GroupInitReq;
         }
         _loc2_ = SNetworkCore.PacketAcquire(_loc3_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function SetWakePath() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:TWakeUpEquip = null;
         var _loc7_:TInventories = null;
         var _loc8_:TInventoryWake = null;
         var _loc9_:TWakeSource = null;
         var _loc10_:TCity = null;
         var _loc11_:TOrgPointInfo = null;
         var _loc12_:String = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         _loc7_ = new TInventories();
         _loc2_ = FParentNames ? int(FParentNames.length) : 0;
         _loc3_ = "";
         _loc4_ = "";
         _loc5_ = "";
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ += _loc4_ + this.Path_Split_Str + FParentNames[_loc1_] + "\n";
            _loc4_ += "   ";
            _loc1_++;
         }
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,FWakeIdentifier) as TWakeUpEquip;
         SToolReward.GetInventoryByID(FWakeIdentifier,_loc7_);
         _loc8_ = _loc7_.GetInventoryByTempletID(FWakeIdentifier) as TInventoryWake;
         FPathName = _loc8_.Name;
         _loc3_ += _loc4_ + this.Path_Split_Str + FPathName;
         this.FTxtPath.text = _loc3_;
         this.FSlotEnd.Context = _loc8_;
         _loc2_ = _loc6_.SourceCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc9_ = _loc6_.GetSourceByIndex(_loc1_);
            _loc10_ = this.FCityBins.GetDatebaseByIdentifier(_loc9_.CityId) as TCity;
            _loc13_ = this.GetPointStatus(_loc9_.CityId);
            if(_loc13_)
            {
               _loc12_ = this.Color_Green;
               _loc14_ = 1;
            }
            else
            {
               _loc12_ = this.Color_Gray;
               _loc14_ = 0;
            }
            _loc11_ = this.FOrgPointInfoBins.GetDatebaseByIdentifier(_loc9_.PointId) as TOrgPointInfo;
            _loc5_ += "<font color=\'" + _loc12_ + "\'><u><a href=\'event:" + _loc9_.CityId + "_" + _loc14_ + "\'>" + _loc10_.Name + "-" + _loc11_.Name + "</a></u></font><br>";
            _loc1_++;
         }
         this.FTxtSource.htmlText = _loc5_;
         this.Visible = true;
      }
      
      public function get OnHyperlink() : Function
      {
         return this.FOnHyperlink;
      }
      
      public function set OnHyperlink(param1:Function) : void
      {
         this.FOnHyperlink = param1;
      }
      
      public function UpdateOrganizationData(param1:Object, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.FOrgSingles = param1 as Vector.<TOrgCopyVO>;
         }
         else
         {
            this.FOrgGroups = param1 as Vector.<TOrgCopyVO>;
         }
      }
      
      public function CheckOrganizationData() : void
      {
         if(this.FOrgSingles == null)
         {
            this.SendSever();
         }
         if(this.FOrgGroups == null)
         {
            this.SendSever(false);
         }
      }
   }
}

