package Processors.Game.Lobby.TokenShop
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
   import Logics.GongFuFight.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TokenShop.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTokenShop extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_Page_InventorySamples:uint = CONST_GONGFUFIGHT.CAPACITY_Page_InventorySamples;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FSP_TokenShop:Sprite;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FUIPage:TUIPage;
      
      protected var FTF_Count:TextField;
      
      protected var FTokenFlag:Sprite;
      
      protected var FHint:THint;
      
      protected var FUITokenSamples:Vector.<TUITokenSample>;
      
      protected var FMC_EffectLeft:MovieClip;
      
      protected var FMC_EffectRight:MovieClip;
      
      protected var FMC_EffectLeftTop:MovieClip;
      
      protected var FMC_EffectRightTop:MovieClip;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      protected var FInventorySamples:TInventorySamples;
      
      protected var FPageIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorWindowTokenShop(param1:TUIComponent)
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
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GONGFUFIGHT.RESOURCESID_GongFuFight_TokenShop);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TUITokenSample = null;
         this.FInventorySamples = new TInventorySamples();
         this.FSP_TokenShop = TUtilityReflection.CreateDisplayObjectInstance(CONST_GONGFUFIGHT.RESOURCE_ClassName_SP_GongFuFight_TokenShop) as Sprite;
         addChild(this.FSP_TokenShop);
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FSP_TokenShop[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.ButtonCloseOnClick;
         this.FMC_EffectLeft = this.FSP_TokenShop[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectLeft];
         this.FMC_EffectRight = this.FSP_TokenShop[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectRight];
         this.FMC_EffectLeft.stop();
         this.FMC_EffectRight.stop();
         this.FTokenFlag = this.FSP_TokenShop["MC_Star"];
         this.FTokenFlag.addEventListener(MouseEvent.MOUSE_MOVE,this.TokenFlagOnMove);
         this.FTokenFlag.addEventListener(MouseEvent.MOUSE_OUT,this.TokenFlagOnOut);
         this.FHint = new THint();
         this.FTF_Count = this.FSP_TokenShop["TF_Count"];
         this.FUIPage = new TUIPage(null);
         this.FUIPage.ButtonPrevious.Substrate = this.FSP_TokenShop[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FSP_TokenShop[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPage.LabelPage = this.FSP_TokenShop[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage.text = "0/0";
         this.FUIPage.PageSize = CAPACITY_Page_InventorySamples;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FUITokenSamples = new Vector.<TUITokenSample>(CAPACITY_Page_InventorySamples);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            _loc3_ = new TUITokenSample(this);
            _loc3_.Resource = this.FSP_TokenShop["SP_Item_" + _loc1_];
            _loc3_.OnExchange = this.UIInventorySampleOnExchange;
            _loc3_.OnSlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnSlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.Perform_UIDispatch();
            this.FUITokenSamples[_loc1_] = _loc3_;
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
                  this.FUITokenSamples[_loc1_].Update();
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
         _loc1_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(CONST_GONGFUFIGHT.TokenID));
         this.FTF_Count.text = _loc1_.toString();
         this.ProcessorFilterInventorySamples();
         this.FMC_EffectLeft.play();
         this.FMC_EffectRight.play();
      }
      
      protected function ProcessorFilterInventorySamples() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventorySamples = null;
         var _loc4_:TInventorySample = null;
         this.FInventorySamples.Clear();
         _loc3_ = SLogicsCore.Character.InventorySamples;
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_.GetInventorySampleByIndex(_loc1_);
            if(_loc4_.Model == CONST_MALL.TYPE_MODEL_TOKENSHOP)
            {
               this.FInventorySamples.Add(_loc4_);
            }
            _loc1_++;
         }
      }
      
      public function UpdateUIInventorySample() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventorySample = null;
         var _loc6_:TUITokenSample = null;
         _loc4_ = this.FPageIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            _loc6_ = this.FUITokenSamples[_loc1_];
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
            _loc6_ = this.FUITokenSamples[_loc1_];
            _loc6_.Context = _loc5_;
            _loc6_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
         this.ProcessorUpdateCommon();
         this.UpdateUIInventorySample();
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
         ProcessorWindowClose();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUIInventorySample();
      }
      
      protected function UIInventorySampleOnExchange(param1:Object, param2:TInventorySample) : void
      {
         var _loc3_:TPurchaseRequest = null;
         _loc3_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc3_.IDTemplate = param2.Indentifier;
         _loc3_.Quantity = 1;
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(this,_loc3_,this.FPurchaseParameters);
         }
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
      
      protected function TokenFlagOnMove(param1:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_33);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function TokenFlagOnOut(param1:MouseEvent) : void
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
         this.FTF_Count = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            this.FUITokenSamples[_loc1_].Dispose();
            this.FUITokenSamples[_loc1_] = null;
            _loc1_++;
         }
         this.FUITokenSamples.length = 0;
         this.FUITokenSamples = null;
         this.FMC_EffectLeft = null;
         this.FMC_EffectRight = null;
         this.FMC_EffectLeftTop = null;
         this.FMC_EffectRightTop = null;
         this.FInventorySamples = null;
         if(this.FSP_TokenShop.parent != null)
         {
            this.FSP_TokenShop.parent.removeChild(this.FSP_TokenShop);
         }
         this.FSP_TokenShop = null;
         this.FInitialization = false;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_InventorySamples)
         {
            this.FUITokenSamples[_loc1_].Context = null;
            this.FUITokenSamples[_loc1_].Visible = false;
            _loc1_++;
         }
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
         this.FTF_Count.text = "";
      }
      
      public function Update() : void
      {
         this.ProcessorUpdateCommon();
         this.UpdateUIInventorySample();
         this.ProcessorResize();
      }
   }
}

