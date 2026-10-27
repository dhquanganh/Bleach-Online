package Processors.Game.Lobby.Activity.HDServerPay.Window
{
   import Components.ScrollBar.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDServerPay.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowSPExchangeShop extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_TF_Item:uint = 1;
      
      protected static const COUNT_SLOT_Item:uint = 5;
      
      protected var FTF_CurScore:TextField;
      
      protected var FUIScrollBar:TScrollBar;
      
      protected var FTF_ShopDesc:TextField;
      
      protected var FMC_ShopItems:Vector.<TUIActivityOSAwardList>;
      
      protected var FData_ServerPay:TActivityServerPay;
      
      protected var FHD_ServerPay:THDServerPay;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsInitData:Boolean;
      
      protected var FOnWindowClose:Function;
      
      public function TProcessorHDWindowSPExchangeShop(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleServerPayShop;
         this.FIsInitWindow = false;
         this.FMC_ShopItems = new Vector.<TUIActivityOSAwardList>();
         this.FIsInitData = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitData)
         {
            return;
         }
         _loc2_ = int(this.FMC_ShopItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_ShopItems[_loc1_].UpDateSlot();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         super.InitWindow(param1);
         this.FTF_CurScore = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurScore];
         this.FTF_CurScore.mouseEnabled = false;
         this.FTF_ShopDesc = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_ShopDesc];
         this.FTF_ShopDesc.mouseEnabled = false;
         _loc2_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List];
         this.FUIScrollBar = new TScrollBar(_loc2_,288,false,-5,75);
         this.FUIScrollBar.Visible = false;
         this.FIsInitWindow = true;
         this.ResetTextField();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_ServerPay = FHDActivityConfig as THDServerPay;
         _loc2_ = int(this.FMC_ShopItems.length);
         this.FUIScrollBar.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_ShopItems[_loc1_] = null;
            _loc1_++;
         }
         this.FMC_ShopItems.length = 0;
         _loc2_ = int(this.FHD_ServerPay.ExchangeShops.length);
         _loc5_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_Link_MC_SPShopElement) as Sprite;
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.OnBtnOkClick = this.AwardItemOnClick;
            _loc4_.Perform_UIDispatch(_loc3_,COUNT_TF_Item,COUNT_SLOT_Item);
            this.FMC_ShopItems.push(_loc4_);
            this.FUIScrollBar.AddItem(_loc4_);
            _loc5_[_loc1_] = this.FHD_ServerPay.ExchangeShops[_loc1_].Awards[0];
            _loc1_++;
         }
         this.FUIScrollBar.ScrollToUp();
         this.FUIScrollBar.Visible = true;
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc5_);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FData_ServerPay = param1 as TActivityServerPay;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:TActivitySPExchangeShop = null;
         var _loc5_:Vector.<String> = null;
         super.UpdateUI();
         this.FTF_CurScore.text = this.FData_ServerPay.CurScore.toString();
         this.FTF_ShopDesc.text = this.FHD_ServerPay.ExchangeDesc;
         _loc2_ = int(this.FMC_ShopItems.length);
         _loc5_ = new Vector.<String>(COUNT_TF_Item);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_ShopItems[_loc1_];
            _loc4_ = this.FData_ServerPay.GetExchangeByIndex(_loc1_);
            _loc5_[0] = TUtilityString.Format(this.FHD_ServerPay.Prompts.PromptScore,_loc4_.Condition);
            _loc3_.UpDateUI(_loc4_.Index,FInventoriesVect[_loc1_],_loc5_);
            _loc3_.UpDateBtn(_loc4_.Status);
            _loc1_++;
         }
         this.FIsInitData = true;
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         _loc2_ = int(this.FMC_ShopItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_ShopItems[_loc1_].Clear();
            _loc1_++;
         }
         this.ResetTextField();
         this.FIsInitData = false;
      }
      
      protected function ResetTextField() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FTF_CurScore.text = "";
         this.FTF_ShopDesc.text = "";
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(this.FOnWindowClose != null)
         {
            this.FOnWindowClose(CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Main);
         }
      }
      
      protected function AwardItemOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      public function get OnWindowClose() : Function
      {
         return this.FOnWindowClose;
      }
      
      public function set OnWindowClose(param1:Function) : void
      {
         this.FOnWindowClose = param1;
      }
   }
}

