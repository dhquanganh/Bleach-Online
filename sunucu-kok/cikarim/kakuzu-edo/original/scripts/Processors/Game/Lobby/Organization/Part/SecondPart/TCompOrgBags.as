package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.Pages.*;
   import Components.SelectBox.*;
   import Components.Slots.*;
   import Components.Standard.TUIButton;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Organization.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Windows.Editors.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TCompOrgBags extends TUIComponent
   {
      
      protected static const MAX_MEMBERSLIST_COUNT:uint = 14;
      
      protected static const MAX_SELECTSLOT_COUNT:uint = 8;
      
      protected static const MAX_GIVESLOT_COUNT:uint = 4;
      
      protected static const MAX_SELECTSLOT_PAGES:uint = 25;
      
      public static const STAGE_Width:Number = 906;
      
      public static const STAGE_Height:Number = 554;
      
      protected var FMC:MovieClip;
      
      protected var FMC_ChangeListPage:MovieClip;
      
      protected var FMC_PageLeftList:MovieClip;
      
      protected var FMC_PageRightList:MovieClip;
      
      protected var FMC_ChangeSlotPage:MovieClip;
      
      protected var FMC_PageLeftSlot:MovieClip;
      
      protected var FMC_PageRightSlot:MovieClip;
      
      protected var FBtn_Reset:TUIButton;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FUIPage_MembersList:TUIPage;
      
      protected var FPageIndex_MembersList:int;
      
      protected var FSelectPageIndex_MembersList:int;
      
      protected var FTF_MemberListPage:TextField;
      
      protected var FUIPage_SelectSlots:TUIPage;
      
      protected var FPageIndex_SelectSlots:int;
      
      protected var FSelectPageIndex_SelectSlots:int;
      
      protected var FTF_AwardListPage:TextField;
      
      protected var FMC_MembersListVect:Vector.<TUIOrgBagMemberListElement>;
      
      protected var FMC_AwardSlotListVect:Vector.<TUISlot>;
      
      protected var FMC_GiveSlotListVect:Vector.<TUISlot>;
      
      protected var FIsInitialization:Boolean;
      
      protected var FData_OrgMembersListVect:Vector.<TBaseOrganizationMember>;
      
      protected var FData_AwardInventories:TInventories;
      
      protected var FData_OriginalAwardQuantityVect:Vector.<uint>;
      
      protected var FData_AwardCodeVect:Vector.<uint>;
      
      protected var FSelectPlayerIDHigh:uint;
      
      protected var FSelectPlayerIDLow:uint;
      
      protected var FSelectAwardCountVect:Vector.<uint>;
      
      protected var FGiveAwardVect:Vector.<TInventory>;
      
      protected var FGiveAwardCodeVect:Vector.<uint>;
      
      protected var FBInitAwardSlot:Boolean;
      
      protected var FBInitGiveAwardSlot:Boolean;
      
      protected var FIndex_SelectSlot:int;
      
      protected var FMC_SelectBox:TSelectBoxSingle;
      
      protected var FMC_SelectBoxVect:Vector.<MovieClip>;
      
      protected var FIndex_SelectMember:int;
      
      protected var FUIWindowEditor:TUIWindowEditor;
      
      protected var FOrgBaseInfo:TBaseOrganization;
      
      protected var FSelectSlotOnMove:Function;
      
      protected var FSelectSlotOnOut:Function;
      
      protected var FEffectGenerateText:Function;
      
      public function TCompOrgBags(param1:TUIComponent)
      {
         super(param1);
         this.FPageIndex_MembersList = 0;
         this.FPageIndex_SelectSlots = 0;
         this.FMC_MembersListVect = new Vector.<TUIOrgBagMemberListElement>();
         this.FMC_AwardSlotListVect = new Vector.<TUISlot>();
         this.FMC_GiveSlotListVect = new Vector.<TUISlot>();
         this.FSelectAwardCountVect = new Vector.<uint>();
         this.FGiveAwardVect = new Vector.<TInventory>();
         this.FGiveAwardCodeVect = new Vector.<uint>();
         this.FMC_SelectBox = new TSelectBoxSingle();
         this.FMC_SelectBoxVect = new Vector.<MovieClip>();
         this.FData_AwardInventories = new TInventories();
         this.FBInitAwardSlot = false;
         this.FBInitGiveAwardSlot = false;
         this.FIndex_SelectSlot = -1;
         this.FIndex_SelectMember = -1;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIOrgBagMemberListElement = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TUISlot = null;
         this.FMC = param1;
         addChild(this.FMC);
         _loc2_ = 0;
         while(_loc2_ < MAX_MEMBERSLIST_COUNT)
         {
            _loc5_ = new TUIOrgBagMemberListElement(this);
            _loc4_ = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_Element + _loc2_];
            _loc5_.Perform_UIDispatch(_loc4_);
            this.FMC_MembersListVect[_loc2_] = _loc5_;
            _loc6_ = new MovieClip();
            _loc6_ = this.FMC["MC_CheckBox_" + _loc2_];
            this.FMC_SelectBox.SetTaskByIndex(_loc2_,_loc6_);
            this.FMC_SelectBoxVect[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FMC_SelectBox.CallBackOnSelect = this.OnMcSelectBoxSelect;
         this.FMC_SelectBox.CallBackOnUnselect = this.OnMcSelectBoxUnselect;
         this.FMC_SelectBox.Init();
         _loc2_ = 0;
         while(_loc2_ < MAX_SELECTSLOT_COUNT)
         {
            _loc4_ = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_SelectSlot + _loc2_];
            _loc7_ = new TUISlot(this);
            _loc7_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc7_.Resource = _loc4_;
            _loc7_.OnClick = this.OnSelectSlotClick;
            _loc7_.OnOver = this.FSelectSlotOnMove;
            _loc7_.OnOut = this.FSelectSlotOnOut;
            _loc7_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc7_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc7_.Init();
            this.FMC_AwardSlotListVect[_loc2_] = _loc7_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < MAX_GIVESLOT_COUNT)
         {
            _loc4_ = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_GiveSlot + _loc2_];
            _loc7_ = new TUISlot(this);
            _loc7_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc7_.Resource = _loc4_;
            _loc7_.OnOver = this.FSelectSlotOnMove;
            _loc7_.OnOut = this.FSelectSlotOnOut;
            _loc7_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc7_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc7_.Init();
            this.FMC_GiveSlotListVect[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Ok];
         this.FBtn_Ok.OnClick = this.OnBtnOkClick;
         this.FBtn_Reset = new TUIButton();
         this.FBtn_Reset.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Reset];
         this.FBtn_Reset.OnClick = this.OnBtnResetClick;
         this.FUIPage_MembersList = new TUIPage(this);
         this.FMC_ChangeListPage = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_ChangeListPage];
         this.FMC_PageLeftList = this.FMC_ChangeListPage[CONST_ORGANIZATION.RESOURCE_Link_MC_PageLeft];
         this.FMC_PageRightList = this.FMC_ChangeListPage[CONST_ORGANIZATION.RESOURCE_Link_MC_PageRight];
         this.FTF_MemberListPage = this.FMC_ChangeListPage[CONST_ORGANIZATION.RESOURCE_Link_TF_Page];
         this.FUIPage_MembersList.LabelPage = this.FTF_MemberListPage;
         this.FUIPage_MembersList.ButtonPrevious.Substrate = this.FMC_PageLeftList;
         this.FUIPage_MembersList.ButtonNext.Substrate = this.FMC_PageRightList;
         this.FUIPage_MembersList.PageSize = MAX_MEMBERSLIST_COUNT;
         this.FUIPage_MembersList.Init();
         this.FUIPage_MembersList.OnChangePage = this.OnChangePageList;
         this.FUIPage_SelectSlots = new TUIPage(this);
         this.FMC_ChangeSlotPage = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_ChangeSlotPage];
         this.FMC_PageLeftSlot = this.FMC_ChangeSlotPage[CONST_ORGANIZATION.RESOURCE_Link_MC_PageLeft];
         this.FMC_PageRightSlot = this.FMC_ChangeSlotPage[CONST_ORGANIZATION.RESOURCE_Link_MC_PageRight];
         this.FTF_AwardListPage = this.FMC_ChangeSlotPage[CONST_ORGANIZATION.RESOURCE_Link_TF_Page];
         this.FUIPage_SelectSlots.LabelPage = this.FTF_AwardListPage;
         this.FUIPage_SelectSlots.ButtonPrevious.Substrate = this.FMC_PageLeftSlot;
         this.FUIPage_SelectSlots.ButtonNext.Substrate = this.FMC_PageRightSlot;
         this.FUIPage_SelectSlots.PageSize = MAX_SELECTSLOT_COUNT;
         this.FUIPage_SelectSlots.Init();
         this.FUIPage_SelectSlots.OnChangePage = this.OnChangePageSlot;
         this.FUIWindowEditor = new TUIWindowEditor(this);
         this.FUIWindowEditor.OnOK = this.WindowEditorOnOK;
         this.FUIWindowEditor.OnCancel = this.WindowEditorOnCancel;
         this.FUIWindowEditor.X = -200;
         this.FUIWindowEditor.y = -200;
         TUtilityUIWindow.SetupWindowEditor(this.FUIWindowEditor);
         this.FUIWindowEditor.Visible = false;
         this.FOrgBaseInfo = new TBaseOrganization();
      }
      
      protected function UpdateMemberListUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FData_OrgMembersListVect.sort(this.SortOnOrgMemeberList);
         _loc2_ = int(this.FData_OrgMembersListVect.length);
         _loc1_ = 0;
         while(_loc1_ < MAX_MEMBERSLIST_COUNT)
         {
            if(_loc1_ < _loc2_)
            {
               if(this.FOrgBaseInfo.OrgPower == 2)
               {
                  this.FMC_SelectBoxVect[_loc1_].visible = true;
               }
               else
               {
                  this.FMC_SelectBoxVect[_loc1_].visible = false;
               }
               this.FMC_MembersListVect[_loc1_].MC.visible = true;
               if(this.FMC_MembersListVect[_loc1_] != null)
               {
                  this.FMC_MembersListVect[_loc1_].UpData(this.FData_OrgMembersListVect[_loc1_]);
                  this.FMC_MembersListVect[_loc1_].UpDateUI();
               }
            }
            else
            {
               this.FMC_MembersListVect[_loc1_].MC.visible = false;
               this.FMC_SelectBoxVect[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this.FUIPage_MembersList.TotalQuantity = this.FData_OrgMembersListVect.length;
         this.FUIPage_MembersList.PageIndex = this.FPageIndex_MembersList;
         this.FUIPage_MembersList.Update();
      }
      
      protected function SortOnOrgMemeberList(param1:TBaseOrganizationMember, param2:TBaseOrganizationMember) : Number
      {
         if(param1.OrgDuties < param2.OrgDuties)
         {
            return 1;
         }
         if(param1.OrgDuties > param2.OrgDuties)
         {
            return -1;
         }
         if(param1.TotalContribution < param2.TotalContribution)
         {
            return 1;
         }
         if(param1.TotalContribution > param2.TotalContribution)
         {
            return -1;
         }
         if(param1.PlayerLevel < param2.PlayerLevel)
         {
            return 1;
         }
         if(param1.PlayerLevel > param2.PlayerLevel)
         {
            return -1;
         }
         if(param1.Rank < param2.Rank)
         {
            return 1;
         }
         if(param1.Rank > param2.Rank)
         {
            return -1;
         }
         return 0;
      }
      
      protected function UpdateUI_AwardList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         this.FIndex_SelectSlot = 0;
         _loc2_ = int(MAX_SELECTSLOT_COUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardSlotListVect[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_SELECTSLOT_COUNT)
         {
            if(_loc1_ < this.FData_AwardInventories.Count)
            {
               _loc3_ = this.FData_AwardInventories.GetInventoryByIndex(_loc1_);
               this.FMC_AwardSlotListVect[_loc1_].Context = _loc3_;
            }
            _loc1_++;
         }
         this.FBInitAwardSlot = true;
         this.FUIPage_SelectSlots.TotalQuantity = this.FData_AwardInventories.Count;
         this.FUIPage_SelectSlots.PageIndex = this.FPageIndex_SelectSlots;
         this.FUIPage_SelectSlots.Update();
         this.FBtn_Ok.Enabled = true;
      }
      
      protected function UpdateUI_GiveAwardList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_GIVESLOT_COUNT)
         {
            if(this.FMC_GiveSlotListVect[_loc1_] != null)
            {
               this.FMC_GiveSlotListVect[_loc1_].Context = null;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_GIVESLOT_COUNT)
         {
            if(_loc1_ < this.FGiveAwardVect.length)
            {
               _loc3_ = this.FGiveAwardVect[_loc1_];
               this.FMC_GiveSlotListVect[_loc1_].Context = _loc3_;
               this.FMC_GiveSlotListVect[_loc1_].Update();
            }
            _loc1_++;
         }
         this.FBInitGiveAwardSlot = true;
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         if(param2 is TInventory)
         {
            _loc4_ = param2 as TInventory;
            _loc6_ = _loc4_.Quantity;
            param3.Value = String(_loc6_);
         }
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
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function OnMcSelectBoxSelect(param1:int, param2:int) : void
      {
         this.FIndex_SelectMember = this.FPageIndex_MembersList * MAX_MEMBERSLIST_COUNT + param2;
      }
      
      protected function OnMcSelectBoxUnselect(param1:int, param2:int) : void
      {
         this.FIndex_SelectMember = -1;
      }
      
      protected function WindowEditorOnOK(param1:Object) : void
      {
         var _loc2_:TAppliance = null;
         var _loc3_:TInventory = null;
         var _loc4_:TInventory = null;
         if(this.FGiveAwardVect.length >= MAX_GIVESLOT_COUNT || this.FUIWindowEditor.Value == 0)
         {
            return;
         }
         _loc2_ = this.FUIWindowEditor.Context as TAppliance;
         _loc3_ = new TInventory(_loc2_.Identifier);
         _loc3_.IDTemplate = _loc2_.IDTemplate;
         _loc3_.IDTexture = _loc2_.IDTexture;
         _loc3_.Quantity = this.FUIWindowEditor.Value;
         this.FGiveAwardVect.push(_loc3_);
         this.FGiveAwardCodeVect.push(this.FData_AwardCodeVect[this.FIndex_SelectSlot]);
         this.UpdateUI_GiveAwardList();
         if(this.FIndex_SelectSlot != -1)
         {
            this.FData_AwardInventories.GetInventoryByIndex(this.FIndex_SelectSlot).Quantity = this.FData_AwardInventories.GetInventoryByIndex(this.FIndex_SelectSlot).Quantity - this.FUIWindowEditor.Value;
         }
      }
      
      protected function WindowEditorOnCancel(param1:Object) : void
      {
         this.FUIWindowEditor.Context = null;
         this.FUIWindowEditor.Visible = false;
         this.FIndex_SelectSlot = -1;
      }
      
      protected function OnSelectSlotClick(param1:Object, param2:TInventory) : void
      {
         var _loc3_:TAppliance = null;
         var _loc4_:TUISlot = null;
         if(this.FOrgBaseInfo.OrgPower != 2)
         {
            return;
         }
         _loc3_ = param2 as TAppliance;
         if(_loc3_.Quantity <= 0)
         {
            return;
         }
         _loc4_ = param1 as TUISlot;
         this.FIndex_SelectSlot = this.FPageIndex_SelectSlots * MAX_SELECTSLOT_COUNT + this.FMC_AwardSlotListVect.indexOf(_loc4_);
         this.FUIWindowEditor.Label = _loc3_.Name;
         this.FUIWindowEditor.Context = _loc3_ as TInventory;
         this.FUIWindowEditor.Quantity = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.BACKPACK_STRING_10),_loc3_.Quantity);
         this.FUIWindowEditor.Value = _loc3_.Quantity;
         this.FUIWindowEditor.Min = 1;
         this.FUIWindowEditor.Max = _loc3_.Quantity;
         this.FUIWindowEditor.SetFocus();
         this.FUIWindowEditor.Update();
         this.FUIWindowEditor.Visible = true;
      }
      
      protected function OnChangePageList(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != null)
         {
         }
         if(param2 == this.FPageIndex_MembersList)
         {
            return;
         }
         this.FPageIndex_MembersList = param2;
         this.FMC_SelectBox.UnselectAll();
         this.FIndex_SelectMember = -1;
         _loc3_ = 0;
         while(_loc3_ < MAX_MEMBERSLIST_COUNT)
         {
            this.FMC_MembersListVect[_loc3_].ResetUI();
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < MAX_MEMBERSLIST_COUNT)
         {
            _loc4_ = this.FPageIndex_MembersList * MAX_MEMBERSLIST_COUNT + _loc3_;
            if(_loc4_ < this.FData_OrgMembersListVect.length)
            {
               this.FMC_MembersListVect[_loc3_].UpData(this.FData_OrgMembersListVect[_loc4_]);
               this.FMC_MembersListVect[_loc3_].UpDateUI();
               if(this.FOrgBaseInfo.OrgPower == 2)
               {
                  this.FMC_SelectBoxVect[_loc3_].visible = true;
               }
               else
               {
                  this.FMC_SelectBoxVect[_loc3_].visible = false;
               }
            }
            else
            {
               this.FMC_SelectBoxVect[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function OnChangePageSlot(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         if(param1 != null)
         {
         }
         if(param2 == this.FPageIndex_SelectSlots)
         {
            return;
         }
         this.FPageIndex_SelectSlots = param2;
         _loc3_ = 0;
         while(_loc3_ < MAX_SELECTSLOT_COUNT)
         {
            this.FMC_AwardSlotListVect[_loc3_].Context = null;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < MAX_SELECTSLOT_COUNT)
         {
            _loc4_ = this.FPageIndex_SelectSlots * MAX_SELECTSLOT_COUNT + _loc3_;
            if(_loc4_ < this.FData_AwardInventories.Count)
            {
               _loc6_ = this.FData_AwardInventories.GetInventoryByIndex(_loc4_);
               this.FMC_AwardSlotListVect[_loc3_].Context = _loc6_;
            }
            _loc3_++;
         }
      }
      
      protected function OnBtnOkClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(this.FIndex_SelectMember >= 0)
         {
            this.FSelectPlayerIDHigh = this.FData_OrgMembersListVect[this.FIndex_SelectMember].Identifier0;
            this.FSelectPlayerIDLow = this.FData_OrgMembersListVect[this.FIndex_SelectMember].Identifier1;
            if(this.FSelectPlayerIDLow <= 0 || this.FSelectPlayerIDHigh < 0 || this.FGiveAwardCodeVect.length <= 0 || this.FGiveAwardVect.length <= 0)
            {
               return;
            }
            this.FBtn_Ok.Enabled = false;
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_AssignGulidDepotReq);
            _loc4_ = _loc3_.Data;
            _loc6_ = int(this.FGiveAwardVect.length);
            _loc4_.writeShort(_loc6_);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc4_.writeUnsignedInt(this.FGiveAwardCodeVect[_loc5_]);
               _loc4_.writeUnsignedInt(this.FGiveAwardVect[_loc5_].IDTemplate);
               _loc4_.writeUnsignedInt(this.FGiveAwardVect[_loc5_].Quantity);
               _loc5_++;
            }
            _loc4_.writeUnsignedInt(this.FSelectPlayerIDHigh);
            _loc4_.writeUnsignedInt(this.FSelectPlayerIDLow);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
            return;
         }
         if(this.FEffectGenerateText != null)
         {
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_37);
            this.FEffectGenerateText(this,_loc7_);
         }
      }
      
      protected function OnBtnResetClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FGiveAwardCodeVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FGiveAwardCodeVect.shift();
            _loc3_++;
         }
         _loc4_ = int(this.FGiveAwardVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FGiveAwardVect.shift();
            _loc3_++;
         }
         this.UpdateUI_GiveAwardList();
         _loc4_ = this.FData_AwardInventories.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FData_AwardInventories.GetInventoryByIndex(_loc3_).Quantity = this.FData_OriginalAwardQuantityVect[_loc3_];
            this.UpDateUI();
            _loc3_++;
         }
         this.FPageIndex_SelectSlots = 0;
         this.FIndex_SelectSlot = -1;
         this.FPageIndex_MembersList = 0;
         this.FMC_SelectBox.UnselectAll();
         this.FIndex_SelectMember = -1;
      }
      
      protected function CloneInventoryQuantity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventory = null;
         _loc2_ = this.FData_AwardInventories.Count;
         this.FData_OriginalAwardQuantityVect = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData_AwardInventories.GetInventoryByIndex(_loc1_) as TInventory;
            this.FData_OriginalAwardQuantityVect[_loc1_] = _loc3_.Quantity;
            _loc1_++;
         }
      }
      
      public function get SelectSlotOnMove() : Function
      {
         return this.FSelectSlotOnMove;
      }
      
      public function set SelectSlotOnMove(param1:Function) : void
      {
         this.FSelectSlotOnMove = param1;
      }
      
      public function get SelectSlotOnOut() : Function
      {
         return this.FSelectSlotOnOut;
      }
      
      public function set SelectSlotOnOut(param1:Function) : void
      {
         this.FSelectSlotOnOut = param1;
      }
      
      public function get EffectGenerateText() : Function
      {
         return this.FEffectGenerateText;
      }
      
      public function set EffectGenerateText(param1:Function) : void
      {
         this.FEffectGenerateText = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpDateUI() : void
      {
         if(this.FOrgBaseInfo.OrgPower == 2)
         {
            this.FBtn_Ok.Visible = true;
            this.FBtn_Reset.Visible = true;
         }
         else
         {
            this.FBtn_Ok.Visible = false;
            this.FBtn_Reset.Visible = false;
         }
         this.UpdateMemberListUI();
         this.UpdateUI_AwardList();
      }
      
      public function UpData(param1:TInventories, param2:Vector.<uint>, param3:Vector.<TBaseOrganizationMember>, param4:TBaseOrganization) : void
      {
         this.FData_AwardInventories = param1;
         this.FData_AwardCodeVect = param2;
         this.FData_OrgMembersListVect = param3;
         this.FOrgBaseInfo = param4;
         this.CloneInventoryQuantity();
         this.OnBtnResetClick(this,null);
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FBInitAwardSlot)
         {
            _loc2_ = int(MAX_SELECTSLOT_COUNT);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FMC_AwardSlotListVect[_loc1_] != null)
               {
                  this.FMC_AwardSlotListVect[_loc1_].Update();
               }
               _loc1_++;
            }
         }
         if(this.FBInitGiveAwardSlot)
         {
            _loc2_ = int(this.FGiveAwardVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FMC_GiveSlotListVect[_loc1_] != null)
               {
                  this.FMC_GiveSlotListVect[_loc1_].Update();
               }
               _loc1_++;
            }
         }
      }
      
      public function UnMount() : void
      {
         var _loc1_:uint = 0;
         this.OnBtnResetClick(this,null);
         _loc1_ = 0;
         while(_loc1_ < MAX_SELECTSLOT_COUNT)
         {
            this.FMC_AwardSlotListVect[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_GIVESLOT_COUNT)
         {
            this.FMC_GiveSlotListVect[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

