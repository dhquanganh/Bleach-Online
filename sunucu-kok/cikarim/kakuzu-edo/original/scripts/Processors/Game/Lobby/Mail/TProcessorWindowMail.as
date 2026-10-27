package Processors.Game.Lobby.Mail
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Mail.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowMail extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_Mails:uint = CONST_MAIL.CAPACITY_Mails;
      
      public static const FRAME_UnSelect:uint = 1;
      
      public static const FRAME_Select:uint = 2;
      
      public static const FRAME_UnRead:uint = 1;
      
      public static const FRAME_Read:uint = 2;
      
      public static const TYPE_Inbox:uint = TMail.TYPE_Inbox;
      
      public static const TYPE_Sentbox:uint = TMail.TYPE_Sentbox;
      
      protected var FHelpTips:THint;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FTF_MailType:TextField;
      
      protected var FTF_Time:TextField;
      
      protected var FButtonPrevious:TUIButton;
      
      protected var FButtonNext:TUIButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_WriteMail:SimpleButton;
      
      protected var FBtn_AllSelect:TUIButton;
      
      protected var FBtn_Delete:TUIButton;
      
      protected var FBtn_ReceiveAccessory:TUIButton;
      
      protected var FMC_EffectLeft:MovieClip;
      
      protected var FMC_EffectRight:MovieClip;
      
      protected var FMailInfoList:Vector.<MovieClip>;
      
      protected var FBtnOptionList:Vector.<MovieClip>;
      
      protected var FMCTreasureList:Vector.<MovieClip>;
      
      protected var FEnvelopeList:Vector.<MovieClip>;
      
      protected var FTextNameList:Vector.<TextField>;
      
      protected var FTextTittleList:Vector.<TextField>;
      
      protected var FTextTimeList:Vector.<TextField>;
      
      protected var FTabIndex:uint;
      
      protected var FPageIndex:uint;
      
      protected var FBtnList:Vector.<TUIButton>;
      
      protected var FMails:TMails;
      
      protected var FMailsInbox:TMails;
      
      protected var FMailsSentbox:TMails;
      
      protected var FCurrentMails:TMails;
      
      protected var FDictionary:Dictionary;
      
      protected var FSortIndex:UInt64;
      
      protected var FOnOpenMailDetail:Function;
      
      protected var FOnDelete:Function;
      
      protected var FOnReceiveAccessory:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      public function TProcessorWindowMail(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FMailInfoList = new Vector.<MovieClip>(CAPACITY_Mails);
         this.FBtnOptionList = new Vector.<MovieClip>(CAPACITY_Mails);
         this.FMCTreasureList = new Vector.<MovieClip>(CAPACITY_Mails);
         this.FEnvelopeList = new Vector.<MovieClip>(CAPACITY_Mails);
         this.FTextNameList = new Vector.<TextField>(CAPACITY_Mails);
         this.FTextTittleList = new Vector.<TextField>(CAPACITY_Mails);
         this.FTextTimeList = new Vector.<TextField>(CAPACITY_Mails);
         this.FMails = SLogicsCore.Mails;
         this.FMailsInbox = new TMails();
         this.FMailsSentbox = new TMails();
         this.FBtnList = new Vector.<TUIButton>();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MAIL.RESOURCESID_SWF_MAIL);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_MAIL.RESOURCE_ClassName_Mail) as Sprite;
         addChild(_loc3_);
         this.FUITab = new TUITab(this);
         _loc4_ = _loc3_[CONST_MAIL.RESOURCE_Link_MC_Tab_Inbox];
         this.FUITab.SetTabByIndex(_loc4_,0);
         _loc4_ = _loc3_[CONST_MAIL.RESOURCE_Link_MC_Tab_SentBox];
         this.FUITab.SetTabByIndex(_loc4_,1);
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FBtn_AllSelect = new TUIButton();
         this.FBtn_AllSelect.Substrate = _loc3_[CONST_MAIL.RESOURCE_Link_Btn_AllSelect];
         this.FBtn_AllSelect.OnClick = this.ButtonAllSelectOnClick;
         this.FBtnList.push(this.FBtn_AllSelect);
         this.FBtn_Delete = new TUIButton();
         this.FBtn_Delete.Substrate = _loc3_[CONST_MAIL.RESOURCE_Link_Btn_Delete];
         this.FBtn_Delete.OnClick = this.ButtonDeleteOnClick;
         this.FBtnList.push(this.FBtn_Delete);
         this.FBtn_ReceiveAccessory = new TUIButton();
         this.FBtn_ReceiveAccessory.Substrate = _loc3_[CONST_MAIL.RESOURCE_Link_Btn_ReceiveAccessory];
         this.FBtn_ReceiveAccessory.OnClick = this.ButtonReceiveAccessoryOnClick;
         this.FBtnList.push(this.FBtn_ReceiveAccessory);
         this.FBtn_Close = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_WriteMail = _loc3_[CONST_MAIL.RESOURCE_Link_Btn_WriteMail];
         _loc7_ = _loc3_[CONST_MAIL.RESOURCE_Link_MC_MailList][CONST_MAIL.RESOURCE_Link_MC_MailList];
         _loc5_ = _loc7_[CONST_MAIL.RESOURCE_Link_MC_Page][CONST_MAIL.RESOURCE_Link_MC_PageLeft];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc5_;
         _loc5_ = _loc7_[CONST_MAIL.RESOURCE_Link_MC_Page][CONST_MAIL.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc5_;
         _loc6_ = _loc7_[CONST_MAIL.RESOURCE_Link_MC_Page][CONST_MAIL.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc6_;
         this.FUIPage.PageSize = CAPACITY_Mails;
         this.FUIPage.Init();
         this.FButtonPrevious = this.FUIPage.ButtonPrevious;
         this.FButtonNext = this.FUIPage.ButtonNext;
         this.FTF_MailType = _loc7_[CONST_MAIL.RESOURCE_Link_TF_MailType];
         this.FTF_Time = _loc7_[CONST_MAIL.RESOURCE_Link_TF_Time];
         _loc2_ = CAPACITY_Mails;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc8_ = _loc7_[CONST_MAIL.RESOURCE_Link_MC_MailInfo + _loc1_];
            this.FMailInfoList[_loc1_] = _loc8_;
            this.FBtnOptionList[_loc1_] = _loc8_["Btn_Option"];
            this.FBtnOptionList[_loc1_].gotoAndStop(FRAME_UnSelect);
            this.FEnvelopeList[_loc1_] = _loc8_["MC_Envelope"];
            this.FEnvelopeList[_loc1_].gotoAndStop(FRAME_UnRead);
            this.FMCTreasureList[_loc1_] = _loc8_["MC_Treasure"];
            this.FTextNameList[_loc1_] = _loc8_["TF_PlayerName"];
            this.FTextTittleList[_loc1_] = _loc8_["TF_Tittle"];
            this.FTextTimeList[_loc1_] = _loc8_["TF_Time"];
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FBtn_WriteMail.addEventListener(MouseEvent.CLICK,this.ButtonWriteMailOnClick,false,0,true);
         _loc2_ = CAPACITY_Mails;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMailInfoList[_loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.MailInfoOnClick,false,0,true);
            _loc3_["Btn_Option"].addEventListener(MouseEvent.CLICK,this.ButtonOptionOnClick,false,0,true);
            _loc1_++;
         }
         this.FUIPage.OnChangePage = this.PageOnChange;
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateItem(param1:TMails) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TMail = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Date = null;
         var _loc10_:int = 0;
         _loc7_ = int(this.FTabIndex);
         _loc6_ = int(this.FPageIndex);
         _loc9_ = new Date();
         _loc3_ = uint(param1.Count);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_Mails)
         {
            if(this.FDictionary != null)
            {
               delete this.FDictionary[_loc2_];
            }
            _loc2_++;
         }
         this.FDictionary = null;
         this.FDictionary = new Dictionary(true);
         if(_loc3_ <= 0)
         {
            _loc2_ = 0;
            while(_loc2_ < CAPACITY_Mails)
            {
               this.FMailInfoList[_loc2_].visible = false;
               this.FBtnOptionList[_loc2_].visible = false;
               _loc2_++;
            }
            return;
         }
         _loc5_ = _loc6_ * CAPACITY_Mails;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_Mails)
         {
            this.FBtnOptionList[_loc2_].gotoAndStop(FRAME_UnSelect);
            this.FMailInfoList[_loc2_].gotoAndStop(FRAME_UnSelect);
            _loc8_ = _loc2_ + _loc5_;
            if(_loc8_ >= _loc3_)
            {
               this.FMailInfoList[_loc2_].visible = false;
               this.FBtnOptionList[_loc2_].visible = false;
            }
            else
            {
               this.FMailInfoList[_loc2_].visible = true;
               this.FBtnOptionList[_loc2_].visible = true;
               _loc4_ = param1.GetMailByIndex(_loc8_);
               this.FDictionary[this.FMailInfoList[_loc2_]] = _loc4_.SortIndex;
               this.FTextTittleList[_loc2_].text = _loc4_.Subject;
               _loc10_ = STimingCore.ServerTick - _loc4_.CreatTime;
               if(_loc10_ < 0)
               {
                  _loc10_ = 0;
               }
               this.FTextTimeList[_loc2_].text = this.TimeConvert(_loc10_);
               if(_loc4_.Type == TYPE_Inbox)
               {
                  this.FTextNameList[_loc2_].text = _loc4_.Name;
                  this.FEnvelopeList[_loc2_].gotoAndStop(_loc4_.HasRead + 1);
                  this.FEnvelopeList[_loc2_].visible = true;
                  this.FMCTreasureList[_loc2_].visible = _loc4_.AccessoryInventories.Count > 0;
               }
               else
               {
                  this.FTextNameList[_loc2_].text = _loc4_.Name;
                  this.FEnvelopeList[_loc2_].visible = false;
                  this.FMCTreasureList[_loc2_].visible = false;
               }
            }
            _loc2_++;
         }
      }
      
      protected function TimeConvert(param1:uint) : String
      {
         var _loc2_:uint = uint(param1 / 3600);
         var _loc3_:uint = uint(param1 / 60) % 60;
         var _loc4_:uint = param1 % 60;
         var _loc5_:uint = uint(_loc2_ / 24);
         var _loc6_:String = "";
         if(_loc5_ > 0)
         {
            _loc6_ = 15 - _loc5_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_04);
         }
         else if(_loc5_ <= 0)
         {
            _loc6_ = 15 + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_04);
         }
         return _loc6_;
      }
      
      protected function UpdateMailCapacity(param1:TMails) : void
      {
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = param1.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateMailType() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TMail = null;
         _loc2_ = uint(this.FMails.Count);
         this.FMails.Sort();
         this.FMailsInbox.Clear();
         this.FMailsSentbox.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMails.GetMailByIndex(_loc1_);
            switch(_loc3_.Type)
            {
               case TYPE_Inbox:
                  this.FMailsInbox.Add(_loc3_);
                  break;
               case TYPE_Sentbox:
                  this.FMailsSentbox.Add(_loc3_);
            }
            _loc1_++;
         }
      }
      
      protected function UpdateMailList() : void
      {
         var _loc1_:TMails = null;
         switch(this.FTabIndex)
         {
            case 0:
               _loc1_ = this.FMailsInbox;
               this.FTF_MailType.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_01);
               this.FBtn_ReceiveAccessory.Visible = true;
               break;
            case 1:
               _loc1_ = this.FMailsSentbox;
               this.FTF_MailType.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_02);
               this.FBtn_ReceiveAccessory.Visible = false;
         }
         this.FCurrentMails = _loc1_;
         this.UpdateMailCapacity(_loc1_);
         this.UpdateItem(_loc1_);
      }
      
      protected function CheckBtnOptionVisible() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = CAPACITY_Mails;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBtnOptionList[_loc1_];
            if(_loc3_.visible)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      protected function CheckBtnOptionSelect() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         _loc4_ = 0;
         _loc2_ = CAPACITY_Mails;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBtnOptionList[_loc1_];
            if(_loc3_.currentFrame == FRAME_Select)
            {
               _loc4_++;
            }
            _loc1_++;
         }
         if(_loc4_ == _loc2_)
         {
            return false;
         }
         return true;
      }
      
      protected function CheckBtnOptionIsSelected() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = CAPACITY_Mails;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBtnOptionList[_loc1_];
            if(_loc3_.currentFrame == FRAME_Select)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.UpdateMailList();
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Mail);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function ButtonWriteMailOnClick(param1:MouseEvent) : void
      {
         if(this.FOnOpenMailDetail != null)
         {
            this.FOnOpenMailDetail(this,2,UInt64.FromNumber(0));
         }
      }
      
      protected function ButtonAllSelectOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TSystemLanguage = null;
         var _loc6_:uint = 0;
         if(this.CheckBtnOptionVisible() == false)
         {
            _loc6_ = CONST_SYSTEMLANGUAGE.Mail_No_Mail;
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc6_) as TSystemLanguage;
            EffectGenerateText(_loc5_.Desc);
            return;
         }
         _loc4_ = CAPACITY_Mails;
         if(this.CheckBtnOptionSelect())
         {
            _loc3_ = 0;
            while(_loc3_ < CAPACITY_Mails)
            {
               this.FBtnOptionList[_loc3_].gotoAndStop(FRAME_Select);
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < CAPACITY_Mails)
            {
               this.FBtnOptionList[_loc3_].gotoAndStop(FRAME_UnSelect);
               _loc3_++;
            }
         }
      }
      
      protected function ButtonDeleteOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Vector.<UInt64> = null;
         var _loc8_:UInt64 = null;
         var _loc9_:TSystemLanguage = null;
         var _loc10_:uint = 0;
         _loc7_ = new Vector.<UInt64>();
         _loc4_ = CAPACITY_Mails;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FBtnOptionList[_loc3_];
            _loc8_ = this.FDictionary[this.FMailInfoList[_loc3_]];
            if(_loc5_.currentFrame == FRAME_Select)
            {
               if(_loc8_ != null)
               {
                  _loc7_.push(_loc8_);
               }
            }
            _loc3_++;
         }
         if(_loc7_.length <= 0)
         {
            _loc10_ = CONST_SYSTEMLANGUAGE.Mail_Delete_Mail;
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc10_) as TSystemLanguage;
            EffectGenerateText(_loc9_.Desc);
         }
         else
         {
            if(this.FOnDelete != null)
            {
               this.FOnDelete(this,_loc7_,this.FTabIndex + 1);
            }
            this.SetBtnLock(false);
         }
      }
      
      protected function ButtonReceiveAccessoryOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TMail = null;
         var _loc8_:Vector.<UInt64> = null;
         var _loc9_:UInt64 = null;
         var _loc10_:TSystemLanguage = null;
         var _loc11_:uint = 0;
         _loc8_ = new Vector.<UInt64>();
         _loc4_ = uint(this.FCurrentMails.Count);
         if(!this.CheckBtnOptionIsSelected())
         {
            _loc11_ = CONST_SYSTEMLANGUAGE.Mail_Null_Accessory;
            _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc11_) as TSystemLanguage;
            EffectGenerateText(_loc10_.Desc);
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_Mails)
         {
            _loc5_ = this.FBtnOptionList[_loc3_];
            if(this.FPageIndex * CAPACITY_Mails + _loc3_ >= _loc4_)
            {
               break;
            }
            _loc9_ = this.FDictionary[this.FMailInfoList[_loc3_]];
            _loc7_ = this.FCurrentMails.GetMailByIndex(this.FPageIndex * CAPACITY_Mails + _loc3_);
            if(_loc5_.currentFrame == FRAME_Select && _loc7_.AccessoryInventories.Count > 0)
            {
               if(_loc9_ != null)
               {
                  _loc8_.push(_loc9_);
               }
            }
            _loc3_++;
         }
         if(_loc8_.length <= 0)
         {
            _loc11_ = CONST_SYSTEMLANGUAGE.Mail_No_Accessory;
            _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc11_) as TSystemLanguage;
            EffectGenerateText(_loc10_.Desc);
         }
         else
         {
            if(this.FOnReceiveAccessory != null)
            {
               this.FOnReceiveAccessory(this,_loc8_);
            }
            this.SetBtnLock(false);
         }
      }
      
      protected function MailInfoOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:UInt64 = null;
         _loc4_ = param1.currentTarget as MovieClip;
         _loc3_ = CAPACITY_Mails;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FMailInfoList[_loc2_];
            if(_loc5_ != _loc4_)
            {
               _loc5_.gotoAndStop(FRAME_UnSelect);
            }
            _loc2_++;
         }
         _loc4_.gotoAndStop(FRAME_Select);
         _loc4_["MC_Envelope"].gotoAndStop(FRAME_Read);
         _loc6_ = this.FDictionary[_loc4_];
         this.FSortIndex = _loc6_;
         if(this.FOnOpenMailDetail != null)
         {
            this.FOnOpenMailDetail(this,this.FTabIndex,_loc6_);
         }
      }
      
      protected function ButtonOptionOnClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         param1.stopImmediatePropagation();
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(_loc2_.currentFrame % 2 + 1);
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         if(param2 == this.FPageIndex)
         {
            return;
         }
         this.FPageIndex = param2;
         this.UpdateItem(this.FCurrentMails);
      }
      
      public function get OnOpenMailDetail() : Function
      {
         return this.FOnOpenMailDetail;
      }
      
      public function set OnOpenMailDetail(param1:Function) : void
      {
         this.FOnOpenMailDetail = param1;
      }
      
      public function get OnDelete() : Function
      {
         return this.FOnDelete;
      }
      
      public function set OnDelete(param1:Function) : void
      {
         this.FOnDelete = param1;
      }
      
      public function get OnReceiveAccessory() : Function
      {
         return this.FOnReceiveAccessory;
      }
      
      public function set OnReceiveAccessory(param1:Function) : void
      {
         this.FOnReceiveAccessory = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function Update() : void
      {
         this.UpdateMailType();
         this.UpdateMailList();
      }
      
      public function PlayEffect() : void
      {
         this.FMC_EffectLeft.play();
         this.FMC_EffectRight.play();
      }
      
      public function SetBtnLock(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         _loc3_ = this.FBtnList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FBtnList[_loc2_];
            _loc4_.Enabled = param1;
            _loc2_++;
         }
      }
      
      public function ResetMail() : void
      {
         this.FUITab.SwithTagManual(0);
      }
   }
}

