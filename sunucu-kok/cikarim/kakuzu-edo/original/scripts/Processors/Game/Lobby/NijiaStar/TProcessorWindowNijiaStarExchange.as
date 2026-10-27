package Processors.Game.Lobby.NijiaStar
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.NijiaStar.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowNijiaStarExchange extends TProcessorLobbyWindow
   {
      
      protected const CAPACITY_HeroHead:uint = 11;
      
      protected var FMC_NijiaStarExchange:Sprite;
      
      protected var FSP_HeadLeft:Sprite;
      
      protected var FBmpLeft:Bitmap;
      
      protected var FLeftID:uint;
      
      protected var FLeftHero:THero;
      
      protected var FSP_HeadRight:Sprite;
      
      protected var FBmpRight:Bitmap;
      
      protected var FRightID:uint;
      
      protected var FRightHero:THero;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBTN_NijiastarExchange:SimpleButton;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FHeroHeadList:Vector.<TUISlot>;
      
      protected var FMilitaryTypeList:Vector.<MovieClip>;
      
      protected var FHeros:THeros;
      
      protected var FHero:THero;
      
      protected var FBT_ResetLeft:TUIButton;
      
      protected var FBT_ResetRight:TUIButton;
      
      protected var FMC_NameLeft:Sprite;
      
      protected var FMC_NameRight:Sprite;
      
      protected var FMC_LeftBG:Sprite;
      
      protected var FMC_RightBG:Sprite;
      
      protected var FExchangeOnClick:Function;
      
      protected var FUIComponentsOnOut:Function;
      
      protected var FUIComponentsOnOver:Function;
      
      public function TProcessorWindowNijiaStarExchange(param1:TUIComponent)
      {
         super(param1);
         this.FHeroHeadList = new Vector.<TUISlot>(this.CAPACITY_HeroHead);
         this.FMilitaryTypeList = new Vector.<MovieClip>(this.CAPACITY_HeroHead);
         this.FHeros = SLogicsCore.Character.Heros;
         this.FBmpLeft = new Bitmap();
         this.FBmpRight = new Bitmap();
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
         var _loc4_:MovieClip = null;
         var _loc5_:TextField = null;
         var _loc6_:TUISlot = null;
         this.FMC_NijiaStarExchange = TUtilityReflection.CreateDisplayObjectInstance(CONST_NIJIASTAR.RESOURCE_ClassName_MC_NijiaStarExchange) as Sprite;
         addChild(this.FMC_NijiaStarExchange);
         this.FBT_ResetLeft = new TUIButton();
         this.FBT_ResetLeft.Substrate = this.FMC_NijiaStarExchange["MC_ResetLeft"];
         this.FBT_ResetLeft.OnClick = this.ResetOnLcick;
         this.FBT_ResetLeft.Visible = false;
         this.FBT_ResetRight = new TUIButton();
         this.FBT_ResetRight.Substrate = this.FMC_NijiaStarExchange["MC_ResetRight"];
         this.FBT_ResetRight.OnClick = this.ResetOnLcick;
         this.FBT_ResetRight.Visible = false;
         this.FSP_HeadLeft = this.FMC_NijiaStarExchange["MC_HeadLeft"]["MC_Head"];
         this.FSP_HeadLeft.addChild(this.FBmpLeft);
         this.FSP_HeadRight = this.FMC_NijiaStarExchange["MC_HeadRight"]["MC_Head"];
         this.FSP_HeadRight.addChild(this.FBmpRight);
         this.FMC_NameLeft = this.FMC_NijiaStarExchange["MC_NameLeft"];
         this.FMC_NameLeft.visible = false;
         this.FMC_NameRight = this.FMC_NijiaStarExchange["MC_NameRight"];
         this.FMC_NameRight.visible = false;
         this.FBTN_Close = this.FMC_NijiaStarExchange[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBTN_NijiastarExchange = this.FMC_NijiaStarExchange["BTN_NijiaStarExchange"];
         this.FUIPage = new TUIPage(this);
         _loc4_ = this.FMC_NijiaStarExchange[CONST_NIJIASTAR.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonPrevious.Substrate = _loc4_;
         _loc4_ = this.FMC_NijiaStarExchange[CONST_NIJIASTAR.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc4_;
         this.FUIPage.PageSize = this.CAPACITY_HeroHead;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = this.FMC_NijiaStarExchange[CONST_NIJIASTAR.RESOURCES_Link_MC_Hero + _loc1_]["MC_Slot"];
            _loc6_.OnClick = this.ProcessorHeroHeadOnLcick;
            _loc6_.OnOut = this.SlotOnOut;
            _loc6_.OnOver = this.SlotOnOver;
            _loc6_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc6_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc6_.Init();
            this.FHeroHeadList[_loc1_] = _loc6_;
            this.FMilitaryTypeList[_loc1_] = this.FMC_NijiaStarExchange[CONST_NIJIASTAR.RESOURCES_Link_MC_Hero + _loc1_]["mc_militaryType"];
            _loc1_++;
         }
         this.FMC_LeftBG = this.FMC_NijiaStarExchange["MC_LeftBG"];
         this.FMC_RightBG = this.FMC_NijiaStarExchange["MC_RightBG"];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.BTNCloseOnClick,false,0,true);
         this.FSP_HeadLeft.addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorHeroHeadOnOver,false,0,true);
         this.FSP_HeadLeft.addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorHeroHeadOnOut,false,0,true);
         this.FSP_HeadRight.addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorHeroHeadOnOver,false,0,true);
         this.FSP_HeadRight.addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorHeroHeadOnOut,false,0,true);
         this.FBTN_NijiastarExchange.addEventListener(MouseEvent.CLICK,this.NijiastarExchangeOnClick,false,0,true);
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
         }
      }
      
      protected function UpdatePageInfo() : void
      {
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = this.FHeros.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateHeroHead() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:THero = null;
         this.FHeros.Sort();
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc3_.Resource.visible = false;
            this.FMilitaryTypeList[_loc1_].visible = false;
            _loc1_++;
         }
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc1_ + this.FPageIndex * this.CAPACITY_HeroHead;
            if(_loc4_ >= this.FHeros.Count)
            {
               break;
            }
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc6_ = this.FHeros.GetHeroByIndex(_loc4_);
            _loc3_.Context = _loc6_;
            _loc3_.Resource.visible = true;
            _loc5_ = this.FMilitaryTypeList[_loc1_];
            _loc5_.gotoAndStop(_loc6_.StandPositionWithProfession);
            _loc5_.visible = true;
            _loc1_++;
         }
         this.FMC_NijiaStarExchange["MC_Effect"].play();
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
         switch(param3)
         {
            case this.FLeftID:
               this.FBmpLeft.bitmapData = _loc5_;
               break;
            case this.FRightID:
               this.FBmpRight.bitmapData = _loc5_;
         }
      }
      
      protected function SlotOnOut(param1:Object, param2:Object) : void
      {
         if(this.FUIComponentsOnOut != null)
         {
            this.FUIComponentsOnOut(this,param2);
         }
      }
      
      protected function SlotOnOver(param1:Object, param2:Object) : void
      {
         if(this.FUIComponentsOnOver != null)
         {
            this.FUIComponentsOnOver(this,param2);
         }
      }
      
      protected function ProcessorHeroHeadOnLcick(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         _loc3_ = param2 as THero;
         if(this.FBmpLeft.bitmapData == null)
         {
            if(this.FRightID == _loc3_.Identifier)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_05));
               return;
            }
            this.FLeftHero = _loc3_;
            this.FLeftID = _loc3_.Identifier;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FLeftID,this.AutoLoadCallBack);
            this.FMC_NameLeft["TF_Name"].text = _loc3_.Name;
            this.FMC_NameLeft.visible = true;
            this.FBT_ResetLeft.Visible = true;
            this.FMC_LeftBG.visible = false;
         }
         else
         {
            if(_loc3_.Identifier == this.FRightID || _loc3_.Identifier == this.FLeftID)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_05));
               return;
            }
            this.FRightHero = _loc3_;
            this.FRightID = _loc3_.Identifier;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FRightID,this.AutoLoadCallBack);
            this.FMC_NameRight["TF_Name"].text = _loc3_.Name;
            this.FMC_NameRight.visible = true;
            this.FBT_ResetRight.Visible = true;
            this.FMC_RightBG.visible = false;
         }
      }
      
      protected function ResetOnLcick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBT_ResetLeft:
               this.FLeftHero = null;
               this.FBmpLeft.bitmapData = null;
               this.FLeftID = 0;
               this.FMC_NameLeft["TF_Name"].text = "";
               this.FMC_NameLeft.visible = false;
               this.FBT_ResetLeft.Visible = false;
               this.FMC_LeftBG.visible = true;
               break;
            case this.FBT_ResetRight:
               this.FRightHero = null;
               this.FBmpRight.bitmapData = null;
               this.FRightID = 0;
               this.FMC_NameRight["TF_Name"].text = "";
               this.FMC_NameRight.visible = false;
               this.FBT_ResetRight.Visible = false;
               this.FMC_RightBG.visible = true;
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateHeroHead();
      }
      
      protected function BTNCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function NijiastarExchangeOnClick(param1:MouseEvent) : void
      {
         if(this.FExchangeOnClick != null)
         {
            this.FExchangeOnClick(this,this.FLeftHero,this.FRightHero);
         }
      }
      
      protected function ProcessorHeroHeadOnOut(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Sprite = null;
         _loc3_ = param1.currentTarget as Sprite;
         switch(_loc3_)
         {
            case this.FSP_HeadLeft:
               _loc2_ = this.FLeftHero;
               break;
            case this.FSP_HeadRight:
               _loc2_ = this.FRightHero;
         }
         if(this.FUIComponentsOnOut != null)
         {
            this.FUIComponentsOnOut(this,_loc2_);
         }
      }
      
      protected function ProcessorHeroHeadOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Sprite = null;
         _loc3_ = param1.currentTarget as Sprite;
         switch(_loc3_)
         {
            case this.FSP_HeadLeft:
               _loc2_ = this.FLeftHero;
               break;
            case this.FSP_HeadRight:
               _loc2_ = this.FRightHero;
         }
         if(this.FUIComponentsOnOver != null)
         {
            this.FUIComponentsOnOver(this,_loc2_);
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
      
      public function get ExchangeOnClick() : Function
      {
         return this.FExchangeOnClick;
      }
      
      public function set ExchangeOnClick(param1:Function) : void
      {
         this.FExchangeOnClick = param1;
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
      
      public function Update() : void
      {
         this.UpdatePageInfo();
         this.UpdateHeroHead();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         this.FBmpLeft.bitmapData = null;
         this.FBmpRight.bitmapData = null;
         this.FLeftID = 0;
         this.FRightID = 0;
         this.FMC_NameLeft.visible = false;
         this.FMC_NameRight.visible = false;
         this.FLeftHero = null;
         this.FRightHero = null;
         this.FMC_RightBG.visible = true;
         this.FMC_LeftBG.visible = true;
         this.FBT_ResetLeft.Visible = false;
         this.FBT_ResetRight.Visible = false;
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
         this.FMC_NijiaStarExchange["MC_Effect"].stop();
      }
   }
}

