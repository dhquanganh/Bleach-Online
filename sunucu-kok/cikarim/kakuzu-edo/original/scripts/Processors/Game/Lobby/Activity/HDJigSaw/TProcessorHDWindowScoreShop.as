package Processors.Game.Lobby.Activity.HDJigSaw
{
   import Components.Pages.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDJigSaw.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowScoreShop extends TProcessorHDSingleWindowBase
   {
      
      protected static const LISTNUM:uint = 12;
      
      protected static const COUNT_TF_Award:uint = 1;
      
      protected static const COUNT_Slot_Award:uint = 1;
      
      protected var FTF_CurScore:TextField;
      
      protected var Fbtn_Left:MovieClip;
      
      protected var Fbtn_Right:MovieClip;
      
      protected var FTF_Page:TextField;
      
      protected var FMC_Item:Sprite;
      
      protected var FUI_ShopPage:TUIPage;
      
      protected var FData_JigSaw:TActivityJigSaw;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FHD_JigSaw:THDJigSaw;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FIsInitWindow:Boolean;
      
      public function TProcessorHDWindowScoreShop(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ScoreShop;
         this.FIsInitWindow = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardListVect[_loc1_].UpDateSlot();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.InitWindow(param1);
         this.FTF_CurScore = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurScore];
         this.FTF_CurScore.mouseEnabled = false;
         this.Fbtn_Left = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
         this.Fbtn_Right = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
         this.FTF_Page = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Page];
         this.FUI_ShopPage = new TUIPage(null);
         this.FUI_ShopPage.ButtonPrevious.Substrate = this.Fbtn_Left;
         this.FUI_ShopPage.ButtonNext.Substrate = this.Fbtn_Right;
         this.FUI_ShopPage.PageSize = LISTNUM;
         this.FUI_ShopPage.OnChangePage = this.PageOnChange;
         this.FUI_ShopPage.LabelPage = this.FTF_Page;
         this.FUI_ShopPage.Init();
         _loc3_ = int(LISTNUM);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(COUNT_Slot_Award);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardListVect[_loc2_] = new TUIActivityOSAwardList(this);
            this.FAwardListVect[_loc2_].OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            this.FAwardListVect[_loc2_].OnQuerySubscript = SlotsOnQuerySubscript;
            this.FAwardListVect[_loc2_].OnSlotOver = ProcessorOnSlotOver;
            this.FAwardListVect[_loc2_].OnSlotOut = ProcessorOnSlotOut;
            this.FAwardListVect[_loc2_].OnBtnOkClick = this.BtnOKOnClick;
            this.FAwardListVect[_loc2_].Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Items + _loc2_],COUNT_TF_Award,COUNT_Slot_Award,false);
            _loc2_++;
         }
         this.ResetTextFeild();
         this.FIsInitWindow = true;
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUI_ShopPage.TotalQuantity = this.FData_JigSaw.Buys.length;
         this.FUI_ShopPage.Update();
         this.FUI_ShopPage.PageIndex = FPageIndex;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_JigSaw = FHDActivityConfig as THDJigSaw;
         _loc1_ = this.FHD_JigSaw.BuysList.length;
         _loc3_ = new Vector.<uint>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_[_loc2_] = this.FHD_JigSaw.BuysList[_loc2_].Award;
            _loc2_++;
         }
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FData_JigSaw = param1 as TActivityJigSaw;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<String> = null;
         _loc4_ = new Vector.<String>(COUNT_TF_Award);
         _loc1_ = int(LISTNUM);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _loc2_ + FPageIndex * LISTNUM;
            if(_loc3_ < this.FData_JigSaw.Buys.length)
            {
               _loc4_[0] = this.FData_JigSaw.Buys[_loc3_].Value.toString();
               this.FAwardListVect[_loc2_].UpDateUI(this.FData_JigSaw.Buys[_loc3_].Index,this.FAwardInventories[_loc3_],_loc4_);
               if(this.FData_JigSaw.Score.Score < this.FData_JigSaw.Buys[_loc3_].Value)
               {
                  this.FAwardListVect[_loc2_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanNotReceive);
               }
               else
               {
                  this.FAwardListVect[_loc2_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
               }
               this.FAwardListVect[_loc2_].Visible = true;
            }
            else
            {
               _loc4_[0] = "";
               this.FAwardListVect[_loc2_].UpDatePrompt(_loc4_);
               this.FAwardListVect[_loc2_].Visible = false;
            }
            _loc2_++;
         }
         this.FTF_CurScore.text = this.FData_JigSaw.Score.Score.toString();
         this.UpdateUIPage();
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         FPageIndex = 0;
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardListVect[_loc1_].Clear();
            _loc1_++;
         }
         this.ResetTextFeild();
      }
      
      protected function ResetTextFeild() : void
      {
         this.FTF_CurScore.text = "";
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         FPageIndex = param2;
         this.UpdateUI();
      }
   }
}

