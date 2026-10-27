package Processors.Game.Lobby.Activity.HDActivitySuperTreasure.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TUIActivitySingleAwardTypeA extends TUIComponent
   {
      
      protected static const COUNT_TF_Award:uint = 6;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FMC_Main:Sprite;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Price:TextField;
      
      protected var FTF_AwardList:Vector.<TextField>;
      
      protected var FTF_CanBuyCount:TextField;
      
      protected var FMC_BtnOK:MovieClip;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FBoxIndex:uint;
      
      protected var FAwardBoxStatus:int;
      
      protected var FTextFormat:TextFormat;
      
      protected var FOnBtnOkClick:Function;
      
      public function TUIActivitySingleAwardTypeA(param1:TUIComponent)
      {
         super(param1);
         this.FTextFormat = new TextFormat();
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TextField = null;
         this.FMC_Main = param1;
         this.FTF_Name = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
         this.FTF_Name.mouseEnabled = false;
         this.FTF_Price = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_TF_Price];
         this.FTF_Price.mouseEnabled = false;
         _loc4_ = int(COUNT_TF_Award);
         this.FTF_AwardList = new Vector.<TextField>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_TF_AwardName + _loc3_];
            _loc5_.mouseEnabled = false;
            _loc5_.text = "";
            this.FTF_AwardList[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.FTF_CanBuyCount = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_TF_CanBuyCount];
         this.FTF_CanBuyCount.mouseEnabled = false;
         this.FMC_AlreadyGet = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FMC_AlreadyGet.mouseChildren = false;
         this.FMC_AlreadyGet.mouseEnabled = false;
         this.FMC_AlreadyGet.visible = false;
         this.FMC_BtnOK = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMC_BtnOK;
         this.FBtn_OK.OnClick = this.BtnOkOnClick;
         this.FBtn_OK.Enabled = false;
      }
      
      protected function UpdateConfigUI(param1:String, param2:TInventories, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         if(param2 != null)
         {
            _loc5_ = int(COUNT_TF_Award);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc4_ < param2.Count)
               {
                  _loc6_ = param2.GetInventoryByIndex(_loc4_);
                  this.FTF_AwardList[_loc4_].text = _loc6_.Name + "*" + _loc6_.Quantity;
                  this.FTextFormat.color = QUALITYCOLOR_INDEX[_loc6_.Quality];
                  this.FTF_AwardList[_loc4_].setTextFormat(this.FTextFormat);
               }
               else
               {
                  this.FTF_AwardList[_loc4_].text = "";
               }
               _loc4_++;
            }
         }
         this.FTF_Name.text = param1;
         this.FTF_Price.text = param3.toString();
      }
      
      protected function UpdateUI(param1:String) : void
      {
         this.FTF_CanBuyCount.text = param1;
      }
      
      protected function UpdateBtn() : void
      {
         if(this.FAwardBoxStatus == Activity_CanNotReceive)
         {
            this.FBtn_OK.Enabled = false;
            this.FBtn_OK.Visible = true;
            this.FMC_AlreadyGet.visible = false;
         }
         else if(this.FAwardBoxStatus == Activity_AlreadyReceive)
         {
            this.FBtn_OK.Enabled = false;
            this.FBtn_OK.Visible = false;
            this.FMC_AlreadyGet.visible = true;
         }
         else if(this.FAwardBoxStatus >= Activity_CanReceive)
         {
            this.FBtn_OK.Enabled = true;
            this.FBtn_OK.Visible = true;
            this.FMC_AlreadyGet.visible = false;
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FTF_AwardList != null)
         {
            _loc2_ = int(this.FTF_AwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTF_AwardList[_loc1_].text = "";
               _loc1_++;
            }
         }
         if(this.FTF_Name != null)
         {
            this.FTF_Name.text = "";
         }
         if(this.FTF_Price != null)
         {
            this.FTF_Price.text = "";
         }
         if(this.FTF_CanBuyCount != null)
         {
            this.FTF_CanBuyCount.text = "";
         }
      }
      
      protected function BtnOkOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_OK.Enabled = false;
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(this,this.FBoxIndex);
         }
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         this.Resources_UIDispatch(param1,param2);
      }
      
      public function ProcessorUpdateConfigUI(param1:uint, param2:String, param3:TInventories, param4:uint) : void
      {
         this.FBoxIndex = param1;
         this.UpdateConfigUI(param2,param3,param4);
      }
      
      public function ProcessorUpdateUI(param1:String) : void
      {
         this.UpdateUI(param1);
      }
      
      public function ProcessorUpdateBtn(param1:int) : void
      {
         this.FAwardBoxStatus = param1;
         this.UpdateBtn();
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

