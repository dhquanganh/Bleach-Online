package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.ScrollBar.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Organization.*;
   import Logics.Spaces.*;
   import Processors.Game.Lobby.Common.PopupMenu.*;
   import Processors.Game.Lobby.Organization.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TCompOrgMembers extends TUIComponent
   {
      
      public static const CHARACTER_SELECT_View:uint = CONST_ORGANIZATION.CHARACTER_SELECT_View;
      
      public static const CHARACTER_SELECT_Chievement:uint = CONST_ORGANIZATION.CHARACTER_SELECT_Achievement;
      
      public static const CHARACTER_SELECT_Whisper:uint = CONST_ORGANIZATION.CHARACTER_SELECT_Whisper;
      
      public static const CHARACTER_SELECT_CopyName:uint = CONST_ORGANIZATION.CHARACTER_SELECT_CopyName;
      
      public static const CHARACTER_SELECT_Friend:uint = CONST_ORGANIZATION.CHARACTER_SELECT_Friend;
      
      public static const CHARACTER_SELECT_Kick:uint = CONST_ORGANIZATION.CHARACTER_SELECT_Kick;
      
      public static const WIDTH_WINDOW_Organization:Number = CONST_ORGANIZATION.STAGE_Width;
      
      public static const HEIGHT_WINDOW_Organization:Number = CONST_ORGANIZATION.STAGE_Height;
      
      protected static const TYPE_Whitelist_Add:uint = CONST_FRIEND.TYPE_Whitelist_Add;
      
      public static const TYPE_White:uint = CONST_FRIEND.TYPE_White;
      
      protected static const MAX_COUNT_PopupMenuList:uint = 6;
      
      protected static const INDEX_PopupMenuList_KickMember:uint = CONST_ORGANIZATION.INDEX_PopupMenuList_KickMember;
      
      public static const TYPE_MEMBERS_Normal:uint = CONST_ORGANIZATION.TYPE_MEMBERS_Normal;
      
      public static const TYPE_MEMBERS_SecondCommander:uint = CONST_ORGANIZATION.TYPE_MEMBERS_SecondCommander;
      
      public static const TYPE_MEMBERS_FirstCommander:uint = CONST_ORGANIZATION.TYPE_MEMBERS_FirstCommander;
      
      protected var FIsInitialization:Boolean;
      
      protected var FMC:MovieClip;
      
      protected var FMC_MemberList:MovieClip;
      
      protected var FMC_List:MovieClip;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FBInit:Boolean;
      
      protected var FData_MemberList:Vector.<TBaseOrganizationMember>;
      
      protected var FData_OrgBaseInfo:TBaseOrganization;
      
      protected var FMemberIDHigh:uint;
      
      protected var FMemberIDLow:uint;
      
      protected var FMemberName:String;
      
      protected var FWindowCharacterSelectPopupMenu:TWindowCharacterSelectPopupMenu;
      
      protected var FWindowConfirm:TUIWindowConfirmation;
      
      protected var FCharacter:TCharacter;
      
      protected var FFriends:TFriendDigests;
      
      protected var FCharacterDigest:TFriendDigest;
      
      protected var FDigst:TDigest;
      
      protected var FEffectText:Function;
      
      protected var FOnShowHeroInfo:Function;
      
      protected var FOnShowHeroAchievement:Function;
      
      protected var FOnChatWhisper:Function;
      
      protected var FOnInterpersonalRelationships:Function;
      
      public function TCompOrgMembers(param1:TUIComponent)
      {
         super(param1);
         this.FBInit = false;
         this.FCharacter = SLogicsCore.Character;
         this.FFriends = SLogicsCore.Friends;
         this.FCharacterDigest = new TFriendDigest(0,0);
         this.FDigst = new TDigest(0,0);
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         addChild(this.FMC);
         this.FMC_MemberList = this.FMC["MC_MemberList"];
         this.FMC_List = this.FMC_MemberList["mc_list"];
         this.FScrollBar = new TScrollBar(this.FMC_List,367,false,0,23);
         this.ConstructWindwoConfirmPopup();
         this.ConstructWindowCharacterSelectPopupMenu();
         this.addEventListenerWindowPopup();
         this.FBInit = true;
      }
      
      protected function ConstructWindwoConfirmPopup() : void
      {
         this.FWindowConfirm = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function ConstructWindowCharacterSelectPopupMenu() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MC_PopupMenuList") as Sprite;
         this.FWindowCharacterSelectPopupMenu = new TWindowCharacterSelectPopupMenu(this.Parent);
         this.FWindowCharacterSelectPopupMenu.OnSelect = this.PopupMenuCharacterSelectOnClick;
         this.FWindowCharacterSelectPopupMenu.SetSequenceButton(_loc3_);
         _loc2_ = int(MAX_COUNT_PopupMenuList);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FWindowCharacterSelectPopupMenu.SetMenuUsable(_loc1_,true);
            _loc1_++;
         }
      }
      
      protected function addEventListenerWindowPopup() : void
      {
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.WindowPopupHiderOnUp,false,0,true);
      }
      
      protected function ProcessorWindowPopupHider(param1:TUIComponent) : void
      {
         var _loc2_:Boolean = false;
         if(param1.Visible)
         {
            _loc2_ = this.HitWindowTest(param1);
            if(_loc2_)
            {
               return;
            }
            param1.Visible = false;
         }
      }
      
      protected function HitWindowTest(param1:TUIComponent) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:TCoordinate = null;
         var _loc4_:TBounds = null;
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(param1);
         _loc4_ = new TBounds();
         _loc4_.Assign(_loc3_);
         _loc4_.X = param1.Width;
         _loc4_.Y = param1.Height;
         return TUtilityCartisian.BoundsContainsCoordinate(_loc4_,FUICore.MouseCoordinate);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIOrgMemberElement = null;
         this.FData_MemberList.sort(this.SortOnOrgMemeberList);
         this.FScrollBar.Clear();
         _loc2_ = int(this.FData_MemberList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIOrgMemberElement(this);
            _loc3_.Perform_UIDispatch();
            _loc3_.ClickMemberElement = this.OnMemberClick;
            this.FScrollBar.AddItem(_loc3_);
            _loc3_.UpData(this.FData_MemberList[_loc1_],_loc1_);
            _loc3_.UpDateUI();
            _loc1_++;
         }
         this.FScrollBar.ScrollToUp();
         this.FScrollBar.Visible = true;
         if(this.FData_OrgBaseInfo.OrgPower == TYPE_MEMBERS_FirstCommander)
         {
            this.FWindowCharacterSelectPopupMenu.SetMenuUsable(INDEX_PopupMenuList_KickMember,true);
         }
         else
         {
            this.FWindowCharacterSelectPopupMenu.SetMenuUsable(INDEX_PopupMenuList_KickMember,false);
         }
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
      
      protected function ProcessorInterpersonalRelationshipsByCharacter() : void
      {
         var _loc1_:TFriendDigest = null;
         _loc1_ = this.FFriends.GetDigestByIdentifier(this.FCharacterDigest.Identifier0,this.FCharacterDigest.Identifier1);
         if(_loc1_ != null && _loc1_.Type != TYPE_White)
         {
            this.FEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_06));
         }
         else if(this.FOnInterpersonalRelationships != null)
         {
            this.FOnInterpersonalRelationships(this,TYPE_Whitelist_Add,this.FCharacterDigest);
         }
      }
      
      protected function PerformPacket_CS_KickMemberReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_KickMemberReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(this.FMemberIDHigh);
         _loc2_.writeUnsignedInt(this.FMemberIDLow);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function OnMemberClick(param1:Object, param2:uint, param3:uint, param4:String) : void
      {
         var _loc5_:TUIOrgMemberElement = null;
         if(param2 == SLogicsCore.Character.Identifier0 && param3 == SLogicsCore.Character.Identifier1)
         {
            return;
         }
         _loc5_ = param1 as TUIOrgMemberElement;
         this.FWindowCharacterSelectPopupMenu.X = mouseX;
         this.FWindowCharacterSelectPopupMenu.Y = mouseY;
         this.FWindowCharacterSelectPopupMenu.Visible = true;
         this.FMemberIDHigh = param2;
         this.FMemberIDLow = param3;
         this.FMemberName = param4;
      }
      
      protected function PopupMenuCharacterSelectOnClick(param1:Object, param2:uint) : void
      {
         switch(param2)
         {
            case CHARACTER_SELECT_View:
               if(this.FOnShowHeroInfo != null)
               {
                  this.FOnShowHeroInfo(this,this.FMemberIDHigh,this.FMemberIDLow);
               }
               break;
            case CHARACTER_SELECT_Chievement:
               if(this.FOnShowHeroAchievement != null)
               {
                  this.FOnShowHeroAchievement(this,this.FMemberIDHigh,this.FMemberIDLow);
               }
               break;
            case CHARACTER_SELECT_Whisper:
               this.FDigst.Coerce(this.FMemberIDHigh,this.FMemberIDLow);
               this.FDigst.Name = this.FMemberName;
               if(this.FOnChatWhisper != null)
               {
                  this.FOnChatWhisper(this,this.FDigst);
               }
               break;
            case CHARACTER_SELECT_CopyName:
               System.setClipboard(this.FMemberName);
               break;
            case CHARACTER_SELECT_Friend:
               this.FCharacterDigest.Coerce(this.FMemberIDHigh,this.FMemberIDLow);
               this.FCharacterDigest.Tag = TYPE_Whitelist_Add;
               this.ProcessorInterpersonalRelationshipsByCharacter();
               break;
            case CHARACTER_SELECT_Kick:
               if(this.FData_OrgBaseInfo.OrgPower != 2)
               {
                  if(this.FEffectText != null)
                  {
                     this.FEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_38));
                  }
                  return;
               }
               this.FWindowConfirm.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_39) + this.FMemberName + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_40);
               this.FWindowConfirm.OnOK = this.ClickWindowConfirmOk;
               this.FWindowConfirm.Visible = true;
         }
      }
      
      protected function ClickWindowConfirmOk(param1:Object) : void
      {
         this.PerformPacket_CS_KickMemberReq();
      }
      
      protected function WindowPopupHiderOnUp(param1:MouseEvent) : void
      {
         this.ProcessorWindowPopupHider(this.FWindowCharacterSelectPopupMenu);
      }
      
      public function get EffectText() : Function
      {
         return this.FEffectText;
      }
      
      public function set EffectText(param1:Function) : void
      {
         this.FEffectText = param1;
      }
      
      public function get OnShowHeroInfo() : Function
      {
         return this.FOnShowHeroInfo;
      }
      
      public function set OnShowHeroInfo(param1:Function) : void
      {
         this.FOnShowHeroInfo = param1;
      }
      
      public function get OnChatWhisper() : Function
      {
         return this.FOnChatWhisper;
      }
      
      public function set OnChatWhisper(param1:Function) : void
      {
         this.FOnChatWhisper = param1;
      }
      
      public function get OnInterpersonalRelationships() : Function
      {
         return this.FOnInterpersonalRelationships;
      }
      
      public function set OnInterpersonalRelationships(param1:Function) : void
      {
         this.FOnInterpersonalRelationships = param1;
      }
      
      public function set OnShowHeroAchievement(param1:Function) : void
      {
         this.FOnShowHeroAchievement = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:Vector.<TBaseOrganizationMember>, param2:TBaseOrganization) : void
      {
         this.FData_MemberList = param1;
         this.FData_OrgBaseInfo = param2;
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
      
      public function LogicsPerform() : void
      {
         if(this.FBInit)
         {
            this.FWindowCharacterSelectPopupMenu.Update();
         }
      }
   }
}

