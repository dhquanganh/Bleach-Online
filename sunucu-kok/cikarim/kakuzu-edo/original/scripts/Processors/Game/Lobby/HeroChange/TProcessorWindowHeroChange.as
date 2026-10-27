package Processors.Game.Lobby.HeroChange
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.THero;
   import Logics.HeroChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowHeroChange extends TProcessorLobbyWindow
   {
      
      protected static const HeroUINum:int = 3;
      
      protected static const MaterialIconNum:int = 3;
      
      protected static const FreamIndex_Enlist:int = 1;
      
      protected static const FreamIndex_NotEnlist:int = 2;
      
      protected static const MaxStarNum:int = 7;
      
      protected var FTFPowerfulChip:TextField;
      
      protected var FTFNormalSoulPill:TextField;
      
      protected var FTFGradeSoulPill:TextField;
      
      protected var FSoulPillNames:Vector.<String>;
      
      protected var FMaterialIcons:Vector.<Sprite>;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentSelectPage:int;
      
      protected var FHeroUIs:Vector.<Sprite>;
      
      protected var FHeroNames:Vector.<TextField>;
      
      protected var FStarsUI:Vector.<Sprite>;
      
      protected var FLightStars:Vector.<Vector.<Sprite>>;
      
      protected var FDarkStars:Vector.<Vector.<Sprite>>;
      
      protected var FHeroMountPoints:Vector.<Sprite>;
      
      protected var FBtnChanges:Vector.<TUIButton>;
      
      protected var FRoleMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FBtnJmpTrainField:Vector.<TUIButton>;
      
      protected var FSPsMouseOver:Vector.<Sprite>;
      
      protected var FEnlistFlags:Vector.<MovieClip>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FHint:THint;
      
      protected var FHeroChangeData:THeroChangeData;
      
      protected var FTabIndex:int;
      
      protected var FHeros:Vector.<THeroChange>;
      
      protected var FOnJmpToHeroChange:Function;
      
      protected var FOnJmpToHeroTrain:Function;
      
      public function TProcessorWindowHeroChange(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateRoleModel();
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TUIButton = null;
         var _loc6_:Sprite = null;
         var _loc7_:TSceneSpriteMoudle = null;
         var _loc8_:Vector.<Sprite> = null;
         var _loc9_:Vector.<Sprite> = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         addChild(param1);
         _loc2_ = param1["ChipPanle"];
         this.FTFPowerfulChip = _loc2_["PowerfulChip"];
         this.FTFNormalSoulPill = _loc2_["NormalSoulPill"];
         this.FTFGradeSoulPill = _loc2_["GradeSoulPill"];
         this.FMaterialIcons = new Vector.<Sprite>();
         _loc3_ = 0;
         while(_loc3_ < MaterialIconNum)
         {
            _loc6_ = _loc2_["Icon" + _loc3_];
            _loc6_.addEventListener(MouseEvent.MOUSE_MOVE,this.MaterialIconOnMove);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.MaterialIconOnOut);
            this.FMaterialIcons.push(_loc6_);
            _loc3_++;
         }
         _loc2_ = param1["PagePanel"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonNext.Substrate = _loc2_["MC_PageRight"];
         this.FUIPage.ButtonPrevious.Substrate = _loc2_["MC_PageLeft"];
         this.FUIPage.LabelPage = _loc2_["TF_Page"];
         this.FUIPage.PageSize = HeroUINum;
         this.FUIPage.OnChangePage = this.PageOnSwitch;
         this.FUIPage.Init();
         this.FHeroUIs = new Vector.<Sprite>();
         this.FHeroNames = new Vector.<TextField>();
         this.FHeroMountPoints = new Vector.<Sprite>();
         this.FBtnChanges = new Vector.<TUIButton>();
         this.FBtnJmpTrainField = new Vector.<TUIButton>();
         this.FSPsMouseOver = new Vector.<Sprite>();
         this.FRoleMoudles = new Vector.<TSceneSpriteMoudle>();
         this.FQueryModel = new TMoudleInfor();
         this.FEnlistFlags = new Vector.<MovieClip>();
         this.FStarsUI = new Vector.<Sprite>();
         this.FLightStars = new Vector.<Vector.<Sprite>>();
         this.FDarkStars = new Vector.<Vector.<Sprite>>();
         _loc3_ = 0;
         while(_loc3_ < HeroUINum)
         {
            _loc4_ = param1["MC_Heros_" + _loc3_];
            this.FHeroUIs.push(_loc4_);
            _loc6_ = _loc4_["Stars"];
            this.FStarsUI.push(_loc6_);
            _loc8_ = new Vector.<Sprite>();
            _loc9_ = new Vector.<Sprite>();
            _loc10_ = 0;
            while(_loc10_ < MaxStarNum)
            {
               _loc8_.push(_loc6_["Lightstar" + _loc10_]);
               _loc9_.push(_loc6_["Darkstar" + _loc10_]);
               _loc10_++;
            }
            this.FLightStars.push(_loc8_);
            this.FDarkStars.push(_loc9_);
            this.FHeroNames.push(_loc4_["TF_Name"]);
            this.FSPsMouseOver.push(_loc4_["MouseOverUI"]);
            this.FEnlistFlags.push(_loc4_["EnlistFlag"]);
            _loc6_ = _loc4_["MC_MountPoint"];
            _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.HeroOnMouseOver);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnMouseOut);
            this.FHeroMountPoints.push(_loc6_);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc4_["Btn_OK"];
            _loc5_.OnClick = this.BtnChangeOnClick;
            this.FBtnChanges.push(_loc5_);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc4_["Btn_JmpTrainField"];
            _loc5_.OnClick = this.BtnJmpTrainFieldOnClick;
            this.FBtnJmpTrainField.push(_loc5_);
            _loc7_ = new TSceneSpriteMoudle();
            this.FRoleMoudles.push(_loc7_);
            _loc6_.addChild(_loc7_);
            _loc3_++;
         }
         this.FSoulPillNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_06);
         this.FHint = new THint();
      }
      
      public function UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = 0;
         while(_loc1_ < HeroUINum)
         {
            _loc2_ = this.FStarsUI[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnStartMouseMove);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnStartMouseOut);
            _loc1_++;
         }
      }
      
      protected function RenderChipPanle() : void
      {
         this.FTFPowerfulChip.text = this.FHeroChangeData.PowerfulChip.toString();
         this.FTFNormalSoulPill.text = this.FHeroChangeData.NormalSoulPillNum.toString();
         this.FTFGradeSoulPill.text = this.FHeroChangeData.GradeSoulPillNum.toString();
      }
      
      protected function RenderHeroModel() : void
      {
         var _loc1_:TSceneSpriteMoudle = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:THeroChange = null;
         var _loc7_:int = 0;
         _loc2_ = this.FCurrentSelectPage * HeroUINum;
         _loc3_ = _loc2_ + HeroUINum;
         _loc3_ = _loc3_ > this.FHeros.length ? int(this.FHeros.length) : _loc3_;
         _loc4_ = 0;
         _loc7_ = _loc2_;
         while(_loc7_ < _loc3_)
         {
            _loc6_ = this.FHeros[_loc7_];
            this.FHeroNames[_loc4_].text = _loc6_.Hero.Name;
            this.FHeroNames[_loc4_].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc6_.Hero.Quality];
            this.RenderStarLevel(_loc6_,this.FLightStars[_loc4_],this.FDarkStars[_loc4_]);
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc6_.Hero.Identifier,this.FQueryModel);
            this.FRoleMoudles[_loc4_].ChangeRoleMoudle(this.FQueryModel.TextureID,1);
            _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc6_.Hero.Identifier);
            if(_loc5_ != null)
            {
               this.FRoleMoudles[_loc4_].OpenRebirthEffect(_loc5_.IsMain,_loc5_.RebirthNum);
            }
            else
            {
               this.FRoleMoudles[_loc4_].OpenRebirthEffect(false,0);
            }
            this.FHeroUIs[_loc4_].visible = true;
            this.FSPsMouseOver[_loc4_].visible = false;
            if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc6_.Hero.Identifier) != null)
            {
               this.FEnlistFlags[_loc4_].gotoAndStop(FreamIndex_Enlist);
               this.FHeroMountPoints[_loc4_].filters = null;
               this.FHeroMountPoints[_loc4_].visible = true;
               this.FHeroMountPoints[_loc4_].parent["MC_HeroBG"].visible = false;
            }
            else
            {
               this.FEnlistFlags[_loc4_].gotoAndStop(FreamIndex_NotEnlist);
               this.FHeroMountPoints[_loc4_].filters = [TUtilityFilter.GaryColorFiltersTwo];
               this.FHeroMountPoints[_loc4_].visible = false;
               this.FHeroMountPoints[_loc4_].parent["MC_HeroBG"].visible = true;
            }
            this.FBtnJmpTrainField[_loc4_].Enabled = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc6_.Hero.Identifier) != null;
            if(this.FBtnJmpTrainField[_loc4_].Enabled)
            {
               this.FBtnChanges[_loc4_].Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_08);
            }
            else
            {
               this.FBtnChanges[_loc4_].Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_09);
            }
            _loc4_++;
            _loc7_++;
         }
         _loc7_ = _loc4_;
         while(_loc7_ < HeroUINum)
         {
            this.FHeroUIs[_loc7_].visible = false;
            this.FRoleMoudles[_loc7_].ReleaseModuleResource();
            this.FRoleMoudles[_loc7_].Release();
            _loc7_++;
         }
      }
      
      protected function RenderStarLevel(param1:THeroChange, param2:Vector.<Sprite>, param3:Vector.<Sprite>) : void
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < MaxStarNum)
         {
            param2[_loc4_].visible = _loc4_ < param1.Hero.ChangeSchedule;
            param3[_loc4_].visible = _loc4_ < param1.PartnerChanges.length;
            _loc4_++;
         }
      }
      
      protected function UpdateRoleModel() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < HeroUINum)
         {
            if(this.FRoleMoudles[_loc1_].TextrueID != 0)
            {
               this.FRoleMoudles[_loc1_].UpdateView();
            }
            _loc1_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function BtnChangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnChanges.indexOf(param1 as TUIButton);
         _loc3_ += this.FCurrentSelectPage * HeroUINum;
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FHeros[_loc3_].Hero.Identifier) == null)
         {
            switch(this.FTabIndex)
            {
               case CONST_HEROCHANGE.HeroChangeTabIndex_Traven:
                  ProcessorWindowClose();
                  SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
                  break;
               case CONST_HEROCHANGE.HeroChangeTabIndex_TeamBattle:
                  ProcessorWindowClose();
                  SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TeamBattle);
                  break;
               case CONST_HEROCHANGE.HeroChangeTabIndex_GongfuFight:
                  SUtilityOverLayer.UIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_10);
                  SUtilityOverLayer.UIWindowInformation.Visible = true;
                  SUtilityOverLayer.UIWindowInformation.OnOK = null;
                  break;
               case CONST_HEROCHANGE.HeroChangeTabIndex_Free:
                  SUtilityOverLayer.UIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_11);
                  SUtilityOverLayer.UIWindowInformation.Visible = true;
                  SUtilityOverLayer.UIWindowInformation.OnOK = null;
            }
            return;
         }
         if(this.FOnJmpToHeroChange != null)
         {
            this.FOnJmpToHeroChange(this.FHeros,_loc3_);
         }
      }
      
      protected function BtnJmpTrainFieldOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc3_ = this.FBtnJmpTrainField.indexOf(param1 as TUIButton);
         _loc3_ += this.FCurrentSelectPage * HeroUINum;
         _loc4_ = this.FHeros[_loc3_];
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_.Hero.Identifier) == null)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_07));
            return;
         }
         if(this.FOnJmpToHeroTrain != null)
         {
            this.FOnJmpToHeroTrain(_loc4_);
         }
      }
      
      protected function HeroOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroMountPoints.indexOf(param1.currentTarget as Sprite);
         this.FSPsMouseOver[_loc2_].visible = true;
      }
      
      protected function HeroOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroMountPoints.indexOf(param1.currentTarget as Sprite);
         this.FSPsMouseOver[_loc2_].visible = false;
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentSelectPage = param2;
         this.RenderHeroModel();
      }
      
      protected function MaterialIconOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FMaterialIcons.indexOf(param1.currentTarget as Sprite);
         this.FHint.Caption = this.FSoulPillNames[_loc2_];
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function MaterialIconOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnStartMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FStarsUI.indexOf(param1.currentTarget as Sprite);
         _loc2_ += this.FCurrentSelectPage * HeroUINum;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHeros[_loc2_]);
      }
      
      protected function OnStartMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHeros[0]);
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function set OnJmpToHeroChange(param1:Function) : void
      {
         this.FOnJmpToHeroChange = param1;
      }
      
      public function set OnJmpToHeroTrain(param1:Function) : void
      {
         this.FOnJmpToHeroTrain = param1;
      }
      
      public function ChangeHeroList(param1:Vector.<THeroChange>, param2:int) : void
      {
         this.FHeros = param1;
         this.FTabIndex = param2;
         this.RenderChipPanle();
         this.SetupPage(param1.length,0,this.FUIPage);
         this.FCurrentSelectPage = 0;
         this.RenderHeroModel();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < HeroUINum)
         {
            if(this.FRoleMoudles[_loc1_].RoleTempleteID != 0)
            {
               this.FRoleMoudles[_loc1_].ReleaseModuleResource();
               this.FRoleMoudles[_loc1_].Release();
               this.FHeroMountPoints[_loc1_].filters = null;
            }
            _loc1_++;
         }
      }
      
      public function ChangeNotify() : void
      {
         this.RenderHeroModel();
      }
      
      public function MakePillNotify() : void
      {
         this.RenderChipPanle();
      }
      
      public function ExchangePillNotify() : void
      {
         this.RenderChipPanle();
      }
      
      public function CommonMaterialUpdateNotify() : void
      {
         this.RenderChipPanle();
      }
   }
}

