package Processors.Game.Lobby.OrganizationPointMap.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TPointMapInfoMainUI extends TProcessorLobbyWindow
   {
      
      protected static const SIZE_WindowApplyList_Width:Number = 295;
      
      protected static const SIZE_WindowApplyList_Height:Number = 236;
      
      protected static const SIZE_WindowDamageRank_Width:Number = 326;
      
      protected static const SIZE_WindowDamageRank_Height:Number = 302;
      
      protected static const SIZE_WindowDistRecord_Width:Number = 394;
      
      protected static const SIZE_WindowDistRecord_Height:Number = 394;
      
      protected static const SIZE_WindowRaiders_Width:Number = 297;
      
      protected static const SIZE_WindowRaiders_Height:Number = 318;
      
      protected static const SIZE_WindowSpoils_Width:Number = 394;
      
      protected static const SIZE_WindowSpoils_Height:Number = 394;
      
      protected const UI_X:Number = 0;
      
      protected const UI_Y:Number = 0;
      
      protected var FMainUI:MovieClip;
      
      protected var FTF_Remain:TextField;
      
      protected var FBtn_DistRecord:TUIButton;
      
      protected var FBtn_DamageRank:TUIButton;
      
      protected var FBtn_Spoils:TUIButton;
      
      protected var FBtn_Raiders:TUIButton;
      
      protected var FData:TNewOrgData;
      
      protected var FWindowBounds:TBounds;
      
      protected var FLayerMask:Sprite;
      
      protected var FWindowAppList:TPointMapInfoApplyList;
      
      protected var FWindowDamageRank:TPointMapInfoDamageRank;
      
      protected var FWindowDistRecord:TPointMapInfoDistRecord;
      
      protected var FWindowRaiders:TPointMapInfoRaiders;
      
      protected var FWindowSpoils:TPointMapInfoSpoils;
      
      protected var FWindows:Vector.<TProcessorLobbyWindow>;
      
      protected var FEffectGenerateTextByErrorCode:Function;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      public function TPointMapInfoMainUI(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.NewOrgData;
         this.FLayerMask = new Sprite();
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.visible = false;
         addChild(this.FLayerMask);
         this.FWindowAppList = new TPointMapInfoApplyList(this);
         this.FWindowDamageRank = new TPointMapInfoDamageRank(this);
         this.FWindowDistRecord = new TPointMapInfoDistRecord(this);
         this.FWindowRaiders = new TPointMapInfoRaiders(this);
         this.FWindowSpoils = new TPointMapInfoSpoils(this);
         this.FWindowAppList.OnClose = this.AppListWindowOnClose;
         this.FWindowDamageRank.OnClose = this.WindowOnClose;
         this.FWindowDistRecord.OnClose = this.WindowOnClose;
         this.FWindowRaiders.OnClose = this.WindowOnClose;
         this.FWindowSpoils.OnClose = this.WindowOnClose;
         this.FWindowSpoils.OnOpenAppList = this.OpenAppListWindow;
         this.FWindowBounds = new TBounds();
         this.FWindowBounds.Width = SIZE_WindowApplyList_Width;
         this.FWindowBounds.Height = SIZE_WindowApplyList_Height;
         this.ComponentBoundsCenter(this.FWindowAppList,this.FWindowBounds);
         this.FWindowBounds.Width = SIZE_WindowDamageRank_Width;
         this.FWindowBounds.Height = SIZE_WindowDamageRank_Height;
         this.ComponentBoundsCenter(this.FWindowDamageRank,this.FWindowBounds);
         this.FWindowBounds.Width = SIZE_WindowDistRecord_Width;
         this.FWindowBounds.Height = SIZE_WindowDistRecord_Height;
         this.ComponentBoundsCenter(this.FWindowDistRecord,this.FWindowBounds);
         this.FWindowBounds.Width = SIZE_WindowRaiders_Width;
         this.FWindowBounds.Height = SIZE_WindowRaiders_Height;
         this.ComponentBoundsCenter(this.FWindowRaiders,this.FWindowBounds);
         this.FWindowBounds.Width = SIZE_WindowSpoils_Width;
         this.FWindowBounds.Height = SIZE_WindowSpoils_Height;
         this.ComponentBoundsCenter(this.FWindowSpoils,this.FWindowBounds);
         this.FWindows = Vector.<TProcessorLobbyWindow>([this.FWindowAppList,this.FWindowDamageRank,this.FWindowDistRecord,this.FWindowRaiders,this.FWindowSpoils]);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_AllocationRet,this.PacketPerform_PointMapInfoUI_AllocationRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_SpoilsRet,this.PacketPerform_PointMapInfoUI_SpoilsRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_AttValueRet,this.PacketPerform_PointMapInfoUI_AttValueRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_ApplyReq,this.PacketPerform_PointMapInfoUI_ApplyReq);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_ApplyListRet,this.PacketPerform_PointMapInfoUI_ApplyListRet);
      }
      
      protected function PacketPerform_PointMapInfoUI_AllocationRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerOrganizationNew.AllocationRet(param1.Data);
            this.SwitchWindow(this.FWindowDistRecord);
         }
      }
      
      protected function PacketPerform_PointMapInfoUI_SpoilsRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerOrganizationNew.SpoilsRet(param1.Data);
            this.SwitchWindow(this.FWindowSpoils);
         }
      }
      
      protected function PacketPerform_PointMapInfoUI_AttValueRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerOrganizationNew.AttValueRet(param1.Data);
            this.SwitchWindow(this.FWindowDamageRank);
         }
      }
      
      protected function PacketPerform_PointMapInfoUI_ApplyReq(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerOrganizationNew.ApplyRet(param1.Data);
            this.FWindowSpoils.UpdateItem();
         }
      }
      
      protected function PacketPerform_PointMapInfoUI_ApplyListRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerOrganizationNew.ApplyListRet(param1.Data);
            this.SwitchWindow(this.FWindowAppList);
         }
      }
      
      protected function ComponentBoundsCenter(param1:TUIComponent, param2:TBounds) : void
      {
         param1.x = (CONST_COMMON.STAGE_Width - param2.Width) / 2;
         param1.y = (CONST_COMMON.STAGE_Height - param2.Height) / 2;
      }
      
      protected function SwitchWindow(param1:TProcessorLobbyWindow) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TProcessorLobbyWindow = null;
         _loc3_ = this.FWindows.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FWindows[_loc2_];
            _loc4_.Visible = false;
            _loc2_++;
         }
         if(param1 != null)
         {
            param1.Visible = true;
            this.FLayerMask.visible = true;
         }
         else
         {
            this.FLayerMask.visible = false;
         }
      }
      
      protected function WindowOnClose(param1:Object) : void
      {
         this.SwitchWindow(null);
      }
      
      protected function AppListWindowOnClose(param1:Object) : void
      {
         this.SwitchWindow(this.FWindowSpoils);
      }
      
      protected function OpenAppListWindow(param1:uint) : void
      {
         this.FUnstreamizerOrganizationNew.ApplyListReq(param1);
      }
      
      protected function PacketReqSuc(param1:TPacket) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            this.FEffectGenerateTextByErrorCode(_loc2_);
            return false;
         }
         return true;
      }
      
      protected function OnDistRecordBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizerOrganizationNew.AllocationReq();
      }
      
      protected function OnDamageRankBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizerOrganizationNew.AttValueReq();
      }
      
      protected function OnSpoilsBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizerOrganizationNew.SpoilsReq();
      }
      
      protected function OnRaidersBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.SwitchWindow(this.FWindowRaiders);
      }
      
      public function set EffectGenerateTextByErrorCode(param1:Function) : void
      {
         this.FEffectGenerateTextByErrorCode = param1;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
         this.FWindowSpoils.UnstreamizerOrganizationNew = param1;
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_PointMapBtn_Group") as MovieClip;
         addChildAt(this.FMainUI,0);
         this.FMainUI.x = this.UI_X;
         this.FMainUI.y = this.UI_Y;
         this.FTF_Remain = this.FMainUI["TF_Remain"];
         this.FBtn_DistRecord = new TUIButton();
         this.FBtn_DistRecord.OnClick = this.OnDistRecordBtnClick;
         this.FBtn_DistRecord.Substrate = this.FMainUI["Btn_DistRecord"];
         this.FBtn_DamageRank = new TUIButton();
         this.FBtn_DamageRank.OnClick = this.OnDamageRankBtnClick;
         this.FBtn_DamageRank.Substrate = this.FMainUI["Btn_DamageRank"];
         this.FBtn_Spoils = new TUIButton();
         this.FBtn_Spoils.OnClick = this.OnSpoilsBtnClick;
         this.FBtn_Spoils.Substrate = this.FMainUI["Btn_Spoils"];
         this.FBtn_Raiders = new TUIButton();
         this.FBtn_Raiders.OnClick = this.OnRaidersBtnClick;
         this.FBtn_Raiders.Substrate = this.FMainUI["Btn_Raiders"];
         this.FWindowAppList.UIDispatch();
         this.FWindowDamageRank.UIDispatch();
         this.FWindowDistRecord.UIDispatch();
         this.FWindowRaiders.UIDispatch();
         this.FWindowSpoils.UIDispatch();
      }
      
      public function UpdateRemain() : void
      {
         this.FTF_Remain.text = this.FData.GetCopyRemainFight(this.FData.CurrentCopy).toString();
      }
      
      public function Reset() : void
      {
         this.SwitchWindow(null);
      }
   }
}

