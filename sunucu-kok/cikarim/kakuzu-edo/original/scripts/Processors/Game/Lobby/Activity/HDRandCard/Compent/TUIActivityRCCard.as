package Processors.Game.Lobby.Activity.HDRandCard.Compent
{
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDRandCard.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIActivityRCCard extends TUIComponent
   {
      
      protected static const COUNT_SLOT_Award:uint = 1;
      
      protected static const COUNT_TF_Award:uint = 1;
      
      protected static const FRAME_Start:uint = 1;
      
      protected static const FRAME_ShowCard:uint = 8;
      
      protected static const FRAME_HideCard:uint = 20;
      
      protected static const FRAMENAME_Show:String = "Frame_Show";
      
      protected static const FRAMENAME_Hide:String = "Frame_Hide";
      
      protected static const TYPE_RC_Gold:uint = CONST_ACTIVITY_MODE.TYPE_RC_Gold;
      
      protected static const TYPE_RC_Super:uint = CONST_ACTIVITY_MODE.TYPE_RC_Super;
      
      protected static const STATE_RC_Begin:uint = CONST_ACTIVITY_MODE.STATE_RC_Begin;
      
      protected static const STATE_RC_ShowCard:uint = CONST_ACTIVITY_MODE.STATE_RC_ShowCard;
      
      protected static const STATE_RC_WaitChoose:uint = CONST_ACTIVITY_MODE.STATE_RC_WaitChoose;
      
      protected var FMC_Scene:MovieClip;
      
      protected var FSP_Select:Sprite;
      
      protected var FMC_Award:TUIActivityOSAwardList;
      
      protected var FTF_DeletePrompt:TextField;
      
      protected var FSP_Award:Sprite;
      
      protected var FData_AwardCard:TActivityRCAwardCard;
      
      protected var FHD_RandCard:THDRandCard;
      
      protected var FCurType:uint;
      
      protected var FCurFrameState:uint;
      
      protected var FIsInitData:Boolean;
      
      protected var FIsInitComponent:Boolean;
      
      protected var FInventories:TInventories;
      
      protected var FIndex:int;
      
      protected var FAwardCardOnClick:Function;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FQueryOnSubscript:Function;
      
      protected var FQueryOnSequenceContext:Function;
      
      public function TUIActivityRCCard(param1:TUIComponent)
      {
         super(param1);
         this.FCurFrameState = STATE_RC_Begin;
         this.FCurType = TYPE_RC_Gold;
         this.FIsInitData = false;
         this.FIsInitComponent = false;
      }
      
      protected function ProcessorLogicsPerform() : void
      {
         if(!this.FIsInitComponent)
         {
            return;
         }
         if(this.FIsInitData)
         {
            this.FMC_Award.UpDateSlot();
         }
         if(this.FMC_Scene.currentFrame == FRAME_ShowCard)
         {
            this.FMC_Award.Visible = false;
         }
         else
         {
            this.FMC_Award.Visible = false;
         }
      }
      
      protected function Resources_UIDispatch(param1:TUIComponent, param2:MovieClip) : void
      {
         this.FMC_Scene = param2;
         this.FMC_Scene.addEventListener(MouseEvent.CLICK,this.SceneOnClick);
         this.FMC_Scene.addEventListener(MouseEvent.MOUSE_MOVE,this.SceneOnOver);
         this.FMC_Scene.addEventListener(MouseEvent.MOUSE_OUT,this.SceneOnOut);
         this.FMC_Scene.gotoAndStop(1);
         this.FSP_Select = this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_SelectElement];
         this.FSP_Select.mouseChildren = false;
         this.FSP_Select.mouseEnabled = false;
         this.FSP_Select.visible = false;
         this.FTF_DeletePrompt = this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_TF_PromptDelete];
         this.FTF_DeletePrompt.mouseEnabled = false;
         this.FTF_DeletePrompt.visible = false;
         this.FMC_Award = new TUIActivityOSAwardList(this);
         this.FMC_Award.OnSlotOver = this.ProcessorOnSlotOver;
         this.FMC_Award.OnSlotOut = this.ProcessorOnSlotOut;
         this.FMC_Award.OnQuerySubscript = this.FQueryOnSubscript;
         this.FMC_Award.OnQuerySequenceContext = this.FQueryOnSequenceContext;
         this.FMC_Award.Perform_UIDispatch(this.FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award],COUNT_TF_Award,COUNT_SLOT_Award,false);
         this.FMC_Award.Visible = false;
         this.FIsInitComponent = true;
      }
      
      protected function ProcessorShow() : void
      {
         var _loc1_:Vector.<String> = null;
         _loc1_ = new Vector.<String>(COUNT_TF_Award);
         _loc1_[0] = this.FInventories.GetInventoryByIndex(0).Name;
         this.FMC_Award.UpDateUI(this.FData_AwardCard.Index,this.FInventories,_loc1_);
         this.FMC_Award.Visible = true;
         this.FTF_DeletePrompt.text = "";
         this.FIsInitData = true;
      }
      
      protected function ProcessorUpdateUI() : void
      {
         var _loc1_:Vector.<String> = null;
         _loc1_ = new Vector.<String>(COUNT_TF_Award);
         _loc1_[0] = this.FInventories.GetInventoryByIndex(0).Name;
         this.FTF_DeletePrompt.visible = false;
         this.FSP_Select.visible = false;
         this.FMC_Award.Visible = false;
         switch(this.FCurFrameState)
         {
            case STATE_RC_Begin:
               if(this.FCurType == TYPE_RC_Gold)
               {
                  if(this.FData_AwardCard.IsDelete)
                  {
                     this.FTF_DeletePrompt.text = this.FHD_RandCard.Prompts.Prompt5;
                  }
                  else
                  {
                     this.FTF_DeletePrompt.text = this.FHD_RandCard.Prompts.Prompt4;
                  }
                  this.FTF_DeletePrompt.visible = true;
               }
               if(this.FData_AwardCard.IsDelete)
               {
                  this.FMC_Scene.gotoAndStop(FRAME_HideCard);
               }
               else
               {
                  this.FMC_Scene.gotoAndStop(FRAME_ShowCard);
               }
               this.FMC_Award.UpDateUI(this.FData_AwardCard.Index,this.FInventories,_loc1_);
               this.FMC_Award.Visible = true;
               break;
            case STATE_RC_WaitChoose:
               if(this.FCurType == TYPE_RC_Super && this.FIndex == 4)
               {
                  this.FMC_Scene.gotoAndStop(FRAME_ShowCard);
                  return;
               }
               this.FMC_Scene.gotoAndStop(FRAME_HideCard);
               if(this.FData_AwardCard.IsSelect)
               {
                  this.FSP_Select.visible = true;
               }
               if(this.FData_AwardCard.IsDelete)
               {
                  this.FTF_DeletePrompt.text = this.FHD_RandCard.Prompts.Prompt5;
                  this.FTF_DeletePrompt.visible = true;
               }
               break;
            case STATE_RC_ShowCard:
               if(this.FCurType == TYPE_RC_Gold)
               {
                  if(this.FData_AwardCard.IsDelete)
                  {
                     this.FTF_DeletePrompt.text = this.FHD_RandCard.Prompts.Prompt4;
                     this.FTF_DeletePrompt.visible = true;
                  }
               }
               if(this.FData_AwardCard.IsSelect)
               {
                  this.FSP_Select.visible = true;
                  this.FMC_Award.UpDateUI(this.FData_AwardCard.Index,this.FInventories,_loc1_);
                  this.FMC_Award.Visible = true;
               }
               if(this.FData_AwardCard.IsSelect)
               {
                  this.FMC_Scene.gotoAndStop(FRAME_ShowCard);
               }
               this.ProcessorShow();
         }
      }
      
      protected function Reset() : void
      {
         if(!this.FIsInitComponent)
         {
            return;
         }
         this.FTF_DeletePrompt.text = "";
         this.FMC_Award.Clear();
      }
      
      protected function SceneOnClick(param1:MouseEvent) : void
      {
         if(this.FAwardCardOnClick != null)
         {
            this.FAwardCardOnClick(this.FIndex);
         }
      }
      
      protected function SceneOnOver(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = true;
      }
      
      protected function SceneOnOut(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = false;
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FCurFrameState != FRAME_ShowCard && this.FCurFrameState != 0)
         {
            return;
         }
         if(this.FSlotOnOver != null)
         {
            this.FSlotOnOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FCurFrameState != FRAME_ShowCard && this.FCurFrameState != 0)
         {
            return;
         }
         if(this.FSlotOnOut != null)
         {
            this.FSlotOnOut(param1,param2);
         }
      }
      
      public function get SlotOnOver() : Function
      {
         return this.FSlotOnOver;
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function get SlotOnOut() : Function
      {
         return this.FSlotOnOut;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function get QueryOnSubscript() : Function
      {
         return this.FQueryOnSubscript;
      }
      
      public function set QueryOnSubscript(param1:Function) : void
      {
         this.FQueryOnSubscript = param1;
      }
      
      public function get QueryOnSequenceContext() : Function
      {
         return this.FQueryOnSequenceContext;
      }
      
      public function set QueryOnSequenceContext(param1:Function) : void
      {
         this.FQueryOnSequenceContext = param1;
      }
      
      public function get AwardCardOnClick() : Function
      {
         return this.FAwardCardOnClick;
      }
      
      public function set AwardCardOnClick(param1:Function) : void
      {
         this.FAwardCardOnClick = param1;
      }
      
      public function Show(param1:int, param2:TActivityRCAwardCard, param3:THDRandCard, param4:TInventories) : void
      {
         this.FIndex = param1;
         this.FData_AwardCard = param2;
         this.FHD_RandCard = param3;
         this.FInventories = param4;
         if(!this.FIsInitComponent)
         {
            return;
         }
         this.ProcessorShow();
      }
      
      public function Hide() : void
      {
         if(this.FIsInitComponent)
         {
            this.Reset();
         }
      }
      
      public function Perform_UIDispatch(param1:TUIComponent, param2:MovieClip, param3:uint) : void
      {
         this.FCurType = param3;
         this.Resources_UIDispatch(param1,param2);
      }
      
      public function UpdateUI(param1:uint, param2:TActivityRCAwardCard, param3:TInventories = null) : void
      {
         this.FCurFrameState = param1;
         this.FData_AwardCard = param2;
         if(param3 != null)
         {
            this.FInventories = param3;
         }
         this.ProcessorUpdateUI();
      }
      
      public function LogicsPerform() : void
      {
         this.ProcessorLogicsPerform();
      }
   }
}

