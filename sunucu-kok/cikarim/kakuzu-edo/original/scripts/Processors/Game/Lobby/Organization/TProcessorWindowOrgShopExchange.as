package Processors.Game.Lobby.Organization
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Map.TMoudleInfor;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.VO.THeroExchangeVO;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.SLogicsCore;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_ORGANIZATION;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowOrgShopExchange extends TProcessorLobbyWindow
   {
      
      protected var EachShow_ItemCount:uint = 3;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TNewOrgData;
      
      protected var FPage:TUIPage;
      
      protected var FItems:Vector.<MovieClip>;
      
      protected var FExchangeBtns:Vector.<TUIButton>;
      
      protected var FRoleMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FPageIndex:int;
      
      protected var FCurrentHeroExchangeVO:THeroExchangeVO;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FOnExchange:Function;
      
      public function TProcessorWindowOrgShopExchange(param1:TUIComponent)
      {
         super(param1);
         this.FItems = new Vector.<MovieClip>(this.EachShow_ItemCount);
         this.FExchangeBtns = new Vector.<TUIButton>(this.EachShow_ItemCount);
         this.FRoleMoudles = new Vector.<TSceneSpriteMoudle>(this.EachShow_ItemCount);
         this.FQueryModel = new TMoudleInfor();
         this.FPageIndex = 0;
         this.ConstructPurchase();
      }
      
      protected function GetGlobalIconIndexByLocal(param1:uint) : uint
      {
         return this.FPageIndex * this.EachShow_ItemCount + param1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TUIButton = null;
         var _loc4_:TSceneSpriteMoudle = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_ShopExchange") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseCall);
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.PageSize = this.EachShow_ItemCount;
         this.FPage.TotalQuantity = this.FData.HeroExchangeVOs.length;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         _loc1_ = 0;
         while(_loc1_ < this.EachShow_ItemCount)
         {
            _loc2_ = this.FMainUI["MC_Item_" + _loc1_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Btn_Exchange"];
            _loc3_.OnClick = this.OnExchangeClick;
            _loc3_.Tag = _loc1_;
            this.FItems[_loc1_] = _loc2_;
            this.FExchangeBtns[_loc1_] = _loc3_;
            _loc4_ = new TSceneSpriteMoudle();
            this.FRoleMoudles[_loc1_] = _loc4_;
            _loc2_.MC_MountPoint.addChild(_loc4_);
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         if(Visible)
         {
            _loc1_ = 0;
            while(_loc1_ < this.EachShow_ItemCount)
            {
               if(this.FRoleMoudles[_loc1_].TextrueID != 0)
               {
                  this.FRoleMoudles[_loc1_].UpdateView();
               }
               _loc1_++;
            }
         }
         super.LogicsPerform();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         this.FUnstreamizerOrganizationNew.HeroExchangeRet(this.FCurrentHeroExchangeVO);
         this.HeroExchangeRet();
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function OnCloseCall(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THeroExchangeVO = null;
         var _loc8_:uint = 0;
         this.FPageIndex = param2;
         _loc6_ = this.FData.HeroExchangeVOs.length;
         _loc3_ = 0;
         while(_loc3_ < this.EachShow_ItemCount)
         {
            _loc5_ = this.GetGlobalIconIndexByLocal(_loc3_);
            _loc4_ = this.FItems[_loc3_];
            if(_loc5_ < _loc6_)
            {
               _loc4_.visible = true;
               _loc7_ = this.FData.HeroExchangeVOs[_loc5_];
               _loc4_.TF_Name.text = _loc7_.Hero.Name;
               _loc4_.TF_Name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc7_.Hero.Quality];
               _loc4_.TF_NeedAwardName.text = _loc7_.NeedAwardName;
               _loc8_ = CONST_COMMON.RewardIDToTemplateID(_loc7_.Mall.Items.Type,_loc7_.Mall.Items.Code);
               _loc4_.TF_TotalCount.text = SLogicsCore.Character.Appliances.GetCountByTempleteID(_loc8_).toString();
               _loc4_.TF_NeedCount.text = _loc7_.Mall.Items.Amount.toString();
               _loc4_.MC_Exchange.visible = _loc7_.IsExchange;
               this.FExchangeBtns[_loc3_].Enabled = !_loc7_.IsExchange;
               TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc7_.Hero.Identifier,this.FQueryModel);
               this.FRoleMoudles[_loc3_].ChangeRoleMoudle(this.FQueryModel.TextureID,1);
            }
            else
            {
               _loc4_.visible = false;
               this.FRoleMoudles[_loc3_].ReleaseModuleResource();
               this.FRoleMoudles[_loc3_].Release();
            }
            _loc3_++;
         }
      }
      
      protected function OnExchangeClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:THeroExchangeVO = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:TUIWindowConfirmation = null;
         _loc4_ = uint((param1 as TUIButton).Tag);
         _loc3_ = this.FData.HeroExchangeVOs[_loc4_];
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_.Hero.Identifier) != null)
         {
            _loc6_ = this.FData.NewOrgSystemLanguage.GetStr29();
            SToolReward.ShowMessage(_loc6_);
            return;
         }
         _loc5_ = this.GetGlobalIconIndexByLocal(_loc4_);
         this.FCurrentHeroExchangeVO = this.FData.HeroExchangeVOs[_loc5_];
         _loc7_ = SUtilityOverLayer.UIWindowConfirmation;
         _loc7_.Text = this.FData.NewOrgSystemLanguage.GetStr30();
         _loc7_.OnOK = this.OnExchangeOkCall;
         _loc7_.Visible = true;
      }
      
      protected function OnExchangeOkCall(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:TPurchaseRequest = null;
         _loc2_ = CONST_COMMON.RewardIDToTemplateID(this.FCurrentHeroExchangeVO.Mall.Items.Type,this.FCurrentHeroExchangeVO.Mall.Items.Code);
         if(SLogicsCore.Character.Appliances.GetCountByTempleteID(_loc2_) < this.FCurrentHeroExchangeVO.Mall.Items.Amount)
         {
            _loc3_ = this.FData.NewOrgSystemLanguage.GetStr31();
            SToolReward.ShowMessage(_loc3_);
            return;
         }
         _loc4_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc4_.IDTemplate = this.FCurrentHeroExchangeVO.Mall.Identifier;
         _loc4_.Quantity = 1;
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,_loc4_,this.FPurchaseParameters);
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      public function set Data(param1:TNewOrgData) : void
      {
         this.FData = param1;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.PageOnSwitch(null,this.FPageIndex);
         }
      }
      
      public function HeroExchangeRet() : void
      {
         var _loc1_:String = null;
         _loc1_ = this.FData.NewOrgSystemLanguage.GetStr32();
         SToolReward.ShowMessage(_loc1_);
         this.Update();
      }
   }
}

