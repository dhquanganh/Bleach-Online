package Processors.Game.Lobby.TacticalDeployment.Components
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Battle.Character.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class THeroDeployment extends TUIComponent
   {
      
      protected static const TYPE_NORMAL:int = 1;
      
      protected static const TYPE_LIGHT:int = 2;
      
      protected static const TYPE_DISABLED:int = 3;
      
      protected static const MAX_COUNT:int = 15;
      
      protected static const ARMY_COUNT:int = 3;
      
      protected static const INDEX_STAMP:int = 5;
      
      protected static const DEPLOYMENT_WIDTH:Number = 76;
      
      protected static const DEPLOYMENT_HEIGHT:Number = 76;
      
      protected static const CONST_ACTIVE_CLASSNAME:String = "hero";
      
      protected static var bBlackFilters:ColorMatrixFilter = new ColorMatrixFilter([0.8,0.5,0.5,0,0,0.8,0.5,0.5,0,0,0.8,0.5,0.5,0,0,0,0,0,1,0]);
      
      protected static const WHEEL_NUM:int = 5;
      
      protected static const DefaultPicID:int = 2000000;
      
      protected static const CAPACITY_CurHeros_01:uint = 3;
      
      protected static const CAPACITY_CurHeros_02:uint = 4;
      
      protected var FScene:MovieClip;
      
      protected var FMaxPlay:int;
      
      protected var FHeroDeployment:THeros;
      
      protected var FSelectHero:THero;
      
      protected var FTipCountTF:TextField;
      
      protected var FNormalFormat:TextFormat;
      
      protected var FOverFormat:TextFormat;
      
      protected var FShowHeadIndex:int;
      
      protected var FMouseInIndex:uint;
      
      protected var FSystemLanguageBins:TBins;
      
      protected var FIconBitmaps:Vector.<Bitmap>;
      
      protected var FMC_KnifePic:MovieClip;
      
      protected var FMC_KnifeShadow:Sprite;
      
      protected var FBitMap_MountPoint:Bitmap;
      
      protected var FCurrentPicIDRequest:uint;
      
      protected var FMC_ChangeShape:MovieClip;
      
      protected var FTF_KnifeSoulAdded:TextField;
      
      protected var FTF_KnifeSoulLevel:TextField;
      
      protected var FTF_PowerAdded:TextField;
      
      protected var FTF_AgileAdded:TextField;
      
      protected var FTF_IntelligenceAdded:TextField;
      
      protected var FTF_LifeAdded:TextField;
      
      protected var FWheels:Vector.<MovieClip>;
      
      protected var FTF_AddedFrontNames:Vector.<TextField>;
      
      protected var FTF_AddedFrontValues:Vector.<TextField>;
      
      protected var FTF_AddedMiddleNames:Vector.<TextField>;
      
      protected var FTF_AddedMiddleValues:Vector.<TextField>;
      
      protected var FTF_AddedBackNames:Vector.<TextField>;
      
      protected var FTF_AddedBackValues:Vector.<TextField>;
      
      protected var FrontAddedString:Vector.<String>;
      
      protected var MiddleAddedString:Vector.<String>;
      
      protected var BackAddedString:Vector.<String>;
      
      protected var FMC_FrontRecommand:MovieClip;
      
      protected var FMC_MiddleRecommand:MovieClip;
      
      protected var FMC_BackRecommand:MovieClip;
      
      protected var FMC_RecommendsBtn:Vector.<MovieClip>;
      
      protected var FOnEffectText:Function;
      
      protected var FSetSelectHero:Function;
      
      protected var FSetSelectHeroBitmapVisible:Function;
      
      protected var FOnEnterMilitary:Function;
      
      protected var FFunOnClickChangeShape:Function;
      
      protected var FOnRecommendBtnClick:Function;
      
      protected var FShowHeroInfoTip:Function;
      
      protected var FHideHeroInfoTip:Function;
      
      protected var FOnKnifeSoulUpgrade:Function;
      
      public function THeroDeployment(param1:TUIComponent)
      {
         super(param1);
         this.FIconBitmaps = new Vector.<Bitmap>(MAX_COUNT);
         this.FMC_RecommendsBtn = new Vector.<MovieClip>();
      }
      
      protected function InitDeployment() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Bitmap = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc2_ = this.FScene["mc_pos_" + _loc1_];
            if(_loc2_ != null)
            {
               _loc3_ = new Bitmap();
               _loc2_.mc_index.visible = false;
               _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.OnSelectHero);
               _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnShowHero);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnHideHero);
               _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.OnNormalHero);
               _loc2_.mc_heroIcon.addChild(_loc3_);
               this.FIconBitmaps[_loc1_] = _loc3_;
               _loc2_.buttonMode = true;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ARMY_COUNT)
         {
            _loc2_ = this.FScene["mc_strip_" + _loc1_];
            _loc2_.mc_formation.gotoAndStop(_loc1_ + 1);
            _loc1_++;
         }
         this.FNormalFormat = new TextFormat();
         this.FNormalFormat.underline = true;
         this.FNormalFormat.color = 65280;
         this.FOverFormat = new TextFormat();
         this.FOverFormat.underline = true;
         this.FOverFormat.color = 16711680;
         this.FScene.mc_tipCount.buttonMode = true;
         this.FScene.mc_tipCount.addEventListener(MouseEvent.ROLL_OVER,this.OnTextRoll);
         this.FScene.mc_tipCount.addEventListener(MouseEvent.ROLL_OUT,this.OnTextRoll);
         this.FScene.mc_tipCount.addEventListener(MouseEvent.CLICK,this.OnTextClicked);
         this.FTipCountTF = this.FScene.mc_tipCount.tf_tipCount;
         this.FTipCountTF.text = "";
         this.FTipCountTF.selectable = false;
         this.FTipCountTF.mouseEnabled = false;
         this.FScene.addEventListener(MouseEvent.MOUSE_UP,this.OnChangeHero);
         this.FSystemLanguageBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         this.UIDispatch();
         this.UILocation();
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         _loc1_ = this.FScene["KnifeOfKillSoul"];
         this.FMC_KnifePic = _loc1_["KnifeOfKillSoul"];
         this.FBitMap_MountPoint = new Bitmap();
         this.FMC_KnifePic["MountPoint"].addChild(this.FBitMap_MountPoint);
         this.FTF_KnifeSoulAdded = _loc1_["KnifeSoulAdded"];
         this.FMC_ChangeShape = _loc1_["ChangeShape"];
         this.FTF_KnifeSoulLevel = _loc1_["KnifeSoulLevel"];
         this.FMC_KnifeShadow = this.FMC_KnifePic["KnifeShadow"];
         this.FWheels = new Vector.<MovieClip>();
         _loc3_ = 0;
         while(_loc3_ < WHEEL_NUM)
         {
            this.FWheels.push(_loc1_["wheel" + _loc3_]);
            _loc3_++;
         }
         this.FTF_AddedFrontNames = new Vector.<TextField>();
         this.FTF_AddedFrontValues = new Vector.<TextField>();
         this.FTF_AddedMiddleNames = new Vector.<TextField>();
         this.FTF_AddedMiddleValues = new Vector.<TextField>();
         this.FTF_AddedBackNames = new Vector.<TextField>();
         this.FTF_AddedBackValues = new Vector.<TextField>();
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = this.FScene["FrontAdded"];
            this.FTF_AddedFrontNames.push(_loc4_["FrontAddName" + _loc3_]);
            this.FTF_AddedFrontValues.push(_loc4_["FrontAddValue" + _loc3_]);
            _loc4_ = this.FScene["MiddleAdded"];
            this.FTF_AddedMiddleNames.push(_loc4_["FrontAddName" + _loc3_]);
            this.FTF_AddedMiddleValues.push(_loc4_["FrontAddValue" + _loc3_]);
            _loc4_ = this.FScene["BackAdded"];
            this.FTF_AddedBackNames.push(_loc4_["FrontAddName" + _loc3_]);
            this.FTF_AddedBackValues.push(_loc4_["FrontAddValue" + _loc3_]);
            _loc3_++;
         }
         this.FMC_FrontRecommand = this.FScene["FrontRecommad"];
         this.FMC_MiddleRecommand = this.FScene["MiddleRecommad"];
         this.FMC_BackRecommand = this.FScene["BackRecommad"];
         this.FMC_RecommendsBtn.push(this.FMC_FrontRecommand);
         this.FMC_RecommendsBtn.push(this.FMC_MiddleRecommand);
         this.FMC_RecommendsBtn.push(this.FMC_BackRecommand);
         this.FrontAddedString = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_16);
         this.MiddleAddedString = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_17);
         this.BackAddedString = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_18);
      }
      
      protected function UILocation() : void
      {
         TUtilityStandardBTN.SetBtnEventListener(this.FMC_FrontRecommand,this.HeroRecommand);
         TUtilityStandardBTN.SetBtnEventListener(this.FMC_MiddleRecommand,this.HeroRecommand);
         TUtilityStandardBTN.SetBtnEventListener(this.FMC_BackRecommand,this.HeroRecommand);
         this.FMC_FrontRecommand.visible = false;
         this.FMC_MiddleRecommand.visible = false;
         this.FMC_BackRecommand.visible = false;
         TUtilityStandardBTN.SetBtnEventListener(this.FMC_ChangeShape,this.ChangeHeroShape);
      }
      
      protected function UpdateKnifeSoulInfor() : void
      {
         var _loc1_:TCharacter = null;
         var _loc2_:TKnifeOfKillSoulData = null;
         _loc1_ = SLogicsCore.Character;
         if(_loc1_.KnifeSoul.ChangedID != 0)
         {
            _loc2_ = _loc1_.KnifeOfKillSoul.GetByIndentifier(_loc1_.KnifeSoul.ChangedID);
            this.FMC_KnifePic.gotoAndStop("N_" + _loc2_.RelationID);
            SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(_loc2_.ID,this.ResourcesBackInterface);
            this.FCurrentPicIDRequest = _loc2_.ID;
            this.FMC_KnifeShadow.visible = false;
         }
         else
         {
            this.FMC_KnifePic.gotoAndStop(1);
            this.FBitMap_MountPoint.bitmapData = null;
            this.FCurrentPicIDRequest = DefaultPicID;
            this.FMC_KnifeShadow.visible = true;
         }
         this.PlayWheel();
      }
      
      protected function ResourcesBackInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FCurrentPicIDRequest == param3)
         {
            this.FBitMap_MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function PlayWheel() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FWheels.length)
         {
            _loc1_ = this.FWheels[_loc2_];
            _loc1_.play();
            _loc2_++;
         }
      }
      
      protected function StopWheel_Perform() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FWheels.length)
         {
            _loc1_ = this.FWheels[_loc2_];
            _loc1_.stop();
            _loc2_++;
         }
      }
      
      protected function UpdateDeploymentAdded() : void
      {
         var _loc1_:TCharacter = null;
         var _loc2_:TKnifeOfKillSoulData = null;
         _loc1_ = SLogicsCore.Character;
         if(_loc1_.KnifeSoul.ChangedID != 0)
         {
            _loc2_ = _loc1_.KnifeOfKillSoul.GetByIndentifier(_loc1_.KnifeSoul.ChangedID);
            this.FlushAttributeAdded(this.FTF_AddedFrontNames,this.FTF_AddedFrontValues,_loc2_.AddedFront,this.FrontAddedString);
            this.FlushAttributeAdded(this.FTF_AddedMiddleNames,this.FTF_AddedMiddleValues,_loc2_.AddedMiddle,this.MiddleAddedString);
            this.FlushAttributeAdded(this.FTF_AddedBackNames,this.FTF_AddedBackValues,_loc2_.AddedBack,this.BackAddedString);
         }
         else
         {
            this.ClearTextField(this.FTF_AddedFrontNames);
            this.ClearTextField(this.FTF_AddedFrontValues);
            this.ClearTextField(this.FTF_AddedMiddleNames);
            this.ClearTextField(this.FTF_AddedMiddleValues);
            this.ClearTextField(this.FTF_AddedBackNames);
            this.ClearTextField(this.FTF_AddedBackValues);
            this.FTF_AddedFrontNames[0].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_22);
            this.FTF_AddedFrontValues[0].text = "-40%";
         }
      }
      
      protected function HeroRecommand(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_RecommendsBtn.indexOf(_loc3_);
         if(this.FOnRecommendBtnClick != null)
         {
            this.FOnRecommendBtnClick(_loc2_ + 1);
         }
      }
      
      protected function UpgradeKnifeSoul(param1:MouseEvent) : void
      {
      }
      
      protected function ChangeHeroShape(param1:MouseEvent) : void
      {
         if(this.FFunOnClickChangeShape != null)
         {
            this.FFunOnClickChangeShape(this);
         }
      }
      
      protected function LinkTextUpgradeKnifeSoulClicked(param1:MouseEvent) : void
      {
         if(this.FOnKnifeSoulUpgrade != null)
         {
            this.FOnKnifeSoulUpgrade(this);
         }
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KnifeSoul);
      }
      
      protected function ClearTextField(param1:Vector.<TextField>) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_].text = "";
            _loc2_++;
         }
      }
      
      protected function FlushAttributeAdded(param1:Vector.<TextField>, param2:Vector.<TextField>, param3:Vector.<TKnifeAdd>, param4:Vector.<String>) : void
      {
         var _loc5_:int = 0;
         var _loc6_:TStarPointDesc = null;
         var _loc7_:TKnifeAdd = null;
         _loc5_ = 0;
         while(_loc5_ < param3.length)
         {
            _loc7_ = param3[_loc5_];
            param1[_loc5_].text = param4[_loc5_];
            if(_loc7_.Value < 0)
            {
               param2[_loc5_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_9),int(_loc7_.Value * -1 * 100) + "");
               param2[_loc5_].textColor = 16711680;
            }
            else
            {
               param2[_loc5_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),int(_loc7_.Value * 100) + "");
               param2[_loc5_].textColor = _loc7_.Value == 0 ? 13421772 : 65280;
            }
            _loc5_++;
         }
      }
      
      protected function ShowLightWithIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = 0;
         while(_loc2_ < MAX_COUNT)
         {
            if(this.FSelectHero != null && (this.FSelectHero.Identifier == 11120940 || (this.FSelectHero.Identifier == 11120950 || (this.FSelectHero.Identifier == 11120992 || (this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995 || this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11120995)) || this.FSelectHero.Identifier == 11120991 || this.FSelectHero.Identifier == 11120990 || (this.FSelectHero.Identifier == 11120960 || this.FSelectHero.Identifier == 11120970))) || int(_loc2_ / INDEX_STAMP) + 1 == param1)
            {
               _loc3_ = this.FScene["mc_pos_" + _loc2_];
               if(_loc3_ != null)
               {
                  _loc3_.gotoAndStop(TYPE_LIGHT);
               }
            }
            _loc2_++;
         }
      }
      
      protected function ShowNormal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TActive = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc2_ = this.FScene["mc_pos_" + _loc1_];
            if(_loc2_ != null)
            {
               _loc2_.gotoAndStop(TYPE_NORMAL);
            }
            _loc1_++;
         }
         this.SetStripVisible(true);
      }
      
      protected function ShowDisabledWithIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         _loc4_ = param1 - 1;
         _loc2_ = 0;
         while(_loc2_ < MAX_COUNT)
         {
            if((this.FSelectHero == null || this.FSelectHero.Identifier != 11120940 && (this.FSelectHero.Identifier != 11120950 && (this.FSelectHero.Identifier != 11120992 && (this.FSelectHero.Identifier != 11120994 && this.FSelectHero.Identifier != 11120995 && this.FSelectHero.Identifier != 11120997 && this.FSelectHero.Identifier != 11120995)) && this.FSelectHero.Identifier != 11120991 && this.FSelectHero.Identifier != 11120990 && (this.FSelectHero.Identifier != 11120960 && this.FSelectHero.Identifier != 11120970))) && int(_loc2_ / INDEX_STAMP) + 1 != param1)
            {
               _loc3_ = this.FScene["mc_pos_" + _loc2_];
               if(_loc3_ != null)
               {
                  _loc3_.gotoAndStop(TYPE_DISABLED);
               }
            }
            _loc2_++;
         }
         this.SetStripVisible(false);
         this.FScene["mc_strip_" + _loc4_]["mc_background"].visible = true;
         this.FScene["mc_strip_" + _loc4_].mc_formation.filters = [];
      }
      
      protected function ShowNormalWithIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         _loc4_ = param1 - 1;
         _loc2_ = 0;
         while(_loc2_ < MAX_COUNT)
         {
            if(this.FSelectHero != null && (this.FSelectHero.Identifier == 11120940 || (this.FSelectHero.Identifier == 11120950 || (this.FSelectHero.Identifier == 11120992 || (this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995 || this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11120995)) || this.FSelectHero.Identifier == 11120991 || this.FSelectHero.Identifier == 11120990 || (this.FSelectHero.Identifier == 11120960 || this.FSelectHero.Identifier == 11120970))) || int(_loc2_ / INDEX_STAMP) + 1 == param1)
            {
               _loc3_ = this.FScene["mc_pos_" + _loc2_];
               if(_loc3_ != null)
               {
                  _loc3_.gotoAndStop(TYPE_NORMAL);
               }
            }
            _loc2_++;
         }
      }
      
      protected function SetStripVisible(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < ARMY_COUNT)
         {
            this.FScene["mc_strip_" + _loc2_]["mc_background"].visible = param1;
            if(!param1)
            {
               this.FScene["mc_strip_" + _loc2_].mc_formation.filters = [bBlackFilters];
            }
            else
            {
               this.FScene["mc_strip_" + _loc2_].mc_formation.filters = [];
            }
            _loc2_++;
         }
      }
      
      protected function CheckPlayCount() : void
      {
         var _loc1_:TSystemLanguage = null;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         this.FScene.tf_fightCount.text = this.FHeroDeployment.Count + "/" + this.FMaxPlay;
         switch(this.FMaxPlay)
         {
            case CAPACITY_CurHeros_01:
               _loc2_ = CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_07;
               break;
            case CAPACITY_CurHeros_02:
               _loc2_ = CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_08;
               break;
            default:
               _loc2_ = CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_09;
         }
         _loc1_ = this.FSystemLanguageBins.GetDatebaseByIdentifier(_loc2_) as TSystemLanguage;
         this.FTipCountTF.text = _loc1_.Desc;
         this.FTipCountTF.setTextFormat(this.FNormalFormat);
      }
      
      protected function GetHeroByPos(param1:int) : THero
      {
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         _loc2_ = 0;
         while(_loc2_ < this.FHeroDeployment.Count)
         {
            _loc3_ = this.FHeroDeployment.GetHeroByIndex(_loc2_);
            if(_loc3_.FightPosition == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function CheckInDeployment() : int
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         _loc1_ = this.FScene.mouseX;
         _loc2_ = this.FScene.mouseY;
         if(_loc1_ >= this.FScene.mc_pos_1.x && _loc1_ <= this.FScene.mc_pos_1.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_1.y && _loc2_ <= this.FScene.mc_pos_1.y + DEPLOYMENT_HEIGHT)
         {
            return 1;
         }
         if(_loc1_ >= this.FScene.mc_pos_6.x && _loc1_ <= this.FScene.mc_pos_6.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_6.y && _loc2_ <= this.FScene.mc_pos_6.y + DEPLOYMENT_HEIGHT)
         {
            return 6;
         }
         if(_loc1_ >= this.FScene.mc_pos_7.x && _loc1_ <= this.FScene.mc_pos_7.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_7.y && _loc2_ <= this.FScene.mc_pos_7.y + DEPLOYMENT_HEIGHT)
         {
            return 7;
         }
         if(_loc1_ >= this.FScene.mc_pos_8.x && _loc1_ <= this.FScene.mc_pos_8.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_8.y && _loc2_ <= this.FScene.mc_pos_8.y + DEPLOYMENT_HEIGHT)
         {
            return 8;
         }
         if(_loc1_ >= this.FScene.mc_pos_11.x && _loc1_ <= this.FScene.mc_pos_11.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_11.y && _loc2_ <= this.FScene.mc_pos_11.y + DEPLOYMENT_HEIGHT)
         {
            return 11;
         }
         if(_loc1_ >= this.FScene.mc_pos_12.x && _loc1_ <= this.FScene.mc_pos_12.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_12.y && _loc2_ <= this.FScene.mc_pos_12.y + DEPLOYMENT_HEIGHT)
         {
            return 12;
         }
         if(_loc1_ >= this.FScene.mc_pos_13.x && _loc1_ <= this.FScene.mc_pos_13.x + DEPLOYMENT_WIDTH && _loc2_ >= this.FScene.mc_pos_13.y && _loc2_ <= this.FScene.mc_pos_13.y + DEPLOYMENT_HEIGHT)
         {
            return 13;
         }
         return 0;
      }
      
      protected function OnTextRoll(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            this.FTipCountTF.setTextFormat(this.FOverFormat);
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            this.FTipCountTF.setTextFormat(this.FNormalFormat);
         }
      }
      
      protected function OnTextClicked(param1:MouseEvent) : void
      {
         if(this.FOnEnterMilitary != null)
         {
            this.FOnEnterMilitary(this);
         }
      }
      
      protected function OnChangeHero(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:Boolean = false;
         var _loc6_:TSystemLanguage = null;
         var _loc7_:String = null;
         if(this.FSelectHero == null)
         {
            return;
         }
         _loc5_ = false;
         _loc2_ = this.CheckInDeployment();
         if(this.FSelectHero.Identifier != 11120940 && (this.FSelectHero.Identifier != 11120950 && (this.FSelectHero.Identifier != 11120992 && (this.FSelectHero.Identifier != 11120994 && this.FSelectHero.Identifier != 11120995 && this.FSelectHero.Identifier != 11120997 && this.FSelectHero.Identifier != 11120995)) && this.FSelectHero.Identifier != 11120991 && this.FSelectHero.Identifier != 11120990 && (this.FSelectHero.Identifier != 11120960 && this.FSelectHero.Identifier != 11120970)) && this.FSelectHero.StandPositionWithProfession != int(_loc2_ / INDEX_STAMP) + 1)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > 0)
         {
            if(this.FSelectHero != null && this.FSelectHero.FightPosition != _loc2_)
            {
               if(this.FSelectHero.FightPosition <= 0 && this.FMaxPlay <= this.FHeroDeployment.Count && this.GetHeroByPos(_loc2_) == null)
               {
                  _loc6_ = this.FSystemLanguageBins.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_05) as TSystemLanguage;
                  _loc7_ = _loc6_.Desc;
               }
               else
               {
                  _loc5_ = true;
               }
            }
         }
         else if(this.FSelectHero.IsMain)
         {
            _loc6_ = this.FSystemLanguageBins.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_02) as TSystemLanguage;
            _loc7_ = _loc6_.Desc;
         }
         else
         {
            _loc5_ = true;
         }
         if(_loc5_)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc4_ = _loc3_.Data;
            _loc4_.writeUnsignedInt(this.FSelectHero.Identifier);
            _loc4_.writeByte(_loc2_);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
         else if(_loc7_ != null && _loc7_.length > 0 && this.FOnEffectText != null)
         {
            this.FOnEffectText(_loc7_);
         }
      }
      
      protected function OnSelectHero(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         _loc2_ = int(String(param1.currentTarget.name).slice(7));
         _loc3_ = this.GetHeroByPos(_loc2_);
         this.SetListSelectHero(_loc3_);
         if(this.FSetSelectHero != null)
         {
            this.FSetSelectHero(_loc3_);
         }
      }
      
      private function OnNormalHero(param1:MouseEvent) : void
      {
         if(this.FSelectHero == null)
         {
            return;
         }
         this.ShowNormalWithIndex(this.FSelectHero.StandPositionWithProfession);
      }
      
      protected function OnShowHero(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TActive = null;
         var _loc5_:THero = null;
         _loc2_ = uint(int(String(param1.currentTarget.name).slice(7)));
         _loc5_ = this.GetHeroByPos(_loc2_);
         if(this.FShowHeroInfoTip != null && Boolean(_loc5_))
         {
            this.FShowHeroInfoTip(this,_loc5_);
         }
         if(this.FSelectHero == null)
         {
            return;
         }
         _loc2_ = uint(this.CheckInDeployment());
         this.ShowNormalWithIndex(this.FSelectHero.StandPositionWithProfession);
         if(_loc2_ <= 0)
         {
            _loc3_ = this.FScene["mc_pos_" + this.FMouseInIndex];
            if(_loc3_ != null)
            {
               if(this.FSelectHero.Identifier == 11120940 || (this.FSelectHero.Identifier == 11120950 || (this.FSelectHero.Identifier == 11120992 || (this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995 || this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11120995)) || this.FSelectHero.Identifier == 11120991 || this.FSelectHero.Identifier == 11120990 || (this.FSelectHero.Identifier == 11120960 || this.FSelectHero.Identifier == 11120970)) || this.FSelectHero.StandPositionWithProfession == int(this.FMouseInIndex / INDEX_STAMP) + 1)
               {
                  _loc4_ = _loc3_.getChildByName(CONST_ACTIVE_CLASSNAME) as TActive;
                  if(_loc4_ == null)
                  {
                     if(_loc3_.currentFrame != TYPE_NORMAL)
                     {
                        _loc3_.gotoAndStop(TYPE_NORMAL);
                     }
                  }
               }
            }
            return;
         }
         _loc3_ = this.FScene["mc_pos_" + _loc2_];
         this.FMouseInIndex = _loc2_;
         if(_loc3_ != null)
         {
            if(this.FSelectHero.Identifier == 11120940 || (this.FSelectHero.Identifier == 11120950 || (this.FSelectHero.Identifier == 11120992 || (this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995 || this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11120995)) || this.FSelectHero.Identifier == 11120991 || this.FSelectHero.Identifier == 11120990 || (this.FSelectHero.Identifier == 11120960 || this.FSelectHero.Identifier == 11120970)) || this.FSelectHero.StandPositionWithProfession == int(_loc2_ / INDEX_STAMP) + 1)
            {
               if(_loc3_.currentFrame != TYPE_LIGHT)
               {
                  _loc3_.gotoAndStop(TYPE_LIGHT);
               }
            }
         }
      }
      
      protected function OnHideHero(param1:MouseEvent) : void
      {
         if(this.FHideHeroInfoTip != null)
         {
            this.FHideHeroInfoTip(this);
         }
      }
      
      public function get SetSelectHero() : Function
      {
         return this.FSetSelectHero;
      }
      
      public function set SetSelectHero(param1:Function) : void
      {
         this.FSetSelectHero = param1;
      }
      
      public function get SetSelectHeroBitmapVisible() : Function
      {
         return this.FSetSelectHeroBitmapVisible;
      }
      
      public function set SetSelectHeroBitmapVisible(param1:Function) : void
      {
         this.FSetSelectHeroBitmapVisible = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnEnterMilitary() : Function
      {
         return this.FOnEnterMilitary;
      }
      
      public function set OnEnterMilitary(param1:Function) : void
      {
         this.FOnEnterMilitary = param1;
      }
      
      public function set FunOnClickChangeShape(param1:Function) : void
      {
         this.FFunOnClickChangeShape = param1;
      }
      
      public function set OnRecommendBtnClick(param1:Function) : void
      {
         this.FOnRecommendBtnClick = param1;
      }
      
      public function get ShowHeroInfoTip() : Function
      {
         return this.FShowHeroInfoTip;
      }
      
      public function set ShowHeroInfoTip(param1:Function) : void
      {
         this.FShowHeroInfoTip = param1;
      }
      
      public function get HideHeroInfoTip() : Function
      {
         return this.FHideHeroInfoTip;
      }
      
      public function set HideHeroInfoTip(param1:Function) : void
      {
         this.FHideHeroInfoTip = param1;
      }
      
      public function set OnKnifeSoulUpgrade(param1:Function) : void
      {
         this.FOnKnifeSoulUpgrade = param1;
      }
      
      public function GetCheckFrame() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 2;
         if(this.FSelectHero == null)
         {
            _loc2_ = 2;
         }
         _loc1_ = uint(this.CheckInDeployment());
         if(_loc1_ > 0 && (this.FSelectHero.Identifier == 11120940 || (this.FSelectHero.Identifier == 11120950 || (this.FSelectHero.Identifier == 11120992 || (this.FSelectHero.Identifier == 11120994 || this.FSelectHero.Identifier == 11120995 || this.FSelectHero.Identifier == 11120997 || this.FSelectHero.Identifier == 11120995)) || this.FSelectHero.Identifier == 11120991 || this.FSelectHero.Identifier == 11120990 || (this.FSelectHero.Identifier == 11120960 || this.FSelectHero.Identifier == 11120970)) || this.FSelectHero.StandPositionWithProfession == int(_loc1_ / INDEX_STAMP) + 1))
         {
            _loc2_ = 1;
         }
         return _loc2_;
      }
      
      public function SetScene(param1:MovieClip) : void
      {
         this.FScene = param1;
         this.InitDeployment();
      }
      
      public function SetDeploymentData(param1:int, param2:THeros) : void
      {
         this.FMaxPlay = param1;
         this.FHeroDeployment = param2;
         this.FHeroDeployment.SortByHeroSpeed();
         this.SetUI();
         this.CheckPlayCount();
      }
      
      public function SetListSelectHero(param1:THero = null) : void
      {
         this.FSelectHero = param1;
         if(param1 != null)
         {
            this.ShowDisabledWithIndex(param1.StandPositionWithProfession);
         }
         else
         {
            this.ShowNormal();
         }
      }
      
      public function SetUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TActive = null;
         if(this.FHeroDeployment == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc4_ = this.FScene["mc_pos_" + _loc1_];
            if(_loc4_ != null)
            {
               _loc4_.mc_index.visible = false;
               if(_loc4_.currentFrame != TYPE_NORMAL)
               {
                  _loc4_.gotoAndStop(TYPE_NORMAL);
               }
               this.FIconBitmaps[_loc1_].bitmapData = null;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FHeroDeployment.Count)
         {
            _loc2_ = this.FHeroDeployment.GetHeroByIndex(_loc1_);
            _loc3_ = _loc2_.FightPosition;
            _loc4_ = this.FScene["mc_pos_" + _loc3_];
            if(_loc4_ != null)
            {
               _loc4_.mc_index.visible = true;
               _loc4_.mc_index.tf_index.text = String(_loc1_ + 1);
               if(_loc4_.currentFrame != TYPE_LIGHT)
               {
                  _loc4_.gotoAndStop(TYPE_LIGHT);
               }
               _loc4_.mc_light.visible = false;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.SmallID,this.HeroPicArrive);
            }
            _loc1_++;
         }
      }
      
      protected function HeroPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:THero = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:int = 0;
         if(this.FHeroDeployment == null)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < this.FHeroDeployment.Count)
         {
            _loc6_ = this.FHeroDeployment.GetHeroByIndex(_loc4_);
            if(_loc6_.SmallID == param3)
            {
               _loc8_ = _loc6_.FightPosition;
               this.FIconBitmaps[_loc8_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      public function UpdataUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TActive = null;
         if(this.FHeroDeployment == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FHeroDeployment.Count)
         {
            _loc2_ = this.FHeroDeployment.GetHeroByIndex(_loc1_);
            _loc3_ = _loc2_.FightPosition;
            _loc4_ = this.FScene["mc_pos_" + _loc3_];
            if(_loc4_ != null)
            {
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.SmallID,this.HeroPicArrive);
            }
            _loc1_++;
         }
         this.UpdateKnifeSoulInfor();
         this.UpdateDeploymentAdded();
      }
      
      public function GetPosPoint(param1:uint) : TCoordinate
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TCoordinate = null;
         _loc3_ = this.FScene["mc_pos_" + param1];
         if(_loc3_ != null)
         {
            _loc4_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc3_);
         }
         return _loc4_;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FIconBitmaps.length)
         {
            if(this.FIconBitmaps[_loc1_] != null)
            {
               this.FIconBitmaps[_loc1_].bitmapData = null;
            }
            _loc1_++;
         }
         this.FBitMap_MountPoint.bitmapData = null;
         this.StopWheel_Perform();
      }
   }
}

