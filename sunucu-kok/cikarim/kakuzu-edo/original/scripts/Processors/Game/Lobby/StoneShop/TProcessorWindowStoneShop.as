package Processors.Game.Lobby.StoneShop
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GongFuFight.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.StoneShop.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowStoneShop extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_Page_InventorySamples:uint = CONST_GONGFUFIGHT.CAPACITY_Page_InventorySamples;
      
      public static var CAPACITY_Heros:uint = CONST_GONGFUFIGHT.CAPACITY_Heros;
      
      private static const TYPE_STONE_A:uint = 14100283;
      
      private static const TYPE_STONE_B:uint = 14100733;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FSP_StoneShop:Sprite;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FUITabs:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FTF_Count:TextField;
      
      protected var FStoneFlag:MovieClip;
      
      protected var FHint:THint;
      
      protected var FSP_Hero:Sprite;
      
      protected var FUIHeroItems:Vector.<TUIHeroItem>;
      
      protected var FUIHeroInfo:TUIHeroInfo;
      
      protected var FSP_Inventory:Sprite;
      
      protected var FUIStoneSamples:Vector.<TUIStoneSample>;
      
      protected var FUIKnifeItem:TShowAwardUI;
      
      protected var FBtn_KnifeExchange:TUIButton;
      
      protected var FKnifePageIndex:int;
      
      protected var FUIKnifePage:TUIPage;
      
      protected var FMC_EffectLeft:MovieClip;
      
      protected var FMC_EffectRight:MovieClip;
      
      protected var FMC_EffectLeftTop:MovieClip;
      
      protected var FMC_EffectRightTop:MovieClip;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      protected var FInventorySamples:TInventorySamples;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FInitialization:Boolean;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorWindowStoneShop(param1:TUIComponent)
      {
         super(param1);
         this.FGongFuFightData = SLogicsCore.GongFuFightData;
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GONGFUFIGHT.RESOURCESID_GongFuFight_StoneShop);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TUIStoneSample = null;
         var _loc4_:TUIHeroItem = null;
         this.FInventorySamples = new TInventorySamples();
         this.FRolesModelID = new Vector.<int>();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FSP_StoneShop = TUtilityReflection.CreateDisplayObjectInstance(CONST_GONGFUFIGHT.RESOURCE_ClassName_SP_GongFuFight_StoneShop) as Sprite;
         addChild(this.FSP_StoneShop);
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FSP_StoneShop[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.ButtonCloseOnClick;
         this.FMC_EffectLeft = this.FSP_StoneShop[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectLeft];
         this.FMC_EffectRight = this.FSP_StoneShop[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectRight];
         this.FMC_EffectLeft.stop();
         this.FMC_EffectRight.stop();
         this.FUITabs = new TUITab(null);
         _loc1_ = 0;
         while(_loc1_ < CONST_GONGFUFIGHT.CAPACITY_Tabs)
         {
            _loc2_ = this.FSP_StoneShop[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            (_loc2_.getChildAt(1) as TextField).mouseEnabled = true;
            this.FUITabs.SetTabByIndex(_loc2_,_loc1_);
            _loc1_++;
         }
         this.FUITabs.OnSwitch = this.TabsOnSwitch;
         this.FUITabs.Init();
         this.FUITabs.SetTabEnabledByIndex(1,true);
         this.FTF_Count = this.FSP_StoneShop["TF_Count"];
         this.FStoneFlag = this.FSP_StoneShop["StoneFlag"];
         this.FStoneFlag.addEventListener(MouseEvent.MOUSE_MOVE,this.StoneFlagOnMove);
         this.FStoneFlag.addEventListener(MouseEvent.MOUSE_OUT,this.StoneFlagOnOut);
         this.FHint = new THint();
         this.FSP_Hero = this.FSP_StoneShop["SP_Hero"];
         if(this.FSP_Hero["MC_HeroList_" + 3] != null)
         {
            CAPACITY_Heros = 4;
            CONST_GONGFUFIGHT.CAPACITY_Heros = 4;
         }
         this.FUIHeroItems = new Vector.<TUIHeroItem>(CAPACITY_Heros);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Heros)
         {
            _loc4_ = new TUIHeroItem();
            _loc4_.Resource = this.FSP_Hero["MC_HeroList_" + _loc1_];
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc4_.OnExchange = this.UIHeroItemOnExchange;
            _loc4_.OnHeroClick = this.UIHeroItemOnHeroClick;
            _loc4_.Perform_UIDispatch();
            this.FUIHeroItems[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIKnifeItem = new TShowAwardUI(this);
         this.FUIKnifeItem.UIDispatch(this.FSP_Hero["MC_ShowAwardUI"]);
         this.FBtn_KnifeExchange = new TUIButton();
         this.FBtn_KnifeExchange.Substrate = this.FSP_Hero["MC_ShowAwardUI"]["Btn_Exchange"];
         this.FBtn_KnifeExchange.OnClick = this.UIKnifeOnExchange;
         this.FUIHeroInfo = new TUIHeroInfo();
         this.FUIHeroInfo.Resource = this.FSP_Hero["SP_HeroInfo"];
         this.FUIHeroInfo.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUIHeroInfo.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUIHeroInfo.Perform_UIDispatch();
         this.FSP_Inventory = this.FSP_StoneShop["SP_Inventory"];
         this.FUIPage = new TUIPage(null);
         this.FUIPage.ButtonPrevious.Substrate = this.FSP_Inventory[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FSP_Inventory[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPage.LabelPage = this.FSP_Inventory[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage.text = "0/0";
         this.FUIPage.PageSize = CAPACITY_Page_InventorySamples;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FUIKnifePage = new TUIPage(null);
         this.FUIKnifePage.ButtonPrevious.Substrate = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIKnifePage.ButtonNext.Substrate = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIKnifePage.LabelPage = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIKnifePage.LabelPage.text = "0/0";
         this.FUIKnifePage.PageSize = 1;
         this.FUIKnifePage.OnChangePage = this.KnifePageOnChange;
         this.FUIKnifePage.Init();
         this.FUIStoneSamples = new Vector.<TUIStoneSample>(CAPACITY_Page_InventorySamples);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            _loc3_ = new TUIStoneSample(this);
            _loc3_.Resource = this.FSP_Inventory["SP_Slot_" + _loc1_];
            _loc3_.OnClick = this.UIInventorySampleOnClick;
            _loc3_.OnSlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnSlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.Perform_UIDispatch();
            this.FUIStoneSamples[_loc1_] = _loc3_;
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               if(this.FMC_EffectLeft.isPlaying)
               {
                  this.LogicsPerform_EffectLeft();
               }
               if(this.FMC_EffectRight.isPlaying)
               {
                  this.LogicsPerform_EffectRight();
               }
               if(this.FMC_EffectLeftTop == null)
               {
                  this.FMC_EffectLeftTop = this.FMC_EffectLeft[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectTop];
                  if(this.FMC_EffectLeftTop != null && !this.FMC_EffectLeftTop.isPlaying)
                  {
                     this.FMC_EffectLeftTop.play();
                  }
               }
               if(this.FMC_EffectRightTop == null)
               {
                  this.FMC_EffectRightTop = this.FMC_EffectRight[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectTop];
                  if(this.FMC_EffectRightTop != null && !this.FMC_EffectRightTop.isPlaying)
                  {
                     this.FMC_EffectRightTop.play();
                  }
               }
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_Page_InventorySamples)
               {
                  this.FUIStoneSamples[_loc1_].Update();
                  _loc1_++;
               }
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_Heros)
               {
                  this.FUIHeroItems[_loc1_].Update();
                  _loc1_++;
               }
            }
         }
      }
      
      protected function LogicsPerform_EffectLeft() : void
      {
         if(this.FMC_EffectLeft.currentFrame == this.FMC_EffectLeft.totalFrames)
         {
            this.FMC_EffectLeft.stop();
         }
      }
      
      protected function LogicsPerform_EffectRight() : void
      {
         if(this.FMC_EffectRight.currentFrame == this.FMC_EffectRight.totalFrames)
         {
            this.FMC_EffectRight.stop();
         }
      }
      
      protected function ProcessorUpdateCommon() : void
      {
         var _loc1_:int = 0;
         _loc1_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(CONST_GONGFUFIGHT.StoneID));
         this.FTF_Count.text = _loc1_.toString();
         this.ProcessorFilterInventorySamples();
         this.FUITabs.SwithTagManual(this.FTabIndex);
         this.FMC_EffectLeft.play();
         this.FMC_EffectRight.play();
      }
      
      protected function ProcessorFilterInventorySamples() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventorySamples = null;
         var _loc5_:TInventorySample = null;
         if(this.FTabIndex == 0)
         {
            _loc3_ = int(CONST_MALL.MAJORTYPE_MALL_Hero);
         }
         else if(this.FTabIndex == 1)
         {
            _loc3_ = int(CONST_MALL.MAJORTYPE_MALL_Inventory);
         }
         else
         {
            _loc3_ = int(CONST_MALL.MAJORTYPE_MALL_HellHero);
         }
         this.FInventorySamples.Clear();
         _loc4_ = SLogicsCore.Character.InventorySamples;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.GetInventorySampleByIndex(_loc1_);
            if(_loc5_.Model == CONST_MALL.TYPE_MODEL_STONESHOP)
            {
               if(_loc5_.MajorType == _loc3_)
               {
                  this.FInventorySamples.Add(_loc5_);
               }
            }
            _loc1_++;
         }
         this.FUIKnifePage.TotalQuantity = this.FInventorySamples.Count;
         this.FUIKnifePage.Update();
      }
      
      protected function UpdateUIHeroItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventorySample = null;
         var _loc6_:TUIHeroItem = null;
         if(this.FTabIndex == 2)
         {
            _loc2_ = this.FInventorySamples.Count;
         }
         else
         {
            _loc2_ = int(CAPACITY_Heros);
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Heros)
         {
            _loc6_ = this.FUIHeroItems[_loc1_];
            _loc6_.Context = null;
            _loc6_.Visible = false;
            _loc1_++;
         }
         if(this.FTabIndex == 2)
         {
            _loc2_ = 1;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FInventorySamples.GetInventorySampleByIndex(_loc1_);
            if(this.FTabIndex == 2)
            {
               _loc5_ = this.FInventorySamples.GetInventorySampleByIndex(this.FKnifePageIndex);
            }
            if(_loc5_.TemplateID < 10000000)
            {
               this.FUIKnifeItem.SetData(1,_loc5_.TemplateID,_loc5_.TemplateID);
               this.FSP_Hero["MC_ShowAwardUI"]["StoneFlag"].gotoAndStop(2);
               this.FSP_Hero["MC_ShowAwardUI"]["TF_NeedCount"].text = _loc5_.Integration.toString();
               this.FSP_Hero["MC_ShowAwardUI"]["SP_AlreadyRecruit"].visible = false;
               this.FBtn_KnifeExchange.Enabled = true;
               this.FSP_Hero["MC_ShowAwardUI"].visible = true;
               _loc6_.Visible = false;
               _loc4_ = int(SLogicsCore.Character.KnifeOfKillSoul.Count);
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(SLogicsCore.Character.KnifeOfKillSoul.GetByIndex(_loc3_).ID == _loc5_.TemplateID && SLogicsCore.Character.KnifeOfKillSoul.GetByIndex(_loc3_).CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
                  {
                     this.FSP_Hero["MC_ShowAwardUI"]["SP_AlreadyRecruit"].visible = true;
                     this.FBtn_KnifeExchange.Enabled = false;
                  }
                  _loc3_++;
               }
            }
            else
            {
               _loc6_ = this.FUIHeroItems[_loc1_];
               _loc6_.Context = _loc5_;
               _loc6_.Visible = true;
               this.FSP_Hero["MC_ShowAwardUI"].visible = false;
            }
            _loc1_++;
         }
         this.FSP_Hero["MC_HeroList_0"].x = this.FTabIndex == 2 ? 275 : 0;
         if(this.FTabIndex == 2)
         {
            this.FSP_Hero["MC_HeroList_0"]["StoneFlag"].gotoAndStop(2);
         }
         else
         {
            this.FSP_Hero["MC_HeroList_0"]["StoneFlag"].gotoAndStop(1);
         }
      }
      
      protected function UpdateUIInventorySamples() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventorySample = null;
         var _loc6_:TUIStoneSample = null;
         _loc4_ = this.FPageIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            _loc6_ = this.FUIStoneSamples[_loc1_];
            _loc6_.Context = null;
            _loc6_.Visible = false;
            _loc1_++;
         }
         _loc3_ = _loc4_ * CAPACITY_Page_InventorySamples;
         _loc2_ = this.FInventorySamples.Count;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            if(_loc1_ + _loc3_ >= _loc2_)
            {
               return;
            }
            _loc5_ = this.FInventorySamples.GetInventorySampleByIndex(_loc1_ + _loc3_);
            _loc6_ = this.FUIStoneSamples[_loc1_];
            _loc6_.Context = _loc5_;
            _loc6_.Visible = true;
            _loc1_++;
         }
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
      
      protected function ProcessorPurchase(param1:TInventorySample) : void
      {
         var _loc2_:TPurchaseRequest = null;
         _loc2_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc2_.IDTemplate = param1.Indentifier;
         _loc2_.Quantity = 1;
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(this,_loc2_,this.FPurchaseParameters);
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
         this.ProcessorUpdateCommon();
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.X = (_loc1_ - this.Width) / 2 + 50;
         this.Y = (_loc2_ - this.Height) / 2;
      }
      
      protected function ButtonCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FPageIndex = 0;
         this.FTabIndex = 0;
         ProcessorWindowClose();
      }
      
      protected function UIWindowConfirmationOnOK(param1:Object) : void
      {
         this.ProcessorPurchase(this.FUIWindowConfirmation.Context as TInventorySample);
         this.FUIWindowConfirmation.Text = "";
         this.FUIWindowConfirmation.Context = null;
      }
      
      protected function TabsOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.FTabIndex = param1 as int;
         this.ProcessorFilterInventorySamples();
         if(this.FTabIndex == 0)
         {
            this.UpdateUIHeroItems();
            this.FSP_Hero.visible = true;
            this.FSP_Inventory.visible = false;
            this.FSP_Hero[CONST_COMMON.RESOURCE_Link_MC_PageLeft].visible = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_MC_PageRight].visible = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_TF_Page].visible = false;
         }
         else if(this.FTabIndex == 1)
         {
            this.UpdateUIInventorySamples();
            this.FSP_Hero.visible = false;
            this.FSP_Inventory.visible = true;
         }
         else
         {
            this.UpdateUIHeroItems();
            this.FSP_Hero.visible = true;
            this.FSP_Inventory.visible = false;
            this.FSP_Hero[CONST_COMMON.RESOURCE_Link_MC_PageLeft].visible = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_MC_PageRight].visible = this.FSP_Hero[CONST_COMMON.RESOURCE_Link_TF_Page].visible = true;
         }
         if(this.FTabIndex == 2)
         {
            this.FStoneFlag.gotoAndStop(2);
            this.FSP_Hero["MC_Bg"].gotoAndStop(this.FKnifePageIndex + 2);
            _loc2_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(CONST_GONGFUFIGHT.HellStoneID));
            this.FTF_Count.text = _loc2_.toString();
         }
         else
         {
            this.FStoneFlag.gotoAndStop(1);
            this.FSP_Hero["MC_Bg"].gotoAndStop(1);
            _loc2_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(CONST_GONGFUFIGHT.StoneID));
            this.FTF_Count.text = _loc2_.toString();
         }
         this.FUIHeroInfo.Visible = false;
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUIInventorySamples();
      }
      
      protected function KnifePageOnChange(param1:Object, param2:int) : void
      {
         this.FKnifePageIndex = param2;
         this.FSP_Hero["MC_Bg"].gotoAndStop(param2 + 2);
         this.UpdateUIHeroItems();
      }
      
      protected function UIInventorySampleOnClick(param1:Object, param2:TInventorySample) : void
      {
         var _loc3_:TPurchaseRequest = null;
         if(this.FOnPurchase != null)
         {
            _loc3_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
            _loc3_.IDTemplate = param2.Indentifier;
            this.FOnPurchase(this,_loc3_,this.FPurchaseParameters,param2);
         }
      }
      
      protected function UIHeroItemOnExchange(param1:Object, param2:TInventorySample) : void
      {
         this.ProcessorPurchase(param2);
      }
      
      protected function UIKnifeOnExchange(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorPurchase(this.FInventorySamples.GetInventorySampleByIndex(this.FKnifePageIndex));
      }
      
      protected function UIHeroItemOnHeroClick(param1:Object, param2:TInventorySample) : void
      {
         this.FUIHeroInfo.Context = param2;
         this.FUIHeroInfo.Visible = true;
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventorySample = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as TInventorySample;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.RoleModel) as TRoleModel;
         _loc9_ = CONST_ROLE.GetModelIDByIndex(_loc8_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function StoneFlagOnMove(param1:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_34);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function StoneFlagOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         this.Reset();
         if(!this.FInitialization)
         {
            return;
         }
         this.FBtn_Close.Dispose();
         this.FBtn_Close = null;
         this.FUIPage.Dispose();
         this.FUIPage = null;
         this.FUITabs.Dispose();
         this.FUITabs = null;
         this.FTF_Count = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Heros)
         {
            this.FUIHeroItems[_loc1_].Dispose();
            this.FUIHeroItems[_loc1_] = null;
            _loc1_++;
         }
         this.FUIHeroItems.length = 0;
         this.FUIHeroItems = null;
         this.FSP_Inventory = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            this.FUIStoneSamples[_loc1_].Dispose();
            this.FUIStoneSamples[_loc1_] = null;
            _loc1_++;
         }
         this.FUIStoneSamples.length = 0;
         this.FUIStoneSamples = null;
         this.FMC_EffectLeft = null;
         this.FMC_EffectRight = null;
         this.FMC_EffectLeftTop = null;
         this.FMC_EffectRightTop = null;
         this.FInventorySamples = null;
         this.FRolesModelID = null;
         this.FUIHeroInfo.Dispose();
         this.FUIHeroInfo = null;
         if(this.FSP_StoneShop.parent != null)
         {
            this.FSP_StoneShop.parent.removeChild(this.FSP_StoneShop);
         }
         this.FSP_StoneShop = null;
         this.FInitialization = false;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            this.FUIStoneSamples[_loc1_].Context = null;
            this.FUIStoneSamples[_loc1_].Visible = false;
            _loc1_++;
         }
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            SResourcesCore.TexturesModel.DeleteByIdentifier(this.FRolesModelID[_loc1_],true);
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         this.FTF_Count.text = "";
         this.FInventorySamples.Clear();
         this.FMC_EffectLeft.stop();
         this.FMC_EffectRight.stop();
         if(this.FMC_EffectLeftTop != null)
         {
            this.FMC_EffectLeftTop.stop();
         }
         if(this.FMC_EffectRightTop != null)
         {
            this.FMC_EffectRightTop.stop();
         }
         this.FSP_Hero.visible = true;
         this.FUIHeroInfo.Visible = false;
         this.FSP_Inventory.visible = false;
      }
      
      public function Update() : void
      {
         this.ProcessorUpdateCommon();
         this.ProcessorResize();
      }
   }
}

