package Processors.Game.Lobby.Activity.HDActivityGiftBag.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIActivityGBCurAwardList extends TUIComponent
   {
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC:Sprite;
      
      protected var FMC_BtnOK:MovieClip;
      
      protected var FMC_AlreadyGet:MovieClip;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_SlotVect:Vector.<Sprite>;
      
      protected var FSlotVect:Vector.<TUISlot>;
      
      protected var FPromptVect:Vector.<TextField>;
      
      protected var FSlotCount:uint;
      
      protected var FPromptCount:uint;
      
      protected var FAwardBoxStatus:int;
      
      protected var FBoxIndex:uint;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      public function TUIActivityGBCurAwardList(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         this.FMC = param1;
         if(param2)
         {
            addChild(this.FMC);
         }
         _loc4_ = int(this.FSlotCount);
         this.FMC_SlotVect = new Vector.<Sprite>(_loc4_);
         this.FSlotVect = new Vector.<TUISlot>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FMC_SlotVect[_loc3_] = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc3_];
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC_SlotVect[_loc3_][CONST_ACTIVITY.RESOURCE_Link_MC_SlotElement];
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnQuerySequenceContext = this.FOnQuerySequenceContext;
            _loc5_.OnOver = this.FOnSlotOver;
            _loc5_.OnOut = this.FOnSlotOut;
            _loc5_.OnQuerySubscript = this.FOnQuerySubscript;
            _loc5_.Init();
            this.FSlotVect[_loc3_] = _loc5_;
            this.FSlotVect[_loc3_].Visible = false;
            _loc3_++;
         }
         _loc4_ = int(this.FPromptCount);
         this.FPromptVect = new Vector.<TextField>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FPromptVect[_loc3_] = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + _loc3_];
            this.FPromptVect[_loc3_].htmlText = "";
            _loc3_++;
         }
         this.FMC_BtnOK = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FMC_AlreadyGet = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         if(this.FMC_BtnOK != null)
         {
            this.FBtn_OK = new TUIButton();
            this.FBtn_OK.Substrate = this.FMC_BtnOK;
            this.FBtn_OK.OnClick = this.BtnOKOnClick;
            this.FBtn_OK.Visible = false;
         }
         if(this.FMC_AlreadyGet != null)
         {
            this.FMC_AlreadyGet.visible = false;
         }
      }
      
      protected function UpdateUI(param1:TInventories = null, param2:Vector.<String> = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != null)
         {
            _loc4_ = int(this.FSlotCount);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc3_ < param1.Count)
               {
                  this.FSlotVect[_loc3_].Context = param1.GetInventoryByIndex(_loc3_);
                  this.FMC_SlotVect[_loc3_]["TF_Name"].text = param1.GetInventoryByIndex(_loc3_).Name;
                  this.FSlotVect[_loc3_].Visible = true;
               }
               else
               {
                  this.FMC_SlotVect[_loc3_]["TF_Name"].text = "";
                  this.FSlotVect[_loc3_].Visible = false;
               }
               _loc3_++;
            }
         }
         if(param2 != null)
         {
            _loc4_ = int(this.FPromptCount);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FPromptVect[_loc3_].htmlText = param2[_loc3_];
               _loc3_++;
            }
         }
      }
      
      protected function UpdateBtn() : void
      {
         if(this.FBtn_OK == null)
         {
            return;
         }
         switch(this.FAwardBoxStatus)
         {
            case Activity_CanNotReceive:
               this.FBtn_OK.Visible = true;
               this.FBtn_OK.Enabled = false;
               this.FMC_AlreadyGet.visible = false;
               break;
            case Activity_CanReceive:
               this.FBtn_OK.Visible = true;
               this.FBtn_OK.Enabled = true;
               this.FMC_AlreadyGet.visible = false;
               break;
            case Activity_AlreadyReceive:
               this.FBtn_OK.Visible = false;
               this.FMC_AlreadyGet.visible = true;
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FSlotVect.length <= 0)
         {
            return;
         }
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_OK.Enabled = false;
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(this,this.FBoxIndex);
         }
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function get OnHintOver() : Function
      {
         return this.FOnHintOver;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function get OnHintOut() : Function
      {
         return this.FOnHintOut;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite, param2:uint, param3:uint, param4:Boolean = true) : void
      {
         this.FSlotCount = param2;
         this.FPromptCount = param3;
         this.Resources_UIDispatch(param1,param4);
      }
      
      public function UpDateUI(param1:uint, param2:TInventories = null, param3:Vector.<String> = null) : void
      {
         this.FBoxIndex = param1;
         this.UpdateUI(param2,param3);
      }
      
      public function UpDateBtn(param1:int) : void
      {
         this.FAwardBoxStatus = param1;
         this.UpdateBtn();
      }
      
      public function UpDateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

