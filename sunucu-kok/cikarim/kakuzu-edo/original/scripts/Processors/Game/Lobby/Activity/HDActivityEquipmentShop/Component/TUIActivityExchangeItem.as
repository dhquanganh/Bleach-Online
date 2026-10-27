package Processors.Game.Lobby.Activity.HDActivityEquipmentShop.Component
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
   
   public class TUIActivityExchangeItem extends TUIComponent
   {
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC:Sprite;
      
      protected var FMCPromptVect:Vector.<MovieClip>;
      
      protected var FUISlotVect:Vector.<TUISlot>;
      
      protected var FTFPromptVect:Vector.<TextField>;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FCountMC:uint;
      
      protected var FCountSlot:uint;
      
      protected var FCountTF:uint;
      
      protected var FBoxStatus:int;
      
      protected var FBoxIndex:int;
      
      protected var FInventories:TInventories;
      
      protected var FTextList:Vector.<String>;
      
      protected var FMCPlayVect:Vector.<int>;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnSlotsQueryEdgeColor:Function;
      
      public function TUIActivityExchangeItem(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         this.FMC = param1;
         if(param2)
         {
            addChild(this.FMC);
         }
         _loc4_ = int(this.FCountMC);
         this.FMCPromptVect = new Vector.<MovieClip>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc3_];
            _loc7_.gotoAndStop(1);
            _loc7_.visible = false;
            this.FMCPromptVect[_loc3_] = _loc7_;
            _loc3_++;
         }
         _loc4_ = int(this.FCountSlot);
         this.FUISlotVect = new Vector.<TUISlot>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc3_];
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc5_.OnQuerySequenceContext = this.FOnQuerySequenceContext;
            _loc5_.OnQueryEdgeColor = this.FOnSlotsQueryEdgeColor;
            _loc5_.OnOver = this.FOnSlotOver;
            _loc5_.OnOut = this.FOnSlotOut;
            _loc5_.OnQuerySubscript = this.FOnQuerySubscript;
            _loc5_.Init();
            this.FUISlotVect[_loc3_] = _loc5_;
            this.FUISlotVect[_loc3_].Visible = false;
            _loc3_++;
         }
         _loc4_ = int(this.FCountTF);
         this.FTFPromptVect = new Vector.<TextField>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + _loc3_];
            _loc6_.mouseEnabled = false;
            _loc6_.text = "";
            this.FTFPromptVect[_loc3_] = _loc6_;
            _loc3_++;
         }
         if(this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_OK] != null)
         {
            this.FBtn_OK = new TUIButton();
            this.FBtn_OK.Substrate = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
            this.FBtn_OK.OnClick = this.BtnOKOnClick;
            this.FBtn_OK.Visible = false;
         }
         this.FMC_AlreadyGet = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         if(this.FMC_AlreadyGet != null)
         {
            this.FMC_AlreadyGet.visible = false;
         }
      }
      
      protected function UpdateUI(param1:Vector.<String> = null, param2:Vector.<int> = null, param3:TInventories = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(this.FCountTF);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1 == null)
            {
               this.FTFPromptVect[_loc4_].text = "";
            }
            else
            {
               this.FTFPromptVect[_loc4_].text = param1[_loc4_];
            }
            _loc4_++;
         }
         _loc5_ = int(this.FCountMC);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param2 == null)
            {
               this.FMCPromptVect[_loc4_].visible = false;
            }
            else
            {
               this.FMCPromptVect[_loc4_].gotoAndStop(param2[_loc4_]);
               this.FMCPromptVect[_loc4_].visible = true;
            }
            _loc4_++;
         }
         _loc5_ = int(this.FCountSlot);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3 == null)
            {
               this.FUISlotVect[_loc4_].Context = null;
               this.FUISlotVect[_loc4_].Visible = false;
            }
            else
            {
               this.FUISlotVect[_loc4_].Context = param3.GetInventoryByIndex(_loc4_);
               this.FUISlotVect[_loc4_].Visible = true;
            }
            _loc4_++;
         }
      }
      
      protected function UpdateBtn() : void
      {
         if(this.FBtn_OK == null)
         {
            return;
         }
         if(this.FBoxStatus == Activity_CanNotReceive)
         {
            this.FBtn_OK.Visible = true;
            this.FBtn_OK.Enabled = false;
            if(this.FMC_AlreadyGet != null)
            {
               this.FMC_AlreadyGet.visible = false;
            }
         }
         else if(this.FBoxStatus >= Activity_CanReceive)
         {
            this.FBtn_OK.Visible = true;
            this.FBtn_OK.Enabled = true;
            if(this.FMC_AlreadyGet != null)
            {
               this.FMC_AlreadyGet.visible = false;
            }
         }
         else if(this.FBoxStatus == Activity_AlreadyReceive)
         {
            this.FBtn_OK.Visible = false;
            if(this.FMC_AlreadyGet != null)
            {
               this.FMC_AlreadyGet.visible = true;
            }
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FUISlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUISlotVect[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
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
      
      public function get OnSlotsQueryEdgeColor() : Function
      {
         return this.FOnSlotsQueryEdgeColor;
      }
      
      public function set OnSlotsQueryEdgeColor(param1:Function) : void
      {
         this.FOnSlotsQueryEdgeColor = param1;
      }
      
      public function Perform_UIDispatch(param1:int, param2:Sprite, param3:int = 0, param4:int = 0, param5:int = 0, param6:Boolean = false) : void
      {
         this.FBoxIndex = param1;
         this.FCountTF = param3;
         this.FCountMC = param4;
         this.FCountSlot = param5;
         this.Resources_UIDispatch(param2,param6);
      }
      
      public function UpDateUI(param1:uint, param2:TInventories = null, param3:Vector.<String> = null, param4:Vector.<int> = null) : void
      {
         this.FInventories = param2;
         this.FTextList = param3;
         this.FBoxIndex = param1;
         this.UpdateUI(param3,param4,this.FInventories);
      }
      
      public function UpDatePrompt(param1:Vector.<String>) : void
      {
         this.UpdateUI(param1,null,null);
      }
      
      public function UpDateBtn(param1:int) : void
      {
         this.FBoxStatus = param1;
         this.UpdateBtn();
      }
      
      public function UpDateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.Visible)
         {
            return;
         }
         _loc2_ = int(this.FUISlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUISlotVect[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
         this.FInventories = null;
         this.FTextList = null;
         this.FMCPlayVect = null;
      }
   }
}

