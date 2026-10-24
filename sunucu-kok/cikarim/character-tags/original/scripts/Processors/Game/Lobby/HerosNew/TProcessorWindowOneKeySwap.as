package Processors.Game.Lobby.HerosNew
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
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TacticalDeployment.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class TProcessorWindowOneKeySwap extends TProcessorLobbyWindow
   {
      
      protected const CAPACITY_HeroHead:uint = 11;
      
      protected const CAPACITY_EquipmentMounted:uint = 6;
      
      protected const CAPACITY_TalismanMounted:uint = 4;
      
      protected var FMC_OneKeySwap:Sprite;
      
      protected var FSP_HeadLeft:Sprite;
      
      protected var FBmpLeft:Bitmap;
      
      protected var FLeftID:uint;
      
      protected var FHeroLeft:THero;
      
      protected var FSP_HeadRight:Sprite;
      
      protected var FBmpRight:Bitmap;
      
      protected var FRightID:uint;
      
      protected var FHeroRight:THero;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_OneKeySwap:SimpleButton;
      
      protected var FBtn_ResetLeft:TUIButton;
      
      protected var FBtn_ResetRight:TUIButton;
      
      protected var FSP_NameLeft:Sprite;
      
      protected var FSP_NameRight:Sprite;
      
      protected var FTF_NameLeft:TextField;
      
      protected var FTF_NameRight:TextField;
      
      protected var FMC_LeftBG:Sprite;
      
      protected var FMC_RightBG:Sprite;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FHeroHeadList:Vector.<TUISlot>;
      
      protected var FMilitaryTypeList:Vector.<MovieClip>;
      
      protected var FHeros:THeros;
      
      protected var FHeroInfoTip:TDeploymentTip;
      
      protected var FInitialization:Boolean;
      
      protected var FOnExchange:Function;
      
      public function TProcessorWindowOneKeySwap(param1:TUIComponent)
      {
         super(param1);
         this.FHeroHeadList = new Vector.<TUISlot>(this.CAPACITY_HeroHead);
         this.FMilitaryTypeList = new Vector.<MovieClip>(this.CAPACITY_HeroHead);
         this.FHeros = SLogicsCore.Character.Heros;
         this.FInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HEROS.RESOURCESID_Swf_Heros);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         this.FMC_OneKeySwap = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROS.RESOURCE_ClassName_MC_OneKeySwap) as Sprite;
         addChild(this.FMC_OneKeySwap);
         this.FMC_OneKeySwap.mouseEnabled = false;
         this.FMC_OneKeySwap.mouseChildren = false;
         this.FBtn_ResetLeft = new TUIButton();
         this.FBtn_ResetLeft.Substrate = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_Btn_ResetLeft];
         this.FBtn_ResetLeft.OnClick = this.BtnResetOnClick;
         this.FBtn_ResetLeft.Visible = false;
         this.FBtn_ResetRight = new TUIButton();
         this.FBtn_ResetRight.Substrate = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_Btn_ResetRight];
         this.FBtn_ResetRight.OnClick = this.BtnResetOnClick;
         this.FBtn_ResetRight.Visible = false;
         _loc3_ = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_HeadLeft];
         this.FSP_HeadLeft = _loc3_[CONST_HEROS.RESOURCES_Link_SP_Head];
         this.FBmpLeft = new Bitmap();
         this.FSP_HeadLeft.addChild(this.FBmpLeft);
         this.FSP_HeadLeft.mouseChildren = false;
         this.FSP_HeadLeft.mouseEnabled = false;
         _loc3_ = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_HeadRight];
         this.FSP_HeadRight = _loc3_[CONST_HEROS.RESOURCES_Link_SP_Head];
         this.FBmpRight = new Bitmap();
         this.FSP_HeadRight.addChild(this.FBmpRight);
         this.FSP_HeadRight.mouseChildren = false;
         this.FSP_HeadRight.mouseEnabled = false;
         this.FSP_NameLeft = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_NameLeft];
         this.FSP_NameLeft.mouseChildren = false;
         this.FSP_NameLeft.mouseEnabled = false;
         this.FSP_NameLeft.visible = false;
         this.FTF_NameLeft = this.FSP_NameLeft[CONST_HEROS.RESOURCES_Link_TF_Name];
         this.FSP_NameRight = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_NameRight];
         this.FSP_NameRight.mouseChildren = false;
         this.FSP_NameRight.mouseEnabled = false;
         this.FSP_NameRight.visible = false;
         this.FTF_NameRight = this.FSP_NameRight[CONST_HEROS.RESOURCES_Link_TF_Name];
         this.FBtn_Close = this.FMC_OneKeySwap[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_OneKeySwap = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_Btn_OneKeySwap];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMC_OneKeySwap[CONST_HEROS.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FMC_OneKeySwap[CONST_HEROS.RESOURCE_Link_MC_PageRight];
         this.FUIPage.PageSize = this.CAPACITY_HeroHead;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc3_ = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_HeroHead + _loc1_];
            _loc5_.Resource = _loc3_[CONST_HEROS.RESOURCES_Link_MC_Slot];
            _loc5_.OnClick = this.UIHeroHeadOnClick;
            _loc5_.OnOut = this.SlotOnOut;
            _loc5_.OnOver = this.SlotOnOver;
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc5_.Init();
            this.FHeroHeadList[_loc1_] = _loc5_;
            _loc4_ = _loc3_[CONST_HEROS.RESOURCES_Link_MC_MilitaryType];
            _loc4_.mouseChildren = false;
            _loc4_.mouseEnabled = false;
            this.FMilitaryTypeList[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FMC_LeftBG = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_LeftBG];
         this.FMC_LeftBG.mouseChildren = false;
         this.FMC_LeftBG.mouseEnabled = false;
         this.FMC_RightBG = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_SP_RightBG];
         this.FMC_RightBG.mouseChildren = false;
         this.FMC_RightBG.mouseEnabled = false;
         this.FMC_Effect = this.FMC_OneKeySwap[CONST_HEROS.RESOURCES_Link_MC_Effect];
         this.FMC_Effect.mouseChildren = false;
         this.FMC_Effect.mouseEnabled = false;
         this.FMC_Effect.stop();
         this.FHeroInfoTip = new TDeploymentTip(this.Parent);
         this.FHeroInfoTip.Visible = false;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick,false,0,true);
         this.FBtn_OneKeySwap.addEventListener(MouseEvent.CLICK,this.BtnOneKeySwapOnClick,false,0,true);
         this.FInitialization = true;
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
            if(this.FHeroInfoTip != null && this.FHeroInfoTip.Visible)
            {
               this.FHeroInfoTip.UpdataBitmap();
            }
         }
      }
      
      protected function ShowHeroInfoTip(param1:THero) : void
      {
         if(param1 != null)
         {
            this.FHeroInfoTip.SetHeroData(param1);
            this.FHeroInfoTip.Visible = true;
         }
      }
      
      protected function HideHeroInfoTip(param1:THero) : void
      {
         this.FHeroInfoTip.Visible = false;
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
         this.FMC_Effect.play();
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
      
      protected function SlotOnOver(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         _loc3_ = param2 as THero;
         if(_loc3_ == null)
         {
            return;
         }
         this.ShowHeroInfoTip(_loc3_);
      }
      
      protected function SlotOnOut(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         _loc3_ = param2 as THero;
         if(_loc3_ == null)
         {
            return;
         }
         this.HideHeroInfoTip(_loc3_);
      }
      
      protected function UIHeroHeadOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         _loc3_ = param2 as THero;
         if(this.FBmpLeft.bitmapData == null)
         {
            if(this.FRightID == _loc3_.Identifier)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_26));
               return;
            }
            this.FHeroLeft = _loc3_;
            this.FLeftID = _loc3_.Identifier;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FLeftID,this.AutoLoadCallBack);
            this.FTF_NameLeft.text = _loc3_.Name;
            this.FSP_NameLeft.visible = true;
            this.FBtn_ResetLeft.Visible = true;
            this.FMC_LeftBG.visible = false;
         }
         else
         {
            if(_loc3_.Identifier == this.FRightID || _loc3_.Identifier == this.FLeftID)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_26));
               return;
            }
            this.FHeroRight = _loc3_;
            this.FRightID = _loc3_.Identifier;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FRightID,this.AutoLoadCallBack);
            this.FTF_NameRight.text = _loc3_.Name;
            this.FSP_NameRight.visible = true;
            this.FBtn_ResetRight.Visible = true;
            this.FMC_RightBG.visible = false;
         }
      }
      
      protected function BtnResetOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtn_ResetLeft:
               this.FHeroLeft = null;
               this.FBmpLeft.bitmapData = null;
               this.FLeftID = 0;
               this.FSP_NameLeft["TF_Name"].text = "";
               this.FSP_NameLeft.visible = false;
               this.FBtn_ResetLeft.Visible = false;
               this.FMC_LeftBG.visible = true;
               break;
            case this.FBtn_ResetRight:
               this.FHeroRight = null;
               this.FBmpRight.bitmapData = null;
               this.FRightID = 0;
               this.FSP_NameRight["TF_Name"].text = "";
               this.FSP_NameRight.visible = false;
               this.FBtn_ResetRight.Visible = false;
               this.FMC_RightBG.visible = true;
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateHeroHead();
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnOneKeySwapOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:TEquipment = null;
         var _loc6_:TEquipment = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         if(this.FHeroLeft == null || this.FHeroRight == null)
         {
            return;
         }
         _loc8_ = this.FHeroLeft.Level;
         _loc9_ = this.FHeroRight.Level;
         _loc10_ = this.FHeroLeft.Quality;
         _loc11_ = this.FHeroRight.Quality;
         if(this.FHeroLeft.Profession == this.FHeroRight.Profession)
         {
            _loc7_ = 0;
         }
         else
         {
            _loc7_ = 1;
         }
         _loc3_ = this.CAPACITY_EquipmentMounted;
         _loc2_ = _loc7_;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FHeroLeft.EquipmentsMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            _loc6_ = this.FHeroRight.EquipmentsMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            if(_loc6_ != null && _loc8_ < _loc6_.RequirementLevel || _loc5_ != null && _loc9_ < _loc5_.RequirementLevel)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_28));
               return;
            }
            _loc2_++;
         }
         _loc3_ = this.CAPACITY_TalismanMounted;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FHeroLeft.TalismansMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            _loc6_ = this.FHeroRight.TalismansMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            if(_loc6_ != null && _loc10_ < _loc6_.Quality || _loc5_ != null && _loc11_ < _loc5_.Quality)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_27));
               return;
            }
            _loc2_++;
         }
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,this.FHeroLeft,this.FHeroRight);
         }
         this.SetEable(false);
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
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function Update() : void
      {
         this.BtnResetOnClick(this.FBtn_ResetLeft,null);
         this.BtnResetOnClick(this.FBtn_ResetRight,null);
         this.UpdatePageInfo();
         this.UpdateHeroHead();
         this.FMC_OneKeySwap.mouseEnabled = true;
         this.FMC_OneKeySwap.mouseChildren = true;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         if(!this.FInitialization)
         {
            return;
         }
         this.FLeftID = 0;
         this.FRightID = 0;
         this.FBmpLeft.bitmapData = null;
         this.FBmpRight.bitmapData = null;
         this.FSP_NameLeft.visible = false;
         this.FSP_NameRight.visible = false;
         this.FHeroLeft = null;
         this.FHeroRight = null;
         this.FMC_RightBG.visible = true;
         this.FMC_LeftBG.visible = true;
         this.FBtn_ResetLeft.Visible = false;
         this.FBtn_ResetRight.Visible = false;
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
         this.FMC_Effect.stop();
      }
      
      public function SetEable(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_OneKeySwap.mouseEnabled = true;
            this.FMC_OneKeySwap.mouseChildren = true;
         }
         else
         {
            this.FMC_OneKeySwap.mouseEnabled = false;
            this.FMC_OneKeySwap.mouseChildren = false;
         }
      }
   }
}

