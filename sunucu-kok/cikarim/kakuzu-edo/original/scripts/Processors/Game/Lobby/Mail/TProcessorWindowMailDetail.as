package Processors.Game.Lobby.Mail
{
   import Components.ComboBox.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.Integer.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.SensitiveWord.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Inventories.*;
   import Logics.Mail.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowMailDetail extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_Slots:uint = 5;
      
      protected static const CAPACITY_TF:uint = 3;
      
      public static const TYPE_Inbox:uint = TMail.TYPE_Inbox;
      
      public static const TYPE_Sentbox:uint = TMail.TYPE_Sentbox;
      
      public static const UIType_WriteMail:uint = 3;
      
      protected static const REWARDID_DATA_MAIL:Vector.<uint> = CONST_MAIL.REWARDID_DATA_MAIL;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FMC_UIType:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMC_List:MovieClip;
      
      protected var FMC_Inbox:MovieClip;
      
      protected var FTF_NameInbox:TextField;
      
      protected var FTF_TittleInbox:TextField;
      
      protected var FTF_DetailInbox:TextField;
      
      protected var FBtn_Left:SimpleButton;
      
      protected var FBtn_Right:SimpleButton;
      
      protected var FBtn_DeleteInbox:TUIButton;
      
      protected var FBtn_Reply:TUIButton;
      
      protected var FBtn_ReceiveAccessory:TUIButton;
      
      protected var FSlotList:Vector.<TUISlot>;
      
      protected var FMC_Sentbox:MovieClip;
      
      protected var FTF_NameSentbox:TextField;
      
      protected var FTF_TittleSentbox:TextField;
      
      protected var FTF_DetailSentbox:TextField;
      
      protected var FBtn_DeleteSentbox:TUIButton;
      
      protected var FMC_WriteMail:MovieClip;
      
      protected var FTF_NameWriteMail:TextField;
      
      protected var FTF_TittleWriteMail:TextField;
      
      protected var FTF_DetailWriteMail:TextField;
      
      protected var FBtn_Send:TUIButton;
      
      protected var FBtn_Cancle:TUIButton;
      
      protected var FFriendComboBox:TComboBox;
      
      protected var FFriendList:Vector.<DisplayObject>;
      
      protected var FFriends:TFriendDigests;
      
      protected var FSortIndex:UInt64;
      
      protected var FMails:TMails;
      
      protected var FMail:TMail;
      
      protected var FPageIndex:uint;
      
      protected var FInventories:TInventories;
      
      protected var FUIType:int;
      
      protected var FTFRewardList:Vector.<TextField>;
      
      protected var MailWrite_InputName:String;
      
      protected var MailWrite_InputTittle:String;
      
      protected var MailWrite_InputText:String;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnDelete:Function;
      
      protected var FOnSendMail:Function;
      
      protected var FOnReceiveAccessory:Function;
      
      public function TProcessorWindowMailDetail(param1:TUIComponent)
      {
         super(param1);
         this.FSlotList = new Vector.<TUISlot>(CAPACITY_Slots);
         this.FFriends = SLogicsCore.Friends;
         this.FMails = SLogicsCore.Mails;
         this.FTFRewardList = new Vector.<TextField>(CAPACITY_TF);
         this.FFriendList = new Vector.<DisplayObject>();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FUIType = -1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MAIL.RESOURCESID_SWF_MAIL);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_MAIL.RESOURCE_ClassName_MailDetail) as Sprite;
         addChild(_loc1_);
         this.FMC_UIType = _loc1_[CONST_MAIL.RESOURCE_Link_MC_UIType];
         this.FBtn_Close = _loc1_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.ResourcesPerform_InboxUIDispatch();
         this.ResourcesPerform_SentboxUIDispatch();
         this.ResourcesPerform_WriteMailUIDispatch();
         this.MailWrite_InputName = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_07);
         this.MailWrite_InputTittle = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_08);
         this.MailWrite_InputText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_09);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function ResourcesPerform_InboxUIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         this.FMC_Inbox = this.FMC_UIType[CONST_MAIL.RESOURCE_Link_MC_Inbox];
         this.FTF_NameInbox = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_TF_Name];
         this.FTF_NameInbox.mouseEnabled = false;
         this.FTF_TittleInbox = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_TF_Tittle];
         this.FTF_TittleInbox.mouseEnabled = false;
         this.FTF_DetailInbox = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_TF_Detail];
         this.FTF_DetailInbox.mouseEnabled = false;
         this.FBtn_DeleteInbox = new TUIButton();
         this.FBtn_DeleteInbox.Substrate = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_Btn_Delete];
         this.FBtn_DeleteInbox.OnClick = this.ButtonDeleteInboxOnClick;
         this.FBtn_Reply = new TUIButton();
         this.FBtn_Reply.Substrate = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_Btn_Reply];
         this.FBtn_Reply.OnClick = this.ButtonReplyOnClick;
         this.FBtn_ReceiveAccessory = new TUIButton();
         this.FBtn_ReceiveAccessory.Substrate = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_Btn_ReceiveAccessory];
         this.FBtn_ReceiveAccessory.OnClick = this.ButtonReceiveAccessoryOnClick;
         this.FBtn_Left = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward][CONST_MAIL.RESOURCE_Link_Btn_Left];
         this.FBtn_Right = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward][CONST_MAIL.RESOURCE_Link_Btn_Right];
         _loc2_ = CAPACITY_Slots;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward][CONST_MAIL.RESOURCE_Link_MC_Slot + _loc1_] as Sprite;
            _loc3_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc3_.Tag = _loc1_;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.OnOver = this.SlotsOnMove;
            _loc3_.OnOut = this.SlotsOnOut;
            _loc3_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc3_.Init();
            this.FSlotList[_loc1_] = _loc3_;
            _loc1_++;
         }
         _loc2_ = CAPACITY_TF;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFRewardList[_loc1_] = this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward][CONST_MAIL.RESOURCE_Link_TF_Reward + _loc1_];
            this.FTFRewardList[_loc1_].mouseEnabled = false;
            this.FTFRewardList[_loc1_].text = "";
            _loc1_++;
         }
         this.ResourcesPerform_InboxUILocations();
      }
      
      protected function ResourcesPerform_InboxUILocations() : void
      {
         this.FBtn_Left.addEventListener(MouseEvent.CLICK,this.ButtonLeftOnClick,false,0,true);
         this.FBtn_Right.addEventListener(MouseEvent.CLICK,this.ButtonRightOnClick,false,0,true);
      }
      
      protected function ResourcesPerform_SentboxUIDispatch() : void
      {
         this.FMC_Sentbox = this.FMC_UIType[CONST_MAIL.RESOURCE_Link_MC_Sentbox];
         this.FBtn_DeleteSentbox = new TUIButton();
         this.FBtn_DeleteSentbox.Substrate = this.FMC_Sentbox[CONST_MAIL.RESOURCE_Link_Btn_Delete];
         this.FBtn_DeleteSentbox.OnClick = this.ButtonDeleteSentboxOnClick;
         this.FTF_NameSentbox = this.FMC_Sentbox[CONST_MAIL.RESOURCE_Link_TF_Name];
         this.FTF_NameSentbox.mouseEnabled = false;
         this.FTF_TittleSentbox = this.FMC_Sentbox[CONST_MAIL.RESOURCE_Link_TF_Tittle];
         this.FTF_TittleSentbox.mouseEnabled = false;
         this.FTF_DetailSentbox = this.FMC_Sentbox[CONST_MAIL.RESOURCE_Link_TF_Detail];
         this.FTF_DetailSentbox.mouseEnabled = false;
      }
      
      protected function ResourcesPerform_WriteMailUIDispatch() : void
      {
         this.FMC_WriteMail = this.FMC_UIType[CONST_MAIL.RESOURCE_Link_MC_WriteMail];
         this.FTF_TittleWriteMail = this.FMC_WriteMail[CONST_MAIL.RESOURCE_Link_TF_Tittle];
         this.FTF_DetailWriteMail = this.FMC_WriteMail[CONST_MAIL.RESOURCE_Link_TF_Detail];
         this.FTF_NameWriteMail = this.FMC_WriteMail[CONST_MAIL.RESOURCE_Link_MC_FriendList]["mc_bar"]["tf_curInfo"];
         this.FTF_NameWriteMail.maxChars = 32;
         this.FBtn_Send = new TUIButton();
         this.FBtn_Send.Substrate = this.FMC_WriteMail[CONST_MAIL.RESOURCE_Link_Btn_Send];
         this.FBtn_Send.OnClick = this.ButtonSendOnClick;
         this.FBtn_Cancle = new TUIButton();
         this.FBtn_Cancle.Substrate = this.FMC_WriteMail[CONST_MAIL.RESOURCE_Link_Btn_Cancel];
         this.FBtn_Cancle.OnClick = this.CancleOnClick;
         this.InitialFriendList();
         this.FFriendComboBox = new TComboBox(this,this.FMC_WriteMail[CONST_MAIL.RESOURCE_Link_MC_FriendList],this.FFriendList,100,this.OnFriendSelect,false);
         this.FFriendComboBox.SetCurInfoInput();
         this.ResourcesPerform_WriteMailUILocations();
      }
      
      protected function ResourcesPerform_WriteMailUILocations() : void
      {
         this.FTF_TittleWriteMail.addEventListener(FocusEvent.FOCUS_IN,this.TFOnFocusIn,false,0,true);
         this.FTF_NameWriteMail.addEventListener(FocusEvent.FOCUS_IN,this.TFOnFocusIn,false,0,true);
         this.FTF_DetailWriteMail.addEventListener(FocusEvent.FOCUS_IN,this.TFOnFocusIn,false,0,true);
         this.FTF_TittleWriteMail.addEventListener(FocusEvent.FOCUS_OUT,this.TFOnFocusOut,false,0,true);
         this.FTF_NameWriteMail.addEventListener(FocusEvent.FOCUS_OUT,this.TFOnFocusOut,false,0,true);
         this.FTF_DetailWriteMail.addEventListener(FocusEvent.FOCUS_OUT,this.TFOnFocusOut,false,0,true);
         this.FTF_DetailWriteMail.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput,false,0,true);
         this.FTF_NameWriteMail.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput,false,0,true);
         this.FTF_TittleWriteMail.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput,false,0,true);
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc2_ = this.FSlotList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FSlotList[_loc1_];
            if(_loc3_ != null)
            {
               _loc3_.Update();
            }
            _loc1_++;
         }
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_MAIL.RESOURCE_ClassName_ComboBoxItem) as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function OnFriendSelect(param1:Object, param2:int) : void
      {
      }
      
      protected function UpdateInboxInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TMail = null;
         var _loc4_:String = null;
         var _loc5_:TInventory = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         _loc3_ = this.FMails.GetMailByTypeBySortIndex(this.FUIType,this.FSortIndex);
         this.FMail = _loc3_;
         this.FTF_NameInbox.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_05),_loc3_.Name);
         this.UpdateSlotInfo();
         this.UpdatePageInfo();
         _loc8_ = 0;
         _loc2_ = uint(_loc3_.AccessoryInventories.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc3_.AccessoryInventories.GetInventoryByIndex(_loc1_);
            _loc4_ = TUtilityString.Format("%0*%1",_loc5_.Name,_loc5_.Quantity);
            _loc7_ = REWARDID_DATA_MAIL.indexOf(_loc5_.IDTemplate);
            if(_loc7_ >= 0 && _loc8_ < 3)
            {
               this.FTFRewardList[_loc8_++].text = _loc4_;
            }
            _loc1_++;
         }
         if(_loc3_.Subject != "")
         {
            if(_loc3_.Name == TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_03))
            {
               _loc4_ = _loc3_.Subject;
            }
            else
            {
               _loc4_ = SSensitiveWord.Filter(_loc3_.Subject);
            }
            this.FTF_TittleInbox.text = _loc4_;
         }
         if(_loc3_.Detail != "")
         {
            if(_loc3_.Name == TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_03))
            {
               _loc4_ = _loc3_.Detail;
            }
            else
            {
               _loc4_ = SSensitiveWord.Filter(_loc3_.Detail);
            }
            this.FTF_DetailInbox.text = _loc4_;
         }
      }
      
      protected function UpdateSentboxInfo() : void
      {
         var _loc1_:TMail = null;
         var _loc2_:String = null;
         _loc1_ = this.FMails.GetMailByTypeBySortIndex(this.FUIType,this.FSortIndex);
         this.FMail = _loc1_;
         this.FTF_NameSentbox.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_06),_loc1_.Name);
         _loc2_ = SSensitiveWord.Filter(_loc1_.Subject);
         this.FTF_TittleSentbox.text = _loc2_;
         _loc2_ = SSensitiveWord.Filter(_loc1_.Detail);
         this.FTF_DetailSentbox.text = _loc2_;
      }
      
      protected function UpdateSlotInfo() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         if(this.FMail.AccessoryInventories.Count == 0)
         {
            this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward].visible = false;
            this.FBtn_ReceiveAccessory.Visible = false;
         }
         else
         {
            _loc1_ = new TInventories();
            _loc5_ = CAPACITY_Slots;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               this.FSlotList[_loc4_].Context = null;
               this.FSlotList[_loc4_].Resource.visible = false;
               _loc4_++;
            }
            this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward].visible = true;
            this.FBtn_ReceiveAccessory.Visible = true;
            this.FMC_Inbox[CONST_MAIL.RESOURCE_Link_MC_Reward].visible = true;
            _loc5_ = uint(this.FMail.AccessoryInventories.Count);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc2_ = this.FMail.AccessoryInventories.GetInventoryByIndex(_loc4_);
               _loc6_ = REWARDID_DATA_MAIL.indexOf(_loc2_.IDTemplate);
               if(_loc2_ != null && _loc6_ == -1)
               {
                  _loc1_.Add(_loc2_);
               }
               _loc4_++;
            }
            _loc5_ = CAPACITY_Slots;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc1_.Count <= _loc4_ + this.FPageIndex * CAPACITY_Slots)
               {
                  break;
               }
               _loc2_ = _loc1_.GetInventoryByIndex(this.FPageIndex * CAPACITY_Slots + _loc4_);
               this.FSlotList[_loc4_].Context = _loc2_;
               this.FSlotList[_loc4_].Resource.visible = true;
               _loc4_++;
            }
            this.FInventories = _loc1_;
         }
      }
      
      protected function UpdatePageInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.FInventories == null)
         {
            return;
         }
         _loc3_ = Math.ceil(this.FInventories.Count / CAPACITY_Slots);
         if(this.FPageIndex == 0)
         {
            if(_loc3_ <= 1)
            {
               this.FBtn_Left.visible = false;
               this.FBtn_Right.visible = false;
            }
            else
            {
               this.FBtn_Left.visible = false;
               this.FBtn_Right.visible = true;
            }
         }
         else if(this.FPageIndex == _loc3_ - 1)
         {
            this.FBtn_Left.visible = true;
            this.FBtn_Right.visible = false;
         }
         else if(this.FPageIndex < _loc3_ - 1)
         {
            this.FBtn_Left.visible = true;
            this.FBtn_Right.visible = true;
         }
      }
      
      protected function InitialText() : void
      {
         this.FTF_NameWriteMail.text = this.MailWrite_InputName;
         this.FTF_TittleWriteMail.text = this.MailWrite_InputTittle;
         this.FTF_DetailWriteMail.text = this.MailWrite_InputText;
         this.InitialFriendList();
         this.FFriendComboBox.ResetList(this.FFriendList);
      }
      
      protected function InitialFriendList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<String> = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:TFriendDigests = null;
         var _loc5_:uint = 0;
         var _loc6_:TFriendDigest = null;
         _loc2_ = new Vector.<String>();
         if(this.FFriendList != null && this.FFriendList.length > 0)
         {
            while(this.FFriendList.length > 0)
            {
               this.FFriendList.pop();
            }
            this.FFriendList.length = 0;
         }
         _loc5_ = uint(this.FFriends.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc6_ = this.FFriends.GetDigestByIndex(_loc1_);
            if(_loc6_.Type == 1)
            {
               _loc2_.push(_loc6_.Name);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc3_ = this.MakeComboItem(_loc2_[_loc1_]);
            this.FFriendList.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function SetUITypeVisible(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               this.FMC_Inbox.visible = true;
               this.FMC_Sentbox.visible = false;
               this.FMC_WriteMail.visible = false;
               break;
            case 1:
               this.FMC_Inbox.visible = false;
               this.FMC_Sentbox.visible = true;
               this.FMC_WriteMail.visible = false;
               break;
            case 2:
               this.FMC_Inbox.visible = false;
               this.FMC_Sentbox.visible = false;
               this.FMC_WriteMail.visible = true;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         _loc2_ = CAPACITY_TF;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFRewardList[_loc1_].text = "";
            _loc1_++;
         }
         _loc2_ = CAPACITY_Slots;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotList[_loc1_].Context = null;
            this.FSlotList[_loc1_].Resource.visible = false;
            _loc1_++;
         }
         this.FTF_DetailInbox.text = "";
         this.FTF_DetailSentbox.text = "";
         this.FTF_DetailWriteMail.text = "";
         this.FTF_NameInbox.text = "";
         this.FTF_NameSentbox.text = "";
         this.FTF_NameWriteMail.text = "";
         this.FTF_TittleInbox.text = "";
         this.FTF_TittleSentbox.text = "";
         this.FTF_TittleWriteMail.text = "";
      }
      
      protected function CancleOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ButtonCloseOnClick(param2);
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function ButtonDeleteInboxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<UInt64> = null;
         _loc3_ = new Vector.<UInt64>();
         _loc3_.push(this.FSortIndex);
         if(this.FOnDelete != null)
         {
            this.FOnDelete(this,_loc3_,TYPE_Inbox);
         }
      }
      
      protected function ButtonReplyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.SetUITypeVisible(2);
         this.InitialText();
         this.FFriendComboBox.SetInfo(this.FMail.Name);
      }
      
      protected function ButtonReceiveAccessoryOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TMail = null;
         var _loc4_:Vector.<UInt64> = null;
         _loc4_ = new Vector.<UInt64>();
         _loc3_ = this.FMails.GetMailByTypeBySortIndex(this.FUIType,this.FSortIndex);
         _loc4_.push(this.FSortIndex);
         if(this.FOnReceiveAccessory != null)
         {
            this.FOnReceiveAccessory(this,_loc4_);
         }
         this.ButtonCloseOnClick(null);
      }
      
      protected function ButtonLeftOnClick(param1:MouseEvent) : void
      {
         --this.FPageIndex;
         this.UpdateSlotInfo();
         this.UpdatePageInfo();
      }
      
      protected function ButtonRightOnClick(param1:MouseEvent) : void
      {
         ++this.FPageIndex;
         this.UpdateSlotInfo();
         this.UpdatePageInfo();
      }
      
      protected function ButtonDeleteSentboxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<UInt64> = null;
         _loc3_ = new Vector.<UInt64>();
         _loc3_.push(this.FSortIndex);
         if(this.FOnDelete != null)
         {
            this.FOnDelete(this,_loc3_,TYPE_Sentbox);
         }
      }
      
      protected function ButtonSendOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:TMail = null;
         var _loc5_:TFriendDigest = null;
         _loc3_ = this.FTF_NameWriteMail.text;
         _loc5_ = this.FFriends.GetDigestByName(_loc3_);
         if(_loc5_ == null)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_07));
            return;
         }
         _loc4_ = SLogicsCore.PoolMail.AcquireMail();
         _loc4_.Name = this.FTF_NameWriteMail.text;
         _loc4_.Subject = this.FTF_TittleWriteMail.text;
         _loc4_.Detail = this.FTF_DetailWriteMail.text;
         if(this.FOnSendMail != null)
         {
            this.FOnSendMail(_loc4_);
         }
      }
      
      protected function TFOnFocusIn(param1:FocusEvent) : void
      {
         var _loc2_:TextField = null;
         _loc2_ = param1.target as TextField;
         if(_loc2_.text == this.MailWrite_InputName || _loc2_.text == this.MailWrite_InputTittle || _loc2_.text == this.MailWrite_InputText)
         {
            _loc2_.text = "";
         }
      }
      
      protected function TFOnFocusOut(param1:FocusEvent) : void
      {
         var _loc2_:TextField = null;
         _loc2_ = param1.target as TextField;
         if(_loc2_ == this.FTF_NameWriteMail)
         {
            if(_loc2_.text == "")
            {
               this.FTF_NameWriteMail.text = this.MailWrite_InputName;
            }
         }
         else if(_loc2_ == this.FTF_TittleWriteMail)
         {
            if(_loc2_.text == "")
            {
               this.FTF_TittleWriteMail.text = this.MailWrite_InputTittle;
            }
         }
         else if(_loc2_ == this.FTF_DetailWriteMail)
         {
            if(_loc2_.text == "")
            {
               this.FTF_DetailWriteMail.text = this.MailWrite_InputText;
            }
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
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(this,param2);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,param2);
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
      
      protected function onTextInput(param1:TextEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeMultiByte(param1.currentTarget.text,"");
         _loc2_.writeMultiByte(param1.text,"");
         _loc3_ = _loc2_.length;
         switch(param1.currentTarget.name)
         {
            case "tf_curInfo":
               _loc4_ = 12;
               break;
            case "TF_Tittle":
               _loc4_ = 20;
               break;
            case "TF_Detail":
               _loc4_ = 300;
         }
         if(_loc3_ > _loc4_)
         {
            param1.preventDefault();
         }
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.FOnInventoryOver;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function get OnInventoryOut() : Function
      {
         return this.FOnInventoryOut;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function get OnDelete() : Function
      {
         return this.FOnDelete;
      }
      
      public function set OnDelete(param1:Function) : void
      {
         this.FOnDelete = param1;
      }
      
      public function get OnSendMail() : Function
      {
         return this.FOnSendMail;
      }
      
      public function set OnSendMail(param1:Function) : void
      {
         this.FOnSendMail = param1;
      }
      
      public function get OnReceiveAccessory() : Function
      {
         return this.FOnReceiveAccessory;
      }
      
      public function set OnReceiveAccessory(param1:Function) : void
      {
         this.FOnReceiveAccessory = param1;
      }
      
      public function UIUpdate(param1:int, param2:UInt64) : void
      {
         this.FUIType = param1 + 1;
         this.FSortIndex = param2;
         this.Reset();
         switch(param1)
         {
            case 0:
               this.SetUITypeVisible(0);
               this.UpdateInboxInfo();
               break;
            case 1:
               this.SetUITypeVisible(1);
               this.UpdateSentboxInfo();
               break;
            default:
               this.SetUITypeVisible(2);
               this.InitialText();
         }
      }
      
      public function Update() : void
      {
         this.ButtonCloseOnClick(null);
      }
      
      public function OpenWriteMail(param1:TDigest) : void
      {
         this.FTF_NameWriteMail.text = param1.Name;
      }
      
      public function CloseComboBox() : void
      {
         this.FFriendComboBox.HideComboBoxList();
      }
   }
}

