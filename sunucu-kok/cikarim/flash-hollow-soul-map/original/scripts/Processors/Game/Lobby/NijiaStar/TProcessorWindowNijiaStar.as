package Processors.Game.Lobby.NijiaStar
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.NijiaStar.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.NijiaStar.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowNijiaStar extends TProcessorLobbyWindow
   {
      
      protected static const TEMP_NUM:uint = 82200001;
      
      protected static const BLUEFIRE_NUM:uint = 4;
      
      protected const CAPACITY_KingSouls:uint = 8;
      
      protected const CAPACITY_HeroHead:uint = 6;
      
      protected const CAPACITY_NijiaStar:uint = 7;
      
      protected var FMC_NijiaStar:MovieClip;
      
      protected var FMC_BaseCostInfo:Sprite;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBTN_Help:SimpleButton;
      
      protected var FBTN_NijiaStarInherit:TUIButton;
      
      protected var FBTN_GetKingSoul:TUIButton;
      
      protected var FMC_HeroBox:MovieClip;
      
      protected var FBTN_Left:TUIButton;
      
      protected var FBTN_Right:TUIButton;
      
      protected var FMC_KingSoulChart:Sprite;
      
      protected var FTF_Silver:TextField;
      
      protected var FTF_Gold:TextField;
      
      protected var FTF_GiftCertificate:TextField;
      
      protected var FSoulNumList:Vector.<TextField>;
      
      protected var FHeroHeadList:Vector.<TUISlot>;
      
      protected var FMainPoints:Vector.<TUIMainPoint>;
      
      protected var FCurPage:int;
      
      protected var FTotalPage:int;
      
      protected var FHeros:THeros;
      
      protected var FHero:THero;
      
      protected var FHelpTips:THint;
      
      protected var FCharacter:TCharacter;
      
      protected var FSevenHeroSoul:TSevenHeroSoul;
      
      protected var FHint:THint;
      
      protected var FUIHero:TUIHero;
      
      protected var FMC_Role:Sprite;
      
      protected var FMC_CloseBox:Sprite;
      
      protected var FMC_FireLeft:MovieClip;
      
      protected var FMC_FireRight:MovieClip;
      
      protected var FMC_BlueFire:MovieClip;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FMainPointOnClick:Function;
      
      protected var FExchangeOnClick:Function;
      
      protected var FGetKingSoulOnClick:Function;
      
      protected var FUIComponentsOnOver:Function;
      
      protected var FUIComponentsOnOut:Function;
      
      protected var FUIHintOnOver:Function;
      
      protected var FUIHintOnOut:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorWindowNijiaStar(param1:TUIComponent)
      {
         super(param1);
         this.FSoulNumList = new Vector.<TextField>(this.CAPACITY_KingSouls);
         this.FHeroHeadList = new Vector.<TUISlot>(this.CAPACITY_HeroHead);
         this.FMainPoints = new Vector.<TUIMainPoint>(this.CAPACITY_NijiaStar);
         this.FRolesModelID = new Vector.<int>();
         this.FHint = new THint();
         this.FHelpTips = new THint();
         this.FCharacter = SLogicsCore.Character;
         this.FHeros = this.FCharacter.Heros;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_NIJIASTAR.RESOURCESID_Swf_NjiaStar);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIMainPoint = null;
         var _loc6_:TUISubPoint = null;
         var _loc7_:TextField = null;
         var _loc8_:TSevenHeroSoul = null;
         var _loc9_:TBins = null;
         var _loc10_:TBounds = null;
         var _loc11_:TCoordinate = null;
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroSoul) as TBins;
         this.FMC_NijiaStar = TUtilityReflection.CreateDisplayObjectInstance(CONST_NIJIASTAR.RESOURCE_ClassName_MC_NjiaStar) as MovieClip;
         addChild(this.FMC_NijiaStar);
         this.FMC_BaseCostInfo = this.FMC_NijiaStar[CONST_NIJIASTAR.RESOURCES_Link_MC_BaseCostInfo];
         this.FMC_CloseBox = this.FMC_BaseCostInfo[CONST_NIJIASTAR.RESOURCES_Link_MC_HelpClose];
         this.FBTN_Close = this.FMC_CloseBox[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBTN_Help = this.FMC_CloseBox[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FMC_HeroBox = this.FMC_NijiaStar[CONST_NIJIASTAR.RESOURCES_Link_MC_HeroBox];
         this.FBTN_Left = new TUIButton();
         this.FBTN_Left.Substrate = this.FMC_HeroBox[CONST_NIJIASTAR.RESOURCES_Link_BTN_Left];
         this.FBTN_Left.OnClick = this.OnLeft;
         this.FBTN_Right = new TUIButton();
         this.FBTN_Right.Substrate = this.FMC_HeroBox[CONST_NIJIASTAR.RESOURCES_Link_BTN_Right];
         this.FBTN_Right.OnClick = this.OnRight;
         this.FBTN_NijiaStarInherit = new TUIButton();
         this.FBTN_NijiaStarInherit.Substrate = this.FMC_HeroBox[CONST_NIJIASTAR.RESOURCES_Link_BTN_NijiaStarInherit];
         this.FBTN_NijiaStarInherit.OnClick = this.BTNExchangeOnClick;
         this.FBTN_GetKingSoul = new TUIButton();
         this.FBTN_GetKingSoul.Substrate = this.FMC_HeroBox[CONST_NIJIASTAR.RESOURCES_Link_BTN_GetKingSoul];
         this.FBTN_GetKingSoul.OnClick = this.BTNGetKingSoulOnClick;
         this.FTF_Silver = this.FMC_BaseCostInfo[CONST_NIJIASTAR.RESOURCES_Link_TF_Silver];
         this.FTF_Gold = this.FMC_BaseCostInfo[CONST_NIJIASTAR.RESOURCES_Link_TF_Gold];
         this.FTF_GiftCertificate = this.FMC_BaseCostInfo[CONST_NIJIASTAR.RESOURCES_Link_TF_GiftCertificate];
         _loc2_ = this.CAPACITY_KingSouls;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FMC_BaseCostInfo[CONST_NIJIASTAR.RESOURCES_Link_MC_SoulNum + _loc1_];
            _loc7_.selectable = false;
            _loc7_.text = "";
            this.FSoulNumList[_loc1_] = _loc7_;
            _loc1_++;
         }
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = this.FMC_HeroBox[CONST_NIJIASTAR.RESOURCES_Link_MC_Hero + _loc1_];
            _loc4_.OnClick = this.ProcessorHeroHeadOnLcick;
            _loc4_.OnOut = this.ProcessorPointOnOut;
            _loc4_.OnOver = this.ProcessorPointOnOver;
            _loc4_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc4_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc4_.OnQuerySelectedContext = this.SlotsOnSelectedContext;
            _loc4_.Init();
            this.FHeroHeadList[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FMC_KingSoulChart = this.FMC_NijiaStar[CONST_NIJIASTAR.RESOURCES_Link_MC_KingSoulChart];
         _loc2_ = this.CAPACITY_NijiaStar;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUIMainPoint(this);
            _loc5_.Resoures = this.FMC_KingSoulChart[CONST_NIJIASTAR.RESOURCES_Link_MC_MainPoint + _loc1_];
            _loc5_.OnClick = this.ProcessorPointOnClick;
            _loc5_.OnOut = this.ProcessorPointOnOut;
            _loc5_.OnOver = this.ProcessorPointOnOver;
            _loc5_.Tag = _loc1_;
            _loc5_.Init();
            this.FMainPoints[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FMC_Role = this.FMC_NijiaStar["MC_Role"];
         this.FUIHero = new TUIHero(this);
         this.FMC_Role.mouseEnabled = false;
         this.FMC_Role.mouseChildren = false;
         this.FMC_Role.addChild(this.FUIHero);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIHero.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         _loc10_ = new TBounds();
         _loc11_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc11_,_loc10_);
         this.FUIHero.X = _loc10_.X;
         this.FUIHero.Y = _loc10_.Y;
         _loc3_ = this.FMC_NijiaStar["MC_Fire"];
         this.FMC_FireLeft = _loc3_["MC_Left"];
         this.FMC_FireRight = _loc3_["MC_Right"];
         this.FMC_BlueFire = this.FMC_HeroBox["MC_BlueFire"];
         this.FMC_BlueFire.stop();
         this.FMC_NijiaStar.MC_RedLight.stop();
         this.FMC_FireLeft.stop();
         this.FMC_FireRight.stop();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TextField = null;
         _loc2_ = this.CAPACITY_KingSouls;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FSoulNumList[_loc1_];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.MCKingSoulOnOver,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.MCKingSoulOnOut,false,0,true);
            _loc1_++;
         }
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.BTNCloseOnClick,false,0,true);
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonHelpOnOver,false,0,true);
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FHeroHeadList != null)
            {
               _loc2_ = this.CAPACITY_HeroHead;
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  _loc3_ = this.FHeroHeadList[_loc1_];
                  _loc3_.Update();
                  _loc1_++;
               }
            }
            if(this.FUIHero != null)
            {
               this.FUIHero.Update();
            }
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = FUICore.StageWidth;
         if(this.FMC_NijiaStar != null)
         {
            this.FMC_CloseBox.x = _loc1_ - this.FMC_CloseBox.width;
            this.FMC_HeroBox.x = _loc1_ - this.FMC_HeroBox.width;
         }
      }
      
      protected function UpdatePage() : void
      {
         this.FBTN_Left.Visible = Boolean(this.FCurPage != 1);
         this.FBTN_Right.Visible = Boolean(this.FCurPage != this.FTotalPage);
      }
      
      protected function UpdateHeroHeadInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:uint = 0;
         var _loc5_:THero = null;
         this.FHeros.Sort();
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc3_.Resource.visible = false;
            _loc3_.IsSelected = false;
            _loc1_++;
         }
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc1_ + (this.FCurPage - 1) * this.CAPACITY_HeroHead;
            if(_loc4_ >= this.FHeros.Count)
            {
               break;
            }
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc5_ = this.FHeros.GetHeroByIndex(_loc4_);
            _loc3_.Context = _loc5_;
            if(this.FHero == _loc5_)
            {
               _loc3_.IsSelected = true;
            }
            _loc3_.Resource.visible = true;
            _loc1_++;
         }
      }
      
      protected function UpdateCostText() : void
      {
         this.FTF_Silver.text = this.FCharacter.CreditSilverCoin.ToNumber() + "";
         this.FTF_Gold.text = this.FCharacter.CreditGold.toString();
         this.FTF_GiftCertificate.text = this.FCharacter.CreditGiftCertificate.toString();
      }
      
      protected function UpdateHeroMainPoint() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TNijiaStar = null;
         var _loc4_:TNijiaStars = null;
         var _loc5_:TUIMainPoint = null;
         _loc4_ = this.FHero.NijiaStars;
         _loc2_ = uint(_loc4_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetNijiaStarByIndex(_loc1_);
            _loc5_ = this.FMainPoints[_loc1_];
            _loc5_.Context = _loc3_;
            _loc5_.SetSubPointInfo();
            _loc1_++;
         }
      }
      
      protected function SelectHero() : void
      {
         this.FHero = this.FHeros.GetHeroByIndex((this.FCurPage - 1) * this.CAPACITY_HeroHead);
         this.FUIHero.Context = this.FHero;
      }
      
      protected function PlayEffects() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.FMC_NijiaStar.gotoAndPlay(1);
         this.FMC_NijiaStar.MC_Arm.gotoAndPlay(1);
         this.FMC_HeroBox.gotoAndPlay(1);
         this.FMC_NijiaStar.MC_RedLight.play();
         this.FMC_FireLeft.play();
         this.FMC_FireRight.play();
         this.FMC_BlueFire.play();
      }
      
      protected function ProcessorPointOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TUIMainPoint = null;
         var _loc4_:TNijiaStar = null;
         if(param1 is TUIMainPoint)
         {
            _loc3_ = param1 as TUIMainPoint;
         }
         if(param2 is TNijiaStar)
         {
            _loc4_ = param2 as TNijiaStar;
            if(_loc4_.Identifier == -1)
            {
               return;
            }
         }
         if(this.FMainPointOnClick != null)
         {
            if(this.FMainPointOnClick != null)
            {
               this.FMainPointOnClick(this,param2,_loc3_,this.FHero);
            }
         }
      }
      
      protected function ProcessorPointOnOut(param1:Object, param2:Object) : void
      {
         var _loc3_:TNijiaStar = null;
         if(param2 is TNijiaStar)
         {
            _loc3_ = param2 as TNijiaStar;
            if(_loc3_.Identifier != -1)
            {
               if(this.FUIComponentsOnOut != null)
               {
                  this.FUIComponentsOnOut(this,param2);
               }
            }
            else if(this.FUIHintOnOut != null)
            {
               this.FUIHintOnOut(this,this.FHint);
            }
         }
         else if(param2 is THero)
         {
            if(this.FUIComponentsOnOut != null)
            {
               this.FUIComponentsOnOut(this,param2);
            }
         }
      }
      
      protected function ProcessorPointOnOver(param1:Object, param2:Object) : void
      {
         var _loc3_:TNijiaStar = null;
         if(param2 is TNijiaStar)
         {
            _loc3_ = param2 as TNijiaStar;
            if(_loc3_.Identifier != -1)
            {
               if(this.FUIComponentsOnOver != null)
               {
                  this.FUIComponentsOnOver(this,param2);
               }
            }
            else
            {
               this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_16),_loc3_.HeroName);
               if(this.FUIHintOnOver != null)
               {
                  this.FUIHintOnOver(this,this.FHint);
               }
            }
         }
         else if(param2 is THero)
         {
            if(this.FUIComponentsOnOver != null)
            {
               this.FUIComponentsOnOver(this,param2);
            }
         }
      }
      
      protected function OnLeft(param1:Object, param2:MouseEvent) : void
      {
         --this.FCurPage;
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         this.UpdatePage();
         this.UpdateHeroHeadInfo();
      }
      
      protected function OnRight(param1:Object, param2:MouseEvent) : void
      {
         ++this.FCurPage;
         if(this.FCurPage > this.FTotalPage)
         {
            this.FCurPage = this.FTotalPage;
         }
         this.UpdatePage();
         this.UpdateHeroHeadInfo();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_NijiaStar);
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
      
      protected function BTNCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function MCKingSoulOnOut(param1:MouseEvent) : void
      {
         if(this.FUIComponentsOnOut != null)
         {
            this.FUIComponentsOnOut(this,this.FSevenHeroSoul);
         }
      }
      
      protected function MCKingSoulOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TSevenHeroSoul = null;
         var _loc5_:TextField = null;
         var _loc6_:TBins = null;
         _loc5_ = param1.currentTarget as TextField;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroSoul) as TBins;
         _loc2_ = this.FSoulNumList.indexOf(_loc5_);
         _loc4_ = _loc6_.GetDatebaseByIndex(_loc2_) as TSevenHeroSoul;
         if(this.FUIComponentsOnOver != null)
         {
            this.FSevenHeroSoul = _loc4_;
            this.FUIComponentsOnOver(this,this.FSevenHeroSoul);
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:THero = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:TRoleModel = null;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         _loc5_ = param2 as THero;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.Identifier) as TRoleModel;
         _loc11_ = CONST_ROLE.GetModelIDByIndex(_loc10_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc11_);
         if(_loc7_ != null)
         {
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
            param3.Value.Evaluate(_loc9_,_loc8_);
            this.FUIHero.X = _loc8_.X;
            this.FUIHero.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(_loc11_);
         }
         this.SetRoleModelID(_loc11_);
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
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:THero = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as THero;
         _loc6_ = SResourcesCore.TexturesHeadIcon;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.SmallID);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.SmallID);
         }
      }
      
      protected function SlotsOnSelectedContext(param1:Object, param2:Object, param3:TQueryBoolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         _loc5_ = this.CAPACITY_HeroHead;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FHeroHeadList[_loc4_];
            _loc6_.IsSelected = false;
            _loc4_++;
         }
         param3.Value = true;
      }
      
      protected function ProcessorHeroHeadOnLcick(param1:Object, param2:Object) : void
      {
         var _loc3_:TUISlot = null;
         _loc3_ = param1 as TUISlot;
         this.FHero = param2 as THero;
         this.FUIHero.Context = this.FHero;
         this.UpdateHeroMainPoint();
      }
      
      protected function BTNExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FExchangeOnClick != null)
         {
            this.FExchangeOnClick(this);
         }
      }
      
      protected function BTNGetKingSoulOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGetKingSoulOnClick != null)
         {
            this.FGetKingSoulOnClick(this);
         }
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
      
      public function get MainPointOnClick() : Function
      {
         return this.FMainPointOnClick;
      }
      
      public function set MainPointOnClick(param1:Function) : void
      {
         this.FMainPointOnClick = param1;
      }
      
      public function get ExchangeOnClick() : Function
      {
         return this.FExchangeOnClick;
      }
      
      public function set ExchangeOnClick(param1:Function) : void
      {
         this.FExchangeOnClick = param1;
      }
      
      public function get GetKingSoulOnClick() : Function
      {
         return this.FGetKingSoulOnClick;
      }
      
      public function set GetKingSoulOnClick(param1:Function) : void
      {
         this.FGetKingSoulOnClick = param1;
      }
      
      public function get UIComponentsOnOver() : Function
      {
         return this.FUIComponentsOnOver;
      }
      
      public function set UIComponentsOnOver(param1:Function) : void
      {
         this.FUIComponentsOnOver = param1;
      }
      
      public function get UIComponentsOnOut() : Function
      {
         return this.FUIComponentsOnOut;
      }
      
      public function set UIComponentsOnOut(param1:Function) : void
      {
         this.FUIComponentsOnOut = param1;
      }
      
      public function get UIHintOnOver() : Function
      {
         return this.FUIHintOnOver;
      }
      
      public function set UIHintOnOver(param1:Function) : void
      {
         this.FUIHintOnOver = param1;
      }
      
      public function get UIHintOnOut() : Function
      {
         return this.FUIHintOnOut;
      }
      
      public function set UIHintOnOut(param1:Function) : void
      {
         this.FUIHintOnOut = param1;
      }
      
      public function get UpdateHeroPower() : Function
      {
         return this.FUpdateHeroPower;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function UpdateUI() : void
      {
         this.FHeros.Sort();
         this.FCurPage = 1;
         this.FTotalPage = Math.ceil(this.FHeros.Count / this.CAPACITY_HeroHead);
         this.SelectHero();
         this.OnLeft(null,null);
         this.UpdateCostText();
         this.UpdateSoulCount();
         this.UpdateHeroMainPoint();
         this.PlayEffects();
      }
      
      public function UpdateSoulCount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.CAPACITY_KingSouls;
         _loc1_ = 0;
         while(_loc1_ < _loc2_ - 1)
         {
            _loc3_ = this.FCharacter.GetKingSoulByIndex(_loc1_ + 1);
            this.FSoulNumList[_loc1_].text = _loc3_.toString();
            _loc1_++;
         }
         this.FSoulNumList[_loc2_ - 1].text = this.FCharacter.GetKingSoulByIndex(CONST_COMMON.KINGSOULINDEX_Common).toString();
      }
      
      public function UpdateUIMainPoint() : void
      {
         this.UpdateSoulCount();
         this.UpdateHeroMainPoint();
      }
      
      public function UpdateLevelUp(param1:TNijiaStarAtom) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TNijiaStar = null;
         var _loc5_:TNijiaStars = null;
         var _loc6_:TUIMainPoint = null;
         _loc4_ = this.FHero.NijiaStars.GetNijiaStarByIdentifier(param1.BigStar);
         _loc2_ = _loc4_.Tag - TEMP_NUM;
         _loc6_ = this.FMainPoints[_loc2_];
         _loc6_.Context = _loc4_;
         _loc6_.SetSubPointInfo();
         if(this.FUpdateHeroPower != null && this.FHero != null)
         {
            this.FUpdateHeroPower(this,this.FHero.Identifier);
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         this.FUIHero.Context = null;
         _loc2_ = this.FRolesModelID.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FRolesModelID[_loc1_];
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc5_,true);
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
         this.FMC_NijiaStar.MC_Arm.stop();
         this.FMC_NijiaStar.MC_RedLight.stop();
         this.FMC_FireLeft.stop();
         this.FMC_FireRight.stop();
         this.FMC_BlueFire.stop();
         this.FHero = null;
      }
   }
}

