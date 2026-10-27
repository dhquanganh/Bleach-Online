package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.KnifeOfKillSoul.TKnifeLanguage;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenPhase;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_KNIFEOFKILLSOUL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TKnifeStrengthenUI extends TUIComponent
   {
      
      protected static const PhasiNum:int = 5;
      
      protected static const TrianglesVertexIndex:Vector.<int> = Vector.<int>([0,1,2,0,2,3,0,3,4]);
      
      protected static const RadinaBlank:Number = 72 / 180 * Math.PI;
      
      protected static const RadinaStart:Number = 18 / 180 * Math.PI;
      
      protected static const UnitPhasiLength:Number = 38 / 10;
      
      protected const AttributeNum:uint = 3;
      
      protected const PhaseNum:uint = 3;
      
      protected var FMainUI:MovieClip;
      
      protected var FKnifeOfkillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FChangeKnifeBtn:TUIButton;
      
      protected var FStrengthenBtns:Vector.<TUIButton>;
      
      protected var FBitMap_PicMountPoint:Bitmap;
      
      protected var FKnifeLevelName:Vector.<String>;
      
      protected var FHint:THint;
      
      protected var FPhasi:Sprite;
      
      protected var FPhasiPaintPoint:Sprite;
      
      protected var FPhisisUI:Vector.<Sprite>;
      
      protected var FVertexArr:Vector.<Number>;
      
      protected var FPhasiNumArr:Vector.<int>;
      
      protected var FPhaseUI:TKnifeStrengthenPhaseUI;
      
      protected var FAllPhaseBtn:TUIButton;
      
      protected var FInforBar:MovieClip;
      
      protected var FRedBar:Sprite;
      
      protected var FOpenStrengthenBox:Function;
      
      protected var FChangeKnife:Function;
      
      protected var FKnifeLanguage:TKnifeLanguage;
      
      protected var FOpenAllPhase:Function;
      
      public function TKnifeStrengthenUI(param1:TUIComponent)
      {
         super(param1);
         this.FVertexArr = new Vector.<Number>();
         this.FPhasiNumArr = new Vector.<int>();
      }
      
      protected function GetCurPhase() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:TKnifeStrengthenPhase = null;
         var _loc3_:uint = 0;
         _loc3_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.PhaseNum)
         {
            _loc2_ = this.FKnifeData.StrengthenPhase[_loc1_];
            if(!_loc2_.Activate)
            {
               break;
            }
            _loc3_++;
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function GetDefaultIndex() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TKnifeOfKillSoulData = null;
         _loc3_ = uint(this.FKnifeOfkillSoulDatas.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = this.FKnifeOfkillSoulDatas.GetByIndex(_loc1_);
            if(SLogicsCore.Character.KnifeSoul.ChangedID == _loc4_.ID)
            {
               return _loc1_;
            }
            if(_loc4_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
            {
               _loc2_ = _loc1_;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      protected function UpdateKnifeIcon() : void
      {
         var _loc1_:TSkillConfig = null;
         this.FMainUI.KnifePic.gotoAndStop("N_" + this.FKnifeData.RelationID);
         this.FBitMap_PicMountPoint.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FKnifeData.ID,this.ResourceSendInterface);
         this.FMainUI.Level.text = this.FKnifeLevelName[this.FKnifeData.Level - 1];
         this.FMainUI.TypePic.gotoAndStop(this.FKnifeData.Type);
         this.InitInforBar();
         this.FMainUI.StarLevel.gotoAndStop(this.FKnifeData.Appraise);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FMainUI.Skill.SkiiLable.text = _loc1_.Name;
         this.PaintPhasi();
         this.FMainUI.TF_AttributeType.text = this.FKnifeLanguage.GetStr0(this.FKnifeData.StrengthenType);
      }
      
      protected function UpdateKnifeAttribute() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TKnifeStrengthenAdd = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIButton = null;
         var _loc5_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.AttributeNum)
         {
            _loc2_ = this.FKnifeData.StrengthenAdd[_loc1_];
            _loc3_ = this.FMainUI["MC_Attribute_" + _loc1_];
            _loc3_.MC_AttributeType.gotoAndStop("Type_" + _loc2_.Type);
            _loc3_.TF_Level.text = this.FKnifeLanguage.GetStr1(_loc2_.Level);
            _loc3_.MC_Bar.scaleX = _loc2_.Level / _loc2_.NextNodeLevel;
            _loc3_.TF_AttributeName.text = TUtilityLobby.GetAttributeName(_loc2_.Type);
            _loc3_.TF_AttributeValue.text = "+" + _loc2_.Value;
            _loc3_.TF_AttributeAdd.text = "+" + _loc2_.UpAddValue;
            _loc4_ = this.FStrengthenBtns[_loc1_];
            _loc4_.OnMove = _loc2_.IsMax ? this.StrengthenBtnOver : null;
            _loc4_.OnOut = _loc2_.IsMax ? this.HitOnOut : null;
            if(this.FKnifeData.CurrentState != CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
            {
               _loc4_.Enabled = false;
            }
            else
            {
               _loc4_.Enabled = !_loc2_.IsMax;
               if(!_loc2_.IsMax && _loc2_.IsNodeLevel)
               {
                  _loc4_.Enabled = false;
               }
            }
            _loc1_++;
         }
         _loc5_ = this.GetCurPhase();
         if(_loc5_ == this.FKnifeData.StrengthenPhase.length)
         {
            this.FMainUI.TF_CurNodeLevelInfo0.text = this.FKnifeLanguage.GetStr12();
            this.FMainUI.TF_CurNodeLevel.text = "";
            this.FMainUI.TF_CurNodeLevelInfo1.text = "";
         }
         else
         {
            this.FMainUI.TF_CurNodeLevelInfo0.text = this.FKnifeLanguage.GetStr10();
            this.FMainUI.TF_CurNodeLevel.text = this.FKnifeLanguage.GetStr1(_loc2_.NextNodeLevel);
            this.FMainUI.TF_CurNodeLevelInfo1.text = this.FKnifeLanguage.GetStr11(_loc5_ + 1);
         }
      }
      
      protected function UpdateKnifePhase() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TKnifeStrengthenPhase = null;
         _loc2_ = null;
         _loc1_ = 0;
         while(_loc1_ < this.PhaseNum)
         {
            if(!this.FKnifeData.StrengthenPhase[_loc1_].Activate)
            {
               break;
            }
            _loc2_ = this.FKnifeData.StrengthenPhase[_loc1_];
            _loc1_++;
         }
         if(_loc2_ == null)
         {
            _loc2_ = this.FKnifeData.StrengthenPhase[0];
            this.FPhaseUI.GreyState();
         }
         else
         {
            this.FPhaseUI.NormalState();
         }
         this.FPhaseUI.SetData(_loc2_);
         this.FMainUI.TF_AttEffect.text = this.FKnifeLanguage.GetStr13(Math.max(this.GetCurPhase(),1));
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
      
      protected function HandBookOnOver(param1:MouseEvent) : void
      {
         if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook)
         {
            this.FHint.Caption = this.FKnifeData.GetRoad;
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
            this.FRedBar.visible = true;
         }
      }
      
      protected function OnChangeKnifeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FChangeKnife();
      }
      
      protected function OnStrengthenClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TKnifeStrengthenAdd = null;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FKnifeData.StrengthenAdd[_loc3_.Tag];
         this.FOpenStrengthenBox(_loc4_,this.FKnifeData.ID,_loc3_.Tag);
      }
      
      protected function ResourceSendInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FKnifeData.ID)
         {
            this.FBitMap_PicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function SkillOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TSkillConfig = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FHint.Caption = _loc2_.Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function SkillOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function StrengthenBtnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = this.FKnifeLanguage.GetStr2();
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function HitOnOut(param1:Object, param2:MouseEvent = null) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         if(this.FKnifeData.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook)
         {
            this.FRedBar.visible = false;
         }
      }
      
      protected function OnAllPhaseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOpenAllPhase(this.FKnifeData);
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.UpdateUI();
      }
      
      public function set KnifeOfkillSoulDatas(param1:TKnifeOfkillSoulDatas) : void
      {
         this.FKnifeOfkillSoulDatas = param1;
      }
      
      public function set OpenStrengthenBox(param1:Function) : void
      {
         this.FOpenStrengthenBox = param1;
      }
      
      public function set KnifeLanguage(param1:TKnifeLanguage) : void
      {
         this.FKnifeLanguage = param1;
      }
      
      public function set ChangeKnife(param1:Function) : void
      {
         this.FChangeKnife = param1;
      }
      
      public function set KnifeData(param1:TKnifeOfKillSoulData) : void
      {
         this.FKnifeData = param1;
      }
      
      public function set OpenAllPhase(param1:Function) : void
      {
         this.FOpenAllPhase = param1;
      }
      
      public function UIDispath(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUIButton = null;
         this.FMainUI = param1;
         addChild(param1);
         this.FChangeKnifeBtn = new TUIButton();
         this.FChangeKnifeBtn.Substrate = this.FMainUI.Btn_ChangeKnife;
         this.FChangeKnifeBtn.OnClick = this.OnChangeKnifeBtnClick;
         this.FStrengthenBtns = new Vector.<TUIButton>();
         _loc2_ = 0;
         while(_loc2_ < this.AttributeNum)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = this.FMainUI["MC_Attribute_" + _loc2_]["Btn_Strengthen"];
            _loc3_.OnClick = this.OnStrengthenClick;
            _loc3_.Tag = _loc2_;
            this.FStrengthenBtns.push(_loc3_);
            _loc2_++;
         }
         this.FBitMap_PicMountPoint = new Bitmap();
         this.FMainUI.KnifePic.ImagePoint.addChild(this.FBitMap_PicMountPoint);
         this.FKnifeLevelName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_3);
         this.FMainUI.Skill.SkiiLable.addEventListener(MouseEvent.MOUSE_OVER,this.SkillOnOver);
         this.FMainUI.Skill.SkiiLable.addEventListener(MouseEvent.MOUSE_OUT,this.SkillOnOut);
         this.FHint = new THint();
         this.FPhasi = this.FMainUI.phasi;
         this.FPhasiPaintPoint = this.FPhasi["PhasiPaintPoint"];
         this.FPhisisUI = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < PhasiNum)
         {
            this.FPhisisUI.push(this.FPhasi["Attr" + _loc2_]);
            _loc2_++;
         }
         this.FPhaseUI = new TKnifeStrengthenPhaseUI();
         this.FPhaseUI.UIDispath(this.FMainUI.MC_CurrentPhase);
         this.FAllPhaseBtn = new TUIButton();
         this.FAllPhaseBtn.Substrate = this.FMainUI.Btn_AllPhase;
         this.FAllPhaseBtn.OnClick = this.OnAllPhaseBtnClick;
         this.FMainUI.TF_Help.text = this.FKnifeLanguage.GetStr9();
         this.FInforBar = this.FMainUI.InforBar;
         this.FInforBar.gotoAndStop(2);
         this.FRedBar = this.FInforBar["MC"]["Red"];
         this.FRedBar.visible = false;
         this.FInforBar.addEventListener(MouseEvent.MOUSE_MOVE,this.HandBookOnOver);
         this.FInforBar.addEventListener(MouseEvent.MOUSE_OUT,this.HitOnOut);
      }
      
      public function UpdateUI() : void
      {
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         if(this.FKnifeData == null)
         {
            this.FKnifeData = this.FKnifeOfkillSoulDatas.GetByIndex(this.GetDefaultIndex());
         }
         this.UpdateKnifeIcon();
         this.UpdateKnifeAttribute();
         this.UpdateKnifePhase();
      }
      
      public function Reset() : void
      {
         this.FKnifeData = null;
      }
   }
}

