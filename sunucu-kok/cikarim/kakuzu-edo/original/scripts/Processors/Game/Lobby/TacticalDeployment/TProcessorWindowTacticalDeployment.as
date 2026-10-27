package Processors.Game.Lobby.TacticalDeployment
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GeneralStar.*;
   import Logics.Skills.*;
   import Processors.Game.Battle.Character.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TacticalDeployment.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import ghostcat.util.easing.*;
   
   public class TProcessorWindowTacticalDeployment extends TProcessorLobbyWindow
   {
      
      protected static const MAX_COUNT:int = 10;
      
      protected static const INIT_WIDTH:Number = 205;
      
      protected static var MoveTimesCount:uint = 70;
      
      protected var FHelpTips:THint;
      
      protected var FScene:MovieClip;
      
      protected var FSceneCheck:MovieClip;
      
      protected var FMaxHeroCount:uint;
      
      protected var FMaxPointCount:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FHeros:THeros;
      
      protected var FCurPage:int;
      
      protected var FTotlePage:int;
      
      protected var FSelectHeroBitmap:Bitmap;
      
      protected var FSelectHero:THero;
      
      protected var FShowHeroCoordinate:TCoordinate;
      
      protected var FHint:THint;
      
      protected var FRoleModel:TBins;
      
      protected var FHeroList:THeroList;
      
      protected var FHeroDeployment:THeroDeployment;
      
      protected var FHeroInfoTip:TDeploymentTip;
      
      protected var FIsAutoSet:Boolean;
      
      protected var FAutoHeroId:uint;
      
      protected var FAutoPos:uint;
      
      protected var FAutoHeroModelId:uint;
      
      protected var StartHeroPoint:TCoordinate;
      
      protected var EndPosPoint:TCoordinate;
      
      protected var MoveTimesIndex:uint;
      
      protected var FAutoEndFun:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnEnterMilitary:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnSetBackToDepoly:Function;
      
      protected var FTriggerFreshGuide:Boolean;
      
      public function TProcessorWindowTacticalDeployment(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FCharacter = SLogicsCore.Character;
         this.FHeroDeployment = new THeroDeployment(this);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.CheckMouseIcon();
         if(this.FHeroList != null)
         {
            this.FHeroList.UpdataHeroList();
         }
         if(this.FHeroDeployment != null)
         {
            this.FHeroDeployment.UpdataUI();
         }
         if(this.FHeroInfoTip != null && this.FHeroInfoTip.visible == true)
         {
            this.FHeroInfoTip.UpdataBitmap();
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DEPLOYMENT.RESOURCESID_TacticalDeployment);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_DEPLOYMENT.RESOURCE_ClassName_TacticalDeployment) as MovieClip;
         addChild(this.FScene);
         this.FHeroList = new THeroList(this,this.FScene.mc_heroList);
         this.FHeroList.ShowHeroInfoTip = this.ShowHeroInfoTip;
         this.FHeroList.HideHeroInfoTip = this.HideHeroInfoTip;
         this.FHeroList.SetSelectHero = this.SetListSelectHero;
         this.FHeroList.visible = false;
         this.FHeroDeployment.SetScene(this.FScene);
         this.FHeroDeployment.SetSelectHero = this.SetDeploymentSelectHero;
         this.FHeroDeployment.SetSelectHeroBitmapVisible = this.SetSelectHeroBitmapVisible;
         this.FHeroDeployment.OnEffectText = EffectGenerateText;
         this.FHeroDeployment.OnEnterMilitary = this.EnterMilitary;
         this.FHeroDeployment.FunOnClickChangeShape = this.OnClickChangeShapeClick;
         this.FHeroDeployment.OnRecommendBtnClick = this.OnRecommandBtnClick;
         this.FHeroDeployment.ShowHeroInfoTip = this.ShowHeroInfoTip;
         this.FHeroDeployment.HideHeroInfoTip = this.HideHeroInfoTip;
         this.FHeroDeployment.OnKnifeSoulUpgrade = this.OnCloseWindow;
         this.FHeroInfoTip = new TDeploymentTip(this.Parent);
         this.FHeroInfoTip.Visible = false;
         this.FSelectHeroBitmap = new Bitmap();
         addChild(this.FSelectHeroBitmap);
         this.FHint = new THint();
         this.FScene.tf_battleValue.text = "";
         this.FIsAutoSet = false;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_WindowDeployment,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_WindowDeployment,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);
         this.FScene.btn_help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver);
         this.FScene.btn_help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut);
         TGameUtil.setButtonMode(this.FScene.mc_heroListPage.btn_left,true);
         this.FScene.mc_heroListPage.btn_left.addEventListener(MouseEvent.CLICK,this.OnLeft);
         TGameUtil.setButtonMode(this.FScene.mc_heroListPage.btn_right,true);
         this.FScene.mc_heroListPage.btn_right.addEventListener(MouseEvent.CLICK,this.OnRight);
         addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         super.ResourcesPerform_UILocations();
      }
      
      protected function OnClickChangeShapeClick(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_KnifeOfKillSoul);
         if(this.FOnSetBackToDepoly != null)
         {
            this.FOnSetBackToDepoly(this);
         }
      }
      
      protected function OnChangeShapeCloseClick(param1:Object) : void
      {
         this.FScene.visible = true;
      }
      
      protected function OnRecommendCloseClick(param1:Object) : void
      {
         this.FScene.visible = true;
      }
      
      protected function OnRecommandBtnClick(param1:int) : void
      {
         this.FScene.visible = false;
      }
      
      protected function CheckBtn() : void
      {
         this.FScene.mc_heroListPage.btn_left.visible = Boolean(this.FCurPage != 1);
         this.FScene.mc_heroListPage.btn_right.visible = Boolean(this.FCurPage != this.FTotlePage);
      }
      
      protected function UpdataUI() : void
      {
         this.ResetHeroList();
         this.ResetDeployment();
      }
      
      protected function GetPageHeroInfo() : THeros
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeros = null;
         var _loc5_:THero = null;
         _loc2_ = (this.FCurPage - 1) * MAX_COUNT;
         _loc3_ = Math.min(_loc2_ + MAX_COUNT,this.FHeros.Count);
         _loc4_ = new THeros();
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = this.FHeros.GetHeroByIndex(_loc1_);
            _loc4_.Add(_loc5_);
            _loc1_++;
         }
         return _loc4_;
      }
      
      protected function GetDeploymentHeroInfo() : THeros
      {
         var _loc1_:int = 0;
         var _loc2_:THeros = null;
         var _loc3_:THero = null;
         _loc2_ = new THeros();
         _loc1_ = 0;
         while(_loc1_ < this.FHeros.Count)
         {
            _loc3_ = this.FHeros.GetHeroByIndex(_loc1_);
            if(_loc3_.FightPosition > 0)
            {
               _loc2_.Add(_loc3_);
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      protected function SetListSelectHero(param1:THero = null) : void
      {
         this.FSelectHero = param1;
         this.FHeroDeployment.SetListSelectHero(param1);
      }
      
      protected function SetDeploymentSelectHero(param1:THero = null) : void
      {
         this.FSelectHero = param1;
      }
      
      protected function CheckMouseIcon() : void
      {
         var _loc1_:TRoleModel = null;
         var _loc2_:TCoordinate = null;
         if(this.FIsAutoSet)
         {
            this.UpdateAutoSetMove();
            return;
         }
         if(this.FSelectHero != null)
         {
            _loc1_ = this.FRoleModel.GetDatebaseByIdentifier(this.FSelectHero.Identifier) as TRoleModel;
            TGameUtil.ShowImageByID(TGameUtil.Type_HeadIcon,this.FSelectHeroBitmap,_loc1_.RoleHead);
            if(this.FSelectHeroBitmap.bitmapData != null)
            {
               this.FSelectHeroBitmap.x = mouseX;
               this.FSelectHeroBitmap.y = mouseY;
               this.FSelectHeroBitmap.alpha = 0.7;
            }
         }
         else if(this.FSelectHeroBitmap != null && this.FSelectHeroBitmap.bitmapData != null)
         {
            this.FSelectHeroBitmap.bitmapData = null;
         }
      }
      
      protected function UpdateAutoSetMove() : void
      {
         var _loc1_:TCoordinate = null;
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         TGameUtil.ShowImageByID(TGameUtil.Type_HeadIcon,this.FSelectHeroBitmap,this.FAutoHeroModelId);
         if(this.FSelectHeroBitmap.bitmapData != null)
         {
            this.FSelectHeroBitmap.x = this.StartHeroPoint.X + this.MoveTimesIndex * (this.EndPosPoint.X - this.StartHeroPoint.X) / MoveTimesCount;
            this.FSelectHeroBitmap.y = this.StartHeroPoint.Y + this.MoveTimesIndex * (this.EndPosPoint.Y - this.StartHeroPoint.Y) / MoveTimesCount;
            this.FSelectHeroBitmap.alpha = 0.7;
         }
         ++this.MoveTimesIndex;
         if(this.MoveTimesIndex > MoveTimesCount)
         {
            this.FIsAutoSet = false;
            mouseEnabled = true;
            mouseChildren = true;
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc3_ = _loc2_.Data;
            _loc3_.writeUnsignedInt(this.FAutoHeroId);
            _loc3_.writeByte(this.FAutoPos);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
            if(this.FAutoEndFun != null)
            {
               this.FAutoEndFun(this);
            }
         }
      }
      
      protected function SetSelectHeroBitmapVisible(param1:Boolean) : void
      {
         this.FSelectHeroBitmap.visible = param1;
      }
      
      protected function ShowHeroInfoTip(param1:Object, param2:THero) : void
      {
         this.FHeroInfoTip.Visible = true;
         this.FHeroInfoTip.SetHeroData(param2);
      }
      
      protected function HideHeroInfoTip(param1:Object) : void
      {
         this.FHeroInfoTip.Visible = false;
      }
      
      protected function LogoOnMove(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Vector.<TAdditionRate> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:TStarPointDesc = null;
         var _loc8_:int = 0;
         _loc6_ = "";
         _loc2_ = param1.currentTarget as Sprite;
         if(_loc2_.name == "MC_LogoFront")
         {
            _loc3_ = this.FCharacter.EsotericPoints.GetRatesByIndex(0);
         }
         else if(_loc2_.name == "MC_LogoMiddle")
         {
            _loc3_ = this.FCharacter.EsotericPoints.GetRatesByIndex(1);
         }
         else if(_loc2_.name == "MC_LogoAfter")
         {
            _loc3_ = this.FCharacter.EsotericPoints.GetRatesByIndex(2);
         }
         _loc5_ = int(_loc3_.length);
         if(_loc5_ <= 0)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc3_[_loc4_].Key == 0)
            {
               _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_10),_loc3_[_loc4_].Value);
            }
            else if(_loc3_[_loc4_].Key == 101)
            {
               _loc8_ = 17500000 + _loc3_[_loc4_].Key;
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,_loc8_) as TStarPointDesc;
               _loc6_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_13),_loc7_.Desc,_loc3_[_loc4_].Value);
            }
            else
            {
               _loc8_ = 17500000 + _loc3_[_loc4_].Key;
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,_loc8_) as TStarPointDesc;
               _loc6_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_11),_loc7_.Desc,_loc3_[_loc4_].Value);
            }
            _loc4_++;
         }
         this.FHint.Caption = _loc6_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(param1,this.FHint);
         }
      }
      
      protected function LogoOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnMouseCheck() : void
      {
         if(this.FSceneCheck)
         {
            this.FSceneCheck.visible = Boolean(this.FSelectHero != null);
         }
         if(this.FSelectHero == null)
         {
            return;
         }
         this.FSceneCheck.x = mouseX + 15;
         this.FSceneCheck.y = mouseY + 7;
         this.FSceneCheck.gotoAndStop(this.FHeroDeployment.GetCheckFrame());
      }
      
      protected function OnCloseWindow(param1:Object) : void
      {
         if(this.FTriggerFreshGuide)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_21));
            return;
         }
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_TacticalDeployment);
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
      
      protected function OnLeft(param1:MouseEvent = null) : void
      {
         --this.FCurPage;
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         this.FHeroList.SetHerosData(this.GetPageHeroInfo());
         this.CheckBtn();
         this.FScene.mc_heroListPage.tf_heroListPage.text = this.FCurPage + "/" + this.FTotlePage;
      }
      
      protected function OnRight(param1:MouseEvent = null) : void
      {
         ++this.FCurPage;
         if(this.FCurPage > this.FTotlePage)
         {
            this.FCurPage = this.FTotlePage;
         }
         this.FHeroList.SetHerosData(this.GetPageHeroInfo());
         this.CheckBtn();
         this.FScene.mc_heroListPage.tf_heroListPage.text = this.FCurPage + "/" + this.FTotlePage;
      }
      
      protected function OnMouseUp(param1:MouseEvent) : void
      {
         this.SetListSelectHero();
      }
      
      protected function EnterMilitary(param1:Object) : void
      {
         if(this.FOnEnterMilitary != null)
         {
            this.FOnEnterMilitary(param1);
         }
      }
      
      public function set MaxPointCount(param1:uint) : void
      {
         this.FMaxPointCount = param1;
      }
      
      public function set MaxHeroCount(param1:uint) : void
      {
         this.FMaxHeroCount = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
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
      
      public function get OnEnterMilitary() : Function
      {
         return this.FOnEnterMilitary;
      }
      
      public function set OnEnterMilitary(param1:Function) : void
      {
         this.FOnEnterMilitary = param1;
      }
      
      public function set OnSetBackToDepoly(param1:Function) : void
      {
         this.FOnSetBackToDepoly = param1;
      }
      
      public function SetupDeploymentData() : void
      {
         this.FHeros = this.FCharacter.Heros;
         this.FCurPage = 1;
         this.FTotlePage = Math.max((this.FHeros.Count - 1) / MAX_COUNT + 1,1);
         this.OnLeft();
         this.UpdataUI();
         if(Boolean(this.FScene) && Boolean(this.FScene.tf_count))
         {
            this.FScene.tf_count.text = this.FHeros.Count + "/" + this.FMaxHeroCount;
         }
         this.UserUpdateFightingPower();
      }
      
      public function UserUpdateFightingPower() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FCharacter.GetFightingPower();
         this.FScene.tf_battleValue.text = _loc1_.toString();
      }
      
      public function ResetHeroList() : void
      {
         if(this.FHeroList != null)
         {
            this.FHeroList.SetHerosData(this.GetPageHeroInfo());
         }
      }
      
      public function ResetDeployment() : void
      {
         this.FHeroDeployment.SetDeploymentData(this.FMaxPointCount,this.GetDeploymentHeroInfo());
         this.UserUpdateFightingPower();
      }
      
      public function AutoSetDeployment(param1:uint, param2:uint, param3:Function = null) : void
      {
         var _loc4_:TRoleModel = null;
         this.StartHeroPoint = this.FHeroList.GetHeroPoint(param1);
         this.EndPosPoint = this.FHeroDeployment.GetPosPoint(param2);
         if(this.StartHeroPoint == null && this.EndPosPoint == null)
         {
            return;
         }
         _loc4_ = this.FRoleModel.GetDatebaseByIdentifier(param1) as TRoleModel;
         this.StartHeroPoint.X -= this.x;
         this.StartHeroPoint.Y -= this.y;
         this.EndPosPoint.X -= this.x - 20;
         this.EndPosPoint.Y -= this.y - 15;
         this.MoveTimesIndex = 0;
         this.FAutoHeroId = param1;
         this.FAutoPos = param2;
         this.FAutoHeroModelId = _loc4_.RoleHead;
         this.FIsAutoSet = true;
         mouseEnabled = false;
         mouseChildren = false;
         this.FAutoEndFun = param3;
      }
      
      public function Reset() : void
      {
         this.FHeroDeployment.Reset();
         this.FHeroList.Reset();
         if(this.FHeroInfoTip != null)
         {
            this.FHeroInfoTip.Reset();
         }
      }
      
      public function SetupForcePromptFreshGuide(param1:Boolean) : void
      {
         this.FTriggerFreshGuide = param1;
      }
   }
}

