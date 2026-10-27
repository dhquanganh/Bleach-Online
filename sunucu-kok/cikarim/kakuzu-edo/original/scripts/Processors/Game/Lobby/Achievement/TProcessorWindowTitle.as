package Processors.Game.Lobby.Achievement
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.*;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowTitle extends TProcessorLobbyWindow
   {
      
      protected static const FormatString:String = "%0<font color=\'%1\'>(%2/%3)</font>\n";
      
      protected static const ATTRIBUTE_NUM:int = 4;
      
      protected static const FREAMINDEX_OVERTIME:int = 1;
      
      protected static const FREAMINDEX_DURATION:int = 2;
      
      protected static const FREAMINDEX_NEW:int = 3;
      
      protected var TABNUM:int = 6;
      
      protected var FUITab:TUITab;
      
      protected var FScrollbar:TScrollBar;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FTitleItemsIdle:Vector.<MovieClip>;
      
      protected var FTitleItemsUsing:Vector.<MovieClip>;
      
      protected var FCurrentTabIndex:int;
      
      protected var FCurrentShowTitles:TTitles;
      
      protected var FAlreadyGetTitles:TTitles;
      
      protected var FTF_PreName:TextField;
      
      protected var FTF_PreAttributeArea:TextField;
      
      protected var FMC_PreTitleStateFlag:MovieClip;
      
      protected var FTF_PreAttrbuteAre:Vector.<TextField>;
      
      protected var FTF_PreAttrbuteName:Vector.<TextField>;
      
      protected var FTF_PreAttrbuteValue:Vector.<TextField>;
      
      protected var FTF_PreTitleCondition:TextField;
      
      protected var FTF_PreLastTime:TextField;
      
      protected var FCompleteFlag:Sprite;
      
      protected var FBtnEquipTitle:TUIButton;
      
      protected var FBtnCancleTitle:TUIButton;
      
      protected var FPreViewUI:Sprite;
      
      protected var FViewBoard:Sprite;
      
      protected var FBtnPreView:MovieClip;
      
      protected var FPicMount:Sprite;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FTitleAnimationSequence:TAnimationSequence;
      
      protected var FIfShowTitle:Boolean;
      
      protected var FTimeStore:int;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FPreTitle:TTitle;
      
      protected var FTF_CurrentName:TextField;
      
      protected var FTF_CurrentAttributeArea:TextField;
      
      protected var FMC_CurrentTitleStateFlag:MovieClip;
      
      protected var FTF_CurrentAttrbuteAre:Vector.<TextField>;
      
      protected var FTF_CurrentAttrbuteName:Vector.<TextField>;
      
      protected var FTF_CurrentAttrbuteValue:Vector.<TextField>;
      
      protected var FTF_CurrentLastTime:TextField;
      
      protected var FCurrentTitle:TTitle;
      
      protected var FAttributeNames:Vector.<String>;
      
      protected var FAchievementTitles:Vector.<TTitles>;
      
      public function TProcessorWindowTitle(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateLimitTime(this.FTF_CurrentLastTime,this.FCurrentTitle);
            this.UpdateLimitTime(this.FTF_PreLastTime,this.FPreTitle);
            this.FRoleMoudle.UpdateView();
            if(this.FIfShowTitle)
            {
               this.UpdateTitle();
            }
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("AchievementTitle") as Sprite;
         addChild(_loc1_);
         this.UIDispatch_Tab(_loc1_);
         this.UIDispatch_PreView(_loc1_);
         this.UIDispatch_CurrentTitle(_loc1_);
         this.FAttributeNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_09);
      }
      
      protected function UIDispatch_Tab(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         this.FBtnClose = param1["Board"]["Btn_Close"];
         this.FUITab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < this.TABNUM)
         {
            this.FUITab.SetTabByIndex(param1["Tab_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.SwitchTab;
         this.FUITab.Init();
         this.FScrollbar = new TScrollBar(param1["ScroolBar"]["mc_list"],325,false,1,20);
         this.FAlreadyGetTitles = new TTitles();
         this.FTitleItemsIdle = new Vector.<MovieClip>();
         this.FTitleItemsUsing = new Vector.<MovieClip>();
      }
      
      protected function UIDispatch_PreView(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.FTF_PreAttrbuteAre = new Vector.<TextField>();
         this.FTF_PreAttrbuteName = new Vector.<TextField>();
         this.FTF_PreAttrbuteValue = new Vector.<TextField>();
         this.FTF_PreName = param1["PreName"]["Name"];
         this.FTF_PreAttributeArea = param1["PreAttribute0"]["Area"];
         this.FMC_PreTitleStateFlag = param1["PreName"]["TitleStateFlag"];
         this.FTF_PreTitleCondition = param1["PreTitleCondition"];
         this.FTF_PreLastTime = param1["PreLastTime"];
         this.FCompleteFlag = param1["CompleteFlag"];
         this.FBtnEquipTitle = new TUIButton();
         this.FBtnEquipTitle.Substrate = param1["EquipTitle"];
         this.FBtnEquipTitle.OnClick = this.BtnEquipTitleOnClick;
         this.FBtnCancleTitle = new TUIButton();
         this.FBtnCancleTitle.Substrate = param1["CancleTitle"];
         this.FBtnCancleTitle.OnClick = this.BtnCancleTitleOnClick;
         this.FPreViewUI = param1["PreViewUI"];
         this.FViewBoard = this.FPreViewUI["MoudleView"];
         this.FBtnPreView = this.FPreViewUI["ShowTitleMoudle"];
         this.FPicMount = this.FPreViewUI["MoudleView"]["MoudleMountPoint"];
         _loc2_ = 0;
         while(_loc2_ < ATTRIBUTE_NUM)
         {
            _loc3_ = param1["PreAttribute" + _loc2_];
            this.FTF_PreAttrbuteAre.push(_loc3_["Area"]);
            this.FTF_PreAttrbuteName.push(_loc3_["AttributeName"]);
            this.FTF_PreAttrbuteValue.push(_loc3_["AttributeValue"]);
            _loc2_++;
         }
         this.FQueryModel = new TMoudleInfor();
      }
      
      protected function UIDispatch_CurrentTitle(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.FTF_CurrentAttrbuteAre = new Vector.<TextField>();
         this.FTF_CurrentAttrbuteName = new Vector.<TextField>();
         this.FTF_CurrentAttrbuteValue = new Vector.<TextField>();
         this.FTF_CurrentName = param1["CurrentName"]["Name"];
         this.FTF_CurrentAttributeArea = param1["CurrentAttribute0"]["Area"];
         this.FMC_CurrentTitleStateFlag = param1["CurrentName"]["TitleStateFlag"];
         this.FTF_CurrentLastTime = param1["CurrentLastTime"];
         _loc2_ = 0;
         while(_loc2_ < ATTRIBUTE_NUM)
         {
            _loc3_ = param1["CurrentAttribute" + _loc2_];
            this.FTF_CurrentAttrbuteAre.push(_loc3_["Area"]);
            this.FTF_CurrentAttrbuteName.push(_loc3_["AttributeName"]);
            this.FTF_CurrentAttrbuteValue.push(_loc3_["AttributeValue"]);
            _loc2_++;
         }
      }
      
      public function UILocations() : void
      {
         var _loc1_:THero = null;
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         _loc1_ = SLogicsCore.Character.Heros.GetHeroByIndex(0);
         this.FRoleMoudle = new TSceneSpriteMoudle();
         this.FRoleMoudle.RoleTempleteID = _loc1_.Identifier;
         this.FPicMount.addChild(this.FRoleMoudle);
         this.FPicMountPoint = new Bitmap();
         this.FPicMount.addChild(this.FPicMountPoint);
         this.FPreViewUI.visible = false;
         this.FBtnPreView.addEventListener(MouseEvent.MOUSE_OVER,this.FBtnPreViewOnMouseOver);
         this.FBtnPreView.addEventListener(MouseEvent.MOUSE_OUT,this.FBtnPreViewOnMouseOut);
         this.FCurrentTabIndex = 0;
      }
      
      protected function TabUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TTitle = null;
         var _loc5_:MovieClip = null;
         if(this.FCurrentTabIndex == 0)
         {
            this.FCurrentShowTitles = this.FAlreadyGetTitles;
         }
         else
         {
            this.FCurrentShowTitles = this.FAchievementTitles[this.FCurrentTabIndex - 1];
         }
         this.ReleaseScroolBar();
         _loc2_ = this.FCurrentShowTitles.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FCurrentShowTitles.GetTitleByIndex(_loc1_);
            _loc5_ = this.GetTitleItem();
            this.FScrollbar.AddItem(_loc5_);
            this.SetupListItemState(_loc4_,_loc5_);
            this.FTitleItemsUsing.push(_loc5_);
            _loc5_["Name"].text = _loc4_.Name;
            if(_loc4_.IfGetTitle)
            {
               _loc5_["Name"].textColor = CONST_COMMON.TEXT_Green_Color;
            }
            else
            {
               _loc5_["Name"].textColor = CONST_COMMON.TEXT_Gray_Color;
            }
            _loc5_["Effect"].visible = _loc4_.IfNew;
            if(_loc4_.IfNew)
            {
               _loc5_["Effect"].play();
            }
            _loc5_["Star"]["Star"].text = _loc4_.LevelTitle.toString();
            _loc5_ = _loc5_["Flag"];
            _loc5_.visible = true;
            if(_loc4_.IfOverTime)
            {
               _loc5_.gotoAndStop(FREAMINDEX_OVERTIME);
            }
            else if(_loc4_.IfNew)
            {
               _loc5_.gotoAndStop(FREAMINDEX_NEW);
            }
            else if(_loc4_.IfGetTitle && _loc4_.IfTimeLimit)
            {
               _loc5_.gotoAndStop(FREAMINDEX_DURATION);
            }
            else
            {
               _loc5_.visible = false;
            }
            _loc4_.IfNew = false;
            _loc1_++;
         }
      }
      
      protected function PreTitleUpdate() : void
      {
         var _loc1_:String = null;
         var _loc2_:TAchievementSchedule = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = Number(NaN);
         var _loc7_:TTitle = null;
         var _loc8_:int = 0;
         this.FPreViewUI.visible = false;
         if(this.FPreTitle == null)
         {
            this.ClearPreTitle();
            return;
         }
         this.FPreViewUI.visible = true;
         this.FViewBoard.visible = false;
         this.FTF_PreName.text = this.FPreTitle.Name;
         if(this.FPreTitle.IfGetTitle)
         {
            this.FTF_PreName.textColor = CONST_COMMON.TEXT_Yellow_Color;
         }
         else
         {
            this.FTF_PreName.textColor = CONST_COMMON.TEXT_Gray_Color;
         }
         this.FTF_PreAttributeArea.text = this.FAttributeNames[this.FPreTitle.DepPosition - 1];
         if(this.FPreTitle.IfGetTitle)
         {
            this.FMC_PreTitleStateFlag.gotoAndStop(1);
         }
         else
         {
            this.FMC_PreTitleStateFlag.gotoAndStop(2);
         }
         this.FCompleteFlag.visible = this.FPreTitle.AchievementInfor.IfComplete;
         _loc1_ = "";
         _loc4_ = 0;
         while(_loc4_ < this.FPreTitle.AchievementInfor.AchievementSchedules.length)
         {
            _loc2_ = this.FPreTitle.AchievementInfor.AchievementSchedules[_loc4_];
            if(_loc2_.CurrentSchedule >= _loc2_.Value)
            {
               _loc3_ = CONST_COMMON.HTMLCOLOR_Green;
            }
            else
            {
               _loc3_ = CONST_COMMON.HTMLCOLOR_Red;
            }
            _loc1_ += TUtilityString.Format(FormatString,_loc2_.ConditionStrings,_loc3_,_loc2_.CurrentSchedule,_loc2_.Value);
            _loc4_++;
         }
         this.FTF_PreTitleCondition.htmlText = _loc1_;
         _loc4_ = 0;
         while(_loc4_ < this.FPreTitle.TitleAttributeValue.length)
         {
            _loc5_ = this.FPreTitle.TitleAttributeType[_loc4_];
            _loc6_ = this.FPreTitle.TitleAttributeValue[_loc4_];
            this.FTF_PreAttrbuteName[_loc4_].text = this.CreateAddAttributeName(_loc5_);
            this.FTF_PreAttrbuteValue[_loc4_].text = this.CreateAddAttributeValue(_loc6_);
            _loc4_++;
         }
         while(_loc4_ < ATTRIBUTE_NUM)
         {
            this.FTF_PreAttrbuteName[_loc4_].text = "";
            this.FTF_PreAttrbuteValue[_loc4_].text = "";
            _loc4_++;
         }
         this.FBtnEquipTitle.Enabled = this.FPreTitle.AchievementInfor.IfComplete && this.FPreTitle.IfGetTitle && !this.FPreTitle.IfOverTime;
         this.FBtnEquipTitle.Visible = true;
         this.FBtnCancleTitle.Visible = false;
         _loc8_ = int(SLogicsCore.Character.CurrentEquipTitles.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc7_ = SLogicsCore.Character.CurrentEquipTitles.GetTitleByIndex(_loc4_);
            if(_loc7_ == this.FPreTitle)
            {
               this.FBtnCancleTitle.Visible = true;
               this.FBtnEquipTitle.Visible = false;
            }
            _loc4_++;
         }
      }
      
      protected function UpdateTitle() : void
      {
         if(this.FTitleAnimationSequence != null)
         {
            this.FPicMountPoint.bitmapData = this.FTitleAnimationSequence.GetAnimationFrameByTick(this.FTimeStore).Surface;
            this.FTimeStore += CONST_COMMON.SIZE_FrameRatePerSecond;
         }
      }
      
      protected function ClearPreTitle() : void
      {
         var _loc1_:int = 0;
         this.FTF_PreName.text = "";
         _loc1_ = 0;
         while(_loc1_ < ATTRIBUTE_NUM)
         {
            this.FTF_PreAttrbuteAre[_loc1_].text = "";
            this.FTF_PreAttrbuteName[_loc1_].text = "";
            this.FTF_PreAttrbuteValue[_loc1_].text = "";
            _loc1_++;
         }
         this.FTF_PreTitleCondition.text = "";
         this.FTF_PreLastTime.text = "";
         this.FCompleteFlag.visible = false;
         this.FBtnEquipTitle.Enabled = false;
      }
      
      protected function CreateAddAttributeName(param1:int) : String
      {
         var _loc2_:TStarPointDesc = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,17500000 + param1) as TStarPointDesc;
         return _loc2_.Desc;
      }
      
      protected function CreateAddAttributeValue(param1:Number) : String
      {
         var _loc2_:Number = Number(NaN);
         if(param1 < 1)
         {
            _loc2_ = param1 * 100;
            return "+" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_0),_loc2_.toString());
         }
         return "+" + int(param1);
      }
      
      protected function CurrentTitleUpdate() : void
      {
         var _loc1_:String = null;
         var _loc2_:TAchievementSchedule = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = Number(NaN);
         this.FCurrentTitle = this.GetTitleByTypeID(SLogicsCore.Character.CurrentEquipTitles,CONST_ACHIEVEMENT.AchievmentTitleGroupType);
         if(this.FCurrentTitle == null)
         {
            this.ClearCurrentTitle();
            return;
         }
         this.FTF_CurrentName.text = this.FCurrentTitle.Name;
         this.FTF_CurrentAttributeArea.text = this.FAttributeNames[this.FCurrentTitle.DepPosition - 1];
         _loc4_ = 0;
         while(_loc4_ < this.FCurrentTitle.TitleAttributeValue.length)
         {
            _loc5_ = this.FCurrentTitle.TitleAttributeType[_loc4_];
            _loc6_ = this.FCurrentTitle.TitleAttributeValue[_loc4_];
            this.FTF_CurrentAttrbuteName[_loc4_].text = this.CreateAddAttributeName(_loc5_);
            this.FTF_CurrentAttrbuteValue[_loc4_].text = this.CreateAddAttributeValue(_loc6_);
            _loc4_++;
         }
         while(_loc4_ < ATTRIBUTE_NUM)
         {
            this.FTF_CurrentAttrbuteName[_loc4_].text = "";
            this.FTF_CurrentAttrbuteValue[_loc4_].text = "";
            _loc4_++;
         }
      }
      
      protected function UpdateLimitTime(param1:TextField, param2:TTitle) : void
      {
         var _loc3_:int = 0;
         if(param2 != null)
         {
            if(!param2.IfTimeLimit)
            {
               param1.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_08);
            }
            else
            {
               _loc3_ = Math.max(0,param2.TargetTime - Number(STimingCore.ServerTick));
               if(_loc3_ <= 0)
               {
                  param2.IfOverTime = true;
                  param1.text = "Expired";
               }
               else
               {
                  param1.text = TUtilityTiming.fomatTime(_loc3_);
               }
            }
         }
         else
         {
            param1.text = "";
         }
      }
      
      protected function ClearCurrentTitle() : void
      {
         var _loc1_:int = 0;
         this.FTF_CurrentName.text = "";
         _loc1_ = 0;
         while(_loc1_ < ATTRIBUTE_NUM)
         {
            this.FTF_CurrentAttrbuteAre[_loc1_].text = "";
            this.FTF_CurrentAttrbuteName[_loc1_].text = "";
            this.FTF_CurrentAttrbuteValue[_loc1_].text = "";
            _loc1_++;
         }
         this.FTF_CurrentLastTime.text = "";
      }
      
      protected function GetTitleItem() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(this.FTitleItemsIdle.length != 0)
         {
            _loc1_ = this.FTitleItemsIdle.pop();
         }
         else
         {
            _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("TitleListItem") as MovieClip;
            _loc1_.buttonMode = true;
            _loc1_.mouseChildren = false;
            _loc1_.addEventListener(MouseEvent.CLICK,this.ScroolBarItemOnClick);
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.ScroolBarItemOnMouseOver);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.ScroolBarItemOnMouseOut);
         }
         return _loc1_;
      }
      
      protected function ReleaseScroolBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FTitleItemsUsing.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTitleItemsIdle.push(this.FTitleItemsUsing[_loc1_]);
            _loc3_ = this.FTitleItemsUsing[_loc1_]["Effect"];
            _loc3_.gotoAndStop(1);
            _loc1_++;
         }
         this.FTitleItemsUsing.length = 0;
         this.FScrollbar.Clear();
      }
      
      protected function FliterAlreadyGetTitels() : void
      {
         var _loc1_:TAchievementInfors = null;
         var _loc2_:TAchievementInfor = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = SLogicsCore.Character.AchievementData;
         this.FAlreadyGetTitles.Clear();
         _loc4_ = _loc1_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc1_.GetAchievementByIndex(_loc3_);
            if(_loc2_.Title != null && _loc2_.Title.IfGetTitle)
            {
               this.FAlreadyGetTitles.Add(_loc2_.Title);
            }
            _loc3_++;
         }
      }
      
      protected function GetTitleByTypeID(param1:TTitles, param2:uint) : TTitle
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTitle = null;
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GetTitleByIndex(_loc3_);
            if(_loc5_.TitleTypeGroup == param2)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:TAnimationFrame = null;
         if(this.FPreTitle != null && param3 == this.FPreTitle.ID)
         {
            this.FTitleAnimationSequence = param2.GetAnimationSequenceByIndex(0);
            _loc4_ = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0);
            this.FPicMountPoint.x = -_loc4_.Pivot.X;
            this.FPicMountPoint.y = -(this.FRoleMoudle.height + _loc4_.Surface.height);
         }
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         this.Reset();
         ProcessorWindowClose();
      }
      
      protected function BtnEquipTitleOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_EquipAchievenmentTitleRep);
         _loc3_.Data.writeUnsignedInt(this.FPreTitle.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCancleTitleOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = 0;
         var _loc6_:TTitle = null;
         _loc5_ = this.FAchievementTitles[0].GetTitleByIndex(0).TitleTypeGroup;
         _loc6_ = this.GetTitleByTypeID(SLogicsCore.Character.CurrentEquipTitles,_loc5_);
         if(_loc6_ != null)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CancleAchievenmentTitleRep);
            _loc3_.Data.writeUnsignedInt(_loc6_.ID);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
      }
      
      protected function SwitchTab(param1:int) : void
      {
         this.FCurrentTabIndex = param1;
         this.Update();
      }
      
      protected function SetupListItemState(param1:TTitle, param2:MovieClip) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:TTitles = null;
         _loc5_ = SLogicsCore.Character.CurrentEquipTitles;
         _loc3_ = false;
         _loc4_ = 0;
         while(_loc4_ < _loc5_.Count)
         {
            if(param1 == _loc5_.GetTitleByIndex(_loc4_))
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            param2.gotoAndStop(4);
         }
         else
         {
            param2.gotoAndStop(1);
         }
      }
      
      protected function ScroolBarItemOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(2);
      }
      
      protected function ScroolBarItemOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTitle = null;
         var _loc4_:MovieClip = null;
         _loc4_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FTitleItemsUsing.indexOf(_loc4_);
         _loc3_ = this.FCurrentShowTitles.GetTitleByIndex(_loc2_);
         if(_loc3_ == this.FPreTitle)
         {
            return;
         }
         this.SetupListItemState(_loc3_,_loc4_);
      }
      
      protected function ScroolBarItemOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTitle = null;
         var _loc4_:MovieClip = null;
         _loc4_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FTitleItemsUsing.indexOf(_loc4_);
         _loc3_ = this.FCurrentShowTitles.GetTitleByIndex(_loc2_);
         _loc2_ = 0;
         while(_loc2_ < this.FTitleItemsUsing.length)
         {
            this.SetupListItemState(this.FCurrentShowTitles.GetTitleByIndex(_loc2_),this.FTitleItemsUsing[_loc2_]);
            _loc2_++;
         }
         _loc4_.gotoAndStop(4);
         this.FPreTitle = _loc3_;
         this.PreTitleUpdate();
      }
      
      protected function FBtnPreViewOnMouseOver(param1:MouseEvent) : void
      {
         this.FBtnPreView.gotoAndStop(2);
         this.FIfShowTitle = true;
         this.FPicMountPoint.bitmapData = null;
         this.FTitleAnimationSequence = null;
         this.FViewBoard.visible = true;
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FRoleMoudle.RoleTempleteID,this.FQueryModel);
         this.FRoleMoudle.ChangeRoleMoudle(this.FQueryModel.TextureID,1);
         SResourcesCore.TexturesAchievementTitle.LoadAutoSecondary(this.FPreTitle.ID,this.CallBack_PicArrive);
      }
      
      protected function FBtnPreViewOnMouseOut(param1:MouseEvent) : void
      {
         this.FBtnPreView.gotoAndStop(1);
         this.FViewBoard.visible = false;
         this.FIfShowTitle = false;
      }
      
      public function set AchievementTitles(param1:Vector.<TTitles>) : void
      {
         this.FAchievementTitles = param1;
      }
      
      public function Update() : void
      {
         if(FIsResourcesLoadCompleted)
         {
            this.FliterAlreadyGetTitels();
            this.TabUpdate();
            this.PreTitleUpdate();
            this.CurrentTitleUpdate();
         }
      }
      
      public function Init() : void
      {
         this.UIDispatch();
         this.UILocations();
         FIsResourcesLoadCompleted = true;
      }
      
      public function Reset() : void
      {
         this.FUITab.SwithTagManual(0);
         this.ClearCurrentTitle();
         this.ClearPreTitle();
         this.FCurrentShowTitles = null;
         this.FPreTitle = null;
         this.FCurrentTitle = null;
         this.FPicMountPoint.bitmapData = null;
         this.FTitleAnimationSequence = null;
         this.FRoleMoudle.ReleaseModuleResource();
         SResourcesCore.TexturesModel.DeleteByIdentifier(CONST_ROLE.GetModelIDByIndex(SLogicsCore.Character.Heros.GetHeroByIndex(0).Identifier,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase));
      }
   }
}

