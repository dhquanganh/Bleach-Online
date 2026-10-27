package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTrain extends TProcessorLobbyWindow
   {
      
      public static const WindowTrainWidth:int = 516;
      
      public static const WindowTrainHeight:int = 411;
      
      protected static const SoulID:int = 14100021;
      
      protected var FTF_Level:TextField;
      
      protected var FMC_Pic:MovieClip;
      
      protected var FBitMap_PicMountPoint:Bitmap;
      
      protected var FTF_KnifeSoulLevel:TextField;
      
      protected var FTF_NeedKnifeSoulLevel:TextField;
      
      protected var FTF_SoulNum:TextField;
      
      protected var FTF_FindSoul:TextField;
      
      protected var FMC_StarLevel:MovieClip;
      
      protected var FBaseInfor:MovieClip;
      
      protected var FTF_CurrentLevelName:TextField;
      
      protected var FTF_CurrentKnifeSoulAdded:TextField;
      
      protected var FTF_CurrentSkillName:TextField;
      
      protected var FTF_CurrentAddedFrontNames:Vector.<TextField>;
      
      protected var FTF_CurrentAddedFrontValues:Vector.<TextField>;
      
      protected var FTF_CurrentAddedMiddleNames:Vector.<TextField>;
      
      protected var FTF_CurrentAddedMiddleValues:Vector.<TextField>;
      
      protected var FTF_CurrentAddedBackNames:Vector.<TextField>;
      
      protected var FTF_CurrentAddedBackValues:Vector.<TextField>;
      
      protected var FTF_NextLevelName:TextField;
      
      protected var FTF_NextKnifeSoulAdded:TextField;
      
      protected var FTF_NextSkillName:TextField;
      
      protected var FTF_NextAddedFrontNames:Vector.<TextField>;
      
      protected var FTF_NextAddedFrontValues:Vector.<TextField>;
      
      protected var FTF_NextAddedMiddleNames:Vector.<TextField>;
      
      protected var FTF_NextAddedMiddleValues:Vector.<TextField>;
      
      protected var FTF_NextAddedBackNames:Vector.<TextField>;
      
      protected var FTF_NextAddedBackValues:Vector.<TextField>;
      
      protected var FTF_ExpLevelName:TextField;
      
      protected var FMC_ExpBar:MovieClip;
      
      protected var FTF_ExpNum:TextField;
      
      protected var FBtn_SoulTrain:TUIButton;
      
      protected var FBtn_OneKeySoulTrain:TUIButton;
      
      protected var FBtn_GoldTrain:TUIButton;
      
      protected var FBtn_OneKeyGoldTrain:TUIButton;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FGoldTrainAsk:Boolean;
      
      protected var FOneKeyGoldTrainAsk:Boolean;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FHint:THint;
      
      protected var FToolKnifeData:TKnifeOfKillSoulData;
      
      protected var FUIWindowInputNum:TUIWindowInputNum;
      
      protected var FKnifeLevelName:Vector.<String>;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FOnClickClose:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnShortcutHyperlinks:Function;
      
      public function TProcessorWindowTrain(param1:TUIComponent)
      {
         super(param1);
         this.FToolKnifeData = new TKnifeOfKillSoulData();
         this.FHint = new THint();
      }
      
      protected function UIDispatch_Perform() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("TrainBorad") as MovieClip;
         addChild(_loc1_);
         this.UIDispatchBaseInfor(_loc1_);
         this.UIDispatchAttribute(_loc1_);
         this.UIDispatchExpBar(_loc1_);
         this.UIDispatchBtn(_loc1_);
         this.UIDispatchTool();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_KnifeOfKillSoulTrainView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_KnifeOfKillSoulTrainView,FParent);
      }
      
      protected function UILocation_Perform() : void
      {
         this.UILocationBaseInfor();
         this.UILocationAttribute();
         this.UILocationExpBar();
         this.UILocationBtn();
         this.UILocationTool();
      }
      
      protected function UIDispatchBaseInfor(param1:MovieClip) : void
      {
         this.FBaseInfor = param1["KnifeBaseInfor"];
         this.FTF_Level = this.FBaseInfor["Level"];
         this.FMC_Pic = this.FBaseInfor["KnifePic"];
         this.FBitMap_PicMountPoint = new Bitmap();
         this.FMC_Pic["MountPoint"].addChild(this.FBitMap_PicMountPoint);
         this.FMC_StarLevel = this.FBaseInfor["StarLevel"];
         this.FTF_KnifeSoulLevel = param1["KnifeSoulLevel"];
         this.FTF_NeedKnifeSoulLevel = param1["NeedKnifesoulLevel"];
         this.FTF_SoulNum = param1["SoulNum"];
         this.FTF_FindSoul = param1["KnifeBaseInfor"]["FindSoul"];
         this.FKnifeLevelName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_3);
      }
      
      protected function UILocationBaseInfor() : void
      {
         this.FTF_CurrentSkillName.addEventListener(MouseEvent.MOUSE_OVER,this.CurrentSkillOnOver);
         this.FTF_CurrentSkillName.addEventListener(MouseEvent.MOUSE_OUT,this.HitOnOut);
         this.FTF_NextSkillName.addEventListener(MouseEvent.MOUSE_OVER,this.NextSkillOnOver);
         this.FTF_NextSkillName.addEventListener(MouseEvent.MOUSE_OUT,this.HitOnOut);
         this.FTF_FindSoul.addEventListener(TextEvent.LINK,this.LinkFindSoulClicked);
         this.FTF_FindSoul.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_27);
      }
      
      protected function UpdateBaseInfor() : void
      {
         var _loc1_:TCharacter = null;
         _loc1_ = SLogicsCore.Character;
         this.FBaseInfor.gotoAndStop(this.FKnifeData.Type);
         this.FTF_Level.text = this.FKnifeLevelName[this.FKnifeData.Level - 1];
         this.FMC_Pic.gotoAndStop("N_" + this.FKnifeData.RelationID);
         this.FTF_KnifeSoulLevel.text = "LV." + _loc1_.KnifeSoul.Level;
         this.FBitMap_PicMountPoint.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FKnifeData.ID,this.ResourceSendInterface);
         this.FMC_StarLevel.gotoAndStop(this.FKnifeData.Appraise);
         if(this.FKnifeData.Level != CONST_KNIFEOFKILLSOUL.KnifeMaxLevel)
         {
            this.FTF_NeedKnifeSoulLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_19),this.FKnifeLevelName[this.FToolKnifeData.Level - 1],this.FToolKnifeData.NeedKnifeSoulLevel + "");
         }
         else
         {
            this.FTF_NeedKnifeSoulLevel.text = "";
         }
         this.FTF_SoulNum.text = _loc1_.Appliances.GetCountByTempleteID(SoulID).toString();
      }
      
      protected function ResourceSendInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FKnifeData.ID)
         {
            this.FBitMap_PicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function CurrentSkillOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TSkillConfig = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FHint.Caption = _loc2_.Desc;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function NextSkillOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TSkillConfig = null;
         if(this.FKnifeData.Level >= CONST_KNIFEOFKILLSOUL.KnifeMaxLevel)
         {
            return;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FToolKnifeData.SkillID) as TSkillConfig;
         this.FHint.Caption = _loc2_.Desc;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function HitOnOut(param1:Object, param2:MouseEvent = null) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function LinkFindSoulClicked(param1:TextEvent) : void
      {
         this.CloseBtnClick();
         if(this.FOnShortcutHyperlinks != null)
         {
            this.FOnShortcutHyperlinks(this);
         }
      }
      
      protected function UIDispatchAttribute(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         this.FTF_CurrentAddedFrontNames = new Vector.<TextField>();
         this.FTF_CurrentAddedFrontValues = new Vector.<TextField>();
         this.FTF_CurrentAddedMiddleNames = new Vector.<TextField>();
         this.FTF_CurrentAddedMiddleValues = new Vector.<TextField>();
         this.FTF_CurrentAddedBackNames = new Vector.<TextField>();
         this.FTF_CurrentAddedBackValues = new Vector.<TextField>();
         this.FTF_NextAddedFrontNames = new Vector.<TextField>();
         this.FTF_NextAddedFrontValues = new Vector.<TextField>();
         this.FTF_NextAddedMiddleNames = new Vector.<TextField>();
         this.FTF_NextAddedMiddleValues = new Vector.<TextField>();
         this.FTF_NextAddedBackNames = new Vector.<TextField>();
         this.FTF_NextAddedBackValues = new Vector.<TextField>();
         this.FTF_CurrentLevelName = param1["CurrentName"];
         this.FTF_CurrentKnifeSoulAdded = param1["CurrentKnifeSoulAdded"];
         this.FTF_CurrentSkillName = param1["CurrentSkillName"];
         this.FTF_NextLevelName = param1["NextName"];
         this.FTF_NextKnifeSoulAdded = param1["NextKnifeSoulAdded"];
         this.FTF_NextSkillName = param1["NextSkillName"];
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            this.FTF_CurrentAddedFrontNames.push(param1["CurrentAddedName" + _loc2_]);
            this.FTF_CurrentAddedFrontValues.push(param1["CurrentAddedValue" + _loc2_]);
            this.FTF_NextAddedFrontNames.push(param1["NextAddedName" + _loc2_]);
            this.FTF_NextAddedFrontValues.push(param1["NextAddedValue" + _loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            this.FTF_CurrentAddedMiddleNames.push(param1["CurrentMiddleAddedName" + _loc2_]);
            this.FTF_CurrentAddedMiddleValues.push(param1["CurrentMiddleAddedValue" + _loc2_]);
            this.FTF_NextAddedMiddleNames.push(param1["NextMiddleAddedName" + _loc2_]);
            this.FTF_NextAddedMiddleValues.push(param1["NextMiddleAddedValue" + _loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            this.FTF_CurrentAddedBackNames.push(param1["CurrentBackAddedName" + _loc2_]);
            this.FTF_CurrentAddedBackValues.push(param1["CurrentBackAddedValue" + _loc2_]);
            this.FTF_NextAddedBackNames.push(param1["NextBackAddedName" + _loc2_]);
            this.FTF_NextAddedBackValues.push(param1["NextBackAddedValue" + _loc2_]);
            _loc2_++;
         }
      }
      
      protected function UILocationAttribute() : void
      {
      }
      
      protected function UpdateAttribute() : void
      {
         var _loc1_:TSkillConfig = null;
         this.FTF_CurrentLevelName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_18),this.FKnifeLevelName[this.FKnifeData.Level - 1]);
         this.FTF_CurrentKnifeSoulAdded.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),this.FKnifeData.KnifeSoulAdded);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FTF_CurrentSkillName.text = _loc1_.Name;
         this.FlushAttributeAdded(this.FTF_CurrentAddedFrontNames,this.FTF_CurrentAddedFrontValues,this.FKnifeData.AddedFront);
         this.FlushAttributeAdded(this.FTF_CurrentAddedMiddleNames,this.FTF_CurrentAddedMiddleValues,this.FKnifeData.AddedMiddle);
         this.FlushAttributeAdded(this.FTF_CurrentAddedBackNames,this.FTF_CurrentAddedBackValues,this.FKnifeData.AddedBack);
         if(this.FKnifeData.Level != CONST_KNIFEOFKILLSOUL.KnifeMaxLevel)
         {
            this.FToolKnifeData.ID = this.FKnifeData.ID + 1;
            this.AssignKnifeData(this.FToolKnifeData);
            this.FTF_NextLevelName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_18),this.FKnifeLevelName[this.FToolKnifeData.Level - 1]);
            this.FTF_NextKnifeSoulAdded.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),this.FToolKnifeData.KnifeSoulAdded);
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FToolKnifeData.SkillID) as TSkillConfig;
            this.FTF_NextSkillName.text = _loc1_.Name;
            this.FlushAttributeAdded(this.FTF_NextAddedFrontNames,this.FTF_NextAddedFrontValues,this.FToolKnifeData.AddedFront);
            this.FlushAttributeAdded(this.FTF_NextAddedMiddleNames,this.FTF_NextAddedMiddleValues,this.FToolKnifeData.AddedMiddle);
            this.FlushAttributeAdded(this.FTF_NextAddedBackNames,this.FTF_NextAddedBackValues,this.FToolKnifeData.AddedBack);
         }
         else
         {
            this.FTF_NextLevelName.text = "";
            this.FTF_NextKnifeSoulAdded.text = "";
            this.FTF_NextSkillName.text = "";
            this.ClearTextFields(this.FTF_NextAddedFrontValues);
            this.ClearTextFields(this.FTF_NextAddedMiddleValues);
            this.ClearTextFields(this.FTF_NextAddedBackValues);
         }
      }
      
      protected function ClearTextFields(param1:Vector.<TextField>) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_].text = "";
            _loc2_++;
         }
      }
      
      protected function FlushAttributeAdded(param1:Vector.<TextField>, param2:Vector.<TextField>, param3:Vector.<TKnifeAdd>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TStarPointDesc = null;
         var _loc6_:TKnifeAdd = null;
         _loc4_ = 0;
         while(_loc4_ < param3.length)
         {
            _loc6_ = param3[_loc4_];
            if(_loc6_.Value < 0)
            {
               param2[_loc4_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_9),int(_loc6_.Value * -1 * 100) + "");
               param2[_loc4_].textColor = 16711680;
            }
            else
            {
               param2[_loc4_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),int(_loc6_.Value * 100) + "");
               param2[_loc4_].textColor = _loc6_.Value == 0 ? 13421772 : 65280;
            }
            _loc4_++;
         }
      }
      
      protected function AssignKnifeData(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:TKnifeExpand = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1.ID) as TKnifeExpand;
         param1.Level = _loc2_.Level;
         param1.SkillID = _loc2_.SkillID;
         param1.NeedKnifeSoulLevel = _loc2_.KnifeSoulLevelNeed;
         param1.KnifeSoulAdded = _loc2_.KnifeSoulAdded;
         param1.AddedFront = _loc2_.AddedFront;
         param1.AddedMiddle = _loc2_.AddedMiddle;
         param1.AddedBack = _loc2_.AddedBack;
      }
      
      protected function UIDispatchExpBar(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1["ExpBar"];
         this.FTF_ExpLevelName = _loc2_["ExpBarName"];
         this.FMC_ExpBar = _loc2_["ExpYellowBar"]["ExpYellowBarMask"];
         this.FTF_ExpNum = _loc2_["ExpNum"];
      }
      
      protected function UILocationExpBar() : void
      {
      }
      
      protected function UpdateExpBar() : void
      {
         this.FTF_ExpLevelName.text = this.FKnifeLevelName[this.FKnifeData.Level - 1];
         if(this.FKnifeData.Level == CONST_KNIFEOFKILLSOUL.KnifeMaxLevel)
         {
            this.FTF_ExpNum.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_17);
            this.FMC_ExpBar.scaleX = 0;
         }
         else
         {
            this.FMC_ExpBar.scaleX = this.FKnifeData.CurrentExp / this.FKnifeData.NeedExp;
            this.FTF_ExpNum.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_16),this.FKnifeData.CurrentExp,this.FKnifeData.NeedExp);
         }
      }
      
      protected function UIDispatchBtn(param1:MovieClip) : void
      {
         this.FBtn_SoulTrain = new TUIButton();
         this.FBtn_SoulTrain.Substrate = param1["SoulTrain"];
         this.FBtn_OneKeySoulTrain = new TUIButton();
         this.FBtn_OneKeySoulTrain.Substrate = param1["OneKeySoulTrain"];
         this.FBtn_GoldTrain = new TUIButton();
         this.FBtn_GoldTrain.Substrate = param1["GoldTrain"];
         this.FBtn_OneKeyGoldTrain = new TUIButton();
         this.FBtn_OneKeyGoldTrain.Substrate = param1["OneKeyGoldTrain"];
         this.FBtnClose = param1["Board"]["BtnClose"];
         this.FUIWindowConfirmation = new TUIWindowConfirmation(Parent);
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
      }
      
      protected function UILocationBtn() : void
      {
         this.FBtn_SoulTrain.OnClick = this.SoulTrainBtnClick;
         this.FBtn_SoulTrain.OnOver = this.SoulTrainOnOver;
         this.FBtn_SoulTrain.OnOut = this.HitOnOut;
         this.FBtn_OneKeySoulTrain.OnClick = this.OneKeySoulTrainBtnClick;
         this.FBtn_OneKeySoulTrain.OnOver = this.OneKeySoulTrainOnOver;
         this.FBtn_OneKeySoulTrain.OnOut = this.HitOnOut;
         this.FBtn_GoldTrain.OnClick = this.GoldTrainBtnClick;
         this.FBtn_GoldTrain.OnOver = this.GoldTrainOnOver;
         this.FBtn_GoldTrain.OnOut = this.HitOnOut;
         this.FBtn_OneKeyGoldTrain.OnClick = this.OneKeyGoldTrainBtnClick;
         this.FBtn_OneKeyGoldTrain.OnOver = this.OneKeyGoldTrainOnOver;
         this.FBtn_OneKeyGoldTrain.OnOut = this.HitOnOut;
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.CloseBtnClick);
         this.FGoldTrainAsk = true;
         this.FOneKeyGoldTrainAsk = true;
      }
      
      protected function RequestTrain(param1:int, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         if(param2 == 0 || this.FKnifeData.Level >= CONST_KNIFEOFKILLSOUL.KnifeMaxLevel)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TrainKnifeRequest);
         _loc3_.Data.writeByte(param1);
         _loc3_.Data.writeUnsignedInt(param2);
         _loc3_.Data.writeUnsignedInt(this.FKnifeData.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_KnifeOfKillSoulTrainBtnClicked);
      }
      
      protected function WindowInputNumSoulTrainBack(param1:Object, param2:uint) : void
      {
         this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeNormal,param2);
      }
      
      protected function SoulTrainBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FToolKnifeData.NeedKnifeSoulLevel > SLogicsCore.Character.KnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_6));
            return;
         }
         this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeNormal,1);
      }
      
      protected function OneKeySoulTrainBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FToolKnifeData.NeedKnifeSoulLevel > SLogicsCore.Character.KnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_6));
            return;
         }
         this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeNormal,50);
      }
      
      protected function GoldTrainOnOk(param1:Object) : void
      {
         if(this.FGoldTrainAsk && this.FUIWindowConfirmation.IsSelected)
         {
            this.FGoldTrainAsk = false;
         }
         this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeUpgrade,1);
      }
      
      protected function GoldTrainBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FToolKnifeData.NeedKnifeSoulLevel > SLogicsCore.Character.KnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_6));
            return;
         }
         if(!this.FGoldTrainAsk)
         {
            this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeUpgrade,1);
         }
         else
         {
            this.FUIWindowConfirmation.SetCheckBoxUsable(true);
            this.FUIWindowConfirmation.SetSelected(false);
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_25);
            this.FUIWindowConfirmation.OnOK = this.GoldTrainOnOk;
            this.FUIWindowConfirmation.visible = true;
         }
      }
      
      protected function OneKeyGoldTrainOnOk(param1:Object) : void
      {
         if(this.FOneKeyGoldTrainAsk && this.FUIWindowConfirmation.IsSelected)
         {
            this.FOneKeyGoldTrainAsk = false;
         }
         this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeUpgrade,CONST_KNIFEOFKILLSOUL.BatchNum);
      }
      
      protected function OneKeyGoldTrainBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FToolKnifeData.NeedKnifeSoulLevel > SLogicsCore.Character.KnifeSoul.Level)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_6));
            return;
         }
         if(!this.FOneKeyGoldTrainAsk)
         {
            this.RequestTrain(CONST_KNIFEOFKILLSOUL.KnifeTrainTypeUpgrade,CONST_KNIFEOFKILLSOUL.BatchNum);
         }
         else
         {
            this.FUIWindowConfirmation.SetCheckBoxUsable(true);
            this.FUIWindowConfirmation.SetSelected(false);
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_26);
            this.FUIWindowConfirmation.OnOK = this.OneKeyGoldTrainOnOk;
            this.FUIWindowConfirmation.visible = true;
         }
      }
      
      protected function GradeTrainWindowInputTextAsk(param1:int) : String
      {
         return null;
      }
      
      protected function CloseBtnClick(param1:MouseEvent = null) : void
      {
         if(this.FOnClickClose != null)
         {
            this.FOnClickClose();
         }
      }
      
      protected function SoulTrainOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_21),this.FKnifeData.NormalTrainExp);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function OneKeySoulTrainOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_22),this.FKnifeData.NormalTrainExp * CONST_KNIFEOFKILLSOUL.BatchNum);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function GoldTrainOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_23),this.FKnifeData.GoldTrainExp);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function OneKeyGoldTrainOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_24),this.FKnifeData.GoldTrainExp * CONST_KNIFEOFKILLSOUL.BatchNum);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function UIDispatchTool() : void
      {
         this.FUIWindowInputNum = new TUIWindowInputNum(Parent.Parent);
         TUtilityUIWindow.SetupWindowInputNum(this.FUIWindowInputNum);
      }
      
      protected function UILocationTool() : void
      {
      }
      
      public function set KnifeData(param1:TKnifeOfKillSoulData) : void
      {
         this.FKnifeData = param1;
      }
      
      public function set OnClickClose(param1:Function) : void
      {
         this.FOnClickClose = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function set OnShortcutHyperlinks(param1:Function) : void
      {
         this.FOnShortcutHyperlinks = param1;
      }
      
      public function UIDispath() : void
      {
         this.UIDispatch_Perform();
      }
      
      public function UILocation() : void
      {
         this.UILocation_Perform();
      }
      
      public function Update() : void
      {
         this.UpdateAttribute();
         this.UpdateBaseInfor();
         this.UpdateExpBar();
      }
      
      public function Reset() : void
      {
         this.FBitMap_PicMountPoint.bitmapData = null;
      }
   }
}

