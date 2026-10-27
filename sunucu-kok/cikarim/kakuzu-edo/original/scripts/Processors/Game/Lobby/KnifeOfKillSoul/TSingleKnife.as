package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class TSingleKnife extends TProcessorLobbyWindow
   {
      
      protected static const TrianglesVertexIndex:Vector.<int> = Vector.<int>([0,1,2,0,2,3,0,3,4]);
      
      protected static const RadinaBlank:Number = 72 / 180 * Math.PI;
      
      protected static const RadinaStart:Number = 18 / 180 * Math.PI;
      
      protected static const UnitPhasiLength:Number = 38 / 10;
      
      protected static const PhasiNum:int = 5;
      
      protected static const StrengthenInfoNum:int = 3;
      
      protected var FTF_Level:TextField;
      
      protected var FMC_KnifePic:MovieClip;
      
      protected var FBitMap_PicMountPoint:Bitmap;
      
      protected var FMC_StarLevel:MovieClip;
      
      protected var FTF_SkillName:TextField;
      
      protected var FPhasi:Sprite;
      
      protected var FPhasiPaintPoint:Sprite;
      
      protected var FPhisisUI:Vector.<Sprite>;
      
      protected var FTypePic:MovieClip;
      
      protected var FInforBar:MovieClip;
      
      protected var FRedBar:Sprite;
      
      protected var FColorTransform:ColorTransform;
      
      protected var FShowKnifeMoudleBtn:MovieClip;
      
      protected var FShowKnifeMoudleView:MovieClip;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FSpriteMoudleMountPoint:Sprite;
      
      protected var FShowMoudle:Boolean;
      
      protected var FMC_AttributeTable:MovieClip;
      
      protected var FTF_KnifeSoulAdded:TextField;
      
      protected var FTF_AddedFrontNames:Vector.<TextField>;
      
      protected var FTF_AddedFrontValues:Vector.<TextField>;
      
      protected var FTF_AddedMiddleNames:Vector.<TextField>;
      
      protected var FTF_AddedMiddleValues:Vector.<TextField>;
      
      protected var FTF_AddedBackNames:Vector.<TextField>;
      
      protected var FTF_AddedBackValues:Vector.<TextField>;
      
      protected var FLookKnifeAdded:MovieClip;
      
      protected var FHideKnifeAdded:MovieClip;
      
      protected var FCommonBtn:MovieClip;
      
      protected var FBtn_ChangeShape:MovieClip;
      
      protected var FVertexArr:Vector.<Number>;
      
      protected var FPhasiNumArr:Vector.<int>;
      
      protected var FHint:THint;
      
      protected var FKnifeLevelName:Vector.<String>;
      
      protected var FPhasiStrings:Vector.<String>;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FFlyText:Function;
      
      protected var FOnClickCommonBtn:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnChangeShape:Function;
      
      protected var FKnifeLanguage:TKnifeLanguage;
      
      public function TSingleKnife(param1:TUIComponent)
      {
         super(param1);
         this.FVertexArr = new Vector.<Number>();
         this.FPhasiNumArr = new Vector.<int>();
         this.FRolesModelID = new Vector.<int>();
         visible = true;
      }
      
      protected function UIDispatch_Perform(param1:MovieClip) : void
      {
         this.BaseInforUIDispatch(param1);
         this.ShowKnifeMoudleDispatch(param1);
         this.AttributeUIDispatch(param1);
         this.BtnUIDispatch(param1);
      }
      
      protected function UILocation_Perform() : void
      {
         this.BaseInforUILocation();
         this.ShowKnifeMoudleLocation();
         this.AttributeLocation();
         this.BtnLocation();
      }
      
      protected function BaseInforUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         this.FTF_Level = param1["Level"];
         this.FMC_KnifePic = param1["KnifePic"];
         this.FBitMap_PicMountPoint = new Bitmap();
         this.FMC_KnifePic["ImagePoint"].addChild(this.FBitMap_PicMountPoint);
         this.FMC_StarLevel = param1["StarLevel"];
         this.FTF_SkillName = param1["Skill"]["SkiiLable"];
         this.FPhasi = param1["phasi"];
         this.FPhasiPaintPoint = param1["phasi"]["PhasiPaintPoint"];
         this.FTypePic = param1["TypePic"];
         this.FInforBar = param1["InforBar"];
         this.FInforBar.gotoAndStop(2);
         this.FRedBar = this.FInforBar["MC"]["Red"];
         this.FRedBar.visible = false;
         this.FColorTransform = new ColorTransform(1,1,1,1,30,30,0,0);
         this.FPhisisUI = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < PhasiNum)
         {
            this.FPhisisUI.push(this.FPhasi["Attr" + _loc2_]);
            _loc2_++;
         }
         this.FHint = new THint();
         this.FKnifeLevelName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_3);
         this.FPhasiStrings = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_20);
      }
      
      protected function BaseInforUILocation() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < PhasiNum)
         {
            _loc1_ = this.FPhisisUI[_loc2_];
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.PhisisOnOver);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.HitOnOut);
            _loc2_++;
         }
         this.FInforBar.addEventListener(MouseEvent.MOUSE_MOVE,this.HandBookOnOver);
         this.FInforBar.addEventListener(MouseEvent.MOUSE_OUT,this.HitOnOut);
         this.FTF_SkillName.addEventListener(MouseEvent.MOUSE_OVER,this.SkillOnOver);
         this.FTF_SkillName.addEventListener(MouseEvent.MOUSE_OUT,this.HitOnOut);
         this.FPhasiPaintPoint.alpha = 0.6;
      }
      
      protected function UpdateBaseInfor() : void
      {
         var _loc1_:TSkillConfig = null;
         var _loc2_:TArticle = null;
         var _loc3_:int = 0;
         this.FTF_Level.text = this.FKnifeLevelName[this.FKnifeData.Level - 1];
         this.FTypePic.gotoAndStop(this.FKnifeData.Type);
         this.FMC_KnifePic.gotoAndStop("N_" + this.FKnifeData.RelationID);
         this.FBitMap_PicMountPoint.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FKnifeData.ID,this.ResourceSendInterface);
         this.FMC_StarLevel.gotoAndStop(this.FKnifeData.Appraise);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FTF_SkillName.text = _loc1_.Name;
         this.PaintPhasi();
         this.InitInforBar();
      }
      
      protected function ResourceSendInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FKnifeData.ID)
         {
            this.FBitMap_PicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function InitInforBar() : void
      {
         if(SLogicsCore.Character.KnifeSoul.ChangedID == this.FKnifeData.ID)
         {
            this.FInforBar.gotoAndStop(1);
            this.FInforBar.visible = true;
         }
         else if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook)
         {
            this.FInforBar.gotoAndStop(2);
            this.FInforBar["Lable"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_5),this.FKnifeData.HandBookName);
            this.FInforBar.visible = true;
         }
         else if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_WaitUnlock)
         {
            this.FInforBar.gotoAndStop(3);
            this.FInforBar.Effect.play();
            this.FInforBar.visible = true;
         }
         else
         {
            this.FInforBar.visible = false;
         }
      }
      
      protected function PaintPhasi() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FVertexArr.length = 0;
         this.FPhasiNumArr.length = 0;
         this.FPhasiNumArr.push(this.FKnifeData.SpeedAttr);
         this.FPhasiNumArr.push(this.FKnifeData.AttackAttr);
         this.FPhasiNumArr.push(this.FKnifeData.DefenseAttr);
         this.FPhasiNumArr.push(this.FKnifeData.RecoveryAttr);
         this.FPhasiNumArr.push(this.FKnifeData.ResistanceAttr);
         _loc1_ = RadinaStart;
         _loc2_ = 0;
         while(_loc2_ < this.FPhasiNumArr.length)
         {
            _loc3_ = this.FPhasiNumArr[_loc2_];
            this.FVertexArr.push(Math.cos(_loc1_) * _loc3_ * UnitPhasiLength);
            this.FVertexArr.push(-Math.sin(_loc1_) * _loc3_ * UnitPhasiLength);
            _loc1_ += RadinaBlank;
            _loc2_++;
         }
         this.FPhasiPaintPoint.graphics.clear();
         this.FPhasiPaintPoint.graphics.beginFill(2163518208);
         this.FPhasiPaintPoint.graphics.drawTriangles(this.FVertexArr,TrianglesVertexIndex);
         this.FPhasiPaintPoint.graphics.endFill();
      }
      
      protected function HandBookOnOver(param1:MouseEvent) : void
      {
         if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook)
         {
            if(this.FHintOnOver != null)
            {
               this.FHintOnOver(this,this.FHint);
            }
            this.FHint.Caption = this.FKnifeData.GetRoad;
            this.FRedBar.visible = true;
         }
      }
      
      protected function SkillOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TSkillConfig = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FHint.Caption = _loc2_.Desc;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function PhisisOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as Sprite;
         _loc3_ = this.FPhisisUI.indexOf(_loc2_);
         this.FHint.Caption = this.FPhasiStrings[_loc3_];
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function HitOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
         if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook)
         {
            this.FRedBar.visible = false;
         }
      }
      
      protected function ShowKnifeMoudleDispatch(param1:MovieClip) : void
      {
         this.FShowKnifeMoudleBtn = param1["ShowKnifeMoudle"];
         this.FShowKnifeMoudleBtn.visible = false;
         this.FShowKnifeMoudleView = param1["MoudleView"];
         this.FShowKnifeMoudleView.visible = false;
         this.FSpriteMoudleMountPoint = this.FShowKnifeMoudleView["MoudleMountPoint"];
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FSpriteMoudleMountPoint.addChild(this.FSpriteMoudle);
      }
      
      protected function ShowKnifeMoudleLocation() : void
      {
         this.FShowKnifeMoudleBtn.addEventListener(MouseEvent.MOUSE_OVER,this.ShowKnifeMoudleBtnOnOver);
         this.FShowKnifeMoudleBtn.addEventListener(MouseEvent.MOUSE_OUT,this.ShowKnifeMoudleBtnOnOut);
      }
      
      protected function UpdateKnifeMoudle() : void
      {
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FKnifeData.RelationID,this.FQureyMoudleInfor);
         this.SetRoleModelID(this.FQureyMoudleInfor.TextureID);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      protected function ShowKnifeMoudleBtnOnOver(param1:MouseEvent) : void
      {
         this.FShowKnifeMoudleView.visible = true;
         this.FShowKnifeMoudleView.gotoAndStop(this.FKnifeData.Type);
         this.FShowMoudle = true;
         this.FShowKnifeMoudleBtn.gotoAndStop(2);
      }
      
      protected function ShowKnifeMoudleBtnOnOut(param1:MouseEvent) : void
      {
         this.FShowKnifeMoudleView.visible = false;
         this.FShowKnifeMoudleBtn.gotoAndStop(1);
         this.FShowMoudle = false;
      }
      
      protected function AttributeUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TKnifeStrengthenAdd = null;
         this.FTF_AddedFrontNames = new Vector.<TextField>();
         this.FTF_AddedFrontValues = new Vector.<TextField>();
         this.FTF_AddedMiddleNames = new Vector.<TextField>();
         this.FTF_AddedMiddleValues = new Vector.<TextField>();
         this.FTF_AddedBackNames = new Vector.<TextField>();
         this.FTF_AddedBackValues = new Vector.<TextField>();
         this.FMC_AttributeTable = param1["AttributeTable"];
         this.FTF_KnifeSoulAdded = this.FMC_AttributeTable["KnifeSoulAdded"];
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            this.FTF_AddedFrontNames.push(this.FMC_AttributeTable["FrontAddedName" + (_loc2_ + 1)]);
            this.FTF_AddedFrontValues.push(this.FMC_AttributeTable["FrontAddedValue" + (_loc2_ + 1)]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            this.FTF_AddedMiddleNames.push(this.FMC_AttributeTable["MiddleAddedName" + (_loc2_ + 1)]);
            this.FTF_AddedMiddleValues.push(this.FMC_AttributeTable["MiddleAddedValue" + (_loc2_ + 1)]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            this.FTF_AddedBackNames.push(this.FMC_AttributeTable["BackAddedName" + (_loc2_ + 1)]);
            this.FTF_AddedBackValues.push(this.FMC_AttributeTable["BackAddedValue" + (_loc2_ + 1)]);
            _loc2_++;
         }
      }
      
      protected function AttributeLocation() : void
      {
      }
      
      protected function UpdateAttribute() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TKnifeStrengthenAdd = null;
         this.FTF_KnifeSoulAdded.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),this.FKnifeData.KnifeSoulAdded);
         this.FlushAttributeAdded(this.FTF_AddedFrontNames,this.FTF_AddedFrontValues,this.FKnifeData.AddedFront);
         this.FlushAttributeAdded(this.FTF_AddedMiddleNames,this.FTF_AddedMiddleValues,this.FKnifeData.AddedMiddle);
         this.FlushAttributeAdded(this.FTF_AddedBackNames,this.FTF_AddedBackValues,this.FKnifeData.AddedBack);
         this.FMC_AttributeTable.TF_Type.text = this.FKnifeLanguage.GetStr0(this.FKnifeData.StrengthenType);
         _loc1_ = 0;
         while(_loc1_ < StrengthenInfoNum)
         {
            _loc2_ = this.FMC_AttributeTable["MC_StrengthenInfo_" + _loc1_];
            _loc3_ = this.FKnifeData.StrengthenAdd[_loc1_];
            _loc2_.TF_Name.text = TUtilityLobby.GetAttributeName(_loc3_.Type);
            _loc2_.TF_Value.text = "+" + _loc3_.Value;
            _loc1_++;
         }
      }
      
      protected function FlushAttributeAdded(param1:Vector.<TextField>, param2:Vector.<TextField>, param3:Vector.<TKnifeAdd>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TKnifeAdd = null;
         _loc4_ = 0;
         while(_loc4_ < param3.length)
         {
            _loc5_ = param3[_loc4_];
            if(_loc5_.Value < 0)
            {
               param2[_loc4_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_9),int(_loc5_.Value * -1 * 100) + "");
               param2[_loc4_].textColor = 16711680;
            }
            else
            {
               param2[_loc4_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),int(_loc5_.Value * 100) + "");
               param2[_loc4_].textColor = _loc5_.Value == 0 ? 13421772 : 65280;
            }
            _loc4_++;
         }
      }
      
      protected function BtnUIDispatch(param1:MovieClip) : void
      {
         this.FLookKnifeAdded = param1["KnifeContorl"]["Look"];
         this.FHideKnifeAdded = param1["KnifeContorl"]["Hide"];
         this.FCommonBtn = param1["CommonBtn"];
         this.FBtn_ChangeShape = param1["ChangeShape"];
      }
      
      protected function BtnLocation() : void
      {
         TUtilityStandardBTN.SetBtnEventListener(this.FLookKnifeAdded,this.OnLookKnifeAddedBtnClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FHideKnifeAdded,this.OnHideKnifeAddedBtnClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FCommonBtn,this.OnCommonBtn);
         TUtilityStandardBTN.SetBtnEventListener(this.FBtn_ChangeShape,this.OnChangeShapeClick);
      }
      
      protected function UpdateBtn() : void
      {
         if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
         {
            this.FCommonBtn["Lable"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_11);
            if(SLogicsCore.Character.KnifeSoul.ChangedID == this.FKnifeData.ID)
            {
               this.FBtn_ChangeShape["Lable"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_13);
            }
            else
            {
               this.FBtn_ChangeShape["Lable"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_12);
            }
            this.FBtn_ChangeShape.visible = true;
         }
         else
         {
            this.FCommonBtn["Lable"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_10);
            this.FBtn_ChangeShape.visible = false;
         }
      }
      
      protected function OnCommonBtn(param1:MouseEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:TArticle = null;
         switch(this.FKnifeData.CurrentState)
         {
            case CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook:
               _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FKnifeData.HandBook) as TArticle;
               _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_14),_loc3_.Name);
               EffectGenerateText(_loc2_);
               break;
            case CONST_KNIFEOFKILLSOUL.KNIFESTATE_KnifeSoulUnReach:
               _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_15),this.FKnifeData.NeedKnifeSoulLevel);
               EffectGenerateText(_loc2_);
               break;
            case CONST_KNIFEOFKILLSOUL.KNIFESTATE_WaitUnlock:
               this.RequestOpenKnife();
               break;
            case CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK:
               if(this.FOnClickCommonBtn != null)
               {
                  this.FOnClickCommonBtn(this.FKnifeData);
               }
         }
      }
      
      protected function OnChangeShapeClick(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ChangeKnifeRequest);
         if(SLogicsCore.Character.KnifeSoul.ChangedID == this.FKnifeData.ID)
         {
            _loc2_.Data.writeByte(CONST_KNIFEOFKILLSOUL.KnifeCancleChangeShpae);
            _loc2_.Data.writeUnsignedInt(this.FKnifeData.ID);
         }
         else
         {
            _loc2_.Data.writeByte(CONST_KNIFEOFKILLSOUL.KnifeChangeShpae);
            _loc2_.Data.writeUnsignedInt(this.FKnifeData.ID);
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         SLogicsCore.SinalPostFreshGuide(CONST_FRESHGUIDE.EVENTID_KnifeOfKillSoulChangeShapeBtnClicked);
      }
      
      protected function OnLookKnifeAddedBtnClick(param1:MouseEvent = null) : void
      {
         this.FLookKnifeAdded.visible = false;
         this.FHideKnifeAdded.visible = true;
         this.FMC_AttributeTable.visible = true;
      }
      
      protected function OnHideKnifeAddedBtnClick(param1:MouseEvent = null) : void
      {
         this.FLookKnifeAdded.visible = true;
         this.FHideKnifeAdded.visible = false;
         this.FMC_AttributeTable.visible = false;
      }
      
      protected function RequestOpenKnife() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OpenKnifeRequest);
         _loc1_.Data.writeUnsignedInt(this.FKnifeData.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FShowMoudle)
         {
            this.FSpriteMoudle.UpdateView();
         }
      }
      
      public function set KnifeData(param1:TKnifeOfKillSoulData) : void
      {
         this.FKnifeData = param1;
      }
      
      public function set FlyText(param1:Function) : void
      {
         this.FFlyText = param1;
      }
      
      public function set OnClickCommonBtn(param1:Function) : void
      {
         this.FOnClickCommonBtn = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function set OnChangeShape(param1:Function) : void
      {
         this.FOnChangeShape = param1;
      }
      
      public function set KnifeLanguage(param1:TKnifeLanguage) : void
      {
         this.FKnifeLanguage = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.UIDispatch_Perform(param1);
      }
      
      public function UILocation() : void
      {
         this.UILocation_Perform();
      }
      
      public function Update() : void
      {
         this.UpdateBaseInfor();
         this.UpdateAttribute();
         this.UpdateBtn();
         this.UpdateKnifeMoudle();
         this.OnHideKnifeAddedBtnClick();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         this.FBitMap_PicMountPoint.bitmapData = null;
         this.FShowKnifeMoudleView.visible = false;
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = uint(this.FRolesModelID[_loc1_]);
            _loc3_ = CONST_COMMON.CheckKnifeModelID(_loc4_,SLogicsCore.Character.RoleSencePosition);
            if(!_loc3_)
            {
               SResourcesCore.TexturesModel.DeleteByIdentifier(_loc4_,true);
            }
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         visible = false;
      }
   }
}

