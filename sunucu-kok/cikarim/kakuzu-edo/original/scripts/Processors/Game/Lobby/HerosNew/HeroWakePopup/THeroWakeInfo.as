package Processors.Game.Lobby.HerosNew.HeroWakePopup
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.TBounds;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TAddOther;
   import Logics.DatebaseVO.VO.TWakeUpEquip;
   import Logics.Inventories.TInventoryWake;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class THeroWakeInfo extends TProcessorLobbyWindow
   {
      
      public static const Window_Width:int = 190;
      
      public static const Window_Height:int = 355;
      
      public static const Window_Interval:int = 10;
      
      public static const Window_MaxCount:int = 4;
      
      protected static const SecondType_WakeEquip:int = 1;
      
      protected static const SecondType_WakeChip:int = 2;
      
      protected static const Move_Tick:int = 500;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FSlot:TUISlot;
      
      protected var FTxtName:TextField;
      
      protected var FTxtDesc:TextField;
      
      protected var FTxtProperty:TextField;
      
      protected var FTxtLevel:TextField;
      
      protected var FBtnCompose:TUIButton;
      
      protected var FBtnComposeAll:TUIButton;
      
      protected var FBounds:TBounds;
      
      protected var FWakeUpEquip:TWakeUpEquip;
      
      protected var FIdentifier:int;
      
      protected var FHeroId:int;
      
      protected var FWindowsPos:Vector.<int>;
      
      protected var FParentX:int;
      
      protected var FParentY:int;
      
      protected var FMoveLiners:Vector.<TMovementLinear>;
      
      protected var FTickStore:int;
      
      protected var FPathWindows:Vector.<THeroWakeBase>;
      
      protected var FBackWindows:Vector.<THeroWakeBase>;
      
      protected var FIsMoveOver:Boolean;
      
      protected var FCurLayer:int;
      
      protected var FWindowEnd:THeroWakeEnd;
      
      public function THeroWakeInfo(param1:TUIComponent)
      {
         super(param1);
         this.FIsMoveOver = true;
         this.FCurLayer = param1.getChildIndex(this);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroWakePan_0") as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMainUI["MC_Slot"];
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.OnQuerySubscript = null;
         this.FSlot.Init();
         this.FTxtName = this.FMainUI["Txt_Name"];
         this.FTxtDesc = this.FMainUI["Txt_Desc"];
         this.FTxtProperty = this.FMainUI["Text_Property"];
         this.FTxtLevel = this.FMainUI["Txt_Level"];
         this.FBtnCompose = new TUIButton();
         this.FBtnCompose.Substrate = this.FMainUI["Btn_Compose"];
         this.FBtnCompose.OnClick = this.BtnComposeOnClick;
         this.FBtnComposeAll = new TUIButton();
         this.FBtnComposeAll.Substrate = this.FMainUI["Btn_ComposeAll"];
         this.FBtnComposeAll.OnClick = this.BtnComposeAllOnClick;
         this.FPathWindows = new Vector.<THeroWakeBase>();
         this.FBackWindows = new Vector.<THeroWakeBase>();
         this.FMoveLiners = new Vector.<TMovementLinear>();
         this.FParentX = FParent.x;
         this.FParentY = FParent.y;
         this.InitWindowsBounds();
      }
      
      protected function InitWindowsBounds() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = Window_Width;
         _loc3_ = 0;
         this.FWindowsPos = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < Window_MaxCount)
         {
            this.FWindowsPos[_loc1_] = (CONST_COMMON.STAGE_Width - _loc2_ - _loc3_ >> 1) - this.FParentX;
            _loc2_ += Window_Width;
            _loc3_ += _loc3_;
            this.FMoveLiners[_loc1_] = new TMovementLinear();
            _loc1_++;
         }
      }
      
      protected function RenderWakeInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TAddOther = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:THero = null;
         var _loc8_:TInventoryWake = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         this.FWakeUpEquip = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,this.FIdentifier) as TWakeUpEquip;
         _loc7_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FHeroId);
         _loc8_ = _loc7_.WakeEquipsNeed.GetInventoryByIDTemplate(this.FIdentifier) as TInventoryWake;
         if(_loc8_ == null)
         {
            return;
         }
         if(_loc7_.Level >= this.FWakeUpEquip.NeedLevel)
         {
            _loc11_ = CONST_COMMON.HTMLCOLOR_Green;
         }
         else
         {
            _loc11_ = CONST_COMMON.HTMLCOLOR_Red;
         }
         this.FTxtLevel.htmlText = "<font color=\'" + _loc11_ + "\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_62),this.FWakeUpEquip.NeedLevel) + "</font>";
         this.FTxtName.text = _loc8_.Name;
         _loc9_ = int(SLogicsCore.Character.WakeEquip.GetCountByTempleteID(_loc8_.IDTemplate));
         if(_loc9_ > 0)
         {
            _loc11_ = CONST_COMMON.HTMLCOLOR_Green;
         }
         else
         {
            _loc11_ = CONST_COMMON.HTMLCOLOR_Red;
         }
         this.FTxtDesc.htmlText = "<font color=\'" + _loc11_ + "\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_61),_loc9_) + "</font>";
         this.FSlot.Context = _loc8_;
         _loc6_ = "";
         _loc3_ = this.FWakeUpEquip.PropertyCount;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = this.FWakeUpEquip.GetPropertyByIndex(_loc1_) as TAddOther;
            _loc5_ = TUtilityLobby.GetBaseAttributeNameByType(_loc4_.Type);
            if(TUtilityLobby.GetViewtypeByAttributeName(_loc4_.Type))
            {
               _loc10_ = (Number(_loc4_.Value) * 100).toFixed(2) + "%";
            }
            else
            {
               _loc10_ = _loc4_.Value + "";
            }
            _loc6_ += _loc5_ + "：" + _loc10_ + "\n";
            _loc1_++;
         }
         this.FTxtProperty.text = _loc6_;
      }
      
      protected function SetWindowMiddle(param1:TUIComponent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = (CONST_COMMON.STAGE_Height - Window_Height >> 1) - this.FParentY;
         param1.Y = _loc2_;
         param1.X = this.FWindowsPos[0];
      }
      
      protected function SetWindowGroupMove() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTickStore = STimingCore.TickCount;
         this.FIsMoveOver = false;
         _loc1_ = 0;
         while(_loc1_ < this.FPathWindows.length)
         {
            this.FMoveLiners[_loc1_].SetupSegmentByDuration(this.FWindowsPos[this.FPathWindows.length - 1] + _loc2_,this.FPathWindows[0].Y,this.FPathWindows[_loc1_].X,this.FPathWindows[0].Y,Move_Tick);
            _loc2_ += Window_Interval + Window_Width;
            this.FPathWindows[_loc1_].mouseEnabled = false;
            this.FPathWindows[_loc1_].mouseChildren = false;
            _loc1_++;
         }
      }
      
      protected function AddEndWindow(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         _loc3_ = new Vector.<String>();
         _loc2_ = 0;
         while(_loc2_ < this.FPathWindows.length)
         {
            _loc3_[_loc2_] = this.FPathWindows[_loc2_].PathName;
            _loc2_++;
         }
         this.FWindowEnd.OnHyperlink = this.OnHyperlink;
         this.FWindowEnd.WakeIdentifier = param1;
         this.FWindowEnd.ParentNames = _loc3_;
         this.FWindowEnd.WindowOnClose = this.PathWindowOnClose;
         this.FWindowEnd.Y = this.Y;
         this.FWindowEnd.X = this.FPathWindows.length == 0 ? this.X : this.FPathWindows[this.FPathWindows.length - 1].X;
         this.FWindowEnd.CurLayer = this.FCurLayer;
         this.FWindowEnd.SetWakePath();
         this.FPathWindows.push(this.FWindowEnd);
         this.SetWindowGroupMove();
      }
      
      protected function AddPathWindow(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THeroWakePath = null;
         var _loc4_:Vector.<String> = null;
         _loc4_ = new Vector.<String>();
         _loc2_ = 0;
         while(_loc2_ < this.FPathWindows.length)
         {
            _loc4_[_loc2_] = this.FPathWindows[_loc2_].PathName;
            _loc2_++;
         }
         if(this.FBackWindows.length == 0)
         {
            _loc3_ = new THeroWakePath(FParent);
            _loc3_.UIDispatch();
         }
         else
         {
            _loc3_ = this.FBackWindows.pop() as THeroWakePath;
         }
         _loc3_.WakeIdentifier = param1;
         _loc3_.ParentNames = _loc4_;
         _loc3_.SlotOnClick = this.PathSlotOnClick;
         _loc3_.WindowOnClose = this.PathWindowOnClose;
         _loc3_.Y = this.Y;
         _loc3_.X = this.FPathWindows.length == 0 ? this.X : this.FPathWindows[this.FPathWindows.length - 1].X;
         _loc3_.CurLayer = this.FCurLayer;
         _loc3_.SetWakePath();
         this.FPathWindows.push(_loc3_);
         this.SetWindowGroupMove();
      }
      
      protected function ClearWindowByIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1;
         while(_loc2_ < this.FPathWindows.length)
         {
            this.FPathWindows[_loc2_].Close();
            if(this.FPathWindows[_loc2_] is THeroWakePath)
            {
               this.FBackWindows.push(this.FPathWindows[_loc2_]);
            }
            _loc2_++;
         }
         this.FPathWindows.splice(param1,this.FPathWindows.length - param1);
         if(this.FPathWindows.length == 0)
         {
            ProcessorWindowClose();
         }
         else
         {
            this.SetWindowGroupMove();
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         this.FSlot.Update();
         if(this.FIsMoveOver)
         {
            return;
         }
         _loc2_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FPathWindows.length)
         {
            this.FMoveLiners[_loc1_].Move(STimingCore.TickCount - this.FTickStore);
            this.FPathWindows[_loc1_].X = this.FMoveLiners[_loc1_].X;
            if(this.FMoveLiners[_loc1_].MoveOver)
            {
               _loc2_++;
            }
            _loc1_++;
         }
         if(_loc2_ >= this.FPathWindows.length)
         {
            this.FIsMoveOver = true;
            _loc1_ = 0;
            while(_loc1_ < this.FPathWindows.length)
            {
               this.FPathWindows[_loc1_].mouseEnabled = true;
               this.FPathWindows[_loc1_].mouseChildren = true;
               _loc1_++;
            }
         }
      }
      
      protected function PathSlotOnClick(param1:THeroWakeBase, param2:TInventoryWake) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TWakeUpEquip = null;
         _loc4_ = this.FPathWindows.indexOf(param1);
         this.ClearWindowByIndex(_loc4_ + 1);
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,param2.IDTemplate) as TWakeUpEquip;
         if(_loc5_.ComposeItemsCount == 0)
         {
            this.AddEndWindow(param2.IDTemplate);
         }
         else
         {
            this.AddPathWindow(param2.IDTemplate);
         }
      }
      
      protected function PathWindowOnClose(param1:THeroWakeBase) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FPathWindows.indexOf(param1);
         this.ClearWindowByIndex(_loc2_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
         if(this.FPathWindows.length == 0)
         {
            ProcessorWindowClose();
         }
      }
      
      protected function BtnComposeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FWakeUpEquip.ComposeItemsCount == 0)
         {
            this.AddEndWindow(this.FIdentifier);
         }
         else
         {
            this.AddPathWindow(this.FIdentifier);
         }
         this.Visible = false;
      }
      
      protected function BtnComposeAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_WakeUp_ComposeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FIdentifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnHyperlink(param1:Object) : void
      {
         this.ClearWindowByIndex(0);
      }
      
      public function UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function ShowInfoById(param1:int, param2:int, param3:Boolean) : void
      {
         this.FIdentifier = param2;
         this.FHeroId = param1;
         this.FBtnComposeAll.Enabled = param3;
         this.Visible = true;
         this.FIsMoveOver = true;
         this.RenderWakeInfo();
         this.SetWindowMiddle(this);
         if(this.FWindowEnd == null)
         {
            this.FWindowEnd = new THeroWakeEnd(FParent);
            this.FWindowEnd.UIDispatch();
         }
         this.FWindowEnd.CheckOrganizationData();
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         if(this.FPathWindows == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FPathWindows.length)
         {
            this.FPathWindows[_loc1_].SetData();
            _loc1_++;
         }
      }
      
      public function set BtnComposeEnable(param1:Boolean) : void
      {
         this.FBtnComposeAll.Enabled = param1;
      }
      
      public function get CurLayer() : int
      {
         return this.FCurLayer;
      }
      
      public function set CurLayer(param1:int) : void
      {
         this.FCurLayer = param1;
      }
      
      public function UpdateOrganizationData(param1:Object, param2:Boolean = true) : void
      {
         this.FWindowEnd.UpdateOrganizationData(param1,param2);
      }
   }
}

